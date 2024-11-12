Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397382040A8;
	Tue, 12 Nov 2024 01:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731376797; cv=none; b=QzlMLya1IlUGtLrtMp1+aGyIuwrruyD1v6bKof+DOIwGI+nfoYN14fIiXIyx+gPYxy0avfBFPrIyfLF3iS6p1TkPSe5WKYDErYziRCrqS+XpK9TQH3LrjL1nZx3SeFBhQcsObkBQV6+rXfMo2ULk6A5RSsgpty3vcF6cAYf/f6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731376797; c=relaxed/simple;
	bh=aXYZ1wmyao3Lcc2X2UFTZZ/JZa17V3RMqI9Bh2tXkH0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UQ9Cf2d78I2Vy1QXIw4uUYOqX8eKpjzz6qmS09wdHP2Dm2/EGmMZaGVlTSx6BukO+ZqI1SB8duoPO0nXT/OsySgZeaA8aZM+M3iULyo78nGa47mwzwlVQ5rLBoygLM8mQaem6IbR3CKLpzuT239b7ZBucTiFffQjKcRxTY98fKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HQC6r/AI; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HQC6r/AI"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4315eeb2601so64779255e9.2;
        Mon, 11 Nov 2024 17:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731376793; x=1731981593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=c8v4PHWLECGvbJAUU4tXSsbcNs9XiIiR6lHIjzJ5k2M=;
        b=HQC6r/AIePQI5O9jO9+n4qj9V1oRRddoTaC4rEMxc/EC5MsCnPyZ9nwnfeKa6Dn9ik
         PxsnCfJ6jqDjfViP+Q5jC2Qpl3RCkmMu/mmBOq1pklPFpUer3uGM3bss9kpv0Xe50jFN
         8yZ5fjXzyqr7xTIWiS7l5SXP+8/RCp6YevDFov/X6tdWyykU885KEjVkozONNL0jJsO1
         CnBvGI1gc9uI9bDs3CMxvIN+hX57qrk7SGFgY0nJNqYvsD0gxOxgynZMXXiMUNOGPgPR
         eYNdHF2mWvLKy88qiXovvCPcf9jdxSjqKqsOjnWtinhCBAuzQp7acwC2eaqj/Zfj6LvW
         2i+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731376793; x=1731981593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c8v4PHWLECGvbJAUU4tXSsbcNs9XiIiR6lHIjzJ5k2M=;
        b=gXEC3eGopK4reBr6dnhs1N9sw8rGaMcTATp0SZwoZrpEeKdfkHC1xnlVUCXRwIcViC
         5ixYrHUX4QQ9cZcQ25lDWGYROB0TpWXz/cdsmta1K2GxKPMBfr6JGs710t+bzU8qLjIk
         BNaW2ixxWglVz7N4P8UhEiAyXpenBuShJE5lUydX2okEbyLhf088nr01yySOYaOSqYeY
         BoD3nkdWcNJx/A7mnKnCLiJuvofnpmE1xwWei3HIneQO/rbPmv7yAjGfJwRNiVv11utv
         JSD8GxQ1HZXJ+sZXJcwqwdBz4Wr4gFa57PWR9E8ExHf+sPjBHU+sufZ0RKdRFKvOMCqO
         Z+tQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsokzjpBWA8ZFjQ6zoD0h9vjHaz0cfQatmnNnqPcz1hr8wojuSUJFpb87OEPGiCa1JnkNuVjWMys9ABOdb@vger.kernel.org, AJvYcCVXO64Kt9FPDnT4BJEywhEvvaaWxn3FfmoLVzND5GDvgxgtPipYVxmvFIQdelB+bDQ/lpTt603lMwDwoLQt@vger.kernel.org, AJvYcCWTyCQqmNDCXpZCYhLiTzONrhNitoA0DSDNg/PB3zMOKyW4qpzKeqxYd1EFOm94iaQDNyrVPjwOVT73@vger.kernel.org
X-Gm-Message-State: AOJu0YxKg4PB/8yHPFwGTvo9OpbR8Mdkt7w4jiQUAqtIl12qVLC2FYZC
	R5nap0s/q1/cyry4uHBJaw20RaO7jF9snThO3IXHY4X31mlZAD3I
X-Google-Smtp-Source: AGHT+IH/di55KhvyH/nFAQd0By19c/iW/d+gHvodKaUdHseEE4eBVOofeL+t8Uvg4Omb0BJuQIWJWA==
X-Received: by 2002:a05:600c:1396:b0:431:5c3d:1700 with SMTP id 5b1f17b1804b1-432b7518e11mr148469195e9.21.1731376793276;
        Mon, 11 Nov 2024 17:59:53 -0800 (PST)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-432cf2b9fb9sm1783295e9.1.2024.11.11.17.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 17:59:52 -0800 (PST)
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
Subject: [PATCH v7 0/3] crypto: Add EIP-93 crypto engine support
Date: Tue, 12 Nov 2024 02:58:57 +0100
Message-ID: <20241112015920.22564-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This small series add support for the Inside Secure EIP-93.
This is a predecessor of the current supported EIP197. It doesn't
require a firmware but instead it's embedded in the SoC.

First patch extend guard for spinlock_bh.

The other actually implement Documentation and Driver.

The Driver pass all the normal selft test for the supported
algo and also pass the EXTRA test with fuzz_iterations set to 10000.

Changes v7:
- Fix copypaste error in __eip93_hash_init
- Rework import/export to actually export the partial hash
  (we actually unmap DMA on export)
- Rename no_finalize variable to better partial_hash
- Rename 3rd commit title and drop Mediatek from title.
- Add Cover Letter
- Add Reviewed-by to DT commit
(cumulative changes from old series that had changelog in each patch)
Changes v6:
- Add SoC specific compatible
- Add now supported entry for compatible with no user
Changes v5:
- Add Ack tag to guard patch
- Comment out compatible with no current user
- Fix smatch warning (reported by Dan Carpenter)
Changes v4:
- Out of RFC
- Add missing bitfield.h
- Drop useless header
Changes v3:
- Mute warning from Clang about C23
- Fix not inizialized err
- Drop unused variable
- Add SoC compatible with generic one
Changes v2:
- Rename all variables from mtk to eip93
- Move to inside-secure directory
- Check DMA map errors
- Use guard API for spinlock
- Minor improvements to code
- Add guard patch
- Change to better compatible
- Add description for EIP93 models

Christian Marangi (3):
  spinlock: extend guard with spinlock_bh variants
  dt-bindings: crypto: Add Inside Secure SafeXcel EIP-93 crypto engine
  crypto: Add Inside Secure SafeXcel EIP-93 crypto engine support

 .../crypto/inside-secure,safexcel-eip93.yaml  |   67 ++
 MAINTAINERS                                   |    7 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/inside-secure/eip93/Kconfig    |   20 +
 drivers/crypto/inside-secure/eip93/Makefile   |    5 +
 .../crypto/inside-secure/eip93/eip93-aead.c   |  710 ++++++++++++
 .../crypto/inside-secure/eip93/eip93-aead.h   |   38 +
 .../crypto/inside-secure/eip93/eip93-aes.h    |   16 +
 .../crypto/inside-secure/eip93/eip93-cipher.c |  413 +++++++
 .../crypto/inside-secure/eip93/eip93-cipher.h |   60 +
 .../crypto/inside-secure/eip93/eip93-common.c |  823 ++++++++++++++
 .../crypto/inside-secure/eip93/eip93-common.h |   23 +
 .../crypto/inside-secure/eip93/eip93-des.h    |   16 +
 .../crypto/inside-secure/eip93/eip93-hash.c   | 1012 +++++++++++++++++
 .../crypto/inside-secure/eip93/eip93-hash.h   |   78 ++
 .../crypto/inside-secure/eip93/eip93-main.c   |  502 ++++++++
 .../crypto/inside-secure/eip93/eip93-main.h   |  152 +++
 .../crypto/inside-secure/eip93/eip93-regs.h   |  335 ++++++
 include/linux/spinlock.h                      |   13 +
 20 files changed, 4292 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
 create mode 100644 drivers/crypto/inside-secure/eip93/Kconfig
 create mode 100644 drivers/crypto/inside-secure/eip93/Makefile
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-aead.c
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-aead.h
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-aes.h
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-cipher.c
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-cipher.h
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-common.c
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-common.h
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-des.h
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-hash.c
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-hash.h
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-main.c
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-main.h
 create mode 100644 drivers/crypto/inside-secure/eip93/eip93-regs.h

-- 
2.45.2

