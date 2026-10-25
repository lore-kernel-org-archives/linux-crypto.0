Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792972098;
	b=K9TshBUI0vmutBojIphHFLfpS0rWzUXSH8lbHLjb6FE9/6pViqezdnKVzdPiHEasw/wK
	 t5XmOecI8U9LfgdrR8kqrFzm28eAbtqOJhKSpiJoKOlHUGV3qMmZOyWnfCFJLYnWPUpVh
	 fPAydj9VfTa9Dib/xrbdt87Hn92YhNj8+Yn10xd6KYv9L0JY+O5vFe0llO0Zw4TC0xA3u
	 sMFPAwZTs1l+9tVZ+dMLVN6Yy7Ftfpt8PMkWpE0zZhHpkrW2lQyHFcQbPHPzh2uLE79WM
	 b4OWoOuc3Msw0xiQvQTIG/WaZeO+zLtGmLB2Xy3nEHsmfkQ9O1LKZYlXrfjAayM7HBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792972098;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=FiQEWvS3B2xCrzNDlQOd1LW5c1tre05LfYV4xTUsYmQ=;
	b=3L2pj2/NY/5O7L8aplBEV1MGoiR0cPEWT3iZsnMejbkO0eMjC9Y9Z/gAW4iA3qthicXW
	 iwVeNH8TLNX1+5zCYV4+hIVy1JgHQUOD+XA48QS2oBxFTLFH98Toi8bnjjBHXi5gBof+T
	 BBs51tJL1bYG1bUBBhXIX+W1oc6FbaZabeUzC+aM4LugfxVDZmXgKsBn2VRp63YJv0fVW
	 Y9zBOjHOrR9eYklbjT2+n6kigui3Wgl/iEyqn3Ztt7K+Kh6gN/wlW5xR0UsLWkATrYsXh
	 D3lT2Zxwcg0jDYtZjAi/vJ0pYF8DQYM2W9vCvtOAfUTC+kuRFkWl5YNPFCd9YdUR0xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=IU1tcXDX;
	arc=none smtp.remote-ip=195.10.208.52
Received: from mout-b-203.mailbox.org (mout-b-203.mailbox.org [195.10.208.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CAB606A31A;
	Sun, 25 Oct 2026 23:48:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81CAB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=IU1tcXDX
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-b-203.mailbox.org (Postfix) with ESMTPS id 4jCYNS4NYnzLm3c;
	Mon, 26 Oct 2026 00:48:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1792972088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FiQEWvS3B2xCrzNDlQOd1LW5c1tre05LfYV4xTUsYmQ=;
	b=IU1tcXDXOQzJdlaYuanL6JZ+g5E0hqpmhKvr+Wp/2RHxx1IRGvmhBNY2ReFHmNx6hIoiOp
	VXLRvhu4lrOLVN1PPZghAN2NyJtNoCpSPVyLlIE6GM9Ucnpw3M52wuiRtTyyZtg0p+r1ln
	adworJTrJjzknNC6ThgrG/+2NYIdefUIVPswUyhj+tiaVossg+/RmD3TUm97orE4TD6lMN
	TRdZzFEkrX3oB9Q7PgcKXY77bSx/akVwyiuNFUgMYPP2gl4hXxwuGcoeLZtJGpS0yD7/Ny
	lS0aLRJsd8IJHcD2a55j/l277NHQo3BY+EzcBv6XaxiTHFaeFq2Pt+aM14CKaQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
From: Antonio Quartulli <antonio@mandelbit.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Antonio Quartulli <antonio@mandelbit.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] lib/crypto: x86/chacha: Add 16-block AVX-512 implementation
Date: Mon, 26 Oct 2026 00:47:53 +0100
Message-ID: <20261025234758.3219829-1-antonio@mandelbit.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4jCYNS4NYnzLm3c

Hi all,

this series adds a 16-block ChaCha implementation for x86 using 512-bit
registers. It is preceded by a KUnit suite and benchmark for
chacha_crypt(), as lib/crypto has none for plain ChaCha yet.

Patch 1 stands on its own and passes with and without patch 2.

On AMD Zen 5, the new code doubles chacha_crypt() throughput for inputs
of 1 KiB and more, from about 5.2 GB/s to about 10.2 GB/s. It came out
of work on the OpenVPN data channel offload driver (ovpn), whose
ChaCha20-Poly1305 throughput is CPU-bound: in a VM benchmark it gained
about 10% at a 1500-byte MTU and 35% at 9000.

iPlease note that I could only measure Zen 5.
The new code is not used on the CPUs setting X86_FEATURE_PREFER_YMM
(Skylake-X, Ice Lake and Tiger Lake), but it is on
Rocket Lake, Sapphire Rapids and later, and on Zen 4, where 512-bit
operations are split into two halves. Numbers from any of those would be
very welcome.

Regards,
	Antonio

Antonio Quartulli (2):
  lib/crypto: tests: Add KUnit tests and benchmark for ChaCha
  lib/crypto: x86/chacha: Add 16-block AVX-512 (zmm) implementation

 lib/crypto/.kunitconfig                 |   1 +
 lib/crypto/tests/Kconfig                |   8 +
 lib/crypto/tests/Makefile               |   1 +
 lib/crypto/tests/chacha_kunit.c         | 269 +++++++++++++++
 lib/crypto/x86/chacha-avx512vl-x86_64.S | 413 +++++++++++++++++++++++-
 lib/crypto/x86/chacha.h                 |  29 +-
 6 files changed, 719 insertions(+), 2 deletions(-)
 create mode 100644 lib/crypto/tests/chacha_kunit.c


base-commit: 20ec6916d8712e84d58e8c688a25cd368ddeb82b
-- 
2.55.0

