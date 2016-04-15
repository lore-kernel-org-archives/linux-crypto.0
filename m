From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: ccp - Register the CCP as a DMA resource
Date: Fri, 15 Apr 2016 22:30:16 +0800
Message-ID: <20160415143016.GB733@gondor.apana.org.au>
References: <20160405154146.18471.42588.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
	davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38427 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbcDOOaV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2016 10:30:21 -0400
Content-Disposition: inline
In-Reply-To: <20160405154146.18471.42588.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 05, 2016 at 10:42:38AM -0500, Gary R Hook wrote:
> The CCP has the ability to provide DMA services to the
> kernel using pass-through mode of the device. Register
> these services as general purpose DMA channels.

You forgot the Signed-off-by.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
