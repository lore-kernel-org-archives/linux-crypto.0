Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BDAC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jan 2021 10:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3899D2376F
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jan 2021 10:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbhAVKFT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Jan 2021 05:05:19 -0500
Received: from mail-am6eur05on2095.outbound.protection.outlook.com ([40.107.22.95]:55937
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727792AbhAVKDK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Jan 2021 05:03:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRKNeDoYnKV4DheYvkpOxEI04PXT0Bfeh6ScHemJdGHN45MbjK0hVFc8aPvzZuA8S/oqb6CA+di/FawjATYDdXgWZ2ac2kyi59wOR7iO4Mgvxq0pMEbLNR5Iwc9c7lU5I5/31mpPVld7auuIrP9FhCbP7an+wDcZ5IxbdGCitZ5AvNl5xLblhMvA5RFuBu/U58TSlsGzLm+VlOv8Hj0wHzCteJsplKmStXm/BF+TYiGGPi7+eaykIVlBcE/sAr7ghNNnfy8k9U26J9+j+stSN98WcUxEtCg8B/TzvAjlorbQHBt75N31ruAlXhrNEP41NFqmtsG7IGRKGFZZWoY4dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSK1d+UyZ2tBD2WBcM7G7FmHirBjMB5JRamJ8Or3PRc=;
 b=VmJf6+yAdoarpceF3j8OA5f9C1KPmVxcguBTp1yT5XyUWi0+c3og2MN9a2scz9YWRjFP8WdbDMDpxcSexD/xfYPFsxADIQYmWX2R0PAWzvrFaWm+MWMHJ1QWILu6ycbi/kmCLtv1tE/ObdPOO9O7I/R5VNb20vJj2jdkZSCLYZO1YOqUdoN4wZNGi2tzBYrDSnuQxNsDJvcpC1gnAigKSUVjkByc4f406TKjaPcLYYBXqjROP7gjr2LpGlP4IDkSlAG7GcerR6JlA4/td46mxeM5Ob5rntFIqVV8AUCh+vufG/lq1pMIIdKb6rePgPeN1j7NxLwcG4BUsLHsbQyg9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSK1d+UyZ2tBD2WBcM7G7FmHirBjMB5JRamJ8Or3PRc=;
 b=KOH7uCdl84EEDLuul8TKU9Tw08hjBOw8LXqw3mxK2OOYCDkfYtezzBHCKkN0FnRQsMPp88FaFIVz98m+98OgKRudQvas37NFH2oP4yuwiY+i0b2KcE11aQSXCtiJJwe6fMwECw2OXKHXnbUVIWYDzfvpYrkIcUS55stSA4FivXU=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM4PR05MB3268.eurprd05.prod.outlook.com (2603:10a6:205:4::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 10:02:19 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b%6]) with mapi id 15.20.3784.012; Fri, 22 Jan 2021
 10:02:19 +0000
Date:   Fri, 22 Jan 2021 11:02:03 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Fix use of sg_pcopy on iomem
 pointer
Message-ID: <20210122100203.uyurjtxjiier6257@SvensMacbookPro.hq.voleatech.com>
References: <20210121051646.GA24114@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121051646.GA24114@gondor.apana.org.au>
X-Originating-IP: [37.24.174.41]
X-ClientProxiedBy: AM8P192CA0024.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::29) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacbookPro.hq.voleatech.com (37.24.174.41) by AM8P192CA0024.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21b::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 10:02:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e6b2111-ac9e-4f96-ee4c-08d8bebcce3a
X-MS-TrafficTypeDiagnostic: AM4PR05MB3268:
X-Microsoft-Antispam-PRVS: <AM4PR05MB3268A9BA5A32AB5DB3BF3509EFA00@AM4PR05MB3268.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PjTs7Gj0TthqSDXCquWZYYFyvLBI9HuYaJwEi5jN2+VhY+Nb+Zq1kOv8grISHvcboMVbofLlZV2/PBeVuPWYYwah1c43hf8b2WvoZsZj7RpSJ5KdE5nsl8yhQK2n7hnpBGwkekzchNxEEHF7/XXrxXraUeP/C2yOn7/up/ag2ylN/NMSCAivdlDVWmM0suAuswh5COssUi3HANahWtLs7ye4wFj4x2A4ARj7ZyKDxpnxDqS4nJKVkay5ZyAsJ6N+lelrJr0EPs6JA4n05irfknKrjvGJkpkzYDHBM5UBIbAZLGKgIqkJS+312qOZ2Qyh4uuCribL/KpQ+dt1X15ke9hsQJRCb9/IC4CnxbJhM0EpowKdotSN8enj8IniQB79+nxdtXz9cy50DqMYte4+OmFVg51CpYMG10rLGfM6njQlHBmDs/dqUmzjr9BqS5HDzdTsMtroH+ioOOqZLxUEn98FrCe+dhjaf+Bt5QmE4GrNUoG1qY7bpkeP0EoTBO/LiQBvaVOEst2U1ZqoNKN4ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(366004)(136003)(39830400003)(44832011)(8676002)(66476007)(66556008)(956004)(30864003)(66946007)(83080400002)(1076003)(86362001)(83380400001)(8936002)(55016002)(9686003)(2906002)(4326008)(7696005)(52116002)(45080400002)(966005)(6506007)(54906003)(6666004)(26005)(186003)(16526019)(5660300002)(478600001)(316002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xcbdVA7ObLa/9vcfLqT3VuG7s69bHyQHSjBdH+7/vccV821Rf58dNxzlS1Qv?=
 =?us-ascii?Q?R9odDbL0hQfwRYogc82PzhwqRggtpOOc0/SJqtcwV6ziGFpOlI3PCkDVcPA8?=
 =?us-ascii?Q?udZNdwkZz6Rdv3CX3353+eTRJNRrFtwFEuGod1YHs+eRSg0BTqQOkXeqsPJ2?=
 =?us-ascii?Q?NGMEGcGNP/TlBmzPBz6y10+2EUdI82Vhk6Jio/6GMEO5bGT6SWYiyzxYSTLi?=
 =?us-ascii?Q?uTpq67G4w95HUMB/xBA0Eqo0qTnzqXJ+G8PJP1SzKWrU1+skwzsXDH4AUPHI?=
 =?us-ascii?Q?qR0Ji0IGjvJstGwfke1USwQrvG7k2Aq773tgkHKJQvpepvQnbENnJDPjdOuj?=
 =?us-ascii?Q?sIfQc4KKJwWaphgwt32Xk6tsC4hManJ3tkgPPNFQdud+rYaxVrhzjo+WMmuA?=
 =?us-ascii?Q?paQBlZe0+KL4ano4UXqcxUFcqpIoTJ6OzsKzW7cuRagreawFTZx36g56xDMk?=
 =?us-ascii?Q?zg0sw+eqHD9HgJHLzpd9xhA3Y72BaENykHJf50EyXPtVd3111luFn8GQCF6F?=
 =?us-ascii?Q?UaTR/dg8Yy2qK+mnmoLuw1ZctjsHnMRqpOgXenbi4Yw37QLRhMrPV13FsTJm?=
 =?us-ascii?Q?oe+86Z+0RatAezJsuAa+nH21ben0B5HPy3MSUxesoQRWn8RUktM9qjOH/vux?=
 =?us-ascii?Q?NxIFsZHnxPdnXCLwOcw2W/yl41WibOSRyfNVTNCElk4qk57nh1AEGve5ZxNk?=
 =?us-ascii?Q?ohYAYiPcsCwnYJx11PtrIwXFkAh16ujyiCkMQKe0wW6keqiTlNGxDicN7bNq?=
 =?us-ascii?Q?ZfMJz3j4xeito6fQ4YfcqUNKIbUchqWehDQsQCVtuKFFq2vHMAO567+JlrA2?=
 =?us-ascii?Q?ZbcyPUraTnORbCUXerKC+JRMREkBZn0Wtml5GlbG8YyY8bWkqm7t2+wg3ONX?=
 =?us-ascii?Q?7rfTSgMJjQg9v5f6SdbfWubT2WL4oMCQDCbJqTFQ5UoAuiiFwUwos/t/lBWO?=
 =?us-ascii?Q?whvSQF9os844DBoWI1GajxRX3O8HiIIGeCRPZuCos95uQhQkfM9Hr1y6Zqu5?=
 =?us-ascii?Q?vPak?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e6b2111-ac9e-4f96-ee4c-08d8bebcce3a
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 10:02:19.8213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HsRVQ4RtWm3UeXy5e4tQG/5bKb9wVuCevEia+zOkCrW1hiFvtJ5EonAEAinyO6zOJKxaUTPCnJJk4kkVzUme1lg+RX5laS1d6RTc2h6hbOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3268
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 21, 2021 at 04:16:46PM +1100, Herbert Xu wrote:
> The cesa driver mixes use of iomem pointers and normal kernel
> pointers.  Sometimes it uses memcpy_toio/memcpy_fromio on both
> while other times it would use straight memcpy on both, through
> the sg_pcopy_* helpers.
> 
> This patch fixes this by adding a new field sram_pool to the engine
> for the normal pointer case which then allows us to use the right
> interface depending on the value of engine->pool.

Hi Herbert,

sorry, no luck on my armfh system with this patch:

[169999.310405] INFO: task cryptomgr_test:7698 blocked for more than 120 seconds.
[169999.317669]       Tainted: G           OE     5.10.0-1-vtair-armmp #1 Debian 5.10.3-3~vtair
[169999.326139] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

Best
Sven

> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
> index 06211858bf2e..f14aac532f53 100644
> --- a/drivers/crypto/marvell/cesa/cesa.c
> +++ b/drivers/crypto/marvell/cesa/cesa.c
> @@ -381,10 +381,10 @@ static int mv_cesa_get_sram(struct platform_device *pdev, int idx)
>  	engine->pool = of_gen_pool_get(cesa->dev->of_node,
>  				       "marvell,crypto-srams", idx);
>  	if (engine->pool) {
> -		engine->sram = gen_pool_dma_alloc(engine->pool,
> -						  cesa->sram_size,
> -						  &engine->sram_dma);
> -		if (engine->sram)
> +		engine->sram_pool = gen_pool_dma_alloc(engine->pool,
> +						       cesa->sram_size,
> +						       &engine->sram_dma);
> +		if (engine->sram_pool)
>  			return 0;
>  
>  		engine->pool = NULL;
> @@ -422,7 +422,7 @@ static void mv_cesa_put_sram(struct platform_device *pdev, int idx)
>  	struct mv_cesa_engine *engine = &cesa->engines[idx];
>  
>  	if (engine->pool)
> -		gen_pool_free(engine->pool, (unsigned long)engine->sram,
> +		gen_pool_free(engine->pool, (unsigned long)engine->sram_pool,
>  			      cesa->sram_size);
>  	else
>  		dma_unmap_resource(cesa->dev, engine->sram_dma,
> diff --git a/drivers/crypto/marvell/cesa/cesa.h b/drivers/crypto/marvell/cesa/cesa.h
> index fabfaaccca87..5c5eff0adbcc 100644
> --- a/drivers/crypto/marvell/cesa/cesa.h
> +++ b/drivers/crypto/marvell/cesa/cesa.h
> @@ -428,6 +428,7 @@ struct mv_cesa_dev {
>   * @id:			engine id
>   * @regs:		engine registers
>   * @sram:		SRAM memory region
> + * @sram_pool:		SRAM memory region from pool
>   * @sram_dma:		DMA address of the SRAM memory region
>   * @lock:		engine lock
>   * @req:		current crypto request
> @@ -448,7 +449,10 @@ struct mv_cesa_dev {
>  struct mv_cesa_engine {
>  	int id;
>  	void __iomem *regs;
> -	void __iomem *sram;
> +	union {
> +		void __iomem *sram;
> +		void *sram_pool;
> +	};
>  	dma_addr_t sram_dma;
>  	spinlock_t lock;
>  	struct crypto_async_request *req;
> @@ -867,6 +871,31 @@ int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
>  				 struct mv_cesa_sg_dma_iter *sgiter,
>  				 gfp_t gfp_flags);
>  
> +size_t mv_cesa_sg_copy(struct mv_cesa_engine *engine,
> +		       struct scatterlist *sgl, unsigned int nents,
> +		       unsigned int sram_off, size_t buflen, off_t skip,
> +		       bool to_sram);
> +
> +static inline size_t mv_cesa_sg_copy_to_sram(struct mv_cesa_engine *engine,
> +					     struct scatterlist *sgl,
> +					     unsigned int nents,
> +					     unsigned int sram_off,
> +					     size_t buflen, off_t skip)
> +{
> +	return mv_cesa_sg_copy(engine, sgl, nents, sram_off, buflen, skip,
> +			       true);
> +}
> +
> +static inline size_t mv_cesa_sg_copy_from_sram(struct mv_cesa_engine *engine,
> +					       struct scatterlist *sgl,
> +					       unsigned int nents,
> +					       unsigned int sram_off,
> +					       size_t buflen, off_t skip)
> +{
> +	return mv_cesa_sg_copy(engine, sgl, nents, sram_off, buflen, skip,
> +			       false);
> +}
> +
>  /* Algorithm definitions */
>  
>  extern struct ahash_alg mv_md5_alg;
> diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
> index b4a6ff9dd6d5..b739d3b873dc 100644
> --- a/drivers/crypto/marvell/cesa/cipher.c
> +++ b/drivers/crypto/marvell/cesa/cipher.c
> @@ -89,22 +89,29 @@ static void mv_cesa_skcipher_std_step(struct skcipher_request *req)
>  			    CESA_SA_SRAM_PAYLOAD_SIZE);
>  
>  	mv_cesa_adjust_op(engine, &sreq->op);
> -	memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
> +	if (engine->pool)
> +		memcpy(engine->sram_pool, &sreq->op, sizeof(sreq->op));
> +	else
> +		memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
>  
> -	len = sg_pcopy_to_buffer(req->src, creq->src_nents,
> -				 engine->sram + CESA_SA_DATA_SRAM_OFFSET,
> -				 len, sreq->offset);
> +	len = mv_cesa_sg_copy_to_sram(engine, req->src, creq->src_nents,
> +				      CESA_SA_DATA_SRAM_OFFSET, len,
> +				      sreq->offset);
>  
>  	sreq->size = len;
>  	mv_cesa_set_crypt_op_len(&sreq->op, len);
>  
>  	/* FIXME: only update enc_len field */
>  	if (!sreq->skip_ctx) {
> -		memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
> +		if (engine->pool)
> +			memcpy(engine->sram_pool, &sreq->op, sizeof(sreq->op));
> +		else
> +			memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op));
>  		sreq->skip_ctx = true;
> -	} else {
> +	} else if (engine->pool)
> +		memcpy(engine->sram_pool, &sreq->op, sizeof(sreq->op.desc));
> +	else
>  		memcpy_toio(engine->sram, &sreq->op, sizeof(sreq->op.desc));
> -	}
>  
>  	mv_cesa_set_int_mask(engine, CESA_SA_INT_ACCEL0_DONE);
>  	writel_relaxed(CESA_SA_CFG_PARA_DIS, engine->regs + CESA_SA_CFG);
> @@ -121,9 +128,9 @@ static int mv_cesa_skcipher_std_process(struct skcipher_request *req,
>  	struct mv_cesa_engine *engine = creq->base.engine;
>  	size_t len;
>  
> -	len = sg_pcopy_from_buffer(req->dst, creq->dst_nents,
> -				   engine->sram + CESA_SA_DATA_SRAM_OFFSET,
> -				   sreq->size, sreq->offset);
> +	len = mv_cesa_sg_copy_from_sram(engine, req->dst, creq->dst_nents,
> +					CESA_SA_DATA_SRAM_OFFSET, sreq->size,
> +					sreq->offset);
>  
>  	sreq->offset += len;
>  	if (sreq->offset < req->cryptlen)
> @@ -214,11 +221,14 @@ mv_cesa_skcipher_complete(struct crypto_async_request *req)
>  		basereq = &creq->base;
>  		memcpy(skreq->iv, basereq->chain.last->op->ctx.skcipher.iv,
>  		       ivsize);
> -	} else {
> +	} else if (engine->pool)
> +		memcpy(skreq->iv,
> +		       engine->sram_pool + CESA_SA_CRYPT_IV_SRAM_OFFSET,
> +		       ivsize);
> +	else
>  		memcpy_fromio(skreq->iv,
>  			      engine->sram + CESA_SA_CRYPT_IV_SRAM_OFFSET,
>  			      ivsize);
> -	}
>  }
>  
>  static const struct mv_cesa_req_ops mv_cesa_skcipher_req_ops = {
> diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
> index 8cf9fd518d86..c72b0672fc71 100644
> --- a/drivers/crypto/marvell/cesa/hash.c
> +++ b/drivers/crypto/marvell/cesa/hash.c
> @@ -168,7 +168,12 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
>  	int i;
>  
>  	mv_cesa_adjust_op(engine, &creq->op_tmpl);
> -	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
> +	if (engine->pool)
> +		memcpy(engine->sram_pool, &creq->op_tmpl,
> +		       sizeof(creq->op_tmpl));
> +	else
> +		memcpy_toio(engine->sram, &creq->op_tmpl,
> +			    sizeof(creq->op_tmpl));
>  
>  	if (!sreq->offset) {
>  		digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
> @@ -177,9 +182,14 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
>  				       engine->regs + CESA_IVDIG(i));
>  	}
>  
> -	if (creq->cache_ptr)
> -		memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,
> -			    creq->cache, creq->cache_ptr);
> +	if (creq->cache_ptr) {
> +		if (engine->pool)
> +			memcpy(engine->sram_pool + CESA_SA_DATA_SRAM_OFFSET,
> +			       creq->cache, creq->cache_ptr);
> +		else
> +			memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,
> +				    creq->cache, creq->cache_ptr);
> +	}
>  
>  	len = min_t(size_t, req->nbytes + creq->cache_ptr - sreq->offset,
>  		    CESA_SA_SRAM_PAYLOAD_SIZE);
> @@ -190,12 +200,10 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
>  	}
>  
>  	if (len - creq->cache_ptr)
> -		sreq->offset += sg_pcopy_to_buffer(req->src, creq->src_nents,
> -						   engine->sram +
> -						   CESA_SA_DATA_SRAM_OFFSET +
> -						   creq->cache_ptr,
> -						   len - creq->cache_ptr,
> -						   sreq->offset);
> +		sreq->offset += mv_cesa_sg_copy_to_sram(
> +			engine, req->src, creq->src_nents,
> +			CESA_SA_DATA_SRAM_OFFSET + creq->cache_ptr,
> +			len - creq->cache_ptr, sreq->offset);
>  
>  	op = &creq->op_tmpl;
>  
> @@ -220,16 +228,28 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
>  			if (len + trailerlen > CESA_SA_SRAM_PAYLOAD_SIZE) {
>  				len &= CESA_HASH_BLOCK_SIZE_MSK;
>  				new_cache_ptr = 64 - trailerlen;
> -				memcpy_fromio(creq->cache,
> -					      engine->sram +
> -					      CESA_SA_DATA_SRAM_OFFSET + len,
> -					      new_cache_ptr);
> +				if (engine->pool)
> +					memcpy(creq->cache,
> +					       engine->sram_pool +
> +					       CESA_SA_DATA_SRAM_OFFSET + len,
> +					       new_cache_ptr);
> +				else
> +					memcpy_fromio(creq->cache,
> +						      engine->sram +
> +						      CESA_SA_DATA_SRAM_OFFSET +
> +						      len,
> +						      new_cache_ptr);
>  			} else {
>  				i = mv_cesa_ahash_pad_req(creq, creq->cache);
>  				len += i;
> -				memcpy_toio(engine->sram + len +
> -					    CESA_SA_DATA_SRAM_OFFSET,
> -					    creq->cache, i);
> +				if (engine->pool)
> +					memcpy(engine->sram_pool + len +
> +					       CESA_SA_DATA_SRAM_OFFSET,
> +					       creq->cache, i);
> +				else
> +					memcpy_toio(engine->sram + len +
> +						    CESA_SA_DATA_SRAM_OFFSET,
> +						    creq->cache, i);
>  			}
>  
>  			if (frag_mode == CESA_SA_DESC_CFG_LAST_FRAG)
> @@ -243,7 +263,10 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
>  	mv_cesa_update_op_cfg(op, frag_mode, CESA_SA_DESC_CFG_FRAG_MSK);
>  
>  	/* FIXME: only update enc_len field */
> -	memcpy_toio(engine->sram, op, sizeof(*op));
> +	if (engine->pool)
> +		memcpy(engine->sram_pool, op, sizeof(*op));
> +	else
> +		memcpy_toio(engine->sram, op, sizeof(*op));
>  
>  	if (frag_mode == CESA_SA_DESC_CFG_FIRST_FRAG)
>  		mv_cesa_update_op_cfg(op, CESA_SA_DESC_CFG_MID_FRAG,
> diff --git a/drivers/crypto/marvell/cesa/tdma.c b/drivers/crypto/marvell/cesa/tdma.c
> index 0e0d63359798..f0b5537038c2 100644
> --- a/drivers/crypto/marvell/cesa/tdma.c
> +++ b/drivers/crypto/marvell/cesa/tdma.c
> @@ -350,3 +350,53 @@ int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
>  
>  	return 0;
>  }
> +
> +size_t mv_cesa_sg_copy(struct mv_cesa_engine *engine,
> +		       struct scatterlist *sgl, unsigned int nents,
> +		       unsigned int sram_off, size_t buflen, off_t skip,
> +		       bool to_sram)
> +{
> +	unsigned int sg_flags = SG_MITER_ATOMIC;
> +	struct sg_mapping_iter miter;
> +	unsigned int offset = 0;
> +
> +	if (to_sram)
> +		sg_flags |= SG_MITER_FROM_SG;
> +	else
> +		sg_flags |= SG_MITER_TO_SG;
> +
> +	sg_miter_start(&miter, sgl, nents, sg_flags);
> +
> +	if (!sg_miter_skip(&miter, skip))
> +		return 0;
> +
> +	while ((offset < buflen) && sg_miter_next(&miter)) {
> +		unsigned int len;
> +
> +		len = min(miter.length, buflen - offset);
> +
> +		if (to_sram) {
> +			if (engine->pool)
> +				memcpy(engine->sram_pool + sram_off + offset,
> +				       miter.addr, len);
> +			else
> +				memcpy_toio(engine->sram + sram_off + offset,
> +					    miter.addr, len);
> +		} else {
> +			if (engine->pool)
> +				memcpy(miter.addr,
> +				       engine->sram_pool + sram_off + offset,
> +				       len);
> +			else
> +				memcpy_fromio(miter.addr,
> +					      engine->sram + sram_off + offset,
> +					      len);
> +		}
> +
> +		offset += len;
> +	}
> +
> +	sg_miter_stop(&miter);
> +
> +	return offset;
> +}
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2F&amp;data=04%7C01%7Csven.auhagen%40voleatech.de%7Ce92f884faf51475c1f5f08d8bdcbcf36%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637468030359443421%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=k2cxVHZ3iMK8XE4OTd%2BHz%2F9PPXOvKPJoBv4VvGCGgww%3D&amp;reserved=0
> PGP Key: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2Fpubkey.txt&amp;data=04%7C01%7Csven.auhagen%40voleatech.de%7Ce92f884faf51475c1f5f08d8bdcbcf36%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637468030359443421%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=vLLpgcyh1wy9Efd%2B9qx4Ip7h%2FqJuO90%2B%2F3nJtQAlVPU%3D&amp;reserved=0
