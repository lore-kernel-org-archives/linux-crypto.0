Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33264 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728462AbfAKGe0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 01:34:26 -0500
Date: Fri, 11 Jan 2019 14:34:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: algapi - reject NULL crypto_spawn::inst
Message-ID: <20190111063424.ll6k2jtbxig5eylb@gondor.apana.org.au>
References: <20190106204606.11412-1-ebiggers@kernel.org>
 <20190106204606.11412-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190106204606.11412-2-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 06, 2019 at 12:46:06PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> It took me a while to notice the bug where the adiantum template left
> crypto_spawn::inst == NULL, because this only caused problems in certain
> cases where algorithms are dynamically loaded/unloaded.
> 
> More improvements are needed, but for now make crypto_init_spawn()
> reject this case and WARN(), so this type of bug will be noticed
> immediately in the future.
> 
> Note: I checked all callers and the adiantum template was the only place
> that had this wrong.  So this WARN shouldn't trigger anymore.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/algapi.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
