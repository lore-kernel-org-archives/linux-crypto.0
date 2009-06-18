From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC 6/7] x86: Move kernel_fpu_using to asm/i387.h
Date: Wed, 17 Jun 2009 20:52:16 -0700
Message-ID: <4A39B9F0.8020200@zytor.com>
References: <1244704236.5320.129.camel@yhuang-dev.sh.intel.com>	 <20090617164622.GB25357@elte.hu>  <4A3922A4.1080300@zytor.com> <1245290268.11965.190.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Ingo Molnar <mingo@elte.hu>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@linutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:38818 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZFRDwc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2009 23:52:32 -0400
In-Reply-To: <1245290268.11965.190.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Huang Ying wrote:
> 
> After some thinking, I think something as follow may be more
> appropriate:
> 
> /* This may be useful for someone else */
> static inline bool fpu_using(void)
> {
> 	return !(read_cr0() & X86_CR0_TS);
> }
> 
> static inline bool irq_fpu_using(void)
> {
> 	return in_interrupt() && fpu_using();
> }
> 

Yes, looks good.  I'll pull in the patch as soon as I get it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

