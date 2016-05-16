From: Megha Dey <megha.dey@linux.intel.com>
Subject: Re: SHA1-MB algorithm broken on latest kernel
Date: Mon, 16 May 2016 11:31:12 -0700
Message-ID: <1463423472.5329.6.camel@megha-Z97X-UD7-TH>
References: <1463095866.2594.8.camel@megha-Z97X-UD7-TH>
	 <20160513031020.GA12467@gondor.apana.org.au>
	 <20160513055103.GB24504@gmail.com>
	 <1463160746.2594.11.camel@megha-Z97X-UD7-TH>
	 <20160516144409.dkzqrpd3nlb36ygq@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ingo Molnar <mingo@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160516144409.dkzqrpd3nlb36ygq@treble>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2016-05-16 at 09:44 -0500, Josh Poimboeuf wrote:
> On Fri, May 13, 2016 at 10:32:26AM -0700, Megha Dey wrote:
> > On Fri, 2016-05-13 at 07:51 +0200, Ingo Molnar wrote:
> > > * Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > > 
> > > > On Thu, May 12, 2016 at 04:31:06PM -0700, Megha Dey wrote:
> > > > > Hi,
> > > > >  
> > > > > When booting latest kernel with the CONFIG_CRYPTO_SHA1_MB enabled, I
> > > > > observe a panic.
> > > > >  
> > > > > After having a quick look, on reverting the following patches, I am able
> > > > > to complete the booting process.
> > > > > aec4d0e301f17bb143341c82cc44685b8af0b945
> > > > > 8691ccd764f9ecc69a6812dfe76214c86ac9ba06
> > > > > 68874ac3304ade7ed5ebb12af00d6b9bbbca0a16
> > > > >  
> > > > > Of the 3 patches, aec4d0e301f17bb143341c82cc44685b8af0b945 seems wrong.
> > > > > The r10 to r15 registers are used in sha1_x8_avx2.S, which is called
> > > > > from sha1_mb_mgr_flush_avx2.S.
> > > > >
> > > > > I do not think the functionality of the SHA1-MB crypto algorithm has
> > > > > been tested after applying these changes. (I am not sure if any of the
> > > > > other crypto algorithms have been affected by these changes).
> > > > 
> > > > Josh, Ingo:
> > > > 
> > > > Any ideas on this? Should we revert?
> > > 
> > > Yeah, I think so - although another option would be to standardize sha1_x8_avx2() 
> > > - the problem is that it is a function that clobbers registers without 
> > > saving/restoring them, breaking the C function ABI. I realize it's written in 
> > > assembly, but unless there are strong performance reasons to deviate from the 
> > > regular calling convention it might make sense to fix that.
> > > 
> > > Do any warnings get generated after the revert, if you enable 
> > > CONFIG_STACK_VALIDATION=y?
> > 
> > After the revert and enabling CONFIG_STACK_VALIDATION:
> > arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.o: warning: objtool:
> > sha1_mb_mgr_flush_avx2()+0x20d: call without frame pointer save/setup
> > 
> > arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.o: warning: objtool:
> > sha1_mb_mgr_submit_avx2()+0x115: call without frame pointer save/setup
> 
> Megha,
> 
> Sorry for breaking it.  I completely missed the fact that the function
> calls sha1_x8_avx2() which clobbers registers.
> 
> If the performance penalty isn't too bad, I'll submit a patch to
> standardize sha1_x8_avx2() to follow the C ABI.
> 
> Do you have any tips for testing this code?  I've tried using the tcrypt
> module, but no luck.
> 
Josh,
Build the kernel with the following configs:
CONFIG_CRYPTO_SHA1_MB=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n
There was a kernel panic while booting. 
So if after applying your new patch, we are able to get complete the
boot, then we are good.

Could you please send a copy of the patch, I could test it on my end
too. 
