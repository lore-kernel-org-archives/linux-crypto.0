From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: picoxcell: fix possible invalid pointer
	dereference
Date: Wed, 10 Aug 2011 19:02:10 +0800
Message-ID: <20110810110210.GB2649@gondor.apana.org.au>
References: <1312280946-4451-1-git-send-email-jamie@jamieiles.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jamie Iles <jamie@jamieiles.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56617 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1HJLCM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Aug 2011 07:02:12 -0400
Content-Disposition: inline
In-Reply-To: <1312280946-4451-1-git-send-email-jamie@jamieiles.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 02, 2011 at 11:29:06AM +0100, Jamie Iles wrote:
> The completion callback will free the request so we must remove it from
> the completion list before calling the callback.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Also applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
