From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: xts,lrw - fix out-of-bounds write after kmalloc
 failure
Date: Fri, 24 Mar 2017 22:15:36 +0800
Message-ID: <20170324141536.GK14780@gondor.apana.org.au>
References: <CACT4Y+ZnQq9x7gXTpaRxnMSh_2Uk461J9CWnoq3i5KQBY-nLGw@mail.gmail.com>
 <20170323203946.11242-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:42750 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965702AbdCXOQH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:16:07 -0400
Content-Disposition: inline
In-Reply-To: <20170323203946.11242-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 23, 2017 at 01:39:46PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> In the generic XTS and LRW algorithms, for input data > 128 bytes, a
> temporary buffer is allocated to hold the values to be XOR'ed with the
> data before and after encryption or decryption.  If the allocation
> fails, the fixed-size buffer embedded in the request buffer is meant to
> be used as a fallback --- resulting in more calls to the ECB algorithm,
> but still producing the correct result.  However, we weren't correctly
> limiting subreq->cryptlen in this case, resulting in pre_crypt()
> overrunning the embedded buffer.  Fix this by setting subreq->cryptlen
> correctly.
> 
> Fixes: f1c131b45410 ("crypto: xts - Convert to skcipher")
> Fixes: 700cb3f5fe75 ("crypto: lrw - Convert to skcipher")
> Cc: stable@vger.kernel.org # v4.10+
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
