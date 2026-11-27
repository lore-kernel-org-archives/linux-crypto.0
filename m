Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795752271;
	b=yMO3Tj9Rg255cDo+fjDNt9CPEXs022W870sGRKhXC1v/n14bjapm5S/T8EXL2nI5IACA
	 OMVBIjPyAuBoF4waR/VEiRYgGpFrZbfSN7j596hf5lIatcaJis3kZzkdPI/zspao5zOVt
	 /d9N7AWbuD/itEyXYnkXIu7PhrN7BB1+y6rSSGsvzX+H8bmCbils8zVabKaUNDoOqAE/f
	 A28vbQUKeddktg16J++ckEu/XId6Sz/sFTPs+23G1+X2Q+/obQr9KyAVzmHfJJbzfuYLb
	 i8MLyGmwtawPfrOqemzcxMVJUSPWS9WggB9du4ox1V2l+Onq95wjVozu0bh+UXcsrcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795752271;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=v9W2gMejQa4ruYwRadXL7m8rwrpY1sGDNVmUPiT9nBQ=;
	b=mxJt0tQsFmyyJea3AEwJOKQJWtfDTRDSYvhv0BwhHJgeRxQQrnXxf5nRkg0fwWQ0bRiy
	 MbTZ5S0vbHJgi4ea0o0/IaVrVM44Fz4CS2uLdXBWZxkzqMjV+K3z+yNF9Jpx+PX7WCdTQ
	 TOgLtYviqCkYJeMvs/pSTT8JqmNt0I7GLUjJo9j/mxEc+t1souk02Rtnx5ayaGgdZJtMX
	 i/52S90f66KYFydi9CDHi2JUfLDlMTiI1KZ7eFTLSe8rQXnxTScUAdxsIS8k6rtlZ1VFu
	 kxv4hqOWfDfTifcH0fF/uKOmjWDWShXNdjgRiIa/GQwH3hObZV0OTXn0q9hkknYLtpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wgv7zUk9;
	arc=none smtp.remote-ip=209.85.216.51
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CE7606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:04:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83CE7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wgv7zUk9
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b520f1604fso390018a91.2
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 20:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795752271; x=1796357071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v9W2gMejQa4ruYwRadXL7m8rwrpY1sGDNVmUPiT9nBQ=;
        b=wgv7zUk9r7TVElCtooNO8NdZH2wqN50UPXtheUgf8EI1CxfY8SJg5eLNgh/7LLhrFb
         YcRrvOYgmvl9F5bRPRjsDvGG0jT1s3fZ1f33JOq3Xmz/jHZznoykafxvQveoQYoiqp/V
         3hgMp3a5Y8wit3ThIbX66H0G/M2iJKV2qIygoPksUEL+MjH5F2fsuFbDKzKNAbk818EZ
         rQ8YxzCftbFery/wjkHxfToJZz5KLGt43OC7iTYXyievXhGabL8wu5+ckF9232dJifrb
         qv98I2Y2jQw7CaeaQuF0fWND+yKuRng5tqT1Ds9jEH3pMHIiQsbnY/OHvQVQSzrc7Gcy
         fZfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795752271; x=1796357071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v9W2gMejQa4ruYwRadXL7m8rwrpY1sGDNVmUPiT9nBQ=;
        b=MBqN3ENpHLxFu+/uYGIn5t0i8YrGqjzd9OHksf9xW0KZlAteXNbq3o1hitXJgr7mRe
         3jcipM0pVyUnv3ugsiyAPd6DNBKQDT5GfWTq7NOuEMvMc4/n/07jPfti4v04J1zGa3G6
         eVHfKUrPcWmGjl4Je0+oVS8L69LZDWabmr4lmuouMGSvMhgnvblEtC2P0qVIfY0+ZyyG
         p7tbfCfpUS/7DFiZznqYHfPyzG32m/FZAsHYmNgzhYhZod3U4ihPN0760H2chwEecU3c
         fBVRg/mGlYtm0Wpkvajae9QP6iEHeXTI3GWj8P01ABNMniC9bi757dj5THav4mNLXtZv
         9bXQ==
X-Gm-Message-State: APuU4Z+eirAAGLj9LHbNf9dlu9TAENnSLZgz6TsRVnVMe+PWEa4RXd5J
	3ZCVMWyNa8tcVHkqiKe+ZmowLDxLHAqzH317bQ6bSgSiywFRFIOZBP58QfjMUA==
X-Gm-Gg: AZFdTZdhTBMRn0GkEqyQj06rLtcqA5rTGks2C49ND2xa0G9zVTpQTn/47te4wCPXgX2
	7QLgaBa0SfdnWCilgkkMFYPXgoup2rP+DL7jfpgDtJW/b2WJbqIBowpzsNnFSyVOO8dBSP7sJhP
	vcRbdiOskd0l7BPXv8DsRpwQj0ttCPATVeLy9ZdRDTZlTqrxQDKJPIDOVdM3S+fe9/qggEiyNmm
	mQAQQrPRQ2iI+0ea3IcFY9v19eAk2Pid5QtAwVYLk0f/ULO7obY/g2UJiJFAgoUVq+g5VwZ3RK4
	RUEqhD+WaR05ZFFNnFuskQWzdszk6hwq0ZSP+sXP6vG8/hDG1glp4u7/VOc6Tox1AHf2RG1ZOEC
	lJSiI2xy9A8LvRKSxnMTj+dgUMWF60KvpncP71tKpPeFxPd0gp3tWvTypTEPxpF6QD9/22ywRM9
	zsoeQusWf1x40izxbjxRAllE8K9RSz/xZ1iN8zKfRfFusb8Ht5zGwSi35T4AsWo6dzgtS/BRP38
	GY49GL2T9du3LxrJOPE2ASbg93IQDLaJ6QpLiYdbQ+Wl2ZWWRzu1sYczUo2suvGHgV+LwB/UTGL
	Q5eFQkCMfo0dQiEbczhOTdweHuoT7ZCov8YEvq7hAjdWZwX/EMbVn5/0j8HOl89/fED4/Lr5Jd0
	K4QuNrPOsfMJKvjnQ2BEsX6CbOEOy0SZpd9IhAFQ2YugYOdYodsiIs4d3b6vCttwgaz88S4tqJk
	95wQ==
X-Received: by 2002:a17:90a:e70c:b0:3b1:ba59:56a1 with SMTP id 98e67ed59e1d1-3b41c939b8cmr21039920a91.39.1795752270766;
        Thu, 26 Nov 2026 20:04:30 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b457a58d04sm15090652a91.0.2026.11.26.20.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 20:04:30 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	James Hsiao <jhsiao@amcc.com>,
	Rosen Penev <rosenp@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/8] crypto: amcc - fix missing DMA memory barriers in descriptor handling
Date: Thu, 26 Nov 2026 20:04:17 -0800
Message-ID: <20261127040423.1023233-3-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127040423.1023233-1-rosenp@gmail.com>
References: <20261127040423.1023233-1-rosenp@gmail.com>
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

The descriptor ring lives in coherent memory that the engine scans on
its own, and PD_CTL_HOST_READY in pd_ctl is the ownership handover; the
INT_DESCR_RD writes are only a doorbell. crypto4xx_build_pd() sets
HOST_READY before writing pd_ctl_len, and nothing orders the descriptor
and SA writes before it, so the engine can fetch a descriptor with a
stale length. The wmb() before the doorbell does not help, since
HOST_READY is already visible by then.

Write pd_ctl_len first, then dma_wmb(), then HOST_READY.

The completion handler takes an entry as finished when it is marked
PD_ENTRY_INUSE and pd_ctl has PE_DONE set and HOST_READY clear. Because
the entry state is written after HOST_READY, an engine that finishes
quickly can complete a request whose entry the handler then skips as
not in use, and nothing completes it until the next interrupt. Marking
the entry in use earlier is not enough on its own: pd_ctl is never
cleared when an entry is recycled, so it still holds PE_DONE from its
previous use, and the handler would complete the half-built request.
Clear pd_ctl when the entry is taken, mark it in use before HOST_READY,
and pair the two with smp_wmb()/smp_rmb().

On the completion side, crypto4xx_pd_done() reads the descriptor and
result data right after the PE_DONE check with no barrier in between.
Add a dma_rmb() after the check.

Fixes: 049359d65527 ("crypto: amcc - Add crypt4xx driver")
Cc: stable@vger.kernel.org
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 42 ++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 7a1ababd9198..e28e836c4f35 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -767,6 +767,12 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 	spin_unlock_irqrestore(&dev->core_dev->lock, flags);
 
 	pd = &dev->pdr[pd_entry];
+	/*
+	 * pd_ctl still holds PE_DONE from this entry's previous use. Clear
+	 * it before the entry is marked in use below, or the completion
+	 * handler would take the half-built descriptor as finished.
+	 */
+	WRITE_ONCE(pd->pd_ctl.w, 0);
 	pd->sa_len = sa_len;
 
 	pd_uinfo = &dev->pdr_uinfo[pd_entry];
@@ -876,11 +882,21 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		}
 	}
 
+	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
+	/* Pairs with smp_rmb() in crypto4xx_bh_tasklet_cb(). */
+	smp_wmb();
+	WRITE_ONCE(pd_uinfo->state,
+		   PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0));
+
+	/*
+	 * The engine may fetch the descriptor as soon as it sees
+	 * PD_CTL_HOST_READY, without waiting for the doorbell below, so
+	 * the descriptor and SA must be visible to it first.
+	 */
+	dma_wmb();
 	pd->pd_ctl.w = PD_CTL_HOST_READY |
 		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
 			PD_CTL_HASH_FINAL : 0);
-	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
-	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);
 
 	wmb();
 	/* write any value to push engine to read a pd */
@@ -1027,16 +1043,20 @@ static void crypto4xx_bh_tasklet_cb(unsigned long data)
 	do {
 		pd_uinfo = &core_dev->dev->pdr_uinfo[tail];
 		pd = &core_dev->dev->pdr[tail];
-		if ((pd_uinfo->state & PD_ENTRY_INUSE) &&
-		     ((READ_ONCE(pd->pd_ctl.w) &
-		       (PD_CTL_PE_DONE | PD_CTL_HOST_READY)) ==
-		       PD_CTL_PE_DONE)) {
-			crypto4xx_pd_done(core_dev->dev, tail);
-			tail = crypto4xx_put_pd_to_pdr(core_dev->dev, tail);
-		} else {
-			/* if tail not done, break */
+		if (!(READ_ONCE(pd_uinfo->state) & PD_ENTRY_INUSE))
 			break;
-		}
+		/*
+		 * Pairs with smp_wmb() in crypto4xx_build_pd(): an in-use
+		 * entry has its stale PE_DONE cleared.
+		 */
+		smp_rmb();
+		if ((READ_ONCE(pd->pd_ctl.w) &
+		     (PD_CTL_PE_DONE | PD_CTL_HOST_READY)) != PD_CTL_PE_DONE)
+			break;
+		/* Read the results only after seeing PE_DONE. */
+		dma_rmb();
+		crypto4xx_pd_done(core_dev->dev, tail);
+		tail = crypto4xx_put_pd_to_pdr(core_dev->dev, tail);
 	} while (head != tail);
 }
 
-- 
2.56.1

