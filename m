From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: algif_hash - Only export and import on
 sockets with data
Date: Thu, 5 Nov 2015 20:19:21 +0800
Message-ID: <20151105121921.GB5776@gondor.apana.org.au>
References: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com>
 <2587504.xtsMOV5mei@myon.chronox.de>
 <20151101091119.GA3035@gondor.apana.org.au>
 <1470343.4RyZqhtxup@myon.chronox.de>
 <20151102031204.GA7372@gondor.apana.org.au>
 <CAFXBA==77BA3aF6UzjK+s6P+Aw7HRy7-xELn6oiyOFgWjdAKvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55764 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030515AbbKEMT1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Nov 2015 07:19:27 -0500
Content-Disposition: inline
In-Reply-To: <CAFXBA==77BA3aF6UzjK+s6P+Aw7HRy7-xELn6oiyOFgWjdAKvw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 05, 2015 at 01:12:04PM +0530, Harsh Jain wrote:
> Hi herbert,
> 
> Which kernel versions will have this patch?

It has to go into 4.4 first before it gets backported.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
