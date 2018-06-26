From: Stephan Mueller <smueller@chronox.de>
Subject: Re: cryptomgr_test / drbg_ctr: BUG: sleeping function called from invalid context
Date: Tue, 26 Jun 2018 13:33:12 +0200
Message-ID: <2482919.MrXjzQZjmy@tauon.chronox.de>
References: <CAMuHMdW_4gvQYhCxcXR+sa6dhwAshyJnhXhc36=VC=hWKB-7Jw@mail.gmail.com> <14009987.cibGRJrWdm@positron.chronox.de> <CAMuHMdXfn6YuG9imLKd5nEdxhT4gWu-V8bn1LRt+M3bESaUAkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdXfn6YuG9imLKd5nEdxhT4gWu-V8bn1LRt+M3bESaUAkA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 26. Juni 2018, 12:33:48 CEST schrieb Geert Uytterhoeven:

Hi Geert,

> Issue is gone. I assume due to commit 6e88f01206edab0e ("crypto:
> arm64/aes-blk - fix and move skcipher_walk_done out of kernel_neon_begin,
> _end").

Thanks a lot for the hint.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert



Ciao
Stephan
