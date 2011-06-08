From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: picoxcell: fix possible invalid pointer
	dereference
Date: Wed, 8 Jun 2011 21:28:11 +0800
Message-ID: <20110608132811.GB9044@gondor.apana.org.au>
References: <1307359877-14946-1-git-send-email-jamie@jamieiles.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@kernel.org
To: Jamie Iles <jamie@jamieiles.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:43702 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab1FHN2Q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jun 2011 09:28:16 -0400
Content-Disposition: inline
In-Reply-To: <1307359877-14946-1-git-send-email-jamie@jamieiles.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 06, 2011 at 12:31:17PM +0100, Jamie Iles wrote:
> The completion callback will free the request so we must remove it from
> the completion list before calling the callback.
> 
> Cc: stable@kernel.org
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Patch applied.  Thanks Jamie!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
