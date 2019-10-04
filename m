Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B20C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F2DF20659
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 15:23:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k25burhP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389812AbfJDPX0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:23:26 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39492 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389591AbfJDPX0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 11:23:26 -0400
Received: by mail-wm1-f67.google.com with SMTP id v17so6295553wml.4
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 08:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BIaCsc6Kek0O9FJJ9A7Ql0Rkoav4bnNBmb+WvjFnAxM=;
        b=k25burhP69DiuRKoYPOaS3BEHutqnfgj01hdNSD1oy7+ljpWBdZDCehiScKJosiqF8
         f0tV1LJnBfsKRHtRqnVzk7AD+8CjVBEDPcVb7ihTa6Zo1kIfobMSfFTbrQ6jDu9zgI9o
         DBq0qEck8ghrapAe7VAlOvid3YLOxmai5HLdfvNnb1mMFAZ4jQIRomQJHhY0x4+A52pb
         g3XJciOvDe2lPcWMjLiLH7lwadOvktOEI/oGIXBzSn520QTUSHlBeMy3hH2XDf7dQRjm
         ddoB4eTThHFYDGSgIAZ4yYgWE+p1cPxlrNqySDx33eoHiAR6qPzfSIz6LDS+PhG1yHuB
         pBEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BIaCsc6Kek0O9FJJ9A7Ql0Rkoav4bnNBmb+WvjFnAxM=;
        b=hqRx4Xq9rl3A1IZnffuJdm/Yr7GB2EeWe7vVz431BklxevnxYwF5GJQ6k53W0myf0G
         m/VqE83m4LoRlpL+u4Nm8nZjnqVXeyUWYqYL6V5qYkAGArz8HAwbMq0FWiIvQsk9MlZo
         NktgG19rXXMnnyFgSHfEviq2rH/kSopZ9nNJnYfzh6RdQhkHzHt02IfwqEeqe+AIemH2
         7IvbmDDYGP9YIdboDeR1xeY3WKSFlPpFf7WbH40UpXVlOUHb7BDBBhIeKyt1DSn4/j5T
         FpeDNYSeIaf0jQbZTvEB4KD8kcHNPU7DwKDiD1Ugw7FZebbkZKI71DmWsp9hKpRJrPnx
         eUuQ==
X-Gm-Message-State: APjAAAXaHk+baVR9EhZy+eVcG3LtlXTx7lpbV4OFeVlMJ42pglZgOlly
        ijq0JEeZdInEJ2FptZcb2SBNQj05iR+5vXB+UjQxvw==
X-Google-Smtp-Source: APXvYqzwlrPVKZOcwWgHxMOi5jpMstTUnn6uOVjV/pHiKROE9mvedX68IYNEE5zxT4xc1ql+Bo5jdcV1t3qnBR7URf0=
X-Received: by 2002:a7b:cb55:: with SMTP id v21mr2215964wmj.53.1570202603633;
 Fri, 04 Oct 2019 08:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-6-ard.biesheuvel@linaro.org> <20191004134644.GE112631@zx2c4.com>
 <CAKv+Gu_X9DBgUiPqcyJ2hOQqi_FEBVpHOr9uG1ZAh-RWv6-z9Q@mail.gmail.com>
 <CAHmME9ojUTysb2kHKbSWaR+2Qat3qF1cNrVtphu3V+C+P_g8yQ@mail.gmail.com> <20191004151524.Horde.zXUzQP5eBQt7Ybx5I75Ig5X@www.vdorst.com>
In-Reply-To: <20191004151524.Horde.zXUzQP5eBQt7Ybx5I75Ig5X@www.vdorst.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 17:23:10 +0200
Message-ID: <CAKv+Gu-84O9wo3-w7bYxW41g3gjwGk5tBJX54TGN53MUPNpdvQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/20] crypto: mips/chacha - import accelerated 32r2
 code from Zinc
To:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 4 Oct 2019 at 17:15, Ren=C3=A9 van Dorst <opensource@vdorst.com> wr=
ote:
>
> Hi Jason,
>
> Quoting "Jason A. Donenfeld" <Jason@zx2c4.com>:
>
> > On Fri, Oct 4, 2019 at 4:44 PM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> >> The round count is passed via the fifth function parameter, so it is
> >> already on the stack. Reloading it for every block doesn't sound like
> >> a huge deal to me.
> >
> > Please benchmark it to indicate that, if it really isn't a big deal. I
> > recall finding that memory accesses on common mips32r2 commodity
> > router hardware was extremely inefficient. The whole thing is designed
> > to minimize memory accesses, which are the primary bottleneck on that
> > platform.
>
> I also think it isn't a big deal, but I shall benchmark it this weekend.
> If I am correct a memory write will first put in cache. So if you read
> it again and it is in cache it is very fast. 1 or 2 clockcycles.
> Also the value isn't used directly after it is read.
> So cpu don't have to stall on this read.
>

Thanks Ren=C3=A9.

Note that the round count is not being spilled. I [re]load it from the
stack as a function parameter.

So instead of

li $at, 20

I do

lw $at, 16($sp)


Thanks a lot for taking the time to double check this. I think it
would be nice to be able to expose xchacha12 like we do on other
architectures.

Note that for xchacha, I also added a hchacha_block() routine based on
your code (with the round count as the third argument) [0]. Please let
me know if you see anything wrong with that.


+.globl hchacha_block
+.ent hchacha_block
+hchacha_block:
+ .frame $sp, STACK_SIZE, $ra
+
+ addiu $sp, -STACK_SIZE
+
+ /* Save s0-s7 */
+ sw $s0, 0($sp)
+ sw $s1, 4($sp)
+ sw $s2, 8($sp)
+ sw $s3, 12($sp)
+ sw $s4, 16($sp)
+ sw $s5, 20($sp)
+ sw $s6, 24($sp)
+ sw $s7, 28($sp)
+
+ lw X0, 0(STATE)
+ lw X1, 4(STATE)
+ lw X2, 8(STATE)
+ lw X3, 12(STATE)
+ lw X4, 16(STATE)
+ lw X5, 20(STATE)
+ lw X6, 24(STATE)
+ lw X7, 28(STATE)
+ lw X8, 32(STATE)
+ lw X9, 36(STATE)
+ lw X10, 40(STATE)
+ lw X11, 44(STATE)
+ lw X12, 48(STATE)
+ lw X13, 52(STATE)
+ lw X14, 56(STATE)
+ lw X15, 60(STATE)
+
+.Loop_hchacha_xor_rounds:
+ addiu $a2, -2
+ AXR( 0, 1, 2, 3, 4, 5, 6, 7, 12,13,14,15, 16);
+ AXR( 8, 9,10,11, 12,13,14,15, 4, 5, 6, 7, 12);
+ AXR( 0, 1, 2, 3, 4, 5, 6, 7, 12,13,14,15, 8);
+ AXR( 8, 9,10,11, 12,13,14,15, 4, 5, 6, 7, 7);
+ AXR( 0, 1, 2, 3, 5, 6, 7, 4, 15,12,13,14, 16);
+ AXR(10,11, 8, 9, 15,12,13,14, 5, 6, 7, 4, 12);
+ AXR( 0, 1, 2, 3, 5, 6, 7, 4, 15,12,13,14, 8);
+ AXR(10,11, 8, 9, 15,12,13,14, 5, 6, 7, 4, 7);
+ bnez $a2, .Loop_hchacha_xor_rounds
+
+ sw X0, 0(OUT)
+ sw X1, 4(OUT)
+ sw X2, 8(OUT)
+ sw X3, 12(OUT)
+ sw X12, 16(OUT)
+ sw X13, 20(OUT)
+ sw X14, 24(OUT)
+ sw X15, 28(OUT)
+
+ /* Restore used registers */
+ lw $s0, 0($sp)
+ lw $s1, 4($sp)
+ lw $s2, 8($sp)
+ lw $s3, 12($sp)
+ lw $s4, 16($sp)
+ lw $s5, 20($sp)
+ lw $s6, 24($sp)
+ lw $s7, 28($sp)
+
+ addiu $sp, STACK_SIZE
+ jr $ra
+.end hchacha_block
+.set at


[0] https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/commit/?=
h=3Dwireguard-crypto-library-api-v3&id=3Dcc74a037f8152d52bd17feaf8d9142b617=
61484f
