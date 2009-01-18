From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto -v6 1/2] AES-NI: Add support to access
	underlying blkcipher under cryptd ablkcipher
Date: Sun, 18 Jan 2009 16:29:05 +1100
Message-ID: <20090118052905.GA23663@gondor.apana.org.au>
References: <1232091666.13948.52.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759539AbZARF3c@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1232091666.13948.52.camel@yhuang-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jan 16, 2009 at 03:41:06PM +0800, Huang Ying wrote:
> cryptd_alloc_ablkcipher() will allocate a cryptd-ed ablkcipher for
> specified algorithm name. The new allocated one is guaranteed to be
> cryptd-ed ablkcipher, so the blkcipher underlying can be gotten via
> cryptd_ablkcipher_child().

Both patches applied.

Thanks a lot for your hard work on this!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
