From: Pavel Roskin <proski@gnu.org>
Subject: Re: Crypto Update for 2.6.38
Date: Thu, 06 Jan 2011 16:46:02 -0500
Message-ID: <4D26381A.8040901@gnu.org>
References: <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au> <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au> <20110106000157.GA16089@gondor.apana.org.au> <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com> <20110106211645.GA26184@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:23859 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab1AFV4J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Jan 2011 16:56:09 -0500
In-Reply-To: <20110106211645.GA26184@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/06/2011 04:16 PM, Herbert Xu wrote:

> This is also why only hash and skcipher are supported as they
> are the main algorithm types supported by teh current async
> drivers in the kernel.

Are there any chances AEAD will be supported?  Is the API extendable to 
allow that?

If I remember correctly, the original patch was simply a port of FreeBSD 
/dev/crypto, which doesn't support AEAD.

-- 
Regards,
Pavel Roskin
