From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: omap-aes: add error check for pm_runtime_get_sync
Date: Thu, 5 Dec 2013 22:36:32 +0800
Message-ID: <20131205143632.GF1976@gondor.apana.org.au>
References: <1386121393-32464-1-git-send-email-nm@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	Joel F <joelf@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
To: Nishanth Menon <nm@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:52397 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab3LEOgl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Dec 2013 09:36:41 -0500
Content-Disposition: inline
In-Reply-To: <1386121393-32464-1-git-send-email-nm@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 03, 2013 at 07:43:13PM -0600, Nishanth Menon wrote:
> The AES driver currently assumes that pm_runtime_get_sync will always
> succeed, which may not always be true, so add error handling for the
> same.
> 
> This scenario was reported in the following bug:
> place.  https://bugzilla.kernel.org/show_bug.cgi?id=66441
> 
> Reported-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
> Signed-off-by: Nishanth Menon <nm@ti.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
