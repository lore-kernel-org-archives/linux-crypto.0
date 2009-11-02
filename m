From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -v4] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Date: Mon, 2 Nov 2009 09:46:21 -0500
Message-ID: <20091102144621.GA32164@gondor.apana.org.au>
References: <1253064946.15717.372.camel@yhuang-dev.sh.intel.com> <20091019025332.GA26624@gondor.apana.org.au> <20091031173015.69e8e9f8.akpm@linux-foundation.org> <20091101175043.GA25257@gondor.apana.org.au> <20091102075039.GA15942@elte.hu> <20091102142824.GA31981@gondor.apana.org.au> <20091102143258.GA23776@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Huang Ying <ying.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Daniel Walker <dwalker@fifo99.com>,
	"H. Peter Anvin" <hpa@zytor.com>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47247 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754238AbZKBOq3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Nov 2009 09:46:29 -0500
Content-Disposition: inline
In-Reply-To: <20091102143258.GA23776@elte.hu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 02, 2009 at 03:32:58PM +0100, Ingo Molnar wrote:
> 
> Please use the standard construct and put an #ifndef __ASSEMBLY__ around 
> it.

You mean like this?

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 0b20bbb..e22d237 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -10,6 +10,13 @@
 #ifndef _ASM_X86_I387_H
 #define _ASM_X86_I387_H
 
+#ifdef __ASSEMBLY__
+
+#define PSHUFB_XMM5_XMM0 .byte 0x66, 0x0f, 0x38, 0x00, 0xc5
+#define PSHUFB_XMM5_XMM6 .byte 0x66, 0x0f, 0x38, 0x00, 0xf5
+
+#else
+
 #include <linux/sched.h>
 #include <linux/kernel_stat.h>
 #include <linux/regset.h>
@@ -411,4 +418,5 @@ static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
 	}
 }
 
+#endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_I387_H */

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
