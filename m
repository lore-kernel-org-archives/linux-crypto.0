From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AF_ALG - wait for data at beginning of recvmsg
Date: Mon, 11 Dec 2017 22:45:24 +1100
Message-ID: <20171211114524.GE12014@gondor.apana.org.au>
References: <001a113f2cd2d62b59055efb7618@google.com>
 <2780580.3j7i2QamZF@tauon.chronox.de>
 <20171129104230.GA24369@gondor.apana.org.au>
 <5089033.JsYCqWMXId@positron.chronox.de>
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
Received: from [128.1.224.119] ([128.1.224.119]:43924 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751347AbdLKLqA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 06:46:00 -0500
Content-Disposition: inline
In-Reply-To: <5089033.JsYCqWMXId@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 29, 2017 at 12:02:23PM +0100, Stephan Müller wrote:
> The wait for data is a non-atomic operation that can sleep and therefore
> potentially release the socket lock. The release of the socket lock
> allows another thread to modify the context data structure. The waiting
> operation for new data therefore must be called at the beginning of
> recvmsg. This prevents a race condition where checks of the members of
> the context data structure are performed by recvmsg while there is a
> potential for modification of these values.
> 
> Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
> Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: <stable@vger.kernel.org> # v4.14+
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
