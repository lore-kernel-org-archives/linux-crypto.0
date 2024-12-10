Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09A222B59A;
	Tue, 10 Dec 2024 20:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733863766; cv=none; b=Z4/OMk86bjrrAuJa8uKxO1BCSB/tVW3hcy+KBJOL/19HCeYhM3JmeQQfrVpuQvmzVkbcvitj98kBkh6TwnCC/JOPc3kC55TVlSygO//pnw85k1AuuEAr/SLotjB9L8wXqNFDtQRGqJnG0WcGhmuGU8SQ6F2xLAdZaYGKlerurMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733863766; c=relaxed/simple;
	bh=etUkdgGOAeKQsofCjyp34uBeNTm3qccykJ4LE5ZFruA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQn/a20vfCkrjnQONvMmdyai+Geaj6tlayebwCBJ8XlYQkQOPzWFpMmOuFiiN/Z/YDBx5tKtlbdKADKepT43YJPmh2hMxY5fXWN+x8ZFXYWZ2ACMBG4IgQ5aXaKhFiopyclf+O4aANOC7B0Do31JHdapOj4YGyAfQPUKnt6r1H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AjIoFuQX; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AjIoFuQX"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-434fef8203fso13823405e9.1;
        Tue, 10 Dec 2024 12:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733863763; x=1734468563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ukl42wl26ysASwjUxfV5ZoP20+T/0IwuT5xUtOVMrvc=;
        b=AjIoFuQXkfaH+Y0v0Axtt428FoUor8MYjDFj7jm7Ffbbk4HNCvGWFXYjSjUCSlUjyJ
         meoCNbEsGsh2awybWtylcLUSPoBNmQzxFkKcbCWSCF5SD4JV75ChfStDSOGNPba22QXV
         8BCJeTXNKHIFeKKmMrDibX/tJpa8p+qAbf/QXqwTMtiY1WCuXox8wh3Q6dcOn1ZrYIkE
         wR6b3PEDiIWKjCALpKyEZJGbd897bAPE16uhosNozuhSgtFLL4YsfcEzLYByXgDErPJv
         hsUXu/dIhBHheY8az4GydWVUO/IWrPk5IuoPb9vMlhIHHORHqEzZm/KicbT4T75xVl7V
         Fy3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733863763; x=1734468563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ukl42wl26ysASwjUxfV5ZoP20+T/0IwuT5xUtOVMrvc=;
        b=akabhuu7naNue62rOo2NGpyhmIWUVFBzpNipv1DR4royHhnJOGUytO5iZ4JIE1HxZp
         jGPU3qlUAMPJSdoe8axyCfyF6+/sYBMojMcVjrTZEq+NkY57CQf+YwF4qQzIUUhl7Yms
         KRzlwJuJ9rPs1ckkXbAH7L2tMVP6+jfvAnl6xhcBG5aJWAKDlcFHXy+SL2/JcIw5c/yS
         uxec1oAf/FsRmAXRQWpMPddYVQ+3rzS2oTGGyVbdW5ukkBTYjfgy5yW1NEJkXs0z2d/Y
         IHsmgLzwXQO9InmC67PVra9MGxcYzddzfb40Qfzsxm5fx1W5zqGacIJHa7wGxF3KUoie
         B7Dg==
X-Forwarded-Encrypted: i=1; AJvYcCVrjCuQu5/Fa+3JpH8wY/hM9/KHqKKpchTCYJkznG67nWe/U6wOM2kXsWIg+fNljIM/Iqf9XSVlqZS6DMCg@vger.kernel.org, AJvYcCWkLmsdwQr5uWl8UbTexVnFDM6bKhi7oj0sEDlFIoZyQDAvYXRzz9ageCleYrJ017SbZI+LJ2IYGOC7@vger.kernel.org, AJvYcCWzhIUsJrCaUyUP7iuiqowYMLcIX4LPawEDhWwIpedfAX1OXlj/Br74UeRn++a2ry5vlV5w+8Zd2ZqDxKoU@vger.kernel.org
X-Gm-Message-State: AOJu0Yxwhr80A64fr359YVsxefWEz/1TUO5tj1lCpmRsFapHxwYBHeDE
	BrljqEKHjPfGnnqs3X4epseaHxeKTTa6NzO6dz0iOauCdXPk042K
X-Gm-Gg: ASbGncsSy2dJ4DjxIOxWB+FOBiY222x/9M/wq0uTmTWh2D8Ul5DOhvqkO2VUlAyQJY2
	zECamZXmxeLKNadq4k0G0Tns6IiULZ3G2aldrUJXkkUI1VOzH79XvexyKF3BGsgNWZUHBqEwNq5
	FpGEHNjJAwJexUo/hLLysEisu3uEUZvlSbZEZ/R7ikeW4IApYLz14SpSl0qcIkenpKDAv/5yB7I
	PPe/IiSi+VyNFMbeKQVQSQZNxW0fuudW1Nq7e+Dkbjn6laGbp5xGjxudoiTHio6qDlqEx3fgKrG
	9/9dd8UPjYmG6RbgQPvhQKs=
X-Google-Smtp-Source: AGHT+IHZp+NUH73dscQuYZ/2Rd2wKuMljBl3NtIdFrOR7rbxWGIGQYPnskLR76kS8T3Ksr9CszjJxA==
X-Received: by 2002:a05:6000:1867:b0:386:2aba:a7f6 with SMTP id ffacd0b85a97d-3864cea41f2mr345776f8f.49.1733863762853;
        Tue, 10 Dec 2024 12:49:22 -0800 (PST)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-386334d0486sm11808307f8f.50.2024.12.10.12.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 12:49:21 -0800 (PST)
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
Subject: [PATCH v8 1/3] spinlock: extend guard with spinlock_bh variants
Date: Tue, 10 Dec 2024 21:48:31 +0100
Message-ID: <20241210204853.18765-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241210204853.18765-1-ansuelsmth@gmail.com>
References: <20241210204853.18765-1-ansuelsmth@gmail.com>
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

