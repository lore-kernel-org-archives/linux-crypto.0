Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795172746;
	b=M/4dtakEq3o1YjbWiU/ovz0THwBbL6mTNeUyt4/OcVKIQClbT5jM8v4BBaPG8vSkZsUK
	 9dPts3A+DkhUMKvdgJYmEcnltXsZGYRnXY6l0evv2TPKnX7mRJZ8TkeHw0qOrg/PuoKvo
	 4EUVqhSSnCzfdo5XoTq5+vU3aIf2iHqnDfHoosq3BLxQw+BMCW0DrFoBefHZ3aFyas0gG
	 vwjR8FLQKBATBun3z38Eu8JKuTMfUXVpB+YqOY1/pu3VzFB4CYS/VCRGI9UhJ70JS0ZBd
	 mMudJjGIDTo+25dr42J+LQVstNI83b+GJQd8/iYCfs2dwrI38vrB17q7lzBe3A6GocA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795172746;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Up3Ra2D38K9llmN8TqD/ail/HBaup0j1WqSqScUZniM=;
	b=ZSKh6OEkD0FLc9M/0aMTlRXXwQ8dKOzAq8l2va0ZigLHwMP/j3bD/rfUA3IjnXi5Gp1S
	 BRSOOyxNYo83v1gLs5A0eul40W3I55K8CWtoFg4tuuBOHxvuHaME+609GpdRQ6REHN4Id
	 FBvsY3j0yndfPni6weeZPR1+vKwSvbqikJdA0a552StD4oYQf9iBEU2OZ8c5qgftgNQ8l
	 78VG1/koTFxNY+p4nP9+ZF8B0dRIFoF7+Q8hYLKdPW9LkEquQrvwz0GKM5HlQ6Yqx8XT4
	 B/X3h3wUat1geUHIgLGrOHCj8Q6vM/aKXr5CQOBvhid8yJrGIueERyHvt4ePHXLP3sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=LTdU41t0;
	arc=none smtp.remote-ip=185.125.188.122
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA5D606A339
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:05:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FA5D606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=LTdU41t0
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 926E83FE2D
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1795172738;
	bh=Up3Ra2D38K9llmN8TqD/ail/HBaup0j1WqSqScUZniM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=LTdU41t0pzmVEoUJ3lvOyeZjJVl9KSUlrQzGZd0sqSqV/N0ab6OxQylsb6xDTShJY
	 837SFCz1iRWn3cTIZVVvuHiATud7YUDJjuJRcuEtmZsUTN3Ai1UJ2lJtTaYxf+tZ3Y
	 8Hptew1dmKrfTEoUN9q41TSgjAnh8dYsHiNEiVDYWYO+edYY4ZYG9RimuuuTCfYmaj
	 fWVQhIdKfYqBkGrsp/UPYTyffzKLLoEt3334jZPKV+yV0pnA1JceD08VtYuYxXrhH1
	 6ha+/9dr1r/qzmra+kxdcSxskKliNJ5Qg8A20XW5gzF37jJrbNhvrxr8rCvRWEfRfL
	 NgczcMjzNLZgy2MgoeD4KZEl873B2Vjdu0pidVkSaboOFyfnQCZ3gK8mqZ0tbD2V92
	 mlR4E61Jspgxv5C18sPhwzvhC3ON8w37k6kkCtIwa0AbsLZt7oDQxnUarcM3GjSRV5
	 DzDukoYfznNXc0e/ffWqE/H3W4GNg+sS0vsmy082cKq/Q2KzAGTBR+1U92FOi4a5G3
	 FqBzHJ9bIOGTBRjWNgrLKYT2lzVystZMlUUeLkNGq7RrZNunMXPWDFHHO7JykFoXiE
	 dv+36VuimC+aCzicphWfZd5wCnxkqzJBRTnStuoJAcYBIxjWD6VK5tSMnJl9FajXoQ
	 0MMCIf9vZTcDP9I2eS7RITts=
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33713e5e6daso1351297eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 03:05:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795172737; x=1795777537;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Up3Ra2D38K9llmN8TqD/ail/HBaup0j1WqSqScUZniM=;
        b=qqwgShtj048xwnnNdoQdrgpxE+W6ErT4mL/FgvgWIXCB70eGTkIoIMEQHzB6Lyz/dS
         sVOxcAzyZlbll9xsFRLHdV38BbKbpmkdHEEXch93ghVrmBmwr4ECrBpViwrF9W0Htu0q
         vaER5UesyrZxpEnlrDzHv9GegZ5nHgBFVkgBvVM6WLWPSXy8umMTEC+wB1SqiQ+Le+6C
         eirzJoEfoOm22E3MRIGHongVm6EuuWWjruyBCB/+nq6ctQ+I+KYVeKBOf5sU2cODCC5P
         bijbkUQdta4edZeusAIvo9+RtZ2l4LbMWKoEmF/J/n1y3zi4ZKTtZA7nsmY6NNJmZpuI
         uheQ==
X-Forwarded-Encrypted: i=1; AL+hErGWLI7zRTeaB8iyS7ysdw8485KPM5PfTwfeyyoL9L3tsxB3TyCk1QGFnPtQGNimkMk4/MKcEvHBHC22kCg=@vger.kernel.org
X-Gm-Message-State: APuU4Z+PGzjHqONGsbbSpdjte/f8L9AmTkCpAMslZY8yF/LuMwU0B3gE
	7eVUblTxzT/1TN5s62sJ/31c1haz8nLU0xmH4Kd70xfoMpGETO/jRqRTLXoJxSudLBDLz5hIiUD
	2q0kwEyp4flaVKcmV8tTS2j1xR2/Il35xDuDiuezsvvRgloocFVpKaDT1BCNbVhWMcj1KfRIwkL
	PYPjfULQ==
X-Gm-Gg: AZFdTZf95FO33l6dz05aVQ0Ke40zvbhKOUjs86WeiLhgsuNfpYAjlae6nfPqipJJ3NY
	jXez1ZbjACvJzu9ubhzJsc9ptWK1LDexAEofpWbIJV+2eV/NRRJWj4DUbu39y0JY/9QDB9BuPiy
	2c29UX+XPiSlYZWDqQkMNHggCzpX/KGJlUKu/t440zuTXZTaIaatdzYOOU3XcbMTo6Xr6N4L7Dp
	WgkP+lK2B+fdcPQoxLgeYvdIbIFMBRkGju/YFPAnEbkqHoKhCgbNiK1BM+yWg1i8RKch74W87Zc
	BhePS35TDxSN7Nna+Tmsl+N3XqdR+V1lyIuJqOfD4wjc2YjQmpH7Rp5qnQlXJsScsEp5VGP3S/g
	841YMkHOq6EA1bz8BcHHefemmWzURRjOcQkELIF0VacNA2wB4tCzakSTSa+c=
X-Received: by 2002:a05:7300:1486:b0:369:d8e1:7bb6 with SMTP id 5a478bee46e88-38570e24c35mr3304685eec.25.1795172736664;
        Fri, 20 Nov 2026 03:05:36 -0800 (PST)
X-Received: by 2002:a05:7300:1486:b0:369:d8e1:7bb6 with SMTP id 5a478bee46e88-38570e24c35mr3304646eec.25.1795172736044;
        Fri, 20 Nov 2026 03:05:36 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3866f299d0bsm814874eec.19.2026.11.20.03.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:05:35 -0800 (PST)
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
Subject: [PATCH v7 0/2] crypto: caam - Fix RSA error-path unmap and unaligned dst buffers
Date: Fri, 20 Nov 2026 22:05:23 +1100
Message-ID: <20261120110525.1170175-1-changwei.zou@canonical.com>
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

AI assistance disclosure (per Documentation/process/generated-content.rst):
the OpenCode agent (claude-sonnet-4.6) was used to help analyse the code
paths, draft parts of the changes and the changelogs.

Changes in v7:
- Rebase onto the current tree; v6 no longer applied after the upstream
  caam_rsa_set_priv_key_form() changes (a91d9346a70b, 828c3b265b6d). No
  code changes.
- Drop the non-standard "Assisted-by:" trailer from both patches; it is
  not a recognised trailer (and fails checkpatch), and the AI assistance
  is disclosed in this cover letter instead.
- Pick up Reviewed-by from Sahil Malhotra on both patches.

Changes in v6:
- Patch 1: Factor the priv_form switch into rsa_priv_unmap(), shared by
  rsa_priv_f_done() and rsa_pdb_unmap(), removing the duplicated switch.
- Patch 2: Hoist req_ctx to function scope in set_rsa_priv_f{1,2,3}_pdb(),
  removing the duplicate block-local declarations in the src/dst branches.

Changes in v5:
- Patch 1: Factor the public/FORM1/FORM2/FORM3 error-path unmap dispatch
  into rsa_pdb_unmap(), so akcipher_do_one_req() and akcipher_enqueue_req()
  no longer open-code it twice (Sahil).
- Patch 2: Do not overwrite the caller's req->dst. Use req_ctx->fixup_dst
  for the DMA side (mirroring fixup_src) and drop the orig_dst/restore
  logic (Sahil). Expand the commit message to identify the caller that
  hands in the misaligned dst (rsassa_pkcs1_verify() /
  crypto_akcipher_sync_prep()) and why the DMA API does not bounce it.

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

Link to v6:
https://lore.kernel.org/linux-crypto/20261114060032.872141-1-changwei.zou@canonical.com/

Link to v5:
https://lore.kernel.org/linux-crypto/20261113113650.63038-1-changwei.zou@canonical.com/

Link to v4:
https://lore.kernel.org/linux-crypto/20261111230221.40297-1-changwei.zou@canonical.com/

Link to v3:
https://lore.kernel.org/linux-crypto/20261020025426.955531-1-changwei.zou@canonical.com/

Link to v2:
https://lore.kernel.org/linux-crypto/20261004210200.290119-1-changwei.zou@canonical.com/

Link to v1:
https://lore.kernel.org/linux-crypto/20260821045555.806471-1-changwei.zou@canonical.com/

Changwei Zou (2):
  crypto: caam - Fix wrong unmap operations
  crypto: caam - Use bounce buffer for unaligned RSA destination buffers

 drivers/crypto/caam/caampkc.c | 177 ++++++++++++++++++++++++++--------
 drivers/crypto/caam/caampkc.h |   7 ++
 2 files changed, 142 insertions(+), 42 deletions(-)

-- 
2.43.0

