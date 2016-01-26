From: Stephan Mueller <smueller@chronox.de>
Subject: Re: GCM: cra_name == cra_driver_name
Date: Tue, 26 Jan 2016 14:14:40 +0100
Message-ID: <10394749.3Yi2f5rYLG@tauon.atsec.com>
References: <4642565.JLlnFcM15x@positron.chronox.de> <20160126111352.GB21069@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42542 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965819AbcAZNOm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 08:14:42 -0500
In-Reply-To: <20160126111352.GB21069@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 26. Januar 2016, 19:13:52 schrieb Herbert Xu:

Hi Herbert,

>On Mon, Jan 25, 2016 at 10:48:38PM +0100, Stephan Mueller wrote:
>> Hi Herbert,
>> 
>> with the current cryptodev tree, when I call a compound AEAD cipher with
>> cra_driver_name for the first time, this cra_driver_name gets registered
>> also as cra_name. Note, using other compound ciphers (like HMAC or
>> symmetric ciphers), I do not see that error.
>> 
>> With that registering, I am not able to resolve the cipher with usual
>> common
>> cra_name.
>> 
>> Note, when I initialized an AEAD cipher with a cra_name, then all works as
>> it used to be.
>
>Is this a new problem? I thought it always worked like this.

At least I have seen that now for the first time. But maybe I have not tested 
this order of invocation before.
>
>I was going to fix it to generate a proper cra_name after I'm
>done with the skcipher conversion.

Ok, thanks.
>
>Cheers,


Ciao
Stephan
