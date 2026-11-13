Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794569824;
	b=HcisPi7DMjHuIA+CtBg6XztNxPsJeHIxgOY3WTOAXbhZOpgDSDZ3AGUWU2pdUnain9dO
	 zbNPew1gifWgCuHmlMecdGLts9OsOnpADbwyBvAsNnIpg6RQnkjGCer0TgKu6ssh6bQ74
	 ZBBEfl8HQnTqp/GPdEb8F7OGswMAqeOroMk3bEdymPpXyL/fZ+qjpaJLecbJsyyoBPw1b
	 TN2Ok9GcunltZFtKA2L2XbEWYV+OdxidVnocBVtoPJK/tZqjmAwbFtNMFRr9v5TwOI4Us
	 /hiWHfTGH+tRat2yt1tZ5lTj+0mM5nd8+54QOUES+AokHSPjN0UpAXpZIV6CPTzThZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794569824;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=HGeRCUdp/yqOm9ZASAHQapos9k5iYthDXsa49w7sek8=;
	b=OHZ7EeWNaudxX+c/UhatSm4LA8uhTiBupkzOjN/1stZrpfiNOAEkDuh5Nx/o3ZE1J93Y
	 XIm2Yn3VLzScd+2BjxiYajjI1w/StmG9yJyfkYTpj4EJcyRSA0vOlKJDbAOKHTIOQOPg9
	 xyJqNiCkyN/RwZze9lcGTCJvuN5cOh6sz/0C+UWK+PjaPJcMX4PUE93EBNot7LZjMwr4l
	 TfGHZ3Sdzqi75y7jlMzCxH0YP0gaEwB/1W9VDVTuoErjOgypcQG03fxuzS2CgR80Hd3Z9
	 AqoITzX40s18Fed751qsqYo6do86FGdFbBkwN0nxJS6tZIqcZczYZEZN7+jeEsC4iTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=Id6aZRjf;
	arc=none smtp.remote-ip=185.125.188.123
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309D4606A327
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 11:37:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 309D4606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=Id6aZRjf
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 05647429CF
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 11:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1794569821;
	bh=HGeRCUdp/yqOm9ZASAHQapos9k5iYthDXsa49w7sek8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=Id6aZRjfSG/aX2sJur3S9CVSFWA3mUUxXxP562sGrw3Y2sr2YkDu5CnWAQydyPL3x
	 esSVZmmkkqvP+LWUk3wZ6SxRAIUnLH78xidFW41uAqK7YM6pbUvUnxQrkCh1wQObcc
	 dFuvT2d6Zml14sYJpDCE1fsLFpS6d/yGG6V3q/l+KlhO0aeXRiuozBPA+rQ/cBXkMM
	 r8SQZKMrNAOYxIJpwM/ExfZPNzKTfXOYTx1grQ/wvhiqz/2m5bpEE4fjQeR0LDV22R
	 U261K8Xr4+ssNkUcOKSBZJKwcU//fWUNaiPq0pkNQxs2rcbAsrmZuxsrPBzVWHJrwO
	 fSF7WrKM+KsO1uYfLC8DdhVDAUaf8dIaXbaMIQTJiGb8D4XfwubymUVTkskDyU797d
	 HeXfHNPWtv/0aSUbHQ0RRf9+w5zRAN8ycpEFDFEUMRMNvR/tL/z8wxDpO/gweh6y2j
	 zWwVqj8pzir8ubIsPASYUBY9RWWW0Qzp8hC8v4O9PA7R/vOxxkjGNefa+3kngef9LP
	 Q0CyFua9PYpmaEfu40Qi2SLIQ0O8afxf81r/tiU+hH8HpeLFJgbE+bmkf888WG9vGQ
	 5yGnd74zR3jbRv6UmQhg7TZtGVM233C3jnYweCQz2tpR+d6BUpxDQuW1+zZCMreGin
	 wQotvd+hdtHIT4pbf+imHZ7w=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ed00709df0so8653195ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 03:37:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794569819; x=1795174619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HGeRCUdp/yqOm9ZASAHQapos9k5iYthDXsa49w7sek8=;
        b=nqzd4pFBeMitr0rL6a0Ump9j3RUb/9cWwj0mtR1ZrLEMY3eGM4jOxOcn+qOiffizdx
         Oabat9EeZ0Z+MADkmxyGnPTjvJV/gctbQFaK/sEUwyqQqcHeeTGpNB9DQ9IDXD/u+TB1
         /+ITzWbQb3awy05sbguTJSdFnbmdPfIMDxgphlzA8NwX4/NOd4/dgYoLqf9BzehN4tbx
         k8vYPl4RLeB2N+DWmg6+4Llld2JoUC1k//8C8AjSI+epbcDLhnalm+32dCn6nAvla+Q1
         6k5rU3y1WzRhFf7AzC9k0IDJ2I19VFsxNcRjlmgm+cdv/1CNp8P4YVVLvvRNgRl544j9
         9F7A==
X-Forwarded-Encrypted: i=1; AL+hErF8DerboUyuMC7wv0up0vPENCZgC2Y+noyrKXw1Mnga4LzXpstnMQs61ZNu5eujWz+QXlsYSBElMQm2LV4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/xvdGlb5nCE3nTkQ/WPSWuy/peGD6qORV9ZP6lD8Z6P4r42nQg
	nsRC/8Q0gh4pZOjdJ2KawuMHUrnPIJfqeMfSbThBqlELl9NYwLE/3DQ3O8pENVp8/mezUnbnlo6
	t+SkWD136QV53xl5boW4+E1R5TgVxvbifTmzm2qN5Z2R8iYdTLm7O2vgpBMLhlp7sQwyqek8/BW
	XrSQkKYA==
X-Gm-Gg: AYBFou2IxwTFG4N7Z7jg4rd+9NId+yf9ANn9lV034atiJXgXUSnl7V9OAFa20ScrXQa
	o5wRo3KpC2Deq7nkRf7COLFZVqDSxW0ymmNHV1FdJJPasNgAvG9NQVWx6LZH3X625Xl6NK/YYaC
	ews5wPtNAama+Cdu17XPfaks6fYKi7B1V6clCDmYLJsRMmSMVo1FTGR3KKm7c2OxOMrXQjCU3f2
	B0cPBUNAlk3UK6q9HdYROK3lM58zCzM16bgkJWGNPa5Ye/BJQ6v7U6zvhcv8XSGzv8OgpKv4j7g
	Ny58rt36ZUxxLtEidEdQN/CgDlnc+1Zz7mj+ODu2w0SiYgInEMk20opdW0SYYg1SAJJwQK7Jwkc
	ueD+Kh8+CZDUBbmXCCeL1xKviP+PjZY2W3FqvAeE+M0ce/MK0LZ6saXKjWuE=
X-Received: by 2002:a17:902:e951:b0:2e5:54b9:6b5c with SMTP id d9443c01a7336-2ee0da98ceemr19485895ad.20.1794569819157;
        Fri, 13 Nov 2026 03:36:59 -0800 (PST)
X-Received: by 2002:a17:902:e951:b0:2e5:54b9:6b5c with SMTP id d9443c01a7336-2ee0da98ceemr19485695ad.20.1794569818758;
        Fri, 13 Nov 2026 03:36:58 -0800 (PST)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f80b7f6sm8757445ad.40.2026.11.13.03.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 03:36:58 -0800 (PST)
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
Subject: [PATCH v5 0/2] crypto: caam - Fix RSA error-path unmap and unaligned dst buffers
Date: Fri, 13 Nov 2026 22:36:48 +1100
Message-ID: <20261113113650.63038-1-changwei.zou@canonical.com>
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

Changes in v5:
- Patch 1: Factor the public/FORM1/FORM2/FORM3 error-path unmap dispatch
  into a shared rsa_pdb_unmap() helper, so akcipher_do_one_req() and
  akcipher_enqueue_req() no longer open-code it twice (Sahil).
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

 drivers/crypto/caam/caampkc.c | 157 ++++++++++++++++++++++++++++------
 drivers/crypto/caam/caampkc.h |   7 ++
 2 files changed, 138 insertions(+), 26 deletions(-)

-- 
2.43.0

