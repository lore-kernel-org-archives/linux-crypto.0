Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793624137;
	b=2i4srvW+vCUo3L4BLaRKk3wtdhLlffqPPKDYonxDbVkAWW1kR4NY7Tu5WfAhwK2Jcrbr
	 NPBD3o1epj98q0t71E5DBhPsWuPSH9zJUQe3Z3jSkZqs25fSV8a686wkNuF55PKYDSZAw
	 GIqtjusIvJEY1r6HWQBvZ34RV/u+MuB3WKjAcjxW9T1iBP+K3wNR95Ic+CTWCCuQ3DwUx
	 10Bd6UrH4WueTbuZ4geO5KESjZ7WFQvc5QhSZ9eVanDaDEt27GTGiJa+NEJUJfM2MmK6Z
	 H9BhZ8zMzEQPcoaAWQDUsqW85jfo/xByeen5uS3vxsow5PvVbGVfguq17aYMGhVbXiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793624137;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=98gkWalObxsRGE9ms/3go8HXEZ8fxnay9RLop7DxfZY=;
	b=MxHoKEvwDBnpmGDRp9fj7lya/6obdmASmcL5L9lC/OUdYf0NO2YdnnZB7DiF5v/XdVpn
	 SxoD+K4VDED/bnMjOTUlX4QAkGiM1RfJC4NsWZR/vCyeuBO7aLgDq1P/VFeRIPGon1ec8
	 NnU7Ex6YhLDSLER/XdRChzaXzRcw8G0fWWmstFLrVCGlvButAU6E5DcqitecmF4p2+ryH
	 FeZanoEvre34FgsJW/P/CqRlGqC+Cly1EBm5guzq6aHHfy1ACysroYgsSBeY3iZBMofI6
	 hrdU/5BYhjHB+W9FIqu3USY3tPE/W/sJPk8YCAW+P5UtDxXlh8CVldFrP1Z5Rw5BGfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gBh6tBT6;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1B0606A327
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 12:55:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE1B0606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gBh6tBT6
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc4dbda1e5dso913562a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 02 Nov 2026 04:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793624136; x=1794228936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=98gkWalObxsRGE9ms/3go8HXEZ8fxnay9RLop7DxfZY=;
        b=gBh6tBT6Pm71M6tBg8kYzmjp+cw7EmUQoLz5DSaZV6D6PBkQ13dCCPDYdGPr9Ps8Jd
         cRD0YsOWiQKZNHWJcWxy2nx5LTqd30k6Pt1+aQpbajhTuL6o0U88P8jFaBMFe1JCBht4
         vAPXo5YqMkTKGoKu35OgCBJLLpDIJQbYoj/hKRwABfoxX2ulsbGCK1L5pQZRuiQpbpk2
         My5YhMbXtytivbplhvlwM62PbS3v45k9D4sUEQCTJCK+E+fUWYKDutbibMmTPmp7OZk/
         tchROAkbf2xTZXP2MXWwnaRZaKecpq1raIAkV/1Wm0jecMmppdxMnnYwVKN+ETZLeUp5
         lxzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793624136; x=1794228936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=98gkWalObxsRGE9ms/3go8HXEZ8fxnay9RLop7DxfZY=;
        b=vHIs2lpuisWwYZegjGF3fm9nk7qIKyNmSTEJkBkXars8J1aIB7z5iqlePiRHwlNEIL
         tDArlVGopvuPU+Qta4MpY06nm0xlE0KV2plDrPk/9K8miRY47EMwpUktn3ohhbrgFWri
         sDNermz6Q5d2HqPXQweEQHnCEOxgDeViORBoEHYX0Eos54a9MYX5BppsXJ5voWUdr9Zo
         7+bAQj1k5UbQsXwj4it4EKk6LBTwnFhaXF8icKDWMHbFwo+NoP8skGOr89KUEYEkVTkN
         SGHQYKbnJxS0ZWWkzUrAkmvHf10rKywZeL0F9rOcLur+ACtXOHuyxe+5ZL2IbtlCS7b7
         9Qkg==
X-Gm-Message-State: AFq9FYKitmfxUEDIhy63EJNEnZVucvEyLR7HaZE2kbsIdpP5+ouZtf/5
	/gON2c6J30S/T/utQKIiqGhzIVjegvooU99gh/i7HRIkUJFud0zf43nt/qYd2A==
X-Gm-Gg: AYBFou1INYZO0pfqsIS5TW+bF7CxSZhJAgg5fjte9kcHRnY3TIdn9O+9Ey6GQNJMF/b
	oaQWSHAkfbrRgevo5Vg9WEx5aMa0RXVCI7aE+jmVJyyRdpB95yGgw4lKd0VoIM0pOiSDLoWBJJJ
	Ykv9rXK+wg5MugO1zREM4dqukGvF8TTy3rNNFEqwfbLY8Y6IKRU+6pw9S8MkTX/ubNfiXLCFLr8
	hl38ZEGjDIBG93ZBrnYSErb8RqlB29rRXf3zz5EPK4rRt2oAatuJgMMkv2dWQ5bhyrKenBhq/Kv
	VEYJYeiWPv/9CdHpfELHSZ/O7qz103XahUCHou4Vii9gYoCYRMxk1enYDWz6fcSKxUfLXzZ1C8J
	ThwELiCUd/yRF0SmXMlAzleQq32wwnfRYuA7563a5SvaS8mtlA2DuSmie0Sk80i0SwlGiWb9QsC
	wRgfeLJRnISJ6Ym0kMwPfLuT4fiI4+XunimpNRlnRCUEuDv3uzTlFVSMJ7/VkbQMqg0ZabWi0UA
	tL1gId30UdEQFKNQP2B6wPbHFUvTAL3Qhd6srfm1QubkaBSpWdvBhWDC+FkzmdNO09X0H3dzQzF
	f4jYlcbcZQ1tfCNjf9M6dUVvzA0dv3+as93FB31G+EuljB6mXQ==
X-Received: by 2002:a05:6a21:8808:b0:3e0:de4c:71ef with SMTP id adf61e73a8af0-3e928e01f46mr6895080637.58.1793624135935;
        Mon, 02 Nov 2026 04:55:35 -0800 (PST)
Received: from ubuntuser.. ([103.156.164.98])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb097093desm3078544a12.21.2026.11.02.04.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:55:35 -0800 (PST)
From: Maholi Tumanggor <maholitumanggor@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	Maholi Tumanggor <maholitumanggor@gmail.com>
Subject: [PATCH v2] lib/crypto/mpi: Fix heap OOB write in mpi_powm() when res aliases input
Date: Mon,  2 Nov 2026 09:25:50 +0000
Message-ID: <20261102092550.2633-1-maholitumanggor@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102064225.2271-1-maholitumanggor@gmail.com>
References: <20261102064225.2271-1-maholitumanggor@gmail.com>
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

The previous fix (v1) introduced a new issue: inside the exponentiation
loop rp and xp are swapped after each squaring/multiplication step, so
after the loop rp may point to xp_marker instead of the originally
allocated buffer. Fix by saving the allocation pointer in rp_alloc at
the time of allocation, then using rp_alloc as the write-back destination
so mpi_assign_limb_space() always receives the correct buffer regardless
of how many swaps occurred in the loop.

Confirmed via SLUB debug (slub_debug=FZPU) on kernel 6.8.0-147-generic
(Ubuntu 24.04): two BUG reports (Right Redzone overwritten and Freepointer
corrupt) are triggered by mpi_powm(base, base, exp, mod) with base->alloced
smaller than required, and are absent after this fix.

Signed-off-by: Maholi Tumanggor <maholitumanggor@gmail.com>
---
 lib/crypto/mpi/mpi-pow.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/lib/crypto/mpi/mpi-pow.c b/lib/crypto/mpi/mpi-pow.c
index 9e695a3bd..f4df9fbcb 100644
--- a/lib/crypto/mpi/mpi-pow.c
+++ b/lib/crypto/mpi/mpi-pow.c
@@ -28,6 +28,7 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 	mpi_ptr_t mp_marker = NULL, bp_marker = NULL, ep_marker = NULL;
 	struct karatsuba_ctx karactx = {};
 	mpi_ptr_t xp_marker = NULL;
+	mpi_ptr_t rp_alloc = NULL;
 	mpi_ptr_t tspace = NULL;
 	mpi_ptr_t rp, ep, mp, bp;
 	mpi_size_t esize, msize, bsize, rsize;
@@ -256,16 +257,23 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 		 * might be, see above).
 		 */
 		if (mod_shift_cnt) {
-			carry_limb =
-			    mpihelp_lshift(res->d, rp, rsize, mod_shift_cnt);
-			rp = res->d;
+			mpi_ptr_t dst = assign_rp ? rp_alloc : res->d;
+
+			carry_limb = mpihelp_lshift(dst, rp, rsize, mod_shift_cnt);
+			rp = dst;
 			if (carry_limb) {
 				rp[rsize] = carry_limb;
 				rsize++;
 			}
 		} else {
-			MPN_COPY(res->d, rp, rsize);
-			rp = res->d;
+			if (assign_rp) {
+				if (rp != rp_alloc)
+					MPN_COPY(rp_alloc, rp, rsize);
+				rp = rp_alloc;
+			} else {
+				MPN_COPY(res->d, rp, rsize);
+				rp = res->d;
+			}
 		}
 
 		if (rsize >= msize) {
-- 
2.43.0

