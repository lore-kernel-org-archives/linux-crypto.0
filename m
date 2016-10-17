From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH resend 4.9] hw_random: Don't use a stack buffer in add_early_randomness()
Date: Mon, 17 Oct 2016 20:36:16 +0200
Message-ID: <1709183.xhj4cRUFK9@tauon.atsec.com>
References: <4169224b6858d1cf149f1a73f8a03603fa19076d.1476638125.git.luto@kernel.org> <2711337.nAU4qxUyQs@tauon.atsec.com> <CALCETrVYuo1yNWyRQBRt3HwM4EJ7c5FAMZdEgnzKCHqMRCryXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jens Axboe <axboe@fb.com>, Matt Mullins <mmullins@mmlx.us>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53614 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754447AbcJQSgW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Oct 2016 14:36:22 -0400
In-Reply-To: <CALCETrVYuo1yNWyRQBRt3HwM4EJ7c5FAMZdEgnzKCHqMRCryXQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 17. Oktober 2016, 10:30:13 CEST schrieb Andy Lutomirski:

Hi Andy,
> 
> Sure, but shouldn't that be a separate patch covering the whole hw_crypto
> core?

I think that you are right -- there are many more cases where a memset(0) is 
warranted.

Do you want to make this change or should I send a patch?

Ciao
Stephan
