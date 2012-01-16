From: "David Laight" <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 2/3] sha512: reduce stack usage to safe number
Date: Mon, 16 Jan 2012 09:56:41 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AF43@saturn3.aculab.com>
References: <20120114204127.GA4100@p183.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
	<ken@codelabs.ch>,
	"Steffen Klassert" <steffen.klassert@secunet.com>,
	"Eric Dumazet" <eric.dumazet@gmail.com>, <security@kernel.org>
To: "Alexey Dobriyan" <adobriyan@gmail.com>,
	"Linus Torvalds" <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:40898 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750927Ab2APJ4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jan 2012 04:56:42 -0500
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 22827-03 for <linux-crypto@vger.kernel.org>;
 Mon, 16 Jan 2012 09:56:39 +0000 (GMT)
Content-class: urn:content-classes:message
In-Reply-To: <20120114204127.GA4100@p183.telecom.by>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Doesn't this badly overflow W[] ..
 
> +#define SHA512_0_15(i, a, b, c, d, e, f, g, h) \
> +	t1 = h + e1(e) + Ch(e, f, g) + sha512_K[i] + W[i];	\
...
> +	for (i = 0; i < 16; i += 8) {
...
> +		SHA512_0_15(i + 7, b, c, d, e, f, g, h, a);
> +	}

	David
