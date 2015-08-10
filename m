From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Removing CTR mode from NX driver
Date: Mon, 10 Aug 2015 23:42:23 +0800
Message-ID: <20150810154223.GF21143@gondor.apana.org.au>
References: <20150808213058.GA5932@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	pfsmorigo@linux.vnet.ibm.com
To: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56740 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364AbbHJPm1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Aug 2015 11:42:27 -0400
Content-Disposition: inline
In-Reply-To: <20150808213058.GA5932@bluepex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Aug 08, 2015 at 06:31:01PM -0300, Leonidas S. Barbosa wrote:
> CTR hardware implementation does not match with kernel spec causing a counter bug
> where just low 8 bytes are used for counter, when should be all 16bytes.
> 
> Since we already have other counter modes working according with specs
> not worth to keep CTR itself on NX.
> 
> Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
