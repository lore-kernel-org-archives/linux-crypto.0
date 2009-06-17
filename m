From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC 6/7] x86: Move kernel_fpu_using to asm/i387.h
Date: Wed, 17 Jun 2009 10:06:44 -0700
Message-ID: <4A3922A4.1080300@zytor.com>
References: <1244704236.5320.129.camel@yhuang-dev.sh.intel.com> <20090617164622.GB25357@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Huang Ying <ying.huang@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:40061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141AbZFQR1D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2009 13:27:03 -0400
In-Reply-To: <20090617164622.GB25357@elte.hu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ingo Molnar wrote:
>>  
>> +static inline int kernel_fpu_using(void)
>> +{
>> +	if (in_interrupt() && !(read_cr0() & X86_CR0_TS))
>> +		return 1;
>> +	return 0;
>> +}
>> +
> 
> Looks sane to me. Herbert, do you ack it?
> 

Although I have to say, the structure of:

if (boolean test)
	return 1;
return 0;

... truly was hit with the ugly stick.  It really should be:

static inline bool kernel_fpu_using(void)
{
	return in_interrupt() && !(read_cr0() && C86_CR0_TS);
}

Huang: if I recall correctly, these functions were originally designed
to deal with the fact that VIA processors generate spurious #TS faults
due to broken design of the Padlock instructions.  The AES and PCLMUL
instructions actually use SSE registers and so will require different
structure.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

