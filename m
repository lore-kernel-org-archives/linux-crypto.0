Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FBFC04EBD
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 15:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A57392086E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 15:58:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="aps+J8Vw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A57392086E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbeJPXs7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Oct 2018 19:48:59 -0400
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:19693
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727223AbeJPXs7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Oct 2018 19:48:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwxBxs/p/8HGOtOEJarpvlBFMC/qTKQkruPOIUQnCFQ=;
 b=aps+J8Vwo2CXfltJWKbX90XiF4PtCd+MgfagpQ6Pfej5B/hI39nU5vhksGuFNFh4r0ksI2XCyofYYidpzHLRWqj8LTkoS4Y3XlAw61qjTUxKbskIJJh6R1yfFU2IMBQoN46DFSva7hmhZgPrEY8mL3yXucy7+SxTbJPh6tDxrAM=
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com (52.134.126.145) by
 AM0PR04MB4019.eurprd04.prod.outlook.com (52.134.90.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1228.23; Tue, 16 Oct 2018 15:57:43 +0000
Received: from AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef]) by AM0PR04MB4290.eurprd04.prod.outlook.com
 ([fe80::3836:6416:4ebd:34ef%3]) with mapi id 15.20.1228.027; Tue, 16 Oct 2018
 15:57:43 +0000
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
Subject: [PATCH v3 2/4] crypto: mxs-dcp - Add support for dcp clk
Thread-Topic: [PATCH v3 2/4] crypto: mxs-dcp - Add support for dcp clk
Thread-Index: AQHUZWj5i/DYKbq7fkKcieuhPA7M6A==
Date:   Tue, 16 Oct 2018 15:57:43 +0000
Message-ID:
 <dcbcaf888bbd0a35dcf34228df2d9eb4fd762ea7.1539705286.git.leonard.crestez@nxp.com>
References: <cover.1539705285.git.leonard.crestez@nxp.com>
In-Reply-To: <cover.1539705285.git.leonard.crestez@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.76.156.53]
x-mailer: git-send-email 2.17.1
x-clientproxiedby: AM6P193CA0008.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:3e::21) To AM0PR04MB4290.eurprd04.prod.outlook.com
 (2603:10a6:208:67::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonard.crestez@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;AM0PR04MB4019;6:L77Xtm2mDUPQUTN8Nrjwvrg53qPm5QxbItS/PqQMm2QHyNtdWKQk8vocbljjPnMwNJhJ0YxoK/2vCqUPJXmU/y72RCDSDopbJcFNRGxZDoYxO5NYbKSJloVUB0K6q2miQqtVZWlk6kdrvgkGDJnCrjy6ewtu7weudve6AY9GyMJd/OOCZOxkaES2/SBoCg7xU7N11Sbw6Qiu3vjfggkUtAGbsSyqDn1jUo3Rx3w+UbUXDgRwe/0K/3nYNP5XvesrHUaXC+BTr33N7r0cOgZ6o6GbsZPYgH3X4nXo37x9TxOpz9mAtVo5tltzMkH0vI1h8sqiRLPE56sjYQEy8Wj2ppB71ZuotIevD3LiC0aPvKhA+osKYQCC3ivfk0+sXu95wXxTlTINSLCooLjWVOLHrRSOJWVfSokQ6/775jTUg8t9SoMngF2C9IezicbWyEuCB9UlU/lsMDDdl9975OTVBA==;5:ff+AlwpuuOjb4PyVqVX3KlCdCY+0WcfrA9luuBeOurG3jJPlqMzL6x4kk8yXR4WGke5VLiEYSPYP8MZHTBpDg1qI7ILDnGl7cB4ywF71uH1/kbaFXep8Sz/JB1F97Gdk8N/pjkQ0Rzmzv+K4egqP2xpubdtfz34mUJU4j7r/E+w=;7:id83TivZXBNg9WSXGgN8WhY7G8Ns5ZMmUpeZ0tQXq19SIHx1nTYX6PYd/LDqz+5K+3vUwsO8pUjsEHS1F3kGnL+HCUkoWHowG3g6VHnVNFzvfo32HOWH8lv21XoUE0p0F8m8pxXJZQ0d5HAIFdpas4IT6HrqRRyGqGd3zKAT0l2QaODhfdOgJzkFFFJ2UMygnOVICnXYd/42fhIUgLfTVFFtI18TYGulRBGs39XPckVF7MTbTco1LU8Kou+p9DxN
x-ms-office365-filtering-correlation-id: 2925a66c-7d36-4b97-832a-08d633801b6c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(4618075)(2017052603328)(7153060)(7193020);SRVR:AM0PR04MB4019;
x-ms-traffictypediagnostic: AM0PR04MB4019:
x-microsoft-antispam-prvs: <AM0PR04MB401938F195573F4CDCB22F63EEFE0@AM0PR04MB4019.eurprd04.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(185117386973197);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(8211001083)(6040522)(2401047)(8121501046)(5005006)(3002001)(3231355)(944501410)(52105095)(10201501046)(93006095)(93001095)(6055026)(149066)(150057)(6041310)(20161123560045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123564045)(20161123558120)(20161123562045)(201708071742011)(7699051)(76991067);SRVR:AM0PR04MB4019;BCL:0;PCL:0;RULEID:;SRVR:AM0PR04MB4019;
x-forefront-prvs: 0827D7ACB9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(346002)(366004)(396003)(199004)(189003)(2616005)(14454004)(118296001)(68736007)(39060400002)(110136005)(54906003)(316002)(52116002)(81166006)(14444005)(81156014)(71190400001)(71200400001)(99286004)(6636002)(2906002)(36756003)(2900100001)(7736002)(5250100002)(5660300001)(7416002)(186003)(97736004)(256004)(26005)(305945005)(106356001)(105586002)(6486002)(386003)(76176011)(6506007)(25786009)(486006)(50226002)(44832011)(478600001)(66066001)(86362001)(8936002)(6116002)(6436002)(446003)(3846002)(102836004)(8676002)(476003)(53936002)(11346002)(6512007)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4019;H:AM0PR04MB4290.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 1Ul8nj8fQpl3LgsxLnidKqpSEpKYB2wufWzjy5zqKch0ULXPl8/hlgDm9vOocWa8KpUTsueUdYHWPPOxNU35JfT6qLV5zgdmqf1CnDqSe+fkHx5zB/NXLX5Tvo2OPJThQ0jIFGqvmx5V/pvJTEI+aOR/5ueUtkfZwaQzggzGPppgcUd6pf5KZplRpZmbX58M+21HyMluYjkmFMHGj8Jva9XSvz4Aek0om8sXrmyx09xYTFHzBkwgN5Bgg5+vdOEo8c0wAE5KrgKZmh4xp/sqr4h4RlFW4FLWZ2l7t/E9/BW+hTPcmFQ8NzlCJKR0jVH0v4jYa5gb7BVFv3ru3bIEUuAxyZMgEIpLW8b29wFMGmM=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2925a66c-7d36-4b97-832a-08d633801b6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2018 15:57:43.1192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4019
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181016155743.GyARz2pqu2H9P3xdsoamPI-1AIAaJMZET6nuVA4fQ8Q@z>

On 6ull and 6sll the DCP block has a clock which needs to be explicitly
enabled.

Add minimal handling for this at probe/remove time.

Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
---
 drivers/crypto/mxs-dcp.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 4e6ff32f8a7e..a9855f622e05 100644
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
@@ -1027,10 +1029,21 @@ static int mxs_dcp_probe(struct platform_device *pd=
ev)
 	sdcp->dev =3D dev;
 	sdcp->base =3D devm_ioremap_resource(dev, iores);
 	if (IS_ERR(sdcp->base))
 		return PTR_ERR(sdcp->base);
=20
+	/* DCP clock is optional, only used on some SOCs */
+	sdcp->dcp_clk =3D devm_clk_get(dev, "dcp");
+	if (IS_ERR(sdcp->dcp_clk)) {
+		if (sdcp->dcp_clk !=3D ERR_PTR(-ENOENT))
+			return PTR_ERR(sdcp->dcp_clk);
+		sdcp->dcp_clk =3D NULL;
+	}
+
+	ret =3D clk_prepare_enable(sdcp->dcp_clk);
+	if (ret)
+		return ret;
=20
 	ret =3D devm_request_irq(dev, dcp_vmi_irq, mxs_dcp_irq, 0,
 			       "dcp-vmi-irq", sdcp);
 	if (ret) {
 		dev_err(dev, "Failed to claim DCP VMI IRQ!\n");
@@ -1168,10 +1181,12 @@ static int mxs_dcp_remove(struct platform_device *p=
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

