Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06069C433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 22:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D50D3611CC
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 22:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347440AbhDMWdn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 18:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347432AbhDMWdl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 18:33:41 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2300C061756
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 15:33:19 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id d12so18581585oiw.12
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 15:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sqfGaBhe70BoTx0o+2mDgjDn7lEZItlnBeAJOK0Lkqc=;
        b=qyX1PsIYpCoV5z15FYGA8pPKLWbbT0QW6FBhxE7DxXJxlRwO3Fh8f0v3QqeNVbcnnz
         iJvB7tR87kNU1XYb6NQWc4lfXAoMP/uFvZPCvrI110b+FvQWFwESkRSPpk7Iya/5Vt+/
         x8/TyAT9eWwrc013FMu0gYMbOfd8bmNCD1C9f5SrvWjeD7CzAi+0AAVVPllUXAR2HEZN
         08UTOyh8vTLAeKD2yN8Z4CfRHkT3Y+Xw0QlyD2TV6RBceTFBA5aQX9D9bsxGOICaCpm3
         1ROcsZ/ZW/KmC9OEJrrzhIVhSiBRGlcK1QQjBnZl2TLWoXiq8yqlzSntHqqKonmmhm3S
         pOAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sqfGaBhe70BoTx0o+2mDgjDn7lEZItlnBeAJOK0Lkqc=;
        b=cYNV7aUgRj90w2WgQeSSptxvhB+AlSD9nUdvjqE7vGfyt8KHEexOLYS8YiUW+9ACCS
         Y/bAkDVTi6z8UxV2X8h+0gDrVrGVS720OnqUcfOgZXJVlwuTtrHMRNc747+xozssXqFK
         9bpa/Np1KZHv3UMdawLE5UWXoygg0eAIB2SrW780gW/mmbX/QAgvESj7QxvDfWYLj6yG
         Our6fV1dGDu5I1lWD/YnbDSyV5gJ8ZKQsfuRB29qf7FaoR3H4yu1+d9mcMkO32Nss4Nf
         TLS/oP/E7V2XmvOtLXuKvybx7fP4I/0zsf2q6F/4yHX2Wbrk21X8mQ5c/ofZyNfTS5mT
         72zA==
X-Gm-Message-State: AOAM533WhxAq1RoVlykYUVaHuXPJv8aP1SXvvlTWFC3AiXCn57pPucXp
        R6+Eqgzs5pN+eoztOEpM0c0mfg==
X-Google-Smtp-Source: ABdhPJzBycgpZcYOptdphpOa+oK7Exg/FmKFaFLPvwEdqgE4NbS3n828exkD5oDBlZj5zoH0aRZYiQ==
X-Received: by 2002:aca:3303:: with SMTP id z3mr386oiz.140.1618353199219;
        Tue, 13 Apr 2021 15:33:19 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id e2sm931116otk.70.2021.04.13.15.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 15:33:18 -0700 (PDT)
Date:   Tue, 13 Apr 2021 17:33:16 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] crypto: qce: common: Add support for AEAD algorithms
Message-ID: <20210413223316.GT1538589@yoga>
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210225182716.1402449-7-thara.gopinath@linaro.org>
 <20210405221848.GA904837@yoga>
 <64543792-7237-8622-9619-7020ed0b3fa1@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64543792-7237-8622-9619-7020ed0b3fa1@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue 13 Apr 17:27 CDT 2021, Thara Gopinath wrote:

> 
> 
> On 4/5/21 6:18 PM, Bjorn Andersson wrote:
> > On Thu 25 Feb 12:27 CST 2021, Thara Gopinath wrote:
> > 
> > > Add register programming sequence for enabling AEAD
> > > algorithms on the Qualcomm crypto engine.
> > > 
> > > Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> > > ---
> > >   drivers/crypto/qce/common.c | 155 +++++++++++++++++++++++++++++++++++-
> > >   1 file changed, 153 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
> > > index 05a71c5ecf61..54d209cb0525 100644
> > > --- a/drivers/crypto/qce/common.c
> > > +++ b/drivers/crypto/qce/common.c
> > > @@ -15,6 +15,16 @@
> > >   #include "core.h"
> > >   #include "regs-v5.h"
> > >   #include "sha.h"
> > > +#include "aead.h"
> > > +
> > > +static const u32 std_iv_sha1[SHA256_DIGEST_SIZE / sizeof(u32)] = {
> > > +	SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4, 0, 0, 0
> > > +};
> > > +
> > > +static const u32 std_iv_sha256[SHA256_DIGEST_SIZE / sizeof(u32)] = {
> > > +	SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
> > > +	SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7
> > > +};
> > >   static inline u32 qce_read(struct qce_device *qce, u32 offset)
> > >   {
> > > @@ -96,7 +106,7 @@ static inline void qce_crypto_go(struct qce_device *qce, bool result_dump)
> > >   		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT));
> > >   }
> > > -#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
> > > +#if defined(CONFIG_CRYPTO_DEV_QCE_SHA) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
> > >   static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
> > >   {
> > >   	u32 cfg = 0;
> > > @@ -139,7 +149,9 @@ static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
> > >   	return cfg;
> > >   }
> > > +#endif
> > > +#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
> > >   static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
> > >   {
> > >   	struct ahash_request *req = ahash_request_cast(async_req);
> > > @@ -225,7 +237,7 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
> > >   }
> > >   #endif
> > > -#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
> > > +#if defined(CONFIG_CRYPTO_DEV_QCE_SKCIPHER) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
> > >   static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
> > >   {
> > >   	u32 cfg = 0;
> > > @@ -271,7 +283,9 @@ static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
> > >   	return cfg;
> > >   }
> > > +#endif
> > > +#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
> > >   static void qce_xts_swapiv(__be32 *dst, const u8 *src, unsigned int ivsize)
> > >   {
> > >   	u8 swap[QCE_AES_IV_LENGTH];
> > > @@ -386,6 +400,139 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
> > >   }
> > >   #endif
> > > +#ifdef CONFIG_CRYPTO_DEV_QCE_AEAD
> > > +static int qce_setup_regs_aead(struct crypto_async_request *async_req)
> > > +{
> > > +	struct aead_request *req = aead_request_cast(async_req);
> > > +	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
> > > +	struct qce_aead_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
> > > +	struct qce_alg_template *tmpl = to_aead_tmpl(crypto_aead_reqtfm(req));
> > > +	struct qce_device *qce = tmpl->qce;
> > > +	__be32 enckey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(__be32)] = {0};
> > > +	__be32 enciv[QCE_MAX_IV_SIZE / sizeof(__be32)] = {0};
> > > +	__be32 authkey[QCE_SHA_HMAC_KEY_SIZE / sizeof(__be32)] = {0};
> > > +	__be32 authiv[SHA256_DIGEST_SIZE / sizeof(__be32)] = {0};
> > > +	__be32 authnonce[QCE_MAX_NONCE / sizeof(__be32)] = {0};
> > > +	unsigned int enc_keylen = ctx->enc_keylen;
> > > +	unsigned int auth_keylen = ctx->auth_keylen;
> > > +	unsigned int enc_ivsize = rctx->ivsize;
> > > +	unsigned int auth_ivsize;
> > > +	unsigned int enckey_words, enciv_words;
> > > +	unsigned int authkey_words, authiv_words, authnonce_words;
> > > +	unsigned long flags = rctx->flags;
> > > +	u32 encr_cfg = 0, auth_cfg = 0, config, totallen;
> > 
> > I don't see any reason to initialize encr_cfg or auth_cfg.
> > 
> > > +	u32 *iv_last_word;
> > > +
> > > +	qce_setup_config(qce);
> > > +
> > > +	/* Write encryption key */
> > > +	qce_cpu_to_be32p_array(enckey, ctx->enc_key, enc_keylen);
> > > +	enckey_words = enc_keylen / sizeof(u32);
> > > +	qce_write_array(qce, REG_ENCR_KEY0, (u32 *)enckey, enckey_words);
> > 
> > Afaict all "array registers" in this function are affected by the
> > CRYPTO_SETUP little endian bit, but you set this bit before launching
> > the operation dependent on IS_CCM(). So is this really working for the
> > !IS_CCM() case?
> > 
> > > +
> > > +	/* Write encryption iv */
> > > +	qce_cpu_to_be32p_array(enciv, rctx->iv, enc_ivsize);
> > > +	enciv_words = enc_ivsize / sizeof(u32);
> > > +	qce_write_array(qce, REG_CNTR0_IV0, (u32 *)enciv, enciv_words);
> > 
> > It would be nice if this snippet was extracted to a helper function.
> 
> I kind of forgot to type this earlier. So yes I agree in principle.
> It is more elegant to have something like qce_convert_be32_and_write
> and in the function do the above three steps. This snippet is prevalent in
> this driver code across other alogs as well (skcipher and hash).

Perhaps make qce_cpu_to_be32p_array() (or qce_be32_to_cpu() per the
other reply), could return the number of words written - that way you
remove the ugly middle line at least - and can still poke at the data
when needed.

> Take it up as a separate clean up activity  ?
> 

Yes, that seems like a good idea.

Regards,
Bjorn
