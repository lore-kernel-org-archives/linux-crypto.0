From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V3] crypto/nx842: Add CRC and validation support
Date: Wed, 14 Oct 2015 22:27:18 +0800
Message-ID: <20151014142718.GD17455@gondor.apana.org.au>
References: <1444337151.10131.10.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, ddstreet@ieee.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	hbabu@us.ibm.com
To: Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35934 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbbJNO11 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 10:27:27 -0400
Content-Disposition: inline
In-Reply-To: <1444337151.10131.10.camel@hbabu-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 08, 2015 at 01:45:51PM -0700, Haren Myneni wrote:
> 
> This patch adds CRC generation and validation support for nx-842.
> Add CRC flag so that nx842 coprocessor includes CRC during compression
> and validates during decompression.
> 
> Also changes in 842 SW compression to append CRC value at the end
> of template and checks during decompression.
> 
> Signed-off-by: Haren Myneni <haren@us.ibm.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
