From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: variable iv lengths for aes-gcm
Date: Thu, 18 Jun 2015 16:07:07 +0800
Message-ID: <20150618080707.GA29218@gondor.apana.org.au>
References: <55827696.20704@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ambarus Tudor-Dan-B38632 <b38632@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57990 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbbFRIHL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 04:07:11 -0400
Content-Disposition: inline
In-Reply-To: <55827696.20704@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 18, 2015 at 10:43:18AM +0300, Ambarus Tudor-Dan-B38632 wrote:
> 
> I'm trying to find a method to pass IVs of various lengths to an
> algorithm. A particular case would be aes-gcm IV. It can have any
> number of bits between 1 and 2^64.
> 
> A possible way to do this is to set the ivlen per request. Are there
> any (better) ways to do this?

Why would you want do this apart from the fact that your hardware
supports it and you want to export this?

Using a long IV is fundamentally insecure because all GCM will do
is hash it and there is nothing that can guarantee uniquenes of the
hash result.

You might as well just pull out a random number and use that as your
IV.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
