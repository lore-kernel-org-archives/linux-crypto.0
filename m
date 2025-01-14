Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CF4236A9B;
	Tue, 14 Jan 2025 12:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736858520; cv=none; b=SIvhLSgVrnW6JXB1rDM3G6/teptzTiCVlHXAl9Ex/taOt/YSudpuhzkjrdNdHZcu0OyT6IlfbduGaojfWsOl8qr6QHLnWBeKPu/bK+VNvC7nSX13YKyDrOiz3NNB18rrTcdtjP484ItMuYLQJklrjrbkbah3iawFq6zcuggHnwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736858520; c=relaxed/simple;
	bh=etUkdgGOAeKQsofCjyp34uBeNTm3qccykJ4LE5ZFruA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLDYYKnCb7is7ezbxoSZGauYkq979ylrWNp+cFChARhBK2xQGH1+dR/hTkrtSNqwRdfGn3Bpgm/RhKfu8eKBwT9z9TnBhroK1Cm2o1m4n1vn0DSAKehowgHoWaHNjuTX6DF/nBLC7vsaQF8sBwnsm+ZXJlEyF200zq1k50aaf2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IiLgvSdI; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IiLgvSdI"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4361e89b6daso38789105e9.3;
        Tue, 14 Jan 2025 04:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736858517; x=1737463317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ukl42wl26ysASwjUxfV5ZoP20+T/0IwuT5xUtOVMrvc=;
        b=IiLgvSdIfEGPAVjgJYN9WXZj+BAfgulKl/GetVTNbn4jHrGFFhDQ4GjGm+n8w1JuH/
         gLIHcgFf6MTNMciD0zmzm9APFjKEZZ0oVD70W2KNSnpYRqTKJaieNNkX4ZE6yXt0jC2G
         Fik4hsjK8LWleHboMs6T5seh1DLw+wg2NtpPkTM34lEKWp6i9yEgxmuW68VMnh6MtcQf
         647wkuhScBaj9QEf4sNPZ54DBQKF9CWbpD1ZnOpR3TpkEfmB8GKDzzpoSWdLIBMggK6V
         XcWa3wx7RKOURB2MR66O0HFQZvG8HZIuN8U8z8jLRqK9gyXk+VEsmOhZ/iFihI7Ddvdt
         7L6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736858517; x=1737463317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ukl42wl26ysASwjUxfV5ZoP20+T/0IwuT5xUtOVMrvc=;
        b=OtYO7taDMFMw+dO8+bu3YeCVm1i5N4SWC51rxDU8/cOfJtkNb2jWrPx5KpSwajEdC7
         K7Dn38XhcSGFwT81MKkR+rWksQCTqCNL63ScJsi+yCRoxLODpq8l1+b1JBE/tjTGSnaT
         ModKpHXShjIibsl3l6TDTEF21tNSDhmJHgzmOd0zy2tWxeTcQAX+20XEShTA6GAk6HrA
         VstjNmqDnC4wDz/i9NQAZsi0s7GKMQiJ1Por91IKs1J/Fits0s0HpLtyIJnNzmAnmb1K
         xtUM5dw3dqxhywTQSS0shK6VHUfZFEacstofzcZKuHcw1Mei6WO5pfVVPSpN1ARuMpjZ
         Zylg==
X-Forwarded-Encrypted: i=1; AJvYcCUTRJjAoSg7W3yd+dYPIYv87BN58mcDMaaRgVI8ec4V5RM7VJsnubpNtbXK4rWwV/35xIokFXi2aQWKkHF6@vger.kernel.org, AJvYcCWWyv/C9TFY/tcGk+uAX+HQ5J5T2r4aExearu8VRl67MHsay7CvkCTgZ5mEUWu0RSMA1ZAl0AG/4UG4@vger.kernel.org, AJvYcCXPuglVpax+ROQh2osupNVICDJRZpCHY3jX9rbcoRQpr1Sr0LUh9isPMiruwmzX274hLB6IkbNdWKr2LUdo@vger.kernel.org
X-Gm-Message-State: AOJu0YzMp4w/loMwz1V7PrNutks/QzK0B7KXM+o6d3ntH4Pk0AR7jyLU
	U7TSpqMxrQZ4uxcecG71uzMJOZk3kSw8PIRHAMBjhhAostWmV2mY
X-Gm-Gg: ASbGncvepH1U2yKG50niAHf+yvaH81ro0G20Of8diilO7V2re3fjN5uqPeJMLX0qH6Q
	8rDrJsyI7XWykphkP4t0B6cQWFSYSOv7B6W5JAJkaeTRtE6brRthwoAjKu1PnmpXfju4LmAs99E
	nMR49pTOZnn6jBX0kTWXV2SpHulwW5MAvgMmoODCGGT76wb2OWKU6lf3Ota5od2iI9IsyX/BK6D
	lG17dM9VpIgH0r2Ck79+O2QtSDNz5Dc3LsvSXWIVNRf51O3rrKggAvAcdYS+T7Bk5/PLZ940GNc
	ROCVlUclkFdHf22bk829yJsSig==
X-Google-Smtp-Source: AGHT+IGnbebatGAOiJ3fjOKMQPS+jkDpP6sYR3bmMOHCqroBtsQ1XYlDJmLLnxvAZWV1clSRm5lr1Q==
X-Received: by 2002:a05:600c:1c14:b0:434:f0df:a14 with SMTP id 5b1f17b1804b1-436e26786a4mr52023115e9.2.1736858516797;
        Tue, 14 Jan 2025 04:41:56 -0800 (PST)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a8e38c6a2sm14798771f8f.54.2025.01.14.04.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 04:41:56 -0800 (PST)
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
Subject: [PATCH v11 1/3] spinlock: extend guard with spinlock_bh variants
Date: Tue, 14 Jan 2025 13:36:34 +0100
Message-ID: <20250114123935.18346-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250114123935.18346-1-ansuelsmth@gmail.com>
References: <20250114123935.18346-1-ansuelsmth@gmail.com>
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

