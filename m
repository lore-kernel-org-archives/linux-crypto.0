From: Megha Dey <megha.dey@linux.intel.com>
Subject: Re: [PATCH] crypto/sha1-mb: make sha1_x8_avx2() conform to C
 function ABI
Date: Mon, 16 May 2016 16:07:53 -0700
Message-ID: <1463440073.2547.1.camel@megha-Z97X-UD7-TH>
References: <1463095866.2594.8.camel@megha-Z97X-UD7-TH>
	 <20160513031020.GA12467@gondor.apana.org.au>
	 <20160513055103.GB24504@gmail.com>
	 <1463160746.2594.11.camel@megha-Z97X-UD7-TH>
	 <20160516144409.dkzqrpd3nlb36ygq@treble>
	 <1463423472.5329.6.camel@megha-Z97X-UD7-TH>
	 <20160516201618.u4zethkab3ohgtfb@treble>
	 <1463434746.2538.1.camel@megha-Z97X-UD7-TH>
	 <20160516214631.5cvnfgvppw74acah@treble>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ingo Molnar <mingo@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33734 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbcEPXCo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 May 2016 19:02:44 -0400
In-Reply-To: <20160516214631.5cvnfgvppw74acah@treble>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2016-05-16 at 16:46 -0500, Josh Poimboeuf wrote:
> On Mon, May 16, 2016 at 02:39:06PM -0700, Megha Dey wrote:
> > On Mon, 2016-05-16 at 15:16 -0500, Josh Poimboeuf wrote:
> > > On Mon, May 16, 2016 at 11:31:12AM -0700, Megha Dey wrote:
> > > > On Mon, 2016-05-16 at 09:44 -0500, Josh Poimboeuf wrote:
> > > > > On Fri, May 13, 2016 at 10:32:26AM -0700, Megha Dey wrote:
> > > > > > On Fri, 2016-05-13 at 07:51 +0200, Ingo Molnar wrote:
> > > > > > > * Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > > > > > > 
> > > > > > > > On Thu, May 12, 2016 at 04:31:06PM -0700, Megha Dey wrote:
> > > > > > > > > Hi,
> > > > > > > > >  
> > > > > > > > > When booting latest kernel with the CONFIG_CRYPTO_SHA1_MB enabled, I
> > > > > > > > > observe a panic.
> > > > > > > > >  
> > > > > > > > > After having a quick look, on reverting the following patches, I am able
> > > > > > > > > to complete the booting process.
> > > > > > > > > aec4d0e301f17bb143341c82cc44685b8af0b945
> > > > > > > > > 8691ccd764f9ecc69a6812dfe76214c86ac9ba06
> > > > > > > > > 68874ac3304ade7ed5ebb12af00d6b9bbbca0a16
> > > > > > > > >  
> > > > > > > > > Of the 3 patches, aec4d0e301f17bb143341c82cc44685b8af0b945 seems wrong.
> > > > > > > > > The r10 to r15 registers are used in sha1_x8_avx2.S, which is called
> > > > > > > > > from sha1_mb_mgr_flush_avx2.S.
> > > > > > > > >
> > > > > > > > > I do not think the functionality of the SHA1-MB crypto algorithm has
> > > > > > > > > been tested after applying these changes. (I am not sure if any of the
> > > > > > > > > other crypto algorithms have been affected by these changes).
> > > > > > > > 
> > > > > > > > Josh, Ingo:
> > > > > > > > 
> > > > > > > > Any ideas on this? Should we revert?
> > > > > > > 
> > > > > > > Yeah, I think so - although another option would be to standardize sha1_x8_avx2() 
> > > > > > > - the problem is that it is a function that clobbers registers without 
> > > > > > > saving/restoring them, breaking the C function ABI. I realize it's written in 
> > > > > > > assembly, but unless there are strong performance reasons to deviate from the 
> > > > > > > regular calling convention it might make sense to fix that.
> > > > > > > 
> > > > > > > Do any warnings get generated after the revert, if you enable 
> > > > > > > CONFIG_STACK_VALIDATION=y?
> > > > > > 
> > > > > > After the revert and enabling CONFIG_STACK_VALIDATION:
> > > > > > arch/x86/crypto/sha1-mb/sha1_mb_mgr_flush_avx2.o: warning: objtool:
> > > > > > sha1_mb_mgr_flush_avx2()+0x20d: call without frame pointer save/setup
> > > > > > 
> > > > > > arch/x86/crypto/sha1-mb/sha1_mb_mgr_submit_avx2.o: warning: objtool:
> > > > > > sha1_mb_mgr_submit_avx2()+0x115: call without frame pointer save/setup
> > > > > 
> > > > > Megha,
> > > > > 
> > > > > Sorry for breaking it.  I completely missed the fact that the function
> > > > > calls sha1_x8_avx2() which clobbers registers.
> > > > > 
> > > > > If the performance penalty isn't too bad, I'll submit a patch to
> > > > > standardize sha1_x8_avx2() to follow the C ABI.
> > > > > 
> > > > > Do you have any tips for testing this code?  I've tried using the tcrypt
> > > > > module, but no luck.
> > > > > 
> > > > Josh,
> > > > Build the kernel with the following configs:
> > > > CONFIG_CRYPTO_SHA1_MB=y
> > > > CONFIG_CRYPTO_TEST=m
> > > > CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n
> > > > There was a kernel panic while booting. 
> > > > So if after applying your new patch, we are able to get complete the
> > > > boot, then we are good.
> > > > 
> > > > Could you please send a copy of the patch, I could test it on my end
> > > > too. 
> > > 
> > > Thanks.  I was able to run the tests, though I didn't see a panic.  Can
> > > you test with this patch?
> > > 
> > > ----
> > > 
> > > From: Josh Poimboeuf <jpoimboe@redhat.com>
> > > Subject: [PATCH] crypto/sha1-mb: make sha1_x8_avx2() conform to C function ABI
> > > 
> > > Megha Day reported a kernel panic in crypto code.  The problem is that
> > > sha1_x8_avx2() clobbers registers r12-r15 without saving and restoring
> > > them.
> > > 
> > > Before commit aec4d0e301f1 ("x86/asm/crypto: Simplify stack usage in
> > > sha-mb functions"), those registers were saved and restored by the
> > > callers of the function.  I removed them with that commit because I
> > > didn't realize sha1_x8_avx2() clobbered them.
> > > 
> > > Fix the potential undefined behavior associated with clobbering the
> > > registers and make the behavior less surprising by changing the
> > > registers to be callee saved/restored to conform with the C function
> > > call ABI.
> > > 
> > > Also, rdx (aka RSP_SAVE) doesn't need to be saved: I verified that none
> > > of the callers rely on it being saved, and it's not a callee-saved
> > > register in the C ABI.
> > > 
> > > Fixes: aec4d0e301f1 ("x86/asm/crypto: Simplify stack usage in sha-mb functions")
> > > Cc: stable@vger.kernel.org # 4.6
> > > Reported-by: Megha Dey <megha.dey@linux.intel.com>
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > ---
> > >  arch/x86/crypto/sha-mb/sha1_x8_avx2.S | 13 +++++++++++--
> > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/crypto/sha-mb/sha1_x8_avx2.S b/arch/x86/crypto/sha-mb/sha1_x8_avx2.S
> > > index 8e1b477..c9dae1c 100644
> > > --- a/arch/x86/crypto/sha-mb/sha1_x8_avx2.S
> > > +++ b/arch/x86/crypto/sha-mb/sha1_x8_avx2.S
> > > @@ -296,7 +296,11 @@ W14  = TMP_
> > >  #
> > >  ENTRY(sha1_x8_avx2)
> > >  
> > > -	push	RSP_SAVE
> > > +	# save callee-saved clobbered registers to comply with C function ABI
> > > +	push	%r12
> > > +	push	%r13
> > > +	push	%r14
> > > +	push	%r15
> > >  
> > >  	#save rsp
> > >  	mov	%rsp, RSP_SAVE
> > > @@ -446,7 +450,12 @@ lloop:
> > >  	## Postamble
> > >  
> > >  	mov     RSP_SAVE, %rsp
> > > -	pop	RSP_SAVE
> > > +
> > > +	# restore callee-saved clobbered registers
> > > +	pop	%r15
> > > +	pop	%r14
> > > +	pop	%r13
> > > +	pop	%r12
> > >  
> > >  	ret
> > >  ENDPROC(sha1_x8_avx2)
> > 
> > Hi Josh,
> > I don't see the panic and am able to boot. However, I am not able to see
> > the tests running. You said you were able to insert the tcrypt module
> > and test this right?
> 
> I didn't insert tcrypt manually, but I set the config flags you
> suggested, plus I added a few printks, and was at least able to verify
> that this code ran during boot without any crypto test errors or other
> warnings being reported.
> 
ok. I tried at my end too using some printk's and nothing seems to be
broken. Also, if you intend to use the same commit message, I spell my
name as Megha Dey and not Day :)
