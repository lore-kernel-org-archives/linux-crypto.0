Return-Path: <SRS0=6Tes=CG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914E4C433E6
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Aug 2020 06:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73A4220CC7
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Aug 2020 06:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgH1G5l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Aug 2020 02:57:41 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35254 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgH1G5l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Aug 2020 02:57:41 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kBYKP-0003Me-Uj; Fri, 28 Aug 2020 16:57:39 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Aug 2020 16:57:37 +1000
Date:   Fri, 28 Aug 2020 16:57:37 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, vulab@iscas.ac.cn
Subject: Re: [PATCH] Remove unneeded variable t1
Message-ID: <20200828065737.GA14575@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818080553.12064-1-vulab@iscas.ac.cn>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Xu Wang <vulab@iscas.ac.cn> wrote:
> Remove unneeded variable t1 seed_encrypt() and
> seed_decrypt().
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
> crypto/seed.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/seed.c b/crypto/seed.c
> index 5e3bef3a617d..69b3058d6a32 100644
> --- a/crypto/seed.c
> +++ b/crypto/seed.c
> @@ -366,7 +366,7 @@ static void seed_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>        const struct seed_ctx *ctx = crypto_tfm_ctx(tfm);
>        const __be32 *src = (const __be32 *)in;
>        __be32 *dst = (__be32 *)out;
> -       u32 x1, x2, x3, x4, t0, t1;
> +       u32 x1, x2, x3, x4, t0;
>        const u32 *ks = ctx->keysched;
> 
>        x1 = be32_to_cpu(src[0]);
> @@ -404,7 +404,7 @@ static void seed_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>        const struct seed_ctx *ctx = crypto_tfm_ctx(tfm);
>        const __be32 *src = (const __be32 *)in;
>        __be32 *dst = (__be32 *)out;
> -       u32 x1, x2, x3, x4, t0, t1;
> +       u32 x1, x2, x3, x4, t0;
>        const u32 *ks = ctx->keysched;
> 
>        x1 = be32_to_cpu(src[0]);

This doesn't even compile!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
