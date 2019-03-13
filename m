Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A3EC43381
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 10:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13F262171F
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 10:35:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p46volXp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbfCMKfs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 06:35:48 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:54622 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfCMKfs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 06:35:48 -0400
Received: by mail-it1-f195.google.com with SMTP id w18so2040589itj.4
        for <linux-crypto@vger.kernel.org>; Wed, 13 Mar 2019 03:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sQIQF5Y8mCINIb4xih/YwsdwB5n5L/6dfUG9VoyAHNI=;
        b=p46volXptWdRGLpMptPP9rC0T5aT2erdQhlh2TL35aiwuoVfaO3/vNCprDEgW7r2sy
         J0PtHoPo/mBhPw6DrWbtvJ/Ws61xXb0Q6rc01JJBq33oT9a5qKU74CZi7GtPz+7TD5I0
         n/e34zClhmqCB+5PQ0gpQqqIRorDW7UjuKQ02nfU/VBquNn3qMyYHthbn8wiFthqwKCW
         AqOzGScgWNI/73mMXv61eNFnw+eEP1mO5awxFHUODMvvPAWbjwwa85ZqynvcpZyhLwHD
         7COFDg6XKVAcsG/yQN/0i6dtmg5+YTfEvLC5DZ8khKaMf48iwcR2xWZNyIFDjmSk60hn
         j7gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sQIQF5Y8mCINIb4xih/YwsdwB5n5L/6dfUG9VoyAHNI=;
        b=JW83wz6+0cpoq84zqXgs52+qVcCD+JLU2BGZCAwvxCduPTMgZqVZOZjTwC7JBDrlaI
         FNvuBJUN3z3LAILcJGDxFEzBtRGCSDkA1RrLmQ+HxQoaSYPIb/iemrvwy1MlIUCCrV+l
         Kd2TfRRuPMzUQZBO4aIFco/n71xLDJYTKuUXHiWDdeEBjjBx5UHT3nmhMZrji9sNPSla
         RyIGbzBQvC6DGAQJiZNKCW4mMtmFZngjl80wqXLdKUh0Oq+F8L6fKqUQmuhIQODiuSWS
         fBqoUnjNGJotKRcO/ux6R/RHLEAdIQ5VVN/xFtn32zfvioAFoK4QRcCSwO7vLVEEE4OB
         jegg==
X-Gm-Message-State: APjAAAXAY21yAuOZ+umqFV5iraHA9+FtQyo3CMMUoq8qwyFMPsjPgfhr
        PKWExEAedc1CUJrzPcnlwBWF+dmF/2UNyPeuK7Vwyg==
X-Google-Smtp-Source: APXvYqzlJt+nGenyZcKkhQ0VRajSm2I82hKQs6n19YYcQX2GcqMR1qc9udfnyZ4FnZkdznqsJZoN1u6gTvmgKw9+zC4=
X-Received: by 2002:a24:32d0:: with SMTP id j199mr1349750ita.71.1552473346627;
 Wed, 13 Mar 2019 03:35:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190313051252.2917-1-ebiggers@kernel.org> <20190313051252.2917-9-ebiggers@kernel.org>
In-Reply-To: <20190313051252.2917-9-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 13 Mar 2019 11:35:35 +0100
Message-ID: <CAKv+Gu94tcpkXfVcPw8rr2NKFr8WMoOG+wT6ZrZhYsvW8QFdMA@mail.gmail.com>
Subject: Re: [PATCH 8/8] crypto: testmgr - test the !may_use_simd() fallback code
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 13 Mar 2019 at 06:15, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> All crypto API algorithms are supposed to support the case where they
> are called in a context where SIMD instructions are unusable, e.g. IRQ
> context on some architectures.  However, this isn't tested for by the
> self-tests, causing bugs to go undetected.
>
> Now that all algorithms have been converted to use crypto_simd_usable(),
> update the self-tests to test the no-SIMD case.  First, a bool
> testvec_config::nosimd is added.  When set, the crypto operation is
> executed with preemption disabled and with crypto_simd_usable() mocked
> out to return false on the current CPU.
>
> A bool test_sg_division::nosimd is also added.  For hash algorithms it's
> honored by the corresponding ->update().  By setting just a subset of
> these bools, the case where some ->update()s are done in SIMD context
> and some are done in no-SIMD context is also tested.
>
> These bools are then randomly set by generate_random_testvec_config().
>
> For now, all no-SIMD testing is limited to the extra crypto self-tests,
> because it might be a bit too invasive for the regular self-tests.
> But this could be changed later.
>
> This has already found bugs in the arm64 AES-GCM and ChaCha algorithms.
> This would have found some past bugs as well.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/testmgr.c | 116 +++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 92 insertions(+), 24 deletions(-)
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 52417dde811f..2c2ddebb48d3 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -234,12 +234,14 @@ enum finalization_type {
>   *                               @offset
>   * @flush_type: for hashes, whether an update() should be done now vs.
>   *             continuing to accumulate data
> + * @nosimd: if doing the pending update(), do it with SIMD disabled?
>   */
>  struct test_sg_division {
>         unsigned int proportion_of_total;
>         unsigned int offset;
>         bool offset_relative_to_alignmask;
>         enum flush_type flush_type;
> +       bool nosimd;
>  };
>
>  /**
> @@ -259,6 +261,7 @@ struct test_sg_division {
>   * @iv_offset_relative_to_alignmask: if true, add the algorithm's alignmask to
>   *                                  the @iv_offset
>   * @finalization_type: what finalization function to use for hashes
> + * @nosimd: execute with SIMD disabled?  Requires !CRYPTO_TFM_REQ_MAY_SLEEP.
>   */
>  struct testvec_config {
>         const char *name;
> @@ -269,6 +272,7 @@ struct testvec_config {
>         unsigned int iv_offset;
>         bool iv_offset_relative_to_alignmask;
>         enum finalization_type finalization_type;
> +       bool nosimd;
>  };
>
>  #define TESTVEC_CONFIG_NAMELEN 192
> @@ -420,8 +424,11 @@ static unsigned int count_test_sg_divisions(const struct test_sg_division *divs)
>         return ndivs;
>  }
>
> +#define SGDIVS_HAVE_FLUSHES    BIT(0)
> +#define SGDIVS_HAVE_NOSIMD     BIT(1)
> +
>  static bool valid_sg_divisions(const struct test_sg_division *divs,
> -                              unsigned int count, bool *any_flushes_ret)
> +                              unsigned int count, int *flags_ret)
>  {
>         unsigned int total = 0;
>         unsigned int i;
> @@ -432,7 +439,9 @@ static bool valid_sg_divisions(const struct test_sg_division *divs,
>                         return false;
>                 total += divs[i].proportion_of_total;
>                 if (divs[i].flush_type != FLUSH_TYPE_NONE)
> -                       *any_flushes_ret = true;
> +                       *flags_ret |= SGDIVS_HAVE_FLUSHES;
> +               if (divs[i].nosimd)
> +                       *flags_ret |= SGDIVS_HAVE_NOSIMD;
>         }
>         return total == TEST_SG_TOTAL &&
>                 memchr_inv(&divs[i], 0, (count - i) * sizeof(divs[0])) == NULL;
> @@ -445,19 +454,18 @@ static bool valid_sg_divisions(const struct test_sg_division *divs,
>   */
>  static bool valid_testvec_config(const struct testvec_config *cfg)
>  {
> -       bool any_flushes = false;
> +       int flags = 0;
>
>         if (cfg->name == NULL)
>                 return false;
>
>         if (!valid_sg_divisions(cfg->src_divs, ARRAY_SIZE(cfg->src_divs),
> -                               &any_flushes))
> +                               &flags))
>                 return false;
>
>         if (cfg->dst_divs[0].proportion_of_total) {
>                 if (!valid_sg_divisions(cfg->dst_divs,
> -                                       ARRAY_SIZE(cfg->dst_divs),
> -                                       &any_flushes))
> +                                       ARRAY_SIZE(cfg->dst_divs), &flags))
>                         return false;
>         } else {
>                 if (memchr_inv(cfg->dst_divs, 0, sizeof(cfg->dst_divs)))
> @@ -470,7 +478,12 @@ static bool valid_testvec_config(const struct testvec_config *cfg)
>             MAX_ALGAPI_ALIGNMASK + 1)
>                 return false;
>
> -       if (any_flushes && cfg->finalization_type == FINALIZATION_TYPE_DIGEST)
> +       if ((flags & (SGDIVS_HAVE_FLUSHES | SGDIVS_HAVE_NOSIMD)) &&
> +           cfg->finalization_type == FINALIZATION_TYPE_DIGEST)
> +               return false;
> +
> +       if ((cfg->nosimd || (flags & SGDIVS_HAVE_NOSIMD)) &&
> +           (cfg->req_flags & CRYPTO_TFM_REQ_MAY_SLEEP))
>                 return false;
>
>         return true;
> @@ -731,13 +744,14 @@ static int build_cipher_test_sglists(struct cipher_test_sglists *tsgls,
>  #ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
>  static char *generate_random_sgl_divisions(struct test_sg_division *divs,
>                                            size_t max_divs, char *p, char *end,
> -                                          bool gen_flushes)
> +                                          bool gen_flushes, u32 req_flags)
>  {
>         struct test_sg_division *div = divs;
>         unsigned int remaining = TEST_SG_TOTAL;
>
>         do {
>                 unsigned int this_len;
> +               const char *flushtype_str;
>
>                 if (div == &divs[max_divs - 1] || prandom_u32() % 2 == 0)
>                         this_len = remaining;
> @@ -766,11 +780,31 @@ static char *generate_random_sgl_divisions(struct test_sg_division *divs,
>                         }
>                 }
>
> +               if (div->flush_type != FLUSH_TYPE_NONE &&
> +                   !(req_flags & CRYPTO_TFM_REQ_MAY_SLEEP) &&
> +                   prandom_u32() % 2 == 0)
> +                       div->nosimd = true;
> +
> +               switch (div->flush_type) {
> +               case FLUSH_TYPE_FLUSH:
> +                       if (div->nosimd)
> +                               flushtype_str = "<flush,nosimd>";
> +                       else
> +                               flushtype_str = "<flush>";
> +                       break;
> +               case FLUSH_TYPE_REIMPORT:
> +                       if (div->nosimd)
> +                               flushtype_str = "<reimport,nosimd>";
> +                       else
> +                               flushtype_str = "<reimport>";
> +                       break;
> +               default:
> +                       flushtype_str = "";
> +                       break;
> +               }
> +
>                 BUILD_BUG_ON(TEST_SG_TOTAL != 10000); /* for "%u.%u%%" */
> -               p += scnprintf(p, end - p, "%s%u.%u%%@%s+%u%s",
> -                              div->flush_type == FLUSH_TYPE_NONE ? "" :
> -                              div->flush_type == FLUSH_TYPE_FLUSH ?
> -                              "<flush> " : "<reimport> ",
> +               p += scnprintf(p, end - p, "%s%u.%u%%@%s+%u%s", flushtype_str,
>                                this_len / 100, this_len % 100,
>                                div->offset_relative_to_alignmask ?
>                                         "alignmask" : "",
> @@ -820,18 +854,26 @@ static void generate_random_testvec_config(struct testvec_config *cfg,
>                 break;
>         }
>
> +       if (!(cfg->req_flags & CRYPTO_TFM_REQ_MAY_SLEEP) &&
> +           prandom_u32() % 2 == 0) {
> +               cfg->nosimd = true;
> +               p += scnprintf(p, end - p, " nosimd");
> +       }
> +
>         p += scnprintf(p, end - p, " src_divs=[");
>         p = generate_random_sgl_divisions(cfg->src_divs,
>                                           ARRAY_SIZE(cfg->src_divs), p, end,
>                                           (cfg->finalization_type !=
> -                                          FINALIZATION_TYPE_DIGEST));
> +                                          FINALIZATION_TYPE_DIGEST),
> +                                         cfg->req_flags);
>         p += scnprintf(p, end - p, "]");
>
>         if (!cfg->inplace && prandom_u32() % 2 == 0) {
>                 p += scnprintf(p, end - p, " dst_divs=[");
>                 p = generate_random_sgl_divisions(cfg->dst_divs,
>                                                   ARRAY_SIZE(cfg->dst_divs),
> -                                                 p, end, false);
> +                                                 p, end, false,
> +                                                 cfg->req_flags);
>                 p += scnprintf(p, end - p, "]");
>         }
>
> @@ -864,6 +906,23 @@ static void crypto_reenable_simd_for_test(void)
>  }
>  #endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
>
> +static int do_ahash_op(int (*op)(struct ahash_request *req),
> +                      struct ahash_request *req,
> +                      struct crypto_wait *wait, bool nosimd)
> +{
> +       int err;
> +
> +       if (nosimd)
> +               crypto_disable_simd_for_test();
> +
> +       err = op(req);
> +
> +       if (nosimd)
> +               crypto_reenable_simd_for_test();
> +
> +       return crypto_wait_req(err, wait);
> +}
> +
>  static int check_nonfinal_hash_op(const char *op, int err,
>                                   u8 *result, unsigned int digestsize,
>                                   const char *driver, unsigned int vec_num,
> @@ -938,7 +997,7 @@ static int test_hash_vec_cfg(const char *driver,
>                 ahash_request_set_callback(req, req_flags, crypto_req_done,
>                                            &wait);
>                 ahash_request_set_crypt(req, tsgl->sgl, result, vec->psize);
> -               err = crypto_wait_req(crypto_ahash_digest(req), &wait);
> +               err = do_ahash_op(crypto_ahash_digest, req, &wait, cfg->nosimd);
>                 if (err) {
>                         pr_err("alg: hash: %s digest() failed with err %d on test vector %u, cfg=\"%s\"\n",
>                                driver, err, vec_num, cfg->name);
> @@ -951,7 +1010,7 @@ static int test_hash_vec_cfg(const char *driver,
>
>         ahash_request_set_callback(req, req_flags, crypto_req_done, &wait);
>         ahash_request_set_crypt(req, NULL, result, 0);
> -       err = crypto_wait_req(crypto_ahash_init(req), &wait);
> +       err = do_ahash_op(crypto_ahash_init, req, &wait, cfg->nosimd);
>         err = check_nonfinal_hash_op("init", err, result, digestsize,
>                                      driver, vec_num, cfg);
>         if (err)
> @@ -967,7 +1026,8 @@ static int test_hash_vec_cfg(const char *driver,
>                                                    crypto_req_done, &wait);
>                         ahash_request_set_crypt(req, pending_sgl, result,
>                                                 pending_len);
> -                       err = crypto_wait_req(crypto_ahash_update(req), &wait);
> +                       err = do_ahash_op(crypto_ahash_update, req, &wait,
> +                                         divs[i]->nosimd);
>                         err = check_nonfinal_hash_op("update", err,
>                                                      result, digestsize,
>                                                      driver, vec_num, cfg);
> @@ -1010,12 +1070,12 @@ static int test_hash_vec_cfg(const char *driver,
>         ahash_request_set_crypt(req, pending_sgl, result, pending_len);
>         if (cfg->finalization_type == FINALIZATION_TYPE_FINAL) {
>                 /* finish with update() and final() */
> -               err = crypto_wait_req(crypto_ahash_update(req), &wait);
> +               err = do_ahash_op(crypto_ahash_update, req, &wait, cfg->nosimd);
>                 err = check_nonfinal_hash_op("update", err, result, digestsize,
>                                              driver, vec_num, cfg);
>                 if (err)
>                         return err;
> -               err = crypto_wait_req(crypto_ahash_final(req), &wait);
> +               err = do_ahash_op(crypto_ahash_final, req, &wait, cfg->nosimd);
>                 if (err) {
>                         pr_err("alg: hash: %s final() failed with err %d on test vector %u, cfg=\"%s\"\n",
>                                driver, err, vec_num, cfg->name);
> @@ -1023,7 +1083,7 @@ static int test_hash_vec_cfg(const char *driver,
>                 }
>         } else {
>                 /* finish with finup() */
> -               err = crypto_wait_req(crypto_ahash_finup(req), &wait);
> +               err = do_ahash_op(crypto_ahash_finup, req, &wait, cfg->nosimd);
>                 if (err) {
>                         pr_err("alg: hash: %s finup() failed with err %d on test vector %u, cfg=\"%s\"\n",
>                                driver, err, vec_num, cfg->name);
> @@ -1259,8 +1319,12 @@ static int test_aead_vec_cfg(const char *driver, int enc,
>         aead_request_set_crypt(req, tsgls->src.sgl_ptr, tsgls->dst.sgl_ptr,
>                                enc ? vec->plen : vec->clen, iv);
>         aead_request_set_ad(req, vec->alen);
> -       err = crypto_wait_req(enc ? crypto_aead_encrypt(req) :
> -                             crypto_aead_decrypt(req), &wait);
> +       if (cfg->nosimd)
> +               crypto_disable_simd_for_test();
> +       err = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
> +       if (cfg->nosimd)
> +               crypto_reenable_simd_for_test();
> +       err = crypto_wait_req(err, &wait);
>         if (err) {
>                 if (err == -EBADMSG && vec->novrfy)
>                         return 0;
> @@ -1594,8 +1658,12 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
>         skcipher_request_set_callback(req, req_flags, crypto_req_done, &wait);
>         skcipher_request_set_crypt(req, tsgls->src.sgl_ptr, tsgls->dst.sgl_ptr,
>                                    vec->len, iv);
> -       err = crypto_wait_req(enc ? crypto_skcipher_encrypt(req) :
> -                             crypto_skcipher_decrypt(req), &wait);
> +       if (cfg->nosimd)
> +               crypto_disable_simd_for_test();
> +       err = enc ? crypto_skcipher_encrypt(req) : crypto_skcipher_decrypt(req);
> +       if (cfg->nosimd)
> +               crypto_reenable_simd_for_test();
> +       err = crypto_wait_req(err, &wait);
>         if (err) {
>                 pr_err("alg: skcipher: %s %s failed with err %d on test vector %u, cfg=\"%s\"\n",
>                        driver, op, err, vec_num, cfg->name);
> --
> 2.21.0
>
