Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D9BC433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 23:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50F55613B1
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 23:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhDMXJ4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbhDMXJz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 19:09:55 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995C6C061574
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 16:09:33 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id w31-20020a9d36220000b02901f2cbfc9743so17666931otb.7
        for <linux-crypto@vger.kernel.org>; Tue, 13 Apr 2021 16:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/OMKvu8Afd8CFUvBeQQ1uu6JC7ucK9TbUL/N0cVMHqA=;
        b=hwF/GvGwEvHZQOPjlpThuI/MAxTWxw9r4jGHvzaxUvQ2TkPzxdkdwr6U24zZyFL829
         spiYrOnZj1s/tDUqjyUnuRMw7bWZeRRyjJzH80bnWOD3wZVNJusOAz5LYVkbJGKt6utO
         O+iVwQp1vCZkUznKEzYMWcTwJceq4TWbnkiTQpLbWM5NW8QljBm1tTYcfZc9TeYSxzhI
         HAcYfUgg/bKpqwyf3yC8Au3GYTb4WDnyMsmN2je5qKkytwLVO2vXnmM2foVhtanfG1W+
         EnbURvSYzrI3bmXW0QbByG1OqyvWQ3aXHYo0+smoYOMd7u/F4zsbWBlAeRrewZzluhGk
         x4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/OMKvu8Afd8CFUvBeQQ1uu6JC7ucK9TbUL/N0cVMHqA=;
        b=H14+gCfusJCcbUy/TKwjmJjgWUXzVQjr/CqQJpjszDDDZA09oONgei0UGEhqfT9cMj
         eQN+R/iWpIXm21s1COATziG2l7SSHiVOctEG8UyFukKJlA17EI3X5iwg5JJimMYwoyXl
         0yTypUt8CCXF149w0Ya/JPy5wgvooXfc0J8nuZVa6b/5ttULTNy61wSOdNyN2FdsgvwE
         nQL/rjmr0und3X0qFH5dZJMnoewiD09Gi0s273+MFKTas7f8LjvmJy+EyCh4iosw3d6c
         gb2gBENrZAQfgcQVqdu41gjlJAYBQ27+EoYzUCaSRJtaFgBJSJsGGXE/mAYwsl9HFAfC
         Iu7g==
X-Gm-Message-State: AOAM5312UcaNtT+PPhi4u997RUTfBvG5Q6krTpzKGPaaJRSR8fdRh3oE
        uRs40WLZRfjlZcQ6YuKDCKRiKQ==
X-Google-Smtp-Source: ABdhPJx0Lfs7rvP8tiEAxDE4tbtUIC95M4xBLYQYHuC9ePxU0XTxsGeaOqac89UnodX89Th6aKWmFw==
X-Received: by 2002:a05:6830:120b:: with SMTP id r11mr28809253otp.82.1618355372847;
        Tue, 13 Apr 2021 16:09:32 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id w14sm3755850ots.39.2021.04.13.16.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 16:09:32 -0700 (PDT)
Date:   Tue, 13 Apr 2021 18:09:30 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] crypto: qce: common: Add support for AEAD algorithms
Message-ID: <20210413230930.GU1538589@yoga>
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210225182716.1402449-7-thara.gopinath@linaro.org>
 <20210405221848.GA904837@yoga>
 <cab25283-1ad6-2107-8a5e-230a3a7358b5@linaro.org>
 <20210413222014.GS1538589@yoga>
 <4c4a9df6-7ad5-85ab-bfcd-2c123bd86ca0@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c4a9df6-7ad5-85ab-bfcd-2c123bd86ca0@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue 13 Apr 17:44 CDT 2021, Thara Gopinath wrote:

> 
> 
> On 4/13/21 6:20 PM, Bjorn Andersson wrote:
> > On Tue 13 Apr 16:31 CDT 2021, Thara Gopinath wrote:
> > 
> > > 
> > > Hi Bjorn,
> > > 
> > > On 4/5/21 6:18 PM, Bjorn Andersson wrote:
> > > > On Thu 25 Feb 12:27 CST 2021, Thara Gopinath wrote:
> > > > 
> > > > > Add register programming sequence for enabling AEAD
> > > > > algorithms on the Qualcomm crypto engine.
> > > > > 
> > > > > Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> > > > > ---
> > > > >    drivers/crypto/qce/common.c | 155 +++++++++++++++++++++++++++++++++++-
> > > > >    1 file changed, 153 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
> > > > > index 05a71c5ecf61..54d209cb0525 100644
> > > > > --- a/drivers/crypto/qce/common.c
> > > > > +++ b/drivers/crypto/qce/common.c
> > > > > @@ -15,6 +15,16 @@
> > > > >    #include "core.h"
> > > > >    #include "regs-v5.h"
> > > > >    #include "sha.h"
> > > > > +#include "aead.h"
> > > > > +
> > > > > +static const u32 std_iv_sha1[SHA256_DIGEST_SIZE / sizeof(u32)] = {
> > > > > +	SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4, 0, 0, 0
> > > > > +};
> > > > > +
> > > > > +static const u32 std_iv_sha256[SHA256_DIGEST_SIZE / sizeof(u32)] = {
> > > > > +	SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
> > > > > +	SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7
> > > > > +};
> > > > >    static inline u32 qce_read(struct qce_device *qce, u32 offset)
> > > > >    {
> > > > > @@ -96,7 +106,7 @@ static inline void qce_crypto_go(struct qce_device *qce, bool result_dump)
> > > > >    		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT));
> > > > >    }
> > > > > -#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
> > > > > +#if defined(CONFIG_CRYPTO_DEV_QCE_SHA) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
> > > > >    static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
> > > > >    {
> > > > >    	u32 cfg = 0;
> > > > > @@ -139,7 +149,9 @@ static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
> > > > >    	return cfg;
> > > > >    }
> > > > > +#endif
> > > > > +#ifdef CONFIG_CRYPTO_DEV_QCE_SHA
> > > > >    static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
> > > > >    {
> > > > >    	struct ahash_request *req = ahash_request_cast(async_req);
> > > > > @@ -225,7 +237,7 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
> > > > >    }
> > > > >    #endif
> > > > > -#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
> > > > > +#if defined(CONFIG_CRYPTO_DEV_QCE_SKCIPHER) || defined(CONFIG_CRYPTO_DEV_QCE_AEAD)
> > > > >    static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
> > > > >    {
> > > > >    	u32 cfg = 0;
> > > > > @@ -271,7 +283,9 @@ static u32 qce_encr_cfg(unsigned long flags, u32 aes_key_size)
> > > > >    	return cfg;
> > > > >    }
> > > > > +#endif
> > > > > +#ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
> > > > >    static void qce_xts_swapiv(__be32 *dst, const u8 *src, unsigned int ivsize)
> > > > >    {
> > > > >    	u8 swap[QCE_AES_IV_LENGTH];
> > > > > @@ -386,6 +400,139 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
> > > > >    }
> > > > >    #endif
> > > > > +#ifdef CONFIG_CRYPTO_DEV_QCE_AEAD
> > > > > +static int qce_setup_regs_aead(struct crypto_async_request *async_req)
> > > > > +{
> > > > > +	struct aead_request *req = aead_request_cast(async_req);
> > > > > +	struct qce_aead_reqctx *rctx = aead_request_ctx(req);
> > > > > +	struct qce_aead_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
> > > > > +	struct qce_alg_template *tmpl = to_aead_tmpl(crypto_aead_reqtfm(req));
> > > > > +	struct qce_device *qce = tmpl->qce;
> > > > > +	__be32 enckey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(__be32)] = {0};
> > > > > +	__be32 enciv[QCE_MAX_IV_SIZE / sizeof(__be32)] = {0};
> > > > > +	__be32 authkey[QCE_SHA_HMAC_KEY_SIZE / sizeof(__be32)] = {0};
> > > > > +	__be32 authiv[SHA256_DIGEST_SIZE / sizeof(__be32)] = {0};
> > > > > +	__be32 authnonce[QCE_MAX_NONCE / sizeof(__be32)] = {0};
> > > > > +	unsigned int enc_keylen = ctx->enc_keylen;
> > > > > +	unsigned int auth_keylen = ctx->auth_keylen;
> > > > > +	unsigned int enc_ivsize = rctx->ivsize;
> > > > > +	unsigned int auth_ivsize;
> > > > > +	unsigned int enckey_words, enciv_words;
> > > > > +	unsigned int authkey_words, authiv_words, authnonce_words;
> > > > > +	unsigned long flags = rctx->flags;
> > > > > +	u32 encr_cfg = 0, auth_cfg = 0, config, totallen;
> > > > 
> > > > I don't see any reason to initialize encr_cfg or auth_cfg.
> > > 
> > > right.. I will remove it
> > > 
> > > > 
> > > > > +	u32 *iv_last_word;
> > > > > +
> > > > > +	qce_setup_config(qce);
> > > > > +
> > > > > +	/* Write encryption key */
> > > > > +	qce_cpu_to_be32p_array(enckey, ctx->enc_key, enc_keylen);
> > > > > +	enckey_words = enc_keylen / sizeof(u32);
> > > > > +	qce_write_array(qce, REG_ENCR_KEY0, (u32 *)enckey, enckey_words);
> > > > 
> > > > Afaict all "array registers" in this function are affected by the
> > > > CRYPTO_SETUP little endian bit, but you set this bit before launching
> > > > the operation dependent on IS_CCM(). So is this really working for the
> > > > !IS_CCM() case?
> > > 
> > > I am not sure I understand you. Below ,
> > > 	/* get little endianness */
> > > 	config = qce_config_reg(qce, 1);
> > > 	qce_write(qce, REG_CONFIG, config);
> > > 
> > > is outside of any checks..
> > > 
> > 
> > You're right, I misread that snippet as I was jumping through the
> > function. So we're unconditionally running the hardware in little endian
> > mode.
> > 
> > > > 
> > > > > +
> > > > > +	/* Write encryption iv */
> > > > > +	qce_cpu_to_be32p_array(enciv, rctx->iv, enc_ivsize);
> > > > > +	enciv_words = enc_ivsize / sizeof(u32);
> > > > > +	qce_write_array(qce, REG_CNTR0_IV0, (u32 *)enciv, enciv_words);
> > > > 
> > > > It would be nice if this snippet was extracted to a helper function.
> > > > 
> > > > > +
> > > > > +	if (IS_CCM(rctx->flags)) {
> > > > > +		iv_last_word = (u32 *)&enciv[enciv_words - 1];
> > > > > +//		qce_write(qce, REG_CNTR3_IV3, enciv[enciv_words - 1] + 1);
> > > > 
> > > > I believe this is a remnant of the two surrounding lines.
> > > 
> > > It indeed is.. I will remove it.
> > > 
> > > > 
> > > > > +		qce_write(qce, REG_CNTR3_IV3, (*iv_last_word) + 1);
> > > > 
> > > > enciv is an array of big endian 32-bit integers, which you tell the
> > > > compiler to treat as cpu-native endian, and then you do math on it.
> > > > Afaict from the documentation the value of REG_CNTR3_IVn should be set
> > > > to rctx->iv + 1, but if the hardware expects these in big endian then I
> > > > think you added 16777216.
> > > 
> > > So, the crypto engine documentation talks of writing to these registers in
> > > little endian mode. The byte stream that you get for iv from the user
> > > is in big endian mode as in the MSB is byte 0. So we kind of invert this and
> > > write  to these registers. This is what happens with declaring the __be32
> > > array and copying words to it from the byte stream. So now byte 0 is the LSB
> > > and a +1 will just add a 1 to it.
> > > 
> > 
> > But if the data come in big endian and after qce_cpu_to_be32p_array()
> > you're able to do math on them with expected result and you're finally
> > passing the data to writel() then I think that qce_cpu_to_be32p_array()
> > is actually be32_to_cpu() and after the conversion you should carry the
> > results in CPU-native u32 arrays - and thereby skip the typecasting.
> 
> you mean I can replace __be32 arrays with u32 arrays ?? yes I probably can.
> I will try this out and if it works do the change.
> 

Yes, given that you just typecast things as you do it should just work
to move the typecast to the qce_cpu_to_be32p_array().

But as I said, this would indicate that what is cpu_to_be32() should
have been be32_to_cpu() (both performs the same swap, it's just a matter
of what type goes in and what type goes out).

Looking at the other uses of qce_cpu_to_be32p_array() I suspect that
it's the same situation there, so perhaps introduce a new function
qce_be32_to_cpu() in this patchset (that returns number of words
converted) and then look into the existing users after that?

[..]
> > > > > +	if (IS_SHA_HMAC(rctx->flags)) {
> > > > > +		/* Write default authentication iv */
> > > > > +		if (IS_SHA1_HMAC(rctx->flags)) {
> > > > > +			auth_ivsize = SHA1_DIGEST_SIZE;
> > > > > +			memcpy(authiv, std_iv_sha1, auth_ivsize);
> > > > > +		} else if (IS_SHA256_HMAC(rctx->flags)) {
> > > > > +			auth_ivsize = SHA256_DIGEST_SIZE;
> > > > > +			memcpy(authiv, std_iv_sha256, auth_ivsize);
> > > > > +		}
> > > > > +		authiv_words = auth_ivsize / sizeof(u32);
> > > > > +		qce_write_array(qce, REG_AUTH_IV0, (u32 *)authiv, authiv_words);
> > > > 
> > > > AUTH_IV0 is affected by the little endian configuration, does this imply
> > > > that IS_SHA_HMAC() and IS_CCM() are exclusive bits of rctx->flags? If so
> > > > I think it would be nice if you grouped the conditionals in a way that
> > > > made that obvious when reading the function.
> > > 
> > > So yes IS_SHA_HMAC() and IS_CCM() are exclusive bits of rctx->flags.
> > > AUTH_IVn is 0 for ccm and has initial value for HMAC algorithms. I don't
> > > understand the confusion here.
> > > 
> > 
> > I'm just saying that writing is as below would have made it obvious to
> > me that IS_SHA_HMAC() and IS_CCM() are exclusive:
> 
> So regardless of the mode, it is a good idea  to clear the IV  registers
> which happens above in
> 
> 	qce_clear_array(qce, REG_AUTH_IV0, 16);
> 
> 
> This is important becasue the size of IV varies between HMAC(SHA1) and
> HMAC(SHA256) and we don't want any previous bits sticking around.
> For CCM after the above step we don't do anything with AUTH_IV where as for
> SHA_HMAC we have to go and program the registers. I can split it into
> if (IS_SHA_HMAC(flags)) {
> 	...
> } else {
> 	...
> }
> 
> but both snippets will have the above line code clearing the IV register and
> the if part will have more stuff actually programming these registers.. Is
> that what you are looking for ?

I didn't find an answer quickly to the question if the two where
mutually exclusive and couldn't determine from the code flow either. But
my comment seems to stem from my misunderstanding that the little endian
bit was dependent on IS_CCM().

That said, if the logic really is "do this for IS_SHA_HMAC(), otherwise
do that", then if else makes sense.

Regards,
Bjorn
