Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76341531C2
	for <linux-crypto@vger.kernel.org>; Mon, 16 Dec 2024 16:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734366859; cv=none; b=ftn9oom+/+KotN5M70exqpyzOfS8ZVlxgmH9dZ5EEIKfPvQb+4q3aGu1rl1cuAHbJmUKs+psk4K32saYTXOuyGvjevtjY6P2yY+aFryFmz9CQviCok8pAjUCYgTcC8jjF+QWGpFsrySO/ivRC+iM1dilkNmEw8R86oLVgNm3KNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734366859; c=relaxed/simple;
	bh=J4P8Yn+HmBStOiyf7871d8RgqIDPsmAX5U/1I64nh6s=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=bV6sPy1D6q/9vue8NjBKHQKvlV2gCbZ6JXlSEPA2oe7mCYV3+SbM+98YCU2B3SB3queYUebpO1wbmsB6anhHp5gXdBdLXDcqlONGJSx3L0BhbFuGm/TyEnd+flLsfAnh+hLd6bbB1eGp6G6h0EUr0pO0DU+dJVFVJZRdd6RdIPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zfvVBaRJ; arc=none smtp.client-ip=209.85.217.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zfvVBaRJ"
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-4afd56903b7so1065833137.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Dec 2024 08:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734366856; x=1734971656; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=voYB97BSoIttk6TNFpCBTpCkCub3HvTPki1P0fPd0XM=;
        b=zfvVBaRJstSDeEl6+GGDGWKT7hTJEbATEo/tkaPmkiCLuPcOzAbSbwcOOQzU1uzDiD
         LfM1dOCRdZqxTEarx4oY6QcHoy0uEjaehokOpQ3zKkftBAZqbEWPF+DB0VGyzq1q/gQi
         ym+sONUkGeV3dg2LmeAdjHRwcJ0WKg5IeO4NhL6JsbVvD8CBPLAwI1QMFazzcUHHdCnh
         BnUF5L1SLxlRuUhM8n+LcVS5yrjBhmNRUYgdsd+1RRFj5I/FcGFgesLwZHbCxaxa+HzD
         Ykp3r5eqQBs0BQ6sYqRe6Mc3QCXN3D81WsPVp3cMztd1ysLBbxz1KN4qifypofSFEOx4
         Uzdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734366856; x=1734971656;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=voYB97BSoIttk6TNFpCBTpCkCub3HvTPki1P0fPd0XM=;
        b=h7tNO9jkzsHIDtAKHKwmRZjPUkf+RL+azpfjSoQPzBM+plhaLuVMOC8kiktt7QKQsc
         pqDqX9h0Xny66JHYsr1z7dyUjMYY8MmzTtKukf5tBPUERzSDOn+OqZ4K5D++PAgLbnmb
         6xjif6fkg/CWXNWUYtN8RhH+NCVnvviZWfhibiOqOj/faiVLqhU/Mm2O3jmGo52Kw8uQ
         xDQqEM+q7AUvTyRWQbSQsL5xwwGvQRf7LMsthzbADM+Re2You8NR8JrzVe6DzTV4lMN5
         MpkdP8M2yon9+Dmsggwy7WZTpAkrWN/mNHWFRd4iwD8dhDQGGR45e3eUlRK84wrWm9z3
         SVcQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8d3csISsJebloIB2LZdhaM8JHlfnWx+Rdsz3gsC0NGJ8WdaJuUfXNhttCxRL7+QDhQFEBZxQLp1Jsb5o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwLOs6UzUZc+YcNqsoqSpllxnn5V4gan/5WN6AYiqBRQrecoTK
	Ngp/HpJCtRvvWs61n15jFUugQynqPhbAprenNa04Q0zaCOsVK0AVBa0Ykzc5ndgT8ZXRZt0IA7O
	cbHChWrUZNX+w3NPELhezzaQS9u2mprJvGHTv+A==
X-Gm-Gg: ASbGncvqT+muU3x2qXZ4Vpubq3LKFhfjN6kA7nC0IcOoIGtPKTRtX/DsEFH6Rrr/yAc
	H6HhHq56RgZUeKKClyWy5eDCjYQDhYHcDW+QOpiDbAzp7n2ek/PyY2gIwFQ1p3OpJ5e9B7eo=
X-Google-Smtp-Source: AGHT+IHwcIqoyILkP+1sx25KZjFSaAGwKZBXcw1KXTOsA6DOwlBCczCOTJUK1dfVqLl4hiOpY/+Ngz4hZael7fpPyHY=
X-Received: by 2002:a05:6122:1e01:b0:516:18cd:c1fc with SMTP id
 71dfb90a1353d-518ca30617amr12733009e0c.8.1734366856629; Mon, 16 Dec 2024
 08:34:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 16 Dec 2024 22:04:05 +0530
Message-ID: <CA+G9fYtpAwXa5mUQ5O7vDLK2xN4t-kJoxgUe1ZFRT=AGqmLSRA@mail.gmail.com>
Subject: next-20241216: drivers/crypto/qce/sha.c:365:3: error: cannot jump
 from this goto statement to its label
To: open list <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>, clang-built-linux <llvm@lists.linux.dev>
Cc: thara gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

The arm and arm64 builds failed on Linux next-20241216 due to following
build warnings / errors with clang-19 and clang-nightly toolchain.
Whereas the gcc-13 builds pass.

arm, arm64:
  * build/clang-19-defconfig
  * build/clang-nightly-defconfig

First seen on Linux next-20241216.
  Good: next-20241216
  Bad:  next-20241213

Build log:
-----------
fs/netfs/read_retry.c:235:20: warning: variable 'subreq' is
uninitialized when used here [-Wuninitialized]
  235 |         if (list_is_last(&subreq->rreq_link, &stream->subrequests))
      |                           ^~~~~~
fs/netfs/read_retry.c:28:36: note: initialize the variable 'subreq' to
silence this warning
   28 |         struct netfs_io_subrequest *subreq;
      |                                           ^
      |                                            = NULL
1 warning generated.
drivers/crypto/qce/sha.c:365:3: error: cannot jump from this goto
statement to its label
  365 |                 goto err_free_ahash;
      |                 ^
drivers/crypto/qce/sha.c:373:6: note: jump bypasses initialization of
variable with __attribute__((cleanup))
  373 |         u8 *buf __free(kfree) = kzalloc(keylen + QCE_MAX_ALIGN_SIZE,
      |             ^
1 error generated.

Links:
-------
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20241216/testrun/26350650/suite/build/test/clang-19-defconfig/log
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20241216/testrun/26350650/suite/build/test/clang-19-defconfig/history/
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20241216/testrun/26351207/suite/build/test/clang-19-defconfig/details/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2qHsa6j5c1HY3GRZFGrxu2ELo3f/

Steps to reproduce:
------------
# tuxmake --runtime podman --target-arch arm64 --toolchain clang-19
--kconfig defconfig LLVM=1 LLVM_IAS=1

metadata:
----
  git describe: next-20241216
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
  git sha: e25c8d66f6786300b680866c0e0139981273feba
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2qHsa8wFmfrlj0VdDqAG408o3l2/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2qHsa8wFmfrlj0VdDqAG408o3l2/
  toolchain: clang-19
  config: clang-19-defconfig
  arch: arm64, arm

 --
Linaro LKFT
https://lkft.linaro.org
