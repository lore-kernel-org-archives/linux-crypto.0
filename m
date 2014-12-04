From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix problem with coalescing enable logic
Date: Thu, 4 Dec 2014 23:51:29 +0800
Message-ID: <20141204155129.GA22279@gondor.apana.org.au>
References: <20141203050847.10558.83640.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: joern@logfs.org, davem@davemloft.net, qat-linux@intel.com,
	dan.carpenter@oracle.com, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:37006 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaLDPvo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2014 10:51:44 -0500
Content-Disposition: inline
In-Reply-To: <20141203050847.10558.83640.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 02, 2014 at 09:08:48PM -0800, Tadeusz Struk wrote:
> Fixed issue reported by Dan Carpenter
> 
> 410          if (adf_get_cfg_int(accel_dev, "Accelerator0",
> 411				 ADF_ETRMGR_COALESCING_ENABLED_FORMAT,
> 412                              bank_num, &coalesc_enabled) && coalesc_enabled)
> This condition is reversed, so it only enables coalescing on error.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
