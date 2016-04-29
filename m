From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random(4) changes
Date: Fri, 29 Apr 2016 13:18:09 +0200
Message-ID: <4191223.qhyOqInRhP@tauon.atsec.com>
References: <20160429110424.641.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54192 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbcD2LSR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 07:18:17 -0400
In-Reply-To: <20160429110424.641.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 29. April 2016, 07:04:24 schrieb George Spelvin:

Hi George,

> > I think there is a slight mixup: IID is not related to an attacker
> > predicting things. IID is simply a statistical measure, it is either there
> > or not. It does not depend on an attacker (assuming that the attacker
> > cannot change the data). Note, the IID is only needed to claim that the
> > XOR will be entropy preserving.
> 
> 1. It DOES depend on the attacker.  Any statement about independence
>    depends on the available knowledge.
> 2. XOR being entropy preserving depends on independence ONLY, it does
>    NOT depend on identical distribution.  The latter is a red herring.
>    (An English metaphor for "irrelevant distraction.")
> 3. Precisely because the bits are not independent, XOR is not
>    guaranteed to be entropy-preserving (your sense) on real data.

It seems we talk past each other. Your entire explanation refers to individual 
bits that come in sequentially where the attacker inbetween can analyze it and 
potentially modify his attack. Sure, in this case they are not independent and 
I am not claiming that.

But one single time stamp is one value where the entire 32 bits are generated 
in an atomic fashion to any observer -- there is no sequential obtaining of 
its bits, analyzing it and then reacting on it. Each of those bits are set 
independently from the others. So, when an attacker looks at it, the entire 32 
bits are already there. Hence there is no changing in a distribution by simply 
looking at it.

So, take one RDTSC value and slice it into the individual bits. You cannot 
predict the 32nd bit when known the first 31 bits. You can only predict the 
32nd bit if you know the previous time stamps.

Again, I know that when seeing two or more time stamps, they are depending on 
each other. And for processing these multiple time stamps I use concatenation 
which is not affected by dependencies.

Ciao
Stephan
