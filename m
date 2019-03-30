Return-Path: <SRS0=3MGL=SB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4497C43381
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 09:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2AB720643
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 09:59:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BUMMNWCd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fHhtajqJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbfC3J7A (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Mar 2019 05:59:00 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39976 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730372AbfC3J7A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Mar 2019 05:59:00 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 620F561110; Sat, 30 Mar 2019 09:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553939938;
        bh=YwPPQXD8Nw0XqGJWkHPsI/ayS6Fml0waQceWOVmBq7g=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=BUMMNWCdxQY/QJ4cvUSW8LBn6XeeHfr9diawYJnsbwjKvt9EZRVMcrVobsFrG1WlH
         vYIfqXZCs0qNDhhAi3jK3VIRqLYEPD5JCeLd9mKVNOXwQc66He/C+jTtyEZyM8cRpJ
         hJO8epP5EwLE2pouLfLPvL3Fyp2M/TFg0vaq15sA=
Received: from [10.79.174.164] (blr-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 08ECD60A4E;
        Sat, 30 Mar 2019 09:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553939933;
        bh=YwPPQXD8Nw0XqGJWkHPsI/ayS6Fml0waQceWOVmBq7g=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fHhtajqJxIZweByZZgH71N/dxy2Qt+DHpoMZoeyDgeg76yBAgiF2Fe+C6eHYtcqgh
         OzleMOW3ZJYPKjm5Yn9XVUg2Sd7QXnlpS+HuMAQa4C1KPoeP/gNlAr+lHsyAs6k1EM
         wME2XoddP/fxZZVMWMEnioMGuay8JJpgtWpynu3o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 08ECD60A4E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH -next] crypto: nx842 - remove set but not used variables
 'dpadding' and 'max_sync_size'
To:     Yue Haibing <yuehaibing@huawei.com>, haren@us.ibm.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20190330055429.25848-1-yuehaibing@huawei.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <e69b2afd-8697-f51c-af4a-89b262f4d3d9@codeaurora.org>
Date:   Sat, 30 Mar 2019 15:28:39 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190330055429.25848-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 3/30/2019 11:24 AM, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/crypto/nx/nx-842.c: In function 'decompress':
> drivers/crypto/nx/nx-842.c:356:25: warning: variable 'dpadding' set but not used [-Wunused-but-set-variable]
> drivers/crypto/nx/nx-842-pseries.c: In function 'nx842_pseries_compress':
> drivers/crypto/nx/nx-842-pseries.c:299:15: warning: variable 'max_sync_size' set but not used [-Wunused-but-set-variable]
> drivers/crypto/nx/nx-842-pseries.c: In function 'nx842_pseries_decompress':
> drivers/crypto/nx/nx-842-pseries.c:430:15: warning: variable 'max_sync_size' set but not used [-Wunused-but-set-variable]
>
> They are not used any more and can be removed.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh
> ---
>   drivers/crypto/nx/nx-842-pseries.c | 6 ++----
>   drivers/crypto/nx/nx-842.c         | 3 +--
>   2 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
> index 6686997..5793284 100644
> --- a/drivers/crypto/nx/nx-842-pseries.c
> +++ b/drivers/crypto/nx/nx-842-pseries.c
> @@ -296,7 +296,7 @@ static int nx842_pseries_compress(const unsigned char *in, unsigned int inlen,
>   	struct nx842_workmem *workmem;
>   	struct nx842_scatterlist slin, slout;
>   	struct nx_csbcpb *csbcpb;
> -	int ret = 0, max_sync_size;
> +	int ret = 0;
>   	unsigned long inbuf, outbuf;
>   	struct vio_pfo_op op = {
>   		.done = NULL,
> @@ -319,7 +319,6 @@ static int nx842_pseries_compress(const unsigned char *in, unsigned int inlen,
>   		rcu_read_unlock();
>   		return -ENODEV;
>   	}
> -	max_sync_size = local_devdata->max_sync_size;
>   	dev = local_devdata->dev;
>   
>   	/* Init scatterlist */
> @@ -427,7 +426,7 @@ static int nx842_pseries_decompress(const unsigned char *in, unsigned int inlen,
>   	struct nx842_workmem *workmem;
>   	struct nx842_scatterlist slin, slout;
>   	struct nx_csbcpb *csbcpb;
> -	int ret = 0, max_sync_size;
> +	int ret = 0;
>   	unsigned long inbuf, outbuf;
>   	struct vio_pfo_op op = {
>   		.done = NULL,
> @@ -451,7 +450,6 @@ static int nx842_pseries_decompress(const unsigned char *in, unsigned int inlen,
>   		rcu_read_unlock();
>   		return -ENODEV;
>   	}
> -	max_sync_size = local_devdata->max_sync_size;
>   	dev = local_devdata->dev;
>   
>   	workmem = PTR_ALIGN(wmem, WORKMEM_ALIGN);
> diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
> index d94e25d..f06565d 100644
> --- a/drivers/crypto/nx/nx-842.c
> +++ b/drivers/crypto/nx/nx-842.c
> @@ -353,7 +353,7 @@ static int decompress(struct nx842_crypto_ctx *ctx,
>   	unsigned int adj_slen = slen;
>   	u8 *src = p->in, *dst = p->out;
>   	u16 padding = be16_to_cpu(g->padding);
> -	int ret, spadding = 0, dpadding = 0;
> +	int ret, spadding = 0;
>   	ktime_t timeout;
>   
>   	if (!slen || !required_len)
> @@ -413,7 +413,6 @@ static int decompress(struct nx842_crypto_ctx *ctx,
>   		spadding = 0;
>   		dst = p->out;
>   		dlen = p->oremain;
> -		dpadding = 0;
>   		if (dlen < required_len) { /* have ignore bytes */
>   			dst = ctx->dbounce;
>   			dlen = BOUNCE_BUFFER_SIZE;
