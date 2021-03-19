Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F55C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 00:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB69A60201
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 00:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhCSAYF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 20:24:05 -0400
Received: from mail-eopbgr20069.outbound.protection.outlook.com ([40.107.2.69]:11429
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231346AbhCSAXl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 20:23:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpkCpMXol6hDLd9VMRQZAu60qkdPjr/DWXjKd+hJpuGYsSo7dVoPw3EBQL5fb64flBdOmoXTMk9vrdrh/a157Ah85WjiwlV6Qr+vZXbMSSHTlXQUKYxKeBbkRHN7OeZBlkcyU5v25hW11v8pJ/lR4g6fMCAf8zFhn9Ml/BoO7GsSaZpVPLKP9A0BIvjJz26VIbuwI5IaWu4VGK2S1NWqmQv15wBYMjHDs9DN5b7RK4bgnnvuLYMGND7SGA73eRjv5Knb0+xJcIFyn/izxABLDZCxuRSGUdzh7xMCaw7ptrxfySCopwD1AYaHT/qAfNFVtD2bdfYrevflQ4oQG/wL7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CW19p226Tvx0t0vXwsKU9yoQIgeHoL0Y8wH+P7DU0uk=;
 b=Fcucm+Ip+S1PKX+reTT9kzdjW+ubWt6Ueh58LY9/rsp500yTIrnen1KVECL+md8GY3OyCK7DSUjvFiLN9OTUzUwaCoBTtzunM4V8fHAmkbzvq9jiQPChO0m/fVOtGdnqu1gDvHb7NI/cwTNIs7JHsrG+PRi55hOzSbrwuOKYji0yqfMvOz05ImADNuFk33lNyApVHhjG0wqrbar6BL3dydFytDlAwYYjvog07x90RybcyPjxPNp45pMauFSjC81mRRGb/vm1F4s6XIIYm9+qcZyKtqPNMvNAkC3zGzKWju0jxrb5RgORRsUzOxZatqk5kaxXyiTcNW4Rmme+kh3n3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CW19p226Tvx0t0vXwsKU9yoQIgeHoL0Y8wH+P7DU0uk=;
 b=mJCa8lmTjopd6E+jZ35czTRKeCPzLRXvxFGVo/6/w4LVRMnEqdcQsF1LDZa2AWGb0SnKGLFcYdMDyqXggyh3d3hwHMdPgs291OBIJT0VctTbtFgn1bbbcZjugzLZ8tAmKdfM7WgKFRqPYfhotteQH3Ubxhzn5DtOQhbgTydoiXQ=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from VI1PR04MB6301.eurprd04.prod.outlook.com (2603:10a6:803:f1::19)
 by VI1PR04MB4942.eurprd04.prod.outlook.com (2603:10a6:803:59::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 19 Mar
 2021 00:23:35 +0000
Received: from VI1PR04MB6301.eurprd04.prod.outlook.com
 ([fe80::94cd:765d:2b27:7733]) by VI1PR04MB6301.eurprd04.prod.outlook.com
 ([fe80::94cd:765d:2b27:7733%3]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 00:23:34 +0000
From:   "Dragos Rosioru (OSS)" <dragos.rosioru@oss.nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     Marek Vasut <marex@denx.de>, Horia Geanta <horia.geanta@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 0/1] crypto: dcp - add power management support
Date:   Fri, 19 Mar 2021 02:22:56 +0200
Message-Id: <1616113377-24703-1-git-send-email-dragos.rosioru@oss.nxp.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM6P195CA0053.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::30) To VI1PR04MB6301.eurprd04.prod.outlook.com
 (2603:10a6:803:f1::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1664-206.ea.freescale.net (83.217.231.2) by AM6P195CA0053.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 00:23:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: df98a96e-4936-482e-7039-08d8ea6d3ba3
X-MS-TrafficTypeDiagnostic: VI1PR04MB4942:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4942D6AB78514F2D44372CCDDF689@VI1PR04MB4942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LzPkkL/aTKa7qtzHqaoN2k2C5BnYoFmsGBQHY8lW6EscZGgYi+XgDNjw0lE2BjFn2e+Q/+lhaPOLp2ZHS+7dpHXcb6oIr5benI6ZNcEDPaJXpf/VPWK54vEXXim8bVnsxw8yGlGf9sbnxNwaAz53Ww0vlxm3V34xgCraNhbfCfD94V0f+oQqCa/XK7MK484YO47EIP11h2aHrQIlb8A2pZZB+Zue1jfCrTe9Ckg6uTOxvY28q+Um/pFxQXcQ49qh38CHy/uqswGvOW+GGEZVTsbFiuXDLBA3YA2Vrr1zbM7tqf6RWaMkrIH8kyEFLACstDeaVjX5dZrUHPmEnL8jTEldZry3vWtby11YMXTR2FTZGnKsd6DJdO4ZMtOpuUso/zPeMbGXHRf6KLE+Xq4AdwHda9NLAH0lMwySvHV7pG1lVeEcKOXdPmyKBTXDsVSyjY/85h+kTkxNzWwP8Y27/gDUR+phVDUTfMd/Zi6M+Fgje/ssX+Ouw2jcIflUT4552ISwhEm4OcLKnJHKmED6F2uh+JxhbLUP3P8xwgQ7qfFjjRsKAu93f9GIXE5nDuN3/VrwZVOZfnMU2QwFOR2i0NaWqlMsEiUO3UUjmt5KwqLk+ClQRFKMZ82uqUHdXclz0AV3Pp9NSVPhcZgLzWc3rQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6301.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(66946007)(6666004)(26005)(52116002)(5660300002)(956004)(83380400001)(66476007)(66556008)(186003)(38100700001)(4326008)(86362001)(54906003)(7416002)(8936002)(316002)(6486002)(6506007)(6512007)(8676002)(478600001)(110136005)(2906002)(2616005)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JwblkjRliA5XzVB08f+xfIqo/0/I0dm5y5yvUNTSlDaInoYCjnXkXjZrnl0d?=
 =?us-ascii?Q?dYJzQrlTTNVt6iq7JbxGNm3GHWdZtXtZMWdoNCoBNZQZPjXOROKwYRJhYzZR?=
 =?us-ascii?Q?sk8wz+XYMnjXTDYMNn0UDLPM3cou5nv/Fu/PY9CuZACGFGmI5YyJFCOAnauO?=
 =?us-ascii?Q?1f31TLuTISfhFSxsNLkC3xNGVSBnTigQhDOWYYCoeQGYekVKarp4KMDNdmmZ?=
 =?us-ascii?Q?V4h7rIr5sNLQtv7bktBQLlIvl70UCqVVgJ6HXAGRnLA/oxVzn5g2TpyBK+85?=
 =?us-ascii?Q?6RWWVBLQBSmkrIa2z5OQ361atj/logS2pKGZvpYQhLA0bO+VkuSdodO9BupH?=
 =?us-ascii?Q?CifhyveSN+7cWpfbF4Mpj5VlJE67t115rgysjvsQRqJGx/Xnxh7nkmu3dKcn?=
 =?us-ascii?Q?4OJpFgNiRd+GegNUoR74tkCFJEK56fKR4wx9nIYJlxZfEPYTFsmXraBrSrac?=
 =?us-ascii?Q?PYZEKyJm5MDYA/vj5KT1GmDA9mPrFm0vToz9WkUuUD75NHwBTU7PKx1IFw3e?=
 =?us-ascii?Q?iWZaogu5tUUg+Y/YtPSH+hafkNFjA18Dd6qUoZfU0ZH91VwlLCv02WMF+FSA?=
 =?us-ascii?Q?Tob3cH84G/xHKxMYBkRkmGPwDusrCLZD1lYSa6uBmd7nlWhzx+Awof8eIH9D?=
 =?us-ascii?Q?Xqz2yw89CiPp9oODaNbB583Ziw9Rx1bZBRTn1qluV6V3aR95tUo2WWhpOJKP?=
 =?us-ascii?Q?LSTiH6mDLsb8+3tyS1pM+RVe7pQjCyewev5feAxRwhWLksc8GLaNwOsEK7Zb?=
 =?us-ascii?Q?gBsM/wZ/6YKIhZmX3eJ/a15xMxxY06+JdoHUeDQaulWSGUgTCWsGt8XOO0Gz?=
 =?us-ascii?Q?qtxGFtYx7BxzX++pkQygniwsOdIuD3vDVrmcfVRFqQbVocfm7SkyEmmy1iEP?=
 =?us-ascii?Q?p54t3dVtJBJ0l9+s3fzweFpC/cIaODpg6ZRDmuwjEpAGj6e2dfJMFgsXkOfG?=
 =?us-ascii?Q?Wo1DlhTMY9FKEGiXdOWlTtYpuFce5XsvFgFWFbwUvdVYJ/3WKaeukIEFQ5Rl?=
 =?us-ascii?Q?0/L5x3YHB0OpZMwCJpBub2cOvjx6xuCsfAo+p7TWuy5ZygXuJBmLjwAUQUZk?=
 =?us-ascii?Q?Q6t5qkRQr12DBmh7SNtkY1h6q+ZMrOem3v5t9+OGQyL+GCQQAB/Z1qj6/HOl?=
 =?us-ascii?Q?QfhBUodZGLjokN9gHeyjRjNEUCJqIBVPWpXdiYhyJ7mH6TiOkZ5VuwceKj7k?=
 =?us-ascii?Q?KTWSrkiUiYTIvbJ2vZypjgKTVPj7WoEMaw8nifrbgLWrc4/Kkyk/0aDSOFfc?=
 =?us-ascii?Q?wCT4zSQk6u6pHLbuukd8HKghRDTWl4AKAGZaDn1Ef018d3oZ9QEh0oGeDquf?=
 =?us-ascii?Q?DF26KuUTIG0z3D/ua/0VDLJB?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df98a96e-4936-482e-7039-08d8ea6d3ba3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6301.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 00:23:34.8515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5fZl99oKV9Tgr+rqpcIhabmziuUC4hrDKL3luI/bMwD32tXqubFGbZtpvH8dBSiecv8BqQzEiz4GCQsyFIAipg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4942
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Dragos Rosioru <dragos.rosioru@nxp.com>

This patch aims to enable PM support in the DCP driver.
The values for DCP Control and Channel Control registers had to be saved
and restored due to the fact that the DCP block would remain in a
low-power mode and have its clocks gated after suspend/resume cycles.

A simple test consisting of running tcrypt speed tests in background and
attempting to put the system in a sleep state(both shallow and deep)
was used.
The test failed due to inability to freeze the kernel threads.
Freezing of tasks failed after 20.015 seconds
(1 tasks refusing to freeze, wq_busy=0)
The solution for this issue was to use the kthread freezer by
calling try_to_freeze() on the processing threads.
Would this be considered a correct solution in this particular case
or should another approach, that does not rely on kthread freezer,
be taken?
In the later case, what would be the suggested option?

modprobe tcrypt mode=500 sec=1 &
pm_suspend.sh 1 &

[  171.648351] tcrypt: test 1 (128 bit key, 64 byte blocks): 2485 operations in 1 seconds (159040 bytes)
[  172.651560] tcrypt: test 2 (128 bit key, 256 byte blocks): 1523 operations in 1 seconds (389888 bytes)
...
PM_SUSPEND    0  TINFO  :  PM_SUSPEND: Test WAIT and STOP mode times: 0
freeze standby mem
rtc_testapp_6    0  TINFO  :  Open RTC device successfully: /dev/rtc

rtc_testapp_6    0  TINFO  : [  196.270268] tcrypt: test 5 (128 bit key, 4096 byte blocks):
ALARM TEST: RTC_ALM_SET & RTC_ALM_[  196.755624] PM: suspend entry (shallow)
READ
rtc_testapp_6    0  TINFO  :    Read date/time...
rtc_testapp_6    0  TINFO  :      Current RTC date/time is 2-1-1970, 17:50:59.
rtc_testapp_6    0  TINFO  :    Set the alarm to 30 seconds in the future...
rtc_testapp_6    0  TINFO  :      Enable alarm interrupts
rtc_testapp_6    0  TINFO  :    Waiting 30 seconds for alarm.......
[  196.824708] Filesystems sync: 0.054 seconds
[  197.066653] Freezing user space processes ...
...
[  209.401137] tcrypt:
[  209.401137] testing speed of async cbc(aes) (cbc-aes-dcp) encryption
[  209.411104] tcrypt: test 0 (128 bit key, 16 byte blocks): 3228 operations in 1 seconds (51648 bytes)
[  210.419875] tcrypt: test 1 (128 bit key, 64 byte blocks): 3232 operations in 1 seconds (206848 bytes)
...
[  216.480736] tcrypt: test 7 (192 bit key, 64 byte blocks): 110395 operations in 1 seconds (7065280 bytes)
[  217.489804]
[  217.491391] Freezing of tasks failed after 20.423 seconds (1 tasks refusing to freeze, wq_busy=0):
[  217.500725] task:modprobe        state:R  running task     stack:    0 pid:  482 ppid:   477 flags:0x00000001
[  217.511782] [<c0e44368>] (__schedule) from [<c0e44b38>] (preempt_schedule_common+0x28/0x44)
[  217.520458] [<c0e44b38>] (preempt_schedule_common) from [<c0e44b90>] (_cond_resched+0x3c/0x44)
[  217.529380] [<c0e44b90>] (_cond_resched) from [<bf0003ec>] (test_skcipher_speed+0x31c/0x590 [tcrypt])
[  217.538881] [<bf0003ec>] (test_skcipher_speed [tcrypt]) from [<bf004460>] (do_test+0x1bbc/0x42cc [tcrypt])
[  217.548918] [<bf004460>] (do_test [tcrypt]) from [<bf00d05c>] (tcrypt_mod_init+0x5c/0x1000 [tcrypt])
[  217.558434] [<bf00d05c>] (tcrypt_mod_init [tcrypt]) from [<c01022c4>] (do_one_initcall+0x84/0x3c4)
[  217.567726] [<c01022c4>] (do_one_initcall) from [<c01e603c>] (do_init_module+0x5c/0x280)
[  217.576128] [<c01e603c>] (do_init_module) from [<c01e8d98>] (sys_finit_module+0xb4/0xf4)
[  217.584533] [<c01e8d98>] (sys_finit_module) from [<c0100080>] (ret_fast_syscall+0x0/0x2c)
[  217.593010] Exception stack(0xc5099fa8 to 0xc5099ff0)
[  217.598157] 9fa0:                   00000000 00000000 00000003 00759210 00000000 00040000
[  217.606604] 9fc0: 00000000 00000000 00000000 0000017b 00759240 00759630 0000000e 00000000
[  217.615048] 9fe0: be8c68e0 be8c68d0 004bce0d b6f083d2
[  217.620349]
[  217.621919] OOM killer enabled.
[  217.625126] Restarting tasks ... done.
[  217.860270] PM: suspend exit
rtc_testapp_6    1  TFAIL  :  rtc_test_6.c:449: Suspend operation failed on mode standby, please check
rtc_testapp_6    0  TINFO  :  Exit suspend operation....
...
rtc_testapp_6    0  TINFO  :  Open RTC device success[  224.738516] PM: suspend entry (deep)
fully: /dev/rtc

rtc_testapp_6    0  TINFO  :  ALA[  224.747606] Filesystems sync: 0.002 seconds
RM TEST: RTC_ALM_SET & RTC_ALM_READ
rtc_testapp_6    0  TINFO  :    Read date/time...
rtc_testapp_6    0  TINFO  :      Current RTC date/time is 2-1-1970, 17:51:27.
rtc_testapp_6    0  TINFO  :    Set the alarm to 30 seconds in the future...
rtc_testapp_6    0  TINFO  :      Enable alarm interrupts
rtc_testapp_6    0  TINFO  :    Waiting 30 seconds for alarm.......
...
[  247.142469] testing speed of async xts(aes) (xts(ecb-aes-dcp)) encryption
[  247.153739] tcrypt: test 0 (256 bit key, 16 byte blocks): 2899 operations in 1 seconds (46384 bytes)
[  248.158437] tcrypt: test 1 (256 bit key, 64 byte blocks):
[  248.905430]
[  248.912762] Freezing of tasks failed after 20.011 seconds (1 tasks refusing to freeze, wq_busy=0):
[  248.922195] task:modprobe        state:D stack:    0 pid:  482 ppid:   477 flags:0x0000000                                                                                                1
[  248.930926] [<c0e44368>] (__schedule) from [<c0e449ec>] (schedule+0x90/0x118)
[  248.938189] [<c0e449ec>] (schedule) from [<c0e49ad8>] (schedule_timeout+0xcc/0x120)
[  248.946156] [<c0e49ad8>] (schedule_timeout) from [<c0e45a20>] (wait_for_completion+0x90/0xf8)
[  248.955006] [<c0e45a20>] (wait_for_completion) from [<bf006c58>] (crypto_wait_req+0x20/0x30 [tcrypt])
[  248.964599] [<bf006c58>] (crypto_wait_req [tcrypt]) from [<bf0003d8>] (test_skcipher_speed+0x308/0x590 [tcrypt])
[  248.975137] [<bf0003d8>] (test_skcipher_speed [tcrypt]) from [<bf0044d4>] (do_test+0x1c30/0x42cc [tcrypt])
[  248.985152] [<bf0044d4>] (do_test [tcrypt]) from [<bf00d05c>] (tcrypt_mod_init+0x5c/0x1000 [tcrypt])
[  248.994649] [<bf00d05c>] (tcrypt_mod_init [tcrypt]) from [<c01022c4>] (do_one_initcall+0x84/0x3c4)
[  249.003935] [<c01022c4>] (do_one_initcall) from [<c01e603c>] (do_init_module+0x5c/0x280)
[  249.012331] [<c01e603c>] (do_init_module) from [<c01e8d98>] (sys_finit_module+0xb4/0xf4)
[  249.020708] [<c01e8d98>] (sys_finit_module) from [<c0100080>] (ret_fast_syscall+0x0/0x2c)
[  249.029180] Exception stack(0xc5099fa8 to 0xc5099ff0)
[  249.034325] 9fa0:                   00000000 00000000 00000003 00759210 00000000 00040000
[  249.042767] 9fc0: 00000000 00000000 00000000 0000017b 00759240 00759630 0000000e 00000000
[  249.051205] 9fe0: be8c68e0 be8c68d0 004bce0d b6f083d2
[  249.056347]
[  249.057912] OOM killer enabled.
[  249.061582] Restarting tasks ...
[  249.149290] 2457 operations in 1 seconds (157248 bytes)
[  249.157967] tcrypt: test 2 (256 bit key, 256 byte blocks):[  249.397200] done.
[  249.445234] PM: suspend exit
rtc_testapp_6    1  TFAIL  :  rtc_test_6.c:449: Suspend operation failed on mode mem, please check

Dragos Rosioru (1):
  crypto: dcp - add power management support

 drivers/crypto/mxs-dcp.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 2 deletions(-)

-- 
2.7.4

