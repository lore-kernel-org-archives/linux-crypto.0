From: Stephan Mueller <smueller@chronox.de>
Subject: Re: GCM / seqiv and SP800-38D
Date: Sat, 28 Feb 2015 13:08:03 +0100
Message-ID: <3241224.tIGo75L0M7@tachyon.chronox.de>
References: <5009281.r2g8PApWDK@tauon> <20150228104712.GA7720@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36222 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbbB1MIH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Feb 2015 07:08:07 -0500
In-Reply-To: <20150228104712.GA7720@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 28. Februar 2015, 23:47:12 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Feb 19, 2015 at 07:56:48AM +0100, Stephan Mueller wrote:
> > In case of rfc4106(gcm(aes)), the IV is 96 bits. Thus, our constructed
> 
> > IV looks like:
> The IV to rfc4106 is 96 bits, but the IV to the underlying gcm
> is 128 bits so that's what guarantees the uniqueness.

We have to be careful with the wording here: SP800-38D specifies the 96 bits 
as the IV (also called the nonce). The additional 32 bit you refer to is the 
counter for the CTR mode. The complete 128 bit are *not* referred to when 
SP800-38D speaks about the uniqueness of IVs in section 8.2.1 or 8.2.2.

Thus, we come back to the 96 bits. And I do not dispute that there is almost 
zip probability of collisions, all I want to state is that the construction 
method with seqiv does neither comply with section 8.2.1 nor with 8.2.2. That 
means, the GCM IV construction currently does not meet the specification of 
SP800-38D. Furthermore, the authors of SP800-38D currently do not approve of 
the seqiv construction method.

-- 
Ciao
Stephan
