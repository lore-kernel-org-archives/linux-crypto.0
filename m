From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - Stop dropping leading zeros from RSA output
Date: Mon, 11 Jul 2016 18:08:25 +0800
Message-ID: <20160711100825.GC21032@gondor.apana.org.au>
References: <1467903137-2110-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36527 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933694AbcGKKIh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jul 2016 06:08:37 -0400
Content-Disposition: inline
In-Reply-To: <1467903137-2110-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 07, 2016 at 03:52:17PM +0100, Salvatore Benedetto wrote:
> There is not need to drop leading zeros from the RSA output
> operations results.
> 
> Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
