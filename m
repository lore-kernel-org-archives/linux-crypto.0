From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: user - no parsing of CRYPTO_MSG_GETALG
Date: Tue, 31 May 2016 18:14:44 +0800
Message-ID: <20160531101444.GB15376@gondor.apana.org.au>
References: <2794859.sgsFI1z3Ep@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38170 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbcEaKPB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 06:15:01 -0400
Content-Disposition: inline
In-Reply-To: <2794859.sgsFI1z3Ep@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 16, 2016 at 02:53:36AM +0200, Stephan Mueller wrote:
> The CRYPTO_MSG_GETALG netlink message type provides a buffer to the
> kernel to retrieve information from the kernel. The data buffer will not
> provide any input and will not be read. Hence the nlmsg_parse is not
> applicable to this netlink message type.
> 
> This patch fixes the following kernel log message when using this
> netlink interface:
> 
> netlink: 208 bytes leftover after parsing attributes in process `XXX'.
> 
> Patch successfully tested with libkcapi from [1] which uses
> CRYPTO_MSG_GETALG to obtain cipher-specific information from the kernel.
> 
> [1] http://www.chronox.de/libkcapi.html
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
