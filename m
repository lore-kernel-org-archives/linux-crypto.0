From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] x86, crypto, Use gas macro for PCLMULQDQ-NI and
	PSHUFB
Date: Mon, 23 Nov 2009 19:55:53 +0800
Message-ID: <20091123115553.GA6424@gondor.apana.org.au>
References: <1257839041.22519.2523.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757375AbZKWLzw@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1257839041.22519.2523.camel@yhuang-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 10, 2009 at 03:44:01PM +0800, Huang Ying wrote:
> Old binutils do not support PCLMULQDQ-NI and PSHUFB, to make kernel
> can be compiled by them, .byte code is used instead of assembly
> instructions. But the readability and flexibility of raw .byte code is
> not good.
> 
> So corresponding assembly instruction like gas macro is used instead.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Both patches applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
