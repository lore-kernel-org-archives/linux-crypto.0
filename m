Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE58AC433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 08:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE0D922BF5
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 08:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g518Chah"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgH0IDP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgH0IDO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 04:03:14 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31E5C061264;
        Thu, 27 Aug 2020 01:03:13 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h15so4391245wrt.12;
        Thu, 27 Aug 2020 01:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zPWziuz3LCO0WQPUnYkp4/1miRf1Z3XiRWMKLQJruX4=;
        b=g518ChahuatEds8QIMSD+o8jx/MfIXKn0ioukoF10QqjB8WzfDRDdhPOy8iLUtoVD6
         L2/Rql8RMcp9/T3IwtLShmTIg5auKyNbNG3cJh7p8aR7QAEvCPjCTdst3xSy89HDL0VV
         MsFwRW6mC0S3vY/ujOaiahHA0EkxbHntu7wbo9iVKBVArGF1oFvuFAnUuY5gYxgvMzIE
         QJWCgwgEyqu8q0LYwdtBptX5N5K/SSVsp4OVMYQEt5KbpvEpGOQvFmo9zl9OJPd705Yr
         D5UPS0968YqhjP3rzZlwtMqviXV+hsajAWHtt681iRmxdAVpSfbZ2owCGj6wmOU5GT2a
         LFpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zPWziuz3LCO0WQPUnYkp4/1miRf1Z3XiRWMKLQJruX4=;
        b=l9YwWL7cflwndM/6+iRdyU5U1EFaafsRX1svBRJB6iOVgZdvj/v7S+gv+R6NVFIifw
         n2MRvC9B1Ykja4UD1wG0v5BwkTR/VUR8Z9yDYt+PV+9ZiMVdAIzLzdiK1L7ZkhFiLGzU
         A5n+FPwYnqTW7/RE8N8ypq06UXZukLLZB4+a2p+OoMsDilj9slObftNVUSiJ+e33sCNA
         8WEV5bmSJwT6K2YmIcmYRRvT5rMLYHQI0t53obSp8OwGIF85uwE9e4ihScX7Gj3y3mmj
         HsoJ0Gi9MmM96AJ80Bum/5kJ80WdB6ZXoyINac11opDtCL0mEcRjB1XnOIKMnVAU9JjL
         Gp1g==
X-Gm-Message-State: AOAM533onAFoJF0qsXPwX7m4znao2D5P9rQsAAKiZ8Y724ewU7bGdtEa
        HqlDOKgqXVTj87kjCjLsWe8=
X-Google-Smtp-Source: ABdhPJzGp61xe0Gsy8NKvKUnUa/mtH0mX+6nZ5odV/vnmJpvRw48eE0aNfPx4UtYEFibakuMAWTcTA==
X-Received: by 2002:adf:f192:: with SMTP id h18mr15865363wro.247.1598515392581;
        Thu, 27 Aug 2020 01:03:12 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id e2sm4251407wrt.66.2020.08.27.01.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 01:03:11 -0700 (PDT)
Date:   Thu, 27 Aug 2020 10:03:10 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sun8i-ss - remove redundant memzero_explicit()
Message-ID: <20200827080310.GA29222@Red>
References: <20200827074023.15565-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827074023.15565-1-efremov@linux.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 27, 2020 at 10:40:23AM +0300, Denis Efremov wrote:
> Remove redundant memzero_explicit() in sun8i_ss_cipher() before calling
> kfree_sensitive(). kfree_sensitive() will zero the memory with
> memzero_explicit().
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> index deb8b39a86db..ed2a69f82e1c 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> @@ -248,7 +248,6 @@ static int sun8i_ss_cipher(struct skcipher_request *areq)
>  			offset = areq->cryptlen - ivsize;
>  			if (rctx->op_dir & SS_DECRYPTION) {
>  				memcpy(areq->iv, backup_iv, ivsize);
> -				memzero_explicit(backup_iv, ivsize);
>  				kfree_sensitive(backup_iv);
>  			} else {
>  				scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
> -- 
> 2.26.2
> 

Hello

Could you add:
Fixes: 453431a54934 ("mm, treewide: rename kzfree() to kfree_sensitive()")

Regards
