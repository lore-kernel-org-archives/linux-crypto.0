From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: Crypto/nx842: Ignore invalid XER[S0] return error
Date: Sat, 12 Dec 2015 18:05:50 -0600
Message-ID: <20151213000550.GA9787@gate.crashing.org>
References: <1449891029.19568.5.camel@hbabu-laptop> <20151212084348.GA26552@gate.crashing.org> <566CA746.1090001@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, ddstreet@ieee.org,
	davem@davemloft.net, mpe@ellerman.id.au, pair@us.ibm.com,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:35414 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbbLMAGU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Dec 2015 19:06:20 -0500
Content-Disposition: inline
In-Reply-To: <566CA746.1090001@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 12, 2015 at 03:01:26PM -0800, Haren Myneni wrote:
> On 12/12/2015 12:43 AM, Segher Boessenkool wrote:
> > On Fri, Dec 11, 2015 at 07:30:29PM -0800, Haren Myneni wrote:
> >> NX842 coprocessor sets 3rd bit in CR register with XER[S0] which is
> >> nothing to do with NX request. On powerpc, XER[S0] will be set if
> >> overflow in FPU and stays until another floating point operation is
> >> executed. Since this bit can be set with other valuable return status,
> >> ignore this XER[S0] value.
> > 
> > XER[SO] is the *integer* summary overflow bit.  It is set by OE=1
> > instructions ("addo" and the like), and can only be cleared explicitly
> > (using "mtxer").
> 
> Thanks for the correct description. I was told XER[S0] is floating overflow from FPU.

You can use the Power ISA document to make sure for yourself.

> >> +	if (ret & ICSWX_XERS0)
> >> +		ret &= ~ICSWX_XERS0;
> > 
> > You can just always clear it, there is no need to check if it is set first.
> 
> Do you mean reset this before calling NX?

I mean write this as simply

+	ret &= ~ICSWX_XERS0;

(without any "if").

> I believe NX coprocessor should not set CR bit as XER[S0] nothing to do with NX request and it is no use.

Many instructions set the CR bit to XER[SO] -- store conditional, slbfee.,
and all "normal" dot insns and of course cmp[l][i].  Or, shorter: "everything"
does this.

> NX is copying this CR bit with XER. But reset XER[S0] has to be done before NX request.

Only if you care what the final value of bit 3 in the CR will be.  Even
in the unusual case where you want to look at all CR field bits at once
it is cheap to just mask out the bit (as you do).

> We can not do this in icswx since this instruction can be used by other coprocessors in future. But I am not comfortable clearing as we are not touching this XER in the driver or result of NX operation. So I am proposing this patch to fix this not proper NX behaviour - ignores CR bit. 

I really wouldn't call it "not proper", that makes it sound like there
is an implementation bug or design mistake.  Instead, you could say that
your switch statement looks at the values of bits 0, 1, and 2, so you
just mask those -- you do not care about the value of bit 3, so you mask
it out.

Something like

+	/* Mask out the bits we do not care about. */
+	ret &= ~ICSWX_XERS0;


Segher
