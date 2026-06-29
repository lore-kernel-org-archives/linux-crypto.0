Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164A13914EB
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 06:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782713265; cv=none; b=nNp8BUzhMJpoXBy+prKv6CQgWxkpR8Mos2SUlYFujAE5oH+dxVXvC0DNgylk4awpmzlGdBUMvLKGqr5MoEKSs4GkuiyNOK29Djnprjr5ge0y4DJbfIMJjj+NGxhD07YDkbBdN5Uv8Y4BvoMOka/sPmHFj6MtB4I7VTYbxY5hYG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782713265; c=relaxed/simple;
	bh=CHLicMuFuX5sW5ZgxlxSNtbIjywywz4YoFc1ADW+XMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpipO4sfTTSn3lZT4z5R+jaJTYdR7NXwz9LaaCKIYuVqb47XECsH3uKbTRYuo0C3LvGoLWnnUGS8aOPpnJ5GUv6rditlQS3l4bo/Zb9v3Bfy1eHK3pE7CUyQLpxqpsE3X1g7km3Vw+0g5aNrTLl0zE3WZFuP5noUP9zi24ct5+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9E2E575D19;
	Mon, 29 Jun 2026 06:07:42 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6F5CE779A8;
	Mon, 29 Jun 2026 06:07:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PWm7Ga4LQmpaEwAAD6G6ig
	(envelope-from <jgross@suse.com>); Mon, 29 Jun 2026 06:07:42 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 23/32] hw_random/via-rng: Stop using 32-bit MSR interfaces
Date: Mon, 29 Jun 2026 08:05:14 +0200
Message-ID: <20260629060526.3638272-24-jgross@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629060526.3638272-1-jgross@suse.com>
References: <20260629060526.3638272-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: 9E2E575D19
X-Rspamd-Action: no action

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
2.54.0

