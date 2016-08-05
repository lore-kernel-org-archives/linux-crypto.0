From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] crypto: crc32c-vpmsum - Convert to CPU feature based module autoloading
Date: Fri, 05 Aug 2016 16:51:51 +1000
Message-ID: <87y44biu7s.fsf@concordia.ellerman.id.au>
References: <1470292695-9829-1-git-send-email-anton@ozlabs.org> <87lh0dexp3.fsf@concordia.ellerman.id.au> <20160804202601.12aa879e@kryten>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Anton Blanchard <anton@ozlabs.org>, benh@kernel.crashing.org,
	paulus@samba.org, herbert@gondor.apana.org.au, davem@davemloft.net,
	alastair@d-silva.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:58445 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965170AbcHEGvx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Aug 2016 02:51:53 -0400
In-Reply-To: <20160804202601.12aa879e@kryten>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Anton Blanchard <anton@samba.org> writes:

> Hi Michael,
>
>> Is VEC_CRYPTO the right feature?
>> 
>> That's new power8 crypto stuff.
>
> The vpmsum* instructions are part of the same pipeline as the vcipher*
> instructions, introduced in POWER8.

OK.

>> I thought this only used VMX? (but I haven't looked closely)
>
> Yes, vcipher* and vpmsum* are VMX instructions.

Right. The confusion is that we have PPC_FEATURE_HAS_ALTIVEC, but that
doesn't mean we have *these* VMX instructions.

This is actually an arch/powerpc patch, so I'll merge it unless Herbert
objects.

cheers
