From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v5 1/2] crypto: skcipher AF_ALG - overhaul memory management
Date: Thu, 16 Mar 2017 11:18:33 +0100
Message-ID: <4808097.uXnqYIEybL@tauon.atsec.com>
References: <2523592.mde6d2a8Lg@positron.chronox.de> <1797510.JnIj36BbdJ@tauon.atsec.com> <20170316095248.GA11996@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58082 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751136AbdCPKUL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 06:20:11 -0400
In-Reply-To: <20170316095248.GA11996@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 16. März 2017, 10:52:48 CET schrieb Herbert Xu:

Hi Herbert,

> First of all you're only limiting the amount of memory occupied
> by the SG list which is not the same thing as the memory pinned
> down by the actual recvmsg.

I am fully aware of that. As this was present in the code, I thought I could 
reuse that approach.

Are you saying that you want to stop this approach? 
> 
> More importantly, with the current code, a very large recvmsg
> would still work by doing it piecemeal.

This piecemeal would be done in the sync case. In the current AIO code path, 
such piecemeal would not be achieved.

> With your patch, won't
> it fail because sock_kmalloc could fail to allocate memory for
> the whole thing?

I this case yes. To handle AIO and sync in a common code path (and thus make 
both behave identically), this would be the result.

If very large recvmsg requests are to be handled, the socket option could be 
increased or the caller would piecemeal that request.

Otherwise, if do a piecemeal handling like it is done now, I see the following 
drawbacks:

- no common sync/AIO code and no common behavior

- no common approach between skcipher and other implementations (algif_aead 
and the algif_akcipher that I have in the pipe which looks identically to the 
proposed patchset)

Ciao
Stephan
