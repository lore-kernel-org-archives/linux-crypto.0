From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3 v2] Optimize CRC32C calculation using PCLMULQDQ in
 crc32c-intel module
Date: Mon, 15 Oct 2012 22:31:35 +0800
Message-ID: <20121015143135.GA25426@gondor.apana.org.au>
References: <cover.1348784343.git.tim.c.chen@linux.intel.com>
 <1348785854.17632.15.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	David Cote <david.m.cote@intel.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Chaohong Guo <chaohong.guo@intel.com>,
	Austin Zhang <austin_zhang@linux.intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Min Li <min.a.li@intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:58133 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750896Ab2JOOcX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Oct 2012 10:32:23 -0400
Content-Disposition: inline
In-Reply-To: <1348785854.17632.15.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 27, 2012 at 03:44:14PM -0700, Tim Chen wrote:
> Version 2
> This version of the patch series fixes compilation errors for
> 32 bit x86 targets.
> 
> Version 1
> This patch series optimized CRC32C calculations with PCLMULQDQ
> instruction for crc32c-intel module.  It speeds up the original
> implementation by 1.6x for 1K buffer and by 3x for buffer 4k or
> more.  The tcrypt module was enhanced for doing speed test
> on crc32c calculations.
> 
> Tim
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
