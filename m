Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25E2C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jan 2021 19:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8817E22CE3
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jan 2021 19:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbhAZF6t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jan 2021 00:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730685AbhAYQTz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jan 2021 11:19:55 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87356C061786
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jan 2021 08:19:14 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id a109so13277534otc.1
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jan 2021 08:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y9Fsn2jfHkFIrA5bW8cDuY4amagOU6WxYdUpBc0EWbM=;
        b=f35foE0Cx8SIvXwYd5AkZ+rsJeccF30iQEEwXO431gw0SAwNAQm0hmRcG9zIA7Z083
         vD8apYXgsSy1FYJxluAJulpwxPE3pAsniGqVP7qCHdW/ScZDklDyQ+Cs3Oj24TcQIa0Q
         ysy+iulClvS1IK3/8tpzS2f7y8Bcehyr27C1QlHDcpmyiMli/ON363G/8Qq9y5WKRCs2
         3Y5e/qbcyTejJhDfhEzF1P+huIagPcuabgqatjDyvqeLa3SZrAPvwqxrcqIeuwiI2uL8
         T6R+VJSn+MS68/mXa5dZjuV5wuQd6KtUIvimQW7B9lt1wOin2DJN/SKaIbbo48KTQeeI
         zidw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y9Fsn2jfHkFIrA5bW8cDuY4amagOU6WxYdUpBc0EWbM=;
        b=GgXUx7hwKG6RTxMVqkZtvcbPprGfeGuG0U4KTlcbx4va2MsMmzH2o07HP3ErBnYEVE
         Z7mXE7qFagjIOO9phSaIrZkO9iS/eSZnCXyRXigsL4dqYCeeF+2NAq/gkhk0iVDf24qJ
         tK15OWOYD8BLy2g4mSPDcRCepULCozmDzI+DxWZYyFtDqdRj74NFRoFAgT8BMf/ifFtT
         7Jd4lvHdXVU8cYlJuS/r1N6nzUtR4gFYzZtm/n8E2Ko8K0F2wsSndZbf0wNWk5LfqOD2
         BUly4+WuD9rpCu8Zvgxz3gsWVzCgxEvI0RxAniOVVhGOgWvC7zUWo+LQ3j8ZKAAhDuzM
         JLjg==
X-Gm-Message-State: AOAM532ph+a/FxSk91r7tMjCe+HruV5DCFH9wDo4z71R29ecdvg1KwfG
        9mJOB1rj0is3snfB7KhENVz0TQ==
X-Google-Smtp-Source: ABdhPJzFaIphTGrsrxOU+aDKm6mW1PpqUVSACH6ly/1sYqZSzfa8zNY6JYtn/CFZvIl7Hdtannv60Q==
X-Received: by 2002:a9d:347:: with SMTP id 65mr989868otv.4.1611591553963;
        Mon, 25 Jan 2021 08:19:13 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id d3sm313238ooi.42.2021.01.25.08.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 08:19:13 -0800 (PST)
Date:   Mon, 25 Jan 2021 10:19:11 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/6] drivers: crypto: qce: sha: Hold back a block of
 data to be transferred as part of final
Message-ID: <YA7vf9ilbeI9fskA@builder.lan>
References: <20210120184843.3217775-1-thara.gopinath@linaro.org>
 <20210120184843.3217775-3-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120184843.3217775-3-thara.gopinath@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed 20 Jan 12:48 CST 2021, Thara Gopinath wrote:

> If the available data to transfer is exactly a multiple of block size, save
> the last block to be transferred in qce_ahash_final (with the last block
> bit set) if this is indeed the end of data stream. If not this saved block
> will be transferred as part of next update. If this block is not held back
> and if this is indeed the end of data stream, the digest obtained will be
> wrong since qce_ahash_final will see that rctx->buflen is 0 and return
> doing nothing which in turn means that a digest will not be copied to the
> destination result buffer.  qce_ahash_final cannot be made to alter this
> behavior and allowed to proceed if rctx->buflen is 0 because the crypto
> engine BAM does not allow for zero length transfers.
> 

Please drop "drivers: " from $subject.

Apart from that this looks good.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---
>  drivers/crypto/qce/sha.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
> index 08aed03e2b59..dd263c5e4dd8 100644
> --- a/drivers/crypto/qce/sha.c
> +++ b/drivers/crypto/qce/sha.c
> @@ -216,6 +216,25 @@ static int qce_ahash_update(struct ahash_request *req)
>  
>  	/* calculate how many bytes will be hashed later */
>  	hash_later = total % blocksize;
> +
> +	/*
> +	 * At this point, there is more than one block size of data.  If
> +	 * the available data to transfer is exactly a multiple of block
> +	 * size, save the last block to be transferred in qce_ahash_final
> +	 * (with the last block bit set) if this is indeed the end of data
> +	 * stream. If not this saved block will be transferred as part of
> +	 * next update. If this block is not held back and if this is
> +	 * indeed the end of data stream, the digest obtained will be wrong
> +	 * since qce_ahash_final will see that rctx->buflen is 0 and return
> +	 * doing nothing which in turn means that a digest will not be
> +	 * copied to the destination result buffer.  qce_ahash_final cannot
> +	 * be made to alter this behavior and allowed to proceed if
> +	 * rctx->buflen is 0 because the crypto engine BAM does not allow
> +	 * for zero length transfers.
> +	 */
> +	if (!hash_later)
> +		hash_later = blocksize;
> +
>  	if (hash_later) {
>  		unsigned int src_offset = req->nbytes - hash_later;
>  		scatterwalk_map_and_copy(rctx->buf, req->src, src_offset,
> -- 
> 2.25.1
> 
