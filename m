From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix bug in ADF_RING_SIZE_BYTES_MIN macro
Date: Tue, 28 Jul 2015 15:06:50 +0800
Message-ID: <20150728070650.GD25287@gondor.apana.org.au>
References: <20150724201825.27624.22237.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Bruce Allan <bruce.w.allan@intel.com>, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41874 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbbG1HGw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jul 2015 03:06:52 -0400
Content-Disposition: inline
In-Reply-To: <20150724201825.27624.22237.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 24, 2015 at 01:18:25PM -0700, Tadeusz Struk wrote:
> From: Bruce Allan <bruce.w.allan@intel.com>
> 
> The subject macro mistakenly compares the passed-in ring size in bytes
> with ADF_RING_SIZE_4K which is 0x6 (an internal representation of 4KB)
> rather than comparing with the intended value of 4096.
> 
> Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
