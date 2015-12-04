From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] IV size failing on skcipher API
Date: Fri, 4 Dec 2015 22:41:55 +0800
Message-ID: <20151204144155.GE17703@gondor.apana.org.au>
References: <20151130181859.GA15519@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	pfsmorigo@linux.vnet.ibm.com
To: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58423 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbbLDOl7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Dec 2015 09:41:59 -0500
Content-Disposition: inline
In-Reply-To: <20151130181859.GA15519@bluepex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 30, 2015 at 04:19:03PM -0200, Leonidas Da Silva Barbosa wrote:
> IV size was zero on CBC and CTR modes,
> causing a bug triggered by skcipher.
> 
> Fixing this  adding a correct size.
> 
> Signed-off-by: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
> Signed-off-by: Paulo Smorigo <pfsmorigo@linux.vnet.ibm.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
