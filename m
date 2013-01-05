From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto api: add crc32 pclmulqdq implementation and
 wrappers for table implementation
Date: Sat, 5 Jan 2013 21:43:41 +1100
Message-ID: <20130105104341.GB28670@gondor.apana.org.au>
References: <50D338AE.3010907@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Andreas Dilger <andreas.dilger@intel.com>
To: Alexander Boyko <alexander_boyko@xyratex.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:43239 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755570Ab3AEKnu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Jan 2013 05:43:50 -0500
Content-Disposition: inline
In-Reply-To: <50D338AE.3010907@xyratex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 20, 2012 at 08:11:26PM +0400, Alexander Boyko wrote:
> From: Alexander Boyko <alexander_boyko@xyratex.com>
> 
> This patch adds crc32 algorithms to shash crypto api. One is wrapper to
> generic crc32_le function. Second is crc32 pclmulqdq implementation. It
> use hardware provided PCLMULQDQ instruction to accelerate the CRC32
> disposal. This instruction present from Intel Westmere and AMD Bulldozer
> CPUs.
> 
> For intel core i5 I got 450MB/s for table implementation and
> 2100MB/s for pclmulqdq implementation.
> 
> Signed-off-by: Alexander Boyko <alexander_boyko@xyratex.com>

Sorry, but your patch is white space damaged and cannot be applied.

You can test this yourself by sending a copy to your email address
and checking whether you can still apply it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
