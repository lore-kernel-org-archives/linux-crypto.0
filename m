From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 0/3] ARM: NEON based fast(er) AES in CBC/CTR/XTS
	modes
Date: Fri, 4 Oct 2013 19:40:05 +0100
Message-ID: <20131004184005.GR12758@n2100.arm.linux.org.uk>
References: <1380837566-18242-1-git-send-email-ard.biesheuvel@linaro.org> <20131004174853.GY24303@mudshark.cambridge.arm.com> <alpine.LFD.2.03.1310041420520.3023@syhkavp.arg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Will Deacon <will.deacon@arm.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"patches@linaro.org" <patches@linaro.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40502 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3JDSpo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Oct 2013 14:45:44 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1310041420520.3023@syhkavp.arg>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 04, 2013 at 02:34:01PM -0400, Nicolas Pitre wrote:
> Do you have an example of something that does require perl to build the 
> kernel on ARM?  I was under the impression that people try to avoid it 
> as much as possible in general.
> 
> I'm personally sitting on the fence between effectively adding a new 
> kernel build dependencies or carrying the output of the perl script.  
> But if the kernel build does already require perl in practice then this 
> might tip the balance.

That is really not a concern with the modern kbuild.  It has supported
having shipped versions of generated files included in the source tree
for years.  So, we can have the perl version included (the preferred
form for editing) while avoiding the issue of requiring everyone to
have perl.

In other words, if you want to build a kernel, you don't need perl for
this.  If you want to edit the "preferred" form, then you do need perl
so that the "preferred" form can be turned into assembly to update the
shipped version.
