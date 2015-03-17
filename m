From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC PATCH] crypto: prevent helper ciphers from being allocated by users
Date: Tue, 17 Mar 2015 15:59:48 +0100
Message-ID: <3827420.CeUHuNxA9P@tauon>
References: <13986065.EbkBp8M36a@tachyon.chronox.de> <1442292.caf3IdtESe@tauon> <20150317114552.GA12326@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46699 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbbCQO7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Mar 2015 10:59:52 -0400
In-Reply-To: <20150317114552.GA12326@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 17. M=E4rz 2015, 22:45:52 schrieb Herbert Xu:

Hi Herbert,

>On Tue, Mar 17, 2015 at 12:40:12PM +0100, Stephan Mueller wrote:
>> >How about adding a flag to all these internal algorithms and then
>> >change crypto_alg_mod_lookup to disable that flag by default?
>>=20
>> The issue with flags is the following: first we have to think about
>> whether we want a black list or white list approach. Your suggestion
>> implies a black list. Black lists for ensuring security is not good
>> IMHO as it has a tendency to miss cases. This especially applies to
>> this area where we have already an indicator for internal ciphers:
>> the prio is so low that it will never ever be selected based on the
>> name. Now, adding a flag means that we mark such an internal cipher
>> twice.
>
>Huh? Using prio is already a black list.
>
>In any case abusing the priority field like this is not acceptable,
>especially when the priority can be set from user-space.

I agree, I forgot about the priority being changable.

I will prepare a proposal with a flag.
>
>Cheers,


Ciao
Stephan
