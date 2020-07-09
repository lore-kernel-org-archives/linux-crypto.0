Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D545EC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 05:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE972206A5
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 05:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgGIFbc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 01:31:32 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34824 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbgGIFbc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 01:31:32 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jtP9a-0004eC-Hl; Thu, 09 Jul 2020 15:31:27 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Jul 2020 15:31:26 +1000
Date:   Thu, 9 Jul 2020 15:31:26 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     mpatocka@redhat.com, linux-crypto@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH 2/6] crypto: algapi - use common mechanism for inheriting
 flags
Message-ID: <20200709053126.GA5510@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701045217.121126-3-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
>
> @@ -875,14 +873,21 @@ static void cbcmac_exit_tfm(struct crypto_tfm *tfm)
> 
> static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
> {
> +       struct crypto_attr_type *algt;
>        struct shash_instance *inst;
>        struct crypto_cipher_spawn *spawn;
>        struct crypto_alg *alg;
> +       u32 mask;
>        int err;
> 
> -       err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
> -       if (err)
> -               return err;
> +       algt = crypto_get_attr_type(tb);
> +       if (IS_ERR(algt))
> +               return PTR_ERR(algt);
> +
> +       if ((algt->type ^ CRYPTO_ALG_TYPE_SHASH) & algt->mask)
> +               return -EINVAL;
> +
> +       mask = crypto_algt_inherited_mask(algt);

How about moving the types check into crypto_algt_inherited_mask,
e.g.,

	u32 mask;
	int err;

	err = crypto_algt_inherited_mask(tb, CRYPTO_ALG_TYPE_SHASH);
	if (err < 0)
		return err;

	mask = err;

This could then be used to simplify other templates too, such as
gcm.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
