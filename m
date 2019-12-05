Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB97C43603
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CD18224F8
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 09:53:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="obB0rWTi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfLEJxy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 04:53:54 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:1122 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729304AbfLEJxx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 04:53:53 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: PNgXXz95UjId+Hb3U2+E8Kpn9FGmn6ik2/Om4Eu7+iahHgJnPDMKq5PxnCM4GsDhuDtIVyO/A3
 SctJJuAUext6B0n6dCMHn+XizyT/3+dh1gqtEoNW2i8PheYCucO7vltVj/XutH9gHBT1EDE8ZX
 1nblrHbr7IaeRzZzNsVgN92Y5BsVvJcd2j5cFC5oF6SS7hNCDYgwcIJqNhQQpU7DeYRrlDXJeh
 fyz5dOTCSB0WueQGbzvKHShKWfjtWoe+62mFd6uVt/eYDj8isVH0hlvGBnt//97/eiImvEHIem
 XIg=
X-IronPort-AV: E=Sophos;i="5.69,281,1571727600"; 
   d="scan'208";a="56727485"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2019 02:53:52 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Dec 2019 02:53:49 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Dec 2019 02:53:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+wMCodjntEXyRsZzkB7b0IEhNjOq4KdL9KVVBzbSFlgxGr3sFC6ggUN3vpsWr1pQoV8/yYLHlk5VIXiFlj+jeDLFyZxFsAR8akc70H3u6TCWNDAbf2PW6GtR4EBeATemhqKJ/sg2xdRfTDC2bAyIASD+PWv+urQHvBIK2GwH5C5cv7e0Ln4jCS5mV+BbDQSErnlE1GoCJ+A7HuTUte9EJW/5p0Y+ONCR8KpE/3BwGzO0FZZeBSSyidNS3IgVzMV+nF28nqnkfQQZPqqp12d4780nnrcYf6EDlwrdB+3s78xmFNC/bHA6HVs9XykkzGBOVVEbokryVJ1YISNsEZJaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ldXAqFTjbIpsLqqTAA6PBPnNaB2lxCFmQ+XhJThz9tM=;
 b=RHqzzVTaEM4j/qU4/z6PqTdAYfJuMKSKRoWkivQeOMHx9dB5cOu+H0A6sldW3TUWwl3sQl5dQ4DZuHBZ7SBSzs4SlsCeJQGi/ym63x06YSQcnJmO8lIFyiuJgm9B1VVqrQQX/zHEyQaXy+1Lo+hTwuWDe82YbaSQNp/Av5QfLXcYUYkcppyUpfZtSX/Fnpc/mGhRME77KqohW4O14KyUsRwX3D1dZB5FESX6c6QbLVjo/+c6TUkmf76iUVFkeCVNPtDxqiEGUnogufY4PzMCujJKCmsDDGWor2MmeAQ91qpq+zcJxftNhCrPeIyZVe58WA6D3LEGPgbl6uR+EufqMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ldXAqFTjbIpsLqqTAA6PBPnNaB2lxCFmQ+XhJThz9tM=;
 b=obB0rWTilb8cjAkTAop9XF4ioTtwF6C8n2QGyJmAanOIF0DIv6CXasJvbAZFjDxqyRMl2nvEQDr6FfKqzJCOJNmVAWhc0H0HfEFWm5en9E79tfQwVli2TA7m1xgjJueZ8WGzVqIzh/BX9ehRU+CJnk+4bPkep5sR8syv/BE1o7s=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3677.namprd11.prod.outlook.com (20.178.253.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 09:53:48 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::84c:6e75:22df:cbc9%5]) with mapi id 15.20.2495.026; Thu, 5 Dec 2019
 09:53:48 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Tudor.Ambarus@microchip.com>
Subject: [PATCH 03/16] crypto: atmel-tdes - Remove unused header includes
Thread-Topic: [PATCH 03/16] crypto: atmel-tdes - Remove unused header includes
Thread-Index: AQHVq1HkXDSMVXrvFESo+HMrRCMz0g==
Date:   Thu, 5 Dec 2019 09:53:48 +0000
Message-ID: <20191205095326.5094-4-tudor.ambarus@microchip.com>
References: <20191205095326.5094-1-tudor.ambarus@microchip.com>
In-Reply-To: <20191205095326.5094-1-tudor.ambarus@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.14.5
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b3d298f-fb04-49ea-be7b-08d779690664
x-ms-traffictypediagnostic: MN2PR11MB3677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB367731A065362CCEFA87979EF05C0@MN2PR11MB3677.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:374;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(2616005)(66556008)(305945005)(66476007)(66446008)(102836004)(64756008)(11346002)(5660300002)(52116002)(76176011)(99286004)(36756003)(66946007)(4744005)(2906002)(54906003)(26005)(6916009)(6506007)(1076003)(8676002)(6486002)(4326008)(50226002)(1730700003)(8936002)(14454004)(81156014)(186003)(86362001)(81166006)(5640700003)(478600001)(6512007)(71200400001)(25786009)(316002)(71190400001)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3677;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UdkKF+YnD2nYiamonXrfJ2mc/d/449dayWSaJeMRceSPMC4hjETQGnPO5pSof6DTEnjPK6Bkyal351EaXhx4EnwgRSVK7l7yh8VRxMS4im2AG8k0b+Enq1Ju/oDWmHwM+dd9niGFEbG9xNWT7QHI4EFqHC4pCUqvC04t7hIBLUUkY4P77279V82YLIR3FIW9uZ+F4Y2d6T0KW2WEwE7plfwprrWNqlgh8sbQ2ySqcPO8rLcywWUKBvOILvbWYcKp+hShacuSZsbzKUr2CmYGlep4wjqi0iKaAC6dMyDiB9uwifuPvr9Va49iDL+YGIpuJDVmq3rV1UjJTDOXKcZay0CVMWkFVwFY6KzSSFM4yCgnDj7XSrIMTnKzC8n06wpg6mXHH1h3C55/o0fQJW9u1wTonvNJnaYo9uyQKTJfVfxq3a5NId/9ZOCBS++HWGGB
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b3d298f-fb04-49ea-be7b-08d779690664
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 09:53:48.4375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: poDPU+RMrqE9k2OGoxpEmOxeLOFrhRla0FD3MXqzb745IsSmakbC3b/XK3izxtAVFJKrHJShD0RBOVeen7711gi8v230MhKv6HLyxsn32NY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3677
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

Hash headers are not used.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-tdes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index a6b36abba3d1..1b1767ca9444 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -30,12 +30,9 @@
 #include <linux/of_device.h>
 #include <linux/delay.h>
 #include <linux/crypto.h>
-#include <linux/cryptohash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/des.h>
-#include <crypto/hash.h>
-#include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/platform_data/crypto-atmel.h>
 #include "atmel-tdes-regs.h"
--=20
2.14.5

