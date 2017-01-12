From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: mediatek - fix format string for 64-bit
 builds
Date: Fri, 13 Jan 2017 00:44:44 +0800
Message-ID: <20170112164444.GC20313@gondor.apana.org.au>
References: <20170111135104.3961730-1-arnd@arndb.de>
 <20170111135601.4047225-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111135601.4047225-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 11, 2017 at 02:55:20PM +0100, Arnd Bergmann wrote:
> After I enabled COMPILE_TEST for non-ARM targets, I ran into these
> warnings:
> 
> crypto/mediatek/mtk-aes.c: In function 'mtk_aes_info_map':
> crypto/mediatek/mtk-aes.c:224:28: error: format '%d' expects argument of type 'int', but argument 3 has type 'long unsigned int' [-Werror=format=]
>    dev_err(cryp->dev, "dma %d bytes error\n", sizeof(*info));
> crypto/mediatek/mtk-sha.c:344:28: error: format '%d' expects argument of type 'int', but argument 3 has type 'long unsigned int' [-Werror=format=]
> crypto/mediatek/mtk-sha.c:550:21: error: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'size_t {aka long unsigned int}' [-Werror=format=]
> 
> The correct format for size_t is %zu, so use that in all three
> cases.
> 
> Fixes: 785e5c616c84 ("crypto: mediatek - Add crypto driver support for some MediaTek chips")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
