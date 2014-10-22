From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] arm64/crypto: use crypto instructions for generating AES
 key schedule
Date: Wed, 22 Oct 2014 18:31:32 +0200
Message-ID: <CAKv+Gu-C73c5y71338jn2mXsS4t7A7SQZVwuYCGOFpZv=uQJpQ@mail.gmail.com>
References: <1413962132-19882-1-git-send-email-ard.biesheuvel@linaro.org>
	<20141022162548.GH15370@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	Will Deacon <Will.Deacon@arm.com>,
	"jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>,
	Andrew Wafaa <Andrew.Wafaa@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:43879 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbaJVQbg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Oct 2014 12:31:36 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so3153646lbi.23
        for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2014 09:31:33 -0700 (PDT)
In-Reply-To: <20141022162548.GH15370@e104818-lin.cambridge.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 22 October 2014 18:25, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Wed, Oct 22, 2014 at 08:15:32AM +0100, Ard Biesheuvel wrote:
>> This patch implements the AES key schedule generation using ARMv8
>> Crypto Instructions. It replaces the table based C implementation
>> in aes_generic.ko, which means we can drop the dependency on that
>> module.
>
> I don't really understand the AES stuff but there's something else I
> noticed: if you build a kernel with the crypto stuff and run it on an
> implementation that does not have the crypto extensions, there does not
> seem to be any check for not using these algorithms (or falling back to
> the generic implementation). Does the kernel end up with undef faults?
>

No, that is handled by

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=67bad2fdb754dbef14596c0b5d28b3a12c8dfe84
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=3be1a5c4f75989cf457f13f38ff0913dff6d4996

and the modules use module_cpu_feature_match(), so they are only
installed if the corresponding hwcap bit is set.

-- 
Ard.
