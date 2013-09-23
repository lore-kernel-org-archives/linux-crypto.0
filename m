From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: caam - map src buffer before access
Date: Tue, 24 Sep 2013 06:08:18 +1000
Message-ID: <20130923200818.GA21243@gondor.apana.org.au>
References: <1378927446-21209-1-git-send-email-yashpal.dutta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Yashpal Dutta <yashpal.dutta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:35680 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753448Ab3IWUI5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Sep 2013 16:08:57 -0400
Content-Disposition: inline
In-Reply-To: <1378927446-21209-1-git-send-email-yashpal.dutta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 11, 2013 at 07:24:06PM +0000, Yashpal Dutta wrote:
> KMap the buffers before copying trailing bytes during hmac into a session
> temporary buffer. This is required if pinned buffer from user-space is send
> during hmac and is safe even if hmac request is generated from within kernel.
> 
> Signed-off-by: Yashpal Dutta <yashpal.dutta@freescale.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
