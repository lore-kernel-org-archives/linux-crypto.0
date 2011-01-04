From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 05/32] crypto: mark crypto workqueues CPU_INTENSIVE
Date: Tue, 4 Jan 2011 15:38:55 +1100
Message-ID: <20110104043855.GC27632@gondor.apana.org.au>
References: <1294062595-30097-1-git-send-email-tj@kernel.org> <1294062595-30097-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:45948 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1ADEjA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Jan 2011 23:39:00 -0500
Content-Disposition: inline
In-Reply-To: <1294062595-30097-6-git-send-email-tj@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 03, 2011 at 02:49:28PM +0100, Tejun Heo wrote:
> kcrypto_wq and pcrypt->wq's are used to run ciphers and may consume
> considerable amount of CPU cycles.  Mark both as CPU_INTENSIVE so that
> they don't block other work items.
> 
> As the workqueues are primarily used to burn CPU cycles, concurrency
> levels shouldn't matter much and are left at 1.  A higher value may be
> beneficial and needs investigation.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
