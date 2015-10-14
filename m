From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccm - remove goto
Date: Wed, 14 Oct 2015 22:13:43 +0800
Message-ID: <20151014141343.GA17325@gondor.apana.org.au>
References: <1444724305-3235-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44596 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbbJNONq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 10:13:46 -0400
Content-Disposition: inline
In-Reply-To: <1444724305-3235-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 13, 2015 at 01:48:25PM +0530, Sudip Mukherjee wrote:
> Instead of using goto and jumping to a label and then returning from
> there, lets return directly. The label out: is not used from anywhere
> else in the code.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

I don't think patch improves the code so I'm not taking it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
