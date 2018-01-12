From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [v2] crypto: aes-generic - build with -Os on gcc-7+
Date: Fri, 12 Jan 2018 23:24:24 +1100
Message-ID: <20180112122424.GH21636@gondor.apana.org.au>
References: <20180103223940.3715372-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Richard Biener <rguenther@suse.de>,
        Jakub Jelinek <jakub@gcc.gnu.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180103223940.3715372-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 03, 2018 at 11:39:27PM +0100, Arnd Bergmann wrote:
> While testing other changes, I discovered that gcc-7.2.1 produces badly
> optimized code for aes_encrypt/aes_decrypt. This is especially true when
> CONFIG_UBSAN_SANITIZE_ALL is enabled, where it leads to extremely
> large stack usage that in turn might cause kernel stack overflows:
> 
> crypto/aes_generic.c: In function 'aes_encrypt':
> crypto/aes_generic.c:1371:1: warning: the frame size of 4880 bytes is larger than 2048 bytes [-Wframe-larger-than=]
> crypto/aes_generic.c: In function 'aes_decrypt':
> crypto/aes_generic.c:1441:1: warning: the frame size of 4864 bytes is larger than 2048 bytes [-Wframe-larger-than=]
> 
> I verified that this problem exists on all architectures that are
> supported by gcc-7.2, though arm64 in particular is less affected than
> the others. I also found that gcc-7.1 and gcc-8 do not show the extreme
> stack usage but still produce worse code than earlier versions for this
> file, apparently because of optimization passes that generally provide
> a substantial improvement in object code quality but understandably fail
> to find any shortcuts in the AES algorithm.
> 
> Possible workarounds include
> 
> a) disabling -ftree-pre and -ftree-sra optimizations, this was an earlier
>    patch I tried, which reliably fixed the stack usage, but caused a
>    serious performance regression in some versions, as later testing
>    found.
> 
> b) disabling UBSAN on this file or all ciphers, as suggested by Ard
>    Biesheuvel. This would lead to massively better crypto performance in
>    UBSAN-enabled kernels and avoid the stack usage, but there is a concern
>    over whether we should exclude arbitrary files from UBSAN at all.
> 
> c) Forcing the optimization level in a different way. Similar to a),
>    but rather than deselecting specific optimization stages,
>    this now uses "gcc -Os" for this file, regardless of the
>    CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE/SIZE option. This is a reliable
>    workaround for the stack consumption on all architecture, and I've
>    retested the performance results now on x86, cycles/byte (lower is
>    better) for cbc(aes-generic) with 256 bit keys:
> 
> 			-O2     -Os
> 	gcc-6.3.1	14.9	15.1
> 	gcc-7.0.1	14.7	15.3
> 	gcc-7.1.1	15.3	14.7
> 	gcc-7.2.1	16.8	15.9
> 	gcc-8.0.0	15.5	15.6
> 
> This implements the option c) by enabling forcing -Os on all compiler
> versions starting with gcc-7.1. As a workaround for PR83356, it would
> only be needed for gcc-7.2+ with UBSAN enabled, but since it also shows
> better performance on gcc-7.1 without UBSAN, it seems appropriate to
> use the faster version here as well.
> 
> Side note: during testing, I also played with the AES code in libressl,
> which had a similar performance regression from gcc-6 to gcc-7.2,
> but was three times slower overall. It might be interesting to
> investigate that further and possibly port the Linux implementation
> into that.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83651
> Cc: Richard Biener <rguenther@suse.de>
> Cc: Jakub Jelinek <jakub@gcc.gnu.org>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
