From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that
 the RNG is ready before using
Date: Tue, 6 Jun 2017 17:23:04 +0200
Message-ID: <CAHmME9rTpe4FM2+VSxZB48JDPCNTpSWzHx2DW1om7DW_1PvttQ@mail.gmail.com>
References: <20170606005108.5646-1-Jason@zx2c4.com> <20170606005108.5646-5-Jason@zx2c4.com>
 <20170606030004.4go6btmobrsmqiwz@thunk.org> <CAHmME9qZUEMDjQGNOBC7PrCTcanOxohVHcED+Xyg_3jR64Q7VQ@mail.gmail.com>
 <20170606044404.GA3469@zzz> <CAHmME9q0N3KgWU4XMDmzNjd0EF_HWROBquwXMYXxfssx_VoghA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
To: Eric Biggers <ebiggers3@gmail.com>,
        David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:36875 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751390AbdFFPXJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2017 11:23:09 -0400
In-Reply-To: <CAHmME9q0N3KgWU4XMDmzNjd0EF_HWROBquwXMYXxfssx_VoghA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey again Eric,

One thing led to another and I wound up just rewriting all the crypto
in big_keys.c. I'll include this for v4:

https://git.zx2c4.com/linux-dev/commit/?h=jd/rng-blocker&id=886ff283b9808aecb14aa8e397da8496a9635aed

Not only was the use of crypto/rng inappropriate, but the decision to
go with aes-ecb is shocking. Seeing that this author had no other
commits in the tree, and that all subsequent commits that mentioned
his name were cleaning up his mess, I just went ahead and removed both
the crypto/rng misusage and changed from aes-ecb to aes-gcm.

Anyway, I'll wait for some more reviews on v3, and then this can be
reviewed for v4.

Regards,
Jason
