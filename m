From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix adf_ctl_drv.c:undefined reference to
 adf_init_pf_wq
Date: Tue, 3 May 2016 16:16:52 +0800
Message-ID: <20160503081652.GC17166@gondor.apana.org.au>
References: <201604290313.pe3TL9PF%fengguang.wu@intel.com>
 <1461951820-11225-1-git-send-email-tadeusz.struk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, fengguang.wu@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51250 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbcECIRA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 04:17:00 -0400
Content-Disposition: inline
In-Reply-To: <1461951820-11225-1-git-send-email-tadeusz.struk@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 29, 2016 at 10:43:40AM -0700, Tadeusz Struk wrote:
> Fix undefined reference issue reported by kbuild test robot.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
