From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: add key wrapping block chaining mode
Date: Mon, 27 Apr 2015 16:34:19 +0200
Message-ID: <2485784.4PBTOVspUY@tauon>
References: <1515730.LIeS5qas5m@myon.chronox.de> <3407264.GJDOVGtEDe@myon.chronox.de> <20150427082607.GA21590@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34531 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932896AbbD0Oe0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 10:34:26 -0400
In-Reply-To: <20150427082607.GA21590@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 27. April 2015, 16:26:07 schrieb Herbert Xu:

Hi Herbert,

>On Sun, Apr 26, 2015 at 12:08:20AM +0200, Stephan Mueller wrote:
>> +		/*
>> +		 * Point to the end of the scatterlists to walk them 
backwards.
>> +		 */
>> +		src_walk.offset += src_nbytes;
>> +		dst_walk.offset += dst_nbytes;
>
>This doesn't work.  Our primitives don't support walking backwards
>over an SG list and what you have simply doesn't work except for the
>trivial case of a completely linear buffer.

Why do you think that will not work? I thought that the code works when the 
non-linear scatterlists are at least broken at an 8 byte boundary.
>
>Cheers,


Ciao
Stephan
