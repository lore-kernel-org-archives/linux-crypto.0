From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 7/7] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Date: Sun, 21 Jun 2009 21:51:21 +0800
Message-ID: <20090621135121.GA3153@gondor.apana.org.au>
References: <1244704280.5320.131.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754955AbZFUNvb@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1244704280.5320.131.camel@yhuang-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Huang Ying <ying.huang@intel.com> wrote:
> PCLMULQDQ is used to accelerate the most time-consuming part of GHASH,
> carry-less multiplication. More information about PCLMULQDQ can be
> found at:
> 
> http://software.intel.com/en-us/articles/carry-less-multiplication-and-its-usage-for-computing-the-gcm-mode/
> 
> Because PCLMULQDQ changes XMM state, its usage must be enclosed with
> kernel_fpu_begin/end, which can be used only in process context, the
> acceleration is implemented as crypto_ahash. That is, request in soft
> IRQ context will be deferred to the cryptd kernel thread.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

All good.

So once we fully convert everything to shash, this series can
go in with the minor changes mentioned in this thread.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
