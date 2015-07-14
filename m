From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/5] crypto: aead - Convert ccm to new interface
Date: Tue, 14 Jul 2015 16:45:47 +0800
Message-ID: <20150714084547.GA21551@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41506 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbbGNIpv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2015 04:45:51 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This series converts all implementations of CCM to the new AEAD
interface.

Note that arm and nx are compile-tested only.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
