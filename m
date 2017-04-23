From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: Allow ecb(cipher_null) in FIPS mode
Date: Sun, 23 Apr 2017 21:06:30 +0200
Message-ID: <2841324.7RLLSJtzS3@positron.chronox.de>
References: <20170421121820.GA14381@gondor.apana.org.au> <9105605.SAXsSHs1iB@tauon.chronox.de> <CACXcFm=HAew+fMAZXWL9WtT49GVdvUdVShnOOsDLEqUwU5cJng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>, linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59160 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755403AbdDWTGe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Apr 2017 15:06:34 -0400
In-Reply-To: <CACXcFm=HAew+fMAZXWL9WtT49GVdvUdVShnOOsDLEqUwU5cJng@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 22. April 2017, 09:54:08 CEST schrieb Sandy Harris:

Hi Sandy,

> In the FreeS/WAN project, back around the turn of the century,
> we refused to implement several things required by the RFCs
> because we thought they were insecure: null cipher, single
> DES & 768-bit DH Group 1.
> 
> At that time, not having DES did cause some problems in
> interoperating with other IPsec implementations, but I
> doubt it would today. Neither of the other dropped items
> caused any problems at all.
> 
> Today I'd say drop all of those plus the 1024-bit Group 2,
> and then look at whether others should go as well. As of
> 2001 or so, the 1536-bit Group 5 was very widely used,
> so dropping it might well be problematic, but I am not
> certain if it is either secure or widely used now.

This approach is fully appropriate and I strongly support that. However, the 
kernel crypto API has a need of a memcpy over SGLs, because the entire crypto 
API operates on SGLs. There are valid use cases. The one I am currently 
working on are AEAD ciphers where we want to copy the AAD from the src SGL to 
the dst SGL. Instead of walking through the SGLs in my code and invoke the 
memcpy, I simply use the null cipher.

What I would like to say is that there are valid use cases of the null cipher 
which do not impair security constraints. For those use cases, the null cipher 
should and must be allowed.

For all other use cases, including the "encryption operation" in IPSEC or dm-
crypt, it should never be used.

Ciao
Stephan
