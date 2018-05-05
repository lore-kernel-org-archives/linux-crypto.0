From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/2] cleanup and hardware keys
Date: Sat, 5 May 2018 15:16:38 +0800
Message-ID: <20180505071638.qi34i47lodltuyge@gondor.apana.org.au>
References: <1524468316-6606-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1524468316-6606-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 23, 2018 at 08:25:13AM +0100, Gilad Ben-Yossef wrote:
> Small cleanup and add support for CryptoCell hardware keys.
> 
> Changes from v1:
> - The cleanup patch is new, as Herbert took the previous one :-)
> - Hardware key API uses the "paes" designator to indicate a protected key,
>   same as s390, as per Herbert preference
> - Avoid direct casting and reference of key material, as pointed out by
>   Herbert
> 
> Gilad Ben-Yossef (2):
>   crypto: ccree: enable support for hardware keys
>   crypto: ccree: use proper printk format
> 
>  crypto/testmgr.c                 |  43 +++++
>  drivers/crypto/ccree/cc_cipher.c | 350 ++++++++++++++++++++++++++++++++++-----
>  drivers/crypto/ccree/cc_cipher.h |  30 +---
>  drivers/crypto/ccree/cc_driver.c |   2 +-
>  4 files changed, 362 insertions(+), 63 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
