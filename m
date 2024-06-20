Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2092.outbound.protection.outlook.com [40.92.53.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C595C40858;
	Thu, 20 Jun 2024 08:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.53.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718873488; cv=fail; b=tuEzLjbOw7MPUchcNvvsUhO24DnL2wZD3YujzEJrt2IFqmJb9tdRREs/TqJFSrAoF5FZrfVCih0J3kmKSzo7bVVycH7IkTBFVZAjXWyVUq1+YKeILJAAuhQjf2haPBrg08qvLLAbjBm3K1XmHtaNQlPbz7cyow3m7DmqVCWEzcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718873488; c=relaxed/simple;
	bh=NwoOQgsH7togAnKtvrNaYGEAboE/sTcbm1JjLHHSx9I=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=TLG4GNmq9Zd+XCwkQ+lnsfp47OXbB6Q0CnpTz8jrdSzr/p75iOb112tEuwJE3dVRR+ly1KTFz/ANc0NqKM5S+V8HyF/IhSlEdtiJejfpABe2QSucxo37+b4Zbfc6BRHbplOYm8uPbttvmiNEqux6aaBG8+bAzJCE279b5AyrK+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=HmBlszHA; arc=fail smtp.client-ip=40.92.53.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="HmBlszHA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwphcPS6dx5vzeZHja0d3NstX7n8TxhM68uy3+B/2j1Dqv5ZfS+cfwxR2Mup5lVncfP03FxVEybgAFnrMu7OZwmZUbe5h9rLZRk5DMXvszwFAsgDugJS4YuDs8a5TfjV9TKFcpoqld0vMSlb6M8VWAFfZwmdkZjY+HjLiYMmWFq7bvg6mnVGglF+VcqE01RSmZBeErrPGbTZPaguA5N7HfRq743QLA8GYyHT4SY/5I+f8xKz9OyXPmA+pSNwYrpvCBqySPZnduJG83Ei6oF9IZNyp+pHoNDUINkP8z0ElV73zPTfps4CbMjmtbJdkJ2wmIWs4vtkRGjeZQ6UJgITjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6g20A5St77nSp9t/MZZBqtDNODNwsja+usQdT0yAEg0=;
 b=XDxFMLDU8RNRNPnU+5nrhBMjj/6IUu4/Bj0xW0vI7KsjZzrHq8CvBsD1d74X6g6EeQk4AN02HmN+CwW90GLT/kunMt5PMtFRJdYtMdJez6mgMgowiOiJXg0I9111mVay8IRO5/e9rSEFxXlBcW+bhy/z8SgGU+60GA8E7CVEvZt3P5ikcwWVmqjXHNYzodP8icHusYDut3e9Yj+12418zsdL5VbbjSXcNRv+W0/uCfwNfXhDIGEwYuKN77iRh7H9wiXnvjPKGP6NDwc1lv/nJSYaDsdEBWWBKEVqFu1vrQdb98fBbuaPvaSlBj4i8eXYEPocSlzlqKjxIU8WRP1hNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6g20A5St77nSp9t/MZZBqtDNODNwsja+usQdT0yAEg0=;
 b=HmBlszHAAgRxNcfI8KBBMpAdlUAYe1VWm9Iuh01wg5G/d+rwp56XO8oVJqtOebeYzfR72RYAw7/kJ8RO4xSismH8c2TXp7sYSbu1WRejZn42lM7OYomwEdneD9mU3KK7ne9sG/XA/+0BHjWPCqwwdQXjCnqVOFCTyXfEJrFqDWHRDRzcSsSK1DqOQqI8/rHSicwAHYilTa2ugRtk37JYspw3I8Zdbak6GmVO3n9sSAguYeWd2bIaiSXEAQG35Mx41vxp5+yuqkq8rc58u+B6tvFAyQ35nnPWKaakdKDJwtiwc2N+GJ5Jvxcjz4KnLfTFFwPV/pqrSLRqxu/ijwA1tA==
Received: from SEZPR01MB4527.apcprd01.prod.exchangelabs.com
 (2603:1096:101:76::5) by JH0PR01MB5516.apcprd01.prod.exchangelabs.com
 (2603:1096:990:13::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 08:51:21 +0000
Received: from SEZPR01MB4527.apcprd01.prod.exchangelabs.com
 ([fe80::653b:3492:9140:d2bf]) by SEZPR01MB4527.apcprd01.prod.exchangelabs.com
 ([fe80::653b:3492:9140:d2bf%2]) with mapi id 15.20.7677.030; Thu, 20 Jun 2024
 08:51:21 +0000
From: Jiwei Sun <sunjw10@outlook.com>
To: giovanni.cabiddu@intel.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	damian.muszynski@intel.com,
	tero.kristo@linux.intel.com,
	siming.wan@intel.com,
	adam.guerin@intel.com,
	ciunas.bennett@intel.com
Cc: qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sunjw10@lenovo.com,
	sunjw10@outlook.com,
	ahuang12@lenovo.com
Subject: [PATCH] crypto: qat - initialize user_input.lock for rate_limiting
Date: Thu, 20 Jun 2024 16:51:10 +0800
Message-ID:
 <SEZPR01MB45275F2F7A32D2DE4D6E2C9BA8C82@SEZPR01MB4527.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [HPwfxdzSystxuZy61dO/Uakq5MgonkVs]
X-ClientProxiedBy: SG3P274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::15)
 To SEZPR01MB4527.apcprd01.prod.exchangelabs.com (2603:1096:101:76::5)
X-Microsoft-Original-Message-ID: <20240620085110.11288-1-sunjw10@outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR01MB4527:EE_|JH0PR01MB5516:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c97552a-75f3-4da9-efc0-08dc91062816
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199025|3412199022|440099025|3420499029|1710799023;
X-Microsoft-Antispam-Message-Info:
	a0Nd5ppn57/wRgRjv5dPJuCzZw9qYfI8fr7FOHsDWHWB6lRuISePqf6PgA3MpNILNBRu0ceMbmcawm+bGwNGhhnD93OiiPhFUcwQQj9z8v3uFfIomShwbMdWefIBRyI9/R/gejd0dvfdOcCNLzZZUJmEVtwJxqGHfpB6coGxq+t/vPPVFpycpUf0a76Ib96uxiqlIsZ3+VYMOA1K2y55eEL+n+1AMGooBGYQq4didSDIut6ml6UeGNt7rR5yQS0GTN9NW+AiKDnN+kssQgveooA5JptrHYPLX+bGUOta0U0BsS33jSzdtlao1exxOTXfqo2hCngk/iQC10RwvsEAGdnVK0Wf6wvaNnKrqu/FxFt/bBVeRbzr328ZI8RpED5Szh0R0xKI5SSJgIyuPau4gdY9kihHUUfBZ6bDjAdwb5490Lvnv9rHKbJjRJUtwYl5JSKgjUC3P1AZx8mUbap2NuJySQJJSIiXarbJuWu+aADiSQiKencn9k9mbyehhhLx6m9xkKNVl3ukpX+ep5cWG5PYc21e4KLsxRPLiBMDaBl0eVo3JDsxPASzhxFJvKOE12u1cQ4MeZL3zXVtlQ4nrCe4LGgw21SEjwzdwHWAZ/hJWJxsLI6vHbovWUTMp34w
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L2ZKEi9/gVAbaYF13092gS08D28w7CIFT/qqKc0Dk496D4D1KidsmT9j8TQu?=
 =?us-ascii?Q?rZ30SMELVN6+V5Do5H22Cf/UqmkBBiv4OjqmkQzoMr16Z60UxQlvIQDodyfG?=
 =?us-ascii?Q?SfHFepSW6i4J70Spd3/I62LPeIlk6yXP+4YxtJYluPizOC/L2QmYoL6c6RDo?=
 =?us-ascii?Q?IRSStFlIiL3fTdPMYanqGCiFhsLGC2Llq1Ky+Gny0niJT8cofmFf3EMIpuXt?=
 =?us-ascii?Q?o1QNY7SneLcTasocofzvgfdxCuxk/JtijdQlUNY4n7KWv+97oQ0T25dmt+/E?=
 =?us-ascii?Q?v4IVm302ibSnqtkYGZxJ0/IxP0cVw1lsCGIr68J3vsfqIU3m42emYuHy083E?=
 =?us-ascii?Q?6YajJSh0fMNruJxRUBxFWNmYL/lU2eodxE7S2nHxxzE49FhVSYxm3A6LNWYq?=
 =?us-ascii?Q?jGy65iO8KQZchCxJWgQkA1DgQHGsC69vrz0EyqdF0hoALlwoJcdLk6ZqDj91?=
 =?us-ascii?Q?eMvO03SRd6+i5yXg1gv5U2b4TRFma8ZeypguiCe1JnMJ8of4Z635juh1gu0c?=
 =?us-ascii?Q?JzFEy6yxLgLIoXDuSTKdM0twgWjSVe4Cgq+/wnLBN+jtEdTVgsFdzIHxs0up?=
 =?us-ascii?Q?ljCnMINsf1OkcYCU3TQpokdUJlRpAySbmdGk8OiXy7n9WjVahZBpdZlkE2Z7?=
 =?us-ascii?Q?BEsddIvZiUOz5NSmfFBM9xur0vxoHF8FtSAOdQKY6xbfCGBvf/qCKflWnlUq?=
 =?us-ascii?Q?OWtYI5620EBnc8XuMaK85uI7wktFxIzje4p36u0qcHCS2JAk5IhvXxvHPugc?=
 =?us-ascii?Q?dgsBYeMnGJleo2TQDlN5rpYtl4Il3sArx56qKLvpZB7ccY4XUxiLr/l9X2ls?=
 =?us-ascii?Q?IfxUgmxkw7AFhOfunWM0vWDnIWy/OPUpQdNsNpKHTe75hF7mSk3yDzgdrF19?=
 =?us-ascii?Q?1OozYepbuzYLmT5idMd6fujGGUpOmZYxQYfc7wn9gYUAsYJCbPVJLwpLPvJe?=
 =?us-ascii?Q?wdRli2lMbpQ7XbyOFGmUUNSq3aEo2WAta58jp2t40gtw1EUrrrVp5QeoI8UN?=
 =?us-ascii?Q?vgbq+92xMQdMfglOK/wKI3QlTfW1xWPXxmusKXPhxDqrhqw8J+qcJm8m7PFM?=
 =?us-ascii?Q?tnzzvHhZZbeRn68sA5u0mFuQexU7U3/m4DjTAnrDj1MxthJC7AK3indrQBQV?=
 =?us-ascii?Q?grsT76NF2d4Sme79Vz+a9T6YpuvfJmqet1CG4LbZmCqwh6SurNX3aLja/J5T?=
 =?us-ascii?Q?YH2PFMhQXvvfeH0osawwXDmZocufSRyMcZAfnu51tAoOdu9efaUgBp/c9nc?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c97552a-75f3-4da9-efc0-08dc91062816
X-MS-Exchange-CrossTenant-AuthSource: SEZPR01MB4527.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 08:51:21.0719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR01MB5516

From: Jiwei Sun <sunjw10@lenovo.com>

If the following configurations are set,
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_RWSEM_SPIN_ON_OWNER=y

And run the following command,
[root@localhost sys]# cat /sys/devices/pci0000:6b/0000:6b:00.0/qat_rl/pir
The following warning log appears,

------------[ cut here ]------------
DEBUG_RWSEMS_WARN_ON(sem->magic != sem): count = 0x0, magic = 0x0, owner = 0x1, curr 0xff11000119288040, list not empty
WARNING: CPU: 131 PID: 1254984 at kernel/locking/rwsem.c:1280 down_read+0x439/0x7f0
CPU: 131 PID: 1254984 Comm: cat Kdump: loaded Tainted: G        W          6.10.0-rc4+ #86 b2ae60c8ceabed15f4fd2dba03c1c5a5f7f4040c
Hardware name: Lenovo ThinkServer SR660 V3/SR660 V3, BIOS T8E166X-2.54 05/30/2024
RIP: 0010:down_read+0x439/0x7f0
Code: 44 24 10 80 3c 02 00 0f 85 05 03 00 00 48 8b 13 41 54 48 c7 c6 a0 3e 0e b4 48 c7 c7 e0 3e 0e b4 4c 8b 4c 24 08 e8 77 d5 40 fd <0f> 0b 59 e9 bc fc ff ff 0f 1f 44 00 00 e9 e2 fd ff ff 4c 8d 7b 08
RSP: 0018:ffa0000035f67a78 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ff1100012b03a658 RCX: 0000000000000000
RDX: 0000000080000002 RSI: 0000000000000008 RDI: 0000000000000001
RBP: 1ff4000006becf53 R08: fff3fc0006becf17 R09: fff3fc0006becf17
R10: fff3fc0006becf16 R11: ffa0000035f678b7 R12: ffffffffb40e3e60
R13: ffffffffb627d1f4 R14: ff1100012b03a6d0 R15: ff1100012b03a6c8
FS:  00007fa9ff9a6740(0000) GS:ff1100081e600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa9ff984000 CR3: 00000002118ae006 CR4: 0000000000771ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 pir_show+0x5d/0xe0 [intel_qat 9e297e249ab040329cf58b657b06f418fd5c5855]
 dev_attr_show+0x3f/0xc0
 sysfs_kf_seq_show+0x1ce/0x400
 seq_read_iter+0x3fa/0x10b0
 vfs_read+0x6f5/0xb20
 ksys_read+0xe9/0x1d0
 do_syscall_64+0x8a/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7fa9ff6fd9b2
Code: c0 e9 b2 fe ff ff 50 48 8d 3d ea 1d 0c 00 e8 c5 fd 01 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
RSP: 002b:00007ffc0616b968 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007fa9ff6fd9b2
RDX: 0000000000020000 RSI: 00007fa9ff985000 RDI: 0000000000000003
RBP: 00007fa9ff985000 R08: 00007fa9ff984010 R09: 0000000000000000
R10: 0000000000000022 R11: 0000000000000246 R12: 0000000000022000
R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000
 </TASK>
irq event stamp: 0
hardirqs last  enabled at (0): [<0000000000000000>] 0x0
hardirqs last disabled at (0): [<ffffffffb102c126>] copy_process+0x21e6/0x6e70
softirqs last  enabled at (0): [<ffffffffb102c176>] copy_process+0x2236/0x6e70
softirqs last disabled at (0): [<0000000000000000>] 0x0
---[ end trace 0000000000000000 ]---

The rate_limiting->user_input.lock rwsem lock is not initialized before
use. Let's initialize it.

Signed-off-by: Jiwei Sun <sunjw10@lenovo.com>
Reviewed-by: Adrian Huang <ahuang12@lenovo.com>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index 346ef8bee99d..e782c23fc1bf 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -1106,6 +1106,7 @@ int adf_rl_init(struct adf_accel_dev *accel_dev)
 	mutex_init(&rl->rl_lock);
 	rl->device_data = &accel_dev->hw_device->rl_data;
 	rl->accel_dev = accel_dev;
+	init_rwsem(&rl->user_input.lock);
 	accel_dev->rate_limiting = rl;
 
 err_ret:
-- 
2.27.0

