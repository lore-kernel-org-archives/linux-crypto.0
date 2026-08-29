Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376A43624DB
	for <linux-crypto@vger.kernel.org>; Sat, 29 Aug 2026 09:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787995225; cv=none; b=qr7HteQzmqlo09tr3ykkWSvfBfnlFHw5/hQn9Li29vyfX2WiHYjAEzWLtiqNMEJJ+L1JuxAyI+nMyGilQuOH2w3v6oe4BXWJ+ynjxt23G++FEjg1Jk1/S2LyeTtYSNSYGtNhqAQu4W/vXQ26RALd5p4z8qFR3B0Fqgal8GUX+Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787995225; c=relaxed/simple;
	bh=vn/sETwpwRxIemo/a/l/1eaolipfFb+WGFx72ujwMnU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q8Mh7HktgNRc/4qKIv++t5w42fKGMDxPGtav7ouIR5IcNzxCbAqwW6gcKmN46q2G3YgDg8hFhEWDrKc1jZVz26QxXT934Leiz3vjBvtwsvQ/g9+ngCZWfmEexYIBa/nwktT8qrv7bhosem/RMmWP0D/yg5MEijV0VSqvW4WrJdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CPMoUOYq; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CPMoUOYq"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49b0eab380eso17951705e9.0
        for <linux-crypto@vger.kernel.org>; Sat, 29 Aug 2026 02:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787995222; x=1788600022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6KyIsLM4pqBiHmYPP6l16RwLjR486x3K93pSlYk67Ow=;
        b=CPMoUOYqLLRaJO8R8xh8MS7rosVZJ2VWsWPZRYb5vgY4ofN5+HQ0gwSIIM6uw9ouaM
         Ok510JCSGatI79q4SiFb/lCoOx3CfKTm9ofYhLc306pATISnkwGcF5Oayalu1eX0g0vT
         xGK6+O1DhSxXm3OS/qVMpyqLNwtjuq2RjV3Qmgb2+ytnEe01zHXNDZn5luT6ElQTSfeH
         Hc9QAYdWs+QRDEZwPKuinUfyDgkgSKM3KPU4ToBYICAVgSFSVIWMGEgp9ItMW2vfrEmH
         cVQKysDsIywPOnEWxdHVNcWTiGvhxGhsLl3Az1L0PV8+2DKv+88T8AZDV/VwZ+ROtTmX
         Rtng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787995222; x=1788600022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6KyIsLM4pqBiHmYPP6l16RwLjR486x3K93pSlYk67Ow=;
        b=EcwHgiKtblaiLnvizYV0AbhD5NeGgrNXr+EVh9iUdg+zXNZ3TbkKiagGiL+V2hq5FJ
         DPwE3SF5R1OIkCcOb6GpFimOyLXOPWzDWBfnVBNn6oSr/XLgzR81pywTdC5d6zV1JnWD
         VpfsDiGVotourWXq3AusYHe4BjU/2kNw0Ld2skN9K3C6EfX2bzCdO81AGZnn7gvUFoKx
         6qnjD3icmdrC1F0/D/wCNJbREPZ6lHwGIzOT80iPPWaYAT2j4syIJUVnEpqD0zXBiDOv
         Q8Zt+A5xEwl5Zqlrz5hYX/k/VvI8cAiSd9lGD6vXa2G11nPRScPB/BYXNoF6ldeyXa+b
         pRpw==
X-Forwarded-Encrypted: i=1; AHgh+RpC3UZsCfTllk0zko8g3at76sfaakD5ntCIuGCQw3dnBMA1cLTXxc7aeHxg3NYdw93gp14zh9goVTi8cyo=@vger.kernel.org
X-Gm-Message-State: AFuF++kf7fkEkhhiyl30uAzMFK2xzppfwmhmFA9dV0kOMAzWk267f2wA
	hQi9XYOk/yCVoK4dBg4YL7B/QBPxwVc1DuH9HgEU6xh9PvVDKFIqfKZp
X-Gm-Gg: AR+sD10qngnu3xWzqHZ+dDkODeGRV1M6HS3L5ESl8j9in7+FHmkMyUqIFlq3xE99dzb
	LIv5OT2YQCl4W8waACuY+Bqnbo+mMpcYkxIMyh9m0tTIDzW7By50SUjpXNVbR5v7YtLqssHcKz/
	kn+kMNAyOFZTGrjSbGXo4IGwqSUexH2DUYvqJbX2+2kZrI5A8BQyBJfD15sVdjM30A6ZrzPolwT
	hKJAPM7mlcIBmKtsRXbjuCivVxzGN5p38dsuYvZQQd6lpjDuPzgQn+Qqd0FPgcyzXZVtu54aEEc
	EYsLel0RbQMQAMkGhJbRo7nvmizT6lCDnkbG7+tz6ZtcRlKiYm5IPPBRn4JESngTLgcjsoNe0mr
	Noa9iEy6cwPE3K6ig13Z/QwZHTj8Wxjbu5SrcgTzMRRkVmJDzzhOpL+ANw1PqySWYywi+QXTgkY
	ylgyB4e3HI0Y0pPFjgNGXiUsIaH+zhwvREV9QSS4zGbZ0dyInvAbg66qidj8GFfRTdEjNIlEk22
	NuD0Go965ixYHw6XrY3sp5hH3B+Cz+jBSnp6yu/yY5g6FGCtv+4hjXN8wozHBDC5WLKFZTAPGTL
	IfVmMYUL1AqfhmzgZs0q
X-Received: by 2002:a05:600c:4683:b0:493:f783:c46a with SMTP id 5b1f17b1804b1-49cca3125c5mr67614085e9.6.1787995222205;
        Sat, 29 Aug 2026 02:20:22 -0700 (PDT)
Received: from localhost.localdomain (dynamic-077-007-015-136.77.7.pool.telefonica.de. [77.7.15.136])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b91c510c9sm80468505e9.0.2026.08.29.02.20.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 02:20:21 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Haren Myneni <haren@us.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dan Streetman <ddstreet@ieee.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/3] lib/842: reject output overflows from index and short data
Date: Sat, 29 Aug 2026 11:18:49 +0200
Message-Id: <441d06b2f8c8fdb25bbe552c71c7896d6da778fa.1787978627.git.kmehltretter@gmail.com>
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

The output length passed to sw842_decompress() is the caller's buffer
capacity. Indexed copies write 2, 4 or 8 bytes and short-data templates
write up to 7, but neither checks that capacity before writing and
decrementing p->olen.

Overwriting an undersized destination then underflows p->olen, which is
unsigned, so every later bounds check in the stream passes. Subsequent
operations keep writing past the destination, and a matching CRC lets
sw842_decompress() return success with an output length larger than the
capacity the caller supplied.

This is reachable through zram's compressed writeback path. With 842
selected, targeted corruption of the compressed data on its backing device
made a KASAN kernel report vmalloc-out-of-bounds writes in __do_index() and
sw842_decompress() when zram read the page back.

Check the remaining output before both operations and return -ENOSPC,
matching the other output-producing templates.

Fixes: 2da572c959dd ("lib: add software 842 compression/decompression")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Review notes:

  - Baseline i386 and x86_64 return success and change post-capacity
    canaries for both vectors; fixed kernels return -ENOSPC without
    changing them.
  - QEMU 11.0.2 TCG with x86_64 KASAN reproduced both operations through
    zram. A 568-byte compressed page was written to a virtio backing disk
    with compressed_writeback enabled, then its backing block was replaced
    before readback. Since zram supplies a PAGE_SIZE destination, these
    were PAGE_SIZE-scaled versions of the KUnit streams: the baseline
    reported an eight-byte vmalloc-out-of-bounds write in __do_index() for
    the indexed copy and a one-byte write in sw842_decompress() for short
    data. Fixed readback returned -EIO without a KASAN report.

 lib/842/842_decompress.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
index 582085ef8b49c..87d1e0f8a4926 100644
--- a/lib/842/842_decompress.c
+++ b/lib/842/842_decompress.c
@@ -165,6 +165,9 @@ static int __do_index(struct sw842_param *p, u8 size, u8 bits, u64 fsize)
 	u64 index, offset, total = round_down(p->out - p->ostart, 8);
 	int ret;
 
+	if (size > p->olen)
+		return -ENOSPC;
+
 	ret = next_bits(p, &index, bits);
 	if (ret)
 		return ret;
@@ -344,6 +347,8 @@ int sw842_decompress(const u8 *in, unsigned int ilen,
 
 			if (!bytes || bytes > SHORT_DATA_BITS_MAX)
 				return -EINVAL;
+			if (bytes > p.olen)
+				return -ENOSPC;
 
 			while (bytes-- > 0) {
 				ret = next_bits(&p, &tmp, 8);
-- 
2.53.0
