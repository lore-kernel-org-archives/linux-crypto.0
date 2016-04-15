From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: qat - adf_dev_stop should not be called in
 atomic context
Date: Fri, 15 Apr 2016 22:34:03 +0800
Message-ID: <20160415143403.GC733@gondor.apana.org.au>
References: <20160406180154.8645.94988.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52906 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbcDOOeK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2016 10:34:10 -0400
Content-Disposition: inline
In-Reply-To: <20160406180154.8645.94988.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 06, 2016 at 11:01:54AM -0700, Tadeusz Struk wrote:
> VFs call adf_dev_stop() from a PF to VF interrupt bottom half.
> This causes an oops "scheduling while atomic", because it tries
> to acquire a mutex to un-register crypto algorithms.
> This patch fixes the issue by calling adf_dev_stop() asynchronously.

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
