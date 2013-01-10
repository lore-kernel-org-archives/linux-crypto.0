From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4] crypto api: add crc32 pclmulqdq implementation and
 wrappers for table implementation
Date: Thu, 10 Jan 2013 09:54:56 -0800
Message-ID: <1357840496.17632.119.camel@schen9-DESK>
References: <50EED427.2040309@xyratex.com>  <50EED643.2010907@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Dilger <adilger@whamcloud.com>
To: Alexander Boyko <alexander_boyko@xyratex.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60920 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab3AJRzD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jan 2013 12:55:03 -0500
In-Reply-To: <50EED643.2010907@xyratex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On Thu, 2013-01-10 at 18:54 +0400, Alexander Boyko wrote:
> From: Alexander Boyko <alexander_boyko@xyratex.com>
> 
> This patch adds crc32 algorithms to shash crypto api. One is wrapper to
> gerneric crc32_le function. Second is crc32 pclmulqdq implementation. It
> use hardware provided PCLMULQDQ instruction to accelerate the CRC32 disposal.
> This instruction present from Intel Westmere and AMD Bulldozer CPUs.
> 
> For intel core i5 I got 450MB/s for table implementation and 2100MB/s 
> for pclmulqdq implementation (

Alexander,

Wonder if you have a chance to test performance of our PCLMULQDQ
implementation for crc32c that's in the current code (see
crc32c-pcl-intel-asm_64.asm). The throughput will probably be comparable
with your implementation.

Tim
