Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910F526C38C
	for <linux-crypto@vger.kernel.org>; Thu,  7 Aug 2025 11:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754567093; cv=none; b=r0UIgU9QiVtdbasiDR8MbZn8BBEHC+jHonZbUJPsVSyX+isFnIhCHBEv/AiF4I+2Ry2F1tIqtS44woL+hNln4TFJloCg7CEtKxaBSCWE5PQ69qqGXQxPpfSLIYJQI/IBH8nH9jRvXv9MiLqWmeiZYm1QnHwavl9mnCbYSJBZ5MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754567093; c=relaxed/simple;
	bh=L7hfLRAJOLHOus5/zQlDJVfnXgYCJqEMBHsaSyGNiY8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XYXOAcfkDyFOj0Ji/mIi7webzCje3NkuNHxy2rqZ/INnHujz1Wi9xEfZrUOmFqBSbWy7tgCYhrfpUNLntJx6ylyT53+pyZ9Vv2mdFv0TN0Zg8XsbR1j1UmxbM6D5fXYoFrcsoSUdND09Uu5wfbkLVDkKRT9r9CZps4kk7TRtp1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kcevrr2H; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kcevrr2H; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kcevrr2H";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kcevrr2H"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C02821FCE6;
	Thu,  7 Aug 2025 11:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1754567089; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tOpR+gfvCF2CLA4th25JsmJoupBuWS5PLe2u+qNugnc=;
	b=kcevrr2HEuQbI4T4G/XnwPf57ViwUAcL5GQKBLcRJI9XKfE16anKkcBA24uszr+yM4GPA7
	kghjasjU2jxeGoj+K/oblgDq2+zsz9tkd4cxfEzNHEqsinVBIwjCjDO4G4KUygx0NnYV8v
	reYRGsFl38lRBZ78qbQqW5l1rmpAtLg=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1754567089; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tOpR+gfvCF2CLA4th25JsmJoupBuWS5PLe2u+qNugnc=;
	b=kcevrr2HEuQbI4T4G/XnwPf57ViwUAcL5GQKBLcRJI9XKfE16anKkcBA24uszr+yM4GPA7
	kghjasjU2jxeGoj+K/oblgDq2+zsz9tkd4cxfEzNHEqsinVBIwjCjDO4G4KUygx0NnYV8v
	reYRGsFl38lRBZ78qbQqW5l1rmpAtLg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8DE513969;
	Thu,  7 Aug 2025 11:44:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RCAdLbGRlGg5ZgAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 07 Aug 2025 11:44:49 +0000
From: David Sterba <dsterba@suse.com>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	ebiggers@kernel.org,
	herbert@gondor.apana.org.au,
	David Sterba <dsterba@suse.com>
Subject: [PATCH] lib/lzo: add unlikely hints to overrun checks
Date: Thu,  7 Aug 2025 13:44:44 +0200
Message-ID: <20250807114444.1341921-1-dsterba@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80

The NEED_* macros do an implicit goto in case the safety bounds checks
fail. Add the unlikely hints as this is the error case and not a hot
path. The final assembly is slightly shorter and some jumps got
reordered according to the hints.

   text    data     bss     dec     hex filename
   2294      16       0    2310     906 pre/lzo1x_decompress_safe.o
   2277      16       0    2293     8f5 post/lzo1x_decompress_safe.o

   text    data     bss     dec     hex filename
   3444      48       0    3492     da4 pre/lzo1x_compress_safe.o
   3372      48       0    3420     d5c post/lzo1x_compress_safe.o

Signed-off-by: David Sterba <dsterba@suse.com>
---
 lib/lzo/lzo1x_compress.c        | 2 +-
 lib/lzo/lzo1x_decompress_safe.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/lzo/lzo1x_compress.c b/lib/lzo/lzo1x_compress.c
index 7b10ca86a89300..01586af2347f5e 100644
--- a/lib/lzo/lzo1x_compress.c
+++ b/lib/lzo/lzo1x_compress.c
@@ -26,7 +26,7 @@
 #define HAVE_OP(x) 1
 #endif
 
-#define NEED_OP(x) if (!HAVE_OP(x)) goto output_overrun
+#define NEED_OP(x) if (unlikely(!HAVE_OP(x))) goto output_overrun
 
 static noinline int
 LZO_SAFE(lzo1x_1_do_compress)(const unsigned char *in, size_t in_len,
diff --git a/lib/lzo/lzo1x_decompress_safe.c b/lib/lzo/lzo1x_decompress_safe.c
index c94f4928e1888b..318abb82c63d2c 100644
--- a/lib/lzo/lzo1x_decompress_safe.c
+++ b/lib/lzo/lzo1x_decompress_safe.c
@@ -22,9 +22,9 @@
 
 #define HAVE_IP(x)      ((size_t)(ip_end - ip) >= (size_t)(x))
 #define HAVE_OP(x)      ((size_t)(op_end - op) >= (size_t)(x))
-#define NEED_IP(x)      if (!HAVE_IP(x)) goto input_overrun
-#define NEED_OP(x)      if (!HAVE_OP(x)) goto output_overrun
-#define TEST_LB(m_pos)  if ((m_pos) < out) goto lookbehind_overrun
+#define NEED_IP(x)      if (unlikely(!HAVE_IP(x))) goto input_overrun
+#define NEED_OP(x)      if (unlikely(!HAVE_OP(x))) goto output_overrun
+#define TEST_LB(m_pos)  if (unlikely((m_pos) < out)) goto lookbehind_overrun
 
 /* This MAX_255_COUNT is the maximum number of times we can add 255 to a base
  * count without overflowing an integer. The multiply will overflow when
-- 
2.50.1

