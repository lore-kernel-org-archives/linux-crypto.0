Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB1422B597;
	Tue, 10 Dec 2024 20:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733863764; cv=none; b=CNzNnD+CngYv/DSH0bN0MUAnE88OxXj8vZMZLunYuOAcGJd4i1eHFTCk+Kducenb/tVGQ5kbXiZl9bFLxwCZRvpng0YROnnnhGvtKtd4/z6YzMrjaVqVazGDfzAe2IlePLlZUo2ZPO4FAjtnxlquhc8wGnsyD8ifUrxVinccuSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733863764; c=relaxed/simple;
	bh=OLTPVYyc/7nlCM5FPxXemPRns+bgGCcQnKZHAGRTsMA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=t9VRITUCYGvKNHVwyP96AtkfHXYoXafmmWjm8VE0pUIhnKYNcbeQhOl42bTPYcGI5QViqkOtBmnobv03Z9Fqee1W5o28xBJ0UEdH48bBXGtDW4d47aRHmAzXQXxACa7ElPm6GoR22DQL+P0GT57Kb8goH97bSGWCaIxnE/d84wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jZUMg/U1; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jZUMg/U1"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3862b40a6e0so2662895f8f.0;
        Tue, 10 Dec 2024 12:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733863761; x=1734468561; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Jg5mU2JMtNTWEE8J9PA490rUld5BDirou6U7dgBSKuk=;
        b=jZUMg/U1vsiNSQuJOjeBb+sknSpZjFZAXjs2RMHNTieBMQpvqs0Sj0EvKY7FCydIZJ
         I7fySqgz7lsN07BpZAWScosTREF1x1eO4jMLO0YhcyPed2LpbTbq1SCq0IjCikTT61aD
         k6UnDY+dt12FeZ5qUFBsLQZq5YG6Y5oYb6S4lzgVH3AXChkn/c/Ygm1TkO0a+JYQjddd
         Fejz/G5Ar3LpEbs4EBm859NDaoATG7W+2Q77jY5U7tJqjTf/YocZEhZIi+gto37QTRq6
         jk2rsugxoktMGW83F5NDNQfGv0sCHFdVa/ckb1DLpf4DP2NqS8VQHfeb7KFhNhAhYvnn
         6rVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733863761; x=1734468561;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jg5mU2JMtNTWEE8J9PA490rUld5BDirou6U7dgBSKuk=;
        b=DA8Sq3MsztlQvaacL8HXZ1eiqnPS+AIUIGGg4jSeqWxIqHUaYB0m1R2tayYMhKW6BS
         OiXqBxcXkDwkx5Y/2ZkKF9bVf7urxOZjNAKAidhK0GoXrysY3gGSXehOo0oODapOI+QE
         1DdwZntRAdRpzeLd64Ys4ReTr7Tc8rqueM4hcTaxXhN4FawTTiPPxmgA8YypF9IhHIlQ
         1EKHieU2guuIxP14JbRGKJ7CWX46I39nH8im+WPahhdW9PoltLYUr3LCCJWPbae7RYpy
         7zcrdi9JCfyCDVDGcNC9CF9Gmbxqw9dp5AKOU/UmHQA/oohZLzAu4yydMLQSXhBJidOp
         AqhA==
X-Forwarded-Encrypted: i=1; AJvYcCV6y7t+PXES5lFWQzTWPekVoFcuoBpkXDjFrHZcXTOs/ZHwv6f0+tjSQ1YkUyT4h5I/tg/k3ZCHIpNgADTg@vger.kernel.org, AJvYcCW9gcj+6sMnJ+fnCZRR+PIYd8pcolNTk1vUqMfS3JKkFga9LSqtYQcN3ywaTUslxloM15K16s0r28Dj@vger.kernel.org, AJvYcCXsqx3M72ZuAkc1MmNj07kU/lsOlrYNNRgMWdLV7dM/iTLQlBlgwbqm6IsepktS62JfgRdS0EHKAfogBwP+@vger.kernel.org
X-Gm-Message-State: AOJu0YyP8OVNmBeTPBf314Mi+9T+VAwPUjLe2o9cNuEus2gyN9HCP9to
	jryr1hN45IlvT+t2uA6JGtnPLnAaCZP1+dQvivlVZjCA6Wj2voFq
X-Gm-Gg: ASbGncvaGbQPks0SxrVrp1IGUaVqnymQpwo2s5Tcl7AsL+0F6o+JBOA8LErK3S07B9Z
	46R0zkQ/w67gTXGeoev+sYFU6XJV6sgRSqu9adHR5As8Pf1EpU13WZMHhNmuksfdLvdRQCLmmtM
	SQOzZzK46fax9BKaCXzTxP2jWVIZK1qoXW6HAAmAaMOUoOFUigeJsdsVqHq2ScJLrA3AI2ezDgq
	LDDxTS/lbTUmqdr3pIKVSB/XsdQQBv7gCewP5ewYsHvDWu2iKe5VL9hY7JHjC3TcU3ulpo/7nY/
	hKU/0PaDpk/BDHTfmBvHJDQ=
X-Google-Smtp-Source: AGHT+IFdGKcgUx09Wfb/ixJSF3YMDPcdaSeYAbxmPfqXTo/jaPabL7YpzhSY2394DQYnDqVsbDBPcg==
X-Received: by 2002:a05:6000:1f82:b0:385:f56c:d90a with SMTP id ffacd0b85a97d-3864ced1f55mr354339f8f.55.1733863760924;
        Tue, 10 Dec 2024 12:49:20 -0800 (PST)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-386334d0486sm11808307f8f.50.2024.12.10.12.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 12:49:19 -0800 (PST)
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
Subject: [PATCH v8 0/3] crypto: Add EIP-93 crypto engine support
Date: Tue, 10 Dec 2024 21:48:30 +0100
Message-ID: <20241210204853.18765-1-ansuelsmth@gmail.com>
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
 .../crypto/inside-secure/eip93/eip93-aead.c   | 710 +++++++++++++
 .../crypto/inside-secure/eip93/eip93-aead.h   |  38 +
 .../crypto/inside-secure/eip93/eip93-aes.h    |  16 +
 .../crypto/inside-secure/eip93/eip93-cipher.c | 413 ++++++++
 .../crypto/inside-secure/eip93/eip93-cipher.h |  60 ++
 .../crypto/inside-secure/eip93/eip93-common.c | 822 +++++++++++++++
 .../crypto/inside-secure/eip93/eip93-common.h |  23 +
 .../crypto/inside-secure/eip93/eip93-des.h    |  16 +
 .../crypto/inside-secure/eip93/eip93-hash.c   | 987 ++++++++++++++++++
 .../crypto/inside-secure/eip93/eip93-hash.h   |  77 ++
 .../crypto/inside-secure/eip93/eip93-main.c   | 502 +++++++++
 .../crypto/inside-secure/eip93/eip93-main.h   | 152 +++
 .../crypto/inside-secure/eip93/eip93-regs.h   | 335 ++++++
 include/linux/spinlock.h                      |  13 +
 20 files changed, 4265 insertions(+)
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

