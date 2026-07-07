Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A10843847F
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 17:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783444559; cv=none; b=H9Tgkjqo+2Zzenpl0OX3QOy2etfN3+1xYy3LzRKoVQKK1q3uAGsy7ruiiwndL+olMy83UyHiBHpTh+tXOsId9kkiT7KUdTYLxKBMcr/glckhgoRxSV73xEtGZtSdgPLVMavzSUD1EXefEWNAxMkGV9vPv4AkPbxRKqKDu4onrhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783444559; c=relaxed/simple;
	bh=10Mha+rr8r0djXqoM15tF2PmLDWsDMomIMO/5vW/vLk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wd1kxl7ync+7GwYk4wYnvvLFFLIr53u6iSV/46um+t9iqgVkhgdayB20kVP76JxOgZpIR/uJ8uJn3DwQBhgSc9EbwMYGFCOL8fgnM7DKm8+vlPxS/qbQ6HZNkCQMgLZBuEoEeAkLzGeflAMIeY+EMjnpkqHoTvj1VD3m6fafJMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LNP3ojpj; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LNP3ojpj"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84780c95e2eso3707638b3a.3
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 10:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783444558; x=1784049358; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PqhZWbzzy0RZ+tTYC5Zxee2buyxObsMSHIZeaXqnIUU=;
        b=LNP3ojpjssRn6UjOF0JG2m2JX+ox1jzKYL3IfgEOcJ+y22+Wgj0RbHZibzK0OYFAdS
         O2wCd/DZh0NYEetSdmMn6nNyF4nENrMTXeuTwGMG3jEGr0sfsxVZdNYwDMk63S2q/hQy
         Gb5A8qFspIG4S9JkVSR/2hlsRwGURYqtlXeL2JixyleS1DyLdzVyF14URMiRyMPGbH6C
         N0gp6ZbV25nJEh9PWoA53/AjsgcRf7U+SEOgibXnHyD7xy8fGzTwsBmTKb84s/BPKEfV
         9GznG5j0XrTEJHR5hfCAFR0xCGOPUZP3GXYDy7ZMhRb/XkE+DheDFaKlhnCoeO8I2ePZ
         uZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783444558; x=1784049358;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PqhZWbzzy0RZ+tTYC5Zxee2buyxObsMSHIZeaXqnIUU=;
        b=cqWa2DKokSJsNOHAkka3hECGLq9JhDJwcfi3xlyxuI8a8XuQy3n6zwbAeirQG5FO4Y
         Ns9LN9dp4u5VmeFu3b8fQo13OBUQV/0C5OIuiiOLyKI7wu+g49cAVnJDN8f+aHMma75j
         y/1yc1ucdXD4MQYwraEL1DDeVCAZqtsuX2cu3MhO6ur29hg1+LWrBiIVwni9ED/726vq
         K02YloOBW8mNVJiOUJ+syc+Ep2yGZYgnvM+yx1+fSLCC4kBOrV26EnxqqKVZhVjhfrkA
         Xij+Oz7xhCAUwHgA0bURCure3FCGrCBhPh0WoZguAq4+Smf3iPhreoDVtz2TWGyVrAMU
         EiAg==
X-Gm-Message-State: AOJu0Yw4cKPBpueahcux/K3UJlVUdxlffnLw191JgkUZFiueRApynsBQ
	uJa/erzyD4Qmyb8+vWyqywC1rcPuw62W7mFE++oGeC99F1xE2rkP5mAwbNdI4KCD
X-Gm-Gg: AfdE7cnACdW955LVLAxJcopUME4LxeaxGdR1gmrvQl5gf4O0tPrjTVDoepVjk2ordNg
	ZuCF2QE6GmEqPsERufMlB45GRcKofe4C01jXtuy0kLB03K1VY7dj9YmtKVxL6NpffJSmFXw4VYK
	n+Gh/4k4+/fgb9cwOrNcCPpEVnB0G5Hvka2s6z+GjL6Pi85jud9bHYJ2Clbion4j77YxkAwZdJI
	EdV0IZRNPJR2B9sk/uvv4dZo8AI8i5kham3R84YU6zSNycSXRPvyrwmB1yzX8BIUCRqXWbRNtwl
	So7CgssuPxlxCmuvJIoEVKo8sBifnYN5pDiTeBHHw6GIFoo4zaxg3XMLpcMfbVd3PWoeE6GHksd
	ocG6UtQLPmThk0J5ww4uy5p52dmaR8h6Y6n/5La+U0+n0qJAAaLBws8IkIADx6CgFQy8qhd/V8Q
	bZqqFsfkB8Y+4s
X-Received: by 2002:a05:6a00:1821:b0:842:747f:c043 with SMTP id d2e1a72fcca58-84826be1c3fmr5799977b3a.1.1783444557468;
        Tue, 07 Jul 2026 10:15:57 -0700 (PDT)
Received: from mincom1 ([175.235.236.90])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b5e566sm5784602b3a.3.2026.07.07.10.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 10:15:57 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Richard van Schagen <vschagen@icloud.com>,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jihong Min <hurryman2212@gmail.com>
Subject: [PATCH v2 0/5] crypto: eip93: fix request lifetime and completion handling
Date: Wed,  8 Jul 2026 02:15:32 +0900
Message-ID: <20260707171537.467608-1-hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v2 of the EIP-93 fix series:

https://lore.kernel.org/linux-crypto/20260524194528.3666383-1-hurryman2212@gmail.com/

This series keeps the remaining request lifetime and completion handling
fixes from v1. Patch 1/6 from v1 is omitted because an equivalent
devm_request_threaded_irq() failure handling fix is already in this tree as
commit 85a61bf9145d ("crypto: inside-secure/eip93 - Add check for
devm_request_threaded_irq").

The patches collect EIP-93 fixes that had been carried out-of-tree and
rework them for the current driver. The original fixes came from work by
multiple people; the individual commits carry provenance trailers where the
original author, reporter or tester is known.

Tested on a Lumen W1700K2 wireless AP running a Linux 6.18 based OpenWrt
build, after verifying that the resulting driver changes match the
corresponding OpenWrt patch diffs, modulo upstream context differences.

Changes in v2:
- Drop the IRQ request error patch; the equivalent fix is already present.
- Rebase the remaining fixes onto cryptodev-2.6 master at e264401ce477.
- Keep the remaining code changes unchanged from v1.

Jihong Min (5):
  crypto: eip93: guard DMA cleanup on uninitialized mappings
  crypto: eip93: reject HMAC requests before setkey
  crypto: eip93: use request-local SA records for cipher requests
  crypto: eip93: order result descriptor reads after PE_READY
  crypto: eip93: handle request ID exhaustion

 .../crypto/inside-secure/eip93/eip93-aead.c   | 34 +++++---
 .../crypto/inside-secure/eip93/eip93-cipher.c | 34 +++++---
 .../crypto/inside-secure/eip93/eip93-cipher.h |  3 +-
 .../crypto/inside-secure/eip93/eip93-common.c | 65 ++++++++++++---
 .../crypto/inside-secure/eip93/eip93-common.h |  3 +
 .../crypto/inside-secure/eip93/eip93-hash.c   | 79 +++++++++++++------
 .../crypto/inside-secure/eip93/eip93-main.c   | 19 +++--
 .../crypto/inside-secure/eip93/eip93-main.h   |  2 +
 8 files changed, 174 insertions(+), 65 deletions(-)


base-commit: e264401ce4776a288524e5b87593d4d864147115
-- 
2.53.0
