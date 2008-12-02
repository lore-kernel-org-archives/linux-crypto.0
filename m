From: Dean Jenkins <djenkins@mvista.com>
Subject: Re: ESP output when using NULL encryption and NON authentication
Date: Tue, 02 Dec 2008 10:59:48 +0000
Message-ID: <1228215588.414.53.camel@libdev3.mvista.co.uk>
References: <E1L6HWV-0000zI-B5@gondolin.me.apana.org.au>
Reply-To: djenkins@mvista.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-vyMbBNnoO36z31NKveNL"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:39069 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYLBK7v (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2008 05:59:51 -0500
In-Reply-To: <E1L6HWV-0000zI-B5@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-vyMbBNnoO36z31NKveNL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Herbert,

Thanks for the clue. I had set the IV size to AES_BLOCK_SIZE in my NULL
crypto registered structure. Now fixed the IV size to 0 and put the
maxauthsize also to 0. Now I have basic Async AEAD NULL enc and NON auth
working with ping over ESP.

Regards,
Dean Jenkins
MontaVista Software

--=-vyMbBNnoO36z31NKveNL
Content-Disposition: inline
Content-Description: Forwarded message - Re: ESP output when using NULL
	encryption and NON authentication
Content-Type: message/rfc822

Return-Path: <herbert@gondor.apana.org.au>
Received: from hermes.mvista.com ([unix socket]) by hermes.mvista.com
	(Cyrus v2.2.3-Invoca-RPM-2.2.3-4) with LMTP; Fri, 28 Nov 2008 20:34:21 -0800
X-Sieve: CMU Sieve 2.2
Received: from dune.mvista.com (unknown [10.20.1.91]) by hermes.mvista.com
	(Postfix) with ESMTP id A75E41882A for <djenkins@mvista.com>; Fri, 28 Nov
	2008 20:34:20 -0800 (PST)
Received: (qmail 24843 invoked from network); 29 Nov 2008 04:34:19 -0000
X-Spam-Checker-Version: SpamAssassin 3.1.7 (2006-10-05) on thoth.mvista.com
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=5.0 tests=AWL,BAYES_00,
	USER_IN_WHITELIST_TO autolearn=ham version=3.1.7
Received: from unknown (HELO arnor.apana.org.au) (64.62.148.172) by
	dune.mvista.com with DES-CBC3-SHA encrypted SMTP; 29 Nov 2008 04:33:45 -0000
Received: from gondolin.me.apana.org.au ([192.168.0.6]) by
	arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian)) id 1L6HWY-0002d9-Tm;
	Sat, 29 Nov 2008 15:33:43 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>) id 1L6HWV-0000zI-B5; Sat, 29
	Nov 2008 12:33:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: djenkins@mvista.com (Dean Jenkins)
Subject: Re: ESP output when using NULL encryption and NON authentication
Cc: linux-crypto@vger.kernel.org
Organization: Core
In-Reply-To: <200811271813.18727.djenkins@mvista.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4
	(i686))
Message-Id: <E1L6HWV-0000zI-B5@gondolin.me.apana.org.au>
Date: Sat, 29 Nov 2008 12:33:39 +0800
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Dean Jenkins <djenkins@mvista.com> wrote:
>
> However, ESP's call to crypto_aead_decrypt() puts the start of the 
> encapsulated packet (first 16 bytes) into the IV field of the AEAD request 
> instead of wholly in the src scatterlist. The dst scatterlist is in fact the 
> same src scatterlist.

Well if you're using NULL encryption then the IV size will be zero.
So even though the IV field has the pointer to the start of the
payload so does the src scatterlist.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--=-vyMbBNnoO36z31NKveNL--

