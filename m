From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -v2] Speed testing support for ghash
Date: Wed, 10 Mar 2010 18:30:52 +0800
Message-ID: <20100310103052.GB23398@gondor.apana.org.au>
References: <1267586296.1640.205.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1267586296.1640.205.camel@yhuang-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 03, 2010 at 11:18:16AM +0800, Huang Ying wrote:
> Because ghash needs setkey, the setkey and keysize template support
> for test_hash_speed is added.
> 
> v2:
> 
>  - Move klen into struct hash_speed.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Also applied.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
