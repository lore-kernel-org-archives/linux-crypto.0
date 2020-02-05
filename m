Return-Path: <SRS0=oWw0=3Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A30CC35247
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 19:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D479217BA
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 19:11:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MFyyiATY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgBETLd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 14:11:33 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38175 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgBETLd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 14:11:33 -0500
Received: by mail-wm1-f66.google.com with SMTP id a9so4172694wmj.3;
        Wed, 05 Feb 2020 11:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jMov4KbETyM2WMoQRxMlok3LUpvFHoRjtuVdQssH7qc=;
        b=MFyyiATYYDslQazdI+M1S6zJoUcmUuu2qGCEfjYlAdSm15sFBeMhqZaKgqFxh5mCXr
         mkNyVuWGVZG8Xa1XmMzL1Lf0iLW90BxQy3mZafy179P49bOPTMs1jRqQ+GZMGdJBrxSu
         urkC8c1SqBYoxzLw6ptMLn6kJ1zpZx+8LudsTT2LiOr4M6Fe6RpKogzDWI593bKhQVqI
         3M/AIrObzFSC4PbLLD0QrVVuiM/1hfERWgqE8woiBpC+kAfcgjzqpOTNXlCFB0C1I6X6
         xmgnt2UA6FmE5qhRVgjpUoLizW6TfRkrm3Q+8LdbjY+ofIzRS4C2qhRrJ1QwQgNI3tkd
         pJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jMov4KbETyM2WMoQRxMlok3LUpvFHoRjtuVdQssH7qc=;
        b=gRg9jZf9aEr/5MbUYRrGojnLdDAIbtGhEMBd3DX2Q2vx+KepGaQt6+LFRhtnfxNV7p
         I9JlY6xJXbfTHIW/ZovoQgqsZPTK6lPZb26JzTayJS/67CDte8V6M72aPK7FCeUB9Y6S
         cAbDU9cv+YBZCJFxJqwQur/oOn+k/n3SOC8brL2vvBKPbPsBilN/eLqK5q9OXEdLyMRy
         1q72uwKmzZtYL/vfZdsc9Q7dTfKWQ42ZmAOed3YfkPlAzl6YRPPNx44vKKng1Obcc3Gd
         KZ4AajAxEQxW5/YwfZCngm2UwW8/UHLLPBMdbztjxyiTvCpqeD/dYvjVN6bVnsSH16/l
         7RJQ==
X-Gm-Message-State: APjAAAWVW56p/EVbs1ZLMnkioalpFEYyCYRooLPYA1dsqRc0H59APd/T
        3yOzpmgiJXRkFGCEnnE9HDQ=
X-Google-Smtp-Source: APXvYqxnArd6FNdbfRC8VRQ5oBDCx0vD9IKE5niHMygUbt1QSf4kw+bjgZD3w3sfbRUPodqOTlGhKQ==
X-Received: by 2002:a7b:c934:: with SMTP id h20mr7155581wml.103.1580929890748;
        Wed, 05 Feb 2020 11:11:30 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y17sm917898wrs.82.2020.02.05.11.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 11:11:30 -0800 (PST)
Date:   Wed, 5 Feb 2020 20:11:28 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Baolin Wang <baolin.wang@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <mripard@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 1/2] crypto: engine - support for parallel requests
Message-ID: <20200205191128.GA32606@Red>
References: <1580819660-30211-1-git-send-email-iuliana.prodan@nxp.com>
 <1580819660-30211-2-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580819660-30211-2-git-send-email-iuliana.prodan@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 04, 2020 at 02:34:19PM +0200, Iuliana Prodan wrote:
> Added support for executing multiple requests, in parallel,
> for crypto engine.
> A new callback is added, can_enqueue_more, which asks the
> driver if the hardware has free space, to enqueue a new request.
> The new crypto_engine_alloc_init_and_set function, initialize
> crypto-engine, sets the maximum size for crypto-engine software
> queue (not hardcoded anymore) and the can_enqueue_more callback.
> On crypto_pump_requests, if can_enqueue_more callback returns true,
> a new request is send to hardware, until there is no space and the
> callback returns false.
> 
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> ---
>  crypto/crypto_engine.c  | 106 ++++++++++++++++++++++++++++++------------------
>  include/crypto/engine.h |  10 +++--
>  2 files changed, 72 insertions(+), 44 deletions(-)
> 
> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
> index eb029ff..aba934f 100644
> --- a/crypto/crypto_engine.c
> +++ b/crypto/crypto_engine.c
> @@ -22,32 +22,18 @@
>   * @err: error number
>   */
>  static void crypto_finalize_request(struct crypto_engine *engine,
> -			     struct crypto_async_request *req, int err)
> +				    struct crypto_async_request *req, int err)
>  {
> -	unsigned long flags;
> -	bool finalize_cur_req = false;
>  	int ret;
>  	struct crypto_engine_ctx *enginectx;
>  
> -	spin_lock_irqsave(&engine->queue_lock, flags);
> -	if (engine->cur_req == req)
> -		finalize_cur_req = true;
> -	spin_unlock_irqrestore(&engine->queue_lock, flags);
> -
> -	if (finalize_cur_req) {
> -		enginectx = crypto_tfm_ctx(req->tfm);
> -		if (engine->cur_req_prepared &&
> -		    enginectx->op.unprepare_request) {
> -			ret = enginectx->op.unprepare_request(engine, req);
> -			if (ret)
> -				dev_err(engine->dev, "failed to unprepare request\n");
> -		}
> -		spin_lock_irqsave(&engine->queue_lock, flags);
> -		engine->cur_req = NULL;
> -		engine->cur_req_prepared = false;
> -		spin_unlock_irqrestore(&engine->queue_lock, flags);
> +	enginectx = crypto_tfm_ctx(req->tfm);
> +	if (enginectx->op.prepare_request &&
> +	    enginectx->op.unprepare_request) {
> +		ret = enginectx->op.unprepare_request(engine, req);
> +		if (ret)
> +			dev_err(engine->dev, "failed to unprepare request\n");
>  	}
> -
>  	req->complete(req, err);
>  
>  	kthread_queue_work(engine->kworker, &engine->pump_requests);
> @@ -73,10 +59,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
>  
>  	spin_lock_irqsave(&engine->queue_lock, flags);
>  
> -	/* Make sure we are not already running a request */
> -	if (engine->cur_req)
> -		goto out;
> -

Hello

Your patch has the same problem than mine reported by Horia.
If a queue has more than one request, a first crypto_pump_requests() will send a request and for drivers which do not block on do_one_request() crypto_pump_requests() will end.
Then another crypto_pump_requests() will fire sending a second request while the driver does not support that.

So we need to replace engine->cur_req by another locking mechanism.
Perhaps the cleaner is to add a "request count" (increased when do_one_request, decreased in crypto_finalize_request)
I know that the early version have that and it was removed, but I do not see any better way.

Regards
