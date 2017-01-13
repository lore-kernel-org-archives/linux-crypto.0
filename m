From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Fri, 13 Jan 2017 18:23:39 +0800
Message-ID: <20170113102339.GB23349@gondor.apana.org.au>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
 <1604413.m50iU9qQPD@tauon.atsec.com>
 <20170112160629.GA19577@gondor.apana.org.au>
 <3463059.TVfkfLOfNf@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45827 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751356AbdAMKXv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 05:23:51 -0500
Content-Disposition: inline
In-Reply-To: <3463059.TVfkfLOfNf@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 05:37:33PM +0100, Stephan Müller wrote:
>
> I would not understand that statement.
> 
> With the patch mentioned above that I provided some weeks ago, we have the 
> following scenario for an encryption (in case of decryption, it is almost 
> identical, just the tag location is reversed):
> 
> user calls sendmsg with data buffer/IOVEC: AAD || PT
> 	-> algif_aead turns this into the src SGL
> 
> user calls recvmsg with data buffer/IOVEC: CT || Tag
> 	-> algif_aead creates the first SG entry in the dst SGL pointing to the 
> AAD from the src SGL
> 	-> algif_aead appends the user buffers to the dst SGL
> 
> 	-> algif_aead performs its operation and during that operation, only the 
> CT and Tag parts are changed
> 
> I.e. with the pre-pending of the SG pointing to the AAD from the src SGL to 
> the dst SGL we have a clean invocation of the kernel API.

But that means you can never invoke the in-place path of the kernel
API, which is the most optimised code path.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
