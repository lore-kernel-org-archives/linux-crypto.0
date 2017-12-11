From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AF_ALG - fix race accessing cipher request
Date: Mon, 11 Dec 2017 22:52:26 +1100
Message-ID: <20171211115226.GM12014@gondor.apana.org.au>
References: <001a1141f050d78763055f85c42e@google.com>
 <5543369.6UIL7PonCy@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: syzbot
        <bot+3cbaad7926415bb8cfce88469e5f66a2bbd0d0cd@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:44012 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752609AbdLKLxA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 06:53:00 -0500
Content-Disposition: inline
In-Reply-To: <5543369.6UIL7PonCy@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 08, 2017 at 11:50:37AM +0100, Stephan Müller wrote:
> Hi Herbert,
> 
> This patch would go on top of 7d2c3f54e6f646887d019faa45f35d6fe9fe82ce
> "crypto: af_alg - remove locking in async callback" found in Linus' tree
> which is not yet in the cryptodev-2.6 tree.
> 
> In addition, this patch is already on top of the other patches discussed
> on this list fixing similar issues. I.e. depending in which order you apply
> the patches, there may be a hunk. In case you want me to rebase the patch,
> please let me know.
> 
> ---8<---
> When invoking an asynchronous cipher operation, the invocation of the
> callback may be performed before the subsequent operations in the
> initial code path are invoked. The callback deletes the cipher request
> data structure which implies that after the invocation of the
> asynchronous cipher operation, this data structure must not be accessed
> any more.
> 
> The setting of the return code size with the request data structure must
> therefore be moved before the invocation of the asynchronous cipher
> operation.
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
