Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601805;
	b=ZTIKQpuhgHyBp1TcSiTuvcZXJvibFp2uaPyen75S1dSpxsyCsyzIZfv8ATaaHYFyfBmE
	 3AD+y6f9fkiwcrbO8gA7wxpbBuLFXXaCVz26/Pf/04WBlKQun8JSh+nDXlQhXfnn0nS4b
	 UvCU09O1lsYUwQeapq0V+neWYUTnEEtMlfD6XolKjsFB2K4m2FPEVcMvEs2pxSuyyWs/2
	 b+WqDL4Rbq1ZwV3O0Y/QZX8DzMxloZArbibAfLogunChBGRJScMTbjPagJ8dVtCjl6ezG
	 ugK1YxEE01UjBc6AEzHGxnvpfvysA7iONPxWIP79NQSL0hLWQC2usUOOyX51yyuWvkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601805;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=vvQTQT421oGMR9S2R/6ssfdymmyN12jYG8rvnvYMyBA=;
	b=0QDnk49n/8P/KbFW1vbTjO2pKzinP79itpBlTV9cTq/Yp82xDNiOvh3cdITtgDSfQubv
	 cTaMQrG4y+KB4ALvTQbw9eodUAxZgaKCravIYZ+H2et+6f7IlVbS6E36o+kmAj/EEnH/Z
	 9Rv+6iv7nZDDIbqL3Y8y06sncajrZROVmpZD3Sxa7fnONuzqH5fRMcjaGaZJw+CUCjDh8
	 m8iYv27juwfcLpu/zdeRtHG7RxiNTFEjdam4zMSaMeAABZgYQNF6Jmz7/hCyuEz6VvQME
	 S4e2ZgiZF50d1gWaqVkhhgA26hzRJZUsOOMUWv+2SjoeW+kSUrIG6iLou7NDYJ8aZ+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IUZ9n7wQ;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F8A606A324
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 06:43:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93F8A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IUZ9n7wQ
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e96502e447so24246315ad.1
        for <linux-crypto@vger.kernel.org>; Sun, 01 Nov 2026 22:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793601804; x=1794206604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vvQTQT421oGMR9S2R/6ssfdymmyN12jYG8rvnvYMyBA=;
        b=IUZ9n7wQEl8AXwELLLfZnWhB3QydccSwYAQEFRsj7j/TXQxXtvZm3aGe6hkSN9pVCK
         hp2clyjMWbcRhHvPA3YhJ6yX090Rw2m+TxcJfUEEcBU0saT+JkYjqmAaljD0Ui+5Mohe
         oPw46ORVsjgMfwwTPgzmTIDHGjByd6xAbAsQVWvPFdD4nNR8GTZ3RrNe4cCsBFByYoiY
         22ktgBQLzAM8ZqC0hYimhwGIdrjo2U0tZxDiqSxuga7PFaHHGX6SA8G5r3cLoc78vdE0
         n3JKOZLXdJ6M4SHamnPWg6RLF+i3hk3tELPIFfFaOYMwO0oyS7Ef37p/8pUcEEb8WhFy
         utgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793601804; x=1794206604;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vvQTQT421oGMR9S2R/6ssfdymmyN12jYG8rvnvYMyBA=;
        b=v7Oz3otq+cIuJo2VHFM1EiPzJV9YH86AAvkFzZ258KszEK3aXLDcW9UFi/vRZuUKl8
         ZvjmRqzOQct90Ez18q9VYLic/Ql8P8vda+RagsmAosZQYDq47w7PKEobagZ/q+cltIcT
         x4Y7PPOk23agryCj1HWVPVRX4iRgESoHdcHo9R30Iz7EY/PVIDP7xSYC1OF17n9GSGi8
         d82bTqgvZX0sHWbfdz0WM9GqBQpx3FLiOlPuFP0pugjtw321LJmcwShI9y1fIbjNo7pN
         VUqzrhUTK3SE8fphlRBbnfY2o9apfoq18W+tmik2ZQCFGZ+6piinCyFTInVyM/X+sbZ9
         cvsA==
X-Gm-Message-State: AFq9FYKaQn0MonoZ8Vmih9wuNWQCC5I0sbmnXvuISvxyi2OjQwHvxCd/
	nELn/10IWkNaq0rIFKqEmhdlikWucFV3mGreCWOyVtyKyqeY2KN4PMthdg2UJg==
X-Gm-Gg: AYBFou3NkzEjrOJTSFTYwtyr/owRDY1iNjIRC5ALserF1jFJae3Yh6B4coPkqQSS/JS
	o58ESN68ctIGZ5Kr2eZkBlQs8wTfw7UiWxrwV9z3sxhMCZuFi/+vlQCpLPYHuDidlKtDqprlmmi
	vJkjQzU3g/BDdTI8kv5kkFgVJe0Zs7vGxikzjvSX8GN421aQUY6jCK9mmOvvgaIkU41q7CRlhLP
	lulk9Ach9+Br565rOfE2B74wXEf9kU+BWpHty8+jEf3CEyLBMKkwuR/62wSW3kkjE33+KtpXlRN
	zj+7oWdR0FXMdGQZsucSmwR5s53kb1x8cJsRs7WDn5y5mRtECNyoXDez2F8gpr0DHWx51qM4XtF
	CPvNF41GN4ltgLl5Oy0tQhStvuNr/6vfj/oXYDYkFn7/lS1FLKwQrtg9nT7cjs1w2xZfrp+HHJJ
	fhS4Bj3chKUKUVFpITVjaOu6rGXUFP/ypaAfXAi11vYYnOteS+bIdWkf6OhjOIN3jb+Ukz1uHNo
	15G8Oy8y7jNTc59WYsIcorg4kuAHH0/zff2c5Vj2GC2kxq+nVUWRTACaDBFnvwmgPuCdDBbyxvc
	tpge2rv4i8Hpu1DCkTM0ik4ITpzi9A9pjdUFJJFBoJ2EQUQlWg==
X-Received: by 2002:a17:903:2b0e:b0:2e8:1f8a:9113 with SMTP id d9443c01a7336-2eb364eabafmr90169955ad.40.1793601803744;
        Sun, 01 Nov 2026 22:43:23 -0800 (PST)
Received: from ubuntuser.. ([103.156.164.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb392aa7bcsm23413125ad.67.2026.11.01.22.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:43:23 -0800 (PST)
From: Maholi Tumanggor <maholitumanggor@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	Maholi Tumanggor <maholitumanggor@gmail.com>
Subject: [PATCH] lib/crypto/mpi: Fix heap OOB write in mpi_powm() when res aliases input
Date: Mon,  2 Nov 2026 06:42:25 +0000
Message-ID: <20261102064225.2271-1-maholitumanggor@gmail.com>
X-Mailer: git-send-email 2.43.0
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

When mpi_powm() is called with res->alloced < size and res->d aliases
base->d or exp->d, assign_rp is set to 1 and a new buffer is allocated
for rp. However the final write-back block unconditionally writes the
result into res->d (the original undersized buffer) instead of rp,
causing a heap out-of-bounds write and a subsequent use-after-free when
mpi_assign_limb_space() frees and re-assigns the corrupted buffer.

Fix by skipping the copy into res->d when assign_rp is set, keeping
the result in rp so that mpi_assign_limb_space() can correctly transfer
ownership.

Signed-off-by: Maholi Tumanggor <maholitumanggor@gmail.com>
---
 lib/crypto/mpi/mpi-pow.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/lib/crypto/mpi/mpi-pow.c b/lib/crypto/mpi/mpi-pow.c
index 9e695a3bd..06038ac8f 100644
--- a/lib/crypto/mpi/mpi-pow.c
+++ b/lib/crypto/mpi/mpi-pow.c
@@ -187,14 +187,14 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 					if (!tspace) {
 						tsize = 2 * rsize;
 						tspace =
-						    mpi_alloc_limb_space(tsize);
+							mpi_alloc_limb_space(tsize);
 						if (!tspace)
 							goto enomem;
 					} else if (tsize < (2 * rsize)) {
 						mpi_free_limb_space(tspace);
 						tsize = 2 * rsize;
 						tspace =
-						    mpi_alloc_limb_space(tsize);
+							mpi_alloc_limb_space(tsize);
 						if (!tspace)
 							goto enomem;
 					}
@@ -204,7 +204,7 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 				xsize = 2 * rsize;
 				if (xsize > msize) {
 					mpihelp_divrem(xp + msize, 0, xp, xsize,
-						       mp, msize);
+							   mp, msize);
 					xsize = msize;
 				}
 
@@ -216,21 +216,21 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 					if (bsize < KARATSUBA_THRESHOLD) {
 						mpi_limb_t tmp;
 						if (mpihelp_mul
-						    (xp, rp, rsize, bp, bsize,
-						     &tmp) < 0)
+							(xp, rp, rsize, bp, bsize,
+							 &tmp) < 0)
 							goto enomem;
 					} else {
 						if (mpihelp_mul_karatsuba_case
-						    (xp, rp, rsize, bp, bsize,
-						     &karactx) < 0)
+							(xp, rp, rsize, bp, bsize,
+							 &karactx) < 0)
 							goto enomem;
 					}
 
 					xsize = rsize + bsize;
 					if (xsize > msize) {
 						mpihelp_divrem(xp + msize, 0,
-							       xp, xsize, mp,
-							       msize);
+								   xp, xsize, mp,
+								   msize);
 						xsize = msize;
 					}
 
@@ -256,14 +256,16 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 		 * might be, see above).
 		 */
 		if (mod_shift_cnt) {
-			carry_limb =
-			    mpihelp_lshift(res->d, rp, rsize, mod_shift_cnt);
+			mpi_ptr_t dst = assign_rp ? rp : res->d;
+
+			carry_limb = mpihelp_lshift(dst, rp, rsize, mod_shift_cnt);
+			if (!assign_rp)
 			rp = res->d;
 			if (carry_limb) {
-				rp[rsize] = carry_limb;
-				rsize++;
+			rp[rsize] = carry_limb;
+			rsize++;
 			}
-		} else {
+		} else if (!assign_rp) {
 			MPN_COPY(res->d, rp, rsize);
 			rp = res->d;
 		}
-- 
2.43.0

