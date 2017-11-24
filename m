From: LABBE Corentin <clabbe@baylibre.com>
Subject: Re: [PATCH] crypto: arm64/aes - do not call
 crypto_unregister_skcipher twice on error
Date: Fri, 24 Nov 2017 06:52:33 +0100
Message-ID: <20171124055233.GA16381@Red>
References: <1511338114-39583-1-git-send-email-clabbe@baylibre.com>
 <CAKv+Gu9m3v_iMdg8ngX-3x1HT+c8D52dhjJ=MiTp11VByD=ewA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35965 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdKXFwh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Nov 2017 00:52:37 -0500
Received: by mail-wm0-f66.google.com with SMTP id r68so20360084wmr.1
        for <linux-crypto@vger.kernel.org>; Thu, 23 Nov 2017 21:52:36 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9m3v_iMdg8ngX-3x1HT+c8D52dhjJ=MiTp11VByD=ewA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 22, 2017 at 08:55:14AM +0000, Ard Biesheuvel wrote:
> Hello Corentin,
> 
> On 22 November 2017 at 08:08, Corentin Labbe <clabbe@baylibre.com> wrote:
> > When a cipher fail
> 
> fails
> 
> > to register in aes_init(), the error path go thought
> 
> goes through
> 
> > aes_exit() then crypto_unregister_skciphers().
> > Since aes_exit calls also crypto_unregister_skcipher, this trigger a
> 
> triggers
> 
> > refcount_t: underflow; use-after-free.
> >
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  arch/arm64/crypto/aes-glue.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
> > index 998ba519a026..9e42ec96243e 100644
> > --- a/arch/arm64/crypto/aes-glue.c
> > +++ b/arch/arm64/crypto/aes-glue.c
> > @@ -664,7 +664,10 @@ static int __init aes_init(void)
> >         return 0;
> >
> >  unregister_simds:
> > -       aes_exit();
> > +       for (i = 0; i < ARRAY_SIZE(aes_simd_algs); i++)
> > +               if (aes_simd_algs[i])
> > +                       simd_skcipher_free(aes_simd_algs[i]);
> > +       crypto_unregister_shashes(mac_algs, ARRAY_SIZE(mac_algs));
> >  unregister_ciphers:
> >         crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
> >         return err;
> > --
> > 2.13.6
> >
> >
> 
> 
> Would this also fix it?
> 
> diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
> index 998ba519a026..2fa850e86aa8 100644
> --- a/arch/arm64/crypto/aes-glue.c
> +++ b/arch/arm64/crypto/aes-glue.c
> @@ -665,6 +665,7 @@ static int __init aes_init(void)
> 
>  unregister_simds:
>         aes_exit();
> +       return err;
>  unregister_ciphers:
>         crypto_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
>         return err;

Yes it is better.

I will send a v2 today.

Regards
