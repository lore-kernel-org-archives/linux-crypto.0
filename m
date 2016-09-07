From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam: add missing header dependencies
Date: Wed, 7 Sep 2016 21:11:03 +0800
Message-ID: <20160907131103.GC17176@gondor.apana.org.au>
References: <1472873370-18589-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, horia.geanta@nxp.com,
        srinivas.kandagatla@linaro.org, alexandru.porosanu@nxp.com,
        arnd@arndb.de, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, xie.baoyou@zte.com.cn
To: Baoyou Xie <baoyou.xie@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472873370-18589-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 03, 2016 at 11:29:30AM +0800, Baoyou Xie wrote:
> We get 1 warning when building kernel with W=1:
> drivers/crypto/caam/ctrl.c:398:5: warning: no previous prototype for 'caam_get_era' [-Wmissing-prototypes]
> 
> In fact, this function is declared in drivers/crypto/caam/ctrl.h
> and be exported, thus can be refrenced by modules, so this patch 
> adds missing header dependencies.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>

This patch has already been applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
