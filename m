Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013070.outbound.protection.outlook.com [40.107.162.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932D244A3E2;
	Wed,  9 Sep 2026 07:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788938596; cv=fail; b=KaH/r3U6sGlrGEeC9hkydv2QJQZ+BltzrVIn4GfvzM1Dnb5Ksq1DxR2K3nDfNU9IvdASDMJYTX3hpeEtMpQJrtEpOyXaooSwxmv1TYJE8pj5HHC2gdZe186Qp/wM538UOfnje11bxYoPBRQy8DaJC/gCi97EbWNVGIkW3/Ubous=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788938596; c=relaxed/simple;
	bh=GWysqxa8kNMNcWOesBtvgLdTu2LDP/rxi6JBrmdk510=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uGVtU2XA7I9o1tLt6XkwaMbXf5yB7pdEM7Z53b9P+c6JilHJYn2rrswLv3clFPzw9tl5dTGZvcGCMgAc6CC06IVkm+U1kTPn9OF56Oc5B3XDwRtmaMToJSTmejdTEAI8+oYMmiVHtrabO08cSjhpz666sXCPuf8Te7JrzOswcAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=biDlPatf; arc=fail smtp.client-ip=40.107.162.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="biDlPatf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lMRpqU9yiIVO/eUKJi4EPTSO+LmC58AsluhtcH1FDpmXpTP5aaF/yA93v2cRbXWy01616gv1PuC8HKMUIJQtWS6O1q1PqBM2fPUchqNZ6VoaXCDBh6sfcUTIrKtExRUSOkU52vp1XfJ50sP6K32QrraNP1jPeFYr82y9SkTwLMNSkqlN4QU74H/YKiAtyvvpKdqX7xVU/PLXkPmaq4xU/CNrhOiOjWnv3Z3kqBaUHg92zJqr1ISAXEZlFqJ/TLnv4OZmlfsdx4O4jG8t+fsnIOcfokmG3cgbIcL/++2d5QScC+vqmpZvYOukOdKHoABziuapfcflcNSW7cOVJW2FkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TpMUK0K+xLdPEk3dfmLGpRQBWQZRjbsXKX2rSWu7JHw=;
 b=JEv4arLQm5sj6epckOmyamUG34bGutm5iKf9JUsI32m92WI9gon9C+qzY+G8Ua3YUsm2jBpTZGtyAfZNH2IaA56407LBIrCo6fLp0oNkx3CykHc9nA5Alp2ogH4Wu0s8Oc2FsXkzbWkP6VL/SvhrG3Fi7HLCSzktrdgyqPI5A38PkfSR7Ev+YwDLCwPIA0ovHfov08PflB78a3Tq51+QNttBepIIgdDCETww9vUMag+yp2mkZQPSE/0Bt+y9wpTowjoZFvc3o19rHX7frqWBvJZ1JHNgdWf+keuPywyYppc758Eefh0ik6ePczF7heHtz5k/Us+IRChCxS2YJcInAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TpMUK0K+xLdPEk3dfmLGpRQBWQZRjbsXKX2rSWu7JHw=;
 b=biDlPatf/Z+Jc2Zd+xUPh/qaAIaekBSM026ChoB0rXwzFLZVu6u6nqqECiNYPWN3WuPWNJNwkLLYBAGB5N0XCNQqGwp+Ve1PqMBsvKOxYcYOY9aD63qE3YfegkJccyl1JViYgFg03NrkoI9nLBFPlNLBXM/qdDZ7cZLr8dCn8MkZM5CQLr5edN9CAT4GaE3OI/cvb8A4EkTxr/52NtXy0V2aLapRwccThzJzT3MssaB9zV7BGXVxcn9bX+RQqjfHm1fJry2bu7GfSSHTRWvnQCt3I+Ov2NVMaSNghxqPuzSXhBtbtcHaIR+YGKGbxKrsRfXI/etaiBeSzGOkC2OAaw==
Received: from MI9PR04MB012790.eurprd04.prod.outlook.com
 (2603:10a6:290:84::16) by PA6PR04MB11832.eurprd04.prod.outlook.com
 (2603:10a6:102:520::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Wed, 9 Sep 2026
 07:23:08 +0000
Received: from MI9PR04MB012790.eurprd04.prod.outlook.com
 ([fe80::155e:50ac:c15c:45]) by MI9PR04MB012790.eurprd04.prod.outlook.com
 ([fe80::155e:50ac:c15c:45%6]) with mapi id 15.21.0406.005; Wed, 9 Sep 2026
 07:23:06 +0000
From: Varun Sethi <V.Sethi@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Changwei Zou
	<changwei.zou@canonical.com>, Sahil Malhotra <sahil.malhotra@nxp.com>
CC: "davem@davemloft.net" <davem@davemloft.net>, "gaurav.jain@nxp.com"
	<gaurav.jain@nxp.com>, Horia Geanta <horia.geanta@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lukas@wunner.de" <lukas@wunner.de>, Pankaj Gupta <pankaj.gupta@nxp.com>
Subject: RE: [EXT] [PATCH] crypto: caam - Remove public key support
Thread-Topic: [EXT] [PATCH] crypto: caam - Remove public key support
Thread-Index: AQHdPDG2KwHn6Z8QCEqkEBSDTbteDLbF3UzQ
Date: Wed, 9 Sep 2026 07:23:06 +0000
Message-ID:
 <MI9PR04MB0127909030EA9E7CB95700E3F1E8B02@MI9PR04MB012790.eurprd04.prod.outlook.com>
References: <an-6Mew-8fQaf5sb@gondor.apana.org.au>
 <20260821051824.808269-1-changwei.zou@canonical.com>
 <appZMZ7WS-KNaHbc@gondor.apana.org.au>
In-Reply-To: <appZMZ7WS-KNaHbc@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Enabled=True;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SiteId=686ea1d3-bc2b-4c6f-a92c-d99c5c301635;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_SetDate=2026-09-09T07:14:24.0000000Z;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Name=NXP
 Confidential;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_ContentBits=3;MSIP_Label_0d9c909a-577b-4ba2-96de-69ada94b137a_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MI9PR04MB012790:EE_|PA6PR04MB11832:EE_
x-ms-office365-filtering-correlation-id: bf090fa7-10b9-44da-cd3f-08df0e4331a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|19092799006|23010399003|366016|6049299003|10067099003|56012099006|4143699003|11063799006|6133799003|4133799003|3023799007|22082099003|18002099003|13003099007|4053099003|38070700021;
x-microsoft-antispam-message-info:
 sIrUxS6O1LprrYqR5y+C6+y9/+Zx+MWHI4n0kTIv6erCb+cF3Huq46zc8OihBVLEniSgYtixXfPJHU25agb87DnTcgv46iWo2CJfVn26WW0tLghEq24AdZX8yMc+lgE7kvUiGJGVH/x8XLdclMw7rULrgE5xej5SHpS/Bd0imOBBYRfsYJTYRlU2dSWHsv2PXC5+8OmNzp28/IeN5eBRibgeQ9xQzj5WCwCF4AptZs+jRAhDHh1nPbRCxUrgckwv3iPlpYbZbhcWwv36Zy8WfFaxOHQDtg5prsBfuzTM10D6kEjIE0gUsDcpIAd5sHQqdP4E3YygHPED1sDZ1AhfhMCi6nb2ZhySemN6jtVEpHthKEGxai0poJ3Fnio0GND6K268mT+LVUkJW0+gPCOnpRNVZdl6gzaYwR23eMVphq3dJuKMRyzzTxB+jStfFxzDGi89LEo86n+4zexRACenKn6Ak6XFmtS2TFBnkw8Rh8Vb9kNb3q1nCfAUKo+s7tXcm51rn7eelBY3BmByeKh54dajEL71TpXosO3kfAkQRk81MjUivwQHw2cXJF09C/Rg0amsLWhnaO/SIFmZ1RDSXCBNWpXkUAACblERlYmMXDRqo3N370SNoX2eTXA1o4ESnVX5GRD4TLKo0HXgbBVF7PFoICoNl++3DkLx0PiuS2E=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MI9PR04MB012790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(19092799006)(23010399003)(366016)(6049299003)(10067099003)(56012099006)(4143699003)(11063799006)(6133799003)(4133799003)(3023799007)(22082099003)(18002099003)(13003099007)(4053099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?dtXbXLDM+CKyIbuz6N+oIFmLzXLAo3BBx8L8PhJpwSOMgJuLUnOeO4/TPgJQ?=
 =?us-ascii?Q?xXwIaXxqT540Zh1v4ymZ8q+7rLStq18/ZHixjusOSaVobCYRd3Kz72S5RjaS?=
 =?us-ascii?Q?QFPIoJwj5zdByj3K4e2I+CzG3hvasm2b+NiNNzv8jAwqoXngRYAjhtBFTClY?=
 =?us-ascii?Q?Gon9tB1H/KUIErAAv61tzXGLMhxmYlCUeFjB56USYJXIdB4KOEuioGs5zHAQ?=
 =?us-ascii?Q?FshFJ7rjilxKbj9cxgj8kuxTeECx/HmgQbsdawo1t1j97px2KnFVGy7Oywf0?=
 =?us-ascii?Q?ZabnoxJwKI/bD5etLGkSiMJZk6xWVUMBM+tqLHF+fvg9X5FUYHA8HuuBaS+A?=
 =?us-ascii?Q?o54+FQmbJ9mDSXYsSvuaxOmFbp1QgdrQJr2I1oQOZvFp8HUNHqsd1ckPjQeA?=
 =?us-ascii?Q?IBO8qOLb0ttKhtpKmThC7rmLhKggmPpGNk9fulJJ2+NT8seJX1j7dS2gqf3t?=
 =?us-ascii?Q?Z0iSjcF29DuWT+PzjUHBoXWTpgqXRADRPRjzaW0A6wssdtS8Md0LtPMsj5Fd?=
 =?us-ascii?Q?tyoY54hWVSZFJTg2XiirQW6kDOcWkTsEzpmEsouYgooZSRrAfnYG3Icv1a5M?=
 =?us-ascii?Q?MxOs2WQGnXO9E8LDErLcVYm01LULNfjppw569QBD87C7kmfyPezOTKc6qaNM?=
 =?us-ascii?Q?4361OfcuxWE2w/PiZ7CNXcVUG1u4vILExOFjY7/rY2vYQwyCPsXL50ZkoqYh?=
 =?us-ascii?Q?28RlMu82sr6tf3Pn3AZDPZeKVyG34fCZdvWcPSrcSLsPJ58StGKbSnThsUxX?=
 =?us-ascii?Q?IM0z+6tJLlEOTOOV8+8se4piY/rJiSy4oaUaUiQwQ7iEhcn24Y/FhvCx1Ild?=
 =?us-ascii?Q?iDYmqLc/xbK620lXM+r3N2VJEp0OHzz6TKo+F6VPDRr+hLFToQvrj5LyxpMw?=
 =?us-ascii?Q?YJD4Yyf4xqk/ZHul2gXeLTrRrImbdwDUsZh9DLYLhkmngs2UI3vLax3WG0bP?=
 =?us-ascii?Q?NvhA9gDoG4xxPqfJlnZSnHBKdehzmCfhlm11uTh/tL+N0Q8+YkoI0RcaeKQs?=
 =?us-ascii?Q?A2kFuBcABJr6hb0b6B/Be77nROQm18tjEUSQhlbhAVJsFbXbVx0QFgYRPQHE?=
 =?us-ascii?Q?XRuTwafTk9F5nGz7DMgaKR+ezPlq/HjKLwHzOxaGUDiBDpMBCjYTiNM3STvn?=
 =?us-ascii?Q?MSmROs1RpND/nLcjnusIsIS26NjPXlXuvIURLuLWYvua4gAg7/F0Nc9E6ShO?=
 =?us-ascii?Q?Gf3aqERASdWVzTS968o3G/evTbloWwXcoVsBy+EQ1QlTJd7Ntel1Tkh5gSuT?=
 =?us-ascii?Q?JNteXCrU/gfpzKyQAL1rPPpmUZ5GRBuBmVjjTFthWRppiJH10GZIFPbfEDAO?=
 =?us-ascii?Q?3IM9K10vF7BRQby+LR+VehWpWNrqVZCT0yE6FcRNHFVu4vPW1mPg5nAeyK29?=
 =?us-ascii?Q?iIlwiTfhi2yzTxx0NJ3b4UHAmXRtQT9GMCPAZlOkzGLGj48x6exgdc3UmGJq?=
 =?us-ascii?Q?6n6Ss69PeL56RKy+VjixqHINROxEqK2WfmeItIEoZQn69q02RPIIOA9CgvKm?=
 =?us-ascii?Q?3dJgQMvmIUdPqHpjpMDkPOpRsSFQb6GgR+GgUKo6sHd+shZmcjCUzEEYJRj3?=
 =?us-ascii?Q?Rhj4Ka6PYQ0BHZF7Z0dcTMCel5bOgj31QOWkk/b3hinaKYKevC/r7+FIvA+L?=
 =?us-ascii?Q?VEfTdhe+79Mt9gDt0s0ABtrQkHex+0ianu+PSa/VMa5RknZ1zqnZwqQf6BN8?=
 =?us-ascii?Q?/MQAmcQOzFQcwhtPBUTnmbGFvld3XPKrBGM8rmjrlL1vT+2h?=
Content-Type: multipart/signed;
	protocol="application/x-pkcs7-signature";
	micalg=SHA1;
	boundary="----=_NextPart_000_0040_01DD405A.26F1AD70"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MI9PR04MB012790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf090fa7-10b9-44da-cd3f-08df0e4331a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2026 07:23:06.7972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8QSB3Mhv4f/UdQEV5sm6/Akhj1cDS9YLppvzpZqgkD0sOH8wV/1xZexLIL9hS04v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR04MB11832

------=_NextPart_000_0040_01DD405A.26F1AD70
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Herbert,
Gaurav and Meenakshi were maintaining the CAAM driver but have left NXP
sometime back. Sahil Malhotra would be taking up this responsibility now.
Please allow Sahil a few weeks to fully transition into this role.

Regards
Varun
> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: 04 September 2026 11:08 AM
> To: Changwei Zou <changwei.zou@canonical.com>
> Cc: davem@davemloft.net; gaurav.jain@nxp.com; Horia Geanta
> <horia.geanta@nxp.com>; linux-crypto@vger.kernel.org; linux-
> kernel@vger.kernel.org; lukas@wunner.de; Pankaj Gupta
> <pankaj.gupta@nxp.com>
> Subject: [EXT] [PATCH] crypto: caam - Remove public key support
> 
> Caution: This is an external email. Please take care when clicking links
or opening
> attachments. When in doubt, report the message using the 'Report this
email'
> button
> 
> 
> On Fri, Aug 21, 2026 at 03:18:24PM +1000, Changwei Zou wrote:
> >
> > A new version with two patches and a cover letter is available at the
following
> link.
> 
> This driver hasn't been actively maintained for years.
> 
> Let's just remove it:
> 
> ---8<---
> Remove the public key part of the caam driver because it has been
> unmaintained and there are serious bugs in it.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
> deleted file mode 100644
> index cb001aa1de66..000000000000
> --- a/drivers/crypto/caam/caampkc.c
> +++ /dev/null
> @@ -1,1230 +0,0 @@
> -// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> -/*
> - * caam - Freescale FSL CAAM support for Public Key Cryptography
> - *
> - * Copyright 2016 Freescale Semiconductor, Inc.
> - * Copyright 2018-2019, 2023 NXP
> - *
> - * There is no Shared Descriptor for PKC so that the Job Descriptor must
carry
> - * all the desired key parameters, input and output pointers.
> - */
> -#include "compat.h"
> -#include "regs.h"
> -#include "intern.h"
> -#include "jr.h"
> -#include "error.h"
> -#include "desc_constr.h"
> -#include "sg_sw_sec4.h"
> -#include "caampkc.h"
> -#include <crypto/internal/engine.h>
> -#include <linux/dma-mapping.h>
> -#include <linux/err.h>
> -#include <linux/kernel.h>
> -#include <linux/slab.h>
> -#include <linux/string.h>
> -
> -#define DESC_RSA_PUB_LEN       (2 * CAAM_CMD_SZ + SIZEOF_RSA_PUB_PDB)
> -#define DESC_RSA_PRIV_F1_LEN   (2 * CAAM_CMD_SZ + \
> -                                SIZEOF_RSA_PRIV_F1_PDB)
> -#define DESC_RSA_PRIV_F2_LEN   (2 * CAAM_CMD_SZ + \
> -                                SIZEOF_RSA_PRIV_F2_PDB)
> -#define DESC_RSA_PRIV_F3_LEN   (2 * CAAM_CMD_SZ + \
> -                                SIZEOF_RSA_PRIV_F3_PDB)
> -#define CAAM_RSA_MAX_INPUT_SIZE        512 /* for a 4096-bit modulus */
> -
> -/* buffer filled with zeros, used for padding */
> -static u8 *zero_buffer;
> -
> -/*
> - * variable used to avoid double free of resources in case
> - * algorithm registration was unsuccessful
> - */
> -static bool init_done;
> -
> -struct caam_akcipher_alg {
> -       struct akcipher_engine_alg akcipher;
> -       bool registered;
> -};
> -
> -static void rsa_io_unmap(struct device *dev, struct rsa_edesc *edesc,
> -                        struct akcipher_request *req)
> -{
> -       struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
> -
> -       dma_unmap_sg(dev, req->dst, edesc->dst_nents, DMA_FROM_DEVICE);
> -       dma_unmap_sg(dev, req_ctx->fixup_src, edesc->src_nents,
> DMA_TO_DEVICE);
> -
> -       if (edesc->sec4_sg_bytes)
> -               dma_unmap_single(dev, edesc->sec4_sg_dma,
edesc->sec4_sg_bytes,
> -                                DMA_TO_DEVICE);
> -}
> -
> -static void rsa_pub_unmap(struct device *dev, struct rsa_edesc *edesc,
> -                         struct akcipher_request *req)
> -{
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct caam_rsa_key *key = &ctx->key;
> -       struct rsa_pub_pdb *pdb = &edesc->pdb.pub;
> -
> -       dma_unmap_single(dev, pdb->n_dma, key->n_sz, DMA_TO_DEVICE);
> -       dma_unmap_single(dev, pdb->e_dma, key->e_sz, DMA_TO_DEVICE);
> -}
> -
> -static void rsa_priv_f1_unmap(struct device *dev, struct rsa_edesc
*edesc,
> -                             struct akcipher_request *req)
> -{
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct caam_rsa_key *key = &ctx->key;
> -       struct rsa_priv_f1_pdb *pdb = &edesc->pdb.priv_f1;
> -
> -       dma_unmap_single(dev, pdb->n_dma, key->n_sz, DMA_TO_DEVICE);
> -       dma_unmap_single(dev, pdb->d_dma, key->d_sz, DMA_TO_DEVICE);
> -}
> -
> -static void rsa_priv_f2_unmap(struct device *dev, struct rsa_edesc
*edesc,
> -                             struct akcipher_request *req)
> -{
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct caam_rsa_key *key = &ctx->key;
> -       struct rsa_priv_f2_pdb *pdb = &edesc->pdb.priv_f2;
> -       size_t p_sz = key->p_sz;
> -       size_t q_sz = key->q_sz;
> -
> -       dma_unmap_single(dev, pdb->d_dma, key->d_sz, DMA_TO_DEVICE);
> -       dma_unmap_single(dev, pdb->p_dma, p_sz, DMA_TO_DEVICE);
> -       dma_unmap_single(dev, pdb->q_dma, q_sz, DMA_TO_DEVICE);
> -       dma_unmap_single(dev, pdb->tmp1_dma, p_sz, DMA_BIDIRECTIONAL);
> -       dma_unmap_single(dev, pdb->tmp2_dma, q_sz, DMA_BIDIRECTIONAL);
> -}
> -
> -static void rsa_priv_f3_unmap(struct device *dev, struct rsa_edesc
*edesc,
> -                             struct akcipher_request *req)
> -{
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct caam_rsa_key *key = &ctx->key;
> -       struct rsa_priv_f3_pdb *pdb = &edesc->pdb.priv_f3;
> -       size_t p_sz = key->p_sz;
> -       size_t q_sz = key->q_sz;
> -
> -       dma_unmap_single(dev, pdb->p_dma, p_sz, DMA_TO_DEVICE);
> -       dma_unmap_single(dev, pdb->q_dma, q_sz, DMA_TO_DEVICE);
> -       dma_unmap_single(dev, pdb->dp_dma, p_sz, DMA_TO_DEVICE);
> -       dma_unmap_single(dev, pdb->dq_dma, q_sz, DMA_TO_DEVICE);
> -       dma_unmap_single(dev, pdb->c_dma, p_sz, DMA_TO_DEVICE);
> -       dma_unmap_single(dev, pdb->tmp1_dma, p_sz, DMA_BIDIRECTIONAL);
> -       dma_unmap_single(dev, pdb->tmp2_dma, q_sz, DMA_BIDIRECTIONAL);
> -}
> -
> -/* RSA Job Completion handler */
> -static void rsa_pub_done(struct device *dev, u32 *desc, u32 err, void
*context)
> -{
> -       struct akcipher_request *req = context;
> -       struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
> -       struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
> -       struct rsa_edesc *edesc;
> -       int ecode = 0;
> -       bool has_bklog;
> -
> -       if (err)
> -               ecode = caam_jr_strstatus(dev, err);
> -
> -       edesc = req_ctx->edesc;
> -       has_bklog = edesc->bklog;
> -
> -       rsa_pub_unmap(dev, edesc, req);
> -       rsa_io_unmap(dev, edesc, req);
> -       kfree(edesc);
> -
> -       /*
> -        * If no backlog flag, the completion of the request is done
> -        * by CAAM, not crypto engine.
> -        */
> -       if (!has_bklog)
> -               akcipher_request_complete(req, ecode);
> -       else
> -               crypto_finalize_akcipher_request(jrp->engine, req, ecode);
> -}
> -
> -static void rsa_priv_f_done(struct device *dev, u32 *desc, u32 err,
> -                           void *context)
> -{
> -       struct akcipher_request *req = context;
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct caam_rsa_key *key = &ctx->key;
> -       struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
> -       struct rsa_edesc *edesc;
> -       int ecode = 0;
> -       bool has_bklog;
> -
> -       if (err)
> -               ecode = caam_jr_strstatus(dev, err);
> -
> -       edesc = req_ctx->edesc;
> -       has_bklog = edesc->bklog;
> -
> -       switch (key->priv_form) {
> -       case FORM1:
> -               rsa_priv_f1_unmap(dev, edesc, req);
> -               break;
> -       case FORM2:
> -               rsa_priv_f2_unmap(dev, edesc, req);
> -               break;
> -       case FORM3:
> -               rsa_priv_f3_unmap(dev, edesc, req);
> -       }
> -
> -       rsa_io_unmap(dev, edesc, req);
> -       kfree(edesc);
> -
> -       /*
> -        * If no backlog flag, the completion of the request is done
> -        * by CAAM, not crypto engine.
> -        */
> -       if (!has_bklog)
> -               akcipher_request_complete(req, ecode);
> -       else
> -               crypto_finalize_akcipher_request(jrp->engine, req, ecode);
> -}
> -
> -/**
> - * caam_rsa_count_leading_zeros - Count leading zeros, need it to strip,
> - *                                from a given scatterlist
> - *
> - * @sgl   : scatterlist to count zeros from
> - * @nbytes: number of zeros, in bytes, to strip
> - * @flags : operation flags
> - */
> -static int caam_rsa_count_leading_zeros(struct scatterlist *sgl,
> -                                       unsigned int nbytes,
> -                                       unsigned int flags)
> -{
> -       struct sg_mapping_iter miter;
> -       int lzeros, ents;
> -       unsigned int len;
> -       unsigned int tbytes = nbytes;
> -       const u8 *buff;
> -
> -       ents = sg_nents_for_len(sgl, nbytes);
> -       if (ents < 0)
> -               return ents;
> -
> -       sg_miter_start(&miter, sgl, ents, SG_MITER_FROM_SG | flags);
> -
> -       lzeros = 0;
> -       len = 0;
> -       while (nbytes > 0) {
> -               /* do not strip more than given bytes */
> -               while (len && !*buff && lzeros < nbytes) {
> -                       lzeros++;
> -                       len--;
> -                       buff++;
> -               }
> -
> -               if (len && *buff)
> -                       break;
> -
> -               if (!sg_miter_next(&miter))
> -                       break;
> -
> -               buff = miter.addr;
> -               len = miter.length;
> -
> -               nbytes -= lzeros;
> -               lzeros = 0;
> -       }
> -
> -       miter.consumed = lzeros;
> -       sg_miter_stop(&miter);
> -       nbytes -= lzeros;
> -
> -       return tbytes - nbytes;
> -}
> -
> -static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
> -                                        size_t desclen)
> -{
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct device *dev = ctx->dev;
> -       struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
> -       struct caam_rsa_key *key = &ctx->key;
> -       struct rsa_edesc *edesc;
> -       gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
> -                      GFP_KERNEL : GFP_ATOMIC;
> -       int sg_flags = (flags == GFP_ATOMIC) ? SG_MITER_ATOMIC : 0;
> -       int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
> -       int src_nents, dst_nents;
> -       int mapped_src_nents, mapped_dst_nents;
> -       unsigned int diff_size = 0;
> -       int lzeros;
> -
> -       if (req->src_len > key->n_sz) {
> -               /*
> -                * strip leading zeros and
> -                * return the number of zeros to skip
> -                */
> -               lzeros = caam_rsa_count_leading_zeros(req->src,
req->src_len -
> -                                                     key->n_sz,
sg_flags);
> -               if (lzeros < 0)
> -                       return ERR_PTR(lzeros);
> -
> -               req_ctx->fixup_src = scatterwalk_ffwd(req_ctx->src,
req->src,
> -                                                     lzeros);
> -               req_ctx->fixup_src_len = req->src_len - lzeros;
> -       } else {
> -               /*
> -                * input src is less then n key modulus,
> -                * so there will be zero padding
> -                */
> -               diff_size = key->n_sz - req->src_len;
> -               req_ctx->fixup_src = req->src;
> -               req_ctx->fixup_src_len = req->src_len;
> -       }
> -
> -       src_nents = sg_nents_for_len(req_ctx->fixup_src,
> -                                    req_ctx->fixup_src_len);
> -       dst_nents = sg_nents_for_len(req->dst, req->dst_len);
> -
> -       mapped_src_nents = dma_map_sg(dev, req_ctx->fixup_src, src_nents,
> -                                     DMA_TO_DEVICE);
> -       if (unlikely(!mapped_src_nents)) {
> -               dev_err(dev, "unable to map source\n");
> -               return ERR_PTR(-ENOMEM);
> -       }
> -       mapped_dst_nents = dma_map_sg(dev, req->dst, dst_nents,
> -                                     DMA_FROM_DEVICE);
> -       if (unlikely(!mapped_dst_nents)) {
> -               dev_err(dev, "unable to map destination\n");
> -               goto src_fail;
> -       }
> -
> -       if (!diff_size && mapped_src_nents == 1)
> -               sec4_sg_len = 0; /* no need for an input hw s/g table */
> -       else
> -               sec4_sg_len = mapped_src_nents + !!diff_size;
> -       sec4_sg_index = sec4_sg_len;
> -
> -       if (mapped_dst_nents > 1)
> -               sec4_sg_len += pad_sg_nents(mapped_dst_nents);
> -       else
> -               sec4_sg_len = pad_sg_nents(sec4_sg_len);
> -
> -       sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
> -
> -       /* allocate space for base edesc, hw desc commands and link tables
*/
> -       edesc = kzalloc(sizeof(*edesc) + desclen + sec4_sg_bytes, flags);
> -       if (!edesc)
> -               goto dst_fail;
> -
> -       edesc->sec4_sg = (void *)edesc + sizeof(*edesc) + desclen;
> -       if (diff_size)
> -               dma_to_sec4_sg_one(edesc->sec4_sg, ctx->padding_dma,
diff_size,
> -                                  0);
> -
> -       if (sec4_sg_index)
> -               sg_to_sec4_sg_last(req_ctx->fixup_src,
req_ctx->fixup_src_len,
> -                                  edesc->sec4_sg + !!diff_size, 0);
> -
> -       if (mapped_dst_nents > 1)
> -               sg_to_sec4_sg_last(req->dst, req->dst_len,
> -                                  edesc->sec4_sg + sec4_sg_index, 0);
> -
> -       /* Save nents for later use in Job Descriptor */
> -       edesc->src_nents = src_nents;
> -       edesc->dst_nents = dst_nents;
> -
> -       req_ctx->edesc = edesc;
> -
> -       if (!sec4_sg_bytes)
> -               return edesc;
> -
> -       edesc->mapped_src_nents = mapped_src_nents;
> -       edesc->mapped_dst_nents = mapped_dst_nents;
> -
> -       edesc->sec4_sg_dma = dma_map_single(dev, edesc->sec4_sg,
> -                                           sec4_sg_bytes, DMA_TO_DEVICE);
> -       if (dma_mapping_error(dev, edesc->sec4_sg_dma)) {
> -               dev_err(dev, "unable to map S/G table\n");
> -               goto sec4_sg_fail;
> -       }
> -
> -       edesc->sec4_sg_bytes = sec4_sg_bytes;
> -
> -       print_hex_dump_debug("caampkc sec4_sg@" __stringify(__LINE__) ":
",
> -                            DUMP_PREFIX_ADDRESS, 16, 4, edesc->sec4_sg,
> -                            edesc->sec4_sg_bytes, 1);
> -
> -       return edesc;
> -
> -sec4_sg_fail:
> -       kfree(edesc);
> -dst_fail:
> -       dma_unmap_sg(dev, req->dst, dst_nents, DMA_FROM_DEVICE);
> -src_fail:
> -       dma_unmap_sg(dev, req_ctx->fixup_src, src_nents, DMA_TO_DEVICE);
> -       return ERR_PTR(-ENOMEM);
> -}
> -
> -static int akcipher_do_one_req(struct crypto_engine *engine, void *areq)
> -{
> -       struct akcipher_request *req = container_of(areq,
> -                                                   struct
akcipher_request,
> -                                                   base);
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct device *jrdev = ctx->dev;
> -       u32 *desc = req_ctx->edesc->hw_desc;
> -       int ret;
> -
> -       req_ctx->edesc->bklog = true;
> -
> -       ret = caam_jr_enqueue(jrdev, desc, req_ctx->akcipher_op_done,
req);
> -
> -       if (ret == -ENOSPC && engine->retry_support)
> -               return ret;
> -
> -       if (ret != -EINPROGRESS) {
> -               rsa_pub_unmap(jrdev, req_ctx->edesc, req);
> -               rsa_io_unmap(jrdev, req_ctx->edesc, req);
> -               kfree(req_ctx->edesc);
> -       } else {
> -               ret = 0;
> -       }
> -
> -       return ret;
> -}
> -
> -static int set_rsa_pub_pdb(struct akcipher_request *req,
> -                          struct rsa_edesc *edesc)
> -{
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct caam_rsa_key *key = &ctx->key;
> -       struct device *dev = ctx->dev;
> -       struct rsa_pub_pdb *pdb = &edesc->pdb.pub;
> -       int sec4_sg_index = 0;
> -
> -       pdb->n_dma = dma_map_single(dev, key->n, key->n_sz,
DMA_TO_DEVICE);
> -       if (dma_mapping_error(dev, pdb->n_dma)) {
> -               dev_err(dev, "Unable to map RSA modulus memory\n");
> -               return -ENOMEM;
> -       }
> -
> -       pdb->e_dma = dma_map_single(dev, key->e, key->e_sz,
DMA_TO_DEVICE);
> -       if (dma_mapping_error(dev, pdb->e_dma)) {
> -               dev_err(dev, "Unable to map RSA public exponent
memory\n");
> -               dma_unmap_single(dev, pdb->n_dma, key->n_sz,
DMA_TO_DEVICE);
> -               return -ENOMEM;
> -       }
> -
> -       if (edesc->mapped_src_nents > 1) {
> -               pdb->sgf |= RSA_PDB_SGF_F;
> -               pdb->f_dma = edesc->sec4_sg_dma;
> -               sec4_sg_index += edesc->mapped_src_nents;
> -       } else {
> -               pdb->f_dma = sg_dma_address(req_ctx->fixup_src);
> -       }
> -
> -       if (edesc->mapped_dst_nents > 1) {
> -               pdb->sgf |= RSA_PDB_SGF_G;
> -               pdb->g_dma = edesc->sec4_sg_dma +
> -                            sec4_sg_index * sizeof(struct sec4_sg_entry);
> -       } else {
> -               pdb->g_dma = sg_dma_address(req->dst);
> -       }
> -
> -       pdb->sgf |= (key->e_sz << RSA_PDB_E_SHIFT) | key->n_sz;
> -       pdb->f_len = req_ctx->fixup_src_len;
> -
> -       return 0;
> -}
> -
> -static int set_rsa_priv_f1_pdb(struct akcipher_request *req,
> -                              struct rsa_edesc *edesc)
> -{
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct caam_rsa_key *key = &ctx->key;
> -       struct device *dev = ctx->dev;
> -       struct rsa_priv_f1_pdb *pdb = &edesc->pdb.priv_f1;
> -       int sec4_sg_index = 0;
> -
> -       pdb->n_dma = dma_map_single(dev, key->n, key->n_sz,
DMA_TO_DEVICE);
> -       if (dma_mapping_error(dev, pdb->n_dma)) {
> -               dev_err(dev, "Unable to map modulus memory\n");
> -               return -ENOMEM;
> -       }
> -
> -       pdb->d_dma = dma_map_single(dev, key->d, key->d_sz,
DMA_TO_DEVICE);
> -       if (dma_mapping_error(dev, pdb->d_dma)) {
> -               dev_err(dev, "Unable to map RSA private exponent
memory\n");
> -               dma_unmap_single(dev, pdb->n_dma, key->n_sz,
DMA_TO_DEVICE);
> -               return -ENOMEM;
> -       }
> -
> -       if (edesc->mapped_src_nents > 1) {
> -               pdb->sgf |= RSA_PRIV_PDB_SGF_G;
> -               pdb->g_dma = edesc->sec4_sg_dma;
> -               sec4_sg_index += edesc->mapped_src_nents;
> -
> -       } else {
> -               struct caam_rsa_req_ctx *req_ctx =
akcipher_request_ctx(req);
> -
> -               pdb->g_dma = sg_dma_address(req_ctx->fixup_src);
> -       }
> -
> -       if (edesc->mapped_dst_nents > 1) {
> -               pdb->sgf |= RSA_PRIV_PDB_SGF_F;
> -               pdb->f_dma = edesc->sec4_sg_dma +
> -                            sec4_sg_index * sizeof(struct sec4_sg_entry);
> -       } else {
> -               pdb->f_dma = sg_dma_address(req->dst);
> -       }
> -
> -       pdb->sgf |= (key->d_sz << RSA_PDB_D_SHIFT) | key->n_sz;
> -
> -       return 0;
> -}
> -
> -static int set_rsa_priv_f2_pdb(struct akcipher_request *req,
> -                              struct rsa_edesc *edesc)
> -{
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct caam_rsa_key *key = &ctx->key;
> -       struct device *dev = ctx->dev;
> -       struct rsa_priv_f2_pdb *pdb = &edesc->pdb.priv_f2;
> -       int sec4_sg_index = 0;
> -       size_t p_sz = key->p_sz;
> -       size_t q_sz = key->q_sz;
> -
> -       pdb->d_dma = dma_map_single(dev, key->d, key->d_sz,
DMA_TO_DEVICE);
> -       if (dma_mapping_error(dev, pdb->d_dma)) {
> -               dev_err(dev, "Unable to map RSA private exponent
memory\n");
> -               return -ENOMEM;
> -       }
> -
> -       pdb->p_dma = dma_map_single(dev, key->p, p_sz, DMA_TO_DEVICE);
> -       if (dma_mapping_error(dev, pdb->p_dma)) {
> -               dev_err(dev, "Unable to map RSA prime factor p memory\n");
> -               goto unmap_d;
> -       }
> -
> -       pdb->q_dma = dma_map_single(dev, key->q, q_sz, DMA_TO_DEVICE);
> -       if (dma_mapping_error(dev, pdb->q_dma)) {
> -               dev_err(dev, "Unable to map RSA prime factor q memory\n");
> -               goto unmap_p;
> -       }
> -
> -       pdb->tmp1_dma = dma_map_single(dev, key->tmp1, p_sz,
> DMA_BIDIRECTIONAL);
> -       if (dma_mapping_error(dev, pdb->tmp1_dma)) {
> -               dev_err(dev, "Unable to map RSA tmp1 memory\n");
> -               goto unmap_q;
> -       }
> -
> -       pdb->tmp2_dma = dma_map_single(dev, key->tmp2, q_sz,
> DMA_BIDIRECTIONAL);
> -       if (dma_mapping_error(dev, pdb->tmp2_dma)) {
> -               dev_err(dev, "Unable to map RSA tmp2 memory\n");
> -               goto unmap_tmp1;
> -       }
> -
> -       if (edesc->mapped_src_nents > 1) {
> -               pdb->sgf |= RSA_PRIV_PDB_SGF_G;
> -               pdb->g_dma = edesc->sec4_sg_dma;
> -               sec4_sg_index += edesc->mapped_src_nents;
> -       } else {
> -               struct caam_rsa_req_ctx *req_ctx =
akcipher_request_ctx(req);
> -
> -               pdb->g_dma = sg_dma_address(req_ctx->fixup_src);
> -       }
> -
> -       if (edesc->mapped_dst_nents > 1) {
> -               pdb->sgf |= RSA_PRIV_PDB_SGF_F;
> -               pdb->f_dma = edesc->sec4_sg_dma +
> -                            sec4_sg_index * sizeof(struct sec4_sg_entry);
> -       } else {
> -               pdb->f_dma = sg_dma_address(req->dst);
> -       }
> -
> -       pdb->sgf |= (key->d_sz << RSA_PDB_D_SHIFT) | key->n_sz;
> -       pdb->p_q_len = (q_sz << RSA_PDB_Q_SHIFT) | p_sz;
> -
> -       return 0;
> -
> -unmap_tmp1:
> -       dma_unmap_single(dev, pdb->tmp1_dma, p_sz, DMA_BIDIRECTIONAL);
> -unmap_q:
> -       dma_unmap_single(dev, pdb->q_dma, q_sz, DMA_TO_DEVICE);
> -unmap_p:
> -       dma_unmap_single(dev, pdb->p_dma, p_sz, DMA_TO_DEVICE);
> -unmap_d:
> -       dma_unmap_single(dev, pdb->d_dma, key->d_sz, DMA_TO_DEVICE);
> -
> -       return -ENOMEM;
> -}
> -
> -static int set_rsa_priv_f3_pdb(struct akcipher_request *req,
> -                              struct rsa_edesc *edesc)
> -{
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct caam_rsa_key *key = &ctx->key;
> -       struct device *dev = ctx->dev;
> -       struct rsa_priv_f3_pdb *pdb = &edesc->pdb.priv_f3;
> -       int sec4_sg_index = 0;
> -       size_t p_sz = key->p_sz;
> -       size_t q_sz = key->q_sz;
> -
> -       pdb->p_dma = dma_map_single(dev, key->p, p_sz, DMA_TO_DEVICE);
> -       if (dma_mapping_error(dev, pdb->p_dma)) {
> -               dev_err(dev, "Unable to map RSA prime factor p memory\n");
> -               return -ENOMEM;
> -       }
> -
> -       pdb->q_dma = dma_map_single(dev, key->q, q_sz, DMA_TO_DEVICE);
> -       if (dma_mapping_error(dev, pdb->q_dma)) {
> -               dev_err(dev, "Unable to map RSA prime factor q memory\n");
> -               goto unmap_p;
> -       }
> -
> -       pdb->dp_dma = dma_map_single(dev, key->dp, p_sz, DMA_TO_DEVICE);
> -       if (dma_mapping_error(dev, pdb->dp_dma)) {
> -               dev_err(dev, "Unable to map RSA exponent dp memory\n");
> -               goto unmap_q;
> -       }
> -
> -       pdb->dq_dma = dma_map_single(dev, key->dq, q_sz, DMA_TO_DEVICE);
> -       if (dma_mapping_error(dev, pdb->dq_dma)) {
> -               dev_err(dev, "Unable to map RSA exponent dq memory\n");
> -               goto unmap_dp;
> -       }
> -
> -       pdb->c_dma = dma_map_single(dev, key->qinv, p_sz, DMA_TO_DEVICE);
> -       if (dma_mapping_error(dev, pdb->c_dma)) {
> -               dev_err(dev, "Unable to map RSA CRT coefficient qinv
memory\n");
> -               goto unmap_dq;
> -       }
> -
> -       pdb->tmp1_dma = dma_map_single(dev, key->tmp1, p_sz,
> DMA_BIDIRECTIONAL);
> -       if (dma_mapping_error(dev, pdb->tmp1_dma)) {
> -               dev_err(dev, "Unable to map RSA tmp1 memory\n");
> -               goto unmap_qinv;
> -       }
> -
> -       pdb->tmp2_dma = dma_map_single(dev, key->tmp2, q_sz,
> DMA_BIDIRECTIONAL);
> -       if (dma_mapping_error(dev, pdb->tmp2_dma)) {
> -               dev_err(dev, "Unable to map RSA tmp2 memory\n");
> -               goto unmap_tmp1;
> -       }
> -
> -       if (edesc->mapped_src_nents > 1) {
> -               pdb->sgf |= RSA_PRIV_PDB_SGF_G;
> -               pdb->g_dma = edesc->sec4_sg_dma;
> -               sec4_sg_index += edesc->mapped_src_nents;
> -       } else {
> -               struct caam_rsa_req_ctx *req_ctx =
akcipher_request_ctx(req);
> -
> -               pdb->g_dma = sg_dma_address(req_ctx->fixup_src);
> -       }
> -
> -       if (edesc->mapped_dst_nents > 1) {
> -               pdb->sgf |= RSA_PRIV_PDB_SGF_F;
> -               pdb->f_dma = edesc->sec4_sg_dma +
> -                            sec4_sg_index * sizeof(struct sec4_sg_entry);
> -       } else {
> -               pdb->f_dma = sg_dma_address(req->dst);
> -       }
> -
> -       pdb->sgf |= key->n_sz;
> -       pdb->p_q_len = (q_sz << RSA_PDB_Q_SHIFT) | p_sz;
> -
> -       return 0;
> -
> -unmap_tmp1:
> -       dma_unmap_single(dev, pdb->tmp1_dma, p_sz, DMA_BIDIRECTIONAL);
> -unmap_qinv:
> -       dma_unmap_single(dev, pdb->c_dma, p_sz, DMA_TO_DEVICE);
> -unmap_dq:
> -       dma_unmap_single(dev, pdb->dq_dma, q_sz, DMA_TO_DEVICE);
> -unmap_dp:
> -       dma_unmap_single(dev, pdb->dp_dma, p_sz, DMA_TO_DEVICE);
> -unmap_q:
> -       dma_unmap_single(dev, pdb->q_dma, q_sz, DMA_TO_DEVICE);
> -unmap_p:
> -       dma_unmap_single(dev, pdb->p_dma, p_sz, DMA_TO_DEVICE);
> -
> -       return -ENOMEM;
> -}
> -
> -static int akcipher_enqueue_req(struct device *jrdev,
> -                               void (*cbk)(struct device *jrdev, u32
*desc,
> -                                           u32 err, void *context),
> -                               struct akcipher_request *req)
> -{
> -       struct caam_drv_private_jr *jrpriv = dev_get_drvdata(jrdev);
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct caam_rsa_key *key = &ctx->key;
> -       struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
> -       struct rsa_edesc *edesc = req_ctx->edesc;
> -       u32 *desc = edesc->hw_desc;
> -       int ret;
> -
> -       req_ctx->akcipher_op_done = cbk;
> -       /*
> -        * Only the backlog request are sent to crypto-engine since the
others
> -        * can be handled by CAAM, if free, especially since JR has up to
1024
> -        * entries (more than the 10 entries from crypto-engine).
> -        */
> -       if (req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
> -               ret =
crypto_transfer_akcipher_request_to_engine(jrpriv->engine,
> -                                                                req);
> -       else
> -               ret = caam_jr_enqueue(jrdev, desc, cbk, req);
> -
> -       if ((ret != -EINPROGRESS) && (ret != -EBUSY)) {
> -               switch (key->priv_form) {
> -               case FORM1:
> -                       rsa_priv_f1_unmap(jrdev, edesc, req);
> -                       break;
> -               case FORM2:
> -                       rsa_priv_f2_unmap(jrdev, edesc, req);
> -                       break;
> -               case FORM3:
> -                       rsa_priv_f3_unmap(jrdev, edesc, req);
> -                       break;
> -               default:
> -                       rsa_pub_unmap(jrdev, edesc, req);
> -               }
> -               rsa_io_unmap(jrdev, edesc, req);
> -               kfree(edesc);
> -       }
> -
> -       return ret;
> -}
> -
> -static int caam_rsa_enc(struct akcipher_request *req)
> -{
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct caam_rsa_key *key = &ctx->key;
> -       struct device *jrdev = ctx->dev;
> -       struct rsa_edesc *edesc;
> -       int ret;
> -
> -       if (unlikely(!key->n || !key->e))
> -               return -EINVAL;
> -
> -       if (req->dst_len < key->n_sz) {
> -               req->dst_len = key->n_sz;
> -               dev_err(jrdev, "Output buffer length less than parameter
n\n");
> -               return -EOVERFLOW;
> -       }
> -
> -       /* Allocate extended descriptor */
> -       edesc = rsa_edesc_alloc(req, DESC_RSA_PUB_LEN);
> -       if (IS_ERR(edesc))
> -               return PTR_ERR(edesc);
> -
> -       /* Set RSA Encrypt Protocol Data Block */
> -       ret = set_rsa_pub_pdb(req, edesc);
> -       if (ret)
> -               goto init_fail;
> -
> -       /* Initialize Job Descriptor */
> -       init_rsa_pub_desc(edesc->hw_desc, &edesc->pdb.pub);
> -
> -       return akcipher_enqueue_req(jrdev, rsa_pub_done, req);
> -
> -init_fail:
> -       rsa_io_unmap(jrdev, edesc, req);
> -       kfree(edesc);
> -       return ret;
> -}
> -
> -static int caam_rsa_dec_priv_f1(struct akcipher_request *req)
> -{
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct device *jrdev = ctx->dev;
> -       struct rsa_edesc *edesc;
> -       int ret;
> -
> -       /* Allocate extended descriptor */
> -       edesc = rsa_edesc_alloc(req, DESC_RSA_PRIV_F1_LEN);
> -       if (IS_ERR(edesc))
> -               return PTR_ERR(edesc);
> -
> -       /* Set RSA Decrypt Protocol Data Block - Private Key Form #1 */
> -       ret = set_rsa_priv_f1_pdb(req, edesc);
> -       if (ret)
> -               goto init_fail;
> -
> -       /* Initialize Job Descriptor */
> -       init_rsa_priv_f1_desc(edesc->hw_desc, &edesc->pdb.priv_f1);
> -
> -       return akcipher_enqueue_req(jrdev, rsa_priv_f_done, req);
> -
> -init_fail:
> -       rsa_io_unmap(jrdev, edesc, req);
> -       kfree(edesc);
> -       return ret;
> -}
> -
> -static int caam_rsa_dec_priv_f2(struct akcipher_request *req)
> -{
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct device *jrdev = ctx->dev;
> -       struct rsa_edesc *edesc;
> -       int ret;
> -
> -       /* Allocate extended descriptor */
> -       edesc = rsa_edesc_alloc(req, DESC_RSA_PRIV_F2_LEN);
> -       if (IS_ERR(edesc))
> -               return PTR_ERR(edesc);
> -
> -       /* Set RSA Decrypt Protocol Data Block - Private Key Form #2 */
> -       ret = set_rsa_priv_f2_pdb(req, edesc);
> -       if (ret)
> -               goto init_fail;
> -
> -       /* Initialize Job Descriptor */
> -       init_rsa_priv_f2_desc(edesc->hw_desc, &edesc->pdb.priv_f2);
> -
> -       return akcipher_enqueue_req(jrdev, rsa_priv_f_done, req);
> -
> -init_fail:
> -       rsa_io_unmap(jrdev, edesc, req);
> -       kfree(edesc);
> -       return ret;
> -}
> -
> -static int caam_rsa_dec_priv_f3(struct akcipher_request *req)
> -{
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct device *jrdev = ctx->dev;
> -       struct rsa_edesc *edesc;
> -       int ret;
> -
> -       /* Allocate extended descriptor */
> -       edesc = rsa_edesc_alloc(req, DESC_RSA_PRIV_F3_LEN);
> -       if (IS_ERR(edesc))
> -               return PTR_ERR(edesc);
> -
> -       /* Set RSA Decrypt Protocol Data Block - Private Key Form #3 */
> -       ret = set_rsa_priv_f3_pdb(req, edesc);
> -       if (ret)
> -               goto init_fail;
> -
> -       /* Initialize Job Descriptor */
> -       init_rsa_priv_f3_desc(edesc->hw_desc, &edesc->pdb.priv_f3);
> -
> -       return akcipher_enqueue_req(jrdev, rsa_priv_f_done, req);
> -
> -init_fail:
> -       rsa_io_unmap(jrdev, edesc, req);
> -       kfree(edesc);
> -       return ret;
> -}
> -
> -static int caam_rsa_dec(struct akcipher_request *req)
> -{
> -       struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct caam_rsa_key *key = &ctx->key;
> -       int ret;
> -
> -       if (unlikely(!key->n || !key->d))
> -               return -EINVAL;
> -
> -       if (req->dst_len < key->n_sz) {
> -               req->dst_len = key->n_sz;
> -               dev_err(ctx->dev, "Output buffer length less than
parameter n\n");
> -               return -EOVERFLOW;
> -       }
> -
> -       if (key->priv_form == FORM3)
> -               ret = caam_rsa_dec_priv_f3(req);
> -       else if (key->priv_form == FORM2)
> -               ret = caam_rsa_dec_priv_f2(req);
> -       else
> -               ret = caam_rsa_dec_priv_f1(req);
> -
> -       return ret;
> -}
> -
> -static void caam_rsa_free_key(struct caam_rsa_key *key)
> -{
> -       kfree_sensitive(key->d);
> -       kfree_sensitive(key->p);
> -       kfree_sensitive(key->q);
> -       kfree_sensitive(key->dp);
> -       kfree_sensitive(key->dq);
> -       kfree_sensitive(key->qinv);
> -       kfree_sensitive(key->tmp1);
> -       kfree_sensitive(key->tmp2);
> -       kfree(key->e);
> -       kfree(key->n);
> -       memset(key, 0, sizeof(*key));
> -}
> -
> -static void caam_rsa_drop_leading_zeros(const u8 **ptr, size_t *nbytes)
> -{
> -       while (!**ptr && *nbytes) {
> -               (*ptr)++;
> -               (*nbytes)--;
> -       }
> -}
> -
> -/**
> - * caam_read_rsa_crt - Used for reading dP, dQ, qInv CRT members.
> - * dP, dQ and qInv could decode to less than corresponding p, q length,
as the
> - * BER-encoding requires that the minimum number of bytes be used to
encode
> the
> - * integer. dP, dQ, qInv decoded values have to be zero-padded to
appropriate
> - * length.
> - *
> - * @ptr   : pointer to {dP, dQ, qInv} CRT member
> - * @nbytes: length in bytes of {dP, dQ, qInv} CRT member
> - * @dstlen: length in bytes of corresponding p or q prime factor
> - */
> -static u8 *caam_read_rsa_crt(const u8 *ptr, size_t nbytes, size_t dstlen)
> -{
> -       u8 *dst;
> -
> -       caam_rsa_drop_leading_zeros(&ptr, &nbytes);
> -       if (!nbytes)
> -               return NULL;
> -
> -       dst = kzalloc(dstlen, GFP_KERNEL);
> -       if (!dst)
> -               return NULL;
> -
> -       memcpy(dst + (dstlen - nbytes), ptr, nbytes);
> -
> -       return dst;
> -}
> -
> -/**
> - * caam_read_raw_data - Read a raw byte stream as a positive integer.
> - * The function skips buffer's leading zeros, copies the remained data
> - * to a buffer allocated in the GFP_KERNEL zone and returns
> - * the address of the new buffer.
> - *
> - * @buf   : The data to read
> - * @nbytes: The amount of data to read
> - */
> -static inline u8 *caam_read_raw_data(const u8 *buf, size_t *nbytes)
> -{
> -
> -       caam_rsa_drop_leading_zeros(&buf, nbytes);
> -       if (!*nbytes)
> -               return NULL;
> -
> -       return kmemdup(buf, *nbytes, GFP_KERNEL);
> -}
> -
> -static int caam_rsa_check_key_length(unsigned int len)
> -{
> -       if (len > 4096)
> -               return -EINVAL;
> -       return 0;
> -}
> -
> -static int caam_rsa_set_pub_key(struct crypto_akcipher *tfm, const void
*key,
> -                               unsigned int keylen)
> -{
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct rsa_key raw_key = {NULL};
> -       struct caam_rsa_key *rsa_key = &ctx->key;
> -       int ret;
> -
> -       /* Free the old RSA key if any */
> -       caam_rsa_free_key(rsa_key);
> -
> -       ret = rsa_parse_pub_key(&raw_key, key, keylen);
> -       if (ret)
> -               return ret;
> -
> -       /* Copy key in DMA zone */
> -       rsa_key->e = kmemdup(raw_key.e, raw_key.e_sz, GFP_KERNEL);
> -       if (!rsa_key->e)
> -               goto err;
> -
> -       /*
> -        * Skip leading zeros and copy the positive integer to a buffer
> -        * allocated in the GFP_KERNEL zone. The decryption descriptor
> -        * expects a positive integer for the RSA modulus and uses its
length as
> -        * decryption output length.
> -        */
> -       rsa_key->n = caam_read_raw_data(raw_key.n, &raw_key.n_sz);
> -       if (!rsa_key->n)
> -               goto err;
> -
> -       if (caam_rsa_check_key_length(raw_key.n_sz << 3)) {
> -               caam_rsa_free_key(rsa_key);
> -               return -EINVAL;
> -       }
> -
> -       rsa_key->e_sz = raw_key.e_sz;
> -       rsa_key->n_sz = raw_key.n_sz;
> -
> -       return 0;
> -err:
> -       caam_rsa_free_key(rsa_key);
> -       return -ENOMEM;
> -}
> -
> -static int caam_rsa_set_priv_key_form(struct caam_rsa_ctx *ctx,
> -                                      struct rsa_key *raw_key)
> -{
> -       struct caam_rsa_key *rsa_key = &ctx->key;
> -       size_t p_sz = raw_key->p_sz;
> -       size_t q_sz = raw_key->q_sz;
> -       unsigned aligned_size;
> -
> -       rsa_key->p = caam_read_raw_data(raw_key->p, &p_sz);
> -       if (!rsa_key->p)
> -               return -ENOMEM;
> -       rsa_key->p_sz = p_sz;
> -
> -       rsa_key->q = caam_read_raw_data(raw_key->q, &q_sz);
> -       if (!rsa_key->q)
> -               goto free_p;
> -       rsa_key->q_sz = q_sz;
> -
> -       aligned_size = ALIGN(raw_key->p_sz, dma_get_cache_alignment());
> -       rsa_key->tmp1 = kzalloc(aligned_size, GFP_KERNEL);
> -       if (!rsa_key->tmp1)
> -               goto free_q;
> -
> -       aligned_size = ALIGN(raw_key->q_sz, dma_get_cache_alignment());
> -       rsa_key->tmp2 = kzalloc(aligned_size, GFP_KERNEL);
> -       if (!rsa_key->tmp2)
> -               goto free_tmp1;
> -
> -       rsa_key->priv_form = FORM2;
> -
> -       rsa_key->dp = caam_read_rsa_crt(raw_key->dp, raw_key->dp_sz,
p_sz);
> -       if (!rsa_key->dp)
> -               goto free_tmp2;
> -
> -       rsa_key->dq = caam_read_rsa_crt(raw_key->dq, raw_key->dq_sz,
q_sz);
> -       if (!rsa_key->dq)
> -               goto free_dp;
> -
> -       rsa_key->qinv = caam_read_rsa_crt(raw_key->qinv, raw_key->qinv_sz,
> -                                         q_sz);
> -       if (!rsa_key->qinv)
> -               goto free_dq;
> -
> -       rsa_key->priv_form = FORM3;
> -
> -       return 0;
> -
> -free_dq:
> -       kfree_sensitive(rsa_key->dq);
> -free_dp:
> -       kfree_sensitive(rsa_key->dp);
> -free_tmp2:
> -       kfree_sensitive(rsa_key->tmp2);
> -free_tmp1:
> -       kfree_sensitive(rsa_key->tmp1);
> -free_q:
> -       kfree_sensitive(rsa_key->q);
> -free_p:
> -       kfree_sensitive(rsa_key->p);
> -       return -ENOMEM;
> -}
> -
> -static int caam_rsa_set_priv_key(struct crypto_akcipher *tfm, const void
*key,
> -                                unsigned int keylen)
> -{
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct rsa_key raw_key = {NULL};
> -       struct caam_rsa_key *rsa_key = &ctx->key;
> -       int ret;
> -
> -       /* Free the old RSA key if any */
> -       caam_rsa_free_key(rsa_key);
> -
> -       ret = rsa_parse_priv_key(&raw_key, key, keylen);
> -       if (ret)
> -               return ret;
> -
> -       /* Copy key in DMA zone */
> -       rsa_key->d = kmemdup(raw_key.d, raw_key.d_sz, GFP_KERNEL);
> -       if (!rsa_key->d)
> -               goto err;
> -
> -       rsa_key->e = kmemdup(raw_key.e, raw_key.e_sz, GFP_KERNEL);
> -       if (!rsa_key->e)
> -               goto err;
> -
> -       /*
> -        * Skip leading zeros and copy the positive integer to a buffer
> -        * allocated in the GFP_KERNEL zone. The decryption descriptor
> -        * expects a positive integer for the RSA modulus and uses its
length as
> -        * decryption output length.
> -        */
> -       rsa_key->n = caam_read_raw_data(raw_key.n, &raw_key.n_sz);
> -       if (!rsa_key->n)
> -               goto err;
> -
> -       if (caam_rsa_check_key_length(raw_key.n_sz << 3)) {
> -               caam_rsa_free_key(rsa_key);
> -               return -EINVAL;
> -       }
> -
> -       rsa_key->d_sz = raw_key.d_sz;
> -       rsa_key->e_sz = raw_key.e_sz;
> -       rsa_key->n_sz = raw_key.n_sz;
> -
> -       ret = caam_rsa_set_priv_key_form(ctx, &raw_key);
> -       if (ret)
> -               goto err;
> -
> -       return 0;
> -
> -err:
> -       caam_rsa_free_key(rsa_key);
> -       return -ENOMEM;
> -}
> -
> -static unsigned int caam_rsa_max_size(struct crypto_akcipher *tfm)
> -{
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -
> -       return ctx->key.n_sz;
> -}
> -
> -/* Per session pkc's driver context creation function */
> -static int caam_rsa_init_tfm(struct crypto_akcipher *tfm)
> -{
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -
> -       akcipher_set_reqsize(tfm, sizeof(struct caam_rsa_req_ctx));
> -
> -       ctx->dev = caam_jr_alloc();
> -
> -       if (IS_ERR(ctx->dev)) {
> -               pr_err("Job Ring Device allocation for transform
failed\n");
> -               return PTR_ERR(ctx->dev);
> -       }
> -
> -       ctx->padding_dma = dma_map_single(ctx->dev, zero_buffer,
> -                                         CAAM_RSA_MAX_INPUT_SIZE - 1,
> -                                         DMA_TO_DEVICE);
> -       if (dma_mapping_error(ctx->dev, ctx->padding_dma)) {
> -               dev_err(ctx->dev, "unable to map padding\n");
> -               caam_jr_free(ctx->dev);
> -               return -ENOMEM;
> -       }
> -
> -       return 0;
> -}
> -
> -/* Per session pkc's driver context cleanup function */
> -static void caam_rsa_exit_tfm(struct crypto_akcipher *tfm)
> -{
> -       struct caam_rsa_ctx *ctx = akcipher_tfm_ctx_dma(tfm);
> -       struct caam_rsa_key *key = &ctx->key;
> -
> -       dma_unmap_single(ctx->dev, ctx->padding_dma,
> CAAM_RSA_MAX_INPUT_SIZE -
> -                        1, DMA_TO_DEVICE);
> -       caam_rsa_free_key(key);
> -       caam_jr_free(ctx->dev);
> -}
> -
> -static struct caam_akcipher_alg caam_rsa = {
> -       .akcipher.base = {
> -               .encrypt = caam_rsa_enc,
> -               .decrypt = caam_rsa_dec,
> -               .set_pub_key = caam_rsa_set_pub_key,
> -               .set_priv_key = caam_rsa_set_priv_key,
> -               .max_size = caam_rsa_max_size,
> -               .init = caam_rsa_init_tfm,
> -               .exit = caam_rsa_exit_tfm,
> -               .base = {
> -                       .cra_name = "rsa",
> -                       .cra_driver_name = "rsa-caam",
> -                       .cra_priority = 3000,
> -                       .cra_module = THIS_MODULE,
> -                       .cra_ctxsize = sizeof(struct caam_rsa_ctx) +
> -                                      CRYPTO_DMA_PADDING,
> -               },
> -       },
> -       .akcipher.op = {
> -               .do_one_request = akcipher_do_one_req,
> -       },
> -};
> -
> -/* Public Key Cryptography module initialization handler */
> -int caam_pkc_init(struct device *ctrldev)
> -{
> -       struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
> -       u32 pk_inst, pkha;
> -       int err;
> -       init_done = false;
> -
> -       /* Determine public key hardware accelerator presence. */
> -       if (priv->era < 10) {
> -               pk_inst = (rd_reg32(&priv->jr[0]->perfmon.cha_num_ls) &
> -                          CHA_ID_LS_PK_MASK) >> CHA_ID_LS_PK_SHIFT;
> -       } else {
> -               pkha = rd_reg32(&priv->jr[0]->vreg.pkha);
> -               pk_inst = pkha & CHA_VER_NUM_MASK;
> -
> -               /*
> -                * Newer CAAMs support partially disabled functionality.
If this is the
> -                * case, the number is non-zero, but this bit is set to
indicate that
> -                * no encryption or decryption is supported. Only signing
and
> verifying
> -                * is supported.
> -                */
> -               if (pkha & CHA_VER_MISC_PKHA_NO_CRYPT)
> -                       pk_inst = 0;
> -       }
> -
> -       /* Do not register algorithms if PKHA is not present. */
> -       if (!pk_inst)
> -               return 0;
> -
> -       /* allocate zero buffer, used for padding input */
> -       zero_buffer = kzalloc(CAAM_RSA_MAX_INPUT_SIZE - 1, GFP_KERNEL);
> -       if (!zero_buffer)
> -               return -ENOMEM;
> -
> -       err = crypto_engine_register_akcipher(&caam_rsa.akcipher);
> -
> -       if (err) {
> -               kfree(zero_buffer);
> -               dev_warn(ctrldev, "%s alg registration failed\n",
> -                        caam_rsa.akcipher.base.base.cra_driver_name);
> -       } else {
> -               init_done = true;
> -               caam_rsa.registered = true;
> -               dev_info(ctrldev, "caam pkc algorithms registered in
/proc/crypto\n");
> -       }
> -
> -       return err;
> -}
> -
> -void caam_pkc_exit(void)
> -{
> -       if (!init_done)
> -               return;
> -
> -       if (caam_rsa.registered)
> -               crypto_engine_unregister_akcipher(&caam_rsa.akcipher);
> -
> -       kfree(zero_buffer);
> -}
> diff --git a/drivers/crypto/caam/caampkc.h b/drivers/crypto/caam/caampkc.h
> deleted file mode 100644
> index 96d03704c9be..000000000000
> --- a/drivers/crypto/caam/caampkc.h
> +++ /dev/null
> @@ -1,155 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -/*
> - * caam - Freescale FSL CAAM support for Public Key Cryptography
descriptors
> - *
> - * Copyright 2016 Freescale Semiconductor, Inc.
> - *
> - * There is no Shared Descriptor for PKC so that the Job Descriptor must
carry
> - * all the desired key parameters, input and output pointers.
> - */
> -
> -#ifndef _PKC_DESC_H_
> -#define _PKC_DESC_H_
> -#include "compat.h"
> -#include "pdb.h"
> -
> -/**
> - * caam_priv_key_form - CAAM RSA private key representation
> - * CAAM RSA private key may have either of three forms.
> - *
> - * 1. The first representation consists of the pair (n, d), where the
> - *    components have the following meanings:
> - *        n      the RSA modulus
> - *        d      the RSA private exponent
> - *
> - * 2. The second representation consists of the triplet (p, q, d), where
the
> - *    components have the following meanings:
> - *        p      the first prime factor of the RSA modulus n
> - *        q      the second prime factor of the RSA modulus n
> - *        d      the RSA private exponent
> - *
> - * 3. The third representation consists of the quintuple (p, q, dP, dQ,
qInv),
> - *    where the components have the following meanings:
> - *        p      the first prime factor of the RSA modulus n
> - *        q      the second prime factor of the RSA modulus n
> - *        dP     the first factors's CRT exponent
> - *        dQ     the second factors's CRT exponent
> - *        qInv   the (first) CRT coefficient
> - *
> - * The benefit of using the third or the second key form is lower
computational
> - * cost for the decryption and signature operations.
> - */
> -enum caam_priv_key_form {
> -       FORM1,
> -       FORM2,
> -       FORM3
> -};
> -
> -/**
> - * caam_rsa_key - CAAM RSA key structure. Keys are allocated in DMA zone.
> - * @n           : RSA modulus raw byte stream
> - * @e           : RSA public exponent raw byte stream
> - * @d           : RSA private exponent raw byte stream
> - * @p           : RSA prime factor p of RSA modulus n
> - * @q           : RSA prime factor q of RSA modulus n
> - * @dp          : RSA CRT exponent of p
> - * @dp          : RSA CRT exponent of q
> - * @qinv        : RSA CRT coefficient
> - * @tmp1        : CAAM uses this temporary buffer as internal state
buffer.
> - *                It is assumed to be as long as p.
> - * @tmp2        : CAAM uses this temporary buffer as internal state
buffer.
> - *                It is assumed to be as long as q.
> - * @n_sz        : length in bytes of RSA modulus n
> - * @e_sz        : length in bytes of RSA public exponent
> - * @d_sz        : length in bytes of RSA private exponent
> - * @p_sz        : length in bytes of RSA prime factor p of RSA modulus n
> - * @q_sz        : length in bytes of RSA prime factor q of RSA modulus n
> - * @priv_form   : CAAM RSA private key representation
> - */
> -struct caam_rsa_key {
> -       u8 *n;
> -       u8 *e;
> -       u8 *d;
> -       u8 *p;
> -       u8 *q;
> -       u8 *dp;
> -       u8 *dq;
> -       u8 *qinv;
> -       u8 *tmp1;
> -       u8 *tmp2;
> -       size_t n_sz;
> -       size_t e_sz;
> -       size_t d_sz;
> -       size_t p_sz;
> -       size_t q_sz;
> -       enum caam_priv_key_form priv_form;
> -};
> -
> -/**
> - * caam_rsa_ctx - per session context.
> - * @key         : RSA key in DMA zone
> - * @dev         : device structure
> - * @padding_dma : dma address of padding, for adding it to the input
> - */
> -struct caam_rsa_ctx {
> -       struct caam_rsa_key key;
> -       struct device *dev;
> -       dma_addr_t padding_dma;
> -
> -};
> -
> -/**
> - * caam_rsa_req_ctx - per request context.
> - * @src           : input scatterlist (stripped of leading zeros)
> - * @fixup_src     : input scatterlist (that might be stripped of leading
zeros)
> - * @fixup_src_len : length of the fixup_src input scatterlist
> - * @edesc         : s/w-extended rsa descriptor
> - * @akcipher_op_done : callback used when operation is done
> - */
> -struct caam_rsa_req_ctx {
> -       struct scatterlist src[2];
> -       struct scatterlist *fixup_src;
> -       unsigned int fixup_src_len;
> -       struct rsa_edesc *edesc;
> -       void (*akcipher_op_done)(struct device *jrdev, u32 *desc, u32 err,
> -                                void *context);
> -};
> -
> -/**
> - * rsa_edesc - s/w-extended rsa descriptor
> - * @src_nents     : number of segments in input s/w scatterlist
> - * @dst_nents     : number of segments in output s/w scatterlist
> - * @mapped_src_nents: number of segments in input h/w link table
> - * @mapped_dst_nents: number of segments in output h/w link table
> - * @sec4_sg_bytes : length of h/w link table
> - * @bklog         : stored to determine if the request needs backlog
> - * @sec4_sg_dma   : dma address of h/w link table
> - * @sec4_sg       : pointer to h/w link table
> - * @pdb           : specific RSA Protocol Data Block (PDB)
> - * @hw_desc       : descriptor followed by link tables if any
> - */
> -struct rsa_edesc {
> -       int src_nents;
> -       int dst_nents;
> -       int mapped_src_nents;
> -       int mapped_dst_nents;
> -       int sec4_sg_bytes;
> -       bool bklog;
> -       dma_addr_t sec4_sg_dma;
> -       struct sec4_sg_entry *sec4_sg;
> -       union {
> -               struct rsa_pub_pdb pub;
> -               struct rsa_priv_f1_pdb priv_f1;
> -               struct rsa_priv_f2_pdb priv_f2;
> -               struct rsa_priv_f3_pdb priv_f3;
> -       } pdb;
> -       u32 hw_desc[];
> -};
> -
> -/* Descriptor construction primitives. */
> -void init_rsa_pub_desc(u32 *desc, struct rsa_pub_pdb *pdb);
> -void init_rsa_priv_f1_desc(u32 *desc, struct rsa_priv_f1_pdb *pdb);
> -void init_rsa_priv_f2_desc(u32 *desc, struct rsa_priv_f2_pdb *pdb);
> -void init_rsa_priv_f3_desc(u32 *desc, struct rsa_priv_f3_pdb *pdb);
> -
> -#endif
> diff --git a/drivers/crypto/caam/pkc_desc.c
b/drivers/crypto/caam/pkc_desc.c
> deleted file mode 100644
> index 0d5ee762e036..000000000000
> --- a/drivers/crypto/caam/pkc_desc.c
> +++ /dev/null
> @@ -1,73 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -/*
> - * caam - Freescale FSL CAAM support for Public Key Cryptography
descriptors
> - *
> - * Copyright 2016 Freescale Semiconductor, Inc.
> - *
> - * There is no Shared Descriptor for PKC so that the Job Descriptor must
carry
> - * all the desired key parameters, input and output pointers.
> - */
> -#include "caampkc.h"
> -#include "desc_constr.h"
> -
> -/* Descriptor for RSA Public operation */
> -void init_rsa_pub_desc(u32 *desc, struct rsa_pub_pdb *pdb)
> -{
> -       init_job_desc_pdb(desc, 0, SIZEOF_RSA_PUB_PDB);
> -       append_cmd(desc, pdb->sgf);
> -       append_ptr(desc, pdb->f_dma);
> -       append_ptr(desc, pdb->g_dma);
> -       append_ptr(desc, pdb->n_dma);
> -       append_ptr(desc, pdb->e_dma);
> -       append_cmd(desc, pdb->f_len);
> -       append_operation(desc, OP_TYPE_UNI_PROTOCOL |
> OP_PCLID_RSAENC_PUBKEY);
> -}
> -
> -/* Descriptor for RSA Private operation - Private Key Form #1 */
> -void init_rsa_priv_f1_desc(u32 *desc, struct rsa_priv_f1_pdb *pdb)
> -{
> -       init_job_desc_pdb(desc, 0, SIZEOF_RSA_PRIV_F1_PDB);
> -       append_cmd(desc, pdb->sgf);
> -       append_ptr(desc, pdb->g_dma);
> -       append_ptr(desc, pdb->f_dma);
> -       append_ptr(desc, pdb->n_dma);
> -       append_ptr(desc, pdb->d_dma);
> -       append_operation(desc, OP_TYPE_UNI_PROTOCOL |
> OP_PCLID_RSADEC_PRVKEY |
> -                        RSA_PRIV_KEY_FRM_1);
> -}
> -
> -/* Descriptor for RSA Private operation - Private Key Form #2 */
> -void init_rsa_priv_f2_desc(u32 *desc, struct rsa_priv_f2_pdb *pdb)
> -{
> -       init_job_desc_pdb(desc, 0, SIZEOF_RSA_PRIV_F2_PDB);
> -       append_cmd(desc, pdb->sgf);
> -       append_ptr(desc, pdb->g_dma);
> -       append_ptr(desc, pdb->f_dma);
> -       append_ptr(desc, pdb->d_dma);
> -       append_ptr(desc, pdb->p_dma);
> -       append_ptr(desc, pdb->q_dma);
> -       append_ptr(desc, pdb->tmp1_dma);
> -       append_ptr(desc, pdb->tmp2_dma);
> -       append_cmd(desc, pdb->p_q_len);
> -       append_operation(desc, OP_TYPE_UNI_PROTOCOL |
> OP_PCLID_RSADEC_PRVKEY |
> -                        RSA_PRIV_KEY_FRM_2);
> -}
> -
> -/* Descriptor for RSA Private operation - Private Key Form #3 */
> -void init_rsa_priv_f3_desc(u32 *desc, struct rsa_priv_f3_pdb *pdb)
> -{
> -       init_job_desc_pdb(desc, 0, SIZEOF_RSA_PRIV_F3_PDB);
> -       append_cmd(desc, pdb->sgf);
> -       append_ptr(desc, pdb->g_dma);
> -       append_ptr(desc, pdb->f_dma);
> -       append_ptr(desc, pdb->c_dma);
> -       append_ptr(desc, pdb->p_dma);
> -       append_ptr(desc, pdb->q_dma);
> -       append_ptr(desc, pdb->dp_dma);
> -       append_ptr(desc, pdb->dq_dma);
> -       append_ptr(desc, pdb->tmp1_dma);
> -       append_ptr(desc, pdb->tmp2_dma);
> -       append_cmd(desc, pdb->p_q_len);
> -       append_operation(desc, OP_TYPE_UNI_PROTOCOL |
> OP_PCLID_RSADEC_PRVKEY |
> -                        RSA_PRIV_KEY_FRM_3);
> -}
> diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
> index ec57bf6aaf6c..94f19126f61b 100644
> --- a/drivers/crypto/caam/Kconfig
> +++ b/drivers/crypto/caam/Kconfig
> @@ -133,15 +133,6 @@ config CRYPTO_DEV_FSL_CAAM_AHASH_API
>           Selecting this will offload ahash for users of the
>           scatterlist crypto API to the SEC4 via job ring.
> 
> -config CRYPTO_DEV_FSL_CAAM_PKC_API
> -       bool "Register public key cryptography implementations with Crypto
API"
> -       default y
> -       select CRYPTO_RSA
> -       help
> -         Selecting this will allow SEC Public key support for RSA.
> -         Supported cryptographic primitives: encryption, decryption,
> -         signature and verification.
> -
>  config CRYPTO_DEV_FSL_CAAM_RNG_API
>         bool "Register caam device for hwrng API"
>         default y
> diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
> index a17e3cf14c61..87a82474b841 100644
> --- a/drivers/crypto/caam/Makefile
> +++ b/drivers/crypto/caam/Makefile
> @@ -20,7 +20,6 @@ caam_jr-
> $(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) += caamalg.o
>  caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI) += caamalg_qi.o
>  caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API) += caamhash.o
>  caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API) += caamrng.o
> -caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API) += caampkc.o
> pkc_desc.o
>  caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_BLOB_GEN) += blob_gen.o
> 
>  caam-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI) += qi.o
> diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
> index 6e48bf7d6054..744b6586171c 100644
> --- a/drivers/crypto/caam/intern.h
> +++ b/drivers/crypto/caam/intern.h
> @@ -178,24 +178,6 @@ static inline void caam_algapi_hash_exit(void)
> 
>  #endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API */
> 
> -#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API
> -
> -int caam_pkc_init(struct device *dev);
> -void caam_pkc_exit(void);
> -
> -#else
> -
> -static inline int caam_pkc_init(struct device *dev)
> -{
> -       return 0;
> -}
> -
> -static inline void caam_pkc_exit(void)
> -{
> -}
> -
> -#endif /* CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API */
> -
>  #ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API
> 
>  int caam_rng_init(struct device *dev);
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index 239469f6882e..2c1e8275ddaf 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -38,7 +38,6 @@ static void register_algs(struct caam_drv_private_jr
> *jrpriv,
> 
>         caam_algapi_init(dev);
>         caam_algapi_hash_init(dev);
> -       caam_pkc_init(dev);
>         jrpriv->hwrng = !caam_rng_init(dev);
>         caam_qi_algapi_init(dev);
> 
> @@ -54,7 +53,6 @@ static void unregister_algs(void)
>                 goto algs_unlock;
> 
>         caam_qi_algapi_exit();
> -       caam_pkc_exit();
>         caam_algapi_hash_exit();
>         caam_algapi_exit();
> 
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page:
> https://eur01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fgondor.ap
> ana.org.au%2F~herbert%2F&data=05%7C02%7Cv.sethi%40nxp.com%7C33199c
> 44b5f145e8981a08df0a48d61a%7C686ea1d3bc2b4c6fa92cd99c5c301635%7
> C0%7C0%7C639240980112891619%7CUnknown%7CTWFpbGZsb3d8eyJFbXB
> 0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbC
> IsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=JF5DELvKDNeBeGHPR%2F3VjQa
> qZgMoz4yDcO5rC%2BWHqEU%3D&reserved=0
> PGP Key:
> https://eur01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fgondor.ap
> ana.org.au%2F~herbert%2Fpubkey.txt&data=05%7C02%7Cv.sethi%40nxp.com%
> 7C33199c44b5f145e8981a08df0a48d61a%7C686ea1d3bc2b4c6fa92cd99c5c
> 301635%7C0%7C0%7C639240980112908987%7CUnknown%7CTWFpbGZsb3
> d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIj
> oiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=Er%2F9fVTTfGOzcuO
> 35eetZ7IPo6Ub21U0AG5iqDXR9vM%3D&reserved=0


------=_NextPart_000_0040_01DD405A.26F1AD70
Content-Type: application/pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIImUTCCBaIw
ggOKoAMCAQICCE4Rpu+H69FRMA0GCSqGSIb3DQEBCwUAMGUxIjAgBgNVBAMMGU5YUCBJbnRlcm5h
bCBQb2xpY3kgQ0EgRzIxCzAJBgNVBAsMAklUMREwDwYDVQQKDAhOWFAgQi5WLjESMBAGA1UEBwwJ
RWluZGhvdmVuMQswCQYDVQQGEwJOTDAeFw0yMzA0MjEwNjQzNDVaFw0yODA0MTkwNjQzNDVaMIG2
MRwwGgYDVQQDDBNOWFAgRW50ZXJwcmlzZSBDQSA1MQswCQYDVQQLDAJJVDERMA8GA1UECgwITlhQ
IEIuVi4xEjAQBgNVBAcMCUVpbmRob3ZlbjEWMBQGA1UECAwNTm9vcmQtQnJhYmFudDETMBEGCgmS
JomT8ixkARkWA3diaTETMBEGCgmSJomT8ixkARkWA254cDETMBEGCgmSJomT8ixkARkWA2NvbTEL
MAkGA1UEBhMCTkwwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDAWrnSkYP60A8wj4AO
kATDjnbdgLv6waFfyXE/hvatdWz2YYtb1YSRi5/wXW+Pz8rsTmSj7iusI+FcLP8WEaMVLn4sEIQY
NI8KJUCz21tsIArYs0hMKEUFeCq3mxTJfPqzdj9CExJBlZ5vWS4er8eJI8U8kZrt4CoY7De0FdJh
35Pi5QGzUFmFuaLgXfV1N5yukTzEhqz36kODoSRw+eDHH9YqbzefzEHK9d93TNiLaVlln42O0qaI
MmxK1aNcZx+nQkFsF/VrV9M9iLGA+Qb/MFmR20MJAU5kRGkJ2/QzgVQM3Nlmp/bF/3HWOJ2j2mpg
axvzxHNN+5rSNvkG2vSpAgMBAAGjggECMIH/MFIGCCsGAQUFBwEBBEYwRDBCBggrBgEFBQcwAoY2
aHR0cDovL253dy5wa2kubnhwLmNvbS9jZXJ0cy9OWFBJbnRlcm5hbFBvbGljeUNBRzIuY2VyMB0G
A1UdDgQWBBRYlWDuTnTvZSKqve0ZqSt6jhedBzASBgNVHRMBAf8ECDAGAQH/AgEAMEUGA1UdHwQ+
MDwwOqA4oDaGNGh0dHA6Ly9ud3cucGtpLm54cC5jb20vY3JsL05YUEludGVybmFsUG9saWN5Q0FH
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
ggEKAoIBAQD8dHi42dSU2xVCWDBfrz2VDlOjrs8Pz6JS+rr5kD0Bwa2JJeiTzy/5F5yCY/YKQ/Rm
qlwnoDtaRUSHOELuWNenwyImSrBwJU0umxEyV/Pcc9PeNjKSv3LgqqpFN1D6KqE6d/cUjaLlHojZ
ZVH4IiMpq5muG8ZPQv0d0hT7vbIatza/q7hpuByUZZArN/nuNrWh7DIRmPxGUnd8MlddU3PPdip9
YYzcSvZWwciFI4nhOOhCOPGefnhUwYNHl8FbHU6KVbSJEfKrZQSXeDYo7WFPnI8iRqhbLP7pFVWf
RjWQWVQi/IAegMRVmPi7qbFbRH0ygKTohugShycgWTBp4RLxAgMBAAGjggOHMIIDgzAOBgNVHQ8B
Af8EBAMCB4AwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMAwGA1UdEwEB/wQCMAAwHQYD
VR0OBBYEFE7MCofJ+DcxfvPhkcQptwk7FIGvMDsGA1UdEQQ0MDKgHwYKKwYBBAGCNxQCA6ARDA92
LnNldGhpQG54cC5jb22BD1YuU2V0aGlAbnhwLmNvbTAfBgNVHSMEGDAWgBTlMnr0ZsFHliR//CeA
OVjfKxfiuzCCAUoGA1UdHwSCAUEwggE9MIIBOaCCATWgggExhoHIbGRhcDovLy9DTj1OWFAlMjBF
bnRlcnByaXNlJTIwQ0ElMjA0LENOPW5sYW1zcGtpMDAwNCxDTj1DRFAsQ049UHVibGljJTIwS2V5
JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz13YmksREM9bnhwLERD
PWNvbT9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJp
YnV0aW9uUG9pbnSGMWh0dHA6Ly9ud3cucGtpLm54cC5jb20vY3JsL05YUC1FbnRlcnByaXNlLUNB
NC5jcmyGMWh0dHA6Ly93d3cucGtpLm54cC5jb20vY3JsL05YUC1FbnRlcnByaXNlLUNBNC5jcmww
ggEQBggrBgEFBQcBAQSCAQIwgf8wgbsGCCsGAQUFBzAChoGubGRhcDovLy9DTj1OWFAlMjBFbnRl
cnByaXNlJTIwQ0ElMjA0LENOPUFJQSxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2
aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXdiaSxEQz1ueHAsREM9Y29tP2NBQ2VydGlmaWNhdGU/
YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MD8GCCsGAQUFBzAChjNodHRw
Oi8vbnd3LnBraS5ueHAuY29tL2NlcnRzL05YUC1FbnRlcnByaXNlLUNBNC5jZXIwPAYJKwYBBAGC
NxUHBC8wLQYlKwYBBAGCNxUIhYLAfoGO9FWG7YU4guuZS5qSVj+Exs1cguWNfgIBZAIBQTAnBgkr
BgEEAYI3FQoEGjAYMAoGCCsGAQUFBwMCMAoGCCsGAQUFBwMEMA0GCSqGSIb3DQEBCwUAA4IBAQB4
kmhnmnFXEsKPjrnxbLMPpBPDWyOVXoK3M5pBT+df++ggyXb49tQhGch4kk3xLnqz6kNlepf0X75c
W5AHqvKd9Z9EL9h3FwdKP2j4oadMiO89POM+pbxa1Sg4jyDcp2a0hOGa6v+bJeEQs0FfxmnVqdOK
ZqPM+KGZscHjda9irdz2VIai2Vlz8MGJG8poamX2qZvIPRQQ7pxBDV/ueeZjSaIryO45y1SWDNfW
dQCU/Cw4JoKcLEjimXV8KD0Z8Vzn+FQGe8158/BXdT0aDzvLs2Uy4mW2zJRDCpLgw928l0k7phBN
kg6vI0qB6p/oI+B1WXKW2ScuuZx9rIEjs5wUMIIH5TCCBs2gAwIBAgITLQAOWbso0Sd2ld0l2AAB
AA5ZuzANBgkqhkiG9w0BAQsFADCBtjEcMBoGA1UEAwwTTlhQIEVudGVycHJpc2UgQ0EgNTELMAkG
A1UECwwCSVQxETAPBgNVBAoMCE5YUCBCLlYuMRIwEAYDVQQHDAlFaW5kaG92ZW4xFjAUBgNVBAgM
DU5vb3JkLUJyYWJhbnQxEzARBgoJkiaJk/IsZAEZFgN3YmkxEzARBgoJkiaJk/IsZAEZFgNueHAx
EzARBgoJkiaJk/IsZAEZFgNjb20xCzAJBgNVBAYTAk5MMB4XDTI1MDkxNDAxMjE1NloXDTI3MDkx
NDAxMjE1NlowgZoxEzARBgoJkiaJk/IsZAEZFgNjb20xEzARBgoJkiaJk/IsZAEZFgNueHAxEzAR
BgoJkiaJk/IsZAEZFgN3YmkxDDAKBgNVBAsTA05YUDELMAkGA1UECxMCSU4xFjAUBgNVBAsTDU1h
bmFnZWQgVXNlcnMxEzARBgNVBAsTCkRldmVsb3BlcnMxETAPBgNVBAMTCG54YTA2NDc1MIIBIjAN
BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAncGRaHDr3LPmdjPd05NBm9THK5MH1bN5PDv1JMKs
y87MuvgLt/SPQLFK0IzidTtqKZfJnvQGPhsRX8Vra+d7w6cZy7/+TwyiN+cx/Qq4Y1oLG/8pavlz
0myXFDvrYD+SK001ZD4xjpFC7wkuFCLXiutb4Wi6/H0WXMJrKiljadxAcqWCoxD+Ea9s+D1YDrDI
vuZpnod1hYYlQhb95xMaItG570qrn1IcfmFsoDOECgcG9saZciY9mJ2OpE7r3rK2mx5nKa005uLH
Eoz/1oItUg0m72OZT+68n5V/ScCKYC3qLdsek3COF2fltEysN2Sxc4cTttecY9CcpoK19l2QPQID
AQABo4IEBDCCBAAwPAYJKwYBBAGCNxUHBC8wLQYlKwYBBAGCNxUIhYLAfoGO9FWG7YU4guuZS5qS
Vj+Bt4I8g+2HMgIBZAIBRzATBgNVHSUEDDAKBggrBgEFBQcDBDAOBgNVHQ8BAf8EBAMCBSAwDAYD
VR0TAQH/BAIwADAbBgkrBgEEAYI3FQoEDjAMMAoGCCsGAQUFBwMEMIGUBgkqhkiG9w0BCQ8EgYYw
gYMwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBLTALBglghkgBZQMEARYwCwYJYIZIAWUDBAEZMAsG
CWCGSAFlAwQBAjALBglghkgBZQMEAQUwCgYIKoZIhvcNAwcwBwYFKw4DAgcwDgYIKoZIhvcNAwIC
AgCAMA4GCCqGSIb3DQMEAgICADAdBgNVHQ4EFgQU5w63IKj0tl3miQ0a1yaiBX4yCmUwOwYDVR0R
BDQwMqAfBgorBgEEAYI3FAIDoBEMD1YuU2V0aGlAbnhwLmNvbYEPVi5TZXRoaUBueHAuY29tMB8G
A1UdIwQYMBaAFFiVYO5OdO9lIqq97RmpK3qOF50HMIIBRgYDVR0fBIIBPTCCATkwggE1oIIBMaCC
AS2GgchsZGFwOi8vL0NOPU5YUCUyMEVudGVycHJpc2UlMjBDQSUyMDUsQ049bmxhbXNwa2kwMDA1
LENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1
cmF0aW9uLERDPXdiaSxEQz1ueHAsREM9Y29tP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFz
ZT9vYmplY3RDbGFzcz1jUkxEaXN0cmlidXRpb25Qb2ludIYvaHR0cDovL253dy5wa2kubnhwLmNv
bS9jcmwvTlhQRW50ZXJwcmlzZUNBNS5jcmyGL2h0dHA6Ly93d3cucGtpLm54cC5jb20vY3JsL05Y
UEVudGVycHJpc2VDQTUuY3JsMIIBEAYIKwYBBQUHAQEEggECMIH/MIG7BggrBgEFBQcwAoaBrmxk
YXA6Ly8vQ049TlhQJTIwRW50ZXJwcmlzZSUyMENBJTIwNSxDTj1BSUEsQ049UHVibGljJTIwS2V5
JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz13YmksREM9bnhwLERD
PWNvbT9jQUNlcnRpZmljYXRlP2Jhc2U/b2JqZWN0Q2xhc3M9Y2VydGlmaWNhdGlvbkF1dGhvcml0
eTA/BggrBgEFBQcwAoYzaHR0cDovL253dy5wa2kubnhwLmNvbS9jZXJ0cy9OWFAtRW50ZXJwcmlz
ZS1DQTUuY2VyMA0GCSqGSIb3DQEBCwUAA4IBAQCFq4Il9DLTn7pE9k6GfRiMn+ypjH3HsdCyzEcp
YYbGBjy+8Aw0uVtPqfoyxOcZJqYX/SLkzo6zEXIMhz7F9Ev3dJkBezOaCKUYFJbjyN5mx3JzSs93
2tDnnh1ypdmBExDXjU34c26u/e0z5ovdeSBlDNcqJNJWQAogvu/nud7IwvxL6JJv9jEjzKHthgVD
RkxWWGCxlzEiSGgWDii4fEUkv+Kp51akSveKII62BuLjwnOKx6Ud51eWLG5hvf0Ar5fd12jlXyQ8
ddP2FWdufmiD6fUWITUA1fB21ueQLwD9/M9oIXw7qTwmrYO80OtkemIEv/BD4j2QuhnS3obiVy1p
MYIEszCCBK8CAQEwgc4wgbYxHDAaBgNVBAMME05YUCBFbnRlcnByaXNlIENBIDQxCzAJBgNVBAsM
AklUMREwDwYDVQQKDAhOWFAgQi5WLjESMBAGA1UEBwwJRWluZGhvdmVuMRYwFAYDVQQIDA1Ob29y
ZC1CcmFiYW50MRMwEQYKCZImiZPyLGQBGRYDd2JpMRMwEQYKCZImiZPyLGQBGRYDbnhwMRMwEQYK
CZImiZPyLGQBGRYDY29tMQswCQYDVQQGEwJOTAITPwAItf/rhOgeZdNMNwAFAAi1/zAJBgUrDgMC
GgUAoIICuTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA5MDkw
NzIzMDNaMCMGCSqGSIb3DQEJBDEWBBTg91PIeEw75bVIP8flEY3d9WJbQTCBkwYJKoZIhvcNAQkP
MYGFMIGCMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCgYIKoZIhvcNAwcwCwYJYIZIAWUDBAEC
MA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCGjALBglghkgBZQMEAgMwCwYJ
YIZIAWUDBAICMAsGCWCGSAFlAwQCATCB3wYJKwYBBAGCNxAEMYHRMIHOMIG2MRwwGgYDVQQDDBNO
WFAgRW50ZXJwcmlzZSBDQSA1MQswCQYDVQQLDAJJVDERMA8GA1UECgwITlhQIEIuVi4xEjAQBgNV
BAcMCUVpbmRob3ZlbjEWMBQGA1UECAwNTm9vcmQtQnJhYmFudDETMBEGCgmSJomT8ixkARkWA3di
aTETMBEGCgmSJomT8ixkARkWA254cDETMBEGCgmSJomT8ixkARkWA2NvbTELMAkGA1UEBhMCTkwC
Ey0ADlm7KNEndpXdJdgAAQAOWbswgeEGCyqGSIb3DQEJEAILMYHRoIHOMIG2MRwwGgYDVQQDDBNO
WFAgRW50ZXJwcmlzZSBDQSA1MQswCQYDVQQLDAJJVDERMA8GA1UECgwITlhQIEIuVi4xEjAQBgNV
BAcMCUVpbmRob3ZlbjEWMBQGA1UECAwNTm9vcmQtQnJhYmFudDETMBEGCgmSJomT8ixkARkWA3di
aTETMBEGCgmSJomT8ixkARkWA254cDETMBEGCgmSJomT8ixkARkWA2NvbTELMAkGA1UEBhMCTkwC
Ey0ADlm7KNEndpXdJdgAAQAOWbswDQYJKoZIhvcNAQEBBQAEggEAKUjZUiquo13loX8ggPgSNoha
9QSMlMYq6OEfcZRvkmjf5m6MgQse8RW421OYE5GBojIScVecwBKjKi8tKqNTS7TjAcNjiL89tpdv
ikJ6G9Mk1sVmfBHB5b8PNSfz6ZNmHs+M6Nlb632PVYnOqr9QnB7hGIgQiozhZLLZfW6AJnaYsVme
SIkeenLg0j4tuRE+0tRlKy23kwGMvSOWan6+jnkWf86CwiUqYbd4dkd1AFXbOCLY24VSXaYOeLes
BAwCI0Mcx175dRVbj3cQ24IWtOsu8Bt2UWXmpJJK3qUTVSQsjk3ilz0Wu7CCeuFw7d+0W3vpbQcU
nFrf9RM/hOj96gAAAAAAAA==

------=_NextPart_000_0040_01DD405A.26F1AD70--
