From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH v2 0/3] ARM: NEON based fast(er) AES in CBC/CTR/XTS
 modes
Date: Fri, 4 Oct 2013 14:34:01 -0400 (EDT)
Message-ID: <alpine.LFD.2.03.1310041420520.3023@syhkavp.arg>
References: <1380837566-18242-1-git-send-email-ard.biesheuvel@linaro.org> <20131004174853.GY24303@mudshark.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"patches@linaro.org" <patches@linaro.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:56915 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3JDSeF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Oct 2013 14:34:05 -0400
Received: by mail-qc0-f171.google.com with SMTP id x19so3101669qcw.30
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2013 11:34:04 -0700 (PDT)
In-Reply-To: <20131004174853.GY24303@mudshark.cambridge.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 4 Oct 2013, Will Deacon wrote:

> Hi Ard,
> 
> On Thu, Oct 03, 2013 at 10:59:23PM +0100, Ard Biesheuvel wrote:
> > Note to reviewers:
> > Reviewing the file aesbs-core.S may be a bit overwhelming, so if there are any
> > questions or concerns, please refer the file bsaes-armv7.pl which can be found
> > at the link below. This is the original Perl script that gets called by
> > OpenSSL's build system during their build to generate the .S file on the fly.
> > [In the case of OpenSSL, this is used in some cases to target different
> > assemblers or ABIs]. This arrangement is not suitable (or required) for the
> > kernel, so I have taken the generated .S file instead.
> > 
> >     http://git.openssl.org/gitweb/?p=openssl.git;a=commit;h=6f6a6130
> > 
> > This series still depends on commit a62b01cd (crypto: create generic version of
> > ablk_helper) which I omitted this time but which can be found in the cryptodev
> > tree or in linux-next.
> 
> Why do you consider it unsuitable to ship the perl script with the kernel?
> Perl 5 is already documented as a build dependency in Documentation/Changes

Do you have an example of something that does require perl to build the 
kernel on ARM?  I was under the impression that people try to avoid it 
as much as possible in general.

I'm personally sitting on the fence between effectively adding a new 
kernel build dependencies or carrying the output of the perl script.  
But if the kernel build does already require perl in practice then this 
might tip the balance.


Nicolas
