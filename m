From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: marvell - Remove the old CESA driver
Date: Fri, 3 Nov 2017 22:22:31 +0800
Message-ID: <20171103142231.GD9011@gondor.apana.org.au>
References: <20171011131619.30196-1-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
 Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
 Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@kernel.org>,
 Arnaud Ebalard <arno@natisbad.org>, Russell King <linux@armlinux.org.uk>,
 Gregory CLEMENT <gregory.clement@free-electrons.com>,
 linux-crypto@vger.kernel.org, Olof Johansson <olof@lixom.net>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20171011131619.30196-1-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 11, 2017 at 03:16:16PM +0200, Boris Brezillon wrote:
> Hello,
> 
> It's been several releases since we added a new driver to support the
> CESA IP (the new driver was introduced in 4.2). It seems most major
> bugs have been discovered and fixed and now is probably a good time to
> kill the old driver and force remaining users to switch to the new one.
> 
> This series first add a platform_device_id table to the marvell CESA
> driver so that it can work on non-DT platforms. Then we patch all
> defconfigs to select the new driver instead of the old. And finally we
> remove the old driver.
> These patches have to be applied in this order to make things
> bisectable, so, if this series is accepted it will have to go through
> a single tree (either ARM or crypto).
> 
> Regards,
> 
> Boris
> 
> Boris Brezillon (3):
>   crypto: marvell - Add a platform_device_id table
>   ARM: configs: Stop selecting the old CESA driver
>   crypto: marvell - Remove the old mv_cesa driver
> 
>  arch/arm/configs/dove_defconfig     |    2 +-
>  arch/arm/configs/multi_v5_defconfig |    2 +-
>  arch/arm/configs/orion5x_defconfig  |    2 +-
>  drivers/crypto/Kconfig              |   22 +-
>  drivers/crypto/Makefile             |    1 -
>  drivers/crypto/marvell/cesa.c       |   13 +-
>  drivers/crypto/mv_cesa.c            | 1216 -----------------------------------
>  drivers/crypto/mv_cesa.h            |  150 -----
>  8 files changed, 12 insertions(+), 1396 deletions(-)
>  delete mode 100644 drivers/crypto/mv_cesa.c
>  delete mode 100644 drivers/crypto/mv_cesa.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
