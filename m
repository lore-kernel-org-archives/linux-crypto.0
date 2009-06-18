From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC 6/7] x86: Move kernel_fpu_using to asm/i387.h
Date: Thu, 18 Jun 2009 09:57:48 +0800
Message-ID: <1245290268.11965.190.camel@yhuang-dev.sh.intel.com>
References: <1244704236.5320.129.camel@yhuang-dev.sh.intel.com>
	 <20090617164622.GB25357@elte.hu>  <4A3922A4.1080300@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Ingo Molnar <mingo@elte.hu>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@linutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:42947 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbZFRB5s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2009 21:57:48 -0400
In-Reply-To: <4A3922A4.1080300@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2009-06-18 at 01:06 +0800, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> >>  
> >> +static inline int kernel_fpu_using(void)
> >> +{
> >> +	if (in_interrupt() && !(read_cr0() & X86_CR0_TS))
> >> +		return 1;
> >> +	return 0;
> >> +}
> >> +
> > 
> > Looks sane to me. Herbert, do you ack it?
> > 
> 
> Although I have to say, the structure of:
> 
> if (boolean test)
> 	return 1;
> return 0;
> 
> ... truly was hit with the ugly stick.  It really should be:
> 
> static inline bool kernel_fpu_using(void)
> {
> 	return in_interrupt() && !(read_cr0() && C86_CR0_TS);
> }

Yes. This is better. I will change this.

> Huang: if I recall correctly, these functions were originally designed
> to deal with the fact that VIA processors generate spurious #TS faults
> due to broken design of the Padlock instructions.  The AES and PCLMUL
> instructions actually use SSE registers and so will require different
> structure.

They are a little different. VIA want to make sure that they can deal
with spurious #TS faults, while AES and PCLMUL need to check whether
MMX/SSE registers are available.

After some thinking, I think something as follow may be more
appropriate:

/* This may be useful for someone else */
static inline bool fpu_using(void)
{
	return !(read_cr0() & X86_CR0_TS);
}

static inline bool irq_fpu_using(void)
{
	return in_interrupt() && fpu_using();
}

Best Regards,
Huang Ying


