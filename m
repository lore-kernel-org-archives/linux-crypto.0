From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat: remove unused vairable.
Date: Fri, 13 May 2016 17:33:09 +0800
Message-ID: <20160513093309.GA14711@gondor.apana.org.au>
References: <1462994953-3195-1-git-send-email-falakreyaz@gmail.com>
 <8e99795a-ed3c-8990-300a-031d7f61531e@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Muhammad Falak R Wani <falakreyaz@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Geliang Tang <geliangtang@163.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43399 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbcEMJdc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 May 2016 05:33:32 -0400
Content-Disposition: inline
In-Reply-To: <8e99795a-ed3c-8990-300a-031d7f61531e@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 11, 2016 at 01:21:29PM -0700, Tadeusz Struk wrote:
> On 05/11/2016 12:28 PM, Muhammad Falak R Wani wrote:
> > Remove the unused variable ret, and return 0 explicitly.
> 
> Thanks for the patch. In this case it will be even better
> to change the adf_ctl_stop_devices() to a void function.
> ---8<---
> Subject: [PATCH] crypto: qat - change the adf_ctl_stop_devices to void
> 
> Change the adf_ctl_stop_devices to a void function.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
