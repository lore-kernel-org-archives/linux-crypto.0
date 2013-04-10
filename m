From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif - suppress sending source address
 information in recvmsg
Date: Wed, 10 Apr 2013 11:31:48 +0800
Message-ID: <20130410033148.GA32360@gondor.apana.org.au>
References: <1365336339-403-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:37586 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755146Ab3DJDbx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Apr 2013 23:31:53 -0400
Content-Disposition: inline
In-Reply-To: <1365336339-403-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 07, 2013 at 02:05:39PM +0200, Mathias Krause wrote:
> The current code does not set the msg_namelen member to 0 and therefore
> makes net/socket.c leak the local sockaddr_storage variable to userland
> -- 128 bytes of kernel stack memory. Fix that.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
