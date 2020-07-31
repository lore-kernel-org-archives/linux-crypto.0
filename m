Return-Path: <SRS0=j/eP=BK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A61C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 16:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76DD120663
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 16:46:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="EwbkanMd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbgGaQqO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Jul 2020 12:46:14 -0400
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:64261
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729396AbgGaQqO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Jul 2020 12:46:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXMd56T/rfRSphZoBs92gpPRBP8mqASGBnTK+W+Hq9guYdvh+/eLloSmAzGhD43BRGUbwk7o68h0urFsCMFwkY75Wc92/35Hrwf69aXtzuY8d5YyejWtLGve7KsNi7PnI9NU2+m290N2Yv1qjCWzKcrdUjJ5VUMVZm+VjMv0W/5G2q9j3oxdUMD+WAKIx312GX6GgbUwsmxP7YqKdqyZBM49W8+bObVKXgAXkmYQKtgM3oEfOLL35Tu1b6b/ILqq7Mte3YV54oNOBGP+3MtzLrACfxAC6xGsknY0EKALHHkR7MEpqZPnLpJX66R00hH4/vphFvrPN5h4mEHEXIxOGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=boNe+AuVfaAU2akd2ji8kSFjraXtMyurW4JQD5aEvnM=;
 b=n2LYgduur8qTkITZuzT5I6D0ka51pGQ1cHKntcWgsQb/sToRDTMj8YoNNC3xALo44OJVRYh6bvLV/pEWnV2rw7SitbRT7EoMHZPLs3FE448/LnbCyL9g5RP7GttwedWH7s+ZWL4bp9pk01aXlKGrTESVW9W2LxYH78KbNjsIflz+zMsiHa/audlT15Xq7Tt1x9B2H00Hbvvo5m+wS6jjWzmzRUW+pdYM40kgTdhpfXTdp4F1uX8cPGNwh4MrAebbJCRblWDt3Qq64filOj98ZPg4RcNRHrVz//TjwzWlg+Kxz7YaiDg3X6UcwrP4yyVlVT0Sx9hciA96sd39em7mUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=boNe+AuVfaAU2akd2ji8kSFjraXtMyurW4JQD5aEvnM=;
 b=EwbkanMdMkBnCoPQ8na5bJ788x8O/urFVLQzmPQZ1mJt3M4r5izJXpWtL06GTm+7thpprfNaHgxgQRXBIiWvDypTrYhSiCYIMYl2xz4bZrpskkse1XrF9u7mfmpovcxXjrmS4UoJ2w4j4GamTYj14HBTzP+nd6HaJp6ZpHDVCYs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR0402MB2878.eurprd04.prod.outlook.com (2603:10a6:800:b6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Fri, 31 Jul
 2020 16:46:10 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3239.017; Fri, 31 Jul 2020
 16:46:10 +0000
Subject: Re: [PATCH] crypto: caam - Move debugfs fops into standalone file
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <20200730135426.GA13682@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <c7fa483a-8f57-ee12-3c72-68c770ba4e00@nxp.com>
Date:   Fri, 31 Jul 2020 19:46:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200730135426.GA13682@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0202CA0004.eurprd02.prod.outlook.com
 (2603:10a6:200:89::14) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM4PR0202CA0004.eurprd02.prod.outlook.com (2603:10a6:200:89::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Fri, 31 Jul 2020 16:46:09 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 45802f95-77ac-4439-5e0e-08d835713a5e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2878A11AB34BAED6CF134596984E0@VI1PR0402MB2878.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r/bIKK7joVNGUZIlMbGvvZja2CM6k7j10jpuJEY5Cbk1ziMh6o2NOOCz1dDCqiUC0whzvHqtDLEdrYjyjmsnRBkPJMfj0amR82EVijevowpE9AMcdtAQpbp8NfbaqqlBvy+93Jj2frilJm4d/kXsMJ6hlAdwlC/kKv3cmnfcufOIHqhuVitWgKRgIg4qPQwzInkpAk3m+3op4kHeWncZwNe9jNyuNUNuKL1BSRyVxkELmnW7ucnJsbkMUrSZF3qYPUggM2GSeToYsUVjZu9Q1wG15vAMl5OMzn9Y/F7r9XYd7vPdyp9eg4gOverRXM9EviuZnLGt5rjY2p/WTngg1cVGoE6Io3b9cMwdO6IZcGeLeILbaqGCfNl+490qyHL8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(66476007)(66556008)(66946007)(86362001)(31696002)(8676002)(26005)(316002)(8936002)(31686004)(16576012)(110136005)(5660300002)(186003)(2616005)(478600001)(53546011)(6486002)(16526019)(36756003)(52116002)(956004)(83380400001)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MOIREiBw9vO4AM84HsQjZ8vXVoFEiW6IwvpOH0MBY+Cm5MPJjS+F4PZwv9kiokNHH8VuGiodahvyGlgkraFqlg/Z+CvKEFDiaJKoYTiQPZnstIBZhOLouMRF/jihCPIyXiQdVL6kwUqdNVRN4lhQduIKNzthGzjHFxwTZThb7nPwxOt0Q9ismq1g+fjzYDlUFw0678L0HFMlhXedNWHmNd4GS+U2iOD0XxcqnjJT7oGL/2SSWGl65cuRNzrH3zrA2XOAVMAg2zPXbUFeZRoHzCKQKmIKbBPFAJvhGMmFfphYJccVyGw/y8E6RkzCfH9GsYhWxlxTAA3Gxcx5VVErbOklkPx/HdrHc5oRMpgmOfOfzBYSSs8NmTwA7jiXTIsszCBANr1jKjdPvBe+VGuIn7dTujYRJQMBjsAAURriQpBZt8K2u+ZfXI/6m05owl1gZ5ukWG6LRioZStnf77EMpeKbMBOiRMv7p7qfe3GjeJvGH20G0MS7e+9XNShLj3lB6M7rIf+LNtya4P1nGAJt3UqP8eYCudDiNLCqAnl1CbMVCai/0MaAP102Dgcu4NkORuPLFXIUe9jt6/lAYp5PtWq4j3Wngct7tIpANqRy0KV/hmdUEnXhP8ycDARo0pJ6dAWNnHdLORk1YIFQYlqMbA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45802f95-77ac-4439-5e0e-08d835713a5e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 16:46:10.2203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QCiKDJKvxcrILW75t+CkPd6arPHXUDDfSOZuBGaVx372GrpI6VrluW4xxwldsBzDwDqS6+QThZ2uNaKx+I1ZpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2878
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/30/2020 4:54 PM, Herbert Xu wrote:
> Currently the debugfs fops are defined in caam/intern.h.  This causes
> problems because it creates identical static functions and variables
> in multiple files.  It also creates warnings when those files don't
> use the fops.
> 
Indeed, I see the warnings when compiling with W=1 and CONFIG_DEBUG_FS=y.

> This patch moves them into a standalone file, debugfs.c.
> 
> It also removes unnecessary uses of ifdefs on CONFIG_DEBUG_FS.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
Below hunk is needed for fixing the compilation when CONFIG_DEBUG_FS=y:

diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index 68d5cc0f28e2..a8d0d37408b2 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC) += caamalg_desc.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC) += caamhash_desc.o

 caam-y := ctrl.o
+caam-$(CONFIG_DEBUG_FS) += debugfs.o
 caam_jr-y := jr.o key_gen.o
 caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) += caamalg.o
 caam_jr-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI) += caamalg_qi.o

> -	ctrlpriv->ctl = debugfs_create_dir("ctl", dfs_root);
> +	ctl = debugfs_create_dir("ctl", dfs_root);
> +#ifdef CONFIG_DEBUG_FS
> +	ctrlpriv->ctl = ctl;
>  #endif
[...]
>  	debugfs_create_blob("kek", S_IRUSR | S_IRGRP | S_IROTH, ctrlpriv->ctl,
> -			    &ctrlpriv->ctl_kek_wrap);
> +			    blob);
Compilation fails when CONFIG_DEBUG_FS=n.

s/ctrlpriv->ctl/ctl, here and below.

>  
> -	ctrlpriv->ctl_tkek_wrap.data = (__force void *)&ctrlpriv->ctrl->tkek[0];
> -	ctrlpriv->ctl_tkek_wrap.size = KEK_KEY_SIZE * sizeof(u32);
> +	blob = caam_debugfs_ptr(&ctrlpriv->ctl_tkek_wrap);
> +	blob->data = (__force void *)&ctrlpriv->ctrl->tkek[0];
> +	blob->size = KEK_KEY_SIZE * sizeof(u32);
>  	debugfs_create_blob("tkek", S_IRUSR | S_IRGRP | S_IROTH, ctrlpriv->ctl,
> -			    &ctrlpriv->ctl_tkek_wrap);
> +			    blob);
>  
> -	ctrlpriv->ctl_tdsk_wrap.data = (__force void *)&ctrlpriv->ctrl->tdsk[0];
> -	ctrlpriv->ctl_tdsk_wrap.size = KEK_KEY_SIZE * sizeof(u32);
> +	blob = caam_debugfs_ptr(&ctrlpriv->ctl_tdsk_wrap);
> +	blob->data = (__force void *)&ctrlpriv->ctrl->tdsk[0];
> +	blob->size = KEK_KEY_SIZE * sizeof(u32);
>  	debugfs_create_blob("tdsk", S_IRUSR | S_IRGRP | S_IROTH, ctrlpriv->ctl,
> -			    &ctrlpriv->ctl_tdsk_wrap);
> -#endif
> +			    blob);

Thanks,
Horia
