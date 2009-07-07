From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC 7/7] crypto: Add PCLMULQDQ accelerated GHASH
 implementation
Date: Tue, 07 Jul 2009 11:31:52 +0800
Message-ID: <1246937512.5282.99.camel@yhuang-dev.sh.intel.com>
References: <20090621135121.GA3153@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53212 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbZGGDbu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2009 23:31:50 -0400
In-Reply-To: <20090621135121.GA3153@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Herbert,

On Sun, 2009-06-21 at 21:51 +0800, Herbert Xu wrote:
> Huang Ying <ying.huang@intel.com> wrote:
> > PCLMULQDQ is used to accelerate the most time-consuming part of GHASH,
> > carry-less multiplication. More information about PCLMULQDQ can be
> > found at:
> > 
> > http://software.intel.com/en-us/articles/carry-less-multiplication-and-its-usage-for-computing-the-gcm-mode/
> > 
> > Because PCLMULQDQ changes XMM state, its usage must be enclosed with
> > kernel_fpu_begin/end, which can be used only in process context, the
> > acceleration is implemented as crypto_ahash. That is, request in soft
> > IRQ context will be deferred to the cryptd kernel thread.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> All good.
> 
> So once we fully convert everything to shash, this series can
> go in with the minor changes mentioned in this thread.

What's your plan to convert everything to shash? For 2.6.32? How about
the progress? What can I do to help?

Best Regards,
Huang Ying


