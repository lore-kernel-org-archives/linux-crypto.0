From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix CTX_ENABLES bits shift direction issue
Date: Sat, 12 Dec 2015 13:46:46 +0800
Message-ID: <20151212054646.GF17504@gondor.apana.org.au>
References: <1449812574-35124-1-git-send-email-pingchao.yang@intel.com>
 <566AEA24.3000507@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yang Pingchao <pingchao.yang@intel.com>,
	linux-crypto@vger.kernel.org, dan.carpenter@oracle.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60278 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbLLFqt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Dec 2015 00:46:49 -0500
Content-Disposition: inline
In-Reply-To: <566AEA24.3000507@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 11, 2015 at 07:22:12AM -0800, Tadeusz Struk wrote:
> On 12/10/2015 09:42 PM, Yang Pingchao wrote:
> > AE CTX bits should be 8-15 in CTX_ENABLES, so the mask value 0xff should be
> > left shifted 0x8
> > 
> > Reported-by:   Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Yang Pingchao <pingchao.yang@intel.com>
> > ---
> >  drivers/crypto/qat/qat_common/qat_hal.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Acked-by: Tadeusz Struk <tadeusz.struk@intel.com>

This patch isn't in patchworks so it needs to be resubmitted.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
