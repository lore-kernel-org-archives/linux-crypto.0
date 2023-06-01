Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42972C77B7A
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jun 2023 19:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbjFATLF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jun 2023 15:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjFATLE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2023 15:11:04 -0400
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413BB186
        for <linux-crypto@vger.kernel.org>; Thu,  1 Jun 2023 12:10:21 -0700 (PDT)
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6260b578097so10904906d6.3
        for <linux-crypto@vger.kernel.org>; Thu, 01 Jun 2023 12:10:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685646620; x=1688238620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hm7Jjh9TF3Bsq+esRbEZ2y936YTbpq5qnxQF0w6eX7M=;
        b=H6h67NlSnRvdOf5g3GoLF9c2Fmsjmr8qxRal6LLvABOKiRHbpfFPuaWgSO1mD6hlUv
         1oMiCuMaTLTMny4jt0IO2kOf02mrivmKeAFEsRNgUq2ZedbRNWIuTeV/rFjCc1s6ZqKq
         LZoOmTrVRc9qN87T7h69yVe7NxeQ/04KrPe4mCblEurvBxSLeMrUmrWjjS6xXxeQ9FSD
         rlUnli8hrgWIVhdxMZFN7KTehn1UlEGQqTX+ljYg+P4glLlwA2Pr4xuV5YzhzCWQ5RJg
         MmJ1sqdnCIkm2PB0QkTIe+MMFm/FR261lT5CW++F27T+R9r7uAg0LFjuLU0Ms3CfCl6z
         sK3g==
X-Gm-Message-State: AC+VfDwGD9FJCd9bTXjVoH2rE1TVcd2zDry+4kPHdQzAtiym+ra2L9IT
        Qm9KB13Nf8npv3Ob6iTsv+m+
X-Google-Smtp-Source: ACHHUZ7bZ4cyi3vQcWjCBhem09VoTvBAo4ZBUsrNepalRX5b0TnPcFZq7rotFJybrs3TC5fTvPZnGQ==
X-Received: by 2002:a05:6214:1bcb:b0:628:3e37:e175 with SMTP id m11-20020a0562141bcb00b006283e37e175mr6190986qvc.25.1685646620329;
        Thu, 01 Jun 2023 12:10:20 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net. [68.160.166.30])
        by smtp.gmail.com with ESMTPSA id mn6-20020a0562145ec600b0060530c942f4sm7830403qvb.46.2023.06.01.12.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 12:10:19 -0700 (PDT)
Date:   Thu, 1 Jun 2023 15:10:18 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: dm crypt: Avoid using MAX_CIPHER_BLOCKSIZE
Message-ID: <ZHjtGvf+gHxeV83V@redhat.com>
References: <ZHhbL+SbWRnTW4b7@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHhbL+SbWRnTW4b7@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 01 2023 at  4:47P -0400,
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> MAX_CIPHER_BLOCKSIZE is an internal implementation detail and should
> not be relied on by users of the Crypto API.
> 
> Instead of storing the IV on the stack, allocate it together with
> the crypto request.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  drivers/md/dm-crypt.c |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 40cb1719ae4d..0e7e443dde11 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -31,10 +31,10 @@
>  #include <asm/unaligned.h>
>  #include <crypto/hash.h>
>  #include <crypto/md5.h>
> -#include <crypto/algapi.h>
>  #include <crypto/skcipher.h>
>  #include <crypto/aead.h>
>  #include <crypto/authenc.h>
> +#include <crypto/utils.h>
>  #include <linux/rtnetlink.h> /* for struct rtattr and RTA macros only */
>  #include <linux/key-type.h>
>  #include <keys/user-type.h>
> @@ -743,16 +743,23 @@ static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
>  static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
>  			    struct dm_crypt_request *dmreq)
>  {
> -	u8 buf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
> +	struct crypto_skcipher *tfm = any_tfm(cc);
>  	struct skcipher_request *req;
>  	struct scatterlist src, dst;
>  	DECLARE_CRYPTO_WAIT(wait);
> +	unsigned int reqsize;
>  	int err;
> +	u8 *buf;
>  
> -	req = skcipher_request_alloc(any_tfm(cc), GFP_NOIO);
> +	reqsize = ALIGN(crypto_skcipher_reqsize(tfm), __alignof__(__le64));
> +
> +	req = kmalloc(reqsize + cc->iv_size, GFP_NOIO);
>  	if (!req)
>  		return -ENOMEM;
>  
> +	skcipher_request_set_tfm(req, tfm);
> +
> +	buf = (u8 *)req + reqsize;
>  	memset(buf, 0, cc->iv_size);
>  	*(__le64 *)buf = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
>  
> @@ -761,7 +768,7 @@ static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
>  	skcipher_request_set_crypt(req, &src, &dst, cc->iv_size, buf);
>  	skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
>  	err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
> -	skcipher_request_free(req);
> +	kfree_sensitive(req);
>  
>  	return err;
>  }


Strikes me as strange that open-coding skcipher_request_{alloc,free}
is ideal, but dm-crypt is the only non-crypto consumer of
MAX_CIPHER_BLOCKSIZE so really not worth standing up yet another
interface wrapper.

Anyway, this code is certainly better for dm-crypt's needs.  I'm happy
with you applying this change via your crypto tree.

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

Thanks.
