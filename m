From: Andrew Lutomirski <luto@mit.edu>
Subject: Re: [PATCH v2 2/2] crypto, x86: SSSE3 based SHA1 implementation for x86-64
Date: Thu, 11 Aug 2011 11:15:16 -0400
Message-ID: <CAObL_7GrFcqg3cBLQawUB0cnpDcHPBnRxedWsLkW_L48UNbx=A@mail.gmail.com>
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com>
 <1311529994-7924-3-git-send-email-minipli@googlemail.com> <20110804064436.GA16247@gondor.apana.org.au>
 <4E43EC49.1040803@mit.edu> <20110811150840.GA14503@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mathias Krause <minipli@googlemail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:57545 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1HKPPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 11:15:37 -0400
In-Reply-To: <20110811150840.GA14503@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 11, 2011 at 11:08 AM, Herbert Xu
<herbert@gondor.hengli.com.au> wrote:
> On Thu, Aug 11, 2011 at 10:50:49AM -0400, Andy Lutomirski wrote:
>>
>>> This is pretty similar to the situation with the Intel AES code.
>>> Over there they solved it by using the asynchronous interface and
>>> deferring the processing to a work queue.
>>
>> I have vague plans to clean up extended state handling and make
>> kernel_fpu_begin work efficiently from any context. =A0(i.e. the fir=
st
>> kernel_fpu_begin after a context switch could take up to ~60 ns on S=
andy
>> Bridge, but further calls to kernel_fpu_begin would be a single bran=
ch.)
>
> This is all well and good but you still need to deal with the
> case of !irq_fpu_usable.

I think I can even get rid of that.  Of course, until that happens,
code still needs to handle !irq_fpu_usable.

(Also, calling these things kernel_fpu_begin() is dangerous.  It's not
actually safe to use floating-point instructions after calling
kernel_fpu_begin.  Integer SIMD instructions are okay, though.  The
issue is that kernel_fpu_begin doesn't initialize MXCSR, and there are
MXCSR values that will cause any floating-point instruction to trap
regardless of its arguments.)

--Andy
