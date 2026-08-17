Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9060313E21
	for <linux-crypto@vger.kernel.org>; Mon, 17 Aug 2026 04:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786940859; cv=none; b=WGGG4DGfQfGB7+yT25bOf7FF60/43OwRwjmt+1hJnyE7FXWnQV2iDb/Y35uRhAgCWBfQfcwvsAWlvwuPPZnYwhoxfsrjor8ipzIDv0M8lNxYHTCjSywmbAHXyLQJKD7q1xRbQ1MaqnpOIMPjvPtx5R1W3Yk+DhQpCwAIwfEsRA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786940859; c=relaxed/simple;
	bh=T5FP46jyxplehsCLTTV6ihDa25uz89wkt3oqqLQtX1o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZLpR8mEgo0rTPtXWFlWtNuTCCkvx13D0lsrlLoCCBKm+I8TAhdZWZGi5JVJWAOWdpxrmdFZ6txhjAcgWaIBWP0sQPRAM5Nx3z818f9xWbqMkrUUmzWK9aiH54CoG0z2aK6yhrTlbVw84yfDJLHB/bRO6N/QskWNayCP3J2ecg9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dnQAUguV; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dnQAUguV"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47db714766aso2299565f8f.0
        for <linux-crypto@vger.kernel.org>; Sun, 16 Aug 2026 21:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786940856; x=1787545656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wZ1x1M8Ws3tbIzXAIDE+DSbo/H7/Nn1lzkQP6Ct23jc=;
        b=dnQAUguVwamHM505+wRbU+AnlNM66pbvPhK8gm/RQ4fa5AqGQdVA7htpTWWQGeolLW
         Dd+CfhSvPvLG7T+H+6pkmgfvZ/xaXvQrCo4w+0mAqtD0Qx5bPeAqk5Z95hdLKPy6NtfO
         uTen5bbjO6vioQ0Qpr0TIwzVUDmwCW8WFEOGlQxx6Y+K/LaGxtwFwruyyFa/lZYRT5wg
         qjBXHxbI9oVPSt3o6TqCqbDdZhE3VNYOfxewrkL0oBT2bH1cmma7wizBm0jwpxoWjZkL
         zFey5EF36s/iflI8iiy97TNtbm+b6S7pTmnVkF+NfLonp5ZPYsM925m0PrSlRYcLA3ua
         v3CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786940856; x=1787545656;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wZ1x1M8Ws3tbIzXAIDE+DSbo/H7/Nn1lzkQP6Ct23jc=;
        b=MA+4v5JBIVFHve/MrEpSbiL/Xr9piFf/lPvlp3SjIAibPuyLKSRHF7OYVTz845c1T+
         MkhhmXCjKqKzBOoRYA5yi4K3nMmMljG64P/cSKMZm5vrY51BwSfXWJKhdMA6830cTPu+
         +5KlAMwwXCH1uq3+DlWemQg2OyiL2jF+PvgJs5kr0lKk3omUZg4uR/v+RboCMnpOcZ+z
         V3IkuCh/w3E0kVJgdBOm4Dk0SWlLTUgFzIAUK6hAfT/SPMmY+6z3qWnWieNcCVSmi+xy
         hGygHb9Z1JoI+uITAvT9/RrTi93gKs03mF9B/4eWhFCMovnTC6aBmJ1JwxnpCX7hEf3j
         NAsg==
X-Forwarded-Encrypted: i=1; AHgh+RrO+bv8aNXqJ/slnn5ZiFF2nX6mnD3j0KIH3htgXUTZKcsxr3wUzQ1DUe8P7xAojck1rJycaFL6nteo9Mc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBnz2wE3S+SB8VryJJaj5nisLVn4Ub39TTcuTjVqPNAh2z8aNo
	J1k1r3EI9UDc5hIClW+9U6uNT/F2xT1dfKzBPrMvvmHi+dd6sXjiaHn1
X-Gm-Gg: AR+sD12/0du8b8yyqQH6KalRZMjIsO7b4nWQyj8Abptz/xhEGueGPeVj50bl6br358W
	Q7GFZU6uLaij8+w1WIg9v9GIBK75b7J1Pw1uzVFTNIyVYT4dtNa12kXrFCd98TjHZymRrJtiziH
	LRQiHQXfmSBM8svRSvwZuU2O7fg5cFA9JaYoUxSh4tQFv5ya7ymNv9kBQrmKoRIbftFkfUXRHO2
	I8wScTOnAknVOIHmKL16BNRQVxieXJYUpOl8AjvNbYbQ6UHpnEq9o0IYrhnjNGmKPxlqRKt8NPo
	KqcR7X6N9PexmK6GdhuEsi8yXLKbgBfy9PjK18/KxZrNSKUtTCygZaRek2FliourpxIkB1V3+zh
	YWiDNfLU19B/lj/BUr66XEsmeNa3SlC16alm8LVSuuF7oUnGkk8eyFhn2SgXPoXL0ATZXbA6CYw
	dIR0xI8/ml+Dok2BsJxOIoWCsVpcFiIVo5a1M2VTEQGH10QJbWPtF7cwo1ECYrudsKRnucDYMmk
	cw0exl3bSz+XKOmODjbPH6FstBikzBLhk/X4TYoXYg6R5S7aON+wWNSUglKEQSaX3/tr2tPW68u
	RQ7DQNPurrMwtzra9t8zkylXoYdjmDsngPMPooI=
X-Received: by 2002:a05:6000:4108:b0:47f:8b0f:7172 with SMTP id ffacd0b85a97d-4815a4f9996mr39625297f8f.6.1786940855866;
        Sun, 16 Aug 2026 21:27:35 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-114-219-094.95.114.pool.telefonica.de. [95.114.219.94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5b783d1sm584685f8f.25.2026.08.16.21.27.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 16 Aug 2026 21:27:35 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>,
	Xin Zeng <xin.zeng@intel.com>,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] crypto: qat - zero the VF migration state buffer on save
Date: Mon, 17 Aug 2026 06:26:13 +0200
Message-Id: <20260817042613.19855-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The migration buffer is only partially written but exposed at its full
size. Unwritten bytes may contain stale heap contents or data from an
earlier migration.

Zero the buffer before saving setup and zero only the area after
setup_size before saving state.

Fixes: f0bbfc391aa7 ("crypto: qat - implement interface for live migration")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Found by review. Compile-tested only, I have no QAT hardware available.

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
