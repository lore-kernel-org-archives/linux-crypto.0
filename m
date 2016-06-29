From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Remove redundant sg_init_table call.
Date: Wed, 29 Jun 2016 18:18:39 +0800
Message-ID: <20160629101839.GA26917@gondor.apana.org.au>
References: <1467140083-4910-1-git-send-email-harshjain.prof@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, harshjain32@gmail.com
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35763 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbcF2KSo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:18:44 -0400
Content-Disposition: inline
In-Reply-To: <1467140083-4910-1-git-send-email-harshjain.prof@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 29, 2016 at 12:24:43AM +0530, Harsh Jain wrote:
> Remove redundant sg_init_table call. scatterwalk_ffwd doing the same.
> 
> Signed-off-by: Harsh Jain <harshjain.prof@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
