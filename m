From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos - corrrectly handle zero-length assoc
 data
Date: Thu, 28 Nov 2013 22:25:46 +0800
Message-ID: <20131128142546.GD32124@gondor.apana.org.au>
References: <1348080820-22250-4-git-send-email-horia.geanta@freescale.com>
 <1384865869-24802-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:53639 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3K1OZs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Nov 2013 09:25:48 -0500
Content-Disposition: inline
In-Reply-To: <1384865869-24802-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 19, 2013 at 02:57:49PM +0200, Horia Geanta wrote:
> talitos does not handle well zero-length assoc data. From dmesg:
> talitos ffe30000.crypto: master data transfer error
> talitos ffe30000.crypto: gather return/length error
> 
> Check whether assoc data is provided by inspecting assoclen,
> not assoc pointer.
> This is needed in order to pass testmgr tests.
> 
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
