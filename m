From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: linux-next: Tree for May 15 (crypto /crct10dif)
Date: Thu, 16 May 2013 09:09:54 -0700
Message-ID: <1368720594.27102.273.camel@schen9-DESK>
References: <20130515132627.817585a3d9fb3a3e502eb586@canb.auug.org.au>
	 <5193CCEC.7070909@infradead.org>
	 <alpine.DEB.2.02.1305161152530.31865@M2420>
	 <CAMuHMdUmD2DMNeezetHNbe9DgQXpTN4BEfEmJSztyzCivQpyXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Xiong Zhou <jencce.kernel@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44169 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab3EPQJy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 May 2013 12:09:54 -0400
In-Reply-To: <CAMuHMdUmD2DMNeezetHNbe9DgQXpTN4BEfEmJSztyzCivQpyXQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2013-05-16 at 09:22 +0200, Geert Uytterhoeven wrote:
> On Thu, May 16, 2013 at 5:57 AM, Xiong Zhou <jencce.kernel@gmail.com> wrote:
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -378,6 +378,7 @@ config CRYPTO_CRC32_PCLMUL
> >
> >  config CRYPTO_CRCT10DIF
> >         tristate "CRCT10DIF algorithm"
> > +       depends on CRC_T10DIF
> 
> This is a library symbol, so "select CRC_T10DIF"?
> 

I think "depends on" CRC_T10DIF is okay.  This generic transform is not
needed if we are not using the T10-DIF library.  It is meant for
wrapping the library call to t10-dif as a crypto transform.

> >         select CRYPTO_HASH
> >         help
> >           CRC T10 Data Integrity Field computation is being cast as
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
