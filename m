Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793679266;
	b=sCSZ0lymIVwuDI6hPEWu57FpPTgzl/UHokrfQdmoNSjlh4x7QB/l7mfq1sqHriTpa80z
	 dO7stYy3vpZf152VBS/E65QOz0qPiCQ5cVWFdbeH1QZYOkBfx5PG7f7Fcn6DYIdDWoBqR
	 GdgKu2MoopGjilZUX/JhgtEfUAHAF8J2D+UvNknddkViRRZXFz3b7WEQo/bgljdhO0I/A
	 vL/dBUkiw0IDqLcgDtOU2y0i9w3TXh8gr/BexVoe0f7VuzeFm9qDnx7xBcgsELDQn8KGe
	 G4IbkO5B1zHbrjqj84XccJixBI/vAKwtpok/hZFQAylGsYFft/ArCo+/x/K/uQuYlEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793679266;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XkEdAXzyx12LNNWQMDZglUPguh6hyM0B9bJcQNENUqY=;
	b=UAs6GmU8ZRdFV3zavsInwlVtH2yERNzh9vTydMZ6TzFGj1gvqRPS1Zn8ANfPNw5guv5i
	 S4DAJlL4J7inFvHsNP86ONlGdYPrYw2RVtnIL81CO2/ctjJW8S21c3xM4HIEHWGklfI5k
	 k/dgzkgkrzfwpvUne4LEd1lp73UC2XHewaVaXW5Ae7mVihU+u3yr0z6acCVklE4F64vtE
	 SJGGdiVAvi6fsccsGBM5WEeDC5ROWHSW1B3agSGy9YniIdNk6IVd9edqRvoydiBbZiNXO
	 quzLb3xM9LGeXHSe48EMNLYV0ENiJ8TD3firDfAa92G+iu5NlrzgJl+W2I/mP1NLg0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R0or+RlF;
	arc=none smtp.remote-ip=209.85.216.47
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E68606A338
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 04:14:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8E68606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R0or+RlF
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ae2b7e1e17so2408352a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 02 Nov 2026 20:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793679265; x=1794284065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XkEdAXzyx12LNNWQMDZglUPguh6hyM0B9bJcQNENUqY=;
        b=R0or+RlFKoAi7y3+vK6eKca2TnSUfgYME9vyDjzP+Yh7pIS64m1gRWQKk1NvsAA1dt
         3I3qcNIEmgt+H+Cri9DdYHZus2RyaHOsaRPN8Z/IP7yWIhlPjtDZ7iHVJFF2ZUt/3uOi
         zEksJpXBhzAzAGHEyEY/qBdV7mJo1iyJa0qpfyyQP91T7gCfI7ob7Du3YEpeEgwi00su
         GhSaxWo8+i3FuXNQ7anOKZ+E361ht4NBHclC5faMe9+SHsimcHr8uQtMXxdNNmYVuBYT
         zFDRSVGgrIBW5bUmK9rI+lk9orZ80otkAfsf0sVfVNRVHV/B9VMlN83QB04ahnXdceVP
         gxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793679265; x=1794284065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XkEdAXzyx12LNNWQMDZglUPguh6hyM0B9bJcQNENUqY=;
        b=OH3efBsN3BPJ1mN0XxWDVs0AYvp9CmFBRzRGYPTtjR1EJJcV3FTYOfCjY1OJ2oYOQS
         gKTXxVw0pp+gbMlbsBrA7Vem7HWcNlJ2JT1DJGAVPE7WfYKX5toq36dCpY/OX4IYxl6e
         g2iPIogBPsxuoduvXGodM6FFXV5g/pby0nL/KMNHMCceMhp9DiNicByBbx2+/lTe/IAu
         0hwf428xZuBrO6H32x7ZphWb/MzdgkURHg25Lsurh387F/q2NK4nmDZpCkKN/nUF9Hc/
         0lzlSsEv8p4pLRLYwXDG3vbWk9D+TnQbiaXieFOtbNIunNPA+RbGtwfyqe1MijVTqLuG
         rMEw==
X-Gm-Message-State: APuU4Z/vQTQNhHkAmBzPqHnYd16Aq777VoovlNIfYaqmar1AXPZhMmWf
	jwNZ64S/bl0bQO+wCv9eqn6Gn5GuJH4+hThvGkkxjn8Ii0PFQ8M9gS3itet65Q==
X-Gm-Gg: AYBFou05qf5R5BmtJbcXYWehJOeNQ9X/NuvVdZeqRp6DvVVQretk8HdAh+J+5KVFaPf
	3iDpgr1m613det+KiMjibiV7sdrYeoJHYPduK55gRzwu/K30Tm1VJiE/Q7O45+qTvcajJ++nyzi
	eknvrXMBsxFOC1JS7O5moGK6BbbTBrddDXdZIznbaqXUPy2dEdcqIBzDgIaT8I9VIuvq+9sbRcw
	Q6uLaUphHJmUosHdkInTXBp4Tcsu1r8t9jUqwycFK6jCV37ECMzHYBKq3MroBlyjssmrWcaQEN4
	WVhHDrTnXW1xofAGpayhRNcc52xlFGeLRT8an7+w2ZI8zmot7Fn/3QrBqcRp62lLfza++wQdqKz
	oXbQe6sntRfjqP39cAReV8fMmAv1H828nBOXJTS3h9huf+56CiPf2lqGI2GTuzzrqhneo/IOERH
	J23HlHGcm741qCh+8/7iLc5MiQCJKM8MX+FkF9Uy4i/xRKRKYT2+qnde0BipsnIDZuqVMmPUGFX
	kgn2cjAzBjQrNw9WORqdgc61p//UPprkYm/XM0pUVnfR9nCA4FveSfWclBGum0p3+8OINSWI1Zh
	rR0gJgPBLHWjS0sUvmcRq3DOaG3StWX9ew4V+Dp4m7nUNwiQ6AhIYHQkTY8v+/sPlueYRdqZbus
	=
X-Received: by 2002:a17:90b:528d:b0:3ae:5525:dc25 with SMTP id 98e67ed59e1d1-3ae89850a1amr9802337a91.51.1793679265200;
        Mon, 02 Nov 2026 20:14:25 -0800 (PST)
Received: from d.home.yangfl.dn42 ([2a09:bac1:7680:28::4:396])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c6740a1sm1989659a91.10.2026.11.02.20.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 20:14:24 -0800 (PST)
From: David Yang <mmyangfl@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: David Yang <mmyangfl@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Danilo Krummrich <dakr@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] hwrng: histb: wait for a batch of words
Date: Tue,  3 Nov 2026 12:13:59 +0800
Message-ID: <20261103041403.4071708-2-mmyangfl@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103041403.4071708-1-mmyangfl@gmail.com>
References: <20261103041403.4071708-1-mmyangfl@gmail.com>
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

The old figures were per-word, taken from a streaming average: ~16ms at
depth 255 is one word out of a batch every ~64ms, and ~1ms at depth 1 is
the 1ms poll granularity of the read path. The device fills the FIFO
with 4 words in one go, every ~200us per unit of post-process depth, so
at the depth of 144 this driver programs a batch lands every ~30ms and
an empty queue waits that long for a single word. The 30ms per-word
timeout falls inside that, so wait 500ms instead, which also covers the
restart after rewriting the control word.

Fixes: a2216e187471 ("crypto: hisilicon/trng - add support for HiSTB TRNG")
Signed-off-by: David Yang <mmyangfl@gmail.com>
---
 drivers/char/hw_random/histb-rng.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/histb-rng.c b/drivers/char/hw_random/histb-rng.c
index 445b80beed62..d435d4ab9aa7 100644
--- a/drivers/char/hw_random/histb-rng.c
+++ b/drivers/char/hw_random/histb-rng.c
@@ -26,16 +26,21 @@ struct histb_rng_priv {
 };
 
 /*
- * Observed:
- * depth = 1 -> ~1ms
- * depth = 255 -> ~16ms
+ * Observed: the FIFO fills with 4 words at a time, roughly every 200us per
+ * unit of post-process depth, i.e. one batch per:
+ * depth = 144 -> ~30ms
+ * depth = 255 -> ~52ms
+ * Rewriting the control word delays the first batch by up to 300ms.
  */
+#define BATCH_TIMEOUT_US	(500 * USEC_PER_MSEC)
+
 static int histb_rng_wait(void __iomem *base)
 {
 	u32 val;
 
 	return readl_relaxed_poll_timeout(base + RNG_STAT, val,
-					  val & DATA_COUNT, 1000, 30 * 1000);
+					  val & DATA_COUNT, 1000,
+					  BATCH_TIMEOUT_US);
 }
 
 static void histb_rng_init(void __iomem *base, unsigned int depth)
-- 
2.53.0

