From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] cleanups and new HW rev support
Date: Sat, 3 Mar 2018 00:42:12 +0800
Message-ID: <20180302164212.GE21579@gondor.apana.org.au>
References: <1519051887-4668-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1519051887-4668-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Feb 19, 2018 at 02:51:20PM +0000, Gilad Ben-Yossef wrote:
> This patch set introduces backward compatible support for the older
> CryptoCell hardware revision 710 and 630 along some minor code
> cleanups.
> 
> Gilad Ben-Yossef (4):
>   crypto: ccree: remove unused definitions
>   dt-bindings: Add DT bindings for ccree 710 and 630p
>   crypto: ccree: add support for older HW revs
>   crypto: ccree: replace memset+kfree with kzfree
> 
>  .../devicetree/bindings/crypto/arm-cryptocell.txt  |   3 +-
>  drivers/crypto/Kconfig                             |   6 +-
>  drivers/crypto/ccree/cc_aead.c                     |  34 +++--
>  drivers/crypto/ccree/cc_cipher.c                   |  25 +++-
>  drivers/crypto/ccree/cc_crypto_ctx.h               |  36 -----
>  drivers/crypto/ccree/cc_driver.c                   |  68 ++++++++--
>  drivers/crypto/ccree/cc_driver.h                   |  23 +++-
>  drivers/crypto/ccree/cc_fips.c                     |  13 +-
>  drivers/crypto/ccree/cc_hash.c                     | 149 +++++++++++----------
>  drivers/crypto/ccree/cc_hash.h                     |  12 +-
>  drivers/crypto/ccree/cc_host_regs.h                |   3 +
>  drivers/crypto/ccree/cc_hw_queue_defs.h            |   2 +-
>  drivers/crypto/ccree/cc_kernel_regs.h              |   1 +
>  drivers/crypto/ccree/cc_request_mgr.c              |   9 +-
>  drivers/crypto/ccree/cc_sram_mgr.c                 |  14 ++
>  15 files changed, 240 insertions(+), 158 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
