From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [ANNOUNCE] /dev/random - a new approach (code for 4.11-rc1)
Date: Fri, 17 Mar 2017 16:31:29 +0100
Message-ID: <CAHmME9oopUxc3fdRERdhHk=GYJuqAonhRBhmyUQE81fPdLn9Zw@mail.gmail.com>
References: <2785457.pDyvZpZC2q@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:60345 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751169AbdCQPci (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2017 11:32:38 -0400
In-Reply-To: <2785457.pDyvZpZC2q@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey Stephan,

Have you considered submitting this without so many options? For
example -- just unconditionally using ChaCha20 instead of the
configurable crypto API functions? And either removing the FIPS140
compliance code, and either unconditionally including it, or just
getting rid of it? And finally just making this a part of the kernel
directly, instead of adding this as a standalone optional component?

Jason
