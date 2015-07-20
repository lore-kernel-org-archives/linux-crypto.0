From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: crypto: qat - Add support for RSA algorithm
Date: Mon, 20 Jul 2015 09:13:32 -0700
Message-ID: <55AD1E2C.5090302@intel.com>
References: <20150720151236.GA5464@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9468 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbbGTQOF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jul 2015 12:14:05 -0400
In-Reply-To: <20150720151236.GA5464@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/20/2015 08:12 AM, Dan Carpenter wrote:
> The patch a990532023b9: "crypto: qat - Add support for RSA algorithm"
> from Jul 15, 2015, leads to the following Smatch warning:
> 
> 	drivers/crypto/qat/qat_common/qat_asym_algs.c:446 qat_rsa_get_n()
> 	warn: was && intended here instead of ||?
> 
> drivers/crypto/qat/qat_common/qat_asym_algs.c
>    444          ret = -EINVAL;
>    445          /* In FIPS mode only allow key size 2K & 3K */
>    446          if (fips_enabled && (ctx->key_sz != 256 || ctx->key_sz != 384)) {
>                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Looks like the static checker is correct.

The logic is if fips_enabled we want to accept only key size 2K (256 bytes) or 3K (384 bytes)
so the condition looks ok to me. Maybe the comment above is misleading?
regards,
T
