From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: Remove duplicate code of SG helpers functions
Date: Mon, 21 Sep 2015 23:09:15 +0800
Message-ID: <20150921150914.GA2836@gondor.apana.org.au>
References: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45897 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbbIUPJS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 11:09:18 -0400
Content-Disposition: inline
In-Reply-To: <1442581036-23789-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 18, 2015 at 02:57:08PM +0200, LABBE Corentin wrote:
> Hello
> 
> This patch series try to remove some duplicate code of some SG helpers functions.
> The first four patch replace custom functions by already in-tree helper functions.

Patches 1-3 applied.  Patch 4 should go through the s390 tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
