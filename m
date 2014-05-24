From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] crypto: x86/sha1: fix coverity CID 1195603
Date: Sat, 24 May 2014 14:30:42 +0200
Message-ID: <201405241430.42673.marex@denx.de>
References: <1398885474-21388-1-git-send-email-milos.vyletel@gmail.com> <20140508133025.GB12700@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Milos Vyletel <milos.vyletel@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	"open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>,
	linux-coverity@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140508133025.GB12700@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday, May 08, 2014 at 03:30:25 PM, Herbert Xu wrote:
> On Wed, Apr 30, 2014 at 03:17:54PM -0400, Milos Vyletel wrote:
> > Coverity detected possible use of uninitialized pointer when printing
> > info message during module load. While this is higly unlikely to cause
> > any troubles simple change in sha1_ssse3_mod_init to make it look like
> > sha256/512 init function will fix this.
> > 
> > 260
> > 
> >    	6. Condition sha1_transform_asm, taking true branch
> > 
> > 261        if (sha1_transform_asm) {
> > 
> > CID 1195603 (#1 of 1): Uninitialized pointer read (UNINIT)
> > 7. uninit_use_in_call: Using uninitialized value algo_name when calling
> > printk. 262                pr_info("Using %s optimized SHA-1
> > implementation\n", algo_name); 263                return
> > crypto_register_shash(&alg);
> > 264        }
> > 
> > Reported-by: <scan-admin@coverity.com>
> > Signed-off-by: Milos Vyletel <milos.vyletel@gmail.com>
> 
> Unless I'm missing something there is no way this code can use
> the variable without initialising it.
> 
> So this is a false positive and I'm not applying this.

I suppose changing the commit message to "align the code with sha256 ... NOTE: 
this also fixed CIDxyz." would work better and might get this applied ? I think 
unification of code is always good.

Best regards,
Marek Vasut
