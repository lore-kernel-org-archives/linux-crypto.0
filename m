From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AEAD x86 assembler crash
Date: Mon, 1 Jun 2015 17:17:45 +0800
Message-ID: <20150601091745.GA12441@gondor.apana.org.au>
References: <5734608.jOsyQWs821@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40240 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbbFAJRs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 05:17:48 -0400
Content-Disposition: inline
In-Reply-To: <5734608.jOsyQWs821@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 01, 2015 at 11:12:45AM +0200, Stephan Mueller wrote:
>
> [  599.243227]  [<ffffffff812b7b85>] old_crypt+0xc5/0xe0
> [  599.243229]  [<ffffffff812b7bdd>] old_encrypt+0x1d/0x20
> [  599.243233]  [<ffffffffa02c1183>] kccavs_aead_encdec+0x53/0x80 [kcapi_cavs]
> [  599.243235]  [<ffffffffa02c1cca>] kccavs_test_aead+0x23a/0x3e0 [kcapi_cavs]
> [  599.243238]  [<ffffffffa02c0f17>] kccavs_data_read+0xf7/0x130 [kcapi_cavs]

Hang on, what is this kcapi_cavs? We don't support out-of-tree
crypto users.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
