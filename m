From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: testmgr in user space
Date: Thu, 25 Jun 2015 22:45:30 +0800
Message-ID: <20150625144530.GA10976@gondor.apana.org.au>
References: <3286221.F87xU132y8@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51864 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbbFYOpf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2015 10:45:35 -0400
Content-Disposition: inline
In-Reply-To: <3286221.F87xU132y8@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 24, 2015 at 07:34:34AM +0200, Stephan Mueller wrote:
>
> While we are at it: wouldn't it make sense to move the tcrypt.c out to the 
> tools/ directory?

tcrypt is currently a kernel module so it would be difficult to move
in its current form.

Please see my response to Linus with regards to my plan to move the
vectors from testmgr into individual algorithm files (e.g., aes.c
for aes vectors).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
