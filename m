From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: mv_cesa - Staticize local symbols
Date: Tue, 24 Sep 2013 06:08:51 +1000
Message-ID: <20130923200851.GB21243@gondor.apana.org.au>
References: <1379072207-11179-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Sachin Kamat <sachin.kamat@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:50348 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753449Ab3IWUI5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Sep 2013 16:08:57 -0400
Content-Disposition: inline
In-Reply-To: <1379072207-11179-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 13, 2013 at 05:06:45PM +0530, Sachin Kamat wrote:
> Local symbols used only in this file are made static.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
