From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: qat - use list_for_each_entry*
Date: Tue, 22 Dec 2015 21:25:18 +0800
Message-ID: <20151222132518.GD25829@gondor.apana.org.au>
References: <56744496.8090000@intel.com>
 <bebc7973675a17a9bc0b063e71d7dd9843e46192.1450512996.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Allan, Bruce W" <bruce.w.allan@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geliang Tang <geliangtang@163.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39091 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbbLVNZy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Dec 2015 08:25:54 -0500
Content-Disposition: inline
In-Reply-To: <bebc7973675a17a9bc0b063e71d7dd9843e46192.1450512996.git.geliangtang@163.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 19, 2015 at 04:22:51PM +0800, Geliang Tang wrote:
> Use list_for_each_entry*() instead of list_for_each*() to simplify
> the code.
> 
> Signed-off-by: Geliang Tang <geliangtang@163.com>
> ---
> Changes in v2:
>  - only to qat_crypto.c, and adf_ctl_drv.c.

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
