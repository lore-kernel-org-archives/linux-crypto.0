From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] consider keysize in algorithm selection
Date: Thu, 11 Oct 2007 21:01:40 +0800
Message-ID: <20071011130140.GA20363@gondor.apana.org.au>
References: <20071010164400.GA19471@Chamillionaire.breakpoint.cc> <20071011114700.GA17801@gondor.apana.org.au> <20071011124314.GA28993@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4790 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753280AbXJKNBn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Oct 2007 09:01:43 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IfxfZ-0001WO-9I
	for <linux-crypto@vger.kernel.org>; Thu, 11 Oct 2007 23:01:41 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IfxfY-0005J0-00
	for <linux-crypto@vger.kernel.org>; Thu, 11 Oct 2007 21:01:40 +0800
Content-Disposition: inline
In-Reply-To: <20071011124314.GA28993@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 11, 2007 at 02:43:14PM +0200, Sebastian Siewior wrote:
>
> >In other words, let's make geode-aes use the padlock-sha method
> >and just fall back to a lower-priority AES algorithm if it sees
> >a key size that it can't handle.
> geode and s390 :)

Are you sure about s390? I can't find a key size that it can't
handle.

> I'm currently digging in geode's code, it seems that there is bug
> hiding somewhere.

I wouldn't be surprised if there were two of them hiding there :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
