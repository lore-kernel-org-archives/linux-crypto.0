From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] RSA: Don't select non-existent symbol
Date: Fri, 30 May 2014 17:18:54 +0800
Message-ID: <20140530091853.GA12760@gondor.apana.org.au>
References: <20140522182515.626f0728@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	David Howells <dhowells@redhat.com>
To: Jean Delvare <jdelvare@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:50020 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaE3JTD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2014 05:19:03 -0400
Content-Disposition: inline
In-Reply-To: <20140522182515.626f0728@endymion.delvare>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 22, 2014 at 06:25:15PM +0200, Jean Delvare wrote:
> You can select MPILIB_EXTRA all you want, it doesn't exist ;-)
> 
> Surprised kconfig doesn't complain about that...
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>

This patch should go to David Howells <dhowells@redhat.com>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
