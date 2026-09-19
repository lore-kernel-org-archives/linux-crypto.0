Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB61F2E03EA
	for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 05:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789796980; cv=none; b=kVeBSsRTkWyXyrelrN0rOXpvn7j6FfvWt66FNgNNyXgVl4drr4hRUaA3Fw65gCmqH3+u/0PfHBA9WW3+zvuCQsF7XN8RfVWwKn0VtaLFl51jYgPle3TphbtNKhkmo4uoFI1dC2+sAu5MZroVW6+jt6eEl9RvSIX5xQB5U7O5z34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789796980; c=relaxed/simple;
	bh=5hn+3SJcyVzss4VqEdL8V/gP/CY6+lzWZiktJfntfiQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M7ViRmVjjEvPX9xbnj1aYYUtM20AlcW8K7RBOCa8pqrJ5FISH4DZs/ldgubZjrhXfE8Qsxvb+Dr1RqGbB3plOf0Js1wFvhU9yN5oOl+1h1jVp9l1zvVnBnCxrECPI6VrHJAn0U/ce10CRXQEVRHC8AK9l/RWOejsdUXTvGCnNCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zbksv44P; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zbksv44P"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e79a408deso7971785e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 22:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789796977; x=1790401777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2Wub6FkkohSWYkw99iErrJH/ltfuxLago62PvO/LfjY=;
        b=Zbksv44PWIeHgU2qn7RhuglINHUCmP2LcDzRAJqf6esajMmp5Xhar89UyywNEEvxts
         Cvki4Ii6LpYkGkCeRTnSLsOHrN1GBnftPYwFJAg1Lu63eAjdPgjN051NaVVKMbPyiqY7
         Nqoiyj4E05nMa0DTGDLyt7WHMTK0z4UFmxVzsOhgw3mAkA0bub/pyR41BgJL7OIbNa2h
         tJM7T0dNzl0ytndaOJ+C0lJ7P/HL4vDPnQ1JmXH0Wy/BFU4L5W56KmrlMQ8wZD6GqajB
         v7yXHFffWvZgCyP/QEyDwUQr7ovHs2Hgn4tfsGcFg17jL74EeMOiohsHVTT+xPYCztpq
         QvMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789796977; x=1790401777;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2Wub6FkkohSWYkw99iErrJH/ltfuxLago62PvO/LfjY=;
        b=dBXe/eWWTWlsYjNDFGKtSVOsamD/rB2QZd23cSz5vq5boUrmJHRg6EMPsRgSieiGSv
         al9VQVQVplp9Abpm4Ywyq3FxJrf/DMGfcFceaBzB03yxTkWbU18K1wWVfNhqJ+APntkr
         D6FLFzkdC686yiuaWH4f5NeX1aLf4NoJMsIk0V96p7xl3xfQQSbf6PILTEP/C4sI0V/S
         0XMZVECKehW4iehBMN6OvLhFxe/OCp6RT/UTRnMbjRa+u6EHyePzS2WHqL+aa3PfDILb
         /38WxLKewrctBVuOD3AJXNW/XfnxSaUtgt8OT6hdljovoRMiJIfJHZVXa0Cs9ksBiBJo
         NdhA==
X-Forwarded-Encrypted: i=1; AKwUvByWTq64ud9VCsgsXwjatlp/W4T9+UI4UejgaK7E4l2dzzXQD3cgmTMmIV75ubNlRHfe1FXyU6Rap+g+PzI=@vger.kernel.org
X-Gm-Message-State: AFuF++mNDjjtVadqfBHeHTQ+2kusFRGkQHOO/iSs9Cm/HFweB8t4SZef
	YitJO3opg1AJTS0AOtW0tVgk13OBUtbcUHXan9xEAIlLhDWGD2W7G7Wu
X-Gm-Gg: AYBFou3tVyCD21fa6Nk6Rxs5WNAl+C64D68sLhQLBnB0YCVc16xRkkaywvzsHOz759q
	3IjixojEYDFhMUinhEeh+wX33s7i9+29HdgF2gFVOWd+UECy9uLT+9CCqI/DM3OszHGIoehiG1O
	vm3c+E4UDS/t6g6Qz6vz0dCpSJm30cVV9IDpdjseHzWTeUsxNtcM3Bj2b8qNM5vphJhnHl7uskn
	VgN4w7QD9N3ETjPC8gquNhD1sXZcN7dxYF3sTwUdNp85vStV7KqTezO63DPdc2YuPwuKvq6pu+q
	s0r6WheC+o7ZOYFBdtOo1GTW07jxy5lyrhHVMNgukGR+ae0/Di8Gpe+zqkhKcFH0D9tBElZV+f5
	OSwhdtE/yKxkh+Jq2KDwz0lY8sjluR7jaGhGGVPMnavcywzm1Q05/qZiko5qDU5sFLwk4QYAEhN
	+EMrW+Fh0uu63rYG56OZnVyjIvsDd9+cktV7/LyFGsmt542H+ugWxcQoYSK2fOK8eup8c2TwT/5
	0xBDnX+0NuTrvRnzG/Kqs62b2HuacrGm+IitWURUHCrTY9i/vGsqjCMAFS6x9aI969GrKjBFa3R
	xssjbmFsdAut1jlPkp/sN4nXPBbSqaQAyPU9rrdY7jWWpllmWLEZog0U8OmULCJrDcAo79SO5ep
	n7IbS1F3jr2/ksmg=
X-Received: by 2002:a05:600c:6097:b0:49e:7cd8:b269 with SMTP id 5b1f17b1804b1-49fc57411a5mr63793185e9.21.1789796976836;
        Fri, 18 Sep 2026 22:49:36 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a017-2b01-05fe-203b-7cd2-a640.310.pool.telefonica.de. [2a02:3100:a017:2b01:5fe:203b:7cd2:a640])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcd8bc15esm28001935e9.1.2026.09.18.22.49.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 18 Sep 2026 22:49:36 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>,
	Xin Zeng <xin.zeng@intel.com>,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] crypto: qat - zero the VF migration state buffer on save
Date: Sat, 19 Sep 2026 07:49:34 +0200
Message-Id: <20260919054934.27322-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The QAT VF migration state buffer is allocated with kmalloc(), while
qat_vf_save_state() exposes all state_size bytes to userspace. The state
manager writes only the serialized sections, leaving the unused tail
unchanged. The first save can therefore disclose stale heap contents,
and subsequent saves can disclose data left by an earlier migration.

Zero the whole buffer before writing the setup data. Once the setup data
is present, preserve it and zero the remaining state area before each
state save.

Fixes: f0bbfc391aa7 ("crypto: qat - implement interface for live migration")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Found by review. Compile-tested only; I do not have QAT hardware available.

Changes since RFC:
- Drop the RFC tag and mark the patch ready for application.
- Describe the concrete userspace exposure path and add Cc: stable.
- No code changes.

RFC: https://lore.kernel.org/r/20260817042613.19855-1-kmehltretter@gmail.com/

 drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
index bf2bae78a40d5..d8b961b2f2f7f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
@@ -837,6 +837,9 @@ static int adf_gen4_vfmig_save_state(struct qat_mig_dev *mdev)
 		return ret;
 	}
 
+	memset(mdev->state + mdev->setup_size, 0,
+	       mdev->state_size - mdev->setup_size);
+
 	adf_mstate_mgr_init(vfmig->mstate_mgr, mdev->state + mdev->setup_size,
 			    mdev->state_size - mdev->setup_size);
 	if (!adf_mstate_preamble_add(vfmig->mstate_mgr))
@@ -934,6 +937,8 @@ static int adf_gen4_vfmig_save_setup(struct qat_mig_dev *mdev)
 	if (mdev->setup_size)
 		return 0;
 
+	memset(mdev->state, 0, mdev->state_size);
+
 	adf_mstate_mgr_init(vfmig->mstate_mgr, mdev->state, mdev->state_size);
 	if (!adf_mstate_preamble_add(vfmig->mstate_mgr))
 		return -EINVAL;
-- 
2.53.0
