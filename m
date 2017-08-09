From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - avoid uninitialized variable warning
Date: Wed, 9 Aug 2017 21:57:03 +0800
Message-ID: <20170809135703.GD743@gondor.apana.org.au>
References: <20170731204936.1511542-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170731204936.1511542-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 31, 2017 at 10:49:21PM +0200, Arnd Bergmann wrote:
> The added support for version 5 CCPs introduced a false-positive
> warning in the RSA implementation:
> 
> drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_rsa_cmd':
> drivers/crypto/ccp/ccp-ops.c:1856:3: error: 'sb_count' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> This changes the code in a way that should make it easier for
> the compiler to track the state of the sb_count variable, and
> avoid the warning.
> 
> Fixes: 6ba46c7d4d7e ("crypto: ccp - Fix base RSA function for version 5 CCPs")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
