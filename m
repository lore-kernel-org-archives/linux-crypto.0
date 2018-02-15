From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/7] crypto: ccree: Introduce Arm TrustZone CryptoCell
Date: Thu, 15 Feb 2018 23:41:50 +0800
Message-ID: <20180215154150.GB7352@gondor.apana.org.au>
References: <1516613230-4524-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1516613230-4524-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On Mon, Jan 22, 2018 at 09:26:58AM +0000, Gilad Ben-Yossef wrote:
> Arm TrustZone CryptoCell is a security hardware IP that
> includes support for hardware based hash, digest, cipher
> and AEAD operations. This driver provides support for
> these as part of the Linux Crypto sub-system.
> 
> The driver spent some time now in the staging tree being
> cleaned up and is now submitted for review for the
> purpose of moving into the crypto tree. The first patch
> therefore renames its copy in the staging directory
> Kconfig define and marks it broken, otherwise there is a
> build failure due to global symbols collisions.
> 
> Please note that the driver include stubs for yet
> unexposed functionality (ivgen and secure HW keys),
> which will be added later.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> 
> Changes from v1:
> - Use KConfig directive to stop staging tree version to not
>   collide during link time as opposed to deleting it as indicated
>   by Greg KH.
> - Switched from legacy ablkcipher to skcipher interface as
>   indicated by Corentin Labbe.
> - Removed unused zero_buff struct as indicated by Corentin Labbe.
> - Moved to kzfree for all IV/key buffers as indicated by
>   Corentin Labbe.
> - Moved to using __des3_ede_setkey() in lieu of home grown
>   version as indicated by Stephan Mueller.
> - Fixed multiple small coding style from Dan Carpenter and others.
> - Fixed pointer signedness sparse warnings as indicated by Jeremy
>   Sowden.
> - Rename all registered algs driver name to -ccree prefix
> 
> Gilad Ben-Yossef (7):
>   staging: ccree: rename staging ver and mark as broken
>   crypto: ccree: introduce CryptoCell driver
>   crypto: ccree: add skcipher support
>   crypto: ccree: add ahash support
>   crypto: ccree: add AEAD support
>   crypto: ccree: add FIPS support
>   MAINTAINERS: update ccree entry

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
