Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794438155;
	b=cRZ8T/u/jdyLra8zS28gLLvSurY+xzRh8okHaKNIxnNU8mFWLOECS5tVuQNxe7EhUW5z
	 ia5Jr4YztUhyuhzYQNnsb92W/4QY+V/Ya8csbIgFo85KWMV9A1QbgsNDjrXPHpyiKhr7Q
	 +Vp/tQzhSDnl1kR9mDQ2o9hWfN3vWNQeOGpAvx9zXkvEQw9NHkJF/ycrZsal1Lpa0xL6X
	 7MRq72K3WFgwbLCI6VqPAbGxFuIHmGPUUH5AbLyRnSPtIYjTtiMN6uTnIL7eCQR2ArTsv
	 2uPOOpE/LG6yKuCB4tNBb3JAL1uIvp3nPDYOKm5pZafC5Y844iLaJA9pMj6q1rNZN7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794438155;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=ztbvpldWNAclg2Azry4ypJeBe0ZERrAJ27Pdrbt2f64=;
	b=eFdm6/1tMl//AUM0AF/G3oTy1cIcETJrgNB7j800P8HHBSFe3yZ8vTmbG6h2KfHgxKxR
	 g1YzdqUj4jUMdwzNPaZynoeR4J1pbEF76MT4G4B9ATfqMv71ncSYUZoIxN5kcx/WBKoiP
	 yff4M9PwLWIKbcgOZa7peZz8fUHEPb7t7Pg8Xo/hpocMkcYAH+CQ0bxdRFeXCvo1cVsZw
	 8nzPWUn5rdFLdSSKaOIUHNN4VbNhwIGpamw+f9ak4ewBx35b6K4KqScNqNPFDfIGA/j7I
	 35TJ/vKElR5bbOYSC8hdalLnIsIBS/MFiCTtExYs9QzjtOuHd0XTLcVXDjwn2mu/mlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=ZlDhI0LQ;
	arc=none smtp.remote-ip=185.125.188.122
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6755F606A321
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 23:02:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6755F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=ZlDhI0LQ
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 8757B4029C
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 23:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794438152;
	bh=ztbvpldWNAclg2Azry4ypJeBe0ZERrAJ27Pdrbt2f64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=ZlDhI0LQkVO5l8r+qUCwUa3E+IdnHOot/rbj/CdgOGazSD2jPhXD22LG8Xp0KBDY+
	 2EBXja2FUdAWTzAfRxMOasaIzgdzHoareW1Nea2V7yIb5SZM8Q3qckQnNju+VS0oSK
	 IYj6jEGeFhGNldYePKQl0L+nPDX7JMz7TyBpkLcj17uEbbVJFgzSb8TJtJsnqiVGxV
	 IuY61qZ6R9gAAg/EOopRIZ8nzCn7N+gME4LnT3Fs7Tv1eysOx4PvBa2E/aSfePVC3/
	 KCPK9DJnip3t3IZdvLVYVyPhkuVXrdar3V1oahIpRP8ctX4ZtcrmTKz7vJLgGiCrnc
	 m10oFjXmBTt7ReW4hDDeEYiKaIMYcghx5dNg0CtcRDVJs9C0nwokH19phmio3QNK6G
	 Rqg/9qAfGq6979dwgkH1gtrB2Vaojj85t90dw9s4jcJ9qbWCewo38cI/7OqUaastlO
	 Sk+/wguFToNsR/V3kU3Y0vYQ0h1YVW81GhCiPpGxp/GdxO4ahO+jpq5IYOM0dsh4Kh
	 pQcIilslx5ew+JUCmccFFk54x2VnErUeYL8z1QC98T2em1Uqo4MB5qecHrIUWjwPj+
	 3DIbgggBBgWgOVruSpx3CDoIh9VtrSuV8xGZx2FwwbsOWQLtW3C+Q5TprjtG3Nj2L5
	 iBayUAN835b8FJ1Lu79f+ZYw=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8b930598cf0so4456935b3a.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 15:02:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794438150; x=1795042950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ztbvpldWNAclg2Azry4ypJeBe0ZERrAJ27Pdrbt2f64=;
        b=2dYqjrnYVErD3wOlxjpMR+WDbfTVnEfWH4YkHfA4jPebCoXqRQnd6JihbMt0DvFPQO
         SyNbGqbehq0gBL4RUyMtcaHGuca3swkQzyKE5kEMt5bI7FMOf4dgqCwBvwg7S3s0g6YV
         Yw7BhL7d2JOONTPNUBKuqcvs+WIA9G9opB+tT76hT4ZNy/+GiGcJo2wE7ik7jwD1Ga5a
         hV6dZsw+IXF5dlp7cf8iOR8OxIyf/mVXL/lyKrZbzOiYBVSlfPUEeYasHZkxb4kmL5SS
         wwU1DCLJVUr8Kbap2iDI5OE1mdLMtd/vrBI5UA7ZR1vtFvzS2NeyaQGH0ojjRKljWRkM
         scxQ==
X-Forwarded-Encrypted: i=1; AL+hErGdUqn5H4wfQ15cFCFRQXmncTnXIYi4xzszF8vGXnqxBB0yCwPTjqM9M0PRcAIf/nJ0xUmMNqrQCUeNdEI=@vger.kernel.org
X-Gm-Message-State: APuU4Z/zOMCnaN8vbxOVD4duub2tVWLg00HA7xluNQh3xIukAZOaYB0z
	2tGgSMwLd5iJo/8yp6OPvfGl0zNHSz5duGhwVjF1TmNopJnPg+9RnaoeaL7Gt9eBDuu5LITAaWM
	yCQ8QfJLO0zB4i7U40cW3ME4VTI7oZIyI9Mi0RNNkOcPxZw3CUiAWrNLD0LjvDQhunzeBr83e1N
	PxSbDIpw==
X-Gm-Gg: AYBFou1QzkwMXwid8houlWFjy9vUMclyfhcGBoBQ4F8yVneH2Y9wspMTaRBu2XRW1E4
	6rOBIy6aX2pBUlVNWymYhGNdConVcNZ6tC+q55DfjGzWs1vTQP/ameoiev7/Wn4wib46u/ikor+
	1vLXKUp96mTVzqJEcF/aeZ2pRngt9UIcWfvrrKUEnBjLduE7uym6r2iljKyotF594Q8chYXiKzt
	YuuYd5xb7h2ErG8/5NP2tFh5wYj3Hu1cA6kT21jzCZYdWg0MXDrhPpRnfzCjpEIBBTQknqHAsyh
	3GiEgcX869D+ODOLJ+DccI288p0hoV2598ebjTmUh+odh9m9UmPwKjJ44ta9hoDlrTpqjXV0ReU
	lTpQSyIBt1XFO1NrTXAhyNy6/6hlKC6znbZz9BOb/EZMhF/WUppbOlSvP+r8=
X-Received: by 2002:a05:6a00:3385:b0:8a0:3072:ee9 with SMTP id d2e1a72fcca58-8bc1b8f8e9fmr4260508b3a.13.1794438150589;
        Wed, 11 Nov 2026 15:02:30 -0800 (PST)
X-Received: by 2002:a05:6a00:3385:b0:8a0:3072:ee9 with SMTP id d2e1a72fcca58-8bc1b8f8e9fmr4260480b3a.13.1794438150134;
        Wed, 11 Nov 2026 15:02:30 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab4fd5c6sm2531211b3a.46.2026.11.11.15.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 15:02:29 -0800 (PST)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au,
	sahil.malhotra@nxp.com
Cc: davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	jeffbarnes@linux.microsoft.com,
	stephane.debusne@cynove.com,
	iuliana.prodan@nxp.com,
	martin.kepplinger-novakovic@ginzinger.com,
	lukas@wunner.de,
	sahil.malhotra@oss.nxp.com,
	changwei.zou@canonical.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] crypto: caam - Fix RSA error-path unmap and unaligned dst buffers
Date: Thu, 12 Nov 2026 10:02:19 +1100
Message-ID: <20261111230221.40297-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
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

This series fixes two issues in the rsa-caam driver.

Patch 1 fixes wrong unmap operations where rsa_pub_unmap() was called
regardless of the key type.

Patch 2 adds a bounce buffer to handle unaligned RSA destination
buffers on DMA-incoherent hardware such as i.MX8, fixing intermittent
-EKEYREJECTED errors when loading signed kernel modules.

Changes in v4:
- Patch 2: Describe the bounce scatterlist with the aligned allocation
  size (ALIGN(dst_len, dma_get_cache_alignment())) instead of the
  possibly-unaligned dst_len. Otherwise, on
  CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC systems, dma_map_sg() evaluates
  sg->length and can treat the already aligned bounce buffer as
  unaligned, bouncing it again via swiotlb or failing with -ENOMEM.

Changes in v3:
- Patch 1: Dispatch the error-path unmap on the operation (the completion
  callback rsa_pub_done vs rsa_priv_f_done) instead of key->d, so the
  unmap always matches the map.
- Patch 2: Bound the bounce-buffer copy-back to the RSA output size
  (key->n_sz) instead of the full dst_len, so the trailing capacity of
  the caller's destination buffer is left untouched; add Tested-by from
  Stephane Debusne.

Changes in v2:
- Patch 1: Add Fixes: tag; pick up Reviewed-by from Sahil Malhotra.
- Patch 2: Move the !bounce_buf check out of do_rsa_bounce_buf() into
  the caller rsa_bounce_buf_done() so the helper is only entered when a
  bounce buffer actually exists; add Reported-by/Closes and Tested-by
  from Martin Kepplinger-Novakovic.

Link to v3:
https://lore.kernel.org/linux-crypto/20261020025426.955531-1-changwei.zou@canonical.com/

Link to v2:
https://lore.kernel.org/linux-crypto/20261004210200.290119-1-changwei.zou@canonical.com/

Link to v1:
https://lore.kernel.org/linux-crypto/20260821045555.806471-1-changwei.zou@canonical.com/

Changwei Zou (2):
  crypto: caam - Fix wrong unmap operations
  crypto: caam - Use bounce buffer for unaligned RSA destination buffers

 drivers/crypto/caam/caampkc.c | 131 ++++++++++++++++++++++++++++++----
 drivers/crypto/caam/caampkc.h |   6 ++
 2 files changed, 124 insertions(+), 13 deletions(-)

-- 
2.43.0

