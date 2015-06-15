From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] remove nx842.h from include/linux
Date: Mon, 15 Jun 2015 18:19:09 +0800
Message-ID: <20150615101909.GA32751@gondor.apana.org.au>
References: <1434121127-14508-1-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52147 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbbFOKTT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 06:19:19 -0400
Content-Disposition: inline
In-Reply-To: <1434121127-14508-1-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 12, 2015 at 10:58:45AM -0400, Dan Streetman wrote:
> Now that the crypto/842.c driver does only software 842 comp/decomp,
> and the hardware crypto compressor for 842-nx is located in
> drivers/crypto/nx with the NX 842 hw driver, there's no reason for
> the nx842.h header to be located in include/linux/ anymore; nobody
> should use the NX 842 hw driver directly, everyone should use the
> crypto compression API.
> 
> The first patch moves the contents of include/linux/nx842.h into the
> existing drivers/crypto/nx/nx-842.h header file.  The second patch
> replaces the use of the NX842_MEM_COMPRESS define, since the 842-nx
> crypto compression driver can directly get the required working
> memory size from the NX 842 hw driver.
> 
> This cleans up include/linux/ by 1 file, and it saves some memory
> by reducing the 842-nx working memory size down to exactly what the
> NX 842 platform driver requires.
> 
> Dan Streetman (2):
>   crypto: move include/linux/nx842.h into drivers/crypto/nx/nx-842.h
>   crypto: replace NX842_MEM_COMPRESS with function

Both applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
