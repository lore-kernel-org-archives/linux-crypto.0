From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: picoxcell: fix boolean and / or confusion
Date: Tue, 20 Dec 2011 15:25:01 +0800
Message-ID: <20111220072501.GB3913@gondor.apana.org.au>
References: <1323770046-3548-1-git-send-email-jamie@jamieiles.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jamie Iles <jamie@jamieiles.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56477 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab1LTHZE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Dec 2011 02:25:04 -0500
Content-Disposition: inline
In-Reply-To: <1323770046-3548-1-git-send-email-jamie@jamieiles.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 13, 2011 at 09:54:06AM +0000, Jamie Iles wrote:
> The AES engine only supports 128 and 256 bit keys so we should correctly
> test for that.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Reported-by: Joe Perches <joe@perches.com>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
