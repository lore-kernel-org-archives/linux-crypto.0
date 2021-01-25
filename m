Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F65C433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jan 2021 16:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3648622583
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jan 2021 16:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730755AbhAYQdD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jan 2021 11:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730760AbhAYQc4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jan 2021 11:32:56 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05861C06178B
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jan 2021 08:32:16 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id v1so13286944ott.10
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jan 2021 08:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7wM9j0NmA+4NCioKAFo7iToU4fViUTFlRLMQnGMrXNk=;
        b=KsGUFXVFxfjbbXtXhs0lhCDVXgarAmZ4nMCt1BNDjKBtjhVtgaRYXX7+phfMlOjjUh
         SpNSW7SUWGZpc11eF4KT1ZT8OZCoWmlzYzs2xFQxzNzNDswA9ysPbRVVbEuHxg+FXjx0
         1Rz+N9cl/cvoQONSrXWps4vCjks3ImqzBdh5LD8ulBjtn0wlMtijSFQ+IbY2zCZonhvD
         NVI8R8yj+ROhiZ5wAo9sX18AYmeTtRkaixRhqF80YwlvKQgOfOQd4pF9osxBOWsh8XLE
         X4NgTnWfOFteeI4lSFPzA96B+TxxBVPVrshFfdIljSQmOTXv0cNBgRN8ZQvq4b2QXtv4
         T+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7wM9j0NmA+4NCioKAFo7iToU4fViUTFlRLMQnGMrXNk=;
        b=IBJHW1zSiAjHgfmhttjeTQExc21Hh0UlHsQGkjaBZ9oX681QK8e2cDhpG9MyhHGPbP
         GxV2pEvkwd23p1mHujoNZTHRCX0IhOMTivzcuYkwhfUQNPGGXFxfYR+bbe7Fs7QZ7xGc
         lMFaNNyF8GCSmVT1QRysSlEsbD6CJex5ajznLHJI6neLPh7jKeT0oyhrCipxyY6o9NaI
         4RT3ipskIgXjbdQ1Cy2xlrS5FXXjXbli0PQ4BJt6bwF4gDrWQocgiyWzB2AhxIuBAykL
         C5QNxbl18mu8u1IOh+YEDUh0Gu/ePaeKdIIeo3d1XlUf1WFS5EhyzqHBtA8Y5KgR4wOC
         nfYg==
X-Gm-Message-State: AOAM530E2R9020GuNpQnnIltNhHAnRDBor+XjGj+tj5ujvCOWRVF/cFx
        /RvmOvF5fsxPJe42ducJIBH7mA==
X-Google-Smtp-Source: ABdhPJweEWp9FLUDyOiNygFsnpmUpVHPjSLC6uPkcAYJUzp0nqWKZ4rzsEErke2GCAyw3KqLnS3uAg==
X-Received: by 2002:a9d:7ccd:: with SMTP id r13mr1003348otn.253.1611592335446;
        Mon, 25 Jan 2021 08:32:15 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id h30sm3252354ooi.12.2021.01.25.08.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 08:32:14 -0800 (PST)
Date:   Mon, 25 Jan 2021 10:32:13 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/6] drivers: crypto: qce: Remover src_tbl from
 qce_cipher_reqctx
Message-ID: <YA7yjaz6kxxs8eTl@builder.lan>
References: <20210120184843.3217775-1-thara.gopinath@linaro.org>
 <20210120184843.3217775-6-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120184843.3217775-6-thara.gopinath@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed 20 Jan 12:48 CST 2021, Thara Gopinath wrote:

> src_table is unused and hence remove it from struct qce_cipher_reqctx
> 
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---
>  drivers/crypto/qce/cipher.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/crypto/qce/cipher.h b/drivers/crypto/qce/cipher.h
> index cffa9fc628ff..850f257d00f3 100644
> --- a/drivers/crypto/qce/cipher.h
> +++ b/drivers/crypto/qce/cipher.h
> @@ -40,7 +40,6 @@ struct qce_cipher_reqctx {
>  	struct scatterlist result_sg;
>  	struct sg_table dst_tbl;
>  	struct scatterlist *dst_sg;
> -	struct sg_table src_tbl;

Please also remove the associated kerneldoc entry.

Regards,
Bjorn

>  	struct scatterlist *src_sg;
>  	unsigned int cryptlen;
>  	struct skcipher_request fallback_req;	// keep at the end
> -- 
> 2.25.1
> 
