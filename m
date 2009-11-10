From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX -v2 for .32] crypto, gcm, fix another complete call in
	complete fuction
Date: Mon, 9 Nov 2009 22:10:22 -0500
Message-ID: <20091110031022.GA13710@gondor.apana.org.au>
References: <1257751454.22519.2287.camel@yhuang-dev.sh.intel.com> <20091109190250.GC9588@gondor.apana.org.au> <1257821399.22519.2410.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755650AbZKJDKU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1257821399.22519.2410.camel@yhuang-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 10, 2009 at 10:49:59AM +0800, Huang Ying wrote:
>
> Yes. This is for performance only. Because crypto_gcm_reqctx(req) is not
> so trivial (it needs access tfm), and used by every xxx_done function,
> so I think it is better to just call crypto_gcm_reqctx once and pass it
> down. Do you think so?

Since we only support blocksize == 16, that means the alignment
cannot exceed 16 bytes.  So just always align to 16 bytes and that
should make crypto_gcm_reqctx trivial once optimised by the
compiler.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
