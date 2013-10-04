From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 0/3] ARM: NEON based fast(er) AES in CBC/CTR/XTS modes
Date: Fri, 4 Oct 2013 20:04:50 +0200
Message-ID: <CAKv+Gu8RdiGw2+o-1ybGTx4fxaGnDQP7duhcFaLuxDphADjMaQ@mail.gmail.com>
References: <1380837566-18242-1-git-send-email-ard.biesheuvel@linaro.org>
	<20131004174853.GY24303@mudshark.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"patches@linaro.org" <patches@linaro.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	"nico@linaro.org" <nico@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:63322 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab3JDSEv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Oct 2013 14:04:51 -0400
Received: by mail-lb0-f171.google.com with SMTP id u14so3630430lbd.30
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2013 11:04:50 -0700 (PDT)
In-Reply-To: <20131004174853.GY24303@mudshark.cambridge.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4 October 2013 19:48, Will Deacon <will.deacon@arm.com> wrote:

> On Thu, Oct 03, 2013 at 10:59:23PM +0100, Ard Biesheuvel wrote:
>> Note to reviewers:
>> Reviewing the file aesbs-core.S may be a bit overwhelming, so if there are any
>> questions or concerns, please refer the file bsaes-armv7.pl which can be found
>> at the link below. This is the original Perl script that gets called by
>> OpenSSL's build system during their build to generate the .S file on the fly.
>> [In the case of OpenSSL, this is used in some cases to target different
>> assemblers or ABIs]. This arrangement is not suitable (or required) for the
>> kernel, so I have taken the generated .S file instead.
>>
>>     http://git.openssl.org/gitweb/?p=openssl.git;a=commit;h=6f6a6130
>>
>> This series still depends on commit a62b01cd (crypto: create generic version of
>> ablk_helper) which I omitted this time but which can be found in the cryptodev
>> tree or in linux-next.
>
> Why do you consider it unsuitable to ship the perl script with the kernel?
> Perl 5 is already documented as a build dependency in Documentation/Changes
> and I'd *much* rather the .S file was generated rather than shipped and
> hacked. That amount of opaque assembly code for something like crypto feels really
> dangerous from both a review and a maintenance perspective.
>

First of all, please note that the whole point of working so closely
with the OpenSSL maintainer on this is that the version I am
presenting here is the verbatim output of the Perl script that lives
in the OpenSSL tree. So just shipped, not shipped and hacked.

Personally, I would much prefer merging the .pl file as well, I just
thought (and I did poll some people informally) that this is not
something most people are happy about. If I am wrong about this, than
I am quite happy to respin so the .S is generated on the fly.

-- 
Ard.
