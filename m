Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C1923EA95
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 14:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764857586; cv=none; b=rWO9hq39JofQn7VMcJd/+h8a81L/L+0+m89uCiDcdfo04YUUzHFi8ekvE8ExiCDkLSoSFoNiQxWggNWjYND5h+dJ9egWNsed70BrV8nE2MyxJ5RXqNKG9+aCb7bckfwq4AQYacvDV7LpEV114w0y2khcpMgPm3PEhcO+4v56YXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764857586; c=relaxed/simple;
	bh=60mCOG4B43H2x5ykMTXSFlPxfaZL2RVUriyiY5vJQWw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FzIhxQcAS5q8puHo1QDdA/1FnOMcpWZ3fEVYVCXRPwqySWGyaErXeNg6/YimF9vNUOPL84eUclbtkUNZaOyAWCD0OD0088Ro/sV6GqBPwpavj00xkIpYJb/c/g0Lnfrk0ru4S8uDgArpGO/bmdgehZmQPpGmPSFO8QCYoU4y33o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lQVeKH0S; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQVeKH0S"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4775ae5684fso5322335e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 06:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857582; x=1765462382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zml3KS+UsrvHkR8m+pYaf5EprirpHcFq08V4fzn955Y=;
        b=lQVeKH0Sk7ddbWW8hJlyOieIWzuQEy5mUyu/CsOX3yRncgzN3NXN0Io1NItkCcThpc
         vl4odVm/ErdCrfbEJLXpx5SEj9kVQ1pGrd3aljbmGgiAuQMnw+BDcEWhmQBzDSQd7X/c
         M1Lxzmbf952DfBtwWuZsPYAOGAfytb2I5gntNTLTEofJ9EioQMsXDZrJXHYe2V7Df/ic
         +X1WCJ5qovwtaY0k0Wl1tHlGZ8yXyYaBWPBf9YJ18qlghQ4Nw/UzbwEmp1D5c0z+m9Qk
         Sl5xAI3qYzsKH8+YnI8GUeOZFLuL+GA00bBnqHedycVO98ha9stwWBrC1Jt0EU4iQ1Mg
         A5lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857582; x=1765462382;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zml3KS+UsrvHkR8m+pYaf5EprirpHcFq08V4fzn955Y=;
        b=qKyKviDS8Rq4dR4gLevFb7o7KkFBPfip+t9xNMP5S/oxbnhj2Q/LUQUS1q5aQ1o9zp
         IlGVw9/Sjk06x/bw0By4EzHB7M6iuBlxUAS4XZZmlWBNXgrPoHGGN+xaXktxH8rRllP1
         7CCfVV/NOi3Z7Td4rq7Wwvw3lvwLe4ibp5IRbAdi3dvXI/oFYcnUuORJ/6d7+L62sUIM
         cxg61CF7Tflg1IPgTAH2UU4MXAkAEdJRZTzRKqky2Twm0PQJ0S1BMB6WrEtqUQvOgqcL
         lsr8QZ5/8WiaqSf0WPG07SY63LDlFaNz1NFXiXOQ9kG94YIhsWOkdhzzEU27UR2A7W25
         a/Dw==
X-Forwarded-Encrypted: i=1; AJvYcCWUcSk9wv7LysPz8T6B8hOBmK9q31NCXQhTi2NtX4IUUEZHzSDaRbvP7RfwHQBucu88uJuB6cuhtSyf69Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0wif+7DFzCaDg4qbebciYI8VjO/5fr/WZ2sbRKYPNjBhv7Vju
	9NO3vqWBIwejDjxY3168QeFMbR971Zqsaasxs0rkdcqsJZuGb/DaGB+D
X-Gm-Gg: ASbGncvTJi1FTVZT98QupdV09i+C92EhzRkFpjJ7COUnlEM2hPhGpioxI5OCtioPH+2
	t9+2hA8rx1wppl7GM8b+4iVKuCc4CTqh645i9P+RUCyqxcFmHJfqT4L8ciSTpAM5uYpt2y41lmK
	JSwmcj8YzUGAWHk8UP3ZA5zAw11B7Ljun9gE/J4eZYqzXpMs9kHisLAocnoS6oztWPXpQsor65H
	KWTCyfDTWV2kCQloVPgeNGZP7QTBMftIoSyBLzBVgYxeaEy2ZoQV9r0LPhDeCTHtbdphCVhuW7/
	TX65m12vXPXux3vj4NikvApIVLXXf6M2Q6jyrgKSAQGQY98QpyO8SnMKsANsmzZobZ2ZV7MdcBH
	rOVvh+tBQmb/iqb/jv731o2ewHmBMoivlB3LmZ/UZBOlAr9gM15N3zvr0C/3Fsf55iLz34Iyca3
	IAZDcV/BvDr+a6eqQcX19CsTnuihVKQ2QIs6fA6g8jD2TFXSMjEb3dY7UGFjf3nb9faA==
X-Google-Smtp-Source: AGHT+IFIh69RdA1vnCTw0PcitJb0iveYoA93ksIeD56K8ycLMTPv0k8+6CuwPbzV5nMxBZQhq5bF+A==
X-Received: by 2002:a05:6000:2507:b0:42b:3e0a:64af with SMTP id ffacd0b85a97d-42f7317205bmr6670197f8f.11.1764857582226;
        Thu, 04 Dec 2025 06:13:02 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:01 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	tarasmadan@google.com
Subject: [PATCH v3 00/10] KFuzzTest: a new kernel fuzzing framework
Date: Thu,  4 Dec 2025 15:12:39 +0100
Message-ID: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series introduces KFuzzTest, a lightweight framework for
creating in-kernel fuzz targets for internal kernel functions.

The primary motivation for KFuzzTest is to simplify the fuzzing of
low-level, relatively stateless functions (e.g., data parsers, format
converters) that are difficult to exercise effectively from the syscall
boundary. It is intended for in-situ fuzzing of kernel code without
requiring that it be built as a separate userspace library or that its
dependencies be stubbed out. Using a simple macro-based API, developers
can add a new fuzz target with minimal boilerplate code.

The core design consists of three main parts:
1. The `FUZZ_TEST(name, struct_type)` and `FUZZ_TEST_SIMPLE(name)`
   macros that allow developers to easily define a fuzz test.
2. A binary input format that allows a userspace fuzzer to serialize
   complex, pointer-rich C structures into a single buffer.
3. Metadata for test targets, constraints, and annotations, which is
   emitted into dedicated ELF sections to allow for discovery and
   inspection by userspace tools. These are found in
   ".kfuzztest_{targets, constraints, annotations}".

As of September 2025, syzkaller supports KFuzzTest targets out of the
box, and without requiring any hand-written descriptions - the fuzz
target and its constraints + annotations are the sole source of truth.

To validate the framework's end-to-end effectiveness, we performed an
experiment by manually introducing an off-by-one buffer over-read into
pkcs7_parse_message, like so:

- ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
+ ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);

A syzkaller instance fuzzing the new test_pkcs7_parse_message target
introduced in patch 7 successfully triggered the bug inside of
asn1_ber_decoder in under 30 seconds from a cold start. Similar
experiments on the other new fuzz targets (patches 8-9) also
successfully identified injected bugs, proving that KFuzzTest is
effective when paired with a coverage-guided fuzzing engine.


The patch series is structured as follows:
- Patch 1 adds and exposes kasan_poison_range for poisoning memory
  ranges with an unaligned start address and KASAN_GRANULE_SIZE aligned
  end address.
- Patch 2 introduces the core KFuzzTest API and data structures.
- Patch 3 introduces the FUZZ_TEST_SIMPLE API for blob-based fuzzing.
- Patch 4 adds the runtime implementation for the framework.
- Patch 5 adds a tool for sending structured inputs into a fuzz target.
- Patch 6 adds documentation.
- Patch 7 provides sample fuzz targets.
- Patch 8 defines fuzz targets for several functions in /crypto.
- Patch 9 defines a fuzz target for parse_xy in /drivers/auxdisplay.
- Patch 10 adds maintainer information for KFuzzTest.

Changes since PR v2:
- Introduce the FUZZ_TEST_SIMPLE macro (patch 3) for blob-based fuzzing,
  and update the module code (now patch 4) to initialize an input_simple
  debugfs file for such targets. While not explicitly requested by
  Johannes Berg, this was developed to address his concerns of the
  serialization format representing a hard barrier for entry.
- Update the crypto/ fuzz targets to use the FUZZ_TEST_SIMPLE macro.
- Per feedback from Kees Cook, the fuzz target for binfmt_load_script
  (previously patch 9/10) has been dropped as it is trivial to fuzz from
  userspace and therefore not a good example of KFuzzTest in action.
- Per feedback from Andrey Konovalov, introduce some WARN_ONs and remove
  redundant checks from kasan_poison_range.
- Per feedback from Andrey Konovalov, move kasan_poison_range's
  implementation into mm/kasan/common.c so that it is built with HW_TAGS
  mode enabled.
- Per feedback from Andy Shevchenko and Lukas Wunner, address the build
  system concerns.

Ethan Graham (10):
  mm/kasan: implement kasan_poison_range
  kfuzztest: add user-facing API and data structures
  kfuzztest: introduce the FUZZ_TEST_SIMPLE macro
  kfuzztest: implement core module and input processing
  tools: add kfuzztest-bridge utility
  kfuzztest: add ReST documentation
  kfuzztest: add KFuzzTest sample fuzz targets
  crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
  drivers/auxdisplay: add a KFuzzTest for parse_xy()
  MAINTAINERS: add maintainer information for KFuzzTest

 Documentation/dev-tools/index.rst             |   1 +
 Documentation/dev-tools/kfuzztest.rst         | 491 +++++++++++++++
 MAINTAINERS                                   |   8 +
 crypto/asymmetric_keys/Makefile               |   2 +
 crypto/asymmetric_keys/tests/Makefile         |   4 +
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    |  17 +
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  |  20 +
 drivers/auxdisplay/Makefile                   |   3 +
 drivers/auxdisplay/tests/charlcd_kfuzz.c      |  22 +
 include/asm-generic/vmlinux.lds.h             |  26 +-
 include/linux/kasan.h                         |  11 +
 include/linux/kfuzztest.h                     | 573 ++++++++++++++++++
 lib/Kconfig.debug                             |   1 +
 lib/Makefile                                  |   2 +
 lib/kfuzztest/Kconfig                         |  20 +
 lib/kfuzztest/Makefile                        |   4 +
 lib/kfuzztest/main.c                          | 278 +++++++++
 lib/kfuzztest/parse.c                         | 236 ++++++++
 mm/kasan/common.c                             |  37 ++
 samples/Kconfig                               |   7 +
 samples/Makefile                              |   1 +
 samples/kfuzztest/Makefile                    |   3 +
 samples/kfuzztest/overflow_on_nested_buffer.c |  71 +++
 samples/kfuzztest/underflow_on_buffer.c       |  51 ++
 tools/Makefile                                |  18 +-
 tools/testing/kfuzztest-bridge/.gitignore     |   2 +
 tools/testing/kfuzztest-bridge/Build          |   6 +
 tools/testing/kfuzztest-bridge/Makefile       |  49 ++
 tools/testing/kfuzztest-bridge/bridge.c       | 115 ++++
 tools/testing/kfuzztest-bridge/byte_buffer.c  |  85 +++
 tools/testing/kfuzztest-bridge/byte_buffer.h  |  31 +
 tools/testing/kfuzztest-bridge/encoder.c      | 390 ++++++++++++
 tools/testing/kfuzztest-bridge/encoder.h      |  16 +
 tools/testing/kfuzztest-bridge/input_lexer.c  | 256 ++++++++
 tools/testing/kfuzztest-bridge/input_lexer.h  |  58 ++
 tools/testing/kfuzztest-bridge/input_parser.c | 425 +++++++++++++
 tools/testing/kfuzztest-bridge/input_parser.h |  82 +++
 .../testing/kfuzztest-bridge/kfuzztest-bridge | Bin 0 -> 911160 bytes
 tools/testing/kfuzztest-bridge/rand_stream.c  |  77 +++
 tools/testing/kfuzztest-bridge/rand_stream.h  |  57 ++
 40 files changed, 3552 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/dev-tools/kfuzztest.rst
 create mode 100644 crypto/asymmetric_keys/tests/Makefile
 create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
 create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
 create mode 100644 drivers/auxdisplay/tests/charlcd_kfuzz.c
 create mode 100644 include/linux/kfuzztest.h
 create mode 100644 lib/kfuzztest/Kconfig
 create mode 100644 lib/kfuzztest/Makefile
 create mode 100644 lib/kfuzztest/main.c
 create mode 100644 lib/kfuzztest/parse.c
 create mode 100644 samples/kfuzztest/Makefile
 create mode 100644 samples/kfuzztest/overflow_on_nested_buffer.c
 create mode 100644 samples/kfuzztest/underflow_on_buffer.c
 create mode 100644 tools/testing/kfuzztest-bridge/.gitignore
 create mode 100644 tools/testing/kfuzztest-bridge/Build
 create mode 100644 tools/testing/kfuzztest-bridge/Makefile
 create mode 100644 tools/testing/kfuzztest-bridge/bridge.c
 create mode 100644 tools/testing/kfuzztest-bridge/byte_buffer.c
 create mode 100644 tools/testing/kfuzztest-bridge/byte_buffer.h
 create mode 100644 tools/testing/kfuzztest-bridge/encoder.c
 create mode 100644 tools/testing/kfuzztest-bridge/encoder.h
 create mode 100644 tools/testing/kfuzztest-bridge/input_lexer.c
 create mode 100644 tools/testing/kfuzztest-bridge/input_lexer.h
 create mode 100644 tools/testing/kfuzztest-bridge/input_parser.c
 create mode 100644 tools/testing/kfuzztest-bridge/input_parser.h
 create mode 100755 tools/testing/kfuzztest-bridge/kfuzztest-bridge
 create mode 100644 tools/testing/kfuzztest-bridge/rand_stream.c
 create mode 100644 tools/testing/kfuzztest-bridge/rand_stream.h

-- 
2.51.0

