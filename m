From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 3/4] crypto: algif_hash - wait for crypto_ahash_init()
 to complete
Date: Mon, 1 Feb 2016 16:17:03 +0800
Message-ID: <20160201081703.GB5818@gondor.apana.org.au>
References: <1453885718-24599-1-git-send-email-rui.y.wang@intel.com>
 <1453885718-24599-4-git-send-email-rui.y.wang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Rui Wang <rui.y.wang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44329 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbcBAIRJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 03:17:09 -0500
Content-Disposition: inline
In-Reply-To: <1453885718-24599-4-git-send-email-rui.y.wang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 27, 2016 at 05:08:37PM +0800, Rui Wang wrote:
> hash_sendmsg/sendpage() need to wait for the completion
> of crypto_ahash_init() otherwise it can cause panic.
> 
> Signed-off-by: Rui Wang <rui.y.wang@intel.com>

Applied to crypto.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
