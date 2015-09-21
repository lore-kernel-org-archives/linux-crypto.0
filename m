From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - VF should never trigger SBR on PH
Date: Mon, 21 Sep 2015 23:04:53 +0800
Message-ID: <20150921150453.GB2703@gondor.apana.org.au>
References: <20150918155947.24663.97648.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	conor.mcloughlin@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44246 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbbIUPE7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 11:04:59 -0400
Content-Disposition: inline
In-Reply-To: <20150918155947.24663.97648.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 18, 2015 at 08:59:47AM -0700, Tadeusz Struk wrote:
> From: Conor McLoughlin <conor.mcloughlin@intel.com>
> 
> Don't allow to trigger SBR from a VF running in VMM context.
> 
> Signed-off-by: Conor McLoughlin <conor.mcloughlin@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied to crypto.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
