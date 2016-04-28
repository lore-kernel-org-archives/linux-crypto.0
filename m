From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix invalid pf2vf_resp_wq logic
Date: Thu, 28 Apr 2016 09:21:26 +0800
Message-ID: <20160428012126.GA5940@gondor.apana.org.au>
References: <1461594739-7616-1-git-send-email-tadeusz.struk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org,
	sureshx.marikkannu@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53055 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbcD1BVd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Apr 2016 21:21:33 -0400
Content-Disposition: inline
In-Reply-To: <1461594739-7616-1-git-send-email-tadeusz.struk@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 25, 2016 at 07:32:19AM -0700, Tadeusz Struk wrote:
> The pf2vf_resp_wq is a global so it has to be created at init
> and destroyed at exit, instead of per device.
> 
> Cc: <stable@vger.kernel.org>
> 
> Tested-by: Suresh Marikkannu <sureshx.marikkannu@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
