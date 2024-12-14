Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7FB191F89;
	Sat, 14 Dec 2024 13:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734182928; cv=none; b=SsUQIC1Dy0qlu5gnRMwYszZqNhtBgrhi0BZJ+wzq48AH5t3pCmMeNZDySfp1G5+loRb2i3CED017WaNKiA3Ewhj38M+AxuUprGO0T6lKEkUxi3B6iJxEqkmLu+wJQoLLGvkQsiQ9VELsvrERVOwZ53MeJOhwHqfMQwzCQbH3Mhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734182928; c=relaxed/simple;
	bh=etUkdgGOAeKQsofCjyp34uBeNTm3qccykJ4LE5ZFruA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVbIzZSbzm0iVAFoVzi2jw1qAQeUQXf3q0i9VIoZWEMjJ80LQch4DBrmaZfZXiKdGj4CGFBOxyY58HnprFCYoU2MqN7QBBBN76H29pJxEM+DxRmJfWOwmPJcSBMFwZZIGunFFrRnAUX67fc6/jyc44u0n7eDp/moi1U1YNy8Tsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eFUdXikA; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eFUdXikA"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43628e97467so20739185e9.3;
        Sat, 14 Dec 2024 05:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734182925; x=1734787725; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ukl42wl26ysASwjUxfV5ZoP20+T/0IwuT5xUtOVMrvc=;
        b=eFUdXikAcITQke+jU0ZKHWL/Rg0yhWUtDIZuNSVSgu2/WBoYI0wazd5t29sooSJgHe
         pQor0O199PJgmf8jRMn4L07aopnCx4VmAgEPezU6mz12IabMxUsIqa8MGEKAjiPNm5UX
         y8WKvlcKkQeptSSdXuQsbJZbGExHxgfaOkg5vCWGG4WXPDg2nIqYkVxhcwkhhirM5YWG
         4QSPDk2v+EXINxnXaYBGBut+0aD6vG4mKVIDpBd1PPbBdlOtUw8jyPlqPe3aZICxxtMR
         nteuWECcBmzBIQtL+TStBOAWbrNvP2yO9juQYv3+K7hixJFDh66EWM1yVvjKdgBSIASv
         iFEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734182925; x=1734787725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ukl42wl26ysASwjUxfV5ZoP20+T/0IwuT5xUtOVMrvc=;
        b=swG++/5QRrty24U1SW27+GzKIQ2qsMNoHKsBR2derGXwTso+IVadVXxGkcxkpaR+va
         tnKkRJE7OB6uk1CXzL2dsyZH4D5TD5wfplMi6wH+l0xHHSNHFisBgTiNLYg2ug4pDTEL
         tmaPAHD4ceBVgmZOp1miREfIY1qFHUx1WDiD2tevX6USN/54EYELN3TLGTzCJoGZpHup
         mLLNzSA2/cs2QO9t6relYXSygCNFTrH9Ee3+qmADJKiGcUAZxqqIGpDqSA1fqmAHnYpG
         BtOnGxkkI8h+dggtS3aCmVlOUqGE+Uk4ytvx+zPIRclzXKXXPoUhuncCVPhd5nMyY9xp
         eMDw==
X-Forwarded-Encrypted: i=1; AJvYcCUx3jBR81/FqjWVVdKRbjcwu9dPdYX208atuz/7Q5hc2NL8nZShpngaNSwb1t4WyMmL6IQQyj/58uy9N8C/@vger.kernel.org, AJvYcCX1VCeAVt6c8u1uHSAAalGOwio9ZTt4SvV7nRHhFJN7MWX3Au2ogic/05OIZ8h9BcoUyeZ8saPS4siK@vger.kernel.org, AJvYcCXMaCSCpQl2i4nIm8iLBELjHdLOdJ9w7fNA/DD9mOJGjzImdO1BzEJ12gTqOzy7r6wx9leo3Wa6UN+/umxv@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0zCPi8agNXwXwdyoLcQi1IRBJXRBn2qE3NsEY+h/sFtVAX4+X
	NlUM5Im5MZRxMM+RHQ7BsmaGIZ9m0W2O2tvT38NbvgNvqCWI0FnX
X-Gm-Gg: ASbGncv7HlSUlPL26PYJHd46AjKVM2kvduJa00LYoCu7kqsVvHC2uOYQ+eg2RGPPXji
	PKIqcjQ0+IV7WAsA0nHVgJLYoVQ2frORl0FBeo6hAQDfvT32bCFLA4szisdt3meyCHt32h9Ij0r
	Bn3OxgOCYldeLTWhusXRBS5iI1HfOHBvPRXeqGd5ABmlVS489EJg1Yv/gr5ehF5pL27Q8R8gLRW
	yrysNEZA5blN88fIlebbQeC36D5fcjsYIl6XU247/UFFP0nkCjmtYTT+qLagBbZyu87cfI1duVI
	wOw+6zVhJ4tAOvOnpEVueu2tDg==
X-Google-Smtp-Source: AGHT+IG5kdQpiIjRbtSweLewsWUDjb0hmx6Fb1IaBGBclApFb+ntYBESFJER2L81+4vZb12ZKm1MGw==
X-Received: by 2002:a05:600c:510c:b0:434:a19a:5965 with SMTP id 5b1f17b1804b1-4362aa157afmr55257345e9.6.1734182924638;
        Sat, 14 Dec 2024 05:28:44 -0800 (PST)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-388c80162a6sm2559850f8f.33.2024.12.14.05.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2024 05:28:44 -0800 (PST)
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
Subject: [PATCH v9 1/3] spinlock: extend guard with spinlock_bh variants
Date: Sat, 14 Dec 2024 14:27:52 +0100
Message-ID: <20241214132808.19449-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241214132808.19449-1-ansuelsmth@gmail.com>
References: <20241214132808.19449-1-ansuelsmth@gmail.com>
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

