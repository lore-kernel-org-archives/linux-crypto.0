From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: dts - Addition of missing SEC compatibile
 property in c29x device tree
Date: Tue, 8 Jul 2014 21:21:11 +0800
Message-ID: <20140708132111.GA24110@gondor.apana.org.au>
References: <1404223643-32275-1-git-send-email-b44382@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, r66431@freescale.com,
	b16394@freescale.com
To: Nitesh Narayan Lal <b44382@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:47405 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbaGHNVT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jul 2014 09:21:19 -0400
Content-Disposition: inline
In-Reply-To: <1404223643-32275-1-git-send-email-b44382@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 01, 2014 at 07:37:23PM +0530, Nitesh Narayan Lal wrote:
> The driver is compatible with SEC version 4.0, which was missing from
> device tree resulting that the caam driver doesn't gets probed. Since
> SEC is backward compatible with older versions, so this patch adds those
> missing versions in c29x device tree.
> 
> Signed-off-by: Nitesh Narayan Lal <b44382@freescale.com>
> Signed-off-by: Vakul Garg <b16394@freescale.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
