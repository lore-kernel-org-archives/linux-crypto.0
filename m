From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [v2] crypto: cryptd - disable softirqs in
 cryptd_queue_worker to prevent data corruption
Date: Wed, 24 Oct 2012 21:14:20 +0800
Message-ID: <20121024131420.GD3251@gondor.apana.org.au>
References: <20121021174228.9770.3775.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Gurucharan Shetty <gurucharan.shetty@gmail.com>,
	stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:44860 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753307Ab2JXNO0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Oct 2012 09:14:26 -0400
Content-Disposition: inline
In-Reply-To: <20121021174228.9770.3775.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 21, 2012 at 08:42:28PM +0300, Jussi Kivilinna wrote:
> cryptd_queue_worker attempts to prevent simultaneous accesses to crypto
> workqueue by cryptd_enqueue_request using preempt_disable/preempt_enable.
> However cryptd_enqueue_request might be called from softirq context,
> so add local_bh_disable/local_bh_enable to prevent data corruption and
> panics.
> 
> Bug report at http://marc.info/?l=linux-crypto-vger&m=134858649616319&w=2
> 
> v2:
>  - Disable software interrupts instead of hardware interrupts
> 
> Cc: stable@vger.kernel.org
> Reported-by: Gurucharan Shetty <gurucharan.shetty@gmail.com>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Patch applied to crypto.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
