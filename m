Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793019790;
	b=f8zEK8dPIfVGr/KJDtSIPe5DMlWJLCT8p7/3Mm0rlt8zrDLrGKDH0Tf/abFddFblXwe7
	 dAoJS6LKJ9Y21w61mTbL54tJRMRh6BlK2v1rOCIhasi4DpcXOeZuPRJdK6Es4fy/tDjwb
	 8WT1h4OqQmpmE/rU3hzCGQ+IKr+Gs3vipf0MHjshZLPuSuqUZczk7uIuYDhYz3gGoM+Bj
	 aVCDkDCnx5HqFQMFCNY8WBA0nPM0bPT6Yl3JKYYIaDN0wQ4fxNX+KbrWIdqeuHdJZLfty
	 8sG3tScJXy7MS9Yh0aJas7EkDsyvy1/3DOLAoLy9cz/lo/gry02oNDCi2t4BfZ6IBWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793019790;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=t0faRPOc49RzpC9aKPihikJDxKQc6PMkf1Bcnpy81rI=;
	b=jMUqz3omKREj4ds/fOqmAZbGTRixeXSS4if8pg1ba8BquEZWOpw8fVD4sHu8hgBHBpku
	 lXG01RiE/0BOAOd2xIs5zmFC/GvIMeSdpPmc+ay6GstiQwogn7kHRDUs2NYZHjuD2Mdz0
	 B+N5mOcl4sksHG6uT4QP9Bgq7QrYPEG+IV3CYMpKSWrsm2qS5hwFQunxzedVME9KP6tFq
	 vsxNKyNkY716qfLYWFzKk2CIAcYrO0yEN0pkjTEo/25e38KCIfySGRpHyQEPy057f1Kd4
	 HEuzcPMud0cltE+wHzDMHwkwwARTwbhwZx5+I/4ya38kOg+V34lyNppm6fUetxvPELg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Wawoop+8;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Wawoop+8;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8198606A31B;
	Mon, 26 Oct 2026 13:03:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8198606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Wawoop+8;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Wawoop+8
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0DC5222268;
	Mon, 26 Oct 2026 13:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793019788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0faRPOc49RzpC9aKPihikJDxKQc6PMkf1Bcnpy81rI=;
	b=Wawoop+82+i/l5WNfkXOtt6DzmLK1qpL0OReTGrHbH1xBgvLsafK+PZeSiCEFJbO2F3SQS
	qs5WOSFZG7gfLjQPsFJNZcZEqcp3QShLz1q5xY+tor/xG8Ws5bYsX3XXnuh1WkD4T1sX7P
	3w1K58dGv6Q/ctA2+zVCnj7PwTrsopo=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793019788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0faRPOc49RzpC9aKPihikJDxKQc6PMkf1Bcnpy81rI=;
	b=Wawoop+82+i/l5WNfkXOtt6DzmLK1qpL0OReTGrHbH1xBgvLsafK+PZeSiCEFJbO2F3SQS
	qs5WOSFZG7gfLjQPsFJNZcZEqcp3QShLz1q5xY+tor/xG8Ws5bYsX3XXnuh1WkD4T1sX7P
	3w1K58dGv6Q/ctA2+zVCnj7PwTrsopo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B060813408;
	Mon, 26 Oct 2026 13:03:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yeuuIYtP32o9WwAAD6G6ig
	(envelope-from <jgross@suse.com>); Mon, 26 Oct 2026 13:03:07 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v5 07/12] hw_random/via-rng: Stop using 32-bit MSR interfaces
Date: Mon, 26 Oct 2026 14:02:18 +0100
Message-ID: <20261026130223.773129-8-jgross@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026130223.773129-1-jgross@suse.com>
References: <20261026130223.773129-1-jgross@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-15.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -15.80

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
2.56.0

