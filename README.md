# 草帽路飞 · 《土豆兄弟》Mod

戴上草帽，边跑边用橡胶手枪打怪。Mod 面向 Steam Windows 版《土豆兄弟》1.2.0.3 的单人模式，使用游戏内置的 ModLoader 6.3.0，基础游戏即可游玩。

[查看实战截图](workshop/gameplay.png)

[后续扩展架构](#后续扩展架构)

## 本地试玩

1. 下载 [StrawHat-Luffy-1.0.1.zip](dist/StrawHat-Luffy-1.0.1.zip)。更新时用它替换旧版 ZIP。
2. 在启用了本地 ZIP 的测试环境中，把 ZIP 原样放进与 Brotato.exe 同级的 `mods` 文件夹，或放进 `--mods-path` 指定的目录。通过 Steam 创意工坊试玩时，按下方流程上传并订阅条目。 [ModLoader 启动参数](https://wiki.godotmodding.com/guides/integration/cli_args/)
3. 启动游戏，在主菜单的 Mods 中确认 StrawHat-Luffy 已启用，开始单人新局。草帽路飞默认解锁，初始武器是 I 阶橡胶手枪。

## 玩法

- **草帽路飞**有 +20 范围、+8% 移速、−5 远程伤害。原版武器也可在局内购买。
- **橡胶手枪**是自动瞄准的长距离近战直拳，沿用原版拳头的出拳和收拳动作。吃 100% 近战伤害加成，命中带击退。两把同阶拳头可以合成下一阶。
- **草帽**是 II 阶道具，提供 +8% 闪避。
- **带骨肉**是 I 阶道具，提供 +6 最大生命值，捡到食物时额外回复 2 点生命。

三种专属装备会出现在路飞的商店中。两件道具也可从宝箱获得，能装下或合成武器时，宝箱有 15% 的机会掉落同阶橡胶手枪。草帽和带骨肉各最多持有一件。

| 橡胶手枪 | I | II | III | IV |
| --- | ---: | ---: | ---: | ---: |
| 基础伤害 | 8 | 15 | 28 | 52 |
| 基础范围 | 175 | 185 | 195 | 205 |

## 提交 Steam 创意工坊

1. 本地试玩后，准备 [Mod ZIP](dist/StrawHat-Luffy-1.0.1.zip) 和 [512 × 512 工坊封面](workshop/cover.png)。
2. 在 Steam 的游戏属性中打开「测试版」，选择 modding 分支。从 Steam 启动游戏时选择工坊上传器。
3. 在上传器选择 ZIP 和封面。首发时留空 Workshop ID。更新时填工坊页面网址里的条目 ID。
4. 上传后从 Steam 的创意工坊进入条目页面，填写下方标题和简介。Steam 默认隐藏新条目，可在页面上调整可见性。上传前按 Steam 协议确认所用内容的权利。 [工坊上传指南](https://steamcommunity.com/sharedfiles/filedetails/?id=2931079751) · [Steam 订户协议](https://store.steampowered.com/subscriber_agreement/)

**建议标题**

草帽路飞 · 橡胶手枪 | Straw Hat Luffy

**可复制的简介**

> Q 版草帽路飞来到了《土豆兄弟》！开局用橡胶手枪，拉开距离打出一记直拳。把拳头合到 IV 阶，再用草帽的闪避和带骨肉的回血撑过怪潮。
>
> 包含 1 个角色、1 把四阶专属武器和 2 件专属道具。支持简体中文和英文。适配 Steam Windows 版 1.2.0.3 单人模式，基础游戏即可游玩。

## 修改和打包

Mod 源码放在 mods-unpacked/StrawHat-Luffy。角色、道具和武器数值在 content 目录，透明 PNG 在 art 目录。使用 Python 3.10+ 和 Godot 3 编辑器打包，已使用 Godot 3.7 dev1 构建。 [Godot 3.7 dev1 下载](https://godotengine.org/download/archive/3.7-dev1/)

```powershell
python build.py --godot "C:\path\to\Godot_v3.7-dev1_win64.exe"
```

脚本将成品写到 dist。修改美术母图后，可用带 Pillow 的 Python 运行 artwork/prepare.py，重新输出游戏贴图和封面。素材母图由内置 ImageGen 生成并裁切成游戏贴图。 [美术母图](artwork/strawhat_atlas.png) · [完整提示词](artwork/imagegen-prompt.txt)

## 后续扩展架构

让新增角色、武器和道具走同一套流程。原版引擎负责选人、合成、属性结算和存档，Mod 提供内容、掉落归属和专属玩法。以 Steam Windows 1.2.0.3、ModLoader 6.3.0 的单人模式为首轮重构的验收基准。

### 现在改哪里

| 要改的内容 | 源码位置 |
| --- | --- |
| 路飞属性、角色图标和局内外观 | [content/luffy.tres](mods-unpacked/StrawHat-Luffy/content/luffy.tres) |
| 橡胶手枪每阶的伤害和范围 | [content/luffy_content.gd](mods-unpacked/StrawHat-Luffy/content/luffy_content.gd) 中的 `DAMAGE` 和 `REACH` |
| 道具属性、价格、阶级和持有上限 | [草帽](mods-unpacked/StrawHat-Luffy/content/straw_hat.tres) · [带骨肉](mods-unpacked/StrawHat-Luffy/content/bone_meat.tres) |
| 专属装备的商店和宝箱规则 | [extensions/item_service.gd](mods-unpacked/StrawHat-Luffy/extensions/item_service.gd) |
| 游戏里的简中和英文名称 | [mod_main.gd](mods-unpacked/StrawHat-Luffy/mod_main.gd) 中的 `NAMES` |

### 目标结构

下列路径相对于 `mods-unpacked/StrawHat-Luffy/`。从新增内容开始按类别归档，首轮重构用现有路径读取 1.0.0 的资源。 [ModLoader 目录规范](https://wiki.godotmodding.com/guides/modding/mod_structure/)

```text
mod_main.gd                 启动时安装游戏扩展、加载翻译
content/catalog.gd          登记角色、装备、起始武器和可获取者
content/characters/         新角色的 .tres 资源
content/weapons/            新武器按家族放 .tres、.tscn 和专属动画
content/items/              新道具的 .tres 资源
localization/text.gd        中文和英文名称、说明
extensions/item_service.gd  接入原版注册、商店和宝箱
art/                        游戏内使用的透明 PNG
```

- **内容登记**放在 `content/catalog.gd`。角色条目关联可选的起始武器，装备条目关联资源和 `owners`。通用装备显式登记 `owners = []`，专属装备列出对应的角色内部 ID。四阶武器共用一个家族 ID 和一份归属，单阶资源有各自的 ID。
- **游戏接入**由 `extensions/item_service.gd` 负责。沿用当前在读取存档和默认解锁前注册内容的时机，注册一次后刷新原版缓存。商店重抽和原版兜底都按角色限制专属装备。路飞的专属武器宝箱概率继续用 15%，命中后从同阶且能装备或合成的专属武器中等概率选一把。没有候选时，发放原版抽到的奖励。 [Godot 3 脚本扩展](https://wiki.godotmodding.com/guides/modding/script_extensions/)
- **玩法和美术**随所属内容存放。普通加属性道具直接复用原版效果。橡胶手枪的武器场景沿用原版拳头的动作和命中判定，使用自己的拳头贴图。新机制若有触发次数或持续时间，按玩家分别记录，在离开对局时清理。

### 逐步扩充

1. **先整理现有内容。** 把现有角色和装备接到登记表，把简中、英文文本从启动脚本抽出来。用 1.0.0 开一局，打到商店后退出，给重构后的版本验证续局。把 `StrawHat-Luffy`、1.0.0 的角色和装备内部 ID、存档引用的资源路径都作为兼容约定。游戏内显示名可以通过翻译调整。
2. **先加一件原创道具验证流程。** 以草帽资源为模板，填写新 `my_id`、翻译键、图标、阶级、价格、效果和持有上限。把 PNG 放进 `art/`，在登记表写明角色归属，在文本表补齐两种语言。原有打包脚本会递归导入新 PNG。
3. **再加一把武器和第二个角色。** 武器沿用 I–IV 阶合成，所有阶共用一个 `weapon_id`。角色用自己的资源登记属性、外观和起始武器。需要独特动作时，在该武器的场景里实现。
4. **有完整玩法需求时再接入战斗事件。** 击杀、拾取、波次事件只接给需要它的内容。先明确触发条件、持续时间和状态何时清除，再实现对应机制。

### 每次发版前

- 检查内部 ID 唯一、武器阶级链完整、角色归属正确，简中和英文都有对应文字。调整贴图路径前，先用旧存档确认该路径是否被保存。
- 用打好的 ZIP 测试选人、开局武器、商店、重抽、宝箱和续局。专属道具要同时用对应角色和原版角色测试。多把武器共享一个宝箱概率时，验证每个候选都能出现，武器栏满了时仍能获得有效奖励。
- 小修或数值调整递增补丁版本，扩充内容递增次版本。打包使用 `manifest.json` 的 `version_number`。更新已发布条目时沿用原 Workshop ID，并在发布说明里记录实测过的游戏版本。
