From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/2] crypto: qat - fix resource release omissions
Date: Tue, 13 Sep 2016 20:40:06 +0800
Message-ID: <20160913124006.GB31835@gondor.apana.org.au>
References: <20160902144753.31334-1-lambert.quentin@gmail.com>
 <20160902144753.31334-3-lambert.quentin@gmail.com>
 <20160906101851.GA27032@sivswdev01.ir.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Quentin Lambert <lambert.quentin@gmail.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        "David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, giovanni.cabiddu@gmail.com
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160906101851.GA27032@sivswdev01.ir.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 06, 2016 at 11:18:51AM +0100, Giovanni Cabiddu wrote:
> 
> ---8<---
> Subject: [PATCH] crypto: qat - fix leak on error path
> 
> Fix a memory leak in an error path in uc loader.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
