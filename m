From: Pavel Roskin <proski@gnu.org>
Subject: Re: Crypto Update for 2.6.38
Date: Thu, 06 Jan 2011 21:39:28 -0500
Message-ID: <20110106213928.jd36vdlpcgsgcwss-cebfxv@webmail.spamcop.net>
References: <20100804140448.GA4042@gondor.apana.org.au>
	<20101024061625.GA23715@gondor.apana.org.au>
	<20110106000157.GA16089@gondor.apana.org.au>
	<AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com>
	<20110106211645.GA26184@gondor.apana.org.au>
	<AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com>
	<20110106213932.GA26538@gondor.apana.org.au>
	<AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com>
	<20110106223042.GA27080@gondor.apana.org.au>
	<AANLkTinbH8i8rjUxACV5PkdLuVc9YccT+E5x=ZBWunyU@mail.gmail.com>
	<20110106225301.GA27358@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:54071 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab1AGCja (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Jan 2011 21:39:30 -0500
In-Reply-To: <20110106225301.GA27358@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Herbert Xu <herbert@gondor.apana.org.au>:

> 	setsockopt(tfmfd, SOL_ALG, ALG_SET_KEY,
> 		   "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
> 		   "\x51\x2e\x03\xd5\x34\x12\x00\x06", 16);

By the way, is it a good idea to use setsockopt() this way?  Some keys  
may be large.  And if AEAD is supported, will it use setsockopt() for  
the unencrypted authenticated data?

Maybe some variation of write() or sendto() would be more appropriate?

-- 
Regards,
Pavel Roskin
