Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794488077;
	b=F2tc0LxJajxlc8NwR7z0zZbn1pi2oBKoEDK6D7rHYtbPxmdqRLs7ZRwKn/g1rTU8sypN
	 kLCzM4YCz+yjzkfTAy04xWoljYFMCiW2U6Y+J6nKMuuBPbtNfFLn380ZsVSCzJSeGQGR8
	 1omajCvb9Q3LBYoasLuAhf1zekGaJZ8aJ+xaLhgx6Zy+S++UA5AdvLOLsoNS/iP79Lspi
	 jWRsl6pxavzR5JXI4Gz1wceyCyqQlAuZjWtO+PDEXqc1A4mwwXeARg4FgbAWG74WGVc2l
	 S8GkFHbMBDVUezKt2IyuQzGg2pFMCBP8lIKwQJii5xslaxQ5QP8TJHOx26V5YQvRe2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488077;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=trcQmX+BbAYz38DRWZP+EI6bjRcKKYLCaAy48svB6+g=;
	b=BUBNhfmTUy6SRaMH7Pd7/ih2tt+Lswe4DnXEGKiOh4bUh2pHjrAPg/1jZpujpVHg8ieA
	 G/ysGukSm8zwKVjw2dk6AvBMZ4ctH1Kghg9giWCYIqOy5BM31IyHGNiHOCW/ZbA35Iz3r
	 FKxZ6Orcgethn1m7Md9Spmu6ukRe0EkgjvyGy9oWSYtWeteN3ITGCwhD0xcGMIC5cPeIG
	 hdh8esWfpDnTKdcaBWZzDpfqKhd1hs1mirs3y9btdBWsUyaJYlnqS5Em65Knx6hi54SPc
	 ryYLFpIlYg4NXd+hWX4R2S40dY/bZYGpOhB+F+2IVHw8fDt/TdVqyCxtMIIJZZ+t8dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvpn.net;
	spf=pass smtp.mailfrom=openvpn.com;
	dkim=pass header.d=openvpn.net header.i=@openvpn.net header.a=rsa-sha256 header.s=google header.b=BENPB5id;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B62606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 12:54:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21B62606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvpn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvpn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=openvpn.net header.i=@openvpn.net header.a=rsa-sha256 header.s=google header.b=BENPB5id
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-492690dd5daso3418939f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 04:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvpn.net; s=google; t=1794488075; x=1795092875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=trcQmX+BbAYz38DRWZP+EI6bjRcKKYLCaAy48svB6+g=;
        b=BENPB5idg8kq2/ZFM8OJ0oELpFkoDWcJDfWeAMA4P5kRvuaSgF+ujJGmlVDVE7dxpU
         66hGKufnwvAHXQ093bNPlmu3uhqqNE7UdFdepYLY7fBKCUJXVBdCgcPaNAEAPqBmo+5D
         wLyfOhf+7M3EQubrvZL8D0vA1qXKr6Dzec6liTCJsmg6qAHfGc8yuI0J/iK8jvL0mhg1
         JCdOXSavhNE11/nP2r27RJpPMBjQv9/p9I2oq6k1uUZ3DPsWHkoE0ZBHDm04K2r7iy8P
         ss6EMVZhPVsjSOLZZXXC+7hUSCGRBkf8bX4gCi6IZrA9IcPV6x+Tq2LHL8DBRQ5CVASo
         Cmxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794488075; x=1795092875;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=trcQmX+BbAYz38DRWZP+EI6bjRcKKYLCaAy48svB6+g=;
        b=EKQhGTiPZnU3JSVztKosmfc0vcdGZtIkMXS3dt1d0Hsvyv39JYoLf4BYE8a5cebgbD
         fbZIxIkdI3B6tXP+R7v3m/qDeZv6FRgsXXK9hqfESsY8NAnHrbQdVrKgohiFHUKWW8WP
         OpvstYCOEq/uybRMIKIM4TokL3qfpOWUig93E/m8mk+9sC1KYXNo/V5CD0G6UK63Wgdp
         lAqyhL9I54g89/vCgixlG5IevmO1t0IjHERH+Eu5Uu6fyGsQcNz6BCY7vYGwfmCzX7EL
         lto+EHwGoKymK8aX6Ma40Dn+Sou6HOMbkef5c7mPtm6CB6nqSQfVF14pDdHKxmTjlPAu
         K9Aw==
X-Gm-Message-State: APuU4Z+funSYFzlP8f8k6m6l3Pcr1k7cRdEp7RBN+r3fzp/GZEu4zDKW
	OMG7ml0aOeEX1JAufNC8MAQva6aITK2EI9uJeQgftEi0Qncih6g09ZPbcbE76YjeTn7w/VYyW90
	U3FGia6m4JKe2pWqLnnIVFy/VChLXuYi4EOScF3hJufHQdZVWJmLYHarKFp6out08jwSXVtD9
X-Gm-Gg: AYBFou1wqdznx+oKouuwTZFndb/CxSwaQE81qhdYh2h/P3vBxFCVZXS53ZTWfIXNJD8
	E/rsF/a6TeyK4FoXfF+TTWh3LwUiQrvI1ruEhS+JbRdIQoGDaP8upNH4694UHvlpxEzoj56CT1u
	uA0/ovvc5OvpkpIWPmhfcKimsM39Nq02eTKdUvZiGZ5u233I7MtIWYyR1Tfwe+lBp4W8IG/HVpV
	ltx4qB61NdCmLxriA/9QmLbMHlLpsl0FDdXB51OL2KxfqcUKCwAl7UgWKFYVwM9Kqf3+5AIklMb
	zNF6F7SUWXJAskrXk3V3COevBC9+2MMeTBlbWF+vUf5MGy5xzHN5RCElnQvqGVY5oom3jrUdNGZ
	Wv7m9eE0rTcMvFxIjF42UiPR4sfoTQ0sM4PY0g+JeLS6e/1nQhIGz8kWGO6yQMGxV8ab73nKgao
	dMpfq4/GV1NJtIxtcF1RaWgBms4mXYfZKnmv0d4RIi5mhQHkMBPfS9okIyMr3aFCGZQPohn4xy6
	QcxpenAu/kwO8QVf/UFbd9jh3uHmUnOWMtQ7UomyjzKyybbJhM+/HOPTyVC8kTTjeRnsUwenTZO
	01HZwt0/7RDJsJll3w2MGlGTbTiYJKfGoHCb5md3NpWxrepOVTyGkpjPmQcGNxG3NcuGANRQBA=
	=
X-Received: by 2002:a05:6000:25ee:b0:493:edc3:6659 with SMTP id ffacd0b85a97d-499ca56383dmr8890621f8f.49.1794488075428;
        Thu, 12 Nov 2026 04:54:35 -0800 (PST)
Received: from inifinity.homelan.mandelbit.com ([2001:67c:2fbc:1:56b9:769a:f836:6390])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49835858f26sm17202726f8f.18.2026.11.12.04.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:54:34 -0800 (PST)
From: Antonio Quartulli <antonio@openvpn.net>
To: linux-crypto@vger.kernel.org
Cc: Antonio Quartulli <antonio@mandelbit.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [RFC PATCH 0/5] lib/crypto: Add AEGIS-128X4
Date: Thu, 12 Nov 2026 13:54:25 +0100
Message-ID: <20261112125432.3064939-1-antonio@openvpn.net>
X-Mailer: git-send-email 2.56.0
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

From: Antonio Quartulli <antonio@mandelbit.com>

This series adds AEGIS-128X4, the 4-way parallel variant of AEGIS-128L
specified in RFC 10032 (Informational, September 2026), as a crypto
library with an x86_64 VAES-AVX512 implementation, a KUnit test suite
and benchmark, and a crypto API wrapper.

AEGIS-128X4 runs four AEGIS-128L instances, one per 128-bit lane of a
512-bit vector, so that each state update is eight VAESENC instructions
on zmm registers.  On CPUs with VAES and AVX-512 it is very fast even for
short messages, which is what makes it attractive for network protocols.

The intended user is ovpn, the OpenVPN data channel offload driver. In
single-stream ovpn tests over a 100 Gbit/s link, with both ciphers used
through the crypto API, the sending CPU spent 1266 cycles per packet with
AEGIS-128X4 against 1448 with AES-GCM over TCP, and 1032 against 1122
with UDP GSO input. It is posted as an RFC because ovpn can't use it
yet.

The library mirrors the AES-GCM one: one-shot encryption and decryption,
and an incremental API for nonlinear data.  The generic code keeps the
state in the same layout as the assembly, so the incremental functions
can switch between the two between any two calls, as needed when the FPU
isn't usable.

Encryption throughput from the KUnit benchmark on a Ryzen 9 9950X, in
MB/s:

  data_len   generic   VAES-AVX512
        16        10           581
        64        41          2351
       256       159          8986
      1420       576         34521
      4096       987         46761
     16384      1308         79588

Open questions:

- There is no AVX2 code yet. AEGIS-128X4 can also run with VAES on
  ymm registers, two per state word, which would cover CPUs without
  AVX-512; for now they use the generic code. For the same reason,
  unlike AES-GCM, the AVX-512 code is used on CPUs with
  X86_FEATURE_PREFER_YMM too. Should an AVX2 version be part of this
  series?

- Is the crypto API wrapper (patch 5) wanted? ovpn currently uses the
  crypto API for AES-GCM and ChaCha20-Poly1305 (but it could call the
  library directly).

- The assembly is a port of the libaegis AVX-512 code by Frank Denis
  from C intrinsics; as libaegis is MIT licensed, the file is
  dual-licensed GPL-2.0-only OR MIT and keeps his copyright line.

Patch 1 is independent of the rest: the AEAD test template's check that
decryption clears dst on authentication failure can't fail with its
all-zero plaintext. AES-GCM and AES-CCM pass it with a random one.

Testing: the KUnit suite passes (RFC 10032 test vectors, the shared AEAD
test cases and a Monte Carlo checksum from an independent Python
implementation in gen-aead-testvecs.py) with the VAES-AVX512 code, with
it built in but AVX-512 hidden from the guest, and with the generic code
only. The crypto API self-tests pass with CRYPTO_SELFTESTS_FULL.

Antonio Quartulli (5):
  lib/crypto: tests: Make the AEAD dst clearing check effective
  lib/crypto: aegis128x4: Add AEGIS-128X4 library
  lib/crypto: tests: Add KUnit test suite for AEGIS-128X4
  lib/crypto: x86/aegis128x4: Add VAES-AVX512 optimized code
  crypto: aegis128x4 - Add AEGIS-128X4 AEAD algorithm

 crypto/Kconfig                          |  11 +
 crypto/Makefile                         |   1 +
 crypto/aegis128x4.c                     | 173 ++++++++
 crypto/testmgr.c                        |   7 +
 crypto/testmgr.h                        | 119 ++++++
 include/crypto/aegis128x4.h             | 275 +++++++++++++
 lib/crypto/.kunitconfig                 |   1 +
 lib/crypto/Kconfig                      |  14 +
 lib/crypto/Makefile                     |   9 +
 lib/crypto/aegis128x4.c                 | 509 ++++++++++++++++++++++++
 lib/crypto/tests/Kconfig                |  10 +
 lib/crypto/tests/Makefile               |   1 +
 lib/crypto/tests/aead-test-template.h   |   5 +
 lib/crypto/tests/aegis128x4_kunit.c     | 352 ++++++++++++++++
 lib/crypto/x86/aegis128x4-vaes-avx512.S | 470 ++++++++++++++++++++++
 lib/crypto/x86/aegis128x4.h             | 167 ++++++++
 scripts/crypto/gen-aead-testvecs.py     | 166 +++++++-
 17 files changed, 2284 insertions(+), 6 deletions(-)
 create mode 100644 crypto/aegis128x4.c
 create mode 100644 include/crypto/aegis128x4.h
 create mode 100644 lib/crypto/aegis128x4.c
 create mode 100644 lib/crypto/tests/aegis128x4_kunit.c
 create mode 100644 lib/crypto/x86/aegis128x4-vaes-avx512.S
 create mode 100644 lib/crypto/x86/aegis128x4.h


base-commit: 33b4f31b1aea3f62b61c892daefc0e6a77859032
-- 
2.56.0

