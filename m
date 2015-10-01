From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - remove unneeded variable
Date: Thu, 1 Oct 2015 22:02:26 +0800
Message-ID: <20151001140226.GG27726@gondor.apana.org.au>
References: <20150930124000.14742.58408.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@intel.com,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40403 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbbJAOC3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 10:02:29 -0400
Content-Disposition: inline
In-Reply-To: <20150930124000.14742.58408.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 30, 2015 at 05:40:00AM -0700, Tadeusz Struk wrote:
> Remove unneeded variable val_indx.
> Issue found by a static analyzer.
> 
> Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
