Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52EF2D7DC8
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 17:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777570665; cv=none; b=HoVZ7N2kK0aPP1wuGAvAiw3ZMmiIQ35zgpu1BljBmvIpXfxzT9hXLGNkuIbIeguX21DjKc5UIG/iRMrHxs4ULx1UUhSzsFXH8aA23PwiD3tETjQOXN3EWVEJlFlGeczgAZx7s7EiJFr6VThfTG35dyd6DR5P/tM4OirCKCVsncM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777570665; c=relaxed/simple;
	bh=g+RA+/B9ogh5Lr5VFnWAfVAqAy9aljo+8QIRWQwcF9c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WrfhzL3MBhT9STNyLa+FiZMDnljfPYOtUN4chKSIut3QejyFefjhsuXDhwEzshDUbG0KMrTKrjdpv9JgNW+jSR3nickOtRtEuyEjYKTgmoz61lrv8/fr9AqHUrDR00q0vJ+kZKcwxmxneAB7KoJhLIuEbKJoTNqpLTmd/aMyIGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aaPCe/gM; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aaPCe/gM"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-12ddbe104ccso1303471c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 10:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777570663; x=1778175463; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qWw6wa3QL95dIfuoX0OrurEDxczvWFjJooGa8i+ckkQ=;
        b=aaPCe/gMAyeM2vWCwWN4RPacWpHlSwl9FCJMFRNMLx8u6VRnLPBjIkmdsIONHDdz3Z
         cQLC3Z2mcsb/0sYA6Ao5SaMIpP533PHBF43uO/d7xZjeGMKk7DbGxufv6sQgDS5+KfpI
         2zzyz4709e4NBJxJocBFaF2pvy4dIRce1TpT5VpQg3cy6lyhO+ZdPPnglflKxHfY+WM1
         H1W0d7/xp66QUg9nBrsAdwg9FXOg84cjh7Ryw4L/3dhrUBR0ffTpaATFoPWD/clzQZHV
         yFaH2cKOHnfpNzdWXOzjBin73ZiqWklnSpsJXTPkzIIGtzxjZtcWcDdsf8c0pYzW5r+7
         cOkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777570663; x=1778175463;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qWw6wa3QL95dIfuoX0OrurEDxczvWFjJooGa8i+ckkQ=;
        b=V5VgfkSXyWrHilZjHXO1ljl256FP+s6XyzBEz/2ofyZbtUrGFy4qWBrf2JIIgbTdNq
         BoRiH0KdkbBdfeizeWh1PPAjTT8/8AphcYXEPtvAYjgHQJn5zeLMUCkiQT35/Mnfu8a+
         7SpUyjR/UMTFh0tFz7eGv7Ut4H+gdi9LbiPvDwubHn1JXtuBT8i8qZMfaMrlOEs/gon6
         C4OhDVA0RDRl3qT5Q5qc4u/yL7Bwu0CDU1gq5+RkXvbq4WINFepIy+K0iAU4VjdcehqH
         sdrSMnSbkhbEaiMW4ySLrXUDWgqxuzjQ0lMLTEOcNLdThB3n/Hj5dUR9+K6vt7B6sEVK
         LUVA==
X-Forwarded-Encrypted: i=1; AFNElJ+Jjd6vfXFBgS1Nk3MQS6w02ZxsRoGH6WsdvmPTCa1WASKA8IXcLZY5c3j8Wwb9mIG0t5m+YMD9CM2IeQs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw55lsmbmLcBS5YCrT3IY5lnNbP8gb+1+u/fYhnpEKDl6Pkv7SR
	+AnxygheUMselhHI32gevSuRrtZ4Cw1gDNWDlSGzqQRh4954/f3o3sIg
X-Gm-Gg: AeBDiets2YZnpkyCX22iGCBjBRoaMmbl0r/w8EkI9H8nh2kM8SxM2SeMk48dpLE0I3m
	fZ+wGIaFaGZpd3d7Q2S208zTDjQZna41nDe33oyV7udw6xXewdrU0I0QJutAjYtkH0MABKcBgbS
	fd1h6s3XcFUizMzZ9Neo04r9IC7XhTqROvrdH22/+H1e6H/0uSdeoqPmPJ3rcJa59F8r694yZCc
	N42BDsujVoDuStvsFeV6krH666s/08fXhoXHOJVc/C7xIacqgSzV/LGs2uVorM+rG2eo6SRYfac
	51uvEGGpsIImDEcDp6rRPJQZEqrY/CLgo2KiozxVw3wrjEFrd6L//H+U0OH/ZhVxifzf5No9jWJ
	n6Trr/8ndPjsdVHg8FI6qHFPYeAkzg9GJe16+NmQIZjcmzC8YQzX3QOR9FtUGdkidiI1k9fe88q
	TuHnsPgjo6XwJ8DtCbOxAu+wU5M5VJKozm/4qopU1ij1lW1gl08t9Zeixz66N7CC38Tqw6ilXhE
	IMcIvqHBZHWdX2VNoel
X-Received: by 2002:a05:7022:43:b0:12d:de3f:d853 with SMTP id a92af1059eb24-12dead675c2mr1724005c88.44.1777570662331;
        Thu, 30 Apr 2026 10:37:42 -0700 (PDT)
Received: from efaec68ba852.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ee38e71ccesm1044942eec.10.2026.04.30.10.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 10:37:41 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: Vivek Goyal <vgoyal@redhat.com>,
	Kees Cook <kees@kernel.org>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH] crypto: fix OOB read in pefile_digest_pe_contents
Date: Thu, 30 Apr 2026 10:36:34 -0700
Message-ID: <20260430173632.277436-3-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pefile_digest_pe_contents() computes the trailing-data hash length as
pelen - (hashed_bytes + certs_size). A crafted PE can make the addition
exceed pelen, causing the unsigned subtraction to underflow to ~4 GiB.
This is passed to crypto_shash_update() which reads out of bounds and
panics on unmapped vmalloc guard pages.

 BUG: unable to handle page fault for address: ffffc900038d8000
 Oops: Oops: 0000 [#1] SMP KASAN NOPTI
 RIP: 0010:sha256_blocks_generic (lib/crypto/sha256.c:152)
 Call Trace:
  <TASK>
  __sha256_update (lib/crypto/sha256.c:208)
  crypto_sha256_update (crypto/sha256.c:142)
  verify_pefile_signature (crypto/asymmetric_keys/verify_pefile.c:436)
  kexec_kernel_verify_pe_sig (kernel/kexec_file.c:151)
  __do_sys_kexec_file_load (kernel/kexec_file.c:406)
  do_syscall_64 (arch/x86/entry/syscall_64.c:94)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  </TASK>
 Kernel panic - not syncing: Fatal exception

Validate that the addition does not overflow and the result does not
exceed pelen before the subtraction. Return -ELIBBAD on failure.

Fixes: af316fc442ef ("pefile: Digest the PE binary and compare to the PKCS#7 data")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 crypto/asymmetric_keys/verify_pefile.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 1f3b227ba7f2..cec99db14129 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -305,6 +305,8 @@ static int pefile_digest_pe_contents(const void *pebuf, unsigned int pelen,
 
 	if (pelen > hashed_bytes) {
 		tmp = hashed_bytes + ctx->certs_size;
+		if (tmp <= hashed_bytes || pelen < tmp)
+			return -ELIBBAD;
 		ret = crypto_shash_update(desc,
 					  pebuf + hashed_bytes,
 					  pelen - tmp);
-- 
2.43.0

