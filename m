From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: brcm - Fix SHA3-512 algorithm failure
Date: Tue, 18 Jul 2017 18:33:55 +0800
Message-ID: <20170718103355.GA6512@gondor.apana.org.au>
References: <1498208648-15948-1-git-send-email-raveendra.padasalagi@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, rob.rice@broadcom.com, sbranden@broadcom.com,
        ray.jui@broadcom.com, steven.lin1@broadcom.com,
        linux-crypto@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        raveendra.padasalagi@broadcom.com
To: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1498208648-15948-1-git-send-email-raveendra.padasalagi@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Raveendra Padasalagi <raveendra.padasalagi@broadcom.com> wrote:
> In Broadcom SPU driver, due to missing break statement
> in spu2_hash_xlate() while mapping SPU2 equivalent
> SHA3-512 value, -EINVAL is chosen and hence leading to
> failure of SHA3-512 algorithm. This patch fixes the same.
> 
> Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
> Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
> Reviewed-by: Ray Jui <ray.jui@broadcom.com>
> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
> Cc: stable@vger.kernel.org

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
