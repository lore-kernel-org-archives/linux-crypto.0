From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/3] random: Replace kernel blocking API with callback API
Date: Tue, 9 Jun 2015 18:18:30 +0800
Message-ID: <20150609101830.GA10521@gondor.apana.org.au>
References: <1758927.bAziGtcHhF@tachyon.chronox.de>
 <20150609064955.GA8794@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, andreas.steffen@strongswan.org,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60323 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbbFIKSm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 06:18:42 -0400
Content-Disposition: inline
In-Reply-To: <20150609064955.GA8794@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

This series replaces the blocking API for random pool readiness
with a callback API.  The reason is that the random pool may not
become ready for quite some time so we cannot really wait for it
in a kernel thread as we quickly run into the 2-minute time limit
for detecting lockups.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
