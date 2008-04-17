From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Date: Thu, 17 Apr 2008 11:34:02 +0800
Message-ID: <20080417033402.GB3394@gondor.apana.org.au>
References: <1207723262.18313.37.camel@caritas-dev.intel.com> <20080416073108.GA13494@Chamillionaire.breakpoint.cc> <1208333949.4322.5.camel@caritas-dev.intel.com> <20080416184016.GA21365@Chamillionaire.breakpoint.cc> <1208397123.4322.21.camel@caritas-dev.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	mingo@elte.hu, tglx@linutronix.de
To: "Huang, Ying" <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45442 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753337AbYDQDeM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Apr 2008 23:34:12 -0400
Content-Disposition: inline
In-Reply-To: <1208397123.4322.21.camel@caritas-dev.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 17, 2008 at 09:52:03AM +0800, Huang, Ying wrote:
>
> As far as I know, the CRYPTO_MINALIGN is defined in
> include/linux/crypto.h as __alignof__(unsigned long long), and the
> __crt_ctx in crypto_tfm is aligned in CRYPTO_MINALIGN. So I think adding
> a pad is sufficient for x86_64 implementation.

It should be sufficient but it would be better to use an align
attribute to better document the intention.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
