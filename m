From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: LRW/XTS + Via Padlock Bug in 2.6.24-rc7?
Date: Fri, 11 Jan 2008 10:58:27 +1100
Message-ID: <20080110235827.GA22040@gondor.apana.org.au>
References: <E1JD4KF-0004T4-00@gondolin.me.apana.org.au> <4786A88E.4020503@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Torben Viets <viets@web.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3574 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752762AbYAJX6a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jan 2008 18:58:30 -0500
Content-Disposition: inline
In-Reply-To: <4786A88E.4020503@web.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 11, 2008 at 12:21:50AM +0100, Torben Viets wrote:
> 
> Why I can't see both in /proc/crypto and of course not use in int 
> cryptsetup, till I make a /etc/init.d/udev restart ist ths a kernel bug, 
> or a ubuntu bug?

The algorithm xts(aes) is an instantiation of the xts template.  As such
you won't see it until someone tries to use it or you instantiate it
explicitly (which isn't possible yet :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
