Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794841376;
	b=uavZ1uQttiNX8c8qqW34O+hVwMrnJ5g/etISk1WKwH6F5OwewEx3sYh+zWLgHF0HO698
	 eRbI4nJvpz80+3rzez5dxB9At0NCQ7riBwLywwtyoHFO8DD1y+J18I4rSIBt/nIXgkGeA
	 0yR1jhcHrBWgL9ed6rKtQwfdVtFDpPtkp7xa35Gstb6FFyYozdYUv4IyPEPSPMCWFXK5F
	 PcVfjyon/uraeL5800rn7TFH3CXXOXR/WNK6PdEFj1hqXrzoowAF8qGOgG1YuKvgRuQGG
	 PAy15MdcU8E6qUcIM5y7EBB3yrwyS6aEIvIdFwrMHFfArHS2lnzr5+BzQrv3VBq0JbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794841376;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=t0faRPOc49RzpC9aKPihikJDxKQc6PMkf1Bcnpy81rI=;
	b=T0vvSjrLyZ0+oHsK2/g33/iKziwydzUOOsdT2Z0eq6zHuoPdreqYUJqEox3JO84flIG6
	 M2ohcrjEo8WwvsNgH03btDYl+vWSZQ5YzY3cjsPLkazx5hS3TuQ7tpzf5oBIWY4QESFSt
	 8QDxqc+6i+M2Sl+8/vHwNYiKI0UWM9L+rn31SKOf0xvBR2uS5YCBrtHxc6mJx/oqu6gak
	 fV5wqvf8poiZD24oAKMCZySEQOVGp79kvZ5ezDty4WdhLYMhtsSnELBeSwdpY5uHlH1lK
	 QVmBPDP1L/aYmYQ3jYH1aL0T6SFUsQmrw9xUMDwJcT5+ijkjkTVmVXMS4gyemAXZnkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=eiSX0k0d;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=eiSX0k0d;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959C7606A31C;
	Mon, 16 Nov 2026 15:02:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 959C7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=eiSX0k0d;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=eiSX0k0d
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DF297221FE;
	Mon, 16 Nov 2026 15:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794841373; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0faRPOc49RzpC9aKPihikJDxKQc6PMkf1Bcnpy81rI=;
	b=eiSX0k0dPp6MgGd6aWJClxtpF9cNKlDe13aZLkpsmigyYJoisYfzm51GuzGJkrBwtP8U/V
	VwOBZcB1hneCZcORSmnrH7/thFeX2aQMy1BVk0en7sj7gbDVIDfLKpKc1MASvRudvCa6d0
	XXRs9h84fKXju8LP3tLQ8H5RpBkqrAQ=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=eiSX0k0d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794841373; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0faRPOc49RzpC9aKPihikJDxKQc6PMkf1Bcnpy81rI=;
	b=eiSX0k0dPp6MgGd6aWJClxtpF9cNKlDe13aZLkpsmigyYJoisYfzm51GuzGJkrBwtP8U/V
	VwOBZcB1hneCZcORSmnrH7/thFeX2aQMy1BVk0en7sj7gbDVIDfLKpKc1MASvRudvCa6d0
	XXRs9h84fKXju8LP3tLQ8H5RpBkqrAQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 94C7A13408;
	Mon, 16 Nov 2026 15:02:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZpvoGh0b+2qIEAAAD6G6ig
	(envelope-from <jgross@suse.com>); Mon, 16 Nov 2026 15:02:53 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v6 07/12] hw_random/via-rng: Stop using 32-bit MSR interfaces
Date: Mon, 16 Nov 2026 16:02:03 +0100
Message-ID: <20261116150208.1572254-8-jgross@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261116150208.1572254-1-jgross@suse.com>
References: <20261116150208.1572254-1-jgross@suse.com>
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
X-Rspamd-Queue-Id: DF297221FE
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.01

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

