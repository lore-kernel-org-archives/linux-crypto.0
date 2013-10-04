From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 0/3] ARM: NEON based fast(er) AES in CBC/CTR/XTS modes
Date: Fri, 4 Oct 2013 18:48:53 +0100
Message-ID: <20131004174853.GY24303@mudshark.cambridge.arm.com>
References: <1380837566-18242-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"patches@linaro.org" <patches@linaro.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	"nico@linaro.org" <nico@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54131 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314Ab3JDRty (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Oct 2013 13:49:54 -0400
Content-Disposition: inline
In-Reply-To: <1380837566-18242-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ard,

On Thu, Oct 03, 2013 at 10:59:23PM +0100, Ard Biesheuvel wrote:
> Note to reviewers:
> Reviewing the file aesbs-core.S may be a bit overwhelming, so if there are any
> questions or concerns, please refer the file bsaes-armv7.pl which can be found
> at the link below. This is the original Perl script that gets called by
> OpenSSL's build system during their build to generate the .S file on the fly.
> [In the case of OpenSSL, this is used in some cases to target different
> assemblers or ABIs]. This arrangement is not suitable (or required) for the
> kernel, so I have taken the generated .S file instead.
> 
>     http://git.openssl.org/gitweb/?p=openssl.git;a=commit;h=6f6a6130
> 
> This series still depends on commit a62b01cd (crypto: create generic version of
> ablk_helper) which I omitted this time but which can be found in the cryptodev
> tree or in linux-next.

Why do you consider it unsuitable to ship the perl script with the kernel?
Perl 5 is already documented as a build dependency in Documentation/Changes
and I'd *much* rather the .S file was generated rather than shipped and
hacked. That amount of opaque assembly code for something like crypto feels really
dangerous from both a review and a maintenance perspective.

Will
