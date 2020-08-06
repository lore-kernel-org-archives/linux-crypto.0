Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBBA6C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 18:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0FA022CAF
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 18:16:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="lYV+PQ1P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgHFSQg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 14:16:36 -0400
Received: from mail-eopbgr50058.outbound.protection.outlook.com ([40.107.5.58]:26030
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728050AbgHFSKD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 14:10:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIEKuaHlvYqKg/FC1YdpNmR95bM1AaOxO+FxlD7N2kfn9db9gh4TmV2MBaMzY8fe5KT6qEiv0c1J4hQ9BHFH9j8ywWr7gRBAhMtKvXzXx/mlAoxeE13DdtnEF1q7N7wcarUSDdoQJo3pmQ+EW3H99eJff9/nXhKyzBqJlJ5GzriX4DcO4hLMxWl2C2llZOGGZ0Aw6uueQJNIfsNiFq18NOgWgR1yhwbkaolh/gvgesXIWC6fFrotPsyMke/tDsO6e9KAqu9wku9jT4Zrf6YR+a/DWbuoFV/xnh0C9q1x/IwBg3PaKcPHDGC9IWj9yleW1AlKT0Ln/rYTvw24icv6xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CntVC+lGILP02VpPuhb6aXic7BWgB2m9ZCz8Yxjp84I=;
 b=EK4/pZyEVc7xZsUIz6/+Yu7ZKoItOn1quLJLi96tpPn0OW/STuFYdcmDinGoq5Ry1wfIraX5g+4Erd+vo+j/JCFZehD4RWzTJeKaWjwIF4UYg+j/jBu7s+drx4tXxt67aRMzZnN5v9+bhZ0TTlCSckXgSvdddrI/bMc8k/3lOiNVOlXmGhlUBZKmrMwtWaVOQmQD+Lj4XtMICEzsnpGdn6Tibj6rCE5iFOwp7IglOOBgsuENHWTmhgiBnGpeciTU87MFIDgDvzsgDz0WxU0cSia7Qg5RHeRf4hWIcenWBGFwxbXJAUz2PCd4H0gm+ejxMjpg3ZrqX8o5QsBMxxxWNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CntVC+lGILP02VpPuhb6aXic7BWgB2m9ZCz8Yxjp84I=;
 b=lYV+PQ1Pcf/72tjd+t4iuUWQ7BeQsyTiZOJI37931+n+1gkW/DpVXbKuIBDEiD8ayaFVzNr2MDgDRC4Olh/2CXfh6Js62zObHAvf/8+J3Wd9gnql5lRtk8a4dJXWRlAoRxzDxszsjwKqN9f1ZuKOrPqKGHtMPO9I/r5814osZOc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB4038.eurprd04.prod.outlook.com (2603:10a6:209:44::24)
 by AM6PR04MB4037.eurprd04.prod.outlook.com (2603:10a6:209:49::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.16; Thu, 6 Aug
 2020 18:09:52 +0000
Received: from AM6PR04MB4038.eurprd04.prod.outlook.com
 ([fe80::3880:77f6:c5ed:6ee2]) by AM6PR04MB4038.eurprd04.prod.outlook.com
 ([fe80::3880:77f6:c5ed:6ee2%7]) with mapi id 15.20.3261.019; Thu, 6 Aug 2020
 18:09:51 +0000
Subject: [v3 PATCH] crypto: caam - Move debugfs fops into standalone file
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <20200730135426.GA13682@gondor.apana.org.au>
 <c7fa483a-8f57-ee12-3c72-68c770ba4e00@nxp.com>
 <20200801124249.GA18580@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <bf2588f8-95f0-dd10-cd03-25268ea68837@nxp.com>
Date:   Thu, 6 Aug 2020 21:09:49 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200801124249.GA18580@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR07CA0115.eurprd07.prod.outlook.com
 (2603:10a6:207:7::25) To AM6PR04MB4038.eurprd04.prod.outlook.com
 (2603:10a6:209:44::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM3PR07CA0115.eurprd07.prod.outlook.com (2603:10a6:207:7::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.13 via Frontend Transport; Thu, 6 Aug 2020 18:09:51 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5ccbe5ae-6f6f-4716-f2f2-08d83a33e9d9
X-MS-TrafficTypeDiagnostic: AM6PR04MB4037:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB403777661BA03D1C9E23AD9F98480@AM6PR04MB4037.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N0e0nGRV142DzOIp0aegFDTUGDH1H9dVD+YTl5fekHgg/c6SiXXtQhIBPlTqhNgQpzkKy9L3MZxNtYfLPDaLLRexWq8P29T6Ope8MWQIz/qfD+v9/xnugktOPyDA0qM16s0dVqN2NVtdA9aWzXdDu3JbDAw9RaBggp1gt459cNZ1n15b+HIIUEsSK3JNh5IVGt6F3scMa7Kr+Qse0UgqpKiKfs36rOP4dN5ntjmSRMnwBqaZ+p1I1Xf4ekFwuPrj4wlDfBseD3HX7eFjKaPZ63evx89X/TvWCM0NjdcBLogVL2cBHNYlC6Fi2MnpCNfM35FzmNrC02ug4iqh2m2o3Uuhn8OKPGSrLWpiQPgf/Oaapw5DFVlDXXuGmULGRzzg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB4038.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(54906003)(36756003)(186003)(16526019)(86362001)(16576012)(6916009)(8936002)(53546011)(4326008)(26005)(6486002)(8676002)(316002)(956004)(31696002)(2616005)(52116002)(66946007)(66476007)(2906002)(5660300002)(66556008)(478600001)(30864003)(31686004)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XtiYDPXPlvNqeuOm/7Q7UwznrdIHovSESm9BhFRaHBUB6F86XSiDyg40TbXzsinPryV21L+6GleyyI9+laz8nGtfeF/IeWCuRCkwmFseB+XGWvZvWcONCQZo0bPLwmzkn7HetfqnAVrz2GgZ7XTymg4YlZyOXXd/PlFZVO1kv2G5zgdwyO6OoAnZNgZAR4zNMOg673fOiljtpciuvZ99ktjSlO6Sm+VLAKMz4ZXjoyPNP5FfY8V5wEoesNL5LFdFAY7IYqohXO2dx1w+L1AQFtSf7Z9Qw1oqaCDOPIv35+od7UvMAIbs/NIBk/eLnzFeIOPYHAL9ZPJVmOhzB8NuB6iDL3buFImLlyOZnLFl96RO4CX7ij0DHqhwsXMVT7XmaKEk3g4L9NtyXByMMnjR+JcBF3FVpHete/O/EgcZtuQLleGAE30d6c/VNKwDIVQW7crIjMaOtb1Ve3ITfZONNupEJtBofmmJpRn9R9hUl1wCbLq/eA8HMuL4rowKM9SrD6ECRSfYrA1i3pFiNxHsm+5jx68xWEYrc4Q5UkEWM4AHjib87OnKtUJoGpw+RKFZ98DQUY7xFLLnGuwJ6ksYHGfZU4BEJ1KLBFQVwZS/ZZWIqS1y6i0DzgtxUiZoNiAAI5/s41C8LXk2mzyyLIZ3sw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ccbe5ae-6f6f-4716-f2f2-08d83a33e9d9
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB4038.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 18:09:51.8640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OLanJNfHBMgT9yoEfkVxv74mvPV7YSZkx+KPp1PzJVcUtkNvBRZg9KsXp/dgqewpAgRuLHBHS2T8x/GmXDfKSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4037
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 8/1/2020 3:42 PM, Herbert Xu wrote:
> On Fri, Jul 31, 2020 at 07:46:07PM +0300, Horia Geantă wrote:
>>
>> Below hunk is needed for fixing the compilation when CONFIG_DEBUG_FS=y:
> 
> Thanks for catching this.  The NULL pointer assignments are also
> a bit iffy.  So here is an updated version:
> 
Thanks.

> @@ -912,56 +916,54 @@ static int caam_probe(struct platform_device *pdev)
>  	dev_info(dev, "job rings = %d, qi = %d\n",
>  		 ctrlpriv->total_jobrs, ctrlpriv->qi_present);
>  
> -#ifdef CONFIG_DEBUG_FS
> -	debugfs_create_file("rq_dequeued", S_IRUSR | S_IRGRP | S_IROTH,
> -			    ctrlpriv->ctl, &perfmon->req_dequeued,
> -			    &caam_fops_u64_ro);
> -	debugfs_create_file("ob_rq_encrypted", S_IRUSR | S_IRGRP | S_IROTH,
> -			    ctrlpriv->ctl, &perfmon->ob_enc_req,
> -			    &caam_fops_u64_ro);
> -	debugfs_create_file("ib_rq_decrypted", S_IRUSR | S_IRGRP | S_IROTH,
> -			    ctrlpriv->ctl, &perfmon->ib_dec_req,
> -			    &caam_fops_u64_ro);
> -	debugfs_create_file("ob_bytes_encrypted", S_IRUSR | S_IRGRP | S_IROTH,
> -			    ctrlpriv->ctl, &perfmon->ob_enc_bytes,
> -			    &caam_fops_u64_ro);
> -	debugfs_create_file("ob_bytes_protected", S_IRUSR | S_IRGRP | S_IROTH,
> -			    ctrlpriv->ctl, &perfmon->ob_prot_bytes,
> -			    &caam_fops_u64_ro);
> -	debugfs_create_file("ib_bytes_decrypted", S_IRUSR | S_IRGRP | S_IROTH,
> -			    ctrlpriv->ctl, &perfmon->ib_dec_bytes,
> -			    &caam_fops_u64_ro);
> -	debugfs_create_file("ib_bytes_validated", S_IRUSR | S_IRGRP | S_IROTH,
> -			    ctrlpriv->ctl, &perfmon->ib_valid_bytes,
> -			    &caam_fops_u64_ro);
> +	caam_debugfs_create_file_u64("rq_dequeued",
> +				     S_IRUSR | S_IRGRP | S_IROTH,
> +				     ctl, &perfmon->req_dequeued);
> +	caam_debugfs_create_file_u64("ob_rq_encrypted",
> +				     S_IRUSR | S_IRGRP | S_IROTH,
> +				     ctl, &perfmon->ob_enc_req);
> +	caam_debugfs_create_file_u64("ib_rq_decrypted",
> +				     S_IRUSR | S_IRGRP | S_IROTH,
> +				     ctl, &perfmon->ib_dec_req);
> +	caam_debugfs_create_file_u64("ob_bytes_encrypted",
> +				     S_IRUSR | S_IRGRP | S_IROTH,
> +				     ctl, &perfmon->ob_enc_bytes);
> +	caam_debugfs_create_file_u64("ob_bytes_protected",
> +				     S_IRUSR | S_IRGRP | S_IROTH,
> +				     ctl, &perfmon->ob_prot_bytes);
> +	caam_debugfs_create_file_u64("ib_bytes_decrypted",
> +				     S_IRUSR | S_IRGRP | S_IROTH,
> +				     ctl, &perfmon->ib_dec_bytes);
> +	caam_debugfs_create_file_u64("ib_bytes_validated",
> +				     S_IRUSR | S_IRGRP | S_IROTH,
> +				     ctl, &perfmon->ib_valid_bytes);
>  
>  	/* Controller level - global status values */
> -	debugfs_create_file("fault_addr", S_IRUSR | S_IRGRP | S_IROTH,
> -			    ctrlpriv->ctl, &perfmon->faultaddr,
> -			    &caam_fops_u32_ro);
> -	debugfs_create_file("fault_detail", S_IRUSR | S_IRGRP | S_IROTH,
> -			    ctrlpriv->ctl, &perfmon->faultdetail,
> -			    &caam_fops_u32_ro);
> -	debugfs_create_file("fault_status", S_IRUSR | S_IRGRP | S_IROTH,
> -			    ctrlpriv->ctl, &perfmon->status,
> -			    &caam_fops_u32_ro);
> +	caam_debugfs_create_file_u32("fault_addr",
> +				     S_IRUSR | S_IRGRP | S_IROTH,
> +				     ctl, &perfmon->faultaddr);
> +	caam_debugfs_create_file_u32("fault_detail",
> +				     S_IRUSR | S_IRGRP | S_IROTH,
> +				     ctl, &perfmon->faultdetail);
> +	caam_debugfs_create_file_u32("fault_status",
> +				     S_IRUSR | S_IRGRP | S_IROTH,
> +				     ctl, &perfmon->status);
>  
>  	/* Internal covering keys (useful in non-secure mode only) */
> -	ctrlpriv->ctl_kek_wrap.data = (__force void *)&ctrlpriv->ctrl->kek[0];
> -	ctrlpriv->ctl_kek_wrap.size = KEK_KEY_SIZE * sizeof(u32);
> -	debugfs_create_blob("kek", S_IRUSR | S_IRGRP | S_IROTH, ctrlpriv->ctl,
> -			    &ctrlpriv->ctl_kek_wrap);
> -
> -	ctrlpriv->ctl_tkek_wrap.data = (__force void *)&ctrlpriv->ctrl->tkek[0];
> -	ctrlpriv->ctl_tkek_wrap.size = KEK_KEY_SIZE * sizeof(u32);
> -	debugfs_create_blob("tkek", S_IRUSR | S_IRGRP | S_IROTH, ctrlpriv->ctl,
> -			    &ctrlpriv->ctl_tkek_wrap);
> -
> -	ctrlpriv->ctl_tdsk_wrap.data = (__force void *)&ctrlpriv->ctrl->tdsk[0];
> -	ctrlpriv->ctl_tdsk_wrap.size = KEK_KEY_SIZE * sizeof(u32);
> -	debugfs_create_blob("tdsk", S_IRUSR | S_IRGRP | S_IROTH, ctrlpriv->ctl,
> -			    &ctrlpriv->ctl_tdsk_wrap);
> -#endif
> +	blob = caam_debugfs_ptr(&ctrlpriv->ctl_kek_wrap, &blob0);
> +	blob->data = (__force void *)&ctrlpriv->ctrl->kek[0];
> +	blob->size = KEK_KEY_SIZE * sizeof(u32);
> +	debugfs_create_blob("kek", S_IRUSR | S_IRGRP | S_IROTH, ctl, blob);
> +
> +	blob = caam_debugfs_ptr(&ctrlpriv->ctl_tkek_wrap, &blob0);
> +	blob->data = (__force void *)&ctrlpriv->ctrl->tkek[0];
> +	blob->size = KEK_KEY_SIZE * sizeof(u32);
> +	debugfs_create_blob("tkek", S_IRUSR | S_IRGRP | S_IROTH, ctl, blob);
> +
> +	blob = caam_debugfs_ptr(&ctrlpriv->ctl_tdsk_wrap, &blob0);
> +	blob->data = (__force void *)&ctrlpriv->ctrl->tdsk[0];
> +	blob->size = KEK_KEY_SIZE * sizeof(u32);
> +	debugfs_create_blob("tdsk", S_IRUSR | S_IRGRP | S_IROTH, ctl, blob);
>  
I'd rather move these in the newly-created debugfs.c, see below v3.

> --- a/drivers/crypto/caam/qi.c
> +++ b/drivers/crypto/caam/qi.c
> @@ -11,6 +11,7 @@
>  #include <linux/kthread.h>
>  #include <soc/fsl/qman.h>
>  
> +#include "debugfs.h"
>  #include "regs.h"
>  #include "qi.h"
>  #include "desc.h"
> @@ -776,8 +777,8 @@ int caam_qi_init(struct platform_device *caam_pdev)
>  	}
>  
>  #ifdef CONFIG_DEBUG_FS
> -	debugfs_create_file("qi_congested", 0444, ctrlpriv->ctl,
> -			    &times_congested, &caam_fops_u64_ro);
> +	caam_debugfs_create_file_u64("qi_congested", 0444, ctrlpriv->ctl,
> +				     &times_congested);
>  #endif
ifdef should go away.

I've done some changes on top of v2, mainly moving the debugfs-related
operations from ctrl.c, qi.c into debugfs.c.

I've kept you Sign-off, but if you consider v3 is too different from v2
feel free to change it into Suggested-by / Reported-by.

---8<---
Currently the debugfs fops are defined in caam/intern.h.  This causes
problems because it creates identical static functions and variables
in multiple files.  It also creates warnings when those files don't
use the fops.

This patch moves them into a standalone file, debugfs.c.

It also removes unnecessary uses of ifdefs on CONFIG_DEBUG_FS.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[Moved most of debugfs-related operations into debugfs.c.]
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/Makefile  |  2 +
 drivers/crypto/caam/ctrl.c    | 77 +++------------------------
 drivers/crypto/caam/debugfs.c | 96 +++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/debugfs.h | 26 ++++++++++
 drivers/crypto/caam/intern.h  | 17 ------
 drivers/crypto/caam/qi.c      | 20 ++------
 6 files changed, 137 insertions(+), 102 deletions(-)
 create mode 100644 drivers/crypto/caam/debugfs.c
 create mode 100644 drivers/crypto/caam/debugfs.h

diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index 68d5cc0f28e2..3570286eb9ce 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -27,6 +27,8 @@ ifneq ($(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI),)
 	ccflags-y += -DCONFIG_CAAM_QI
 endif
 
+caam-$(CONFIG_DEBUG_FS) += debugfs.o
+
 obj-$(CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM) += dpaa2_caam.o
 
 dpaa2_caam-y    := caamalg_qi2.o dpseci.o
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 94502f1d4b48..65de57f169d9 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -13,6 +13,7 @@
 #include <linux/fsl/mc.h>
 
 #include "compat.h"
+#include "debugfs.h"
 #include "regs.h"
 #include "intern.h"
 #include "jr.h"
@@ -582,12 +583,10 @@ static int init_clocks(struct device *dev, const struct caam_imx_data *data)
 	return devm_add_action_or_reset(dev, disable_clocks, ctrlpriv);
 }
 
-#ifdef CONFIG_DEBUG_FS
 static void caam_remove_debugfs(void *root)
 {
 	debugfs_remove_recursive(root);
 }
-#endif
 
 #ifdef CONFIG_FSL_MC_BUS
 static bool check_version(struct fsl_mc_version *mc_version, u32 major,
@@ -619,10 +618,7 @@ static int caam_probe(struct platform_device *pdev)
 	struct device_node *nprop, *np;
 	struct caam_ctrl __iomem *ctrl;
 	struct caam_drv_private *ctrlpriv;
-#ifdef CONFIG_DEBUG_FS
-	struct caam_perfmon *perfmon;
 	struct dentry *dfs_root;
-#endif
 	u32 scfgr, comp_params;
 	u8 rng_vid;
 	int pg_size;
@@ -777,21 +773,15 @@ static int caam_probe(struct platform_device *pdev)
 	ctrlpriv->era = caam_get_era(ctrl);
 	ctrlpriv->domain = iommu_get_domain_for_dev(dev);
 
-#ifdef CONFIG_DEBUG_FS
-	/*
-	 * FIXME: needs better naming distinction, as some amalgamation of
-	 * "caam" and nprop->full_name. The OF name isn't distinctive,
-	 * but does separate instances
-	 */
-	perfmon = (struct caam_perfmon __force *)&ctrl->perfmon;
-
 	dfs_root = debugfs_create_dir(dev_name(dev), NULL);
-	ret = devm_add_action_or_reset(dev, caam_remove_debugfs, dfs_root);
-	if (ret)
-		return ret;
+	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
+		ret = devm_add_action_or_reset(dev, caam_remove_debugfs,
+					       dfs_root);
+		if (ret)
+			return ret;
+	}
 
-	ctrlpriv->ctl = debugfs_create_dir("ctl", dfs_root);
-#endif
+	caam_debugfs_init(ctrlpriv, dfs_root);
 
 	/* Check to see if (DPAA 1.x) QI present. If so, enable */
 	if (ctrlpriv->qi_present && !caam_dpaa2) {
@@ -912,57 +902,6 @@ static int caam_probe(struct platform_device *pdev)
 	dev_info(dev, "job rings = %d, qi = %d\n",
 		 ctrlpriv->total_jobrs, ctrlpriv->qi_present);
 
-#ifdef CONFIG_DEBUG_FS
-	debugfs_create_file("rq_dequeued", S_IRUSR | S_IRGRP | S_IROTH,
-			    ctrlpriv->ctl, &perfmon->req_dequeued,
-			    &caam_fops_u64_ro);
-	debugfs_create_file("ob_rq_encrypted", S_IRUSR | S_IRGRP | S_IROTH,
-			    ctrlpriv->ctl, &perfmon->ob_enc_req,
-			    &caam_fops_u64_ro);
-	debugfs_create_file("ib_rq_decrypted", S_IRUSR | S_IRGRP | S_IROTH,
-			    ctrlpriv->ctl, &perfmon->ib_dec_req,
-			    &caam_fops_u64_ro);
-	debugfs_create_file("ob_bytes_encrypted", S_IRUSR | S_IRGRP | S_IROTH,
-			    ctrlpriv->ctl, &perfmon->ob_enc_bytes,
-			    &caam_fops_u64_ro);
-	debugfs_create_file("ob_bytes_protected", S_IRUSR | S_IRGRP | S_IROTH,
-			    ctrlpriv->ctl, &perfmon->ob_prot_bytes,
-			    &caam_fops_u64_ro);
-	debugfs_create_file("ib_bytes_decrypted", S_IRUSR | S_IRGRP | S_IROTH,
-			    ctrlpriv->ctl, &perfmon->ib_dec_bytes,
-			    &caam_fops_u64_ro);
-	debugfs_create_file("ib_bytes_validated", S_IRUSR | S_IRGRP | S_IROTH,
-			    ctrlpriv->ctl, &perfmon->ib_valid_bytes,
-			    &caam_fops_u64_ro);
-
-	/* Controller level - global status values */
-	debugfs_create_file("fault_addr", S_IRUSR | S_IRGRP | S_IROTH,
-			    ctrlpriv->ctl, &perfmon->faultaddr,
-			    &caam_fops_u32_ro);
-	debugfs_create_file("fault_detail", S_IRUSR | S_IRGRP | S_IROTH,
-			    ctrlpriv->ctl, &perfmon->faultdetail,
-			    &caam_fops_u32_ro);
-	debugfs_create_file("fault_status", S_IRUSR | S_IRGRP | S_IROTH,
-			    ctrlpriv->ctl, &perfmon->status,
-			    &caam_fops_u32_ro);
-
-	/* Internal covering keys (useful in non-secure mode only) */
-	ctrlpriv->ctl_kek_wrap.data = (__force void *)&ctrlpriv->ctrl->kek[0];
-	ctrlpriv->ctl_kek_wrap.size = KEK_KEY_SIZE * sizeof(u32);
-	debugfs_create_blob("kek", S_IRUSR | S_IRGRP | S_IROTH, ctrlpriv->ctl,
-			    &ctrlpriv->ctl_kek_wrap);
-
-	ctrlpriv->ctl_tkek_wrap.data = (__force void *)&ctrlpriv->ctrl->tkek[0];
-	ctrlpriv->ctl_tkek_wrap.size = KEK_KEY_SIZE * sizeof(u32);
-	debugfs_create_blob("tkek", S_IRUSR | S_IRGRP | S_IROTH, ctrlpriv->ctl,
-			    &ctrlpriv->ctl_tkek_wrap);
-
-	ctrlpriv->ctl_tdsk_wrap.data = (__force void *)&ctrlpriv->ctrl->tdsk[0];
-	ctrlpriv->ctl_tdsk_wrap.size = KEK_KEY_SIZE * sizeof(u32);
-	debugfs_create_blob("tdsk", S_IRUSR | S_IRGRP | S_IROTH, ctrlpriv->ctl,
-			    &ctrlpriv->ctl_tdsk_wrap);
-#endif
-
 	ret = devm_of_platform_populate(dev);
 	if (ret)
 		dev_err(dev, "JR platform devices creation error\n");
diff --git a/drivers/crypto/caam/debugfs.c b/drivers/crypto/caam/debugfs.c
new file mode 100644
index 000000000000..b6137df155e0
--- /dev/null
+++ b/drivers/crypto/caam/debugfs.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2019 NXP */
+
+#include <linux/debugfs.h>
+#include "compat.h"
+#include "debugfs.h"
+#include "regs.h"
+#include "intern.h"
+
+static int caam_debugfs_u64_get(void *data, u64 *val)
+{
+	*val = caam64_to_cpu(*(u64 *)data);
+	return 0;
+}
+
+static int caam_debugfs_u32_get(void *data, u64 *val)
+{
+	*val = caam32_to_cpu(*(u32 *)data);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(caam_fops_u32_ro, caam_debugfs_u32_get, NULL, "%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(caam_fops_u64_ro, caam_debugfs_u64_get, NULL, "%llu\n");
+
+#ifdef CONFIG_CAAM_QI
+/*
+ * This is a counter for the number of times the congestion group (where all
+ * the request and response queueus are) reached congestion. Incremented
+ * each time the congestion callback is called with congested == true.
+ */
+static u64 times_congested;
+
+void caam_debugfs_qi_congested(void)
+{
+	times_congested++;
+}
+
+void caam_debugfs_qi_init(struct caam_drv_private *ctrlpriv)
+{
+	debugfs_create_file("qi_congested", 0444, ctrlpriv->ctl,
+			    &times_congested, &caam_fops_u64_ro);
+}
+#endif
+
+void caam_debugfs_init(struct caam_drv_private *ctrlpriv, struct dentry *root)
+{
+	struct caam_perfmon *perfmon;
+
+	/*
+	 * FIXME: needs better naming distinction, as some amalgamation of
+	 * "caam" and nprop->full_name. The OF name isn't distinctive,
+	 * but does separate instances
+	 */
+	perfmon = (struct caam_perfmon __force *)&ctrlpriv->ctrl->perfmon;
+
+	ctrlpriv->ctl = debugfs_create_dir("ctl", root);
+
+	debugfs_create_file("rq_dequeued", 0444, ctrlpriv->ctl,
+			    &perfmon->req_dequeued, &caam_fops_u64_ro);
+	debugfs_create_file("ob_rq_encrypted", 0444, ctrlpriv->ctl,
+			    &perfmon->ob_enc_req, &caam_fops_u64_ro);
+	debugfs_create_file("ib_rq_decrypted", 0444, ctrlpriv->ctl,
+			    &perfmon->ib_dec_req, &caam_fops_u64_ro);
+	debugfs_create_file("ob_bytes_encrypted", 0444, ctrlpriv->ctl,
+			    &perfmon->ob_enc_bytes, &caam_fops_u64_ro);
+	debugfs_create_file("ob_bytes_protected", 0444, ctrlpriv->ctl,
+			    &perfmon->ob_prot_bytes, &caam_fops_u64_ro);
+	debugfs_create_file("ib_bytes_decrypted", 0444, ctrlpriv->ctl,
+			    &perfmon->ib_dec_bytes, &caam_fops_u64_ro);
+	debugfs_create_file("ib_bytes_validated", 0444, ctrlpriv->ctl,
+			    &perfmon->ib_valid_bytes, &caam_fops_u64_ro);
+
+	/* Controller level - global status values */
+	debugfs_create_file("fault_addr", 0444, ctrlpriv->ctl,
+			    &perfmon->faultaddr, &caam_fops_u32_ro);
+	debugfs_create_file("fault_detail", 0444, ctrlpriv->ctl,
+			    &perfmon->faultdetail, &caam_fops_u32_ro);
+	debugfs_create_file("fault_status", 0444, ctrlpriv->ctl,
+			    &perfmon->status, &caam_fops_u32_ro);
+
+	/* Internal covering keys (useful in non-secure mode only) */
+	ctrlpriv->ctl_kek_wrap.data = (__force void *)&ctrlpriv->ctrl->kek[0];
+	ctrlpriv->ctl_kek_wrap.size = KEK_KEY_SIZE * sizeof(u32);
+	debugfs_create_blob("kek", 0444, ctrlpriv->ctl,
+			    &ctrlpriv->ctl_kek_wrap);
+
+	ctrlpriv->ctl_tkek_wrap.data = (__force void *)&ctrlpriv->ctrl->tkek[0];
+	ctrlpriv->ctl_tkek_wrap.size = KEK_KEY_SIZE * sizeof(u32);
+	debugfs_create_blob("tkek", 0444, ctrlpriv->ctl,
+			    &ctrlpriv->ctl_tkek_wrap);
+
+	ctrlpriv->ctl_tdsk_wrap.data = (__force void *)&ctrlpriv->ctrl->tdsk[0];
+	ctrlpriv->ctl_tdsk_wrap.size = KEK_KEY_SIZE * sizeof(u32);
+	debugfs_create_blob("tdsk", 0444, ctrlpriv->ctl,
+			    &ctrlpriv->ctl_tdsk_wrap);
+}
diff --git a/drivers/crypto/caam/debugfs.h b/drivers/crypto/caam/debugfs.h
new file mode 100644
index 000000000000..661d768acdbf
--- /dev/null
+++ b/drivers/crypto/caam/debugfs.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause) */
+/* Copyright 2019 NXP */
+
+#ifndef CAAM_DEBUGFS_H
+#define CAAM_DEBUGFS_H
+
+struct dentry;
+struct caam_drv_private;
+
+#ifdef CONFIG_DEBUG_FS
+void caam_debugfs_init(struct caam_drv_private *ctrlpriv, struct dentry *root);
+#else
+static inline void caam_debugfs_init(struct caam_drv_private *ctrlpriv,
+				     struct dentry *root)
+{}
+#endif
+
+#if defined(CONFIG_DEBUG_FS) && defined(CONFIG_CAAM_QI)
+void caam_debugfs_qi_congested(void);
+void caam_debugfs_qi_init(struct caam_drv_private *ctrlpriv);
+#else
+static inline void caam_debugfs_qi_congested(void) {}
+static inline void caam_debugfs_qi_init(struct caam_drv_private *ctrlpriv) {}
+#endif
+
+#endif /* CAAM_DEBUGFS_H */
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 402d6a362e8c..9112279a4de0 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -195,23 +195,6 @@ static inline void caam_qi_algapi_exit(void)
 
 #endif /* CONFIG_CAAM_QI */
 
-#ifdef CONFIG_DEBUG_FS
-static int caam_debugfs_u64_get(void *data, u64 *val)
-{
-	*val = caam64_to_cpu(*(u64 *)data);
-	return 0;
-}
-
-static int caam_debugfs_u32_get(void *data, u64 *val)
-{
-	*val = caam32_to_cpu(*(u32 *)data);
-	return 0;
-}
-
-DEFINE_SIMPLE_ATTRIBUTE(caam_fops_u32_ro, caam_debugfs_u32_get, NULL, "%llu\n");
-DEFINE_SIMPLE_ATTRIBUTE(caam_fops_u64_ro, caam_debugfs_u64_get, NULL, "%llu\n");
-#endif
-
 static inline u64 caam_get_dma_mask(struct device *dev)
 {
 	struct device_node *nprop = dev->of_node;
diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index b390b935db6d..ec53528d8205 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -11,6 +11,7 @@
 #include <linux/kthread.h>
 #include <soc/fsl/qman.h>
 
+#include "debugfs.h"
 #include "regs.h"
 #include "qi.h"
 #include "desc.h"
@@ -73,15 +74,6 @@ static struct caam_qi_priv qipriv ____cacheline_aligned;
 bool caam_congested __read_mostly;
 EXPORT_SYMBOL(caam_congested);
 
-#ifdef CONFIG_DEBUG_FS
-/*
- * This is a counter for the number of times the congestion group (where all
- * the request and response queueus are) reached congestion. Incremented
- * each time the congestion callback is called with congested == true.
- */
-static u64 times_congested;
-#endif
-
 /*
  * This is a a cache of buffers, from which the users of CAAM QI driver
  * can allocate short (CAAM_QI_MEMCACHE_SIZE) buffers. It's faster than
@@ -544,9 +536,8 @@ static void cgr_cb(struct qman_portal *qm, struct qman_cgr *cgr, int congested)
 	caam_congested = congested;
 
 	if (congested) {
-#ifdef CONFIG_DEBUG_FS
-		times_congested++;
-#endif
+		caam_debugfs_qi_congested();
+
 		pr_debug_ratelimited("CAAM entered congestion\n");
 
 	} else {
@@ -775,10 +766,7 @@ int caam_qi_init(struct platform_device *caam_pdev)
 		return -ENOMEM;
 	}
 
-#ifdef CONFIG_DEBUG_FS
-	debugfs_create_file("qi_congested", 0444, ctrlpriv->ctl,
-			    &times_congested, &caam_fops_u64_ro);
-#endif
+	caam_debugfs_qi_init(ctrlpriv);
 
 	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, ctrlpriv);
 	if (err)
-- 
2.17.1
