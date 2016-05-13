From: Ingo Molnar <mingo@kernel.org>
Subject: Re: SHA1-MB algorithm broken on latest kernel
Date: Fri, 13 May 2016 07:51:03 +0200
Message-ID: <20160513055103.GB24504@gmail.com>
References: <1463095866.2594.8.camel@megha-Z97X-UD7-TH>
 <20160513031020.GA12467@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Megha Dey <megha.dey@linux.intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Josh Poimboeuf <jpoimboe@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35495 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbcEMFvJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 May 2016 01:51:09 -0400
Content-Disposition: inline
In-Reply-To: <20160513031020.GA12467@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Thu, May 12, 2016 at 04:31:06PM -0700, Megha Dey wrote:
> > Hi,
> >  
> > When booting latest kernel with the CONFIG_CRYPTO_SHA1_MB enabled, I
> > observe a panic.
> >  
> > After having a quick look, on reverting the following patches, I am able
> > to complete the booting process.
> > aec4d0e301f17bb143341c82cc44685b8af0b945
> > 8691ccd764f9ecc69a6812dfe76214c86ac9ba06
> > 68874ac3304ade7ed5ebb12af00d6b9bbbca0a16
> >  
> > Of the 3 patches, aec4d0e301f17bb143341c82cc44685b8af0b945 seems wrong.
> > The r10 to r15 registers are used in sha1_x8_avx2.S, which is called
> > from sha1_mb_mgr_flush_avx2.S.
> >
> > I do not think the functionality of the SHA1-MB crypto algorithm has
> > been tested after applying these changes. (I am not sure if any of the
> > other crypto algorithms have been affected by these changes).
> 
> Josh, Ingo:
> 
> Any ideas on this? Should we revert?

Yeah, I think so - although another option would be to standardize sha1_x8_avx2() 
- the problem is that it is a function that clobbers registers without 
saving/restoring them, breaking the C function ABI. I realize it's written in 
assembly, but unless there are strong performance reasons to deviate from the 
regular calling convention it might make sense to fix that.

Do any warnings get generated after the revert, if you enable 
CONFIG_STACK_VALIDATION=y?

Thanks,

	Ingo
