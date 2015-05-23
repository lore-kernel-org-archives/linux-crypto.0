From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: move Kconfig 842 to end of list, default to N
Date: Sat, 23 May 2015 08:34:05 +0800
Message-ID: <20150523003405.GA12622@gondor.apana.org.au>
References: <1432339708-4340-1-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34644 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176AbbEWAef (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 May 2015 20:34:35 -0400
Content-Disposition: inline
In-Reply-To: <1432339708-4340-1-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 22, 2015 at 08:08:28PM -0400, Dan Streetman wrote:
> Move the 842 compression alg choice to last in the list, so it's
> not in the middle of LZO/LZ4/LZ4HC.  Change its default to N, as it
> is a very slow alg, which generally should only be used with
> compression hardware that's capable of doing it much faster.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>

The default default is "n" so this is redundant.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
