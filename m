Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0AF44BCBE;
	Wed, 19 Aug 2026 10:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787135049; cv=none; b=jh1/2HBmvMyC2mKPflnf+GIWu08AKet+9PZN/IuyIbu/U+L9ctz4tG7NejWsqy3GV/RWdfHLbcv3jDJMn4sU53AYnXPjP1RYSRc57gNvmcCpGcFzxjEQl5CFNKP7RGbw6aoey1D1WaPkfyPnC8LWWj/0doUOGoBxo+8Bx+vcINw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787135049; c=relaxed/simple;
	bh=bFIFDnnfC7d/QR0Euq6whcXZctDU96bsANmpRA8Xh7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZw2DxndadFTKcD+LjckwR5PbdFF5wNAl+74Zb+uWG13riiA9O/GRQS+Dqlk1QmXFjH0jqK1Kgx+Wv9lSg5nkAQfhaM0ISSE8CQSoZcvtWo8vrvV8N4wByUfW2pPYxNcwVAa5X7hRsLb1Dr19ApIYNKZFDOLz/eXuWPzBAWj1mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=K8RoF2M2; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=uGEGhEnH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="K8RoF2M2";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="uGEGhEnH"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4F7F284A8D;
	Wed, 19 Aug 2026 10:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787135042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8yyZLGgewj5Dv5zL9Kzezo1+nnTPJyvGdXX8mS3Qras=;
	b=K8RoF2M2MWkt3PM+7SpskFTnv3TFqppm7Xm2kh6TBbJHQKB1MUbl+stnLuAjWjAxRQT8XO
	MlajiggHT0GrHTqGR3UK6yEORjG48PuSn3IQldo4Um+as7bCfSpnp7LsC6zSZNdo5sOFWI
	sXq4mtUOO3f5E55Jbebmf1UOIYQfgJQ=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787135038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8yyZLGgewj5Dv5zL9Kzezo1+nnTPJyvGdXX8mS3Qras=;
	b=uGEGhEnH/NcGZEc6jNSn66Oa5fOcUkWiuwy7xUmg1cd5th2x+zysaIx9wDX7tyWb7QvnZI
	uVv5QNqPsI61NMOolJGEAmwdmGZhv4n6R6a9GW2iwQzKaF/nMTE84wYrUtnHir0L9YBTAv
	xI5Fw27tH2IJnZ6H9id1xJizNJHDO4U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2AE5C2F81;
	Wed, 19 Aug 2026 10:23:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ugVWCT6EhWrCEgAAD6G6ig
	(envelope-from <jgross@suse.com>); Wed, 19 Aug 2026 10:23:58 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 07/13] hw_random/via-rng: Stop using 32-bit MSR interfaces
Date: Wed, 19 Aug 2026 12:23:08 +0200
Message-ID: <20260819102314.1499258-8-jgross@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819102314.1499258-1-jgross@suse.com>
References: <20260819102314.1499258-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[]

The 32-bit MSR interfaces rdmsr() and wrmsr() are planned to be
removed. Use the related 64-bit variants instead.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/char/hw_random/via-rng.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index a9a0a3b09c8b..b718e78d3c1c 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -129,7 +129,8 @@ static int via_rng_data_read(struct hwrng *rng, u32 *data)
 static int via_rng_init(struct hwrng *rng)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
-	u32 lo, hi, old_lo;
+	u32 old_lo;
+	struct msr val;
 
 	/* VIA Nano CPUs don't have the MSR_VIA_RNG anymore.  The RNG
 	 * is always enabled if CPUID rng_en is set.  There is no
@@ -150,32 +151,32 @@ static int via_rng_init(struct hwrng *rng)
 	 * does not say to write them as zero, so I make a guess that
 	 * we restore the values we find in the register.
 	 */
-	rdmsr(MSR_VIA_RNG, lo, hi);
+	rdmsrq(MSR_VIA_RNG, val.q);
 
-	old_lo = lo;
-	lo &= ~(0x7f << VIA_STRFILT_CNT_SHIFT);
-	lo &= ~VIA_XSTORE_CNT_MASK;
-	lo &= ~(VIA_STRFILT_ENABLE | VIA_STRFILT_FAIL | VIA_RAWBITS_ENABLE);
-	lo |= VIA_RNG_ENABLE;
-	lo |= VIA_NOISESRC1;
+	old_lo = val.l;
+	val.l &= ~(0x7f << VIA_STRFILT_CNT_SHIFT);
+	val.l &= ~VIA_XSTORE_CNT_MASK;
+	val.l &= ~(VIA_STRFILT_ENABLE | VIA_STRFILT_FAIL | VIA_RAWBITS_ENABLE);
+	val.l |= VIA_RNG_ENABLE;
+	val.l |= VIA_NOISESRC1;
 
 	/* Enable secondary noise source on CPUs where it is present. */
 
 	/* Nehemiah stepping 8 and higher */
 	if ((c->x86_model == 9) && (c->x86_stepping > 7))
-		lo |= VIA_NOISESRC2;
+		val.l |= VIA_NOISESRC2;
 
 	/* Esther */
 	if (c->x86_model >= 10)
-		lo |= VIA_NOISESRC2;
+		val.l |= VIA_NOISESRC2;
 
-	if (lo != old_lo)
-		wrmsr(MSR_VIA_RNG, lo, hi);
+	if (val.l != old_lo)
+		wrmsrq(MSR_VIA_RNG, val.q);
 
 	/* perhaps-unnecessary sanity check; remove after testing if
 	   unneeded */
-	rdmsr(MSR_VIA_RNG, lo, hi);
-	if ((lo & VIA_RNG_ENABLE) == 0) {
+	rdmsrq(MSR_VIA_RNG, val.q);
+	if ((val.l & VIA_RNG_ENABLE) == 0) {
 		pr_err(PFX "cannot enable VIA C3 RNG, aborting\n");
 		return -ENODEV;
 	}
-- 
2.55.0

