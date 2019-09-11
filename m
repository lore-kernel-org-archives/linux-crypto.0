Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D372ECDE27
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 09:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14CE021928
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 09:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="SXEySzjS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfIKJfb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 05:35:31 -0400
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:46318
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbfIKJfb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 05:35:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/J5vBVBCaBQJpmbvqULJicAol4t6lfjvH/huDp/eEza2g1coLAj8B/kEBu7RI3HAshL/f9VibMwjlkTqxg4GSgZa5dZDmNmcZvZmF2mQbLY4OtDLG0uTcNESnoNxSoBqmOsmOu+PZBsBTAsDp/sIdQhaCyXRIv+E+7QOdNjmbGt6iIac5/tQQ7WUvge+fKI/maC6qKwGkpTqywuycqrKqTZnybsBAvw4jdX0Gp8eXq1ALPZhPiK5I+xq37AlE1/ZY2mAGGeTwFUZ2TghuYHapDdBMdqMQQJHkr37PCOGBk2vID0VlI6eBBXZOdPdYZ8oMTf6rAs0gaKg3ac0nFjmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PwyEVi5+2ichu0K/sF1Wm/mz0LjyQGqZS+R3WPisVM8=;
 b=eRMUOnfIJm1pU47yAQ/jT4ppTzZZKS6ISQFLmz7EQTeXbPAkEkACNa5e0bTNPkdhlw/Ywe3tODQgNydI1GhZ4OLzuS2s9geaegxDAK/INkp0iCDuZ9UDjh4FEhUkY6kehXtQItjVeozcdknqUhiMaTzZMlTbFk/O7kzWjyo5d9osVRDm7P0JnmmyfZ9Jdlal83DGNQGPAoWECfPPnxPT7sTlXDnQ2kDRysd9sKADNbz55GATzG01283cPDcSLaLiXOfaD7q5ipo6/GDwl4kFpXxFNGhDodPuNYznjv3gl3xnVoiopXl0ZKS7W1+7/E6EN0JWdhVbj6/gom4PsqqvHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PwyEVi5+2ichu0K/sF1Wm/mz0LjyQGqZS+R3WPisVM8=;
 b=SXEySzjSezRQK9cy+NgppMgvl6QC+D1f3c6NGbRjLfZnqOqrH1JqHXZT2HVy+z4decYowtpkiRvug4JI0jKCSDn2TjcQ7Rgj8kMvQb7TpI99wYCtqKg92TVXgg9KmMmRZ2YvCKmxL/YgFKgg+Koq+kTEqbhsb6+0jUXq73E1tRE=
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com (52.134.3.153) by
 VI1PR0402MB3903.eurprd04.prod.outlook.com (52.134.17.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Wed, 11 Sep 2019 09:35:27 +0000
Received: from VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5]) by VI1PR0402MB3485.eurprd04.prod.outlook.com
 ([fe80::c1a3:2946:8fa8:bfc5%3]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 09:35:27 +0000
From:   Horia Geanta <horia.geanta@nxp.com>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: caam - use the same jr for rng init/exit
Thread-Topic: [PATCH] crypto: caam - use the same jr for rng init/exit
Thread-Index: AQHVaIQ+ooPZSK+hE0+ffBEyoUzaeQ==
Date:   Wed, 11 Sep 2019 09:35:27 +0000
Message-ID: <VI1PR0402MB34859D108C03F3AB0F64EE6598B10@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-12-andrew.smirnov@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=horia.geanta@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd4167be-93e2-47e6-3fdb-08d7369b6115
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3903;
x-ms-traffictypediagnostic: VI1PR0402MB3903:|VI1PR0402MB3903:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB390376A663B6EB1DCCEE947298B10@VI1PR0402MB3903.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(39860400002)(366004)(376002)(189003)(199004)(45080400002)(478600001)(110136005)(76176011)(54906003)(25786009)(316002)(6436002)(33656002)(66066001)(6116002)(3846002)(4326008)(7696005)(2906002)(53546011)(6506007)(966005)(14454004)(102836004)(476003)(486006)(446003)(44832011)(26005)(186003)(8936002)(81166006)(81156014)(8676002)(52536014)(7736002)(305945005)(74316002)(5660300002)(76116006)(64756008)(91956017)(66446008)(66946007)(66556008)(2501003)(66476007)(99286004)(86362001)(71200400001)(71190400001)(53936002)(256004)(14444005)(55016002)(6306002)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3903;H:VI1PR0402MB3485.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: E4uXI3cE7F3A97mSipFn/KnLIU+Rswyhe7fr0WF2kLUgZHzXL5Km3TQDi7ihHFS1qFLdfZqPGmqxXI6sVqQlgQdhgUTwB10kvfKcMRbDKGpfrc7LnuyclFZzfPvvh1ZWFIu28Svre2SmwzWSZwjqqisCfWLqDMh5a16u2dc0mKPvxN0ahSXIgVFI2eoBR9wA4aZoAZhRbZc7E5SG36A4UY1l5gXbKfYksISVD19TIwhcz7mt2cSx2jr+z4xcMOnDYNr0CJQCWsfdTPIEKPlq/ZyTJJHlLsL165Sdbn7MbLmjLj4pWhIIirC67A8UnvGGzGOjwWEIF7DXWJ1KWJ6YIsKZBeuvjjY7d0d5si71mG+MhH2OnDGH/gJTqatlPpRMjyfPYOcbj1OoMqWMcQvFwmEP7crx8f2Xw5PDmXE+6yk=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd4167be-93e2-47e6-3fdb-08d7369b6115
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 09:35:27.1598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q1jzh6zRqt/zpEeWQxI0sSYNfYOJ1pOhmnVj2LrJcBZBOOsVnYElnMT+rQAt9IR8fvSRSlAAXOfGQ3w/jFG4ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3903
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/4/2019 5:35 AM, Andrey Smirnov wrote:=0A=
> In order to allow caam_jr_enqueue() to lock underlying JR's=0A=
> device (via device_lock(), see commit that follows) we need to make=0A=
> sure that no code calls caam_jr_enqueue() as a part of caam_jr_probe()=0A=
> to avoid a deadlock. Unfortunately, current implementation of caamrng=0A=
> code does exactly that in caam_init_buf().=0A=
> =0A=
> Another big problem with original caamrng initialization is a=0A=
> circular reference in the form of:=0A=
> =0A=
>  1. caam_rng_init() aquires JR via caam_jr_alloc(). Freed only by=0A=
>     caam_rng_exit()=0A=
> =0A=
>  2. caam_rng_exit() is only called by unregister_algs() once last JR=0A=
>     is shut down=0A=
> =0A=
>  3. caam_jr_remove() won't call unregister_algs() for last JR=0A=
>     until tfm_count reaches zero, which can only happen via=0A=
>     unregister_algs() -> caam_rng_exit() call chain.=0A=
> =0A=
> To avoid all of that, convert caamrng code to a platform device driver=0A=
> and extend caam_probe() to create corresponding platform device.=0A=
> =0A=
> Additionally, this change also allows us to remove any access to=0A=
> struct caam_drv_private in caamrng.c as well as simplify resource=0A=
> ownership/deallocation via devres.=0A=
> =0A=
I would avoid adding platform devices that don't have=0A=
corresponding DT nodes.=0A=
=0A=
There's some generic advice here:=0A=
https://www.kernel.org/doc/html/latest/driver-api/driver-model/platform.htm=
l#legacy-drivers-device-probing=0A=
=0A=
and there's also previous experience in caam driver:=0A=
6b175685b4a1 crypto: caam/qi - don't allocate an extra platform device=0A=
=0A=
The issue in caamrng is actually that caam/jr driver (jr.c) tries to call=
=0A=
caam_rng_exit() on the last available jr device.=0A=
Instead, caam_rng_exit() must be called on the same jr device that=0A=
was used during caam_rng_init().=0A=
=0A=
Otherwise, by the time:=0A=
=0A=
void caam_rng_exit(void)=0A=
{=0A=
        if (!init_done)=0A=
                return;=0A=
=0A=
        caam_jr_free(rng_ctx->jrdev);=0A=
	hwrng_unregister(&caam_rng);=0A=
[...]=0A=
=0A=
is executed, rng_ctx->jrdev might have been removed.=0A=
=0A=
This will cause an oops in caam_jr_free().=0A=
caam_cleanup() - .cleanup hwrng callback that is called when doing=0A=
hwrng_unregister() - also needs to be executed on that jr device.=0A=
=0A=
The problem can be easily reproduced as follows.=0A=
=0A=
If caamrng was initialized on jr0:=0A=
[...]=0A=
caam_jr 2101000.jr0: registering rng-caam=0A=
[...]=0A=
=0A=
then by manually unbinding jr0 first, then jr1 (using i.MX6SX):=0A=
# echo -n "2101000.jr0" > /sys/bus/platform/drivers/caam_jr/=0A=
# echo -n "2102000.jr1" > /sys/bus/platform/drivers/caam_jr/=0A=
=0A=
Unable to handle kernel NULL pointer dereference at virtual address 0000004=
0=0A=
pgd =3D 572e14e7=0A=
[00000040] *pgd=3Dbe2e8831=0A=
Internal error: Oops: 17 [#1] SMP ARM=0A=
Modules linked in:=0A=
CPU: 0 PID: 629 Comm: sh Not tainted 5.3.0-rc1-00299-g8e2a2738e5d3-dirty #8=
=0A=
Hardware name: Freescale i.MX6 SoloX (Device Tree)=0A=
PC is at caam_jr_free+0xc/0x24=0A=
LR is at caam_rng_exit+0x20/0x3c=0A=
pc : [<c08aef20>]    lr : [<c08bab1c>]    psr: 200f0013=0A=
sp : e9669e68  ip : 00001488  fp : 00000000=0A=
r10: 00000000  r9 : e9669f80  r8 : e9284010=0A=
r7 : e872d410  r6 : e872d410  r5 : e872d400  r4 : c1aa7cd8=0A=
r3 : 00000000  r2 : 00000040  r1 : 00000000  r0 : e872d010=0A=
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none=0A=
Control: 10c5387d  Table: a969004a  DAC: 00000051=0A=
Process sh (pid: 629, stack limit =3D 0xfc1b6e94)=0A=
Stack: (0xe9669e68 to 0xe966a000)=0A=
9e60:                   e865c940 c08af7dc e872d410 e872d410 c13a9cec c06b22=
3c=0A=
9e80: c06b2218 e872d410 e81a9410 c06b08dc c13806f0 0000000b c13a9cec c06aea=
f8=0A=
9ea0: 0000000b 00000000 0000000b e9284000 e91189c0 c0318c3c 00000000 000000=
00=0A=
9ec0: e95ddbd0 e8843500 c1308b08 c6614c9f e8843500 00438340 e9668000 000000=
04=0A=
9ee0: 00000000 c0285e00 00000001 00000000 00000000 c0288a44 00000000 000000=
00=0A=
9f00: c1308b28 00000000 00000001 c130911c 00000001 c13e81d1 c0288a44 000000=
00=0A=
9f20: e8ed9800 c019df00 e8ed9a7c c028ac08 00000001 00000000 c0288a44 c6614c=
9f=0A=
9f40: c1308b08 0000000b 00438340 e9669f80 e8843500 00438340 e9668000 c02889=
9c=0A=
9f60: e95ddbc0 c6614c9f e8843500 e8843500 c1308b08 0000000b 00438340 c0288b=
fc=0A=
9f80: 00000000 00000000 00000000 c6614c9f 0000000b 00438340 b6ef1da0 000000=
04=0A=
9fa0: c01011c4 c0101000 0000000b 00438340 00000001 00438340 0000000b 000000=
00=0A=
9fc0: 0000000b 00438340 b6ef1da0 00000004 00438340 0000000b 00000000 000000=
00=0A=
9fe0: 0000006c bea7f908 b6e19e58 b6e7325c 600f0010 00000001 00000000 000000=
00=0A=
[<c08aef20>] (caam_jr_free) from [<c08bab1c>] (caam_rng_exit+0x20/0x3c)=0A=
[<c08bab1c>] (caam_rng_exit) from [<c08af7dc>] (caam_jr_remove+0x38/0xc0)=
=0A=
[<c08af7dc>] (caam_jr_remove) from [<c06b223c>] (platform_drv_remove+0x24/0=
x3c)=0A=
[<c06b223c>] (platform_drv_remove) from [<c06b08dc>] (device_release_driver=
_internal+0xdc/0x1a0)=0A=
[<c06b08dc>] (device_release_driver_internal) from [<c06aeaf8>] (unbind_sto=
re+0x5c/0xcc)=0A=
[<c06aeaf8>] (unbind_store) from [<c0318c3c>] (kernfs_fop_write+0xfc/0x1e0)=
=0A=
[<c0318c3c>] (kernfs_fop_write) from [<c0285e00>] (__vfs_write+0x2c/0x1d0)=
=0A=
[<c0285e00>] (__vfs_write) from [<c028899c>] (vfs_write+0xa0/0x180)=0A=
[<c028899c>] (vfs_write) from [<c0288bfc>] (ksys_write+0x5c/0xdc)=0A=
[<c0288bfc>] (ksys_write) from [<c0101000>] (ret_fast_syscall+0x0/0x28)=0A=
Exception stack(0xe9669fa8 to 0xe9669ff0)=0A=
9fa0:                   0000000b 00438340 00000001 00438340 0000000b 000000=
00=0A=
9fc0: 0000000b 00438340 b6ef1da0 00000004 00438340 0000000b 00000000 000000=
00=0A=
9fe0: 0000006c bea7f908 b6e19e58 b6e7325c=0A=
Code: eaffff49 e5903040 e2832040 f5d2f000 (e1921f9f)=0A=
=0A=
Thus, I'd say the following fix is needed:=0A=
=0A=
-- >8 --=0A=
=0A=
When caam_rng_exit() executes, the jr device that was used=0A=
during caam_rng_init() must be available.=0A=
=0A=
This means that current scheme - where caam_rng_exit() is called=0A=
when last jr device is removed - is incorrect.=0A=
Instead, caam_rng_exit() has to run when the jr acquired=0A=
during caam_rng_init() is removed.=0A=
=0A=
Fixes: 1b46c90c8e00 ("crypto: caam - convert top level drivers to libraries=
")=0A=
Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
=0A=
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c=
=0A=
index e8baacaabe07..ec40178fa688 100644=0A=
--- a/drivers/crypto/caam/caamrng.c=0A=
+++ b/drivers/crypto/caam/caamrng.c=0A=
@@ -300,9 +300,9 @@ static struct hwrng caam_rng =3D {=0A=
        .read           =3D caam_read,=0A=
 };=0A=
=0A=
-void caam_rng_exit(void)=0A=
+void caam_rng_exit(struct device *jrdev)=0A=
 {=0A=
-       if (!init_done)=0A=
+       if (!init_done || jrdev !=3D rng_ctx->jrdev)=0A=
                return;=0A=
=0A=
        caam_jr_free(rng_ctx->jrdev);=0A=
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h=0A=
index 731b06becd9c..4795530203ad 100644=0A=
--- a/drivers/crypto/caam/intern.h=0A=
+++ b/drivers/crypto/caam/intern.h=0A=
@@ -165,7 +165,7 @@ static inline void caam_pkc_exit(void)=0A=
 #ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API=0A=
=0A=
 int caam_rng_init(struct device *dev);=0A=
-void caam_rng_exit(void);=0A=
+void caam_rng_exit(struct device *jrdev);=0A=
=0A=
 #else=0A=
=0A=
@@ -174,7 +174,7 @@ static inline int caam_rng_init(struct device *dev)=0A=
        return 0;=0A=
 }=0A=
=0A=
-static inline void caam_rng_exit(void)=0A=
+static inline void caam_rng_exit(struct device *jrdev)=0A=
 {=0A=
 }=0A=
=0A=
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c=0A=
index d11956bc358f..61aea11773a6 100644=0A=
--- a/drivers/crypto/caam/jr.c=0A=
+++ b/drivers/crypto/caam/jr.c=0A=
@@ -53,7 +53,6 @@ static void unregister_algs(void)=0A=
=0A=
        caam_qi_algapi_exit();=0A=
=0A=
-       caam_rng_exit();=0A=
        caam_pkc_exit();=0A=
        caam_algapi_hash_exit();=0A=
        caam_algapi_exit();=0A=
@@ -126,6 +125,8 @@ static int caam_jr_remove(struct platform_device *pdev)=
=0A=
        jrdev =3D &pdev->dev;=0A=
        jrpriv =3D dev_get_drvdata(jrdev);=0A=
=0A=
+       caam_rng_exit(jrdev);=0A=
+=0A=
        /*=0A=
         * Return EBUSY if job ring already allocated.=0A=
         */=0A=
