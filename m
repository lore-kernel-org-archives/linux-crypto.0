Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A238F1DE88C;
	Mon, 21 Oct 2024 14:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729522675; cv=none; b=pf8SfsLTVS66ks6L/BGIS3uKCLezgCpupsDHZNOgQzPQV3+jy2if0VUCC6pfEKhRYSjKSYViiJbGCiNeSh+T79vd5jgYo5KmqAMl6fTgXLhoGb4byKvdDonpjIxCqnb621E38ScmOX9Vfe5zxa6PEGSc8QZnGCxfwzumWvbEJks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729522675; c=relaxed/simple;
	bh=kJOUFMj6PXyuxDe3YoC2Je0/IAK0gMUIltuZ7HfFDHo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Uayxhk6lEQABh+hdyQ32c7tsdsE8jBt/2UyvKPPEhR4yI7opXNDaLw1J41M+VcqBruBH1uoBHJ65oygzfzF0cwufD/907lje9lXkEKYJuNx4D4FTDHjFXIEtWJ34soqR9W6CIz14C5sDBJAqnjTRh8puI5rCUWtPl1aXvSSoaO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WqGdtjHG; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WqGdtjHG"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4315abed18aso42396805e9.2;
        Mon, 21 Oct 2024 07:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729522672; x=1730127472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=3owwwcHs1MDpHN+omOmsedchFOMoG1OAJp1p2+rcmMM=;
        b=WqGdtjHGkn33b6/RFeUTbRK94W3wmpP+qazNx7hjrzlyQzXu1SSk7jUBsRrWVsJx1u
         6dHuWNuEFRhjLnp8V779MHnmx1j8mVL4NgtcL6jhddaFGY2D+g2gffrbfJZAzyXFaPHM
         gfcFFkeCVXVUMW9H81jN1QcTMPYnDGBmZ7/kBnAIyFXE7gOz3TKIpaFhNcECbjxuucMy
         KgGFIoChTnOGJJVO8URvMVNMafI4VT3mDPzwJTIT/Q3+dOOfBXmTUm1bRTy9AizVIGYT
         CGH1Pc5tjOkETmk6gsVJHaqBkIJYWkgHW+fiJKuekqLxG+KEkOaixGoeiCBQR747XLj6
         Ax0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729522672; x=1730127472;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3owwwcHs1MDpHN+omOmsedchFOMoG1OAJp1p2+rcmMM=;
        b=laigyENrAxTNqfoIQwga1ByevdV+2x5/YI/1m/ECWgUZUdQmIrIM6DOOlOmaF5c3Mf
         A7upgKM1N26yKTGFDaO9+3qczU0j1eef/9vyl4TlcwK0r0xvxhbXIx60BR6uq7r9KQEe
         qQmCcAZJ2T5Q1LQ+4Izd6otzpHkTAWLED8IM5gIq+wGqtc/VqEEhnzv7BliuyFj9JgaY
         2UEHKD4hi4hZrchvQmpJB1qO9lAFRAqoNubM4cAlb7xt99iVc2NfMxFu4T2s0eOoWNB5
         C8OL8ErdbYhqo/nfTGK/Fjju8R533P/CdsdUj4/8LVvOeeMzrtMW0hW3qR2wD++nNjfv
         jSXg==
X-Forwarded-Encrypted: i=1; AJvYcCUTn8ZhixNhQL6JpCdCO9YM6UrKczolZjaDSRYJC70aLGAzZa0ra72O7pFnrn/u6Zx/FenOXV0JQdZqWhG3@vger.kernel.org, AJvYcCV3iFwytLcJt7SnL6SZ3hLotuIFaIV6b8jD2taue2Boh4w0CX9y2a9tqkZ/Xesfh/aPeRZLJJk92aXl@vger.kernel.org, AJvYcCXSp26BQ04phSf/cuVjMaQbGH76BA2llo3pCSkKmv32b609gZda8KQ4c6BRNwi2y++GnwvfGpZLl63m58lv@vger.kernel.org
X-Gm-Message-State: AOJu0YyvLpvM739K++vbIcaq1gYlYhuZRz1p5uailvOLX5Ft4JEFZxOt
	qwacQS/NAUYiD3sTtx01D0obb2VMgQCS9xUCD6YHbmFmvw/qpoG/w/Syhw==
X-Google-Smtp-Source: AGHT+IEmU9LyD7il74oyZHDJiaTohk0WzR0tAbNyuFwffiexLZFKYQGfHAyBwaGs3mcOURxZ9Jl+IA==
X-Received: by 2002:a05:600c:1c95:b0:431:6083:cd2a with SMTP id 5b1f17b1804b1-43161659c02mr100797525e9.15.1729522671501;
        Mon, 21 Oct 2024 07:57:51 -0700 (PDT)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4316f58adffsm60303545e9.22.2024.10.21.07.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 07:57:51 -0700 (PDT)
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
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Richard van Schagen <vschagen@icloud.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [RFC PATCH v3 1/3] spinlock: extend guard with spinlock_bh variants
Date: Mon, 21 Oct 2024 16:56:37 +0200
Message-ID: <20241021145642.16368-1-ansuelsmth@gmail.com>
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
Changes v2:
- Add this patch

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

