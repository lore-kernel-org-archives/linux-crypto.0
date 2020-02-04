Return-Path: <SRS0=JC+L=3Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF0EC2D0B1
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Feb 2020 13:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A7232084E
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Feb 2020 13:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="WDoTExlF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgBDNJd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Feb 2020 08:09:33 -0500
Received: from mail-am6eur05on2058.outbound.protection.outlook.com ([40.107.22.58]:6104
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727170AbgBDNJc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Feb 2020 08:09:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvNxMTHO9U55VPEU67/PpfjBSJgnSE7UjxTyz1lzwXJSd7NFBwKsZrsXqcpMCoHtaq5RVyz/1jKXoomW8S5mNTZca8j5kGz002nKgH/NKmxFqik08xmWNeIHPOFsNRy7II15RTlEwWVy+UVKmwTM6E3Q6Pd7tbnfBHXhv760z6Zd+VQ9099KjAleLgnKAL/1coZ2g5iR4Ot6D7hMkGLI0QCqVLG0YY0FveeUaWxISnS/nfTi3oqOGu4qM22EYqYcpLImjqrCGTVOLYsp8L3JSDZAJTevQ1A5Af6h0Uaz4cCfx1HJrkbabq0OdqXL3VbZVYdp3uWrdDWrrv5TeDEO4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XgO4u/+4xSODho3Z8Lg00WFKBYrmFK2MGtVtPKWV0ac=;
 b=NG7Ahde4qh95cdsvaGAqBfq5VSqqHTxsOUr+w6gdZUfYfTObjHbpw0ux0xWYbpXvyu1GTLBoxuFQAwaRo4FDH+M3d2SAy323qaSpVGIptVveSYHfZLEbMdwN8i284ib1amtRkRRbg58vNqfKY7HUJhxK1pYeoo9PLJjqItw4ONeJnWPmJkRyQb2SaP1dQOTx48p0tSLg4hIKrEmtaJUyUTjwWBcP4YFpVUU5d3eLMNp+wOZh9ZibU5OCcv+WTZTsnjZlL1eKPlCjpxEohdM9C1keftefBNL573qCSpZWqAa3Ma8hx/6EuRi833weJwechXhofPsayz2HrfjMW8Gr6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XgO4u/+4xSODho3Z8Lg00WFKBYrmFK2MGtVtPKWV0ac=;
 b=WDoTExlFJ9jdvzTUpbAwtfzQicaZRGb7gW9HTRHzcsPRVJnvXnwP4pDfnNhLDkHbFkiSJEZGPL42yIZBhQ+W3iynbUP9CiACvR5qN2+mXlpp6bcslMfUPAJ2Ck4dg5zhiM4MmjaNOKbcD+xl23oY04LboLrRWE59ufVQav9cNGc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=andrei.botila@oss.nxp.com; 
Received: from AM6PR04MB5430.eurprd04.prod.outlook.com (20.178.92.210) by
 AM6PR04MB4278.eurprd04.prod.outlook.com (52.135.168.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.29; Tue, 4 Feb 2020 13:09:27 +0000
Received: from AM6PR04MB5430.eurprd04.prod.outlook.com
 ([fe80::79f3:d09c:ee2d:396e]) by AM6PR04MB5430.eurprd04.prod.outlook.com
 ([fe80::79f3:d09c:ee2d:396e%3]) with mapi id 15.20.2686.034; Tue, 4 Feb 2020
 13:09:27 +0000
Subject: Re: [EXT] [PATCH v7 8/9] crypto: caam - enable prediction resistance
 in HRWNG
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        linux-crypto@vger.kernel.org
Cc:     Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-9-andrew.smirnov@gmail.com>
From:   "Andrei Botila (OSS)" <andrei.botila@oss.nxp.com>
Message-ID: <882f76df-e5e4-0efc-20bc-e9bc3efd80f0@oss.nxp.com>
Date:   Tue, 4 Feb 2020 15:09:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <20200127165646.19806-9-andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P192CA0031.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::44) To AM6PR04MB5430.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::18)
MIME-Version: 1.0
Received: from [10.171.74.49] (212.146.100.6) by AM6P192CA0031.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 4 Feb 2020 13:09:27 +0000
X-Originating-IP: [212.146.100.6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f6e1869-0dda-48a5-2267-08d7a97376c7
X-MS-TrafficTypeDiagnostic: AM6PR04MB4278:|AM6PR04MB4278:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB427827A6165A5E5C9E0C7678B4030@AM6PR04MB4278.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 03030B9493
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(199004)(189003)(66556008)(53546011)(31686004)(2906002)(66476007)(26005)(16526019)(316002)(186003)(52116002)(81166006)(8936002)(81156014)(8676002)(66946007)(6486002)(6666004)(478600001)(86362001)(5660300002)(16576012)(54906003)(31696002)(2616005)(956004)(4326008)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB4278;H:AM6PR04MB5430.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fsEZk7RpHdVNOy83dMmUJbqHbhpVjAIm6jR7yPJ8Qt5rRB+5hj+dQDd0UGLOSAxB34ByA6fgNeRl22hO2Lav2RyeCBb+CYyITiKzkL/NPz2yRD8X9OeFPWiM+yfstRCl8uTL5WoRJxhGqZ540/GZ3/vbYfyA8KaoEZeoGkMNFm1Mopexo24lASeFJ1Pn1NkdUa0PpVfX0aHkxl9NOD3BzOGsiVDDijTllwSISsuRF3Nnr/0WKOTgistIDOnipaJmcqpILjwiFNKBbJgVQ9rT/U/BeD5vh8j8FVWECdL1kEuli4C+VHfWiSDcHcKFd8iGnGtmKFgCxqmDrKcfZxz83i8uM156JGns85p1jmMWj0skPZyUB6Q1tN6fRbL7R8tikMVazb57czvpzcanss9fmELGBnvb9bIaXaBPHdj/OOtXWpsMHeZn6drIK+gqfTptqlUCXXtxDgjggu64YfL/FAdce0JQBehhNLMDh4PI/L31JGJa0ZVqlcSArOxmWsMP
X-MS-Exchange-AntiSpam-MessageData: s7NvbrfUrXjLSOGIrf2Kp4EFmFTYrDsTVyL0bpXGi7pvmqDethivDMEJXSXtbh34lOJTtHW6hhi9AOnhVfETar3IAsInwFFP2dCw96lrsx0138Rl1PzEbVrIhCsGCcAQ9Q4X0mdhfvFgjVjdWDCvFQ==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6e1869-0dda-48a5-2267-08d7a97376c7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2020 13:09:27.7628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: foH2Po/Q+K5rjhFpJ+XikfBhA/gmeiagjYgkPgpJlQm2c9hkPTjk7Q8axPWMWHZ4N/np8OvxCoMkjQ+jcluqCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4278
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/27/2020 6:56 PM, Andrey Smirnov wrote:
> +static bool caam_mc_skip_hwrng_init(struct caam_drv_private *ctrlpriv)
> +{
> +       return ctrlpriv->mc_en;
> +       /*
> +        * FIXME: Add check for MC firmware version that need
> +        * reinitialization due to PR bit
> +        */
> +}
> +

Hi Andrey,

Please use the following patch as a way to check for MC firmware version.
This should be squashed into current PATCH v7 8/9.

-- >8 --

From: Andrei Botila <andrei.botila@nxp.com>
Subject: [PATCH] crypto: caam - check mc firmware version before instantiating
  rng

Management Complex firmware with version lower than 10.20.0
doesn't provide prediction resistance support. Consider this
and only instantiate rng when mc f/w version is lower.

Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
---
  drivers/crypto/caam/Kconfig |  1 +
  drivers/crypto/caam/ctrl.c  | 46 ++++++++++++++++++++++++++++---------
  2 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index fac5b2e26610..d0e833121d8c 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -13,6 +13,7 @@ config CRYPTO_DEV_FSL_CAAM
  	depends on FSL_SOC || ARCH_MXC || ARCH_LAYERSCAPE
  	select SOC_BUS
  	select CRYPTO_DEV_FSL_CAAM_COMMON
+	imply FSL_MC_BUS
  	help
  	  Enables the driver module for Freescale's Cryptographic Accelerator
  	  and Assurance Module (CAAM), also known as the SEC version 4 (SEC4).
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 167a79fa3b8a..52b98e8d5175 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -10,6 +10,7 @@
  #include <linux/of_address.h>
  #include <linux/of_irq.h>
  #include <linux/sys_soc.h>
+#include <linux/fsl/mc.h>
  
  #include "compat.h"
  #include "regs.h"
@@ -578,14 +579,24 @@ static void caam_remove_debugfs(void *root)
  }
  #endif
  
-static bool caam_mc_skip_hwrng_init(struct caam_drv_private *ctrlpriv)
+#ifdef CONFIG_FSL_MC_BUS
+static bool check_version(struct fsl_mc_version *mc_version, u32 major,
+			  u32 minor, u32 revision)
  {
-	return ctrlpriv->mc_en;
-	/*
-	 * FIXME: Add check for MC firmware version that need
-	 * reinitialization due to PR bit
-	 */
+	if (mc_version->major > major)
+		return true;
+
+	if (mc_version->major == major) {
+		if (mc_version->minor > minor)
+			return true;
+
+		if (mc_version->minor == minor && mc_version->revision > 0)
+			return true;
+	}
+
+	return false;
  }
+#endif
  
  /* Probe routine for CAAM top (controller) level */
  static int caam_probe(struct platform_device *pdev)
@@ -605,6 +616,7 @@ static int caam_probe(struct platform_device *pdev)
  	u8 rng_vid;
  	int pg_size;
  	int BLOCK_OFFSET = 0;
+	bool pr_support = false;
  
  	ctrlpriv = devm_kzalloc(&pdev->dev, sizeof(*ctrlpriv), GFP_KERNEL);
  	if (!ctrlpriv)
@@ -691,16 +703,28 @@ static int caam_probe(struct platform_device *pdev)
  	/* Get the IRQ of the controller (for security violations only) */
  	ctrlpriv->secvio_irq = irq_of_parse_and_map(nprop, 0);
  
+	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-mc");
+	ctrlpriv->mc_en = !!np;
+	of_node_put(np);
+
+#ifdef CONFIG_FSL_MC_BUS
+	if (ctrlpriv->mc_en) {
+		struct fsl_mc_version *mc_version;
+
+		mc_version = fsl_mc_get_version();
+		if (mc_version)
+			pr_support = check_version(mc_version, 10, 20, 0);
+		else
+			return -EPROBE_DEFER;
+	}
+#endif
+
  	/*
  	 * Enable DECO watchdogs and, if this is a PHYS_ADDR_T_64BIT kernel,
  	 * long pointers in master configuration register.
  	 * In case of SoCs with Management Complex, MC f/w performs
  	 * the configuration.
  	 */
-	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-mc");
-	ctrlpriv->mc_en = !!np;
-	of_node_put(np);
-
  	if (!ctrlpriv->mc_en)
  		clrsetbits_32(&ctrl->mcr, MCFGR_AWCACHE_MASK,
  			      MCFGR_AWCACHE_CACH | MCFGR_AWCACHE_BUFF |
@@ -807,7 +831,7 @@ static int caam_probe(struct platform_device *pdev)
  	 * already instantiated, do RNG instantiation
  	 * In case of SoCs with Management Complex, RNG is managed by MC f/w.
  	 */
-	if (!caam_mc_skip_hwrng_init(ctrlpriv) && rng_vid >= 4) {
+	if (!(ctrlpriv->mc_en && pr_support) && rng_vid >= 4) {
  		ctrlpriv->rng4_sh_init =
  			rd_reg32(&ctrl->r4tst[0].rdsta);
  		/*
-- 
2.17.1


