From: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Date: Thu, 17 Apr 2008 12:53:13 +0800
Message-ID: <1208407993.4322.29.camel@caritas-dev.intel.com>
References: <1207723262.18313.37.camel@caritas-dev.intel.com>
	 <20080416073108.GA13494@Chamillionaire.breakpoint.cc>
	 <1208333949.4322.5.camel@caritas-dev.intel.com>
	 <20080416184016.GA21365@Chamillionaire.breakpoint.cc>
	 <1208397123.4322.21.camel@caritas-dev.intel.com>
	 <20080417033402.GB3394@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	mingo@elte.hu, tglx@linutronix.de
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35846 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYDQEtG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Apr 2008 00:49:06 -0400
In-Reply-To: <20080417033402.GB3394@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2008-04-17 at 11:34 +0800, Herbert Xu wrote:
> On Thu, Apr 17, 2008 at 09:52:03AM +0800, Huang, Ying wrote:
> >
> > As far as I know, the CRYPTO_MINALIGN is defined in
> > include/linux/crypto.h as __alignof__(unsigned long long), and the
> > __crt_ctx in crypto_tfm is aligned in CRYPTO_MINALIGN. So I think adding
> > a pad is sufficient for x86_64 implementation.
> 
> It should be sufficient but it would be better to use an align
> attribute to better document the intention.

OK. I will use the align attribute.

Best Regards,
Huang Ying
