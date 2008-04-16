From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Date: Wed, 16 Apr 2008 09:31:08 +0200
Message-ID: <20080416073108.GA13494@Chamillionaire.breakpoint.cc>
References: <1207723262.18313.37.camel@caritas-dev.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Adam J. Richter" <adam@yggdrasil.com>,
	Alexander Kjeldaas <astor@fast.no>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	mingo@elte.hu, tglx@linutronix.de
To: "Huang, Ying" <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:37997 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755997AbYDPHb2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Apr 2008 03:31:28 -0400
Content-Disposition: inline
In-Reply-To: <1207723262.18313.37.camel@caritas-dev.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Huang, Ying | 2008-04-09 14:41:02 [+0800]:

>This patch increases the performance of AES x86-64 implementation. The
>average increment is more than 6.3% and the max increment is
>more than 10.2% on Intel CORE 2 CPU. The performance increment is
>gained via the following methods:
>
>- Two additional temporary registers are used to hold the subset of
>  the state, so that the dependency between instructions is reduced.
>
>- The expanded key is loaded via 2 64bit load instead of 4 32-bit load.
>

>From your description I would assume that the performance can only
increase. However, on my
|model name      : AMD Athlon(tm) 64 Processor 3200+
the opposite is the case [1], [2]. I dunno why and I didn't mixup
patched & unpached :). I checked this patch on
|model name      : Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
and the performance really increases [3], [4].

[1] http://download.breakpoint.cc/aes_patch/patched.txt
[2] http://download.breakpoint.cc/aes_patch/unpatched.txt
[3] http://download.breakpoint.cc/aes_patch/perf_patched.txt
[4] http://download.breakpoint.cc/aes_patch/perf_originall.txt

>---
> arch/x86/crypto/aes-x86_64-asm_64.S |  101 ++++++++++++++++++++----------------
> include/crypto/aes.h                |    1 
> 2 files changed, 58 insertions(+), 44 deletions(-)
>
>--- a/include/crypto/aes.h
>+++ b/include/crypto/aes.h
>@@ -19,6 +19,7 @@
> 
> struct crypto_aes_ctx {
> 	u32 key_length;
>+	u32 _pad1;

Why is this pad required? Do you want special alignment of the keys?

> 	u32 key_enc[AES_MAX_KEYLENGTH_U32];
> 	u32 key_dec[AES_MAX_KEYLENGTH_U32];
> };
>

Sebastian
