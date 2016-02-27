From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif_hash - correctly handle algos without state
Date: Sat, 27 Feb 2016 17:10:39 +0000
Message-ID: <20160227171039.GA8420@gondor.apana.org.au>
References: <1456246916-16130-1-git-send-email-sasha.levin@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Sasha Levin <sasha.levin@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49570 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbcB0RKt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2016 12:10:49 -0500
Content-Disposition: inline
In-Reply-To: <1456246916-16130-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 23, 2016 at 12:01:56PM -0500, Sasha Levin wrote:
> Algorithms without state will cause the creation of a 0 sized array, which
> is undefined outside of structs.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Actually the state size should never be zero and we check it upon
algorithm registration, so how can this possibly happen?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
