From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: may_use_simd on aarch64, chacha20
Date: Sun, 21 May 2017 19:02:41 +0200
Message-ID: <CAHmME9qH=Wu-=9YUmxi7NPrczHu1UrB7phG0y68ipB+ProQ2TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:35377 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751474AbdEURCo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 May 2017 13:02:44 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3ac164af
        for <linux-crypto@vger.kernel.org>;
        Sun, 21 May 2017 17:02:13 +0000 (UTC)
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3ebdc443 (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128:NO)
        for <linux-crypto@vger.kernel.org>;
        Sun, 21 May 2017 17:02:12 +0000 (UTC)
Received: by mail-oi0-f44.google.com with SMTP id h4so137869049oib.3
        for <linux-crypto@vger.kernel.org>; Sun, 21 May 2017 10:02:42 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi folks,

I noticed that the ARM implementation [1] of chacha20 makes a check to
may_use_simd(), but the ARM64 implementation [2] does not. Question 1:
is this a bug, in which case I'll submit a patch shortly, or is this
intentional? In case of the latter, could somebody explain the
reasoning? On a similar note, the only ARM64 glue code that uses
may_use_simd() is sha256; everything else does not. Shall I submit a
substantial patch series to fix this up everywhere?

Secondly, I noticed that may_use_simd() is essentially aliased to
!in_interrupt(), since it uses the asm-generic variety. Question 2:
Isn't this overkill? Couldn't we make an arm/arm64 variant of this
that only checks in_irq()?

Lastly, APIs like pcrypts and padata execute with bottom halves
disabled, even though their actual execution environment is process
context, via a workqueue. Thus, here, in_interrupt() will always be
true, even though this is likely a place where we want to use simd.
Question 3: is there something better that could be done?

Thanks,
Jason

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm/crypto/chacha20-neon-glue.c#n67
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/crypto/chacha20-neon-glue.c#n66
