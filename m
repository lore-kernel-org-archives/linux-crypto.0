From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/4] crypto: mcryptd - Fix load failure
Date: Mon, 1 Feb 2016 16:16:36 +0800
Message-ID: <20160201081636.GA5818@gondor.apana.org.au>
References: <1453885718-24599-1-git-send-email-rui.y.wang@intel.com>
 <1453885718-24599-3-git-send-email-rui.y.wang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Rui Wang <rui.y.wang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46806 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbcBAIQr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 03:16:47 -0500
Content-Disposition: inline
In-Reply-To: <1453885718-24599-3-git-send-email-rui.y.wang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 27, 2016 at 05:08:36PM +0800, Rui Wang wrote:
> mcryptd_create_hash() fails by returning -EINVAL, causing any
> driver using mcryptd to fail to load. It is because it needs
> to set its statesize properly.
> 
> Signed-off-by: Rui Wang <rui.y.wang@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
