Return-Path: <SRS0=HYoH=NT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:52017 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbeKIGPL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 01:15:11 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 14d1e7b0
        for <linux-crypto@vger.kernel.org>;
        Thu, 8 Nov 2018 20:33:21 +0000 (UTC)
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d7266c2c (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 8 Nov 2018 20:33:21 +0000 (UTC)
Received: by mail-ot1-f54.google.com with SMTP id g27so19428804oth.6
        for <linux-crypto@vger.kernel.org>; Thu, 08 Nov 2018 12:37:59 -0800 (PST)
MIME-Version: 1.0
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 8 Nov 2018 21:37:48 +0100
Message-ID: <CAHmME9r=Zm4QzoRRdA88R0R56e3EJb+Psm7YeX6y2+ZhEjwYQg@mail.gmail.com>
Subject: .S_shipped unnecessary?
To: Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ard, Eric, and others,

As promised, the next Zinc patchset will have less generated code! After a
bit of work with Andy and Samuel, I'll be bundling the perlasm.

One thing I'm wondering about, though, is the wisdom behind the current
.S_shipped pattern. Usually the _shipped is for big firmware blobs that are
hard (or impossible) to build independently. But in this case, the .S is
generated from the .pl significantly faster than gcc even compiles a basic
C file. And, since perl is needed to build the kernel anyway, it's not like
it will be impossible to find the right tools. Rather than clutter up commits
with the .pl _and_ the .S_shipped, what would you think if I just generated
the .S each time as an ordinary build artifact. AFAICT, this is fairly usual,
and it's hard to see downsides. Hence, why I'm writing this email: are there
any downsides to that?

Thanks,
Jason
