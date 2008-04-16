From: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Date: Wed, 16 Apr 2008 16:19:09 +0800
Message-ID: <1208333949.4322.5.camel@caritas-dev.intel.com>
References: <1207723262.18313.37.camel@caritas-dev.intel.com>
	 <20080416073108.GA13494@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Adam J. Richter" <adam@yggdrasil.com>,
	Alexander Kjeldaas <astor@fast.no>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	mingo@elte.hu, tglx@linutronix.de
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbYDPIPA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Apr 2008 04:15:00 -0400
In-Reply-To: <20080416073108.GA13494@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Wed, 2008-04-16 at 09:31 +0200, Sebastian Siewior wrote:
> * Huang, Ying | 2008-04-09 14:41:02 [+0800]:
> 
> >This patch increases the performance of AES x86-64 implementation. The
> >average increment is more than 6.3% and the max increment is
> >more than 10.2% on Intel CORE 2 CPU. The performance increment is
> >gained via the following methods:
> >
> >- Two additional temporary registers are used to hold the subset of
> >  the state, so that the dependency between instructions is reduced.
> >
> >- The expanded key is loaded via 2 64bit load instead of 4 32-bit load.
> >
> 
> From your description I would assume that the performance can only
> increase. However, on my
> |model name      : AMD Athlon(tm) 64 Processor 3200+
> the opposite is the case [1], [2]. I dunno why and I didn't mixup
> patched & unpached :). I checked this patch on

En. I have no AMD machine. So I have not tested the patch on it. Maybe
there are some pipeline or load/store unit difference between Intel and
AMD CPUs. Tomorrow I can split the patch into a set of small patches,
with one patch for one small step. Can you help me to test these patches
to find out the reason for degradation on AMD CPU.

> |model name      : Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
> and the performance really increases [3], [4].
> 
> [1] http://download.breakpoint.cc/aes_patch/patched.txt
> [2] http://download.breakpoint.cc/aes_patch/unpatched.txt
> [3] http://download.breakpoint.cc/aes_patch/perf_patched.txt
> [4] http://download.breakpoint.cc/aes_patch/perf_originall.txt
> 
> >---
> > arch/x86/crypto/aes-x86_64-asm_64.S |  101 ++++++++++++++++++++----------------
> > include/crypto/aes.h                |    1 
> > 2 files changed, 58 insertions(+), 44 deletions(-)
> >
> >--- a/include/crypto/aes.h
> >+++ b/include/crypto/aes.h
> >@@ -19,6 +19,7 @@
> > 
> > struct crypto_aes_ctx {
> > 	u32 key_length;
> >+	u32 _pad1;
> 
> Why is this pad required? Do you want special alignment of the keys?

Because the key is loaded in 64bit in this patch, I want to align the
key with 64bit address.

> > 	u32 key_enc[AES_MAX_KEYLENGTH_U32];
> > 	u32 key_dec[AES_MAX_KEYLENGTH_U32];
> > };
> >

Best Regards,
Huang Ying

