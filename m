From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] crypto: ccp - Fix non static symbol warning
Date: Tue, 16 Aug 2016 17:52:26 +0800
Message-ID: <20160816095226.GC27042@gondor.apana.org.au>
References: <1470960009-17784-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Gary Hook <gary.hook@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43506 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbcHPJwg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Aug 2016 05:52:36 -0400
Content-Disposition: inline
In-Reply-To: <1470960009-17784-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 12, 2016 at 12:00:09AM +0000, Wei Yongjun wrote:
> Fixes the following sparse warning:
> 
> drivers/crypto/ccp/ccp-dev.c:62:14: warning:
>  symbol 'ccp_increment_unit_ordinal' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
