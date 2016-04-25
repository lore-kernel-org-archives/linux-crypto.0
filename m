From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Ensure all dependencies are specified
Date: Mon, 25 Apr 2016 19:20:54 +0800
Message-ID: <20160425112054.GA10114@gondor.apana.org.au>
References: <20160420145512.4178.27624.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
	davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59417 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbcDYLVD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 07:21:03 -0400
Content-Disposition: inline
In-Reply-To: <20160420145512.4178.27624.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 20, 2016 at 09:55:12AM -0500, Gary R Hook wrote:
> A DMA_ENGINE requires DMADEVICES in Kconfig
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
