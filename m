Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E98186A
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 00:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771459802; cv=none; b=nh1LUKnQ0tL3FFVHAqhQker2QRWRxUi+2ZntQaj8Ahdjkc7txuX1QoS6L4R83zvZmwi+YpztwhRknPEuRuhJAZ4G527XtizbEWWAQigRPGQ+CH5ay1O948bJaOVTBosHlowFTB3YSIAvwAvyxKNS7nLU4784irR0Y6mV2ZeHcQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771459802; c=relaxed/simple;
	bh=cZdZSENPJpG5YAs60oaxMQ6FIW5NW5Y1yBMgAgTbyuw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qgVin726TYLmnzHBxDvhBiPZeGKwUwnZFqxA+mbwibgOj6WvEzJYNXLcSz7YPtlbSM2a3Fz+UIeRKPZTTJloK81izxilik4Spw4PaWwTnLAGA7rYYAqv3BTpT7uKCtnkKSTQRyALb8c1hGNnDL+GVg5oO3/YXp+kiaQd2cd28qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sony.com; spf=fail smtp.mailfrom=sony.com; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sony.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=sony.com
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id snD7v00QMKXDJsrc8vg0R0; Thu, 19 Feb 2026 00:09:52 +0000
Received: from host2044.hostmonster.com ([67.20.76.238])
	by cmsmtp with ESMTPS
	id src8v5bp0N3K1src8vefRB; Thu, 19 Feb 2026 00:09:52 +0000
X-Authority-Analysis: v=2.4 cv=UdRRSLSN c=1 sm=1 tr=0 ts=699654d0
 a=O1AQXT3IpLm5MaED65xONQ==:117 a=uc9KWs4yn0V/JYYSH7YHpg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=z6gsHLkEAAAA:8 a=CjxXgO3LAAAA:8
 a=bH78PYQqAAAA:8 a=20KFwNOVAAAA:8 a=MyLyNpf-AAAA:8 a=pq4hVcuv_cZcbSj3KMAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=RVmHIydaz68A:10
 a=TrXR8j8ql9YpJ1_1srv2:22 a=jWrGwe0GocFgitYTcm8D:22 a=iekntanDnrheIxGr1pkv:22
Received: from [66.118.46.62] (port=39388 helo=timdesk..)
	by host2044.hostmonster.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.99.1)
	(envelope-from <tim.bird@sony.com>)
	id 1vsrc4-000000012c4-45Fz;
	Wed, 18 Feb 2026 17:09:49 -0700
From: Tim Bird <tim.bird@sony.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	lukas@wunner.de,
	ignat@cloudflare.com,
	stefanb@linux.ibm.com,
	smueller@chronox.de,
	ajgrothe@yahoo.com,
	salvatore.benedetto@intel.com,
	dhowells@redhat.com
Cc: linux-crypto@vger.kernel.org,
	linux-spdx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tim Bird <tim.bird@sony.com>
Subject: [PATCH] crypto: Add SPDX ids to some files
Date: Wed, 18 Feb 2026 17:09:38 -0700
Message-ID: <20260219000939.276256-1-tim.bird@sony.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host2044.hostmonster.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - sony.com
X-BWhitelist: no
X-Source-IP: 66.118.46.62
X-Source-L: No
X-Exim-ID: 1vsrc4-000000012c4-45Fz
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (timdesk..) [66.118.46.62]:39388
X-Source-Auth: tim@bird.org
X-Email-Count: 4
X-Org: HG=bhshared_hm;ORG=bluehost;
X-Source-Cap: YmlyZG9yZztiaXJkb3JnO2hvc3QyMDQ0Lmhvc3Rtb25zdGVyLmNvbQ==
X-Local-Domain: no
X-CMAE-Envelope: MS4xfB/9STYBELzQu1DTi/Kq3npenylWKYukBQPQpAZi7OMI6vzl6cyP9BFvshmhMfuXDldP4VPHKJAcoiJCXwEeNXubR2RjWrTK4DoxyJLW06v+K6mTOvTZ
 eyb1KMq69Ho90GN/HGdpC3aoqUNLhE6eKSPuYIqbph77FmAVKTJSWdeFHG36Bzb431nspHBAWcq9fgSrcGBUjCzXVVG3NQUwCq4=

Add SDPX-License-Identifier ID lines to assorted C files in the
crypto directory, that are missing them.  Remove licensing text,
except in cases where the text itself says that the notice must
be retained.

Signed-off-by: Tim Bird <tim.bird@sony.com>

---
Note that this does not finish adding SPDX id lines to all the
files, as there are a few special cases with weird license texts.
---
 crypto/algif_rng.c           |  1 +
 crypto/anubis.c              |  7 +------
 crypto/drbg.c                |  1 +
 crypto/ecc.c                 | 22 +---------------------
 crypto/fcrypt.c              | 33 +--------------------------------
 crypto/jitterentropy-kcapi.c |  1 +
 crypto/jitterentropy.c       |  1 +
 crypto/khazad.c              |  7 +------
 crypto/md4.c                 |  7 +------
 crypto/wp512.c               |  7 +------
 10 files changed, 10 insertions(+), 77 deletions(-)

diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index 1a86e40c8372..a9dffe53e85a 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * algif_rng: User-space interface for random number generators
  *
diff --git a/crypto/anubis.c b/crypto/anubis.c
index 4b01b6ec961a..18b359883d99 100644
--- a/crypto/anubis.c
+++ b/crypto/anubis.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Cryptographic API.
  *
@@ -21,12 +22,6 @@
  * have put this under the GNU General Public License.
  *
  * By Aaron Grothe ajgrothe@yahoo.com, October 28, 2004
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <crypto/algapi.h>
diff --git a/crypto/drbg.c b/crypto/drbg.c
index 5e7ed5f5c192..410cecc45ab9 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * DRBG: Deterministic Random Bits Generator
  *       Based on NIST Recommended DRBG from NIST SP800-90A with the following
diff --git a/crypto/ecc.c b/crypto/ecc.c
index 2808b3d5f483..c38e4bc0d613 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1,27 +1,7 @@
+// SPDX-License-Identifier: BSD-2-Clause
 /*
  * Copyright (c) 2013, 2014 Kenneth MacKay. All rights reserved.
  * Copyright (c) 2019 Vitaly Chikunov <vt@altlinux.org>
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions are
- * met:
- *  * Redistributions of source code must retain the above copyright
- *   notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
 #include <crypto/ecc_curve.h>
diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index 80036835cec5..63c542ec5b85 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -1,45 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0-or-later OR BSD-3-Clause
 /* FCrypt encryption algorithm
  *
  * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- *
  * Based on code:
  *
  * Copyright (c) 1995 - 2000 Kungliga Tekniska Högskolan
  * (Royal Institute of Technology, Stockholm, Sweden).
  * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- *
- * 3. Neither the name of the Institute nor the names of its contributors
- *    may be used to endorse or promote products derived from this software
- *    without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE INSTITUTE AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED.  IN NO EVENT SHALL THE INSTITUTE OR CONTRIBUTORS BE LIABLE
- * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
  */
 
 #include <asm/byteorder.h>
diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 7c880cf34c52..ad1d60252a96 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Non-physical true random number generator based on timing jitter --
  * Linux Kernel Crypto API specific code
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 3f93cdc9a7af..1ff0d5800b72 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Non-physical true random number generator based on timing jitter --
  * Jitter RNG standalone code.
diff --git a/crypto/khazad.c b/crypto/khazad.c
index dee54ad5f0e4..0868e0fb6ad9 100644
--- a/crypto/khazad.c
+++ b/crypto/khazad.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Cryptographic API.
  *
@@ -11,12 +12,6 @@
  * have put this under the GNU General Public License.
  *
  * By Aaron Grothe ajgrothe@yahoo.com, August 1, 2004
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <crypto/algapi.h>
diff --git a/crypto/md4.c b/crypto/md4.c
index 55bf47e23c13..3f04b1a2e839 100644
--- a/crypto/md4.c
+++ b/crypto/md4.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /* 
  * Cryptographic API.
  *
@@ -13,12 +14,6 @@
  * Copyright (c) Cryptoapi developers.
  * Copyright (c) 2002 David S. Miller (davem@redhat.com)
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
diff --git a/crypto/wp512.c b/crypto/wp512.c
index 229b189a7988..1c9acdf007f3 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Cryptographic API.
  *
@@ -12,12 +13,6 @@
  * have put this under the GNU General Public License.
  *
  * By Aaron Grothe ajgrothe@yahoo.com, August 23, 2004
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
-- 
2.43.0

