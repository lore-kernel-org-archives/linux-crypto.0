From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: qat - enable VF irq after guest exits
 ungracefully
Date: Mon, 14 Dec 2015 21:32:35 +0800
Message-ID: <20151214133235.GA1829@gondor.apana.org.au>
References: <20151210053830.16048.86205.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xin.zeng@intel.com, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40362 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbbLNNcm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Dec 2015 08:32:42 -0500
Content-Disposition: inline
In-Reply-To: <20151210053830.16048.86205.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 09, 2015 at 09:38:30PM -0800, Tadeusz Struk wrote:
> From: Zeng Xin <xin.zeng@intel.com>
> 
> The VF bundle interrupt is not triggered any more in
> the case when guest is shut down with sample app running.
> Need to clear the flag interrupt bit when restarting to fix
> this irrecoverable state.
> 
> Signed-off-by: Zeng Xin <xin.zeng@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
