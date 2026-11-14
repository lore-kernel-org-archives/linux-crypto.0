Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794636052;
	b=zGrhFiIQycgM7gtHQf+6VEfX379Ffsbetpco9YaQ0Rt2WdjdR/jUXcY0jIpDSu44AW7A
	 KkjgNT0tjKqhzJGJqTY/pRIGSU32C+dPyW3RJczRMbT/igiXdq5bmtYL8GdVoUEAle5tB
	 EUWkBsn2Lr2juP1obevDgAWacelJBLrQvxiWuHR74FLnKIvtDRQVljas8L0ufSRuQUFtz
	 OJh7JKK0339LfumphjfaCCTi9ehrS3vgLKaEWYSHX1edGtuI5MrIX9boGSpkLqmZZycDf
	 ABliC+lSF7ZfxZz5IYxC+zxhoGBlI+Qt+BZFyzogYf8KU5r0S7cZ7VdbXtpiPj+QuGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794636052;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=XT7zRCHvVyruRHBRUx/XsXN32kUCmgefaqjrYi/Gicw=;
	b=r2EMNU1AG9nMvg2xjebyKk4QW3LaMHZKuBO24Y9YDiomq6bebs6QUcTfZr8FNqJXezs2
	 8cRG7wwGpp8T5wsQ9iPBSCezSrup2LP2IT6q+aLzKqI2pIgmk9v9O6UlfKw3MZYMGsIWq
	 NdXf7fqvdIIdnfDN41pfo18VWhRgpA1FwTBsDb+CUp/pO8Lg4ld7C6hwQo01k1DTo23kN
	 G4OsCcpfNs7YQCnS06jEztvZ8+NgP/haCFlU+8ghDUZkiGUfam7LtIeTOHXjMMrRpzNZN
	 xJ5noz4Un/KtvD4dKLF1XtgRg1gJsutooTt73YPMqr9qoudpcz+Xi4E6YeyQClJhZWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=EdBZ27ZQ;
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64375606A337
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 06:00:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64375606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=EdBZ27ZQ
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 09F5340330
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 06:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794636044;
	bh=XT7zRCHvVyruRHBRUx/XsXN32kUCmgefaqjrYi/Gicw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=EdBZ27ZQh9bD5H5sOT2VKMI0YxhyhzDu7qRYbi3B9wdciSdg6CKRORrM9wPNCO2Pu
	 2uXM/mKytiy+nVm0nPiuFMI2JLJhYB5iHF0ibHDRqxGMhBSlgczmIDJUmcUDD4C4MN
	 WYQOYmBeCLWNxTtSt1rDC1l88gIhHHyAU6qPKjP0v8PxCD9161kRbOvZby9jf4SgZj
	 unaAMFr2plJxgXjR1NrpJTcxxu2fQU63v+l/iZhki6s+d17QofnrcQePQ2gk0qndHE
	 Rlspr69VsXemsMML8HoCjWSSgQVDFlbGm7VftKVgjGkRnqYjUxs7M4RK+fux1o1hWt
	 ZMO8xNizD6AD7uoQ9lcP1FVhEIY3Zpkj0eVVjshx3xM2dhFAJ/HrqCV1atTrCOsiCH
	 bhdree+Grt+Od+Pi7XuouLxPg6L7B8d08zRMDrv7zWjeHzDewMOaxxZUdGJ4ZoPOEn
	 1bC8sG/oVOD03MKNygXTmsUkmMTmgGzmkqczf90+YRT1FxTm8YqTI/snmgi/aJUF27
	 Lwy457cpfS4tUtIBd/XqRewcVjc9EkM1AEm5tE7CpCvScCE8kMXYHBPN4Wi7pns4Qc
	 B+Vz5ZC1KO7cy6qvLvcRYI2O3Ks3ttYCKDEI+4Hbf1fZ1iCZ4dWp9fFQ7+VpGdUDri
	 tvyjnnJUAqyPj2JZnkHeMOl8=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ad704d4760so1294203a91.3
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 22:00:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794636042; x=1795240842;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XT7zRCHvVyruRHBRUx/XsXN32kUCmgefaqjrYi/Gicw=;
        b=Jl7QsNkHF6y8VzKxn3HvOPKyNy39zvhr0gAGSclNhtb+/CdZLCgXwgIU1j1uRkYhq4
         TZnCVb7kww55CGi9DkXOAZVDSsy6VvBH6KagF4gv7afTlBC9cJTUW0Y427X/3YhUnIfJ
         9YNvdaHR0aJ2UQxk9D8bbvIB+1jktLQ2xcy7vxOBmg3jpK+mBzW3N6mTMyWN+99NlEIr
         guxllYj+lEuCzSw+lSGHkWyS1BAK5OJIS2f1cNimi13B8VvFcocmBVenK/X9o4Dw1kUc
         k1t7BKpnP4uL8DlXqVJsd6KaauqzepSD5IdUB3Y+ool1H6KC3MoVqmrZ0227u2CsgdSN
         L6Fw==
X-Forwarded-Encrypted: i=1; AL+hErFok8+LDaCkr72hXXCsoi5yPRyxB87i/FoNBc9NQXHXFdg8tLgpb0Rjjw1srq1VTiBJnrN/TXkibPMy3Ok=@vger.kernel.org
X-Gm-Message-State: APuU4Z+eUQo2IjN/CmWfdFXbLaqkjZh/zKU/qP4YctT8FaLjnE9SjlNp
	U9yJgVefwcy5ea9O9Jx74qSvtMvj+NLpmfwAAKY9p8ZAVmsHCG3JRx0nYLwSjmug5eYqEHwkEim
	u8T4NuwsLBXg5bB87kXbmS2j4erW28VFsYEP36wi3YTVFgbC5belBwfdp5+q9DxKOUW9rpMkpzK
	g/xzUDoQ==
X-Gm-Gg: AYBFou2v1DxZq3of0ewAzAniusmBddh6lMHwC3XYf4e6lZSfxppTvWe1FAnWIWwjUqR
	IyXCc/FNUnS/7dD8Fjjt96Wnj2/VkDmEAFeeaavNrfPq+0jzysgdnGalO3eYng+mbyDEQo6/VCS
	hjbk5hxF+jP4IL0eoeDq/4cgg0tnNY5SpBNmMath3PxmbTK6bT9we1qYOvoNMGvPYKX/B+fnUPE
	oGsGAiTXih/JmYEZZJjnIlETgPsyu0rZadh8/1JxrCWvzIwti1Z92chF41Of/WUs0K84RsJbnIh
	9VKWEehGHWK+U8hhPRSMQJ1p5D5qViQnmjZWhq+IRIRce66x+sD0QnjBtIgq1dz7PBpz7Z7dq7d
	c3TstLkECe2iKoLS2ftlnkXh0mXboQM1GiAd+vvL+gZOtqWI+XXFNz57NHTY=
X-Received: by 2002:a17:90b:1d45:b0:3a8:c0cd:57f3 with SMTP id 98e67ed59e1d1-3b1b09f3aeemr4514282a91.18.1794636042318;
        Fri, 13 Nov 2026 22:00:42 -0800 (PST)
X-Received: by 2002:a17:90b:1d45:b0:3a8:c0cd:57f3 with SMTP id 98e67ed59e1d1-3b1b09f3aeemr4514256a91.18.1794636041876;
        Fri, 13 Nov 2026 22:00:41 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d32ea0sm12364451a91.15.2026.11.13.22.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 22:00:40 -0800 (PST)
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
Subject: [PATCH v6 0/2] crypto: caam - Fix RSA error-path unmap and unaligned dst buffers
Date: Sat, 14 Nov 2026 17:00:30 +1100
Message-ID: <20261114060032.872141-1-changwei.zou@canonical.com>
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

