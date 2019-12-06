Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730B3C43603
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 22:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4142E217BA
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 22:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575671512;
	bh=f9ayP6lakBWmjP6iwNF3BVLadJRvey+Y11sp9pV1K/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=nJCksew7vDtih/FYpNWMzPy2Ai1P03OkO92vLY3XZ4+qdPlQEg9Re+coAhmxeRQ4F
	 mkaILUgvoKVasa/G8m/71te/1xL3Qsu9IbjCB5H6RPg1E+fUYAaxCE8KP62DLMTEbM
	 xXoOJHtTXuhXOEtvO/F0tuU/CcgXLsJIoCfCN3mw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfLFWbv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Dec 2019 17:31:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:43932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfLFWbv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Dec 2019 17:31:51 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D4B2206DB;
        Fri,  6 Dec 2019 22:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575671511;
        bh=f9ayP6lakBWmjP6iwNF3BVLadJRvey+Y11sp9pV1K/Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b7pIZvq5F2uUGDHWjyuQM5R/R42JHCRIMxVUnG8HYncm/heP/EUAoyz3LcDYCdkF5
         lwKIy8LXNEBFaK3RAyd1qgcmXycDTPko/XAjsyuFcFZhKG1TFc9w3od8lVjVecOsiM
         JveUCB+xtgBAo100mZxRQQbg7LZ8+o2tTh0IK0ls=
Date:   Fri, 6 Dec 2019 14:31:49 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/4] crypto: api - Retain alg refcount in
 crypto_grab_spawn
Message-ID: <20191206223149.GD246840@gmail.com>
References: <20191206063812.ueudgjfwzri5ekpr@gondor.apana.org.au>
 <E1id7G8-000516-19@gondobar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1id7G8-000516-19@gondobar>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 06, 2019 at 02:38:36PM +0800, Herbert Xu wrote:
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index 9ecb4a57b342..6869feb31c99 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -662,7 +662,6 @@ int crypto_grab_spawn(struct crypto_spawn *spawn, const char *name,
>  		return PTR_ERR(alg);
>  
>  	err = crypto_init_spawn(spawn, alg, spawn->inst, mask);
> -	crypto_mod_put(alg);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(crypto_grab_spawn);

No need for 'err' anymore.  This should just do 'return crypto_init_spawn(...)'

- Eric
