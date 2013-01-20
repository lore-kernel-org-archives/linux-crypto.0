From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4] crypto api: add crc32 pclmulqdq implementation and
 wrappers for table implementation
Date: Sun, 20 Jan 2013 11:13:19 +1100
Message-ID: <20130120001319.GD26742@gondor.apana.org.au>
References: <50EED427.2040309@xyratex.com>
 <50EED643.2010907@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Andreas Dilger <adilger@whamcloud.com>
To: Alexander Boyko <alexander_boyko@xyratex.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:42205 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751389Ab3ATANY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 19:13:24 -0500
Content-Disposition: inline
In-Reply-To: <50EED643.2010907@xyratex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 10, 2013 at 06:54:59PM +0400, Alexander Boyko wrote:
> From: Alexander Boyko <alexander_boyko@xyratex.com>
> 
> This patch adds crc32 algorithms to shash crypto api. One is wrapper to
> gerneric crc32_le function. Second is crc32 pclmulqdq implementation. It
> use hardware provided PCLMULQDQ instruction to accelerate the CRC32 disposal.
> This instruction present from Intel Westmere and AMD Bulldozer CPUs.
> 
> For intel core i5 I got 450MB/s for table implementation and 2100MB/s 
> for pclmulqdq implementation.
> 
> Signed-off-by: Alexander Boyko <alexander_boyko@xyratex.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
