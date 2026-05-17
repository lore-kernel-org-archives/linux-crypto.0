Received: from mail-dy1-f193.google.com (mail-dy1-f193.google.com [74.125.82.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11E73290DC
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 03:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778987691; cv=none; b=QusoEhYVV+Z4DmoueRGFmJVWysfQ50lkTXwdmcFB17qM+ARBQZeNgIwATVLNT58dqM3qwA24YE55AoHmYMNvw8JJs1FCKyvwCsf+CMoYIHQq2s/lQeyXIGywNHOr2AmfRODITAL7jeDIK+yuTUqPHB1ib98mFSpdkD78Q2E+nX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778987691; c=relaxed/simple;
	bh=ri/eJlHC7UN2zyssXhADK+SFuDdKeaElhRa8H7tTz+8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KovDDqkj4GEVfTFI1koLgzzbumY7jLxya7w9z4weUvRc8CaEdd4HgmtQ9sJywQKzwOB8R/D1VlDB+AOjFrLdyxkibmDlsfCuWZKjGzx9po5ONKLT3Ph6i3UGNSELRmIwjsjGkmZzDua7M/JEfPRqTgHg3P+aRVUnBSgZX0Qdszg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jIqT1B0W; arc=none smtp.client-ip=74.125.82.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jIqT1B0W"
Received: by mail-dy1-f193.google.com with SMTP id 5a478bee46e88-2f7020a928eso1519052eec.1
        for <linux-crypto@vger.kernel.org>; Sat, 16 May 2026 20:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778987689; x=1779592489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hfq3wqL8gmrW8nePp5k7jramHiXYMDBLkPO5KDqKpBo=;
        b=jIqT1B0WC6evdq4WRH8/94LfO9WHV4hbBwn2lVblSwnfMZHIo+xncDy5WKSwat7JfR
         +4eM5sfL9NZSUjcNBVkrKDT0aeQ1Vb68+Zi+43ECbivoBOPqNHVnDuzP95SYs8szVQh1
         8tRd9uak99VmHBlr/2MDeHWssZ5laz4gv3oDHykWoJNnEOykv2aikcYj5KSTgpJ8PmR3
         38s7jS2rhCkrJSBm5WOSKJ0wFIQKSfSh3Yk9brk6eGcqGPtmGkzE7U6GayM2fGoBgE7n
         s3OBRhW4Ee75P1UMz4niCvD+cS7NwWOYf9WKiNbBVlVaAfHuE1opB3WZnZi3ylvDydPU
         rGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778987689; x=1779592489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hfq3wqL8gmrW8nePp5k7jramHiXYMDBLkPO5KDqKpBo=;
        b=ImnKx9yVvCnsT9qLpEOJ4Gb7oV7e4KQwVt13aeKrkLgn23HfLQHdZ6KLRKYqZej6kS
         uDA3nSptm8sMln/edjqFxlBENQHQQl1EcamwBb3UtlAnsrIoiHTx+126N8BTgNDUCFe1
         vnbwHgk8K0cEZ88lYV9QQAsL0sYi7+LslnWa1gpXchBNLX3seuHIoLi2K7vQzV2Qch85
         z+NlRefMzSOEhgmfZxGWdZkHsNDywXvyNiG11zYIw8DSStsY5k3yUh2MxYxmyKS/NoFW
         zLFjVnIMQFw5EVR8ipBQIFm8n/FcOU7azozdTzqJvdu+adAjNl/xI3vvdxTN+vce5AJs
         YRBQ==
X-Forwarded-Encrypted: i=1; AFNElJ/MvbHZFJ3lXSOYMSJJzpF3wteIatKne6fvWE5QWkJzcJJjnYkXDV/2iWLHrtMl2ify53BoXj3qUqwEPeE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1gG5WCjhnrZ8Xgsz3YUg3bC+w/3XJsATfPNduZSNOYzLdu6Jo
	1VY3nIJS6uC5oNJxHoAS59J4aixgHbF7u8nWoc8W7DevqfuXT+zq8DYt
X-Gm-Gg: Acq92OHiu+LdlYl1KM4rNa9YPTnQicg3KOPDkBR2CySKRRKiHDBmk8VR3clcYQ/7uYY
	S0Gl32McTQW7L3uxTy97zPhgmhuuIwuLGtfV0sIaBc5pJjXdHEy651XHLrBT9CVzzVTGdFWwUCu
	cG1oIOih2sQrmsf/HPfcZuKKO5TynkFIkcn8tD/ML8CALE786UMRD5nV+HjTFmlUMZtMZ2ktI0m
	7NcPfdZ0mt8s/J5VoSCXIYfkcd+msWzGR/4pdRkRKogSJv/PuYAnYxTEDuRgit+6isWC3sXRno+
	P4aiM6JWPYfBvYQblTWeAycjNRQ5n5pRzqCc4G9L+2BzRjxsncHQezbHbhaqVvygrhxWYMggL7R
	cV77/jEPg5D2WFIP7u4ftXt+UcabJ0EWyoa4/tsHrs7Snt+59R2iZuVXtEOSldMUmHUSomEsps9
	kMswqv7EdscYyNqsqRSBE/EpD5EojuvIpzKK7TYk0U4w4CVIXRwm+0z7akauqSiqe5WuLiGKB9j
	iUo32Hy3R5gsxoF8xjxTWX4qfgqNNW7p7ZajW+FbFs5kobFOWQ/Hnq6djd5/5+faIsy6V+U+lBF
	nlJywOyHcN9HVtW4bw==
X-Received: by 2002:a05:7300:fb83:b0:2de:cc07:e8b with SMTP id 5a478bee46e88-3039818afa7mr4753610eec.1.1778987688926;
        Sat, 16 May 2026 20:14:48 -0700 (PDT)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30293e2ea78sm10868372eec.6.2026.05.16.20.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 20:14:48 -0700 (PDT)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH] LoongArch: Remove unused arch/loongarch/crypto directory
Date: Sat, 16 May 2026 20:14:26 -0700
Message-ID: <20260517031430.102984-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All LoongArch crypto code was moved to arch/loongarch/lib in
commit 72f51a4f4b07 ("loongarch/crc32: expose CRC32 functions through
lib"). However, arch/loongarch/crypto still contains stub Kconfig and
Makefile files. Remove these unnecessary files.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 arch/loongarch/Makefile        | 2 --
 arch/loongarch/crypto/Kconfig  | 5 -----
 arch/loongarch/crypto/Makefile | 4 ----
 crypto/Kconfig                 | 3 ---
 4 files changed, 14 deletions(-)
 delete mode 100644 arch/loongarch/crypto/Kconfig
 delete mode 100644 arch/loongarch/crypto/Makefile

diff --git a/arch/loongarch/Makefile b/arch/loongarch/Makefile
index 54fcfa1eac1f..4b22f95aaafb 100644
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -197,8 +197,6 @@ endif
 libs-y += arch/loongarch/lib/
 libs-$(CONFIG_EFI_STUB) += $(objtree)/drivers/firmware/efi/libstub/lib.a
 
-drivers-y		+= arch/loongarch/crypto/
-
 # suspend and hibernation support
 drivers-$(CONFIG_PM)	+= arch/loongarch/power/
 
diff --git a/arch/loongarch/crypto/Kconfig b/arch/loongarch/crypto/Kconfig
deleted file mode 100644
index a0270b3e5b30..000000000000
--- a/arch/loongarch/crypto/Kconfig
+++ /dev/null
@@ -1,5 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-
-menu "Accelerated Cryptographic Algorithms for CPU (loongarch)"
-
-endmenu
diff --git a/arch/loongarch/crypto/Makefile b/arch/loongarch/crypto/Makefile
deleted file mode 100644
index ba83755dde2b..000000000000
--- a/arch/loongarch/crypto/Makefile
+++ /dev/null
@@ -1,4 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-#
-# Makefile for LoongArch crypto files..
-#
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 103d1f58cb7c..62221507f2b9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1361,9 +1361,6 @@ endif
 if ARM64
 source "arch/arm64/crypto/Kconfig"
 endif
-if LOONGARCH
-source "arch/loongarch/crypto/Kconfig"
-endif
 if MIPS
 source "arch/mips/crypto/Kconfig"
 endif
-- 
2.43.0

