From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - remove redundant function call
Date: Mon, 25 Jan 2016 22:47:39 +0800
Message-ID: <20160125144739.GC8840@gondor.apana.org.au>
References: <1452074180-114970-1-git-send-email-pingchao.yang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Yang Pingchao <pingchao.yang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47122 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbcAYOrm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 09:47:42 -0500
Content-Disposition: inline
In-Reply-To: <1452074180-114970-1-git-send-email-pingchao.yang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 06, 2016 at 05:56:20PM +0800, Yang Pingchao wrote:
> adf_dev_restore(accel_dev) was called in adf_dev_shutdown,no
> need to call it in adf_device_reset_worker after adf_dev_shutdown
> was called.
> 
> Signed-off-by: Yang Pingchao <pingchao.yang@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
