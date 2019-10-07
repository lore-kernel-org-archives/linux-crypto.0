Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9C0C47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 09:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A312E2173B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 09:34:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="h+vDW4y2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfJGJeU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 05:34:20 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.83]:30032 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbfJGJeU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 05:34:20 -0400
X-Greylist: delayed 2088 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Oct 2019 05:34:17 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1570440856;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=S36cRnLQIU60DIJ6VvMVjgCE3ff633vnGb8UbjBvdAI=;
        b=h+vDW4y2iwWHxWOmdneDXUFr0ynClcZ4Jo4N8cMniTV/l36kOrHEQZfOENFMcUXHwN
        H7T8q4BuZH5BoAfNe4rLvVyNv0vTye7j8rzkmb+bU3UahGUbC0HAwRj+Gkrg0fvMsvli
        uwcmzYOJ5qK+9fCdd8F/s13MHbu1TKqIPw2Hxz4G3j5/uTJnZGSTKubUtFzKMPQlMH67
        5+QVdxq/k/JlvwuPxT8uTvozy4IEMJ5TFPalaOFvQ8IU7j5ABeSpAgH6g2Gj8/1SW75V
        IxiuU59rH+FWjBbt3Ue19+G5pdEymZ4RYAL8spKZWF3uG/uNycXY4nIgmLJNCueclLLy
        Sjuw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbI/SfP6I9"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.28.0 DYNA|AUTH)
        with ESMTPSA id I003a5v979Y9yqw
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 7 Oct 2019 11:34:09 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH 5.4 regression fix] x86/boot: Provide memzero_explicit
Date:   Mon, 07 Oct 2019 11:34:09 +0200
Message-ID: <12200313.ic8YZTgDOU@tauon.chronox.de>
In-Reply-To: <284b70dd-5575-fee4-109f-aa99fb73a434@redhat.com>
References: <20191007085501.23202-1-hdegoede@redhat.com> <65461301.CAtk0GNLiE@tauon.chronox.de> <284b70dd-5575-fee4-109f-aa99fb73a434@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1856703.9gYyaxCXab"
Content-Transfer-Encoding: 7Bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart1856703.9gYyaxCXab
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Montag, 7. Oktober 2019, 11:06:04 CEST schrieb Hans de Goede:

Hi Hans,

> Hi Stephan,
> 
> On 07-10-2019 10:59, Stephan Mueller wrote:
> > Am Montag, 7. Oktober 2019, 10:55:01 CEST schrieb Hans de Goede:
> > 
> > Hi Hans,
> > 
> >> The purgatory code now uses the shared lib/crypto/sha256.c sha256
> >> implementation. This needs memzero_explicit, implement this.
> >> 
> >> Reported-by: Arvind Sankar <nivedita@alum.mit.edu>
> >> Fixes: 906a4bb97f5d ("crypto: sha256 - Use get/put_unaligned_be32 to get
> >> input, memzero_explicit") Signed-off-by: Hans de Goede
> >> <hdegoede@redhat.com>
> >> ---
> >> 
> >>   arch/x86/boot/compressed/string.c | 5 +++++
> >>   1 file changed, 5 insertions(+)
> >> 
> >> diff --git a/arch/x86/boot/compressed/string.c
> >> b/arch/x86/boot/compressed/string.c index 81fc1eaa3229..511332e279fe
> >> 100644
> >> --- a/arch/x86/boot/compressed/string.c
> >> +++ b/arch/x86/boot/compressed/string.c
> >> @@ -50,6 +50,11 @@ void *memset(void *s, int c, size_t n)
> >> 
> >>   	return s;
> >>   
> >>   }
> >> 
> >> +void memzero_explicit(void *s, size_t count)
> >> +{
> >> +	memset(s, 0, count);
> > 
> > May I ask how it is guaranteed that this memset is not optimized out by
> > the
> > compiler, e.g. for stack variables?
> 
> The function and the caller live in different compile units, so unless
> LTO is used this cannot happen.

Agreed in this case.

I would just be worried that this memzero_explicit implementation is assumed 
to be protected against optimization when used elsewhere since other 
implementations of memzero_explicit are provided with the goal to be protected 
against optimizations.
> 
> Also note that the previous purgatory private (vs shared) sha256
> implementation had:
> 
>          /* Zeroize sensitive information. */
>          memset(sctx, 0, sizeof(*sctx));
> 
> In the place where the new shared 256 code uses memzero_explicit() and the
> new shared sha256 code is the only user of the
> arch/x86/boot/compressed/string.c memzero_explicit() implementation.
> 
> With that all said I'm open to suggestions for improving this.

What speaks against the common memzero_explicit implementation? If you cannot 
use it, what about adding a barrier in the memzero_explicit implementation? Or 
what about adding some compiler magic as attached to this email?


> 
> Regards,
> 
> Hans



Ciao
Stephan
--nextPart1856703.9gYyaxCXab
Content-Disposition: attachment; filename="memset_secure.c"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-csrc; charset="UTF-8"; name="memset_secure.c"

/*
 * Copyright (C) 2015, Stephan Mueller <smueller@chronox.de>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, and the entire permission notice in its entirety,
 *    including the disclaimer of warranties.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote
 *    products derived from this software without specific prior
 *    written permission.
 *
 * ALTERNATIVELY, this product may be distributed under the terms of
 * the GNU General Public License, in which case the provisions of the GPL2
 * are required INSTEAD OF the above restrictions.  (This clause is
 * necessary due to a potential bad interaction between the GPL and
 * the restrictions contained in a BSD-style copyright.)
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
 * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */

#include <string.h>

/*
 * Tested following code:
 *
 * (1) __asm__ __volatile__("" : "=r" (s) : "0" (s));
 * (2) __asm__ __volatile__("": : :"memory");
 * (3) __asm__ __volatile__("" : "=r" (s) : "0" (s) : "memory");
 * (4) __asm__ __volatile__("" : : "r" (s) : "memory");
 *
 * Requred result:
 *
 * gcc -O3: objdump -d shows the following:
 *
 * 0000000000400440 <main>:
 * ...
 *   400469:       48 c7 04 24 00 00 00    movq   $0x0,(%rsp)
 *   400470:       00
 *   400471:       48 c7 44 24 08 00 00    movq   $0x0,0x8(%rsp)
 *   400478:       00 00
 *   40047a:       c7 44 24 10 00 00 00    movl   $0x0,0x10(%rsp)
 *   400481:       00
 *
 * clang -O3: objdump -d shows the following:
 *
 * 0000000000400590 <main>:
 * ...
 *   4005c3:       c7 44 24 10 00 00 00    movl   $0x0,0x10(%rsp)
 *   4005ca:       00
 *
 *
 * Test results:
 *
 * The following table marks an X when the aforementioned movq/movl code is
 * present (or an invocation of memset@plt) in the object code
 * (i.e. the code we want). Contrary, the table marks - where the code is not
 * present (i.e. the code we do not want):
 *
 *          | BARRIER  | (1) | (2) | (3) | (4)
 * ---------+----------+     |     |     |
 * Compiler |          |     |     |     |
 * =========+==========+=======================
 *                     |     |     |     |
 * gcc -O0             |  X  |  X  |  X  |  X
 *                     |     |     |     |
 * gcc -O2             |  -  |  X  |  X  |  X
 *                     |     |     |     |
 * gcc -O3             |  -  |  X  |  X  |  X
 *                     |     |     |     |
 * clang -00           |  X  |  X  |  X  |  X
 *                     |     |     |     |
 * clang -02           |  X  |  -  |  X  |  X
 *                     |     |     |     |
 * clang -03           |  -  |  -  |  X  |  X
 */

static inline void memset_secure(void *s, int c, size_t n)
{
	memset(s, c, n);
	__asm__ __volatile__("" : : "r" (s) : "memory");
}

#if 0
#include <stdio.h>

int main(int argc, char *argv[])
{
	char buf[20];

	snprintf(buf, sizeof(buf) - 1, "test");
	printf("%s\n", buf);

	memset_secure(buf, 0, sizeof(buf));
	return 0;
}
#endif

--nextPart1856703.9gYyaxCXab--



