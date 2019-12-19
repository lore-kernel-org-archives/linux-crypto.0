Return-Path: <SRS0=xTm+=2J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087B2C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 20:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCEA9227BF
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 20:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576787642;
	bh=5BJIA4TZawyxfy3MC3GPUXe62EsLf6lRjIPw121cFLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Xy4icJQVXETel5PhHlAO8KU3MzgJuRdW0hekrfK+5cQS86ZargH3QkmrrOxbIgOI+
	 okn9IRVTcGMxk7pxAg3DL1veprypIH4EZgyxe43VZU4v9jenuaqa/ql2i0ktRuc5hB
	 EeV2S2Gi+zTjwn014xTNQchafo+zZBhA1EEF+4PU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfLSUeC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Dec 2019 15:34:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbfLSUeC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Dec 2019 15:34:02 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89C9E21D7D;
        Thu, 19 Dec 2019 20:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576787641;
        bh=5BJIA4TZawyxfy3MC3GPUXe62EsLf6lRjIPw121cFLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WKwjhRdEj7onYsJZfBIr19NfG3BQ09lzqN34MCs5wuLRKf4sCh4qwPPvuxpk88ZKs
         lIKUUV/5ZBWDIyoGA3SZ4l9B7O5M2oox6qUiEByGSMIZuC4lks76JF8XWN8ijxcxSn
         7PAt9EavLjJcKT5q6zMENJMX/vCZr5Wqu5UZHydc=
Date:   Thu, 19 Dec 2019 12:34:00 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH] crypto: skcipher - Add skcipher_ialg_simple helper
Message-ID: <20191219203359.GB54076@gmail.com>
References: <20191206055704.g2g5y2e5dakxj7za@gondor.apana.org.au>
 <20191218080733.2ckqf4e5qmgnnrjd@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218080733.2ckqf4e5qmgnnrjd@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 18, 2019 at 04:07:33PM +0800, Herbert Xu wrote:
> This patch introduces the skcipher_ialg_simple helper which fetches
> the crypto_alg structure from a simple skcpiher instance's spawn.

Typo: skcpiher => skcipher

> diff --git a/crypto/ecb.c b/crypto/ecb.c
> index 9d6981ca7d5d..249aca75b7dc 100644
> --- a/crypto/ecb.c
> +++ b/crypto/ecb.c
> @@ -64,10 +64,12 @@ static int crypto_ecb_create(struct crypto_template *tmpl, struct rtattr **tb)
>  	struct crypto_alg *alg;
>  	int err;
>  
> -	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
> +	inst = skcipher_alloc_instance_simple(tmpl, tb);
>  	if (IS_ERR(inst))
>  		return PTR_ERR(inst);
>  
> +	alg = skcipher_ialg_simple(inst);
> +
>  	inst->alg.ivsize = 0; /* ECB mode doesn't take an IV */
>  
>  	inst->alg.encrypt = crypto_ecb_encrypt;
> @@ -76,7 +78,7 @@ static int crypto_ecb_create(struct crypto_template *tmpl, struct rtattr **tb)
>  	err = skcipher_register_instance(tmpl, inst);
>  	if (err)
>  		inst->free(inst);
> -	crypto_mod_put(alg);
> +
>  	return err;
>  }

For ecb, 'alg' isn't used anymore, so it should just be removed.

> diff --git a/crypto/pcbc.c b/crypto/pcbc.c
> index 862cdb8d8b6c..5c5245647208 100644
> --- a/crypto/pcbc.c
> +++ b/crypto/pcbc.c
> @@ -156,17 +156,19 @@ static int crypto_pcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
>  	struct crypto_alg *alg;
>  	int err;
>  
> -	inst = skcipher_alloc_instance_simple(tmpl, tb, &alg);
> +	inst = skcipher_alloc_instance_simple(tmpl, tb);
>  	if (IS_ERR(inst))
>  		return PTR_ERR(inst);
>  
> +	alg = skcipher_ialg_simple(inst);
> +
>  	inst->alg.encrypt = crypto_pcbc_encrypt;
>  	inst->alg.decrypt = crypto_pcbc_decrypt;
>  
>  	err = skcipher_register_instance(tmpl, inst);
>  	if (err)
>  		inst->free(inst);
> -	crypto_mod_put(alg);
> +
>  	return err;
>  }

Same for pcbc.

- Eric
