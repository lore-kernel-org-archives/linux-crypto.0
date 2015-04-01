From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: omap-sham: Use pm_runtime_irq_safe()
Date: Wed, 1 Apr 2015 22:24:26 +0800
Message-ID: <20150401142426.GA28651@gondor.apana.org.au>
References: <1427775745-4674-1-git-send-email-lokeshvutla@ti.com>
 <1427775745-4674-2-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-kernel@vger.kernel.org, nsekhar@ti.com, t-kristo@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49832 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbbDAOYb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Apr 2015 10:24:31 -0400
Content-Disposition: inline
In-Reply-To: <1427775745-4674-2-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 31, 2015 at 09:52:24AM +0530, Lokesh Vutla wrote:
> omap_sham_handle_queue() can be called as part of done_task tasklet.
> During this its atomic and any calls to pm functions cannot sleep.
> 
> But there is a call to pm_runtime_get_sync() (which can sleep) in
> omap_sham_handle_queue(), because of which the following appears:
> " [  116.169969] BUG: scheduling while atomic: kworker/0:2/2676/0x00000100"
> 
> Add pm_runtime_irq_safe() to avoid this.
> 
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
