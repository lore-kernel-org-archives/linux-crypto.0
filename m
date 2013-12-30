From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: crypto4xx_core: Remove redundant
 dev_set_drvdata
Date: Mon, 30 Dec 2013 20:20:05 +0800
Message-ID: <20131230122005.GA9766@gondor.apana.org.au>
References: <1387610550-13493-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com
To: Sachin Kamat <sachin.kamat@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:58768 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab3L3MUJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Dec 2013 07:20:09 -0500
Content-Disposition: inline
In-Reply-To: <1387610550-13493-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 21, 2013 at 12:52:28PM +0530, Sachin Kamat wrote:
> Driver core sets it to NULL upon probe failure or release.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
