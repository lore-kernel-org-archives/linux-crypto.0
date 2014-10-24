From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/2] crypto: caam - add support for gcm(aes)
Date: Fri, 24 Oct 2014 22:55:38 +0800
Message-ID: <20141024145538.GH21055@gondor.apana.org.au>
References: <20141010093615.6b8c6aee3b6842603fdd6982@freescale.com>
 <1414069883-1043-1-git-send-email-tudor.ambarus@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, kim.phillips@freescale.com,
	Horia Geanta <horia.geanta@freescale.com>
To: Tudor Ambarus <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:55925 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbaJXOzm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Oct 2014 10:55:42 -0400
Content-Disposition: inline
In-Reply-To: <1414069883-1043-1-git-send-email-tudor.ambarus@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 23, 2014 at 04:11:23PM +0300, Tudor Ambarus wrote:
> Add support for AES working in Galois Counter Mode.
> 
> There is a limitation related to IV size, similar to the one present in
> SW implementation (crypto/gcm.c):
> The only IV size allowed is 12 bytes. It will be padded by HW to the right
> with 0x0000_0001 (up to 16 bytes - AES block size), according to the GCM
> specification.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@freescale.com>
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
