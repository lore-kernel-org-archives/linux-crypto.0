Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795178267;
	b=yLpF9Mvs/UzlpWV8Jsmw63+Gk+NrtEty/qB/NfEtiLDRWqQ0I2Gdwgz7GbD1EWEpdeWk
	 idACIHur2HARIGgsu43CLwmeotmrDraodzmDNJ+vcxMVC6hfo8rUSrrtE5lVrj1SlYrf/
	 XFE+I9ISVU7JwM3pCFVbco+BESSc3i3LVYdRIHxZlTIyujVXWXHGfg71u5x9r3+uikWGc
	 UEClLgPyintytG+oQROKLjm+8DyIN7642ugF9bQYi18bgWP74TGhHeDE+UpcMHJIwYyPO
	 OkslhvPc5r/ekU24v8U9MZw3FZr7+yOaz7uX3BeRPlfi2elEJ+jSO4DpG1zbE57tW1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795178267;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=YIwDvTsoMbycD6a5DXs0DiVLhqVOlC/XPJ2Lhc+16Ao=;
	b=Xh5eBqgbjxDW4QvabGypa3L6SnnDnrR0eZIXuFxC/nFcwk7jI/2p3vKtzFx3+AwvifSa
	 bMcI47cb0wBghz4xlMvZ9qVzNj+DSdQMMifvHVRUlPKcV+ltudOU9NaOSx0RvQXYsLSXE
	 EdRAuTag/8GHdnDzcXbIP4t3+xHjJrlY/WBrFEQ6sU3BXQuY27nmyMIhtrPGK0xBL8Jqc
	 jjU8iX7OQQoIMNBZfUkNKap8j/lpb4I+8lav6nYuBIa5FL/LtSp6RsC+K3hUbjpE6rwMH
	 TX+gobn+Dk/zIjhmexe/LCG/dMVOgTpo/eGEBXKu6imlBz+JoScKpJXOkXYwZsJT9KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=LYk7PZ6Z;
	arc=none smtp.remote-ip=185.125.188.122
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94609606A325
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 12:37:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94609606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=LYk7PZ6Z
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 14F5D3F788
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 12:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1795178264;
	bh=YIwDvTsoMbycD6a5DXs0DiVLhqVOlC/XPJ2Lhc+16Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=LYk7PZ6ZfZBtfkBHYiGZM6+tffhc1+P9HhGXwjLELzd4btilR7RH/14t815o93Duv
	 vs9KMy99o7IXc+9OjCLukA0CDPrbEDxBWeoCKfhqCeSsPKrr3r1nZrhJ8aVZ5OC03l
	 kDG3tNfWVSPZDOzpR8jg+qHXs6jNgWVEVfTSUc38XJO2er5usNSzt1kPb2x65ZZhdr
	 CEBMhkV2zBBbLTPEyuKmcpK8UFoOiK+Vjrl/LRK+2I02EBzdJ4OkA69YbOwIbSwr7r
	 cGHy2zO82VhBCFfenRhzbUdRWwkj5r/n0pRWqb7yvB8aPHjRpFZyPaEDMaqcKJadt9
	 3nDo6F30gHXZ4wLAOTNjcSUJoIKJIXzBH/lIz2DsXUXSsp4Zl5YNNZUJnPIcjXA9zf
	 wiCHi84CJoJ18HKN1Op2Z48jCvaFte3SOaWcSIeurioulYvSbsmEYEppGl2xUz7tbj
	 oLgq2XQrrBLQnmoK3HPpIKoIZkjXa8HWKzB4rE51pzjBgPhvFm+et3QwX4SGb0wEjZ
	 nIVHKO9iwUMoIa2kskrUEmp10Yn7pVoYv0PDGH+0iZYgIXLjjnmh7Fid/3vSuK5B9h
	 ++LE83duR2ygjWW6CoDWs91j73CCa9DgJuvD7DmdOKWJ+eHUXRZnQqqoUr2ouwaM/H
	 zpE71HoUEoRDpDDbqFUvd8RI=
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-386177b0516so1299176eec.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 04:37:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795178262; x=1795783062;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YIwDvTsoMbycD6a5DXs0DiVLhqVOlC/XPJ2Lhc+16Ao=;
        b=AM73AceQwglHFeBOjGtV1idtt0AcdcVUsjXvjCXIGTOLrPw8FRpLSTbOHUzSCudXCn
         8N9h1T6vsVmJ4K9imvHR8kBZgza1b+5pTLUS4NS2MkFgFDjHjwKhyExze1OaLvVokJwX
         kOF16rZ8zV7ZaRL7/HHPzV+M3RRZaklVC2seMJ37psqi9Fd7IE0VXJFhvbreQdKJbR+D
         95ANmN+Ze3fYD/i08KKc6i6hvPFcWCSxQZXE1RVsfWuZUZrwA6Wd3Z14/iyNB7Op3XV1
         YVdwJ6RHk7BrqJva6U35c2jmMWHjRUQeYhuV9L5Ws+b5HrpX/STq3DXN7pyNw+agX+II
         g5vQ==
X-Forwarded-Encrypted: i=1; AL+hErHoBe0AyDEu6JehXQ8nUundgeypVFH+6c9xiWC1XxZjlHcvDJVnEhAJz4sSxct5gBwrlKJMpNRqQvoeDn4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/GmXC+mgjU4ZaDslB/4V3cicspKD5EIy798zBgKGuc+JCaFeV7
	6MXPirbAo9K4a9Sfsd6Py0o+yQIlJY/lEt0wVHcpTgofQJGGLz9D3ZRL9OoalRQSmgz86Qysi0Q
	phuE1PKcBCZO0KB2CtI3keGdL0+x1bopO/R+ruIAhtw8N0MqhtoJrFZxTciy8YRZI/o0TKaAXLH
	xwV7+3Dw==
X-Gm-Gg: AZFdTZe5JQ+4BhJiWGBFbH3yn2UzNHkOUbYtE/TraaH5O8KF87o76DecqMc1j0Ye9NI
	MgmwIGLEZni9Ro7ORHKeoIIwyGqqQo/V213hhclhh0BOpE7RbG1AvxcWdOl7Z2GmE9Vm6spQaQi
	dpDLHA5zgtSE9hqIeBmwa+bWuZ0L4FGTUbItSytkWFUQShMXWwZsikKmzo7jqsHuRq4x8fH+UJo
	zs2uBb3zLOYc6q6Ks8SVpOQRx9j1QIiFyE+WyKlcQ8I31Q13Rkq3C20Dse4X36kSB9w14WS9T/x
	oPzwuOCTNP8dTS0/D0D9X1OnFtrs+ivWZcZqvUwo9V+D3oDVlRFvcdkWaU/fts+POdla3aCmyfF
	FkqMHwpVMX89KiftFieiKuIdZv8a0Nc4X4RFcxu8k7sdCSrlSc3wch7QJD0M=
X-Received: by 2002:a05:693c:20ce:20b0:37a:a9db:6bd2 with SMTP id 5a478bee46e88-3856e63b064mr2798260eec.11.1795178262223;
        Fri, 20 Nov 2026 04:37:42 -0800 (PST)
X-Received: by 2002:a05:693c:20ce:20b0:37a:a9db:6bd2 with SMTP id 5a478bee46e88-3856e63b064mr2798232eec.11.1795178261794;
        Fri, 20 Nov 2026 04:37:41 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385677c371esm7994093eec.23.2026.11.20.04.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 04:37:41 -0800 (PST)
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
Subject: [PATCH v8 0/2] crypto: caam - Fix RSA error-path unmap and unaligned dst buffers
Date: Fri, 20 Nov 2026 23:37:30 +1100
Message-ID: <20261120123732.1200685-1-changwei.zou@canonical.com>
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

Changes in v8:
- Patch 2: Add Fixes: 8c419778ab57 ("crypto: caam - add support for RSA
  algorithm").

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

Link to v7:
https://lore.kernel.org/linux-crypto/20261120110525.1170175-1-changwei.zou@canonical.com/

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

