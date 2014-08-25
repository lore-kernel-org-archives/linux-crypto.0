From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] Add TLS record layer encryption module
Date: Mon, 25 Aug 2014 17:44:03 +0800
Message-ID: <20140825094403.GA27102@gondor.apana.org.au>
References: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
 <53DAA031.30405@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Cristian Stoica <cristian.stoica@freescale.com>,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-kernel@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:37968 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaHYJoW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Aug 2014 05:44:22 -0400
Content-Disposition: inline
In-Reply-To: <53DAA031.30405@amacapital.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 31, 2014 at 12:59:45PM -0700, Andy Lutomirski wrote:
> 
> What is this used for?  AF_ALG?  I find it hard to believe that the
> kernel will ever want to use this internally.

There have been discussions over the years regarding implementing
TLS/SSL in the kernel so it is not inconceivable that it might
happen one day.

Of course I don't think this is the motivation behind this patch
set.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
