From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crytpo: qat - Fix 64 bytes requests
Date: Tue, 25 Nov 2014 22:55:45 +0800
Message-ID: <20141125145545.GB8541@gondor.apana.org.au>
References: <20141121172557.1399.1849.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:41480 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaKYOzs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Nov 2014 09:55:48 -0500
Content-Disposition: inline
In-Reply-To: <20141121172557.1399.1849.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 21, 2014 at 09:25:57AM -0800, Tadeusz Struk wrote:
> Fix invalid inflights calculation for 64 bytes requests.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
