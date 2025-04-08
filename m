Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749A11F94A;
	Tue,  8 Apr 2025 05:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744089451; cv=none; b=e6JeGj1HPCaACVqpYbO53Vg/quZCOY0K1QDbd4V7Bo6l8yQNrMkizsZ/U4uz/nSWDL0HJcfT+IFDW2iNrwsLYSZDQ5t/AVlHi+yDXHUyUnqav7EksxfaquBzhX+GWsRLtxrXtUYRcsyqtKjgP8n75Lb9vtjL4S7yb6Iy7BUlwwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744089451; c=relaxed/simple;
	bh=qI+vY1A5wV0XjhjSNpeKTMGZXi9Vm/a4ANb9gFFEK68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PHmeZsR3bF0+QWXUaciYIyU++QX8d8FVCzSyNQBfpdVSXRbpE3UOze4X27gVRK02/s0KBYnKSFtEWFHrHrvOOtEvjAVqwyAE9V17vhrIamZVt3me/J3bXKkvERq2bkMtRVzQfixm2AVHkbdG9aqj/fyK2uwmNOGYP0hlJ1onkqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ag68ibvF; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ag68ibvF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hN70HOkvOYMaSx7AQ3/aqo4uy4shGsHTRJRTiN34J38=; b=ag68ibvF7mJP9kd4/HQZGKIdCX
	oNm/GvJdnc75UPKok67c9rz1Wucb7mRkfD5J7Hs6iyPFz21ueTPr1qMKY2ccJlLgBWkPWj6OA9Nj+
	FFlGI2ttSw+vERbp36os+PNumVZVCewA/9KukHP7dZQnTkHoj+MRQnwJrQSDLtTeL8jEJYr13BHLI
	b5nUQZu62cVZdnSpabvIw08puNZDTcrrpTy6L6ny7ZLtpJ/z00NYdKbkj64Lle/8NqOmvJDQMng8c
	SWTyI74CyT7HyyfjsndbkjEmdp+en1CNBF6vBdNtQsddl744GkscipNhVURRFbmciGs29UCf4AYRu
	W1/ERTeg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u21Kq-00DmDt-0s;
	Tue, 08 Apr 2025 13:17:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 08 Apr 2025 13:17:20 +0800
Date: Tue, 8 Apr 2025 13:17:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sean Anderson <sean.anderson@linux.dev>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>
Subject: [PATCH] crypto: caam/qi - Fix drv_ctx refcount bug
Message-ID: <Z_SxYFdyBJTYe_7G@gondor.apana.org.au>
References: <17f9af67-de10-4b96-99ef-3c5cd78124c0@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17f9af67-de10-4b96-99ef-3c5cd78124c0@linux.dev>

On Mon, Apr 07, 2025 at 07:16:38PM -0400, Sean Anderson wrote:
>
> [    2.731344] refcount_t: decrement hit 0; leaking memory.

...

> [    2.731496] caam_rsp_fq_dqrr_cb (include/linux/refcount.h:336 include/linux/refcount.h:351 drivers/crypto/caam/qi.c:593) 
> [    2.731502] qman_p_poll_dqrr (drivers/soc/fsl/qbman/qman.c:1652 drivers/soc/fsl/qbman/qman.c:1759) 
> [    2.731510] caam_qi_poll (drivers/crypto/caam/qi.c:491) 
> [    2.731514] __napi_poll (net/core/dev.c:7328) 
> [    2.731520] net_rx_action (net/core/dev.c:7394 net/core/dev.c:7514) 
> [    2.731524] handle_softirqs (arch/arm64/include/asm/jump_label.h:36 include/trace/events/irq.h:142 kernel/softirq.c:562) 
> [    2.731530] __do_softirq (kernel/softirq.c:596) 
> [    2.731533] ____do_softirq (arch/arm64/kernel/irq.c:82) 
> [    2.731538] call_on_irq_stack (arch/arm64/kernel/entry.S:897) 
> [    2.731542] do_softirq_own_stack (arch/arm64/kernel/irq.c:87) 
> [    2.731547] __irq_exit_rcu (kernel/softirq.c:442 kernel/softirq.c:662) 
> [    2.731550] irq_exit_rcu (kernel/softirq.c:681) 
> [    2.731554] el1_interrupt (arch/arm64/kernel/entry-common.c:565 arch/arm64/kernel/entry-common.c:575) 
> [    2.731561] el1h_64_irq_handler (arch/arm64/kernel/entry-common.c:581) 
> [    2.731567] el1h_64_irq (arch/arm64/kernel/entry.S:596) 
> [    2.731570] qman_enqueue (drivers/soc/fsl/qbman/qman.c:2354) (P)
> [    2.731576] caam_qi_enqueue (drivers/crypto/caam/qi.c:125) 

So caam_qi_enqueue hasn't had a chance to increment the refcount
and the IRQ already came in to decrement it.  Lesson is that you
should always increment your refcount before you give it away.

---8<---
Ensure refcount is raised before request is enqueued since it could
be dequeued before the call returns.

Reported-by: Sean Anderson <sean.anderson@linux.dev>
Cc: <stable@vger.kernel.org>
Fixes: 11144416a755 ("crypto: caam/qi - optimize frame queue cleanup")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 7701d00bcb3a..b6e7c0b29d4e 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -122,12 +122,12 @@ int caam_qi_enqueue(struct device *qidev, struct caam_drv_req *req)
 	qm_fd_addr_set64(&fd, addr);
 
 	do {
+		refcount_inc(&req->drv_ctx->refcnt);
 		ret = qman_enqueue(req->drv_ctx->req_fq, &fd);
-		if (likely(!ret)) {
-			refcount_inc(&req->drv_ctx->refcnt);
+		if (likely(!ret))
 			return 0;
-		}
 
+		refcount_dec(&req->drv_ctx->refcnt);
 		if (ret != -EBUSY)
 			break;
 		num_retries++;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
