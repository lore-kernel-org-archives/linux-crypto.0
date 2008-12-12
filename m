From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel AES-NI
	instructions
Date: Fri, 12 Dec 2008 20:57:22 +0100
Message-ID: <20081212195722.GA24489@Chamillionaire.breakpoint.cc>
References: <1229054926.5936.160.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:37923 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751774AbYLLT6Y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Dec 2008 14:58:24 -0500
Content-Disposition: inline
In-Reply-To: <1229054926.5936.160.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Huang Ying | 2008-12-12 12:08:46 [+0800]:

>Add support to Intel AES-NI instructions for x86_64 platform.
>
>Intel AES-NI is a new set of Single Instruction Multiple Data (SIMD)
>instructions that are going to be introduced in the next generation of
>Intel processor, as of 2009. These instructions enable fast and secure
>data encryption and decryption, using the Advanced Encryption Standard
>(AES), defined by FIPS Publication number 197.  The architecture
>introduces six instructions that offer full hardware support for
>AES. Four of them support high performance data encryption and
>decryption, and the other two instructions support the AES key
>expansion procedure.
>
>The white paper can be downloaded from:
>
>http://softwarecommunity.intel.com/isn/downloads/intelavx/AES-Instructions-Set_WP.pdf
>
>AES may be used in soft_irq context, but MMX/SSE context can not be
>touched safely in soft_irq context. So in_interrupt() is checked, if
>in IRQ or soft_irq context, the general x86_64 implementation are used
>instead.

Nice work. A few things:
- Did you rename the "old" x86 functions to avoid a clash?
  So you bypass the crypto layer in case you can't handle the operation.
  Does this improve the performace or just saves key strokes? Not sure
  what the best sollution could be....
- unless I've read the code too fast, it does not work if someone sets the
  key in user context and starts an encryption in softirq context.
- aes_ctx is somehow bad. You are using this for a function and a
  struct. An Intel prefix would be nice (in case of the struct). On a
  second thought, any reason why you can't use crypto_aes_ctx?
- Is this an Intel thing or is going to be part of X86 and also
  available to others (like mmx). In that case the Intel prefix may be
  "wrong".
- does the cpu support more than just pure aes e.g. block modes? In case
  it does not, does the perfomance improve if you implement lets say
  cbc(aes) and do the xor with sse in order to save a few
  kernel_fpu_begin() calls? I'm just asking because I saw a similar
  thing and PowerPC and the AltiVec unit. Maybe it is cheap on x86 :)
- I can't see how why the intel-aes alias is required.

>Signed-off-by: Huang Ying <ying.huang@intel.com>
Sebastian
