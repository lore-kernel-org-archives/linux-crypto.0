From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: qat: Qat driver fixes.
Date: Mon, 15 Sep 2014 19:47:21 +0800
Message-ID: <20140915114721.GC4923@gondor.apana.org.au>
References: <20140910210559.25455.16693.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, bruce.w.allan@intel.com, qat-linux@intel.com,
	conor.mcloughlin@intel.com, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:46108 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbaIOLra (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Sep 2014 07:47:30 -0400
Content-Disposition: inline
In-Reply-To: <20140910210559.25455.16693.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 10, 2014 at 02:07:20PM -0700, Tadeusz Struk wrote:
> Hi,
> Updates for the qat driver.
> First patch enables all 32 IRQs by default.
> Second fixes a typo of tasklet variable.
> Third removes extra buffers for HW state for partial requests.
> ---
> 
> Tadeusz Struk (3):
>       crypto: qat: Enable all 32 IRQs
>       crypto: qat: Fix typo in name of tasklet_struct
>       crypto: qat: Removed unneeded partial state

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
