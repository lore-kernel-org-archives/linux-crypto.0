From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/7] Add support for qat_c3xxx and qat_c62x devices
Date: Wed, 9 Dec 2015 20:12:24 +0800
Message-ID: <20151209121224.GB27962@gondor.apana.org.au>
References: <20151205005612.27411.60451.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, pingchao.yang@intel.com,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37157 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbbLIMMs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 07:12:48 -0500
Content-Disposition: inline
In-Reply-To: <20151205005612.27411.60451.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 04, 2015 at 04:56:12PM -0800, Tadeusz Struk wrote:
> The following series adds support for the new
> qat_c3xxx and qat_c62x acceleration devices.
> 
> ---
> Pingchao Yang (1):
>       crypto: qat - add support for new devices to FW loader
> 
> Tadeusz Struk (6):
>       crypto: qat - add new device definitions
>       crypto: qat - move isr files to qat common so that they can be reused
>       crypto: qat - add support for c3xxx accel type
>       crypto: qat - add support for c62x accel type
>       crypto: qat - add support for c3xxxvf accel type
>       crypto: qat - add support for c62xvf accel type

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
