Return-Path: <SRS0=TB/N=X7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A1CC4360C
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Oct 2019 19:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 559E12087E
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Oct 2019 19:12:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="FESceyk6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfJFTMb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Oct 2019 15:12:31 -0400
Received: from mx.0dd.nl ([5.2.79.48]:54026 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbfJFTMa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Oct 2019 15:12:30 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 455095FBCA;
        Sun,  6 Oct 2019 21:12:29 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="FESceyk6";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id EDD593AD77;
        Sun,  6 Oct 2019 21:12:28 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com EDD593AD77
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1570389149;
        bh=pYYvIlINVMFr28wexA57nXUsHHmBbxLOveUHLaVgk6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FESceyk6OONGviZ9JELPfVQ0D+8ypxw2m5AMDkQfXkKaqdofqU2PoqJ8Sah3p6G6L
         NS+g4clG+7noRHd2eE1QxqCEkd2KQzmxlKI8iYEZbYd83oVfZoTBI50ijCf54oKMKJ
         0SHaf5K0iopjnO3Oww6dJxHCxnBTrP4rAbV+i73jQIdt9vTodslblaACBDKzw4jIv+
         Qn8BqVrhrxTaTn+Tzci/ssxo1gKElqYTy+E83CzpWXs/8lTuX4EOYehCjmSTp4vwtK
         1W8a0gaRt2s5cT/kIyTu1JzlURVngldrSAzKfZ0qQZqvpAvFLjufAalzjBT8COgLmk
         gnw6vw+/VoQ4Q==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Sun, 06 Oct 2019 19:12:28 +0000
Date:   Sun, 06 Oct 2019 19:12:28 +0000
Message-ID: <20191006191228.Horde.E8aAava9O1UOhVnxdaZzfqw@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 05/20] crypto: mips/chacha - import accelerated 32r2
 code from Zinc
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-6-ard.biesheuvel@linaro.org>
 <20191004134644.GE112631@zx2c4.com>
 <CAKv+Gu_X9DBgUiPqcyJ2hOQqi_FEBVpHOr9uG1ZAh-RWv6-z9Q@mail.gmail.com>
 <CAHmME9ojUTysb2kHKbSWaR+2Qat3qF1cNrVtphu3V+C+P_g8yQ@mail.gmail.com>
 <20191004151524.Horde.zXUzQP5eBQt7Ybx5I75Ig5X@www.vdorst.com>
 <CAKv+Gu-84O9wo3-w7bYxW41g3gjwGk5tBJX54TGN53MUPNpdvQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu-84O9wo3-w7bYxW41g3gjwGk5tBJX54TGN53MUPNpdvQ@mail.gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Ard Biesheuvel <ard.biesheuvel@linaro.org>:

<snip>

Hi Ard,

> Thanks a lot for taking the time to double check this. I think it
> would be nice to be able to expose xchacha12 like we do on other
> architectures.
>
> Note that for xchacha, I also added a hchacha_block() routine based on
> your code (with the round count as the third argument) [0]. Please let
> me know if you see anything wrong with that.
>
>
> +.globl hchacha_block
> +.ent hchacha_block
> +hchacha_block:
> + .frame $sp, STACK_SIZE, $ra
> +
> + addiu $sp, -STACK_SIZE
> +
> + /* Save s0-s7 */
> + sw $s0, 0($sp)
> + sw $s1, 4($sp)
> + sw $s2, 8($sp)
> + sw $s3, 12($sp)
> + sw $s4, 16($sp)
> + sw $s5, 20($sp)
> + sw $s6, 24($sp)
> + sw $s7, 28($sp)

We only have to preserve the used s registers.
Currently X11 to X15 are using the registers s6 down to s2.

But by shuffling/redefine the needed registers, so that we use all the
non-preserve registers, I can reduce the used s registers to one.

Registers we don't use and don't have to preserve are a3, at and v0.
Also STATE(a0) can be reused because we only need that pointer while  
loading the
values from memory.

So:

#undef X12
#undef X13
#undef X14
#undef X15

#define X12    $a3
#define X13    $at
#define X14    $v0
#define X15    STATE

And save X11(s6) on the stack.

See the full code here [0].

For the rest the code looks good!

Greats,

René

[0]:  
https://github.com/vDorst/wireguard/commit/562a516ae3b282b32f57d3239369360bc926df60


> +
> + lw X0, 0(STATE)
> + lw X1, 4(STATE)
> + lw X2, 8(STATE)
> + lw X3, 12(STATE)
> + lw X4, 16(STATE)
> + lw X5, 20(STATE)
> + lw X6, 24(STATE)
> + lw X7, 28(STATE)
> + lw X8, 32(STATE)
> + lw X9, 36(STATE)
> + lw X10, 40(STATE)
> + lw X11, 44(STATE)
> + lw X12, 48(STATE)
> + lw X13, 52(STATE)
> + lw X14, 56(STATE)
> + lw X15, 60(STATE)
> +
> +.Loop_hchacha_xor_rounds:
> + addiu $a2, -2
> + AXR( 0, 1, 2, 3, 4, 5, 6, 7, 12,13,14,15, 16);
> + AXR( 8, 9,10,11, 12,13,14,15, 4, 5, 6, 7, 12);
> + AXR( 0, 1, 2, 3, 4, 5, 6, 7, 12,13,14,15, 8);
> + AXR( 8, 9,10,11, 12,13,14,15, 4, 5, 6, 7, 7);
> + AXR( 0, 1, 2, 3, 5, 6, 7, 4, 15,12,13,14, 16);
> + AXR(10,11, 8, 9, 15,12,13,14, 5, 6, 7, 4, 12);
> + AXR( 0, 1, 2, 3, 5, 6, 7, 4, 15,12,13,14, 8);
> + AXR(10,11, 8, 9, 15,12,13,14, 5, 6, 7, 4, 7);
> + bnez $a2, .Loop_hchacha_xor_rounds
> +
> + sw X0, 0(OUT)
> + sw X1, 4(OUT)
> + sw X2, 8(OUT)
> + sw X3, 12(OUT)
> + sw X12, 16(OUT)
> + sw X13, 20(OUT)
> + sw X14, 24(OUT)
> + sw X15, 28(OUT)
> +
> + /* Restore used registers */
> + lw $s0, 0($sp)
> + lw $s1, 4($sp)
> + lw $s2, 8($sp)
> + lw $s3, 12($sp)
> + lw $s4, 16($sp)
> + lw $s5, 20($sp)
> + lw $s6, 24($sp)
> + lw $s7, 28($sp)
> +
> + addiu $sp, STACK_SIZE
> + jr $ra
> +.end hchacha_block
> +.set at
>
>
> [0]  
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/commit/?h=wireguard-crypto-library-api-v3&id=cc74a037f8152d52bd17feaf8d9142b61761484f





