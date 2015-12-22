From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix some timeout tests
Date: Tue, 22 Dec 2015 21:23:05 +0800
Message-ID: <20151222132305.GB25829@gondor.apana.org.au>
References: <1450246190-60770-1-git-send-email-pingchao.yang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dan.carpenter@oracle.com, tadeusz.struk@intel.com,
	linux-crypto@vger.kernel.org, qat-linux@intel.com,
	kernel-janitors@vger.kernel.org
To: Yang Pingchao <pingchao.yang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33894 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbbLVNXi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Dec 2015 08:23:38 -0500
Content-Disposition: inline
In-Reply-To: <1450246190-60770-1-git-send-email-pingchao.yang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 16, 2015 at 02:09:50PM +0800, Yang Pingchao wrote:
> Change the timeout condition since the times value would be -1 after
> running MAX_RETRY_TIMES.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Yang Pingchao <pingchao.yang@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
