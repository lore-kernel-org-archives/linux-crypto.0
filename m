From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: ansi_cprng - Do not select FIPS
Date: Fri, 14 Aug 2009 21:13:55 +1000
Message-ID: <20090814111355.GA5908@gondor.apana.org.au>
References: <20090619123400.GA18778@gondor.apana.org.au> <20090619125500.GA18153@hmsreliant.think-freely.org> <20090813112955.GA25239@gondor.apana.org.au> <20090813144156.GA31826@shamino.rdu.redhat.com> <20090814031340.GA2380@gondor.apana.org.au> <20090814105829.GB20601@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Neil Horman <nhorman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45677 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754817AbZHNLN4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2009 07:13:56 -0400
Content-Disposition: inline
In-Reply-To: <20090814105829.GB20601@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 14, 2009 at 06:58:29AM -0400, Neil Horman wrote:
>
> Yeah, I suppose, it just seemed like a hack to me, since it really is a logical
> boolean, and we use it as such.  Ok, I'll look at fixing this soon.  Thanks!

Well it wouldn't be the first time we had to hack around Kconfig
logic, just look at those *2 symbols in crypto/Kconfig :)
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
