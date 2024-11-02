Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B071154423;
	Sat,  2 Nov 2024 17:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730569880; cv=none; b=uSdHHWmt2X5Tgd6xbAooaX2wAV24L1DSy5YEzOae/dzHcwy+AcaC4ijjwN52sKmnajHZHS4guKNN58O9jUHCctQGcUrE/f3xmtlOZMP4slGEJ2uYrQp5mYpc53xjuTMHj2lk5oID+yG9KnQEYrtXdb/AeiiFfj5JpdwYLIQ/23U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730569880; c=relaxed/simple;
	bh=YamZzvhmaDu6jNuMTIZ5BlSZQSa1W1+FOr371olPtTw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=dFIbVR6C0C1sL/DWOG8TUKnVidhnLa5R2SXZ8Mo1Oc7nGmra1Lebory8iDy16FFM5YyI0URi2W4JMHmLOuxK+RpiVyyovMGVt5ilgKDvsceaPELJiAt2Ub3eH8daKveDbi8DsxVrq6PG3KwZO4Q8f94FBiNOSf48Ul63ilTjN10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kk9mIzwC; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kk9mIzwC"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4315eac969aso16959575e9.1;
        Sat, 02 Nov 2024 10:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730569877; x=1731174677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=CXMuB9N8iV8ohwDfKCUDi+5Z+yxX91mIom7ZPwIqV+s=;
        b=Kk9mIzwCOAZLGz7ACfa1C2de25Q9Eyvz4ztnzFbLy1EGbELdzofKDhSfOZwEpWvKGt
         Mqq7ImQVtvuFiSDqe7zPVlZHFnqE1zBcQisccXfuAY1G/22Wwq2XKX370QMi9WpT39iC
         zontc0mMajj9+LNEq2bPazTAgjQC3+RHQY2NYOK1N2Ol5Sj/QmsgZtuhltnpoEvVVa5G
         BTEBoKJy3RP6zMjAmXoL3X8xgGAOZFAFBXaI9n5Ql2+r3Daz6dYJDxMwGdVu7Tfk907z
         XSJ+tDaGje5vxWoNgzaUAPX7eyAgBtO1CGt4uodTstywYI7aAWmekBq7p0BRR+qIoJgz
         XUWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730569877; x=1731174677;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CXMuB9N8iV8ohwDfKCUDi+5Z+yxX91mIom7ZPwIqV+s=;
        b=uFKOPGabpt6w7SsrTkLar8743+nIReF1OF0RPTENAChTCeaEZ8wWJHRN4RYh9u7+Z6
         MFwTjFBCRl/TASM3EC/vokVxvYslxKkiYslBpYmE3UIl7vm0KnK5k3JwIaTKQ/luYbYD
         qDpDEZ0rM1FlMfJPxDyZVmePY7A4iayGoh3qjDmnL6XblmfLnD0byY12MXjq85eOyZ3C
         wgu28hygBkubd0JkHrsRj8psgb91Z1YfuDquiUK9coTzBd5igRvjNRc1wWe4Z8tnGL4V
         ve9vrjb6VQRsl8b28zbDbLO3E6n7CWef7DXMTiYEoxJ9x6uujBHDtn4S3Uq9DTjePGW1
         I2xw==
X-Forwarded-Encrypted: i=1; AJvYcCUdQCK9Tjmor+wOSqpk4rrAH+aUdKyN32VoYcuycvl6/j6IoXUXb6nXpcL08t63vLRT2Ny7Me/kUgBqicTf@vger.kernel.org, AJvYcCWRHDC5HZkJZO5OnNRNw79f35Xs500JB5H9XgX+TDEYx7Jm2oSufX6n3sP1szw1iRivqz3Xh7dhUN2w@vger.kernel.org, AJvYcCWbuiCkuVuBTRg8RiDtxkXZZIgt6iObvwyFVoD7C3JCeccudaMaW1IJ05cb0dXi9g/LeZdyNFTmg8uUddOu@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg74oPZdDhHPhOgN4s1HcbklndxlkyjECrxsWcFcFXRCPhl3bb
	mcfOW0d78szuFScULS2cCcJk7Ly3Ev2JfS9fr5i3nZK9cPuXWIJr
X-Google-Smtp-Source: AGHT+IG4ErV019b24ATJCRbM47/c0+opqsvXEfIywMoSiIaC/9Pmiq6VSJ0+BXswztHALWT6hLxtkQ==
X-Received: by 2002:a05:600c:1d08:b0:431:559d:4103 with SMTP id 5b1f17b1804b1-4327daa3507mr83554475e9.7.1730569877333;
        Sat, 02 Nov 2024 10:51:17 -0700 (PDT)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-431bd9aa611sm131471715e9.34.2024.11.02.10.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Nov 2024 10:51:16 -0700 (PDT)
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
Subject: [PATCH v6 1/3] spinlock: extend guard with spinlock_bh variants
Date: Sat,  2 Nov 2024 18:50:33 +0100
Message-ID: <20241102175045.10408-1-ansuelsmth@gmail.com>
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

