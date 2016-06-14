From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/3] hw_random: Add Amlogic Meson SoCs Random
 Generator driver
Date: Tue, 14 Jun 2016 18:33:06 +0800
Message-ID: <20160614103306.GA20732@gondor.apana.org.au>
References: <1465546915-24229-1-git-send-email-narmstrong@baylibre.com>
 <20160613123109.GA8674@gondor.apana.org.au>
 <m2wplsviy3.fsf@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Armstrong <narmstrong@baylibre.com>,
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Matt Mackall <mpm@selenic.com>
To: Kevin Hilman <khilman@baylibre.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43341 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbcFNKdO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2016 06:33:14 -0400
Content-Disposition: inline
In-Reply-To: <m2wplsviy3.fsf@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 13, 2016 at 03:10:28PM -0700, Kevin Hilman wrote:
> Could you take just the driver please?
> 
> Due to lots of other activity in the DT, I'd prefer to send the DT &
> bindings though the arm-soc (via the amlogic tree.)

OK I will back out these two patches.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
