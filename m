From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 01/28] crypto: omap-aes: Fix registration of algorithms
Date: Tue, 7 Jun 2016 18:48:21 +0800
Message-ID: <20160607104821.GA520@gondor.apana.org.au>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
 <1464771389-10640-2-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, tony@atomide.com,
	linux-arm-kernel@lists.infradead.org, lokeshvutla@ti.com
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42543 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbcFGKsh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2016 06:48:37 -0400
Content-Disposition: inline
In-Reply-To: <1464771389-10640-2-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 01, 2016 at 11:56:02AM +0300, Tero Kristo wrote:
> From: Lokesh Vutla <lokeshvutla@ti.com>
> 
> Algorithms can be registered only once. So skip registration of
> algorithms if already registered (i.e. in case we have two AES cores
> in the system.)
> 
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> Signed-off-by: Tero Kristo <t-kristo@ti.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
