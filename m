From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AF_ALG - race-free access of encryption flag
Date: Wed, 29 Nov 2017 18:10:49 +1100
Message-ID: <20171129071049.GA23023@gondor.apana.org.au>
References: <001a113f2cd2d62b59055efb7618@google.com>
 <1943686.EAKghbSqDq@positron.chronox.de>
 <20171128230240.GA17611@gondor.apana.org.au>
 <2865588.MNjhcg78tp@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>,
        syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40858 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751487AbdK2HLW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 02:11:22 -0500
Content-Disposition: inline
In-Reply-To: <2865588.MNjhcg78tp@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 29, 2017 at 07:48:53AM +0100, Stephan Mueller wrote:
> Am Mittwoch, 29. November 2017, 00:02:40 CET schrieb Herbert Xu:
>
> > This is wrong.  You can't fetch ctx->enc before you wait.  It has
> > to be done after the wait as otherwise ctx->enc may not even have
> > been initialised.
> 
> All ctx variables are initialized in aead_accept_parent_nokey. Thus, if no 
> sendmsg call is invoked by user space, at least a valid operation is 
> performed.

I didn't mean initialised literally, I meant the value the user
specified in sendmsg.  If the recvmsg call precedes sendmsg then
you can't possibly get the value that the user supplied.

> I am wondering about the wait call inside the while () in af_alg_get_rsgl: 
> this has been taken from algif_skcipher. It would seem that moving the wait 
> call to the beginning of the recvmsg call would be applicable to skcipher as 
> well. I.e. the wait call should be removed from af_alg_get_rsgl entirely and 
> placed at the beginning the recvmsg function in both, the aead and skcipher 
> code paths.

It sort of worked for skcipher because it didn't care if ctx->enc
or even ctx->iv changed midstream.  But even there I don't think
we need to wait a second time.  In fact waiting a second time could
result in a dead-lock if no sendmsg call came around.

So we should definitely wait only once for both aead and skcipher.

Back to the original problem of ctx->enc changing midstream.  I
suppose it could actually be valid, e.g., when one request ended
and you wish to sendmsg a second request while the first is yet
to be started by recvmsg.

So perhaps we can fix it by actually putting such request-specific
information into a list along with the data rather than storing
it in ctx directly as we do now.

But anyway this isn't suitable for stable where we should just fix
it by making it not crash.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
