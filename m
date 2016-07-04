From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2 06/27] crypto: ahash: increase the maximum allowed
 statesize
Date: Mon, 4 Jul 2016 17:19:25 +0800
Message-ID: <20160704091925.GA31964@gondor.apana.org.au>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
 <1466601840-18486-7-git-send-email-t-kristo@ti.com>
 <20160624103209.GA19607@gondor.apana.org.au>
 <5770B283.8000902@ti.com>
 <20160627050031.GA5673@gondor.apana.org.au>
 <577A298E.4040803@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org,
	tony@atomide.com, davem@davemloft.net, lokeshvutla@ti.com,
	linux-arm-kernel@lists.infradead.org
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46854 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbcGDJT6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 05:19:58 -0400
Content-Disposition: inline
In-Reply-To: <577A298E.4040803@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 04, 2016 at 12:17:02PM +0300, Tero Kristo wrote:
>
> I need some clarification on this, afaik request_alloc related
> functionality only works per-request basis. The export / import
> functionality however is supposed to work across multiple requests.
> The test code for example does this:

Why are you trying to allocate memory in export/import at all?
The preferred approach is to unconditionally allocate the memory
in ahash_request_alloc.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
