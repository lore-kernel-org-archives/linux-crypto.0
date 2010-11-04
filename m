From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cast5: simplify if-statements
Date: Thu, 4 Nov 2010 13:59:19 -0500
Message-ID: <20101104185919.GA2464@gondor.apana.org.au>
References: <20101027120324.0b12a8b8@absol.kitzblitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Kartikey Mahendra Bhatt <kartik_me@hotmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nicolas Kaiser <nikai@nikai.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:57614 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab0KDS71 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Nov 2010 14:59:27 -0400
Content-Disposition: inline
In-Reply-To: <20101027120324.0b12a8b8@absol.kitzblitz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 27, 2010 at 12:03:24PM +0200, Nicolas Kaiser wrote:
> I noticed that by factoring out common rounds from the
> branches of the if-statements in the encryption and
> decryption functions, the executable file size goes down
> significantly, for crypto/cast5.ko from 26688 bytes
> to 24336 bytes (amd64).

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
