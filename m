Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794045771;
	b=VKOwRzWac13R0Xj89TjLktk1aIgRECmHw6V0zrGPZVllly3A3O4IvIsPOue7p1fPvF5H
	 XkX9yU6K3L76fNwckZOWv0ouRBSc7DdkMi10CfKgqC+CX7cAZZT1EW0Zph6oVZhCm1DYy
	 0d50cRv3QfnYvNGEbR8qdJZYphUycQxEpDI/dZ4N1XkrWfnMYGlXGu7UKdtVTv4yLsJ5k
	 RVY5KqoAJDXtN+qwMSlKrM+/f9/+Te46ADZhG32QUOc5wW5FRF2ojnMd/MbgmtYlciFlU
	 ORT/jzIqLvpWlZn941PVUgRxeHYtmpZksbHH3hK1fVPZC7R7bhDN5QJzsrMGqlGwv5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794045771;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=N2J859H+uWsojSkha9zezH8TJJ6OSnMwegHD1qKOF64=;
	b=SvrYFuIJ/30fzVJO3BhYLPIcSmn99o4+uEzivAvIdmIPA7wUgCk4DDj2thjCPiWDbKN0
	 yGE08U+qlBcGFMuet6C5XwQmeNt+gWnGuNA4hightIqynakV2K+nvh/Mo8O5GwSm6u2A4
	 B8uyNNLsyMRFbaIrxy5APOL+v7EOO+V+d2dx6AfS20jPCOt4GVmcoxzN0kRwgNQiAfnF0
	 WyAku+ScBvd7T1SmlJtaFLCNcGPcvZPXXk19q7csRNaQzD+tg8wtuWWiySkCbmYE3PxLS
	 hZKJ1lrzcICNDOBXXpLU9v4HZdf95fUDG9aTJgJhrLl6s1Ubix9dmUliSXLSRECz52g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BwDzbLFR;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9DB606A326
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 10:02:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C9DB606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BwDzbLFR
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc7d154ec4fso587422a12.0
        for <linux-crypto@vger.kernel.org>; Sat, 07 Nov 2026 02:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794045770; x=1794650570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=N2J859H+uWsojSkha9zezH8TJJ6OSnMwegHD1qKOF64=;
        b=BwDzbLFRwEm//pUHT/71T3R10Z48hOxXLkQanXNmEMP3e7yH8k/yoBAwpcFgjW4WbD
         R2Ik4Dbi3HIh1w1ElO7YBKep/CfBTeIcKxofrcBMfwXsyDmSZe+ACOOd+rd7sppKs6vm
         o2NE54yUzVwiWuTlrKJDaKoyD9uqSDZLqaxwmMRdZmW3+jBPTh47wl5vtzCZ+dCIYRpM
         8fOV79WMXPFsRQL8vcs09QSBTyaNJZT10cPOSD0HtDVehu0Kxw3qYK+fe+30uwCD53ng
         m97+DK+DwFI+NeOniuMHWRGaprl+tqsM9I7ova4WtaL/z2/UOs1JMGyIYow6CjZb6E4f
         eXcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794045770; x=1794650570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N2J859H+uWsojSkha9zezH8TJJ6OSnMwegHD1qKOF64=;
        b=QcybLO/HgJjAwT5MN3TxidKuqmbxQph4bSLBohSxYq+S4QXzJNyOy4R2FwPWw+6bsF
         CVUUUZYcETgG7AVgWdlljm8U2n+rn/t0enBA4i69R7/jylkCL4rDNOxiZjDFiHQAMgHF
         kQCgYhILlMPW5517PYfigjjtuwxfI92rsc6bzoBLWjeE8ChnikkprtMJ3pPnPA2e+rfS
         Ih5GTQG1SvL9aVaZknR57NIXxNnBDiSLuYyT3qaOI2M8u37EvTyU5jdPEUXl3A/haMfG
         PKo/VhvoiMmKMfzGJFb/2S7hAX78hjxtiNYNDwpeC6VgJSh0vSG5KqkUs9+MwMVZqJ6R
         xz0g==
X-Forwarded-Encrypted: i=1; AL+hErFShTybGGvbqrOYSZXHOzPBNQwm4awOD8ZD6D3IhPs1g0pw2p8EyKoplgsq1DvwDFg2b9wDi3JZeSQswVM=@vger.kernel.org
X-Gm-Message-State: APuU4Z9VejybzZLmnm3PDc3YLKvRjr5B/NJoUrp/PzV+j0SIYYqj6G/l
	IluODH6+MuR1XboY3CyMonZejtwnsuiIpBecpqTx5Vhu23VO3XENftyXbBnuNXrb
X-Gm-Gg: AYBFou1c173fXupI5rWbD3V1kTrlIwG39hGYUsZZbvKCFDRDrcClEpV1RQ7izz91yFb
	/ljjAlYYe8Y0SGf7IM2Q5VFZOlzl+NRtbBWCHKGsI2MnhTxBTsitoj3owREGi7o29Vbo5B0VBU5
	vqkGS1wZ7MQyc62ZHjor1jBxSdX6ifHOqFZ2vn9VkTcg8SEUYQX+6VH7Z8LQ/LYsI8ewHGOFfxu
	VfdXsAvSkIYJB/QPfpblZa9sUt5ssL+0HQh/u/y1Ey3EvMoxFeDcovkEQ8MAN6vwTbwq1pQTDoa
	bs50vjYAcM68CxmZSHAidxdh5XnAdpNopPVZbA6p5NglLYrswQWjwOg57y6ri50WNRwQK1fuzql
	QI0VlDZl/ngnvwwX2Os/JpMidtZszfStc48PkCFDVzhEymK5WwJyWZDGL3HePL+xscrNoXtRyhv
	q0vPKeS7EYWromVOiSTHaepQNlq7uP+o2QsOqfs9bIoPpmnhRX/CjGF5/BINSUVLH4hbYI+za/P
	edBKdzKdRVjNlOHDUt+jX6sv6IPb1/a46wGaEVEkDGVPRNoLrcKFCOPuizRgVCzCaDx+OReUVzK
	1DtWyrG5Eoi3eqNKzlpkRXsEbiqzKauIzX7HJL0Rd0WjXUtPeExIcYvpP3/Gc9ZZMqNWYw==
X-Received: by 2002:a17:90b:530c:b0:3ab:2737:3393 with SMTP id 98e67ed59e1d1-3b0db6f4c26mr4969368a91.40.1794045770439;
        Sat, 07 Nov 2026 02:02:50 -0800 (PST)
Received: from hj.. ([163.239.22.29])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1152fa888sm142705a91.9.2026.11.07.02.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 02:02:49 -0800 (PST)
From: hyunjungg <hj351016@gmail.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Hyunjung Ko <hj351016@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] hwrng: cctrng - cancel deferred works on unbind to avoid use-after-free
Date: Sat,  7 Nov 2026 19:02:38 +0900
Message-ID: <20261107100238.3542588-1-hj351016@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hyunjung Ko <hj351016@gmail.com>

cctrng schedules two deferred works that dereference the driver data via
container_of(): compwork (cc_trng_compwork_handler) is queued from the
interrupt handler cc_isr() on an RNG completion interrupt, and startwork
(cc_trng_startwork_handler) is queued from the hwrng read path.

The driver data is allocated with devm_kzalloc() and nothing ever cancels
these works. On unbind, cctrng_remove() only runs the PM teardown, and
devres then releases the hwrng registration, the IRQ and finally the
driver data. free_irq() stops further interrupts but does not cancel a
work the handler has already queued, so a completion interrupt arriving
shortly before removal can leave compwork pending and have
cc_trng_compwork_handler() run against the freed cctrng_drvdata
(use-after-free). The hwrng core does not drain this driver-private work.

Register the works with devm_work_autocancel() instead of INIT_WORK().
They are set up before devm_request_irq() and devm_hwrng_register(), so on
unwind devres unregisters the hwrng and frees the IRQ first - after which
neither work can be scheduled any more - and then cancels the works while
the driver data is still valid. The handlers do not re-queue themselves,
so a single cancel drains them.

Found by static analysis and code review; not runtime-reproduced (needs
Arm CryptoCell TRNG hardware and a completion interrupt racing unbind).

Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunjung Ko <hj351016@gmail.com>
---
 drivers/char/hw_random/cctrng.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 03401ee..138cc70 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -11,6 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/irqreturn.h>
 #include <linux/workqueue.h>
+#include <linux/devm-helpers.h>
 #include <linux/circ_buf.h>
 #include <linux/completion.h>
 #include <linux/of.h>
@@ -497,8 +498,14 @@ static int cctrng_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(drvdata->clk),
 				     "Failed to get or enable the clock\n");
 
-	INIT_WORK(&drvdata->compwork, cc_trng_compwork_handler);
-	INIT_WORK(&drvdata->startwork, cc_trng_startwork_handler);
+	rc = devm_work_autocancel(dev, &drvdata->compwork,
+				  cc_trng_compwork_handler);
+	if (rc)
+		return rc;
+	rc = devm_work_autocancel(dev, &drvdata->startwork,
+				  cc_trng_startwork_handler);
+	if (rc)
+		return rc;
 	spin_lock_init(&drvdata->read_lock);
 
 	/* register the driver isr function */
-- 
2.43.0

