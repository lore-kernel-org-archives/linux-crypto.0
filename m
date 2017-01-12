From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Thu, 12 Jan 2017 17:37:33 +0100
Message-ID: <3463059.TVfkfLOfNf@tauon.atsec.com>
References: <10526995.lyZ7Je1KMx@positron.chronox.de> <1604413.m50iU9qQPD@tauon.atsec.com> <20170112160629.GA19577@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55510 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751014AbdALQhj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 11:37:39 -0500
In-Reply-To: <20170112160629.GA19577@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. Januar 2017, 00:06:29 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Jan 12, 2017 at 05:01:13PM +0100, Stephan Müller wrote:
> > I fully agree. Therefore, I was under the impression that disregarding the
> > AAD in recvmsg entirely would be most appropriate as offered with the
> > patch "crypto: AF_ALG - disregard AAD buffer space for output". In this
> > case we would be fully POSIX compliant, the kernel would not copy the AAD
> > (and thus perform multiple memcpy operations due to copy_from_user and
> > copy_to_user round trips) and leave the AAD copy operation entirely to
> > user space.
> Yes but then you'd have to play nasty games to fit this through
> the kernel API. 

I would not understand that statement.

With the patch mentioned above that I provided some weeks ago, we have the 
following scenario for an encryption (in case of decryption, it is almost 
identical, just the tag location is reversed):

user calls sendmsg with data buffer/IOVEC: AAD || PT
	-> algif_aead turns this into the src SGL

user calls recvmsg with data buffer/IOVEC: CT || Tag
	-> algif_aead creates the first SG entry in the dst SGL pointing to the 
AAD from the src SGL
	-> algif_aead appends the user buffers to the dst SGL

	-> algif_aead performs its operation and during that operation, only the 
CT and Tag parts are changed

I.e. with the pre-pending of the SG pointing to the AAD from the src SGL to 
the dst SGL we have a clean invocation of the kernel API.

Yet, we avoid copy round trips of the AAD from src to dst in the kernel.

> Besides, we could still do in-place crypto even
> though you suggested that it's complicated.

Is that crypto-in-place operation really a goal we want to achieve if we "buy" 
it with a memcpy of the data from the src SGL to the dst SGL before the crypto 
operation?

Can we really call such implementation a crypto-in-place operation?

> It's not really.

I concur, for encryption the suggested memcpy is not difficult. Only for 
decryption, the memcpy is more challenging.

> All we have to do is walk through the SG list and compare each
> page/offset.  For the common case it's going to be a single-entry
> list.
> 
> Cheers,



Ciao
Stephan
