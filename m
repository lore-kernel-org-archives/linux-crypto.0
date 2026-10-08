Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6723D9DD4;
	Thu,  8 Oct 2026 07:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791443971; cv=none; b=t3T30D5vCNEG4vVv7u0It4sllTVQq97/pk6UuYw6bF9CC5nNDmgY3U+kWzHVTA7xnPjzn7LGSTYAK98zMXLvhSQhGWkx/9ESJjR78+/eVTPS2rCzXErAOMvAvjhbpRPBhPZepYBXhfY56PrjOsDnYgTNPeAA7gSxjqpl+lhKI84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791443971; c=relaxed/simple;
	bh=bFIFDnnfC7d/QR0Euq6whcXZctDU96bsANmpRA8Xh7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ca7HF0WIlnClhgmJQi7P4qgI/a45PR847FNioeABG1CZCwsO9WuC4RsJSk/z8WVEqKyBqtZJosONls/fHy6+3lRjk8BtL4cH0WheOw37tJN/A4RyTdqCL4RgNUorY4Vb9lzp35MMW1sOKZiW37srdVwdNR8sIaik4U4mgZxln40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 42E8421B5A;
	Thu,  8 Oct 2026 07:19:25 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E31B213354;
	Thu,  8 Oct 2026 07:19:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uhSkLfxDx2qTcQAAD6G6ig
	(envelope-from <jgross@suse.com>); Thu, 08 Oct 2026 07:19:24 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v4 07/13] hw_random/via-rng: Stop using 32-bit MSR interfaces
Date: Thu,  8 Oct 2026 09:18:33 +0200
Message-ID: <20261008071839.2247074-8-jgross@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261008071839.2247074-1-jgross@suse.com>
References: <20261008071839.2247074-1-jgross@suse.com>
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
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: 42E8421B5A
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
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
2.55.0

