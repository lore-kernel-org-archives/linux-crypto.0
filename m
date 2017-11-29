From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AF_ALG - race-free access of encryption flag
Date: Wed, 29 Nov 2017 23:17:20 +1100
Message-ID: <20171129121720.GA24845@gondor.apana.org.au>
References: <001a113f2cd2d62b59055efb7618@google.com>
 <2865588.MNjhcg78tp@tauon.chronox.de>
 <20171129071049.GA23023@gondor.apana.org.au>
 <2034920.efhAd224kL@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Eric Biggers <ebiggers3@gmail.com>,
        syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40952 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753466AbdK2MRw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 07:17:52 -0500
Content-Disposition: inline
In-Reply-To: <2034920.efhAd224kL@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 29, 2017 at 12:05:13PM +0100, Stephan Müller wrote:
>
> Shouldn't we then create a patch for the pre-4.14 algif_skcipher code that 
> moves the wait out of the while loop to the beginning of the function in 
> recvmsg?

When I said dead-lock I just meant that the recvmsg will block
indefinitely.  It can still be interrupted from user-space.

As the behaviour is currently undefined anyway, I don't think we
need to backport this fix.  At least not until we maintain a list
of ctx->enc like we discussed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
