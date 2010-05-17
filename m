From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [BUG] SLOB breaks Crypto
Date: Mon, 17 May 2010 18:17:14 +0200
Message-ID: <AANLkTilPEnh3ewTb-KDsReBpjcszh1wkbfZohIaPXBKe@mail.gmail.com>
References: <4B9E38AF.70309@fami-braun.de>
	 <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com>
	 <4BA29A19.2050307@fami-braun.de>
	 <20100319003351.GC20227@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: michael-dev@fami-braun.de, Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>,
	Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100319003351.GC20227@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 19, 2010 at 02:33, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Mar 18, 2010 at 10:24:41PM +0100, michael-dev@fami-braun.de wrote:
>>
>> Pekka Enberg schrieb:
>> > Even with CONFIG_DEBUG_SLAB enabled or with CONFIG_SLUB and
>> > CONFIG_SLUB_DEBUG_ON?
>>
>> no, these options have not been / are not enabled.
>
> Can you please try it with those options enabled? That will tell
> us if there is some latent bug in the crypto layer that only shows
> up right away under SLOB.

After seeing a posting from Nemoto-san on the linux-mips list (should
show up soon on
http://www.linux-mips.org/archives/linux-mips/2010-05/threads.html),
I'm wondering if these defaults are the culprit;

mm/slab.c:#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
mm/slob.c:#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
mm/slub.c:#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)

Note that some platforms override this.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
