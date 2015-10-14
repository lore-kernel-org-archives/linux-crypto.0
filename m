From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto/jitterentropy-kcapi: remove unnecessary
 information from a comment
Date: Wed, 14 Oct 2015 22:27:06 +0800
Message-ID: <20151014142705.GC17455@gondor.apana.org.au>
References: <1444324345-20050-1-git-send-email-kuleshovmail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38907 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbbJNO1J (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 10:27:09 -0400
Content-Disposition: inline
In-Reply-To: <1444324345-20050-1-git-send-email-kuleshovmail@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 08, 2015 at 11:12:25PM +0600, Alexander Kuleshov wrote:
> The clocksource does not provide clocksource_register() function since
> f893598 commit (clocksource: Mostly kill clocksource_register()), so
> let's remove unnecessary information about this function from a comment.
> 
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
