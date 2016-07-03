From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: omap-sham - increase cra_proirity to 400
Date: Sun, 3 Jul 2016 10:47:30 +0800
Message-ID: <20160703024730.GA24581@gondor.apana.org.au>
References: <1467216696-8014-1-git-send-email-b-liu@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Tero Kristo <t-kristo@ti.com>
To: Bin Liu <b-liu@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51706 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbcGCCrf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Jul 2016 22:47:35 -0400
Content-Disposition: inline
In-Reply-To: <1467216696-8014-1-git-send-email-b-liu@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 29, 2016 at 11:11:36AM -0500, Bin Liu wrote:
> Some software alg has cra_priority as higher as 300, so increase
> omap-sham priority to 400 to ensure it is on top of any software alg.
> 
> Signed-off-by: Bin Liu <b-liu@ti.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
