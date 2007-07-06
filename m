From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: RSA support into kernel?
Date: Fri, 06 Jul 2007 21:12:52 +0800
Message-ID: <E1I6ncC-0007e3-00@gondolin.me.apana.org.au>
References: <20070706.040533.30182871.davem@davemloft.net>
Cc: johnpol@2ka.mipt.ru, gautam.singaraju@gmail.com,
	linux-crypto@vger.kernel.org
To: davem@davemloft.net (David Miller)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3006 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751484AbXGFNNV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jul 2007 09:13:21 -0400
In-Reply-To: <20070706.040533.30182871.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

David Miller <davem@davemloft.net> wrote:
>> 
>> VIA padlock engine or RSA? The former is heavily used in the wild, but
>> why would anyone want to use RSA in the kernel?
> 
> Automatic SSL done in-kernel on user data for socket I/O, with
> hardware offload from the crypto layer when available.

AFAIK asymmetric crypto is only used for SSL key exchange and not
on the data transfers so I'm not sure whether this would be that
useful.  This is pretty much the same situation with IPsec where
we delegate the key exchange to the userspace KMs.

Now having in-kernel SSL data exchange support using the crypto
API would be pretty cool and would provide the same level of
crypto support to SSL users as we do for IPsec.

So far the only proposed user for RSA in-kernel seems to be
module signing and I'm staying well away from that debate :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
