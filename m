From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - remove superfluous initializers for
 xts(aes)
Date: Thu, 6 Dec 2012 17:20:27 +0800
Message-ID: <20121206092027.GE15870@gondor.apana.org.au>
References: <1353454171-24217-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Jarod Wilson <jarod@redhat.com>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:34469 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752627Ab2LFJUc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Dec 2012 04:20:32 -0500
Content-Disposition: inline
In-Reply-To: <1353454171-24217-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 21, 2012 at 12:29:31AM +0100, Mathias Krause wrote:
> The test vectors for 'xts(aes)' contain superfluous initializers.
> Remove them.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Cc: Jarod Wilson <jarod@redhat.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
