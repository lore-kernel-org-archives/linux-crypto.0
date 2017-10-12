From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] chacha20-ssse3/avx2: satisfy stack validation 2.0
Date: Thu, 12 Oct 2017 23:16:34 +0800
Message-ID: <20171012151634.GC31122@gondor.apana.org.au>
References: <20171008205053.13201-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin@strongswan.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171008205053.13201-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Oct 08, 2017 at 10:50:53PM +0200, Jason A. Donenfeld wrote:
> The new stack validator in objdump doesn't like directly assigning r11
> to rsp, warning with something like:
> 
> warning: objtool: chacha20_4block_xor_ssse3()+0xa: unsupported stack pointer realignment
> warning: objtool: chacha20_8block_xor_avx2()+0x6: unsupported stack pointer realignment
> 
> This fixes things up to use code similar to gcc's DRAP register, so that
> objdump remains happy.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Fixes: baa41469a7b9 ("objtool: Implement stack validation 2.0")

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
