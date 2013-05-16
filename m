From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: Tree for May 15 (crypto /crct10dif)
Date: Thu, 16 May 2013 09:22:30 +0200
Message-ID: <CAMuHMdUmD2DMNeezetHNbe9DgQXpTN4BEfEmJSztyzCivQpyXQ@mail.gmail.com>
References: <20130515132627.817585a3d9fb3a3e502eb586@canb.auug.org.au>
	<5193CCEC.7070909@infradead.org>
	<alpine.DEB.2.02.1305161152530.31865@M2420>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: tim.c.chen@linux.intel.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
To: Xiong Zhou <jencce.kernel@gmail.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1305161152530.31865@M2420>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 16, 2013 at 5:57 AM, Xiong Zhou <jencce.kernel@gmail.com> wrote:
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -378,6 +378,7 @@ config CRYPTO_CRC32_PCLMUL
>
>  config CRYPTO_CRCT10DIF
>         tristate "CRCT10DIF algorithm"
> +       depends on CRC_T10DIF

This is a library symbol, so "select CRC_T10DIF"?

>         select CRYPTO_HASH
>         help
>           CRC T10 Data Integrity Field computation is being cast as

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
