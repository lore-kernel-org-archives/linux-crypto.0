From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] DH support: add KDF handling support
Date: Thu, 14 Jul 2016 16:19:20 +0200
Message-ID: <9415711.Ky7HB7mCX4@tauon.atsec.com>
References: <4161793.TTVXSVQtZL@positron.chronox.de> <1954976.nIU2Zma9Rk@tauon.atsec.com> <CAH8yC8=GUqm5w069_42SWpjTwcuQxvmCtrAfzX9BnoyW_PEYwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39150 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbcGNOTv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jul 2016 10:19:51 -0400
In-Reply-To: <CAH8yC8=GUqm5w069_42SWpjTwcuQxvmCtrAfzX9BnoyW_PEYwA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 14. Juli 2016, 04:00:57 schrieb Jeffrey Walton:

Hi Jeffrey,

> > Note, as shared secrets potentially post-processed by a KDF usually are
> > again used as key or data encryption keys, they need to be
> > truncated/expanded to a specific length anyway. A KDF inherently provides
> > the truncation support to any arbitrary length. Thus, I would think that
> > the caller needs to provide that length but does not need to truncate the
> > output itself.
> 
> As far as I know, there's no reduction in proof that a truncated hash
> is as secure as the non-truncated one. One of the reasons to provide
> the output length as a security parameter is to help avoid truncation
> and related hash output attacks.
> 
> Also see Kelsey's work on the subject;
> http://www.google.com/search?q=nist+kelsey+truncated+hash.

I understand that point. However, a KDF is not just a simple hash or 
truncation thereof. Furthermore, Kelsey is part of the NIST team that also 
developed SP800-108 (the KDF definition). Furthermore, the authors of 
SP800-56A (in particular Allen Roginsky who I met personally a number of 
times) work closely with Kelsey too.

So, I would not think that applying the standard KDF operation which is 
intended to "right-size" the DH output is nothing we should worry about.

I would rather worry about the size of the private key in the DH operation. 
The private key should be as small as cryptographically possible (e.g. 224 or 
256 bits) instead of half of the DH public key minus one (what TLS does) due 
to the reduced number of Sopie-Germain primes that are available in the latter 
case.

Ciao
Stephan
