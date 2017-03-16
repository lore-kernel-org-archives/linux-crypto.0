From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v5 1/2] crypto: skcipher AF_ALG - overhaul memory management
Date: Thu, 16 Mar 2017 13:20:10 +0100
Message-ID: <74486084.680b3YGfiO@tauon.atsec.com>
References: <2523592.mde6d2a8Lg@positron.chronox.de> <20170316095248.GA11996@gondor.apana.org.au> <4808097.uXnqYIEybL@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58090 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752010AbdCPM3s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 08:29:48 -0400
In-Reply-To: <4808097.uXnqYIEybL@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 16. März 2017, 11:18:33 CET schrieb Stephan Müller:

Hi Stephan,

> Am Donnerstag, 16. März 2017, 10:52:48 CET schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > First of all you're only limiting the amount of memory occupied
> > by the SG list which is not the same thing as the memory pinned
> > down by the actual recvmsg.
> 
> I am fully aware of that. As this was present in the code, I thought I could
> reuse that approach.
> 
> Are you saying that you want to stop this approach?

I would like to bring another point to the table for this discussion relating 
to the maximum amount of memory to be used as well as for the size of the RX-
SGL: allow us please to consider skcipher_sendmsg (sendpage works conceptually 
similar, so it should be covered with this discussion as well).

skcipher_alloc_sgl used in the sendmsg code path is conceptually identical to 
the RX-SGL allocation that I propose here: it allocates a new SGL with 
MAX_SGL_ENTS entries as long as the caller sends data. It limits the amount of 
memory to be allocated based on the maximum size of the SG management data and 
not the actual plaintext/ciphertext data sent by user space. I again was 
therefore under the impression that my suggested approach in the recvmsg code 
path regarding allocation of memory would be allowed.

Regarding the amount of data processed with the RX-SGL, I would like to 
consider the size of the TX-SGL. In the skcipher case, the RX-SGL (or the 
anticipated RX data to be processed) does not need to be larger than the TX-
SGL. Hence the currently existing while() loop of the upstream code that we 
discuss here will only be executed as often to fulfill the available TX-SGL 
data size. Given that both are limited on the sock_kmalloc memory limitation, 
I would imply that using a conceptually identical allocation approach for the 
TX SGL and RX SGL would be a sufficient replacement for the while-loop without 
being visible to user space (i.e. without causing a limit that was not there 
before).

Ciao
Stephan
