From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam/qi2 - add CONFIG_NETDEVICES dependency
Date: Fri, 5 Oct 2018 10:29:42 +0800
Message-ID: <20181005022942.gs7shzuagy5ycfct@gondor.apana.org.au>
References: <20180926130045.2295764-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180926130045.2295764-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 26, 2018 at 03:00:34PM +0200, Arnd Bergmann wrote:
> This driver implements a (part of a) network driver, and fails to
> build if we have turned off networking support:
> 
> drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_caam_fqdan_cb':
> caamalg_qi2.c:(.text+0x577c): undefined reference to `napi_schedule_prep'
> caamalg_qi2.c:(.text+0x578c): undefined reference to `__napi_schedule_irqoff'
> drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_dpseci_poll':
> caamalg_qi2.c:(.text+0x59b8): undefined reference to `napi_complete_done'
> drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_caam_remove':
> caamalg_qi2.c:(.text.unlikely+0x4e0): undefined reference to `napi_disable'
> caamalg_qi2.c:(.text.unlikely+0x4e8): undefined reference to `netif_napi_del'
> drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_dpseci_setup':
> caamalg_qi2.c:(.text.unlikely+0xc98): undefined reference to `netif_napi_add'
> 
> >From what I can tell, CONFIG_NETDEVICES is the correct dependency here,
> and adding it fixes the randconfig failures.
> 
> Fixes: 8d818c105501 ("crypto: caam/qi2 - add DPAA2-CAAM driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
