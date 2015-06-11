From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/3] crypto: picoxcell - Clamp AEAD SG list by input length
Date: Thu, 11 Jun 2015 11:27:03 +0800
Message-ID: <20150611032703.GA10416@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jamie Iles <jamie@jamieiles.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38928 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbbFKD1I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 23:27:08 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This series of patches adds a couple of minor fixes to picoxcell,
but most importantly allows it to be used with the new AEAD interface
by ensuring that it clamps the AD SG list by the AD length.

This is compile-tested only.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
