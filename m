Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AB91DA2F6;
	Mon, 28 Oct 2024 12:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119361; cv=none; b=jcpzdT+SOcPE6iVmnMdPCARsib/eAMThTYkz3k/iD02g3kfNbJMVtFO46nWyTRQcBB4mG3c5+4Gsx/AEd1oa/JPq3cCya8wK93UfTcB1WjQAxalRbem3gF9FLoiYJP5ebm6LG+HOE8zLuhA5BUFrqvegBNw1SxuQN7V2uw0kTQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119361; c=relaxed/simple;
	bh=YamZzvhmaDu6jNuMTIZ5BlSZQSa1W1+FOr371olPtTw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=IGdrCEjlUhaHBNKRuoXpzXrlmuMzuG1TEuGQQBjKjH9RFd8z9X/7YDX2utLeuqKww467wYP1tH95+6fQ2FrMH5zGcQbvO99xML915KvNp7ZMLNnhUcwctEic8Z8n7dG2lVl0aFPxIeSheao2U+ZcXMbyqdhM05U2TrhCGZpv5Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=huTbvfHC; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="huTbvfHC"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-37d49ffaba6so2994181f8f.0;
        Mon, 28 Oct 2024 05:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730119358; x=1730724158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=CXMuB9N8iV8ohwDfKCUDi+5Z+yxX91mIom7ZPwIqV+s=;
        b=huTbvfHC6rvJ48hocCda4hrMfxzlPh+s+Skjg20kHM/o5Kv8phrVdAmauewXfx8a6o
         l93HTyawLy+7KQHZyYKTrqNPU9HMoUC0TAtUtngy+WFgklMeYayTaHZDP0RdgZqeAiRL
         nkQPuBIJoC9tCCMlQUk8XM8LAfEgffcYZsLZW1MHNAVE1loyPpGbEkaYoFFe/h3Ktej4
         vU1tD5JIa/ZFvFtfvNTfCOVTzHgWFy31ATf05OPtSSW7dPWFleabuyhoV/OSLHz1In/V
         slMr6YLi/BGOmNQofdxQnNq4GMOIVBGrB97q6jeR9iSDGJt2TH7iPhtAJvECxaTP2yv+
         tiRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730119358; x=1730724158;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CXMuB9N8iV8ohwDfKCUDi+5Z+yxX91mIom7ZPwIqV+s=;
        b=B98nljSxILlKmkSCK7qr869NgmzN5qsdN7XMOzEP64CZY5mn6FQ9mRsBduk1beu9Ol
         xobNQ6Y6u3bMxxhE617QScytGS/0ypYXPteRw+klCtqe+1K25fxaQOQ9zi+jiW+ngbUh
         LtyAGzd3qN6TgloOp7e7HTh+4fvtI+TcfzRyEQahaVS5bVKBWIjtGk8HnBuTpSeVaAq0
         kBURTywjlRnxI8n7POuQA17+qlPkMI9gKh88XerUhzkNYsOb2og0btub/3ceNH8EHQn1
         brGznsj7R6G0ZSqd6xDs+wvTEkElJGGJDy9P48hyE64GhpNnbck8VTBOOK+/JRVy6b8+
         Q4Ew==
X-Forwarded-Encrypted: i=1; AJvYcCUM5IApVkcQ7uqMCoTXqT0TFtdVr2pW2IzMdr+nvxtmfV0kCgYFWHs1c7U2hnO8JIJof8ZdNtwKjEpFuqCr@vger.kernel.org, AJvYcCWR4eWABB2BJSY00XYyA+udFdD1SnFxEMCuteYwF6+rMWS54g7d3FHbTimbpp4hQQ9wRTxybjiflVE0@vger.kernel.org, AJvYcCXbEVSglfoNC2eHf0duJc3OeOE5jfVgB//F/dHWXhP+vEhyEjI5u2bXAiGX34gxrR7jrak4i79HIRkYa0HX@vger.kernel.org
X-Gm-Message-State: AOJu0Yzev0LGdY0OqIJ8pIQC7/QyCCwBJi6v62rPORe0KBoTPrIEGJHf
	8dSpfTTA/VoSGoaMbvQQTejgKZknKZkcfaW+XGt8bRhzJBz+Mw/i
X-Google-Smtp-Source: AGHT+IGSNkzbM6+B2nzURo8UwNG27pnjBN5LqzCF0OK8RLWSWY8HEXRszgdqRunm2dHG0ZmdMlqgGw==
X-Received: by 2002:adf:a444:0:b0:37d:46f4:35 with SMTP id ffacd0b85a97d-380611dc87dmr5821481f8f.45.1730119357792;
        Mon, 28 Oct 2024 05:42:37 -0700 (PDT)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38058b71231sm9352608f8f.66.2024.10.28.05.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 05:42:37 -0700 (PDT)
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
Subject: [PATCH v5 1/3] spinlock: extend guard with spinlock_bh variants
Date: Mon, 28 Oct 2024 13:41:41 +0100
Message-ID: <20241028124206.24321-1-ansuelsmth@gmail.com>
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
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
Changes v5:
- Add Ack tag
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

