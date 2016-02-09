From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - Set ctx->e to NULL in qat_rsa_exit_tfm
Date: Tue, 9 Feb 2016 12:24:25 +0100
Message-ID: <20160209112424.GA10858@gondor.apana.org.au>
References: <1455016895-22090-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44843 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964868AbcBILYb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2016 06:24:31 -0500
Content-Disposition: inline
In-Reply-To: <1455016895-22090-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 09, 2016 at 11:21:35AM +0000, Salvatore Benedetto wrote:
> Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>

We already use kzfree on the tfm, so we can get rid of all these
manual zeroing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
