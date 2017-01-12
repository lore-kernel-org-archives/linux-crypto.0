From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Fri, 13 Jan 2017 00:06:29 +0800
Message-ID: <20170112160629.GA19577@gondor.apana.org.au>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
 <19793111.SdtrLVTG75@tauon.atsec.com>
 <20170112155344.GB19252@gondor.apana.org.au>
 <1604413.m50iU9qQPD@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34873 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751012AbdALQGf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 11:06:35 -0500
Content-Disposition: inline
In-Reply-To: <1604413.m50iU9qQPD@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 05:01:13PM +0100, Stephan Müller wrote:
>
> I fully agree. Therefore, I was under the impression that disregarding the AAD 
> in recvmsg entirely would be most appropriate as offered with the patch 
> "crypto: AF_ALG - disregard AAD buffer space for output". In this case we 
> would be fully POSIX compliant, the kernel would not copy the AAD (and thus 
> perform multiple memcpy operations due to copy_from_user and copy_to_user 
> round trips) and leave the AAD copy operation entirely to user space.

Yes but then you'd have to play nasty games to fit this through
the kernel API.  Besides, we could still do in-place crypto even
though you suggested that it's complicated.  It's not really.
All we have to do is walk through the SG list and compare each
page/offset.  For the common case it's going to be a single-entry
list.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
