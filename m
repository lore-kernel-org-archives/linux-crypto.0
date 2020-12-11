Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A627FC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 10:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FFFA23F2B
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 10:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgLKKnn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Dec 2020 05:43:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390233AbgLKKnA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Dec 2020 05:43:00 -0500
X-Gm-Message-State: AOAM530MCtu4PcfNQP21mxYujqHnCY/WzzcuFgTxJtJx4K+aRy3PY6UZ
        HU7J42V5XPPDjPJsl5YyTYUE8IPx7iysm2P20sw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607683340;
        bh=2t9pEWVw7pzE9pIhgFfJ7Q4L3pamisj5RJVp5inOjD0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KtEmvc1q3PU+vPnml1LfDUExrnFo0OtoTi9yY0ywuHZQxcOtRtwa69VkzZpD+9WN5
         ReGTYwQ3cHVd+qaFVEZzDbohc7hjG2HlkmAhUjeCLKErH713XpLOpb272FeElDh180
         t8IA0468Ru+aEZV9P7qwPFHykMQI6c8zLvJTVJL/eSzjkx65ugt/nhHiEZhTVeLDrU
         wDBcovwAypLLoPsKVdsKu2Jq6nBwvYhpwAuwQem02uAFzNkhcR4sJJ4JNroLtg1517
         odGZEZKyoLvgls+mHdvLIkX9R+qnQZBbRy7OoG1C9UNluLvYXyruikNFYxoygOMXbN
         XTDjP1OvCjjTw==
X-Google-Smtp-Source: ABdhPJyfd6eKgcHqzZt6pnf4Suw6m4b9QMsmlwNqxVUISzDTYO99vPMOOrMF7pspm0xQE4dk8/MnHDTKXEENliaZvw8=
X-Received: by 2002:aca:b809:: with SMTP id i9mr8674838oif.174.1607683339167;
 Fri, 11 Dec 2020 02:42:19 -0800 (PST)
MIME-Version: 1.0
References: <20201201142451.138221-1-giovanni.cabiddu@intel.com>
 <20201201142451.138221-3-giovanni.cabiddu@intel.com> <20201211100748.GA994@gondor.apana.org.au>
In-Reply-To: <20201211100748.GA994@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 11 Dec 2020 11:42:08 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGr-aJ_uqoq+ooqp6iFSfGraQMHaGi8idd+qc_UXvp7FA@mail.gmail.com>
Message-ID: <CAMj1kXGr-aJ_uqoq+ooqp6iFSfGraQMHaGi8idd+qc_UXvp7FA@mail.gmail.com>
Subject: Re: [PATCH 2/3] crypto: qat - add AES-XTS support for QAT GEN4 devices
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        qat-linux <qat-linux@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Tomaszx Kowalik <tomaszx.kowalik@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 11 Dec 2020 at 11:07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Dec 01, 2020 at 02:24:50PM +0000, Giovanni Cabiddu wrote:
> >
> > @@ -1293,6 +1366,12 @@ static int qat_alg_skcipher_init_xts_tfm(struct crypto_skcipher *tfm)
> >       if (IS_ERR(ctx->ftfm))
> >               return PTR_ERR(ctx->ftfm);
> >
> > +     ctx->tweak = crypto_alloc_cipher("aes", 0, 0);
> > +     if (IS_ERR(ctx->tweak)) {
> > +             crypto_free_skcipher(ctx->ftfm);
> > +             return PTR_ERR(ctx->tweak);
> > +     }
> > +
> >       reqsize = max(sizeof(struct qat_crypto_request),
> >                     sizeof(struct skcipher_request) +
> >                     crypto_skcipher_reqsize(ctx->ftfm));
>
> This may clash with the work that Ard is doing on simpler ciphers.
>
> So I think this should switch over to using the library interface
> for aes.  What do you think Ard?
>

I think this is a valid use of a bare cipher - it lives as long as the
TFM itself, and may be used on a hot path.

I need to respin the bare cipher change I sent the other day anyway,
so I'll make sure this driver gets the right treatment as well (which
shouldn't cause any conflicts so the changes can be merged in any
order)
