From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: return codes
Date: Sat, 9 Oct 2010 09:29:13 +0800
Message-ID: <20101009012913.GA2829@gondor.apana.org.au>
References: <1286309078.2663.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:51836 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab0JIB3Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Oct 2010 21:29:16 -0400
Content-Disposition: inline
In-Reply-To: <1286309078.2663.42.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> Hi,
> 
> Looking at different examples of the same crypto call, it's unclear
> whether it only returns negative error values. Some examples only test
> for negative values, while others test for not 0. tcrypt.c does "if
> (ret)".  Would appreciate some clarification.

Unless the call can return positive values then it makes no
difference.  Which particular call are you talking about?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
