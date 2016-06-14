From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5] crypto: rsa - return raw integers for the ASN.1 parser
Date: Tue, 14 Jun 2016 21:38:06 +0800
Message-ID: <20160614133806.GA22193@gondor.apana.org.au>
References: <1465910098-16349-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <2066344.ohg9RiuaKP@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36983 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbcFNNiS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2016 09:38:18 -0400
Content-Disposition: inline
In-Reply-To: <2066344.ohg9RiuaKP@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 14, 2016 at 03:20:06PM +0200, Stephan Mueller wrote:
>
> memzero_explicit(raw_key) should be added here in success and failure code 
> paths.

The raw_key is just a bunch of pointers, do we really need to
zero it?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
