Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795771698;
	b=tpQqkXyQSfxCQyxW224MzMuCsisQfUhOchZWjRSW4WsX/cKMYzFMsbZEh6lBm0O0DYyd
	 aJ5QcjKrch2SnyDhBflSuqxY5BJB/mVdY4HkjMF+yaBGffbOEMxmNFUAsu9eM9J/YMiV2
	 XZz/hWYJRxfelI5bS6LDpW6dCfYK0kd43gAmqx7pOt9z+YICBi/9cmendglzCikBhqo+M
	 b3HuVavdE6ncSyeH3RPXmaOIuMN/jd0czYKOCFI+ye5cnIJpgk4Xo+hD+6fYkOgvUKr0u
	 famUI3OdzgdhumgdWmTmbBvZqrOw2L16QdG5s+T60fdMYcNWumM07t8J+vZGUgpH7gw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795771698;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-AtpMessageProperties:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=jw4QN0n7MSi43WSn9DHCvxKmOjGX69aUq/4UUbECoQA=;
	b=nFIrc6Og6W7otuWj/QlKRXitTUi9oGBbtDASh8vnBYTRx3Rrw3FtiXewEdZaY/y6oCcs
	 1R7cv7FZuHRYi0IGMNCke0loKljc3g9cRCpx6R+tbcXPvqW5ZuGqLPD0YBHBqwahgccOi
	 kcW8JrCTrZjCqwR9FBpPhQytsRvejqxCKZVdrM2fGvG0SbT8CSw4uSPT/RY2OwYzFXjJm
	 6G83EEh4pHMKar2hgjC6h5xFWxjixzuRZ6P6/wmcKBbU1Z/9q37fDwvsVoAc4BaoVFqsS
	 semXNk7dnbPFpB/aiFv4r7etl7vX2tUfZV9V4J0/QCsnoaJOjTiEiZKk3f+BsCPNqmQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=altera.com;
	spf=pass smtp.mailfrom=altera.com;
	dkim=pass header.d=altera.com header.i=@altera.com header.a=rsa-sha256 header.s=selector2 header.b=epyQY8P3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.6
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013006.outbound.protection.outlook.com [40.93.196.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64686606A32C;
	Fri, 27 Nov 2026 09:28:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64686606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=altera.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altera.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=altera.com header.i=@altera.com header.a=rsa-sha256 header.s=selector2 header.b=epyQY8P3
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o1X+ip3NREZFpgkRIIENxHAt+xg7x/q4KfOWoc4G6cNvvzxLZHkQcs5fGBzT9mezqJrZGD+U5Xm28TFZN3yDKmeeq/BrJDmCKNbexGL+Cn7Z0Xg6rRt8bq0j0G3QcBMdMVm5NLpzb0VU+ijV59Fpm229qaLyx7OlvjwXrL6NIgDQpQWXclgBUjUaBNf48cAA568QQV7VydKYwSqoEnu1JPr0fT4PiARCqX1sMAm+g+I3iaiXJGhP27bGVkZ/frD0lDrkUrPsH9vSftt7F7bU3hQVE0P1IDEp3RrnUTHYOnq7sLHVZvH9WeBpSiGgmc5vwbZrAPQcyMi3jTqqR2JWyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jw4QN0n7MSi43WSn9DHCvxKmOjGX69aUq/4UUbECoQA=;
 b=HDYEN4I2kSjV7o+Ws7tVKjRniTDp9KDFXAhgFjS84dPKqY0LSjT2+tpZ3oly9t0fSsUGeSGPsIBrwpZC0e8V4CJh4BXRlYtQug2aSw6GzF8fsaKMLquLjNSCd+MEnvuQl59Q0ghVctl+4E58WSaoI5PCAwgitgGSp710emptikGe9FC4XjaiQIT8ktKU+egb6ZYgoaoDk6gL/AGn8cyiL0tKGpstf+eV66UiQD0cN/yyOG6u+gd+q6Wc7mpdOxuSx7XRtn56AMj4V7mH81N8lpUi+cskWwJ6zVCDV3Pona9y2PqFGrDzNPWLeXeV58hnmAb+9J50Qp6EacZG0tLCPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=altera.com; dmarc=pass action=none header.from=altera.com;
 dkim=pass header.d=altera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=altera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jw4QN0n7MSi43WSn9DHCvxKmOjGX69aUq/4UUbECoQA=;
 b=epyQY8P3vrdvp4tnqBliJsRzRqRq59fKtF540XX6cp4lg8af6gAucF74ecBxVe5TUMrLnMvrX00wx8F+DjLz7sgyDi76e/tFAddqV0bA0QY1MBTKCBYJhyjATgbp4T1wpuPJ7uV7uSvo1Svzcist03xKjAw5G5d7ACPu+jrD7OnKbFxzY/lDWkoWhd3R2bcZqjendeG/Cbs+6O84nwRItf3PDDzGv/E73AsO0Lrf9hegLrCWNk/UY35TyeOCtMcU3/m3msHZYGqLGDmQ7NyzfTWBpX8NRL6WxKEUHUy6+9M125eYSTppmxFwRgMXXW628xpRrReLUf2izmepOhX9hw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=altera.com;
Received: from DS3PR03MB097838.namprd03.prod.outlook.com (2603:10b6:8:546::7)
 by SJ0PR03MB6675.namprd03.prod.outlook.com (2603:10b6:a03:38d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Fri, 27 Nov
 2026 09:28:12 +0000
Received: from DS3PR03MB097838.namprd03.prod.outlook.com
 ([fe80::fa39:2c18:c265:1d59]) by DS3PR03MB097838.namprd03.prod.outlook.com
 ([fe80::fa39:2c18:c265:1d59%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 09:28:12 +0000
From: hang.suan.wang@altera.com
To: Dinh Nguyen <dinguyen@kernel.org>,
	linux-kernel@vger.kernel.org,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	linux-crypto@vger.kernel.org
Cc: muhammad.nazim.amirul.nazle.asmade@altera.com,
	tze.yee.ng@altera.com,
	chee.nouk.phoon@altera.com,
	genevieve.chan@altera.com,
	adrian.ho.yin.ng@altera.com
Subject: [PATCH v2 2/2] hwrng: socfpga-fcs - Add FCS random number generator driver
Date: Fri, 27 Nov 2026 01:28:08 -0800
Message-Id: <20261127092808.15537-3-hang.suan.wang@altera.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20261127092808.15537-1-hang.suan.wang@altera.com>
References: <20261127092808.15537-1-hang.suan.wang@altera.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0140.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::25) To DS3PR03MB097838.namprd03.prod.outlook.com
 (2603:10b6:8:546::7)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR03MB097838:EE_|SJ0PR03MB6675:EE_
X-MS-Office365-Filtering-Correlation-Id: fd1c695f-108b-47ac-6cef-08df4c68c1c5
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|55112099003|921020|10067099003|56012099006|11063799006|261022105027099003|261021121427099003|261022113327099003|261021123027099003|261028144727099003|261026121527099003|261026140227099003|261009223027099003|261022075727099003|261102130727099003|261102123227099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	9S9OWhJiXhco0m2OlBJGva/td8sFJCJjOK0lM2oqF6B4OT2VOF4ZaPhMNpaijCgpL4gDM95AYnLJh8sx0rkywAc3EMBys8WTmPAdpvWxgr5YRjsWncbKKN4W7AwKXXfi84M2yd7AMMVp+09AOEIHuA3Dc2WFOTFZTDZhlBqNUposYr7JSC9NGYwKFv+PPnPgO2kIfhUUh9/HonbNdmLYXQpG5WTRxXIi7DVACu1vUzlLnJ/wVjRrcBCcIh3gEN7+UOqXnmJFF+YpegoVY/bsK/Qho+IC+0XSzcALJFjDXHGdXqVVo1f4E4jlFYYlT6DEjSNqdxPleO3rEBoV05gz8yBPLTvhxh/WSikeCy+bAUMYg0YRl3gcU6I9VjZtsY+Jf2IaDYa8hj6yaN0+kFWkUVWqwKFR+hgpfrPeoo7n76PA+TWvQVcZEJe43hVQM9y/KBp3y2YQY8o4Rdms62X/r5YOlx3uTCCUZRRYp3qWDv7PbHPmYwA9aclWfv6y5im6XGNUNC7lN+ENYYx4MJ2Z2CfhHXUkV0fWrxWwT3QgGmwJyY4aYRtfXHya5Q5P+WAnW42GktIKdxBSWfMXhTsL+w0BHYIcQIEiWblvqOgPnJ4VQEtkWUzHms92XBVAcDLZMIUH8g7LkXNTAP6PAyc5XIxZx8j39+Y9ZXCTa/J8dhFxEJK3fNVjPJMFb252GHfcuuJw921reJl5bsoSjUH6cw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR03MB097838.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(55112099003)(921020)(10067099003)(56012099006)(11063799006)(261022105027099003)(261021121427099003)(261022113327099003)(261021123027099003)(261028144727099003)(261026121527099003)(261026140227099003)(261009223027099003)(261022075727099003)(261102130727099003)(261102123227099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zV1sXKiZ5bt4/NpiiprUGmw5bvx4b9M84mYcar0zBLEsDtYJPQA3mYgiOIZL?=
 =?us-ascii?Q?/NBNjEckxSj2NdMYtIynwXD2cDsul9LRv+FA5SpFN7k7UHL81oA24wMtpIJ3?=
 =?us-ascii?Q?qD1dokNhbRAZCEIowae0OE3gQEccX0K6OWM8gLlOGLWcfAXk2Oe8ApLAbtX/?=
 =?us-ascii?Q?rC90ZdMyAM4lL6h+D4rUpPh7iAVGyFCD/5EL6ahvxTmV6Pq9jP1z0zjtVACb?=
 =?us-ascii?Q?GcJ3b+0OcaZJz+uPira0W0jzU6qodBM1fhCM7tg5ofe+yqx8SKgrfy81Jim4?=
 =?us-ascii?Q?bf5tLQCJH2qgE6CM2wxZsya+v9Q1MTqwMgTEyUD47R8C/GTRAM+o/kq6aYQ9?=
 =?us-ascii?Q?d8Hqk3lpheXycHnF0IlbyioSgO/z//WFcDL1ulSRxdI49Eg1wzJxF1ZLkgKg?=
 =?us-ascii?Q?v5lr0yUyekWn1DfBDhxzSw+Xuv+lwUqrCQLUQfWQxqAlRXBzO1wMdXUziebT?=
 =?us-ascii?Q?8o9CDQpUCLh80wUP632UEzgZhin40ULRzotHbm67KfkZtN+tvA5f9YslK9hG?=
 =?us-ascii?Q?We2FKceCvR47tAaJb7uOsLaAZLP3xtW9NnLZOnOAyzY8WZX9MfIP7ax8r9Qo?=
 =?us-ascii?Q?CLf1a39MwMU2P1EUnDzIf4PRD1leu6IPIzpj0CozzDKUZUVW5GP6ReBgzQqW?=
 =?us-ascii?Q?wKUkMQyDXnUJ0naF2boEp9WAa1LzasVigC1XF8yi+wucvKABx9OrAU+WvRKr?=
 =?us-ascii?Q?1bWirVu36RboHM9u08HTsWQ/CfSLqu9RrkVKT5TYcayU+9b3yOq1kjQ2iX8e?=
 =?us-ascii?Q?nezCZ63NqEHyGBBB0RptQSdlzhuz5fXQEniO6eXhqQypDvXal7MGDTKGO3ND?=
 =?us-ascii?Q?tInGaeLYChD3Yv7XDFQ7765oM9O8tP4kf8m3d67FuLIhi9SuVSx0oMJY+7cF?=
 =?us-ascii?Q?JO/2lrp42ag1WEbb+P/Hrgz2Qj77LNF6e2Zq139MVOSqh8jxmM7xMzkHoebD?=
 =?us-ascii?Q?Pk1qczE0epl2rfTrXmWWtU3mCqadE2XcbIEQ7weHt+ry86bGK7XbwE4IZSVb?=
 =?us-ascii?Q?FmHR9V22hohrncIQ5/H4+CJZiakyZ+8KROVGr0QGWXXgnbP1CxcY5GXS68GE?=
 =?us-ascii?Q?6xkw1z14Koao1YlfOvhuttzsCg/imTXK2XmaiCG9+BC6FrpRwpLGSBPItdJc?=
 =?us-ascii?Q?EVTYekPlMHLkHLvirwWM2317bt5MGICGfKXBBmJPeDJ2RvW2M75Aw/j0Ze8v?=
 =?us-ascii?Q?0pAHo5Yj+Qi2HB/K5Q8oKAww7F8FLNsI7GlmmHxyCKeCr8oLOOlHa0PNLgLD?=
 =?us-ascii?Q?c1a9CLmBOqTCkJ3NNJvADjv74hgWxOnlLNG1zO04lbv5iVihoVB91k4HVl9n?=
 =?us-ascii?Q?/+DsfqlnitSKEz159FQlb/Ur4fkMgFCRINxj59UB8ijA/l4cgSw4TOVXyF82?=
 =?us-ascii?Q?S4uRdgn2eBmv4P+tBRk9IbP1g9mihbfpbhpC70+S/SJFASombTD2u4d8Q/iO?=
 =?us-ascii?Q?9flZAQLjsxBpQ1Pa5ad1zHZcCk3Poolaz/ALlYRyDisDUpq+Bcar/+hQ9P46?=
 =?us-ascii?Q?C6XWez+o9Hf7k+xe191HkQqa2hBKLC6vn74sekvkMe5adjHOHbKT/HERf4h6?=
 =?us-ascii?Q?dSVO7bPCVs8uRsaUTiw395K6B67ZwQRlejmBNy2HsiiY1tbjdpN9HItx2xQW?=
 =?us-ascii?Q?Wb5yC+LKU9/OyVcCP2uXNoyJurohFmNvb2Tld8icIV68cVTtYWAcwowD00JD?=
 =?us-ascii?Q?gNIgIrP1LreSPOOLipC1d4NhWkfSth5V8fb/0401hLbfhadb2rFg2zISGhHW?=
 =?us-ascii?Q?hrLMt02ctSnQO0pMlwHHQd9vv7NTpUY=3D?=
X-OriginatorOrg: altera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd1c695f-108b-47ac-6cef-08df4c68c1c5
X-MS-Exchange-CrossTenant-AuthSource: DS3PR03MB097838.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 09:28:12.2373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ghjcYNE8/uIu24GUZOBqKNJQ857Dyln5d2/hLDLA8pAIdg0q3AlU/CEFyabpI9LmhH58wLP3kxdoKKAD/HHUq8qwFHslaY9EN8+uaPuTHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB6675

From: Hang Suan Wang <hang.suan.wang@altera.com>

Add a hw_random front-end for the SoCFPGA FCS random-number service.
The driver owns no session or service-layer state: every request goes
through the FCS core, which serializes access to the SDM crypto session
and forwards it to the SDM through ATF.

The Agilex FPGA series generator is an SP 800-90A compliant DRNG hardware
block in the SDM, in particular, Agilex 7 is SP 800-90A compliant DRBG
generation flow and is seeded with the TRNG hardware block.

Unlike existing hw_random drivers, this RNG produces data only if SDM
crypto session is open (for example via FCS_IOC_OPEN_SESSION
on /dev/socfpga-fcs). The session is held by the FCS service, not by this
driver. With no session open, socfpga_fcs_core_engine() returns -ENOTCONN
and the error is passed through unchanged: read() on /dev/hwrng fails with
it, and the hw_random entropy thread treats it as a transient failure and
retries.

The ATF accepts only a non-zero, 4-byte-aligned length, from 4 bytes up to
4080 bytes per request.

The hwrng.quality is left unset. The hw_random core treats 0 as the maximum
(1024 bits of entropy per 1024 bits of input), which matches a
conditioned SP 800-90A DRNG, so the driver claims no separate estimate.

Signed-off-by: Hang Suan Wang <hang.suan.wang@altera.com>
---
 MAINTAINERS                                |   1 +
 drivers/char/hw_random/Kconfig             |  12 ++
 drivers/char/hw_random/Makefile            |   1 +
 drivers/char/hw_random/socfpga-fcs-rng.c   | 133 +++++++++++++++++++++
 drivers/firmware/socfpga-fcs-core.c        |  71 +++++++----
 drivers/firmware/socfpga-fcs.c             |  33 +++++
 include/linux/firmware/intel/socfpga-fcs.h |  23 ++--
 7 files changed, 245 insertions(+), 29 deletions(-)
 create mode 100644 drivers/char/hw_random/socfpga-fcs-rng.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8fed8012195a..52e8650d22eb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -981,6 +981,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-devices-platform-stratix10-fcs
 F:	Documentation/misc-devices/socfpga-fcs.rst
+F:	drivers/char/hw_random/socfpga-fcs-rng.c
 F:	drivers/firmware/socfpga-fcs*
 F:	include/linux/firmware/intel/socfpga-fcs*
 F:	include/uapi/misc/socfpga-fcs*
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index d3108991c251..9ebb52536854 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -648,6 +648,18 @@ config HW_RANDOM_QCOM
 	  To compile this driver as a module, choose M here. The
 	  module will be called qcom-rng. If unsure, say N.
 
+config HW_RANDOM_SOCFPGA_FCS
+	tristate "Altera SoCFPGA FCS Random Number Generator support"
+	depends on ALTERA_SOCFPGA_FCS
+	help
+	  This driver provides support for the random number generator
+	  of the Altera SoCFPGA FPGA Crypto Service (FCS) in the Secure
+	  Device Manager, through the FCS core engine. It can only be
+	  used while an FCS crypto session is open.
+
+	  To compile this driver as a module, choose M here. The
+	  module will be called socfpga-fcs-rng. If unsure, say N.
+
 endif # HW_RANDOM
 
 config UML_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 8fce2aa6cf7d..8496471d568b 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -55,3 +55,4 @@ obj-$(CONFIG_HW_RANDOM_ROCKCHIP) += rockchip-rng.o
 obj-$(CONFIG_HW_RANDOM_JH7110) += jh7110-trng.o
 obj-$(CONFIG_HW_RANDOM_XILINX) += xilinx-trng.o
 obj-$(CONFIG_HW_RANDOM_QCOM) += qcom-rng.o
+obj-$(CONFIG_HW_RANDOM_SOCFPGA_FCS) += socfpga-fcs-rng.o
diff --git a/drivers/char/hw_random/socfpga-fcs-rng.c b/drivers/char/hw_random/socfpga-fcs-rng.c
new file mode 100644
index 000000000000..17b91b5d63fb
--- /dev/null
+++ b/drivers/char/hw_random/socfpga-fcs-rng.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Altera SoCFPGA hardware random number generator driver
+ *
+ * Copyright (c) 2026 Altera Corporation
+ *
+ * Front-end for the FCS random number service. This driver contains no
+ * session, locking or service-layer logic: the FCS core
+ * (drivers/firmware/socfpga-fcs-core.c) is the sole owner of the SDM
+ * crypto session and serializes every request. The RNG can only be
+ * used while a session is open (e.g. via FCS_IOC_OPEN_SESSION on
+ * /dev/socfpga-fcs); socfpga_fcs_core_engine() reports -ENOTCONN otherwise.
+ * The error is passed through unchanged. The hwrng core's background
+ * entropy thread treats it as a transient failure and retries after a
+ * delay, while a read() on /dev/hwrng fails with it.
+ */
+
+#include <linux/err.h>
+#include <linux/firmware/intel/socfpga-fcs.h>
+#include <linux/hw_random.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <linux/unaligned.h>
+
+/* Maximum bytes returned by one FCS_DEV_RANDOM_NUMBER_GEN_EXT request. */
+#define FCS_RANDOM_EXT_MAX_BYTES	(1020 * 4)
+
+/*
+ * The Agilex family SDM prefixes the random data with a 12-byte response
+ * header that consists of session ID (4), context ID (4), crypto parameter
+ * size (2), DRNG output type (1), crypto process stage (1).
+ */
+#define FCS_AGILEX_RNG_RESP_HDR_SIZE	12
+
+/* Offset of the context ID in the response header. */
+#define FCS_AGILEX_RNG_CONTEXT_ID_OFFSET	4
+
+struct socfpga_fcs_rng {
+	struct socfpga_fcs_priv *fcs;
+	struct hwrng rng;
+};
+
+static int socfpga_fcs_rng_read(struct hwrng *rng, void *buf, size_t max,
+				bool wait)
+{
+	struct socfpga_fcs_rng *frng = container_of(rng, struct socfpga_fcs_rng,
+						    rng);
+	struct fcs_cmd_params params = { };
+	size_t len;
+	int ret;
+
+	/* ATF requires a non-zero, 4-byte aligned request size. */
+	len = min_t(size_t, max, FCS_RANDOM_EXT_MAX_BYTES) & ~3UL;
+	if (!len)
+		return -EINVAL;
+
+	params.dst = buf;
+	params.dst_len = len;
+	/*
+	 * SDM requires a non-zero context ID per request; this wrapper
+	 * generates it.
+	 */
+	params.context_id = get_random_u32_above(0);
+
+	/*
+	 * No file owns this read. NULL is accepted only for the RNG
+	 * command; the session must already be open.
+	 */
+	ret = socfpga_fcs_core_engine(frng->fcs, NULL,
+				      FCS_DEV_RANDOM_NUMBER_GEN_EXT,
+				      &params, wait);
+	if (ret)
+		return ret;
+
+	if (params.status || params.dst_len <= FCS_AGILEX_RNG_RESP_HDR_SIZE)
+		return -EIO;
+
+	if (get_unaligned_le32(buf + FCS_AGILEX_RNG_CONTEXT_ID_OFFSET) !=
+	    params.context_id)
+		return -EIO;
+
+	/* Pass random number data to the caller */
+	params.dst_len -= FCS_AGILEX_RNG_RESP_HDR_SIZE;
+	memmove(buf, buf + FCS_AGILEX_RNG_RESP_HDR_SIZE, params.dst_len);
+
+	return params.dst_len;
+}
+
+static void socfpga_fcs_rng_put(void *data)
+{
+	socfpga_fcs_put(data);
+}
+
+static int socfpga_fcs_rng_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct socfpga_fcs_rng *frng;
+	int ret;
+
+	frng = devm_kzalloc(dev, sizeof(*frng), GFP_KERNEL);
+	if (!frng)
+		return -ENOMEM;
+
+	/* The parent (stratix10-fcs) publishes its state as drvdata. */
+	frng->fcs = dev_get_drvdata(dev->parent);
+	if (!frng->fcs)
+		return -EPROBE_DEFER;
+
+	socfpga_fcs_get(frng->fcs);
+	ret = devm_add_action_or_reset(dev, socfpga_fcs_rng_put, frng->fcs);
+	if (ret)
+		return ret;
+
+	frng->rng.name = "socfpga-fcs-rng";
+	frng->rng.read = socfpga_fcs_rng_read;
+
+	return devm_hwrng_register(dev, &frng->rng);
+}
+
+static struct platform_driver socfpga_fcs_rng_driver = {
+	.driver = {
+		.name = "socfpga-fcs-rng",
+	},
+	.probe = socfpga_fcs_rng_probe,
+};
+module_platform_driver(socfpga_fcs_rng_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Hang Suan Wang <hang.suan.wang@altera.com>");
+MODULE_DESCRIPTION("Altera SoCFPGA FCS Random Number Generator (RNG) driver");
+MODULE_ALIAS("platform:socfpga-fcs-rng");
diff --git a/drivers/firmware/socfpga-fcs-core.c b/drivers/firmware/socfpga-fcs-core.c
index 365cafb46545..b40877d3782d 100644
--- a/drivers/firmware/socfpga-fcs-core.c
+++ b/drivers/firmware/socfpga-fcs-core.c
@@ -99,7 +99,8 @@ static int fcs_svc_send_sync(struct socfpga_fcs_priv *priv,
  * @msg: service-layer message to send
  * @timeout: time to wait for the response
  *
- * Return: 0 on success, negative errno on failure.
+ * Return: 0 once the transaction completed, negative errno on transport
+ *         failure or timeout.
  */
 static int fcs_svc_send_async(struct socfpga_fcs_priv *priv,
 			      struct stratix10_svc_client_msg *msg,
@@ -238,6 +239,22 @@ static int fcs_svc_send_request(struct socfpga_fcs_priv *priv,
 		msg->command = COMMAND_FCS_SDOS_DATA_EXT;
 		break;
 
+	case FCS_DEV_RANDOM_NUMBER_GEN_EXT:
+		if (!params) {
+			ret = -EINVAL;
+			break;
+		}
+		dev_dbg(priv->client.dev, "Sending command: COMMAND_FCS_RANDOM_NUMBER_GEN_EXT with session_id: 0x%x, context_id: 0x%x, len: 0x%x\n",
+			priv->session_id, params->context_id,
+			params->dst_len);
+		msg->arg[0] = priv->session_id;
+		msg->arg[1] = params->context_id;
+		/* The svc layer passes msg->payload as the destination. */
+		msg->payload = params->dst;
+		msg->payload_length = params->dst_len;
+		msg->command = COMMAND_FCS_RANDOM_NUMBER_GEN_EXT;
+		break;
+
 	default:
 		dev_err(priv->client.dev, "Unknown command: 0x%x\n", command);
 		ret = -EINVAL;
@@ -257,17 +274,30 @@ static int fcs_svc_send_request(struct socfpga_fcs_priv *priv,
 	return ret;
 }
 
+/*
+ * fcs_non_owner_command() - commands that may run without the session owner
+ *
+ * The caller does not hold the file that opened the session. Every other
+ * command must be issued by that file.
+ */
+static bool fcs_non_owner_command(enum fcs_command_code command)
+{
+	return command == FCS_DEV_RANDOM_NUMBER_GEN_EXT;
+}
+
 /*
  * fcs_seq_begin() - start a serialized FCS request
  *
  * Takes @priv->lock and checks the device is present, a session is
- * open and @owner owns it.
+ * open, and @owner may run @command. A caller that is not the session
+ * owner is accepted only for commands from fcs_non_owner_command().
+ * Any other caller must be the file that opened the session.
  *
  * Return: 0 on success, with @priv->lock held; negative errno on
  * failure, with the lock dropped.
  */
-static int fcs_seq_begin(struct socfpga_fcs_priv *priv,
-			 const void *owner, bool wait)
+static int fcs_seq_begin(struct socfpga_fcs_priv *priv, const void *owner,
+			 enum fcs_command_code command, bool wait)
 {
 	int ret;
 
@@ -288,7 +318,12 @@ static int fcs_seq_begin(struct socfpga_fcs_priv *priv,
 		goto unlock;
 	}
 
-	if (priv->session_owner != owner) {
+	if (!owner) {
+		if (!fcs_non_owner_command(command)) {
+			ret = -EPERM;
+			goto unlock;
+		}
+	} else if (priv->session_owner != owner) {
 		ret = -EPERM;
 		goto unlock;
 	}
@@ -327,18 +362,6 @@ static int fcs_engine_step_locked(struct socfpga_fcs_priv *priv,
 	if (!params->context_id)
 		return -EINVAL;
 
-	/*
-	 * Copy-out below treats the firmware response value as a byte
-	 * count, which is only defined for SDOS. Reject
-	 * an output buffer for any other command instead of silently
-	 * misinterpreting that value.
-	 */
-	if (params->dst && command != FCS_DEV_SDOS_DATA_EXT) {
-		dev_err(priv->client.dev,
-			"copy-out not supported for command %d\n", command);
-		return -EINVAL;
-	}
-
 	params->status = 0;
 	params->status_valid = false;
 
@@ -393,14 +416,15 @@ static int fcs_engine_step_locked(struct socfpga_fcs_priv *priv,
 /**
  * socfpga_fcs_core_engine() - run one FCS command
  * @priv: state returned by fcs_init()
- * @owner: token passed to fcs_ctx_begin() when the session was opened
+ * @owner: token passed to fcs_ctx_begin() when the session was opened.
+ *         NULL is accepted only for FCS_DEV_RANDOM_NUMBER_GEN_EXT.
  * @command: FCS command code to send
  * @params: command parameters, with a caller-generated context ID
  * @wait: true to wait for the lock, false to return -EAGAIN if busy
  *
- * Takes @priv->lock, checks the session, sends the command and copies
- * the output back. The SDM status is stored in @params->status, valid
- * only when @params->status_valid is set.
+ * Takes @priv->lock, checks the session and the owner, sends the command
+ * and copies the output back. The SDM status is stored in
+ * @params->status, valid only when @params->status_valid is set.
  *
  * Return: 0 if the transaction completed, negative errno otherwise.
  */
@@ -410,7 +434,7 @@ int socfpga_fcs_core_engine(struct socfpga_fcs_priv *priv, const void *owner,
 {
 	int ret;
 
-	ret = fcs_seq_begin(priv, owner, wait);
+	ret = fcs_seq_begin(priv, owner, command, wait);
 	if (ret)
 		return ret;
 
@@ -419,6 +443,7 @@ int socfpga_fcs_core_engine(struct socfpga_fcs_priv *priv, const void *owner,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(socfpga_fcs_core_engine);
 
 /**
  * fcs_open_session_locked() - open a crypto session on the SDM
@@ -771,6 +796,7 @@ void socfpga_fcs_get(struct socfpga_fcs_priv *priv)
 {
 	kref_get(&priv->refcount);
 }
+EXPORT_SYMBOL_GPL(socfpga_fcs_get);
 
 /**
  * socfpga_fcs_put() - drop a reference on the FCS state
@@ -780,6 +806,7 @@ void socfpga_fcs_put(struct socfpga_fcs_priv *priv)
 {
 	kref_put(&priv->refcount, fcs_kref_release);
 }
+EXPORT_SYMBOL_GPL(socfpga_fcs_put);
 
 /**
  * fcs_mark_removed() - refuse further operations after the device is gone
diff --git a/drivers/firmware/socfpga-fcs.c b/drivers/firmware/socfpga-fcs.c
index c4a0c96ccca9..51812d409304 100644
--- a/drivers/firmware/socfpga-fcs.c
+++ b/drivers/firmware/socfpga-fcs.c
@@ -235,6 +235,30 @@ static int fcs_driver_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, ret, "Failed to register misc device\n");
 	}
 
+	/*
+	 * Spawn the hwrng front-end as a child device. It discovers this
+	 * state through dev_get_drvdata(dev->parent) and only ever calls
+	 * socfpga_fcs_core_engine(); a failure here is non-fatal, SDOS keeps
+	 * working without the RNG.
+	 */
+	if (!IS_ENABLED(CONFIG_HW_RANDOM_SOCFPGA_FCS))
+		return 0;
+
+	priv->rng_pdev = platform_device_alloc("socfpga-fcs-rng",
+					       PLATFORM_DEVID_NONE);
+	if (!priv->rng_pdev) {
+		dev_warn(dev, "failed to allocate socfpga-fcs-rng device\n");
+	} else {
+		priv->rng_pdev->dev.parent = dev;
+		ret = platform_device_add(priv->rng_pdev);
+		if (ret) {
+			dev_warn(dev, "failed to add socfpga-fcs-rng device: %d\n",
+				 ret);
+			platform_device_put(priv->rng_pdev);
+			priv->rng_pdev = NULL;
+		}
+	}
+
 	return 0;
 }
 
@@ -246,6 +270,12 @@ static void fcs_driver_remove(struct platform_device *pdev)
 {
 	struct socfpga_fcs_priv *priv = platform_get_drvdata(pdev);
 
+	/* Unregister the hwrng child first so it stops calling the engine. */
+	if (priv->rng_pdev) {
+		platform_device_unregister(priv->rng_pdev);
+		priv->rng_pdev = NULL;
+	}
+
 	/*
 	 * misc_deregister() does not wait for open files. Tear the svc
 	 * channel down here (parent may free it as soon as remove returns);
@@ -295,3 +325,6 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Altera SoCFPGA FCS SDOS encrypt/decrypt driver");
 MODULE_AUTHOR("Altera Corporation");
 MODULE_ALIAS("platform:stratix10-fcs");
+#if IS_ENABLED(CONFIG_HW_RANDOM_SOCFPGA_FCS)
+MODULE_SOFTDEP("post: socfpga-fcs-rng");
+#endif
diff --git a/include/linux/firmware/intel/socfpga-fcs.h b/include/linux/firmware/intel/socfpga-fcs.h
index 4d2d9f538b16..8ddc5d434e3c 100644
--- a/include/linux/firmware/intel/socfpga-fcs.h
+++ b/include/linux/firmware/intel/socfpga-fcs.h
@@ -57,8 +57,10 @@ struct fcs_sdos_req {
  *                         socfpga_fcs_core_engine()
  * @src: kernel input buffer, or NULL for output-only commands
  * @src_len: bytes in @src
- * @dst: kernel output buffer, or NULL for input-only commands; only
- *       FCS_DEV_SDOS_DATA_EXT supports one in this series
+ * @dst: kernel output buffer, or NULL for input-only commands.
+ *       FCS_DEV_SDOS_DATA_EXT and FCS_DEV_RANDOM_NUMBER_GEN_EXT use one;
+ *       the engine treats the firmware response value as the number of
+ *       bytes produced.
  * @dst_len: on entry the capacity of @dst, on return the bytes produced
  * @context_id: SDM context ID, generated by the caller
  * @arg: per-command scalars, passed as message arg[2]/arg[3]
@@ -85,6 +87,8 @@ struct socfpga_fcs_priv {
 	struct stratix10_svc_chan *chan;
 	struct stratix10_svc_client client;
 	struct miscdevice miscdev;
+	/* Child device for the hwrng front-end, owned by socfpga-fcs.c. */
+	struct platform_device *rng_pdev;
 	/*
 	 * Held by the driver and by every open file. An fd may outlive
 	 * driver detach, so this state is not devm-managed: the firmware
@@ -114,8 +118,9 @@ struct socfpga_fcs_priv {
 	bool session_opened;
 	/*
 	 * Opaque token of whoever opened the session (the struct file for
-	 * the ioctl front end); guarded by @lock. Only the owner may run
-	 * commands on the session or close it. Compared, never dereferenced.
+	 * the ioctl front end); guarded by @lock. Only that owner may run
+	 * ioctl commands on the session or close it. A NULL owner is
+	 * accepted only for the RNG command. Compared, never dereferenced.
 	 */
 	const void *session_owner;
 	u32 atf_version[3];
@@ -126,6 +131,7 @@ enum fcs_command_code {
 	FCS_DEV_CRYPTO_OPEN_SESSION,
 	FCS_DEV_CRYPTO_CLOSE_SESSION,
 	FCS_DEV_SDOS_DATA_EXT,
+	FCS_DEV_RANDOM_NUMBER_GEN_EXT,
 	FCS_DEV_ATF_VERSION,
 };
 
@@ -144,15 +150,18 @@ void fcs_mark_removed(struct socfpga_fcs_priv *priv);
 int fcs_get_atf_version(struct socfpga_fcs_priv *priv, u32 *version);
 
 /*
- * Open/close a session. Only one session may be open, and only its
- * owner may use or close it. Each takes @priv->lock itself.
+ * Open/close a session. Only one session may be open, and only the same
+ * owner that opened the session can close the session. Each takes @priv->lock
+ * itself.
  */
 int fcs_ctx_begin(struct socfpga_fcs_priv *priv, const void *owner);
 int fcs_ctx_end(struct socfpga_fcs_priv *priv, const void *owner);
 
 /*
  * Run one FCS command on the core engine. @owner must be the session
- * owner; see the kernel-doc in socfpga-fcs-core.c.
+ * owner, except for FCS_DEV_RANDOM_NUMBER_GEN_EXT, which accepts NULL.
+ * The session must already be open. See the kernel-doc in
+ * socfpga-fcs-core.c.
  */
 int socfpga_fcs_core_engine(struct socfpga_fcs_priv *priv, const void *owner,
 			    enum fcs_command_code command,
-- 
2.32.0

