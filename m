From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/6] crypto: Remove fips.h inclusion from internal.h
Date: Wed, 22 Apr 2015 13:24:52 +0800
Message-ID: <20150422052452.GA7553@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55616 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316AbbDVFYz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 01:24:55 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For historical reasons internal.h currently includes fips.h and
a number of files depend on that to get access to fips_enabled.

This is suboptimal because internal.h is truly internal and should
only be used if you're implementing internal crypto API.  That means
if you are an algorithm/driver author or crypto API user then you
should not be accessing that file.

This series moves the fips.h inclusion to spots where it's actually
needed and then gets rid of it from internal.h.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
