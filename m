From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] arm: crypto: picoxcell: Update to the current clk API
Date: Sun, 21 Jun 2015 20:06:55 +0800
Message-ID: <20150621120655.GA30479@gondor.apana.org.au>
References: <1434722151-4309-1-git-send-email-michael@smart-africa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
	David Miller <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org
To: Michael van der Westhuizen <michael@smart-africa.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43432 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbbFUMHG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2015 08:07:06 -0400
Content-Disposition: inline
In-Reply-To: <1434722151-4309-1-git-send-email-michael@smart-africa.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 19, 2015 at 03:55:51PM +0200, Michael van der Westhuizen wrote:
> The picoXcell hardware crypto accelerator driver was using an
> older version of the clk framework, and not (un)preparing the
> clock before enabling/disabling it.  This change uses the handy
> clk_prepare_enable function to interact with the current clk
> framework correctly.
> 
> Signed-off-by: Michael van der Westhuizen <michael@smart-africa.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
