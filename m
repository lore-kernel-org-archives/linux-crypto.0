From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mxs-dcp - Initialize .statesize fields
Date: Fri, 27 Nov 2015 22:31:45 +0800
Message-ID: <20151127143145.GA30135@gondor.apana.org.au>
References: <1448552861-17410-1-git-send-email-fabio.estevam@freescale.com>
 <20151127125239.GA29303@gondor.apana.org.au>
 <5269835.Et7mvBlT7h@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fabio Estevam <fabio.estevam@freescale.com>, marex@denx.de,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38355 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbK0OcA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Nov 2015 09:32:00 -0500
Content-Disposition: inline
In-Reply-To: <5269835.Et7mvBlT7h@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 27, 2015 at 03:25:22PM +0100, Stephan Mueller wrote:
>
> May I ask you for a brief reference on how that should be covered so that we 
> can fix all other problematic implementations?

Basically export needs to write the complete hash state into
a buffer of size statesize, and import needs to be able to read
such a buffer and generate a hash state from it which can then
be updated/finalised.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
