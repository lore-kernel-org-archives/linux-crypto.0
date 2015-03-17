From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] arm: crypto: Add NEON optimized SHA-256
Date: Tue, 17 Mar 2015 07:56:02 +0100
Message-ID: <CAKv+Gu8fmBYwfrMKRqhA5KhU1HNjMP1cLtpmgCmp78R4CUw3fg@mail.gmail.com>
References: <20150316154835.GA31336@google.com>
	<CAKv+Gu8+oQ13j61X6x70baJXOpEiM2L+vK=KgK1JG12sy5KMsg@mail.gmail.com>
	<20150316162304.GA35408@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andy Polyakov <appro@openssl.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Sami Tolvanen <samitolvanen@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33754 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbbCQG4D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Mar 2015 02:56:03 -0400
Received: by ignm3 with SMTP id m3so47480893ign.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2015 23:56:02 -0700 (PDT)
In-Reply-To: <20150316162304.GA35408@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 16 March 2015 at 17:23, Sami Tolvanen <samitolvanen@google.com> wrote:
> On Mon, Mar 16, 2015 at 05:08:03PM +0100, Ard Biesheuvel wrote:
>> Have you tested this code with the tcrypt.ko module?
>
> I have not, but I can look into it.
>
>> Did you talk to Andy about the license? I don't think this is
>> permissible for the kernel as-is.
>
> Unless I have misunderstood something, the license at the Cryptogams
> website includes an option to license the code under the GNU GPL.
>
> However, I can certainly contact Andy to clarify his intentions.
>
>> This is broken on thumb-2, use adr instead
>
>> You can also implement SHA-224 using the same core transform, it's
>> just some trivial glue code.
>
>> Could you please rebase this onto Herbert's cryptodev tree and move
>> this to arch/arm/crypto/Kconfig?
>
> Thanks for the comments, I will submit a second version once we have
> a clarification on the license.
>

I have tested your code with a Thumb2 kernel. With this patch folded,
it builds and passes the tcrypt.ko test for me

--- a/arch/arm/crypto/sha256-armv7-neon.S
+++ b/arch/arm/crypto/sha256-armv7-neon.S
@@ -10,7 +10,6 @@
 #include <linux/linkage.h>

 .text
-.code   32
 .fpu neon

 .type  K256,%object
@@ -44,15 +43,15 @@ ENTRY(sha256_transform_neon)
         *      %r1: data
         *      %r2: nblks
         */
-       sub     r3,pc,#8                @ sha256_transform_neon
        add     r2,r1,r2,lsl#6  @ len to point at the end of inp

        stmdb   sp!,{r4-r12,lr}

        mov     r12,sp
-       sub     sp,sp,#16*4+16          @ alloca
-       sub     r14,r3,#256+32  @ K256
-       bic     sp,sp,#15               @ align for 128-bit stores
+       sub     r14,sp,#16*4+16         @ alloca
+       bic     r14,r14,#15             @ align for 128-bit stores
+       mov     sp,r14
+       adr     r14,K256

        vld1.8          {q0},[r1]!
        vld1.8          {q1},[r1]!
