From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 4/4] crypto: testmgr - Add a test case for
 import()/export()
Date: Mon, 1 Feb 2016 16:21:30 +0800
Message-ID: <20160201082130.GD5818@gondor.apana.org.au>
References: <1453885718-24599-1-git-send-email-rui.y.wang@intel.com>
 <1453885718-24599-5-git-send-email-rui.y.wang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Rui Wang <rui.y.wang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42333 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbcBAIVh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 03:21:37 -0500
Content-Disposition: inline
In-Reply-To: <1453885718-24599-5-git-send-email-rui.y.wang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 27, 2016 at 05:08:38PM +0800, Rui Wang wrote:
>
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index da0a8fd..451e7eb 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -44,6 +44,7 @@ struct hash_testvec {
>  	unsigned short psize;
>  	unsigned char np;
>  	unsigned char ksize;
> +	unsigned char partial;

Why not make it unconditional?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
