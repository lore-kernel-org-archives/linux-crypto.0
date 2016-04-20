From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: ccp - Register the CCP as a DMA resource
Date: Wed, 20 Apr 2016 17:58:50 +0800
Message-ID: <20160420095850.GC3003@gondor.apana.org.au>
References: <20160418142144.21119.67972.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
	davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44272 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933659AbcDTJ66 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2016 05:58:58 -0400
Content-Disposition: inline
In-Reply-To: <20160418142144.21119.67972.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 18, 2016 at 09:21:44AM -0500, Gary R Hook wrote:
> The CCP has the ability to provide DMA services to the
> kernel using pass-through mode of the device. Register
> these services as general purpose DMA channels.
> 
> Changes since v2:
> - Add a Signed-off-by

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
