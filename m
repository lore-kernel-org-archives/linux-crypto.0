From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cavium: cpt: Replace mdelay with msleep in
 cpt_device_init
Date: Sat, 24 Mar 2018 00:04:11 +0800
Message-ID: <20180323160411.GG2186@gondor.apana.org.au>
References: <1521384638-23251-1-git-send-email-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: george.cherian@cavium.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1521384638-23251-1-git-send-email-baijiaju1990@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Mar 18, 2018 at 10:50:38PM +0800, Jia-Ju Bai wrote:
> cpt_device_init() is never called in atomic context.
> 
> The call chain ending up at cpt_device_init() is:
> [1] cpt_device_init() <- cpt_probe()
> cpt_probe() is only set as ".probe" in pci_driver structure 
> "cpt_pci_driver".
> 
> Despite never getting called from atomic context, cpt_device_init() calls
> mdelay(100), i.e. busy wait for 100ms.
> That is not necessary and can be replaced with msleep to 
> avoid busy waiting.
> 
> This is found by a static analysis tool named DCNS written by myself.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
