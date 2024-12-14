Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B712383;
	Sat, 14 Dec 2024 13:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734182927; cv=none; b=BZbYqHhwWxNeUq+JgMHF1jUYWMzla4woSzd6enCh89cNw2BQvOdDLhZORa0ibp4tFzFAEx5lLyYp3eML/hJ+lTdwVz5lyD9juX25ZPPC5ZXXawKGPqi7UJhv3tN1HLRVqhJndwlsOsZqV13tNpQ2taiv2wrf63LmABTSt+z3PN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734182927; c=relaxed/simple;
	bh=Wy+U/RXFyyNeT0tzJjPMpTteXWlnAz+YsoOZBCw4Rcc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VbATrH56kkB//a6T2TIjP3ouH4QBIef/LfOFdmKs/ojzEsUbhyhopzhxZyQkjkgu+JEq0CH9RiVyLjFUL/WzrdPKe5/oRv3BQ9ValO9Eg3Dl9Y38q7vEFctOeaz7v5IgXKJMQKi1RkC+ICKHB0YCG17eNyShCYR8CwZQlC/7PLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y5VcCJaE; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y5VcCJaE"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-434a766b475so27534025e9.1;
        Sat, 14 Dec 2024 05:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734182924; x=1734787724; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=HO8HOTr8B5ah55ywq4xCweT5ljEIJFW9Gqnw5M3266I=;
        b=Y5VcCJaEqKACszlhxn3Rj03AxlLe8PLzg4YBKc8gE5icZWN4NIk4cYY2Fv4IA/wO0g
         /fUFvtauFzALoZEMwHdujaL+89jh+6LgRTnXU+zSxKovzeCRA1n+FB6v5lSyVCpSdqza
         rUsU5DW73p/+fyPdluyuFj5Uk0ECig2KDimVysVQMN8yt58bFEeaHpIght2rCFa26cSO
         vcrNacjYh4STEcBx4Z4dwQ5EWWLtTyRMNXJ2ivKmMrofqee1HXXnQiyhTRQr/c2PBM7W
         rezHNjIxgJSwBe3Aj7X9inH5usyz4GNAv4D4SKScpBsWe7p/ifhYbAIz8QC1B22qMx5e
         i8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734182924; x=1734787724;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HO8HOTr8B5ah55ywq4xCweT5ljEIJFW9Gqnw5M3266I=;
        b=RB+5ftmlDq0GXePGWWVX/r2TJjJasgRn7Uj7bSYaSoavqUFPCUrjKKL4xg64Dxqosb
         c+AYblSNpH4+CJbOdu0+dKmAUDx3n28zGXn3NO4njNdu7YSsiTw1WHlWPoMDRRQSkfwq
         SuW9wAu/nrgGPKJlDMJA5uJjN5RlwMlBIeNJWdfuRP1IhoQGgvDpG06RCi7qWMObTJqf
         FOcjcUGWLopFRSyQpjNfm+KyafCnLC0BcX4vr3eqOpF7/Wazyr2Zi3L9vO8bgTZmzjS8
         ZWciiigCY57sa3wC77zefFNzpC3EWwV6fdY6b+28Cn6ln6tFBuUmgIEAWOqCcO8F/x2f
         JuUg==
X-Forwarded-Encrypted: i=1; AJvYcCW3aewgcfSu4wRL41/LkmwRt44J0fCi34e+D2uNxKBSBSYF5qVcOEaN1YMupxtZ3H1ha68EKHRb/oXGbL01@vger.kernel.org, AJvYcCXVBU66vlHA7qyi5FCkt3uiX25ZIcw2nKnhhGMWnIrvJLprmFrFF7VHpd2FO+tGoKby0dcYJJaHVun8wEiu@vger.kernel.org, AJvYcCXnW5d6nFWlf4nvCzXaq3h1oZJPutd6tqIQwG+8SPjcvc5IUnx3pWaAVCmYKls6LOuRv4VYiqOYqTAH@vger.kernel.org
X-Gm-Message-State: AOJu0YzfeumACpTlIQPByT5MJaeDf00eIa77uGGS4llBrt1xkDp348jq
	1lsXe8rWPB60HHazs11h+/ZOWc/sDXsvP4RwbhedExPZV4yOLxaNc5+ktA==
X-Gm-Gg: ASbGnct7/wo+wrMsilzImRDp+CQQl5EvyjtZKw85C4mhuSmGYMh1nBo72od8fZt6BsD
	zFLr0LUsPx+aK3ENrJ0ycojBCXXtAco4dQFnsd4UWQlmgrK4y1F9T5t1biTKrF74YZEwE4Q6Ube
	QHV+Q0HRnoqsU7yvKpuTUG4SBauEJMJNRYOB3cdLWxuvoELxpuWfT07KX5IMGWYX0d264Do5TJ7
	KhGJfqX4vj+4tcDDHQbgM6FUfcqEF9+Q6y8BtF6s6eAjN5m7npqAUwRWUOl5BvtUsKxmR0v6MK6
	lYKX4uENxZmZ2DtBchdxz4DxCg==
X-Google-Smtp-Source: AGHT+IFJVjWIIB5s39gUx1SvdqqGCesjab1llC/QPC5s1Cw1w7UwSrqeg1+KD36txuQBShLxIST56w==
X-Received: by 2002:a05:6000:4b0c:b0:385:fd07:8616 with SMTP id ffacd0b85a97d-3886c7252f4mr5918505f8f.0.1734182923380;
        Sat, 14 Dec 2024 05:28:43 -0800 (PST)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-388c80162a6sm2559850f8f.33.2024.12.14.05.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2024 05:28:43 -0800 (PST)
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
Subject: [PATCH v9 0/3] crypto: Add EIP-93 crypto engine support
Date: Sat, 14 Dec 2024 14:27:51 +0100
Message-ID: <20241214132808.19449-1-ansuelsmth@gmail.com>
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

Changes v9:
- Rework hash code to alloc DMA only when needed
- Rework hash code to only alloc needed blocks and use
  local struct in req for everything else
- Rework hash code to use GFP_ATOMIC
- Simplify hash update function
- Generalize hmac key set function
Changes v8:
- Rework export and update to not sleep on exporting state
  (consume pending packet in update and return -EINPROGRESS)
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

 .../crypto/inside-secure,safexcel-eip93.yaml  |  67 ++
 MAINTAINERS                                   |   7 +
 drivers/crypto/Kconfig                        |   1 +
 drivers/crypto/Makefile                       |   1 +
 drivers/crypto/inside-secure/eip93/Kconfig    |  20 +
 drivers/crypto/inside-secure/eip93/Makefile   |   5 +
 .../crypto/inside-secure/eip93/eip93-aead.c   | 711 ++++++++++++++
 .../crypto/inside-secure/eip93/eip93-aead.h   |  38 +
 .../crypto/inside-secure/eip93/eip93-aes.h    |  16 +
 .../crypto/inside-secure/eip93/eip93-cipher.c | 413 +++++++++
 .../crypto/inside-secure/eip93/eip93-cipher.h |  60 ++
 .../crypto/inside-secure/eip93/eip93-common.c | 816 +++++++++++++++++
 .../crypto/inside-secure/eip93/eip93-common.h |  24 +
 .../crypto/inside-secure/eip93/eip93-des.h    |  16 +
 .../crypto/inside-secure/eip93/eip93-hash.c   | 866 ++++++++++++++++++
 .../crypto/inside-secure/eip93/eip93-hash.h   |  82 ++
 .../crypto/inside-secure/eip93/eip93-main.c   | 502 ++++++++++
 .../crypto/inside-secure/eip93/eip93-main.h   | 152 +++
 .../crypto/inside-secure/eip93/eip93-regs.h   | 335 +++++++
 include/linux/spinlock.h                      |  13 +
 20 files changed, 4145 insertions(+)
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

