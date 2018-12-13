Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:50546 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbeLMKez (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 05:34:55 -0500
Date: Thu, 13 Dec 2018 18:34:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        LABBE Corentin <clabbe@baylibre.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] crypto: user - support incremental algorithm dumps
Message-ID: <20181213103450.w3csc4uomafnqa64@gondor.apana.org.au>
References: <20181206235541.143730-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181206235541.143730-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 06, 2018 at 03:55:41PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> CRYPTO_MSG_GETALG in NLM_F_DUMP mode sometimes doesn't return all
> registered crypto algorithms, because it doesn't support incremental
> dumps.  crypto_dump_report() only permits itself to be called once, yet
> the netlink subsystem allocates at most ~64 KiB for the skb being dumped
> to.  Thus only the first recvmsg() returns data, and it may only include
> a subset of the crypto algorithms even if the user buffer passed to
> recvmsg() is large enough to hold all of them.
> 
> Fix this by using one of the arguments in the netlink_callback structure
> to keep track of the current position in the algorithm list.  Then
> userspace can do multiple recvmsg() on the socket after sending the dump
> request.  This is the way netlink dumps work elsewhere in the kernel;
> it's unclear why this was different (probably just an oversight).
> 
> Also fix an integer overflow when calculating the dump buffer size hint.
> 
> Fixes: a38f7907b926 ("crypto: Add userspace configuration API")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/crypto_user_base.c | 37 ++++++++++++++++++++-----------------
>  1 file changed, 20 insertions(+), 17 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
