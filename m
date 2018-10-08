From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cavium/nitrox - Fix format strings
Date: Mon, 8 Oct 2018 13:47:54 +0800
Message-ID: <20181008054754.zdt42w6whtpqkpif@gondor.apana.org.au>
References: <20181002210022.2369756-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181002210022.2369756-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 02, 2018 at 11:00:03PM +0200, Arnd Bergmann wrote:
> The return type of atomic64_read() is unfortunately architecture
> specific, it can be 'long', 'long long', or 's64'. When it is 'long',
> we get a build warning:
> 
> drivers/crypto/cavium/nitrox/nitrox_debugfs.c: In function 'stats_show':
> drivers/crypto/cavium/nitrox/nitrox_debugfs.c:62:30: error: format '%lld' expects argument of type 'long long int', but argument 3 has type 'long int' [-Werror=format=]
>   seq_printf(s, "  Posted: %lld\n", atomic64_read(&ndev->stats.posted));
>                            ~~~^
>                            %ld
> drivers/crypto/cavium/nitrox/nitrox_debugfs.c:63:33: error: format '%lld' expects argument of type 'long long int', but argument 3 has type 'long int' [-Werror=format=]
>   seq_printf(s, "  Completed: %lld\n",
>                               ~~~^
>                               %ld
> drivers/crypto/cavium/nitrox/nitrox_debugfs.c:65:31: error: format '%lld' expects argument of type 'long long int', but argument 3 has type 'long int' [-Werror=format=]
> 
> Add an explicit cast to 's64' to get a consistent behavior on all
> architectures here during compile testing.
> 
> Fixes: 2a8780be9c26 ("crypto: cavium/nitrox - updated debugfs information.")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

This patch doesn't apply to cryptodev because the bug has already
been fixed by another patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
