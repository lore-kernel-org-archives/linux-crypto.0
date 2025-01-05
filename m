Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6BD154BFC;
	Sun,  5 Jan 2025 14:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736087553; cv=none; b=XJ3jN83CDyI9CTMQK9akWscq8pn310LCrsLHH8R40wWxCTyavyZ65pfkwEDuP8YMAaS+4kc1POQYBn4dukR1wmHW2vpkoAxx+XjyRDQTgnVUMWJvugOHkg+PjSjKSSJPwJYlliOcy28IOIEJ/tpjx/NQrmDxBb+8hWBdPMPaR58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736087553; c=relaxed/simple;
	bh=etUkdgGOAeKQsofCjyp34uBeNTm3qccykJ4LE5ZFruA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twXu6nsugijnOauKrUs13TfZIFo/YvZvWTHIi6zIEmgnV6dz2x99x5nJFsY3FRkmPaDPKfqfZfBpXnizhnyks8vEx3fvbDfkSZ3SR7VlKobgmtgXMhoF2k3qrBfkmEnCiHBMZbf3Ye1C7vMjMW2TXBj3BW3xpkSihM2t7ehdELw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=djc1nawk; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="djc1nawk"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-385e3621518so6345831f8f.1;
        Sun, 05 Jan 2025 06:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736087550; x=1736692350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ukl42wl26ysASwjUxfV5ZoP20+T/0IwuT5xUtOVMrvc=;
        b=djc1nawkO7E9FlQwV4HEqK/WskDXkVIsHMvQ6sQ62swltM250SjnGPDDqc7SeiKq2l
         2+2Gx3ugLjhqAtvKQVbcu0/RV3QRTNFowGk6HK6sDD+Z1yMPIS++ETwiMPFy00cravQw
         /t93dmoSF//6J5fcKcqFYL/gWcruf89zTxVekr/5C1SUhLtGPEmsNdV1h3SN577KTPLQ
         KVX1ksCiupJuw+kyuJRDCRt0nZXdrgpGfLrvr9g09xZ0L581erYBAhPs7YM3Efwq7EbF
         UmiWWjH2EwiiakSDLJRY5vatN7WqAiqytmlL+ZCd4tV9tV8P0YU0pEK4BxV6Rshi3mly
         Ad5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736087550; x=1736692350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ukl42wl26ysASwjUxfV5ZoP20+T/0IwuT5xUtOVMrvc=;
        b=OiNrzqPYmBOhMNSoIGA+S7fSlaULdTxYvVu7dobc4sKFeOkr6V4nXN+bTBs+JgQhpu
         GKvXeAKXLFrlXqK1hdTx02+57ROaoYfhTadv+xLmjWDaFP6Na7EGj2LV/DBOsp6M/KLM
         ZFGPwdj1helTcbHYvJe6upL0zIjO95fMAGBSvQOlsyHl/hRaghl8PyMjNM1J3H05Qcaq
         WuG1+bds1mI05ZmFuwzzI+33MWTRG5YI3mDDlSFntZzn+ZFudcmNWgGrpojCPGNBAZDD
         znNRoeYAaBUx61izCq4uN6ubBjQqRZM6Pnh5B/mhim8jSLYVYWIi2LVGgRDTBxBC3k+h
         xZ2g==
X-Forwarded-Encrypted: i=1; AJvYcCUelDqev46pq8ML2id0R6DfoQc3FS84etQavhJ38hGlliBywLoCYDDhhUJmOIyleDf7tVk2DKkidM3hthhe@vger.kernel.org, AJvYcCWjC+P2zfT/zU7R1vLFsGN6WDX2aNRDwwfutG7KGOxu70yTJ/HtpBhpaVjJij6Q1FCDF0HomCO0vRRQ@vger.kernel.org, AJvYcCX2R3fu8mqAOVnVr+3BpmyKXwfPyDwBRshj9ksrUxGSxwpiu5P94ysSANJzRTgnnbWdYlBUoEobZnCbXPPm@vger.kernel.org
X-Gm-Message-State: AOJu0YzXVPx+11hgsj1774iv1fFoHojjg57HVUPTqDdUiFvGDHlYP40U
	g5rizwOHhc8jfGEbrA5BHUYVabScJJpZ63VT4bfORX3aXRlQyrE5
X-Gm-Gg: ASbGncs3zkCEi77d2qP20xC3g4SrG5jAGgAYcssRlobwPHkfEtBs1D48SeaIfGS/HKN
	U5oqnesc85WkFNmjBWBtgytytM1Sw69cnI3EW3A2kFBLfkHK9NbjHnVvgUt4rkYP4Jcg+paDGTK
	2Lygilw4cyH8sptqHzUSyCEFh8AEiXt9eXWVHhek1E9fATxV+8vlHKKBp05xSfu3HjgSsOG11mu
	u3q9daLwIP/t7mB9GrU3qucroSwgOz/8FSBnntmCorMsHrZshJcNPPfB1G7rl+opGr1I94wd4Iz
	Zselpey4ro77WNOpLFzLcSCNM+wU9ff03FcNJwPlww==
X-Google-Smtp-Source: AGHT+IGWiRPIFba72Azh1VnX3B1DB2q4xW2k342SX73O+LavSRIo8sHD7IlluQkIFqBtY30AVoTvaA==
X-Received: by 2002:a5d:64ce:0:b0:385:f092:e16 with SMTP id ffacd0b85a97d-38a223fefbdmr49263388f8f.55.1736087550356;
        Sun, 05 Jan 2025 06:32:30 -0800 (PST)
Received: from localhost.localdomain (host-95-246-253-26.retail.telecomitalia.it. [95.246.253.26])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-43656b013e1sm568189695e9.12.2025.01.05.06.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2025 06:32:29 -0800 (PST)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	upstream@airoha.com
Subject: [PATCH v10 1/3] spinlock: extend guard with spinlock_bh variants
Date: Sun,  5 Jan 2025 15:30:46 +0100
Message-ID: <20250105143106.20989-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250105143106.20989-1-ansuelsmth@gmail.com>
References: <20250105143106.20989-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend guard APIs with missing raw/spinlock_bh variants.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/spinlock.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 63dd8cf3c3c2..d3561c4a080e 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -548,6 +548,12 @@ DEFINE_LOCK_GUARD_1(raw_spinlock_irq, raw_spinlock_t,
 
 DEFINE_LOCK_GUARD_1_COND(raw_spinlock_irq, _try, raw_spin_trylock_irq(_T->lock))
 
+DEFINE_LOCK_GUARD_1(raw_spinlock_bh, raw_spinlock_t,
+		    raw_spin_lock_bh(_T->lock),
+		    raw_spin_unlock_bh(_T->lock))
+
+DEFINE_LOCK_GUARD_1_COND(raw_spinlock_bh, _try, raw_spin_trylock_bh(_T->lock))
+
 DEFINE_LOCK_GUARD_1(raw_spinlock_irqsave, raw_spinlock_t,
 		    raw_spin_lock_irqsave(_T->lock, _T->flags),
 		    raw_spin_unlock_irqrestore(_T->lock, _T->flags),
@@ -569,6 +575,13 @@ DEFINE_LOCK_GUARD_1(spinlock_irq, spinlock_t,
 DEFINE_LOCK_GUARD_1_COND(spinlock_irq, _try,
 			 spin_trylock_irq(_T->lock))
 
+DEFINE_LOCK_GUARD_1(spinlock_bh, spinlock_t,
+		    spin_lock_bh(_T->lock),
+		    spin_unlock_bh(_T->lock))
+
+DEFINE_LOCK_GUARD_1_COND(spinlock_bh, _try,
+			 spin_trylock_bh(_T->lock))
+
 DEFINE_LOCK_GUARD_1(spinlock_irqsave, spinlock_t,
 		    spin_lock_irqsave(_T->lock, _T->flags),
 		    spin_unlock_irqrestore(_T->lock, _T->flags),
-- 
2.45.2

