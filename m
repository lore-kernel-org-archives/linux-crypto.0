Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3697F12FB1B;
	Fri, 25 Oct 2024 09:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729849690; cv=none; b=hWj4umLs4FYWOUbx5vP/VHYa0zRzKTELZ7vcWXQG4WbaEqD6NJU74ZsD1k4dVRD3NoR2LWDF66p3yw2IQrsCG7cSTiLamVjChmOxaHklRT/UHcZOhQymRkt7Hk13jFcr8fIIDkVTPJlJFLikLiWwzMqhVLPdXI3wvIt76BCf8K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729849690; c=relaxed/simple;
	bh=ThNvSYZfVe6QKlfxCYRKH8iB/n3TbOriKl7MaLULAAI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=h5PvL+RIKuvP3h0yZCtUi6RqCv4r0oi8UryYVyCaGs7CRE7xaUvmKm9dGtNBJY2Aonts57N8NlXovCAYnB/Eb1Hevd/M8gDs8YalDG3gtUR12qd/AvlhO0olk+Vf4y/taB5C0yLLkZU8td5RW21rKVrhFI84ZxrxF+i844LLEyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eBG3Aug+; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eBG3Aug+"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2fb561f273eso17935981fa.2;
        Fri, 25 Oct 2024 02:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729849686; x=1730454486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=DYXk8J3KGsQhDnC6wKQa2Bh6Djnz5JRK+lEco2zJMUk=;
        b=eBG3Aug+yQfA5PIm9NZwP4C/NGAg5vTZCTg0KnifPTKeQ0DKmNUVVvHowDNXqY2DHa
         hnThdFD9kZs8Jn7NUGP3mSIOsRfRTkl5WDl0nxP/u+ALAzVen8r6C0Kn9GFSlQ9VzFTR
         2EPn+dQgoSJwJtisfDKV1Q8d7305XahFyvAx0qRDysIGHK9QPYGnSL8vu3k1HhwfyDX8
         h0XdUUdp3je17wptAaQ4e2jZZA3uNzky1jRzGnQRqSo5Xns7vcpPjFr21B9rCQXP0n/o
         8ORYsY7NC925fcVkXyB1k4CyS6wAyyTiwpykr5uNd/se+RJ2m27Mo8tx3ETWlduLwSmz
         DVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729849686; x=1730454486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DYXk8J3KGsQhDnC6wKQa2Bh6Djnz5JRK+lEco2zJMUk=;
        b=WTY47QdP+ozwP4VTu7UOsn6wdSKNYWQrIezFTFNyCSCszsMfW7ylnZLauElANYnWqB
         J4Cjv97xuOSi/apBJk3oV+b5shYGKLXUheBhAoksaoSUIVOdj8uwyNbo8DLyGMsXI2O9
         I5dGaurQyCOi0ERQU6Z7Cl3yglK6v4NUIOQdxEMhG66gXG7ByOjsw0guSxWGWZbyTHCT
         o5GgaGj9x+9ykEmLXqqJRJXUz9tWsW+Z0sVrTfYKNE6b8RGxlchIcabB+oActu1if/eq
         +46QDOGbTfQ8oyaV8Cn/4MYaIK37pm6YDmthBp7XRixT3+tyExAKGgVHZ1ofmD8syk8Z
         F6Ig==
X-Forwarded-Encrypted: i=1; AJvYcCV86a5Zml4ptxMeuoVdiC9y4XLZlGjeYzrTGj9b+nieqaCHH8PcFBSS/WwEjQVYL3ljiG8qiS+bHcwXGflY@vger.kernel.org, AJvYcCVPvkgLy0B3gVuqmJM4JgjkLC+lLVkLTPhTnQi5Qo/2FRYl+rLZRAPGfMP5Br3E5omf9C9+qj4jG+sf@vger.kernel.org, AJvYcCVe7zoBVE4tepoMOLIsRbgsDWsVVT4oQ0FPkssOPJHqtT1CJSSlleqx3HTx0Nn0C7cZgiFzaFEIsraWBGQB@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/AX6Pg/o7mTbs4m0IplaOVaEKKMNuXD0s5XPz89dpUtc2MkKG
	bTwxHVvEaSgMPgAux5ZoXCPfFfLZICLd/co5V9ZeONPZbcJq+ipg
X-Google-Smtp-Source: AGHT+IGL3uChiYeGKtJomYvkUJIYvNEpHy1hENHRApI/vHuYwn6oMN9tfoB9YDLfeAdwSvGKyYrMMw==
X-Received: by 2002:a2e:a554:0:b0:2fb:407b:1702 with SMTP id 38308e7fff4ca-2fc9d392a94mr51934231fa.20.1729849686055;
        Fri, 25 Oct 2024 02:48:06 -0700 (PDT)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4318b55f50csm42785605e9.17.2024.10.25.02.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 02:48:05 -0700 (PDT)
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
Subject: [PATCH v4 1/3] spinlock: extend guard with spinlock_bh variants
Date: Fri, 25 Oct 2024 11:47:22 +0200
Message-ID: <20241025094734.1614-1-ansuelsmth@gmail.com>
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
Changes v4:
- Out of RFC
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

