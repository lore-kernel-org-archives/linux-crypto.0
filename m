From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v9 2/3] crypto: kpp - Add DH software implementation
Date: Mon, 20 Jun 2016 19:13:11 +0800
Message-ID: <20160620111310.GA10601@gondor.apana.org.au>
References: <1466174265-4546-1-git-send-email-salvatore.benedetto@intel.com>
 <1466174265-4546-3-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42773 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbcFTLNu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jun 2016 07:13:50 -0400
Content-Disposition: inline
In-Reply-To: <1466174265-4546-3-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 17, 2016 at 03:37:44PM +0100, Salvatore Benedetto wrote:
>
> +int crypto_dh_encode_key(char *buf, unsigned int len, const struct dh *params)
> +{
> +	struct kpp_secret *secret = (struct kpp_secret *)buf;

You can't do that.  The memory under buf may not be aligned so
you need to copy it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
