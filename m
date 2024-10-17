Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9E01F942;
	Thu, 17 Oct 2024 00:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729125853; cv=none; b=GRMwd+MO2Ncg5FWW4BX2AOrpA58t0/mwSBp2eQzkSVFKaSdxnMnJOXQ7m5SxYYPB1UJmHvG0wz2a7ftCDJOVt1+XsPvPrPn8B3GHsT8I3rL9tDzMi2e4+WqH01J25LFTwx1XVGGL3smRfHh9XGjjCa6tvpixpW/413Wcyi7jjoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729125853; c=relaxed/simple;
	bh=rrAFgt7MmFcWWN8PLPvDb7FLmqPUwpsbvQDeeE0PzlE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Z6ttKkhJQmU4+ROBZFD43kKqDSndR9fz/KFWHuJdfnMBwzg9q9dT8eedwRbTR4jJBjVdZt6MFg/ATKGgiBfy/jsfS1gv5bGG5Dgx4KNTBiovZyAJlPeoT/3HlLgKMR8O1jLkjj7rN84VW5RUd+1Mh6i5YEDy+1/CFw2wX8mq4UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KV9S2X/P; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KV9S2X/P"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-37d41894a32so224551f8f.1;
        Wed, 16 Oct 2024 17:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729125850; x=1729730650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=y3Hb5EF2QXHTPkKjiIQ0VTrF8MSdq781n7gJ5VZ5vSg=;
        b=KV9S2X/PmypgzvbiaNzzlO5ugIipmvPiL+r4qU4hzmJMHImliIYDgjppmIQbCPSvck
         FX+z2JUVg/hUkJBgKTvSdlzKbbts6lvYXmoE1R2HJVD1bzLpklgQ6zBVnep3Eq5EXYMk
         pDpFcoztYsMK0V+kjfru9BR170j00CqBEmmQTMkN8IsZ+F85PzZ/RxaSY82UIxb6SV0S
         QPpbWf9vjdNhEZDJ0kWU5btHJTmTbvGmQY2/q1+Mgxz/eZoQEc0JM0iNfEMEuRYH2Vm7
         q5a7ghn1bcnJ6QP+iqO3yyRl/DvF7miORK/x+ZWwofFTpzogNokCV+BFuy1W7ISfi1mV
         enBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729125850; x=1729730650;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y3Hb5EF2QXHTPkKjiIQ0VTrF8MSdq781n7gJ5VZ5vSg=;
        b=MwBAKT9UuWV20fNSI1+lrarFOlvcmTA9+0o2AuEPC7UD1D6uY+tcn9Hgf7qeV7ycRn
         TvXlOmCAAVrF4vxkOQDB6lMkehfOAwXTSF3fS9hQ1JvZuSwbVw9ey0yk7YfX60mGJZKy
         vQyd0pwQlqf8LHZ3pObt236rzdDNd+UG1eIUu266HCN9rOcKPFqrk+8MfTgsurq4rsQT
         x5C32JvgDuW9L451crwYZ+Krc78I3x8v51KrSK+8o6bUVmHofFGYtPEWsaVlD7qD+a93
         TmA5/w9ZZJQBupJqIGE3y7OKrH7hbKey0SRPgfBc+fMKPgZoTiP6vbNHtPBOW/SM4bTU
         2OGw==
X-Forwarded-Encrypted: i=1; AJvYcCUGCHBuxCjcDtMHElG45m3hPUqUy3hulMlkis15ZipY83k9+hX4k3LkL8pONuLwuHiEvGsExBoudYRA@vger.kernel.org, AJvYcCV+KFsLMi5YCKTJvTeLSrcSeqDrNnKqDnkYqGZN8JFJ9AU7TOWLupglG2acPu1rb3kJ0VD1k/2Dc96aEF+1@vger.kernel.org, AJvYcCWIctmlDLxMu6UVhskJLbbBPhlFr2sPWYPDil4U3MkdrbXPMuwN74UWA/LgI6HI+KCm17Bj+2pvmnph9smI@vger.kernel.org
X-Gm-Message-State: AOJu0YxJfIHbt7d5Il1vCJATMFXL/mmRUVUlNIUrs7zBAhmKqDZ/sXq5
	JIwwfAWYBqyJx6yqGdahgbs1yEDGNm7hMu96k/Fgj/uwYuAkHpam
X-Google-Smtp-Source: AGHT+IGdBKabY17pkuhk5yWFmI5laYYTxziqcNsqEErFpXogkxzv8n0d8IYCqMT+dRHAo2kXyu541g==
X-Received: by 2002:a5d:6703:0:b0:37d:34e7:6d24 with SMTP id ffacd0b85a97d-37d93e25a4fmr750472f8f.18.1729125849607;
        Wed, 16 Oct 2024 17:44:09 -0700 (PDT)
Received: from localhost.localdomain (93-34-90-105.ip49.fastwebnet.it. [93.34.90.105])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-37d7fa7a1a3sm5617172f8f.12.2024.10.16.17.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 17:44:08 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
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
	Christian Marangi <ansuelsmth@gmail.com>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 1/3] spinlock: extend guard with spinlock_bh variants
Date: Thu, 17 Oct 2024 02:43:17 +0200
Message-ID: <20241017004335.27471-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend guard APIs with missing raw/spinlock_bh variants.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 include/linux/spinlock.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 3fcd20de6ca8..e016b27f64c4 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -550,6 +550,12 @@ DEFINE_LOCK_GUARD_1(raw_spinlock_irq, raw_spinlock_t,
 
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
@@ -571,6 +577,13 @@ DEFINE_LOCK_GUARD_1(spinlock_irq, spinlock_t,
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

