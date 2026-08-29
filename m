Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3903264C7
	for <linux-crypto@vger.kernel.org>; Sat, 29 Aug 2026 09:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787995229; cv=none; b=f4lEybAoqoU4uP24mBMMJahp7e+UZ0Mp9GiY35W9iA36sYieuaA8eiZn2adEpJdZtUs35Nf4u20FuAY93VzL5SoZrb9Pc8cI3CWrB/yY/dWW6UeCtEQ/7sVQvHmaMKg/LUO3pMAYo16VpdMwold+GQI4BUwJ0IBwXXvHgimMzts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787995229; c=relaxed/simple;
	bh=xEJsUJXXq+AQ7oTTfzOKOEAmZg7d58nz4OsI75LCCcw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HLkvVzT0fl6Jw9N0stbRvEVsmpUe8ZrgTjvVTO/bpqeS4InYkd/jGgtaXutP2ojkpxGsEOsHvE0GZCb+jtNHRzpO9wv9u72GbH3kHXUPmYkct7/a1FMVQxW+2r49FD0bvAZraLewUiwx7CBndiHi78iejFcWfcdk9u5mZNV3X1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H3WVR+9z; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H3WVR+9z"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-499b2981a7bso18666435e9.3
        for <linux-crypto@vger.kernel.org>; Sat, 29 Aug 2026 02:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787995226; x=1788600026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g1+HRCUsJSMaHeBVju8py9w9BV9sqUgEs0fVkhwu3rA=;
        b=H3WVR+9zSVGEDR4B1B+nf4ASE48ffTgB9KdvfEkMyzya4pm5cQsRqpzOsguV6ppDWN
         brBXDz8xRt+ZMqhrvC9nRYNx4tS6wchDlYwaW+LCzwWyGeoguT7rPy1QyKFLN9JzWW7S
         wjWJPwE6beWr9tPIdYOhpJJuq+TjDCUFGQa2oI0soTiB9lA1+cAVzgJuIadfpJaMXB1x
         dsTCuEoAsnojs86neyKJ6z/Zu5yEHMD4Q5JxEbR2se0yqy8baFpvl/X8/gD85C1Krpm/
         8ecyOTqYjH9kN5fyVpKLlkd/cnj6wpemu1hkeRZXFf/+QBBm5bh0+4bZB8ySg1Fh72+P
         zcSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787995226; x=1788600026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=g1+HRCUsJSMaHeBVju8py9w9BV9sqUgEs0fVkhwu3rA=;
        b=WC+AuKLZ2ybanQ5CtDGjKz89V9ebz0fiI1W+i7qSHBP8b3vcaVyKz73C4aXM1saZJa
         eZm+kdvnTF5H3jVt9RlR8f4qXcB/0W5VeEQi6zlKhQiLrsaW9Qdvuv4wtv3OmC2As7kL
         jPthU+zve7sPUE0GeJxlEYagX4lKQWXx2NT7uzSULLnFRJXPFasIwfoc8HNQwYS9HNau
         YtKZTsoYmfK86FgrGkwrVNZU3Rv/ZzVW0s1rm0MqOl57rYdECX7S+dSLitqsLbSFxJFu
         q6IP+34SpdwJDot8inaees1DytVENTwPVR60Xlz1kgpFcsS/Ol1UWrwFyOEkwBFBEkbw
         6Bag==
X-Forwarded-Encrypted: i=1; AHgh+Rruj4D63AhSgztQ4Xyj1OIED4Su1v8hChncW93+ld/CrQUme2J3g+L0x8O4acdZfT/FgnOQ2tk6I8L+SyY=@vger.kernel.org
X-Gm-Message-State: AFuF++moW4HUCnKlfQ3NzbcsYGuaF0JxvXItL7NOHz91I6MZ00i+jDFS
	Egw8yj6lRLjcVW4JEuLw6NGML/joG+rt/KAPwwZ5wv2y7gPvoL/a6zeh
X-Gm-Gg: AR+sD11LCBcoO9Dsc72DtdljRVXWJJSNWS39560b20F8Epu8yngzaVPHa1cw84vJobf
	LRH5/NbXAzX7g53qzBmfnNg83782SgIY0eXlrmxADj10GlGRcKQVk+GrfEIvmnl1pg8JQZt8IJS
	MWjC26feB1693xPGYMxVX4brAzPcPNFBfPGCbI2DHQvokYlXVU7EA2sHb0aAQRch90qOWPcCia8
	IlozPob917vrOupF7XqCQ+XcULFlhxCmryu2RCR0GDX2nlg0OPZJnA5eeiO8Pu47Cr0qFPqNn8y
	Kyoap/UT84NrCT9at0HRHu79Ad2vzuKtT8TyStvCBElvSEfo3mNjmpYthpUpHpfNGSCg0ms2eL8
	TfWr/3iE7+IzxN3pMLI1Y+waFlWYaFURe7zo/NqL7yQF022OU+85ki6WqRo9jiA9fbXdCc4vsa3
	ayvQzeZr46nd9/TO8LD29Z47ULR2BgyAb+FAnKsHgNf2Kk4SAmyHLKJBrqw/Al3Ku4udL2OL+a2
	eR01tP7Z3vXZLv62Gg2wVRJsMZj37hTSzWC4t/TL1VxGf/PwWf5UVSOk9kM7wqisqqSuHsVIGtq
	BZoxuZkLoJGIPNIdQ2oU
X-Received: by 2002:a05:600c:3493:b0:499:b65e:49c9 with SMTP id 5b1f17b1804b1-49b91c4792bmr196921055e9.10.1787995225544;
        Sat, 29 Aug 2026 02:20:25 -0700 (PDT)
Received: from localhost.localdomain (dynamic-077-007-015-136.77.7.pool.telefonica.de. [77.7.15.136])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b91c510c9sm80468505e9.0.2026.08.29.02.20.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 02:20:24 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Haren Myneni <haren@us.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dan Streetman <ddstreet@ieee.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/3] lib/842: require a complete history block for repeat templates
Date: Sat, 29 Aug 2026 11:18:50 +0200
Message-Id: <582dd9a92a793481f9836e1b90726935e90f5414.1787978627.git.kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <cover.1787978627.git.kmehltretter@gmail.com>
References: <cover.1787978627.git.kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An 842 repeat template copies the preceding eight-byte output block. The
decoder rejects a repeat only when no output has been produced. A
short-data operation can produce between one and seven bytes before a
repeat.

Such a stream makes the repeat copy read before the start of the output
buffer. Depending on the surrounding mapping, this can fault or bring
preceding memory into the decompressed data.

This is also reachable through zram's compressed writeback path. With 842
selected, targeted corruption of the compressed data on its backing device
to a short-data-then-repeat stream made a KASAN kernel report a
vmalloc-out-of-bounds read when zram read the page back.

Require at least one complete output block before accepting a repeat.

Fixes: 2da572c959dd ("lib: add software 842 compression/decompression")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Review notes:

  - add_short_data_template() has one caller, immediately before
    add_end_template(), so valid compressor output cannot place a repeat
    after short data.
  - QEMU 11.0.2 TCG with x86_64 KASAN reproduced this through zram. A page
    was written to a virtio backing disk with compressed_writeback enabled,
    then the backing block was replaced with SHORT_DATA(seven bytes),
    REPEAT(one block), END and CRC. Baseline readback reported an eight-byte
    vmalloc-out-of-bounds read starting one byte before zram's output page.
    Fixed readback returned -EIO without a KASAN report.

 lib/842/842_decompress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
index 87d1e0f8a4926..45a9815abd637 100644
--- a/lib/842/842_decompress.c
+++ b/lib/842/842_decompress.c
@@ -309,7 +309,7 @@ int sw842_decompress(const u8 *in, unsigned int ilen,
 			if (ret)
 				return ret;
 
-			if (p.out == out) /* no previous bytes */
+			if (p.out - p.ostart < 8) /* no complete previous block */
 				return -EINVAL;
 
 			/* copy rep + 1 */
-- 
2.53.0
