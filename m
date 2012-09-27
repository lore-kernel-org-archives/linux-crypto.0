From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] Optimize CRC32C calculation using PCLMULQDQ in
 crc32c-intel module
Date: Wed, 26 Sep 2012 22:45:51 -0700
Message-ID: <20120927054551.GI22311@gondor.apana.org.au>
References: <cover.1348599489.git.tim.c.chen@linux.intel.com>
 <1348609808.9977.205.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S. Miller" <davem@davemloft.net>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	James Guilford <james.guilford@intel.com>,
	David Cote <david.m.cote@intel.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Chaohong Guo <chaohong.guo@intel.com>,
	Austin Zhang <austin_zhang@linux.intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:45726 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753682Ab2I0FqA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2012 01:46:00 -0400
Content-Disposition: inline
In-Reply-To: <1348609808.9977.205.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 25, 2012 at 02:50:08PM -0700, Tim Chen wrote:
> This patch series optimized CRC32C calculations with PCLMULQDQ
> instruction for crc32c-intel module.  It speeds up the original
> implementation by 1.6x for 1K buffer and by 3x for buffer 4k or
> more.  The tcrypt module was enhanced for doing speed test
> on crc32c calculations.
> 
> Tim
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

All applied.  Thanks Tim!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
