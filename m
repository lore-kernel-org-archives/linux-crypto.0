From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - enable legacy VFs
Date: Tue, 25 Aug 2015 21:16:35 +0800
Message-ID: <20150825131635.GB13824@gondor.apana.org.au>
References: <20150824185602.30820.25788.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47311 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbbHYNQj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Aug 2015 09:16:39 -0400
Content-Disposition: inline
In-Reply-To: <20150824185602.30820.25788.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 24, 2015 at 11:56:02AM -0700, Tadeusz Struk wrote:
> We need to support legacy VFs as well as VFs running on different OSes.
> To do so the compatibility check need needs to be relaxed.
> This patch moves the logic responsible for VF to PF version and
> compatibility checking from adfsriov.c to adf_pf2vf_msg.c,
> where it belongs, and changes the logic enable legacy VFs.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
