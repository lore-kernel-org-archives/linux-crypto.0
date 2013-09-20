From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 0/4] ARM: NEON based fast(er) AES in CBC/CTR/XTS modes
Date: Fri, 20 Sep 2013 15:12:10 -0400 (EDT)
Message-ID: <alpine.LFD.2.03.1309201501010.312@syhkavp.arg>
References: <1379702811-8025-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:38789 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3ITTMN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Sep 2013 15:12:13 -0400
Received: by mail-qc0-f176.google.com with SMTP id t7so527041qcv.7
        for <linux-crypto@vger.kernel.org>; Fri, 20 Sep 2013 12:12:12 -0700 (PDT)
In-Reply-To: <1379702811-8025-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 20 Sep 2013, Ard Biesheuvel wrote:

> Note to reviewers:
> Reviewing the file aesbs-core.S may be a bit overwhelming, so if there are any
> questions or concerns, please refer to the link below. This is the original Perl
> script that gets called by OpenSSL's build system during their build to generate
> the .S file on the fly. [In the case of OpenSSL, this is used in some cases to
> target different assemblers or ABIs]. This arrangement is not suitable (or 
> required) for the kernel, so I have taken the generated .S file instead.
> 
> http://git.openssl.org/gitweb/?p=openssl.git;f=crypto/aes/asm/bsaes-armv7.pl;a=blob

You should probably capture this reference in the code, or at least in 
the commit log for the corresponding patch.

> Note to integrators:
> While this implementation is significantly faster, especially in CTR mode, it is
> unclear whether the net impact on power efficiency is favorable or not, so
> please refrain from making any assumptions to that effect.

That definitively should be mentioned in the commit log for patch #4.


Nicolas
