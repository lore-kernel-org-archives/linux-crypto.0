From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 4/4] crypto: qat - Add new algif interface for
 userspace
Date: Fri, 7 Nov 2014 10:56:08 +0800
Message-ID: <20141107025607.GA9474@gondor.apana.org.au>
References: <20141106195931.13328.90501.stgit@tstruk-mobl1>
 <20141106195953.13328.77022.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:34429 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaKGC4O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 21:56:14 -0500
Content-Disposition: inline
In-Reply-To: <20141106195953.13328.77022.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 06, 2014 at 11:59:53AM -0800, Tadeusz Struk wrote:
> Add new socket algif interface for userspace for symmetric and asymmetric
> crypto.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

No this is not acceptable.  algif is meant to expose generic
algorithms to user-space not a specific hardware implementation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
