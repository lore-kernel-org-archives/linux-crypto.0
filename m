From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC 6/7] x86: Move kernel_fpu_using to asm/i387.h
Date: Wed, 17 Jun 2009 20:51:08 -0700
Message-ID: <4A39B9AC.30807@zytor.com>
References: <1244704236.5320.129.camel@yhuang-dev.sh.intel.com> <20090617164622.GB25357@elte.hu> <4A3922A4.1080300@zytor.com> <20090618014858.GA1368@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:38810 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbZFRDv2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2009 23:51:28 -0400
In-Reply-To: <20090618014858.GA1368@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> On Wed, Jun 17, 2009 at 10:06:44AM -0700, H. Peter Anvin wrote:
> 
>> Huang: if I recall correctly, these functions were originally designed
>> to deal with the fact that VIA processors generate spurious #TS faults
>> due to broken design of the Padlock instructions.  The AES and PCLMUL
>> instructions actually use SSE registers and so will require different
>> structure.
> 
> No irq_ts_save was the one designed for the VIA, the Intel stuff
> does save the FPU state.
> 

Ah, sorry, misremembered.  Great!  Will apply.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

