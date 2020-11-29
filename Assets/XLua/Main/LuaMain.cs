/*
 * Tencent is pleased to support the open source community by making xLua available.
 * Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
*/

using UnityEngine;
using System.Collections;
using XLua;
using System.IO;

namespace Tutorial
{
    public class LuaMain : MonoBehaviour
    {
        string LUA_PATH;
        LuaEnv luaenv = null;
        LuaFunction awaken_;
        LuaFunction update_;
        LuaFunction lateupdate_;
        LuaFunction fixupdate_;
        LuaFunction ondestroy_;

        private void Awake()    
        {
            LUA_PATH = Application.dataPath.Substring(0, Application.dataPath.Length - 6);
            luaenv = new LuaEnv();
            luaenv.AddLoader((ref string path)
                => {
                    string filepath = $"{LUA_PATH}/Lua/{path}.lua";
                    if (File.Exists(filepath))
                        return File.ReadAllBytes(filepath);
                    return null;
                });
            luaenv.DoString("require 'main'");

            LuaTable lua_script = luaenv.Global.Get<LuaTable>("luascript");
            if (lua_script != null)
            {
                awaken_ = lua_script.Get<LuaFunction>("Awaken");
                update_ = lua_script.Get<LuaFunction>("Update");
                lateupdate_ = lua_script.Get<LuaFunction>("LateUpdate");
                fixupdate_ = lua_script.Get<LuaFunction>("FixUpdate");
                ondestroy_ = lua_script.Get<LuaFunction>("OnDestroy");
            }

            if (awaken_ != null)
                awaken_.Call();
        }


        // Update is called once per frame
        void Update()
        {
            if (luaenv != null)
            {
                luaenv.Tick();
            }
            if (update_ != null)
                update_.Call();
        }

        private void LateUpdate()
        {
            if (lateupdate_ != null)
                lateupdate_.Call();
        }

        private void FixedUpdate()
        {
            if (fixupdate_ != null)
                fixupdate_.Call();
        }

        void OnDestroy()
        {
            if (ondestroy_ != null)
                ondestroy_.Call();

            luaenv.Dispose();
        }
    }
}
