Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D70ECDE30
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 12:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F55621526
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Oct 2018 12:38:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="uj3O1kjE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F55621526
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbeJQUdb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Oct 2018 16:33:31 -0400
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:8163
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727331AbeJQUdb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 16:33:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjEsZ3YDpb4PmUooqzUS9/tlVt8PAZjLWajq36Z3dFo=;
 b=uj3O1kjEdO0NsQTnuCpkkbMtQZgTD5RS+WkHHg+SAAoy3iVstbUk/N39TZvbhnE3Nkz4D519SwRHyw1Yal4rFt/Ok1BWtyLfrjYkXfJlFGia3oT2Vx4EnF1BPoIHMU3j4Sx4YfpWDzyxEcMtLe1M/PSJKYFi/X0LOJUEK4Ig4aU=
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com (52.134.126.145) by
 AM0PR04MB4212.eurprd04.prod.outlook.com (52.134.126.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.26; Wed, 17 Oct 2018 12:37:53 +0000
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef]) by AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef%3]) with mapi id 15.20.1228.032; Wed, 17 Oct 2018
 12:37:53 +0000
From:   Leonard Crestez <leonard.crestez@nxp.com>
To:     Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
CC:     Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S . Miller " <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 2/4] crypto: mxs-dcp - Add support for dcp clk
Thread-Topic: [PATCH v4 2/4] crypto: mxs-dcp - Add support for dcp clk
Thread-Index: AQHUZhY4HefM3c9m50qn78KSFJ8+NA==
Date:   Wed, 17 Oct 2018 12:37:53 +0000
Message-ID:
 <95dce7010676581691b1ac9906e9298470e0aa1a.1539779579.git.leonard.crestez@nxp.com>
References: <cover.1539779579.git.leonard.crestez@nxp.com>
In-Reply-To: <cover.1539779579.git.leonard.crestez@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.76.156.53]
x-mailer: git-send-email 2.17.1
x-clientproxiedby: AM6P191CA0098.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::39) To AM0PR04MB4290.eurprd04.prod.outlook.com
 (2603:10a6:208:67::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR04MB4212;6:4L5EVe8HIPMLs3VxJ3B0lWCzLUev1du1VX+6/eNjxqhoiBShYoq1C2KLC4ImoAJfcqA74lldlioFfTaQVGYVLUL4oo32r2JMYDtKIezmqb7GgIsZdZxzmqQuKKtqIsqL+Kme96sUQhKy15bmQ29C7d0JfvWOkvHgqBphG5Az1JzXNyehmAiJ3PAKfqfu3FctJpsOTNTqbW8LtlFOCU1wPPQ8mU4Ghaz5mTeH5b/9obqXuKunEpe6kfzqVx/ty9Zhhh2PSQAfHZdmQzpXJ3NRFGm+AHCQs+j8SW79Vsrxqgmle5tQHBa+ERhPXBoKtQZXzxWZopERmjZizW+vr57PsKdZuXu1pBnzHLczh7yQpqAmbk/5/k2juqOFOASFHdIHiyO0poaGlRehL0qSLQlCk2Sx6U+UWvd2ak4HYub8V5GgnUV9PLfT3TnyGp+n3l4h1Y5My03xm5EXiJERhcx1Vg==;5:JJ53mFOhA9oQaVRRKBx+rAFURtDSQQTLjjrDlTI3Q7WJG4ifbtKiUheqU3XyCPbOUQiCb2mmwdIwEh0pl1YjAYaZXD/NIZGV6TS0jPmQrgH2kNwo7CfhEJK6vWCk8HcON4K+26QiB51LmQ2V1uZ1WUEA0IpxxRzccfrSm/ofzvQ=;7:AVNd5SIw9ErmE05Gexck5CmC+fZ31V3x+1seQnD5nLtEdCbbEZr65GOFaRU7v7FrySjekQoPxvaeVob597+rAD4G/krpSPJAzcGMe8R2MbKGDSdsvOoe96Ey1FeAab1fx3ZAQ4kelTdWxhYpmgI71MIEEc3i0+bsvVtsm0/E7y0Ae2EA48FLggYByPLd0d+8/TELzJ4yv6WGgHrmZcqIboTPtkRjVX6+76ASsSIeQElUal2AdrFR6gPfWhcndxo7
x-ms-office365-filtering-correlation-id: ce36bcb5-2b43-40b7-fb78-08d6342d5b2a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB4212;
x-ms-traffictypediagnostic: AM0PR04MB4212:
x-microsoft-antispam-prvs: <AM0PR04MB4212421C7D0807F8F42B174CEEFF0@AM0PR04MB4212.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(185117386973197);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231355)(944501410)(52105095)(6055026)(149066)(150057)(6041310)(20161123562045)(20161123558120)(20161123564045)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:AM0PR04MB4212;BCL:0;PCL:0;RULEID:;SRVR:AM0PR04MB4212;
x-forefront-prvs: 08286A0BE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(366004)(346002)(39860400002)(376002)(189003)(199004)(71200400001)(71190400001)(6636002)(446003)(118296001)(11346002)(54906003)(110136005)(52116002)(476003)(2616005)(81166006)(6486002)(81156014)(7736002)(8676002)(50226002)(316002)(256004)(5660300001)(86362001)(305945005)(66066001)(68736007)(53936002)(4326008)(486006)(25786009)(478600001)(44832011)(39060400002)(14454004)(6436002)(6512007)(8936002)(386003)(26005)(76176011)(6346003)(36756003)(97736004)(3846002)(6506007)(6116002)(102836004)(2900100001)(7416002)(2906002)(99286004)(186003)(105586002)(106356001)(5250100002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4212;H:AM0PR04MB4290.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-microsoft-antispam-message-info: CKJUZAaEXmueAGRakQfsUbugDTNy/UbhbluN1TRpK3nu4jiw/KSCbrv7HUer9AabSAjJVfi+Pn7/x8jUX/iRciv1ffT80txfkJPD4JYRxA7aqRZHA3LLA20EL4aWZBTHHKFgR0DSHD/6MJYme6dOPQ8ikYDgqfoj608hiiALSks9v6PNgkI9jkaTqeITKQJFmLooBAkSLXI/IuO2LUbXKProm2y8l3T/U/R8ggS9+F0TXTQ8Rs9OjD9D+VmfsJzsMNlLrLLKQPUY98jM4E6cDnEeo69TcVwb/1DqdgWZO74f0GtgTHoXRFsFd5Y3RPGs3B+i71Wp2fu5zW4/TVMlLfLtqmLlf/QkA0VhV0U/oTQ=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce36bcb5-2b43-40b7-fb78-08d6342d5b2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2018 12:37:53.0962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4212
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181017123753.ycIeIcplETfRqbRKCqQpW1W2ZyCINba6Nql3ytw5-TA@z>

On 6ull and 6sll the DCP block has a clock which needs to be explicitly
enabled.

Add minimal handling for this at probe/remove time.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
---
 drivers/crypto/mxs-dcp.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 4e6ff32f8a7e..a2105cf33abb 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -18,10 +18,11 @@
 #include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/stmp_device.h>
+#include <linux/clk.h>
=20
 #include <crypto/aes.h>
 #include <crypto/sha.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
@@ -80,10 +81,11 @@ struct dcp {
=20
 	struct completion		completion[DCP_MAX_CHANS];
 	spinlock_t			lock[DCP_MAX_CHANS];
 	struct task_struct		*thread[DCP_MAX_CHANS];
 	struct crypto_queue		queue[DCP_MAX_CHANS];
+	struct clk			*dcp_clk;
 };
=20
 enum dcp_chan {
 	DCP_CHAN_HASH_SHA	=3D 0,
 	DCP_CHAN_CRYPTO		=3D 2,
@@ -1051,15 +1053,28 @@ static int mxs_dcp_probe(struct platform_device *pd=
ev)
 		return -ENOMEM;
=20
 	/* Re-align the structure so it fits the DCP constraints. */
 	sdcp->coh =3D PTR_ALIGN(sdcp->coh, DCP_ALIGNMENT);
=20
-	/* Restart the DCP block. */
-	ret =3D stmp_reset_block(sdcp->base);
+	/* DCP clock is optional, only used on some SOCs */
+	sdcp->dcp_clk =3D devm_clk_get(dev, "dcp");
+	if (IS_ERR(sdcp->dcp_clk)) {
+		if (sdcp->dcp_clk !=3D ERR_PTR(-ENOENT))
+			return PTR_ERR(sdcp->dcp_clk);
+		sdcp->dcp_clk =3D NULL;
+	}
+	ret =3D clk_prepare_enable(sdcp->dcp_clk);
 	if (ret)
 		return ret;
=20
+	/* Restart the DCP block. */
+	ret =3D stmp_reset_block(sdcp->base);
+	if (ret) {
+		dev_err(dev, "Failed reset\n");
+		goto err_disable_unprepare_clk;
+	}
+
 	/* Initialize control register. */
 	writel(MXS_DCP_CTRL_GATHER_RESIDUAL_WRITES |
 	       MXS_DCP_CTRL_ENABLE_CONTEXT_CACHING | 0xf,
 	       sdcp->base + MXS_DCP_CTRL);
=20
@@ -1092,11 +1107,12 @@ static int mxs_dcp_probe(struct platform_device *pd=
ev)
 	/* Create the SHA and AES handler threads. */
 	sdcp->thread[DCP_CHAN_HASH_SHA] =3D kthread_run(dcp_chan_thread_sha,
 						      NULL, "mxs_dcp_chan/sha");
 	if (IS_ERR(sdcp->thread[DCP_CHAN_HASH_SHA])) {
 		dev_err(dev, "Error starting SHA thread!\n");
-		return PTR_ERR(sdcp->thread[DCP_CHAN_HASH_SHA]);
+		ret =3D PTR_ERR(sdcp->thread[DCP_CHAN_HASH_SHA]);
+		goto err_disable_unprepare_clk;
 	}
=20
 	sdcp->thread[DCP_CHAN_CRYPTO] =3D kthread_run(dcp_chan_thread_aes,
 						    NULL, "mxs_dcp_chan/aes");
 	if (IS_ERR(sdcp->thread[DCP_CHAN_CRYPTO])) {
@@ -1149,10 +1165,14 @@ static int mxs_dcp_probe(struct platform_device *pd=
ev)
 err_destroy_aes_thread:
 	kthread_stop(sdcp->thread[DCP_CHAN_CRYPTO]);
=20
 err_destroy_sha_thread:
 	kthread_stop(sdcp->thread[DCP_CHAN_HASH_SHA]);
+
+err_disable_unprepare_clk:
+	clk_disable_unprepare(sdcp->dcp_clk);
+
 	return ret;
 }
=20
 static int mxs_dcp_remove(struct platform_device *pdev)
 {
@@ -1168,10 +1188,12 @@ static int mxs_dcp_remove(struct platform_device *p=
dev)
 		crypto_unregister_algs(dcp_aes_algs, ARRAY_SIZE(dcp_aes_algs));
=20
 	kthread_stop(sdcp->thread[DCP_CHAN_HASH_SHA]);
 	kthread_stop(sdcp->thread[DCP_CHAN_CRYPTO]);
=20
+	clk_disable_unprepare(sdcp->dcp_clk);
+
 	platform_set_drvdata(pdev, NULL);
=20
 	global_sdcp =3D NULL;
=20
 	return 0;
--=20
2.17.1

