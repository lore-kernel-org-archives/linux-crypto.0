From: Dominik Paulus <dominik@d-paulus.de>
Subject: Re: crypto: GCM API usage
Date: Mon, 16 Sep 2013 20:34:11 +0200
Message-ID: <20130916183411.GC3380@d-paulus.de>
References: <65abe254e199230984fd6a15dec39a76.squirrel@faumail.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tobias.polzer@fau.de, linux-kernel@i4.cs.fau.de
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from d-paulus.de ([37.221.197.252]:60690 "EHLO d-paulus.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab3IPSoC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Sep 2013 14:44:02 -0400
Content-Disposition: inline
In-Reply-To: <65abe254e199230984fd6a15dec39a76.squirrel@faumail.uni-erlangen.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Mon, Sep 16, 2013 at 12:58:40PM +0200, dominik.d.paulus@studium.uni-erlangen.de wrote:
> We are currently trying to add encryption support to the usbip kernel
> driver. Unfortunately, there is almost no documentation for the kernel
> crypto API. So far, we couldn't figure out how to use the GCM encryption
> mode in the kernel. There seems to be infrastructure for IV generation
> in place (e.g. seqiv.c, the geniv stuff and the RFC 4106 implementation),
> but no code directly using it.
> 
> What's the recommended way to use the IV generators with a "high-level"
> API?

Sorry, that mail probably got a bit too short. To explain our problem a bit
more: We are currently using a 64-bit counter to generate IVs. As the
keys are randomly generated for each session and thus never reused,
that's probably a not too bad idea (if it is, please tell us why ;)),
assuming this counter is never going to overflow. We pass the IVs
directly to aead_request_set_crypt for each message. This currently
works quite fine.

However, we would expect that IV generation is at least partially handled
by the crypto API. As I said, there seems to be infrastructure for that,
that abstracts the sequence number quite nicely. The seqiv generator
seems to provide a high-level interface to the AEAD crypto, including an 
abstraction for the sequence number generation. However, due to the lack
of documentation and/or reference code using the API, we couldn't find
out how to use it yet.

Any help on this would be appreciated. If we feel competent enough to do 
so after finishing this project, we would also volunteer to extend the
introduction in Documentation/crypto/api-intro.txt a bit.

Regards,
        Tobias Polzer and Dominik Paulus
