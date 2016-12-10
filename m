From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: scatterwalk_map_and_copy incorrect optimization
Date: Sat, 10 Dec 2016 16:08:32 +0800
Message-ID: <20161210080832.GA32701@gondor.apana.org.au>
References: <CAHmME9p24bkNPD2CfGMUOHxgOX+OuFO_rVqfhOQdDexwW53ExA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9p24bkNPD2CfGMUOHxgOX+OuFO_rVqfhOQdDexwW53ExA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Dec 09, 2016 at 02:18:01PM +0100, Jason A. Donenfeld wrote:
> Hi Herbert,
> 
> The scatterwalk_map_and_copy function copies ordinary buffers to and
> from scatterlists. These buffers can, of course, be on the stack, and
> this remains the most popular use of this function -- getting info
> between stack buffers and DMA regions. It's mostly used for adding or
> checking MACs, in the majority of call sites. Its implementation is
> relatively straightforward. It maps the DMA region(s) to a vaddr, and
> then just calls vanilla memcpy. Pretty uncontroversial.
> 
> However, around ~4.1 an optimization was added to prevent copying when
> unnecessary (when the src and dst are the same). The optimization
> looks like this:
> 
>         if (sg_page(sg) == virt_to_page(buf) &&
>            sg->offset == offset_in_page(buf))
>                return;
> 
> There are two problems with this:

This code no longer exists in the current tree.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
