From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH cryptodev-2.6 1/4] crypto: cavium/nitrox - fix warnings
 while printing atomic64_t types
Date: Fri, 5 Oct 2018 10:31:53 +0800
Message-ID: <20181005023153.67kvuohxnrtc4frl@gondor.apana.org.au>
References: <20180929081910.17652-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgadam@cavium.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180929081910.17652-1-Jampala.Srikanth@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 29, 2018 at 01:49:07PM +0530, Srikanth Jampala wrote:
> fix compilation warnings with nitrox_debugfs.c while printing
> atomic64_t types on arm64. typecast the atomic64_read() value to u64
> 
> This issue is reported by Ard Biesheuvel
> 
> drivers/crypto/cavium/nitrox/nitrox_debugfs.c:62:30:
> warning: format ‘%lld’ expects argument of type ‘long long int’,
>          but argument 3 has type ‘long int’ [-Wformat=]
>   seq_printf(s, "  Posted: %lld\n", atomic64_read(&ndev->stats.posted));
>                               ^
> Fixes: 2a8780be9c26 (crypto: cavium/nitrox - updated debugfs information)
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
> Reviewed-by: Gadam Sreerama <sgadam@cavium.com>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_debugfs.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
