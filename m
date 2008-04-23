From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Date: Thu, 24 Apr 2008 00:28:43 +0200
Message-ID: <20080423222843.GA16683@Chamillionaire.breakpoint.cc>
References: <1207723262.18313.37.camel@caritas-dev.intel.com> <20080416073108.GA13494@Chamillionaire.breakpoint.cc> <1208333949.4322.5.camel@caritas-dev.intel.com> <20080416184016.GA21365@Chamillionaire.breakpoint.cc> <1208397123.4322.21.camel@caritas-dev.intel.com> <20080417033402.GB3394@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: "Huang, Ying" <ying.huang@intel.com>,
	"Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	mingo@elte.hu, tglx@linutronix.de
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41600 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbYDWW2x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Apr 2008 18:28:53 -0400
Content-Disposition: inline
In-Reply-To: <20080417033402.GB3394@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-04-17 11:34:02 [+0800]:

>On Thu, Apr 17, 2008 at 09:52:03AM +0800, Huang, Ying wrote:
>>
>> As far as I know, the CRYPTO_MINALIGN is defined in
>> include/linux/crypto.h as __alignof__(unsigned long long), and the
>> __crt_ctx in crypto_tfm is aligned in CRYPTO_MINALIGN. So I think adding
>> a pad is sufficient for x86_64 implementation.
>
>It should be sufficient but it would be better to use an align
Doesn't this imply that kmalloc() returns memory that is always pointer
aligned what isn't the case AFAIK?

>Thanks,

Sebastian
