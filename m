From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - remove unnecessary list iteration
Date: Tue, 28 Jul 2015 15:07:23 +0800
Message-ID: <20150728070723.GG25287@gondor.apana.org.au>
References: <20150727195832.30021.94483.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, bruce.w.allan@intel.com,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54560 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbbG1HH0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jul 2015 03:07:26 -0400
Content-Disposition: inline
In-Reply-To: <20150727195832.30021.94483.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 27, 2015 at 12:58:32PM -0700, Tadeusz Struk wrote:
> From: Bruce Allan <bruce.w.allan@intel.com>
> 
> There's no need to iterate through the list for instances in the
> accel_table since the number of devices is already known in this file.
> 
> Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
