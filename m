From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: blowfish: Fixed a multi line macro issue
Date: Fri, 8 Apr 2011 20:45:01 +0800
Message-ID: <20110408124501.GB19422@gondor.apana.org.au>
References: <1302158960-20479-1-git-send-email-aditya.shevade@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Aditya Shevade <aditya.shevade@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:45413 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab1DHMpI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Apr 2011 08:45:08 -0400
Content-Disposition: inline
In-Reply-To: <1302158960-20479-1-git-send-email-aditya.shevade@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 06, 2011 at 11:49:20PM -0700, Aditya Shevade wrote:
> Fixed a multi line macro with do-while loop.
> Fixed some other minor tab related issues.
> 
> Signed-off-by: Aditya Shevade <aditya.shevade@gmail.com>

Your patch doesn't even build!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
