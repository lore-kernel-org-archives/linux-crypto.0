Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00CDC5DF62
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 09:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32D362075C
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 09:30:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nokia.onmicrosoft.com header.i=@nokia.onmicrosoft.com header.b="RxLA8So9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfKFJaz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 04:30:55 -0500
Received: from mail-eopbgr70123.outbound.protection.outlook.com ([40.107.7.123]:42606
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726969AbfKFJaz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 04:30:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCafYu+20QvPLjLIyYwPlrKBglGht8e4GOF/plcFrx5nBg1SMHKUxXXnhhCAwUJ1cgU5RYsRcP/wizPJLaYZTmQjiFq/jxT0Br3z2XZ1YdAVDz4JSdFboSeMln2E+ZiKNC9tCeKssQB3zjlxifNo3QHLIhpUTg0gzdKdElPGf6dbB2G2P69wHMAYf+Jt/cUm0g+huuzw6EaM/1NdPr7pirSz8lVk77V+eZ1xBjIoTYmH4qSrq7GoBDuIO4Fz7QOsCDh6Njxnwrpqp6sjtwn4wPxG3d9vF9r6YNKsNq9Oz8B5UeTNv31Jc5rQKS23kAl98l8eoWXTqw0HDywypor7Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nyXs5dyqIgeDM4giU1He8XQNXenqZuVRFE9b1KYmKc=;
 b=A4moI60TkdFukCiI9HKlZtTsJFx8sx6bnd2bGQuzPlJrQdbUPq1zqGqDkQasM90bUFQaNYtyOwarbwqDEllMTZPCEpgMXOymsezDq1ZeELnPYQ+p70ptfB7IyeSkSApRN/iZYE8b2i9Tpf9XXVzmTY7ygd+/9O8GQBjIrYAc50onYRCGG6/JsOcNdOtEJjtpzybyUM8f8o+w334Pka2RFej9OvPMm36FDYkFZ5l+xjWv9L7te6B63ykOlNFrftaqAt5uZs4ySY0Gy6F0OTLudMLQTy8cyiKnhtnj/diSBMlxDh1XpKeA/QrzGlU+t0wRFY6W0su8evihNy4HntHYQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nyXs5dyqIgeDM4giU1He8XQNXenqZuVRFE9b1KYmKc=;
 b=RxLA8So9xr3BzhbCbHtVwgvFTkVDCdivq01Y5gqlWNrK/E8DUb9SHV6kDs6/R1ITCq7eupFOA8135YDRAOD1e77uwqEDmBR90NWGBpr976UDyx3vJlBZebKxIgmDu7kRk0TIuE5Zpw+TQcMKL6RSAPyuy/1XbQlk6OZWHzLJZJE=
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com (20.177.203.20) by
 VI1PR07MB5373.eurprd07.prod.outlook.com (20.178.14.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.16; Wed, 6 Nov 2019 09:30:49 +0000
Received: from VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::ec3b:5048:b5f7:2826]) by VI1PR07MB5040.eurprd07.prod.outlook.com
 ([fe80::ec3b:5048:b5f7:2826%5]) with mapi id 15.20.2430.020; Wed, 6 Nov 2019
 09:30:49 +0000
From:   "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH] hwrng: ks-sa: Add minimum sleep time before ready-polling
Thread-Topic: [PATCH] hwrng: ks-sa: Add minimum sleep time before
 ready-polling
Thread-Index: AQHVlITg0NE8JAzt00OCpvrM5iYilQ==
Date:   Wed, 6 Nov 2019 09:30:49 +0000
Message-ID: <20191106093019.117233-1-alexander.sverdlin@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.228.32.181]
x-mailer: git-send-email 2.23.0
x-clientproxiedby: HE1PR05CA0384.eurprd05.prod.outlook.com
 (2603:10a6:7:94::43) To VI1PR07MB5040.eurprd07.prod.outlook.com
 (2603:10a6:803:9c::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexander.sverdlin@nokia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4d1b35ef-0ba8-49de-ff1a-08d7629c026e
x-ms-traffictypediagnostic: VI1PR07MB5373:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR07MB537311D5B9A1C2D1F5B3D65288790@VI1PR07MB5373.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(396003)(39860400002)(136003)(199004)(189003)(54906003)(14454004)(4326008)(486006)(476003)(2616005)(478600001)(2351001)(66066001)(6512007)(66946007)(5660300002)(66476007)(64756008)(66556008)(66446008)(25786009)(3846002)(6916009)(7736002)(305945005)(6116002)(6436002)(5640700003)(6486002)(1076003)(36756003)(2501003)(256004)(316002)(2906002)(102836004)(81166006)(8676002)(81156014)(26005)(52116002)(71200400001)(6506007)(386003)(99286004)(71190400001)(186003)(8936002)(86362001)(50226002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB5373;H:VI1PR07MB5040.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UMNilg0pmFrJJqgtgqn/pjJVyTrtuGB8On7lvvCbmmxWrcVvE+ExXKVRzMS0HdDKeAqUI1I3mXw2zgEw1317dZO+XGldcTkJrVJlVLV6W8k6wPvXs92xPhfr3ykCWl2lOO6CnifnjnaT3h2xarmdq9wLjs/tNJKZrttHp51z2PiuxiRUPc0zPJN3wlq4W2KMPQA+VEygiPh2aIcPnhXzM/0YetgZY/eWRwf6QSOZAt/5QTiVC4/Ji+ZU/rqvms66ZQWY1OmGh13lvbUMYYjVQLtzp+/Tg75mELH87IyiypiXiKPVXM4yMt6yUNsYD9q0RlOLnHJIlrijxfZQDZ3o+4HB1wCs6MWbrofiw+g1LHAueA3dn/BfkY0BvoGXSxl60qII9mpEDg3f5lsVDe9xlg/x0LN3cwusQHVMKnF6qEzPDhtJoTwxcco9aUpOQVE2
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d1b35ef-0ba8-49de-ff1a-08d7629c026e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 09:30:49.2732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mrcmct90cRdYxyZO1EWAdW+XXBpxgQ7b2hVDvQAonFcFVX58xTMbLtHE5xzoLSZ52ZrfHQp0fZfRcuhJV2ZPocqLct2MRaGe/FYcW+A760A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB5373
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

Current polling timeout is 25 us. The hardware is currently configured to
harvest the entropy for 81920 us. This leads to timeouts even during
blocking read (wait=3D1).

Log snippet:
[    5.727589] [<c040ffcc>] (ks_sa_rng_probe) from [<c04181e8>] (platform_d=
rv_probe+0x58/0xb4)
...
[    5.727805] hwrng: no data available
...
[   13.157016] random: systemd: uninitialized urandom read (16 bytes read)
[   13.157033] systemd[1]: Initializing machine ID from random generator.
...
[   15.848770] random: fast init done
...
[   15.848807] random: crng init done

After the patch:
[    6.223534] random: systemd: uninitialized urandom read (16 bytes read)
[    6.223551] systemd[1]: Initializing machine ID from random generator.
...
[    6.876075] random: fast init done
...
[    6.954200] random: systemd: uninitialized urandom read (16 bytes read)
[    6.955244] random: systemd: uninitialized urandom read (16 bytes read)
...
[    7.121948] random: crng init done

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
---
 drivers/char/hw_random/ks-sa-rng.c | 38 ++++++++++++++++++++++++++++++++++=
++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/char/hw_random/ks-sa-rng.c b/drivers/char/hw_random/ks=
-sa-rng.c
index a674300..4b223cb 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -21,6 +21,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/delay.h>
+#include <linux/timekeeping.h>
=20
 #define SA_CMD_STATUS_OFS			0x8
=20
@@ -85,13 +86,36 @@ struct ks_sa_rng {
 	struct clk	*clk;
 	struct regmap	*regmap_cfg;
 	struct trng_regs *reg_rng;
+	u64 ready_ts;
+	unsigned int refill_delay_ns;
 };
=20
+static unsigned int cycles_to_ns(unsigned long clk_rate, unsigned int cycl=
es)
+{
+	return DIV_ROUND_UP_ULL((TRNG_DEF_CLK_DIV_CYCLES + 1) * 1000000000ull *
+				cycles, clk_rate);
+}
+
+static unsigned int startup_delay_ns(unsigned long clk_rate)
+{
+	if (!TRNG_DEF_STARTUP_CYCLES)
+		return cycles_to_ns(clk_rate, BIT(24));
+	return cycles_to_ns(clk_rate, 256 * TRNG_DEF_STARTUP_CYCLES);
+}
+
+static unsigned int refill_delay_ns(unsigned long clk_rate)
+{
+	if (!TRNG_DEF_MAX_REFILL_CYCLES)
+		return cycles_to_ns(clk_rate, BIT(24));
+	return cycles_to_ns(clk_rate, 256 * TRNG_DEF_MAX_REFILL_CYCLES);
+}
+
 static int ks_sa_rng_init(struct hwrng *rng)
 {
 	u32 value;
 	struct device *dev =3D (struct device *)rng->priv;
 	struct ks_sa_rng *ks_sa_rng =3D dev_get_drvdata(dev);
+	unsigned long clk_rate =3D clk_get_rate(ks_sa_rng->clk);
=20
 	/* Enable RNG module */
 	regmap_write_bits(ks_sa_rng->regmap_cfg, SA_CMD_STATUS_OFS,
@@ -120,6 +144,10 @@ static int ks_sa_rng_init(struct hwrng *rng)
 	value |=3D TRNG_CNTL_REG_TRNG_ENABLE;
 	writel(value, &ks_sa_rng->reg_rng->control);
=20
+	ks_sa_rng->refill_delay_ns =3D refill_delay_ns(clk_rate);
+	ks_sa_rng->ready_ts =3D ktime_get_ns() +
+			      startup_delay_ns(clk_rate);
+
 	return 0;
 }
=20
@@ -144,6 +172,7 @@ static int ks_sa_rng_data_read(struct hwrng *rng, u32 *=
data)
 	data[1] =3D readl(&ks_sa_rng->reg_rng->output_h);
=20
 	writel(TRNG_INTACK_REG_READY, &ks_sa_rng->reg_rng->intack);
+	ks_sa_rng->ready_ts =3D ktime_get_ns() + ks_sa_rng->refill_delay_ns;
=20
 	return sizeof(u32) * 2;
 }
@@ -152,10 +181,19 @@ static int ks_sa_rng_data_present(struct hwrng *rng, =
int wait)
 {
 	struct device *dev =3D (struct device *)rng->priv;
 	struct ks_sa_rng *ks_sa_rng =3D dev_get_drvdata(dev);
+	u64 now =3D ktime_get_ns();
=20
 	u32	ready;
 	int	j;
=20
+	if (wait && now < ks_sa_rng->ready_ts) {
+		/* Max delay expected here is 81920000 ns */
+		unsigned long min_delay =3D
+			DIV_ROUND_UP((u32)(ks_sa_rng->ready_ts - now), 1000);
+
+		usleep_range(min_delay, min_delay + SA_RNG_DATA_RETRY_DELAY);
+	}
+
 	for (j =3D 0; j < SA_MAX_RNG_DATA_RETRIES; j++) {
 		ready =3D readl(&ks_sa_rng->reg_rng->status);
 		ready &=3D TRNG_STATUS_REG_READY;
--=20
2.4.6

