Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C783927FB10
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 09:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758013282; cv=none; b=oYYdy4YvSSEqZ5T7UA+lsdnJFE+WwKDtTrWlFdKh6RX+Ygrh3Hv6IaZx6DLLgIBf2u6ngual5Ut/OOZA51VTl5vIowwYiUu2/fUJLkH9VOTYb+SaW5VMD6g1Z3um9/kNKMNF5Mm6ENB9m4mu4bLEleK2SAye/dN4pnx14+nGuZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758013282; c=relaxed/simple;
	bh=HW+lZGTNSVb7t+WVX4jnc1u0gcEJsOxGllDVrbzZpXo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UEuSqKbGK+ZFB3+z6rCebkcm6+cA6dHwxbeMAjr2t/KEx8HXbhMaB3WRv/5XSdLdGV68o6utubQE+hyYJlalUAVj5F/pcPQZywmQC06ezLTHE8du8+KXokfUtOh+2GWW4WSdugDDE1uKmzZDoRdTY2eGTZ1biqUVsRBFnPw5ghI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WdlrIIIU; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WdlrIIIU"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45f2c5ef00fso19209965e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 02:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758013279; x=1758618079; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=upMhvQF//L2bSGTsud4VXsSZCTKFm60OzLUP07Pokt0=;
        b=WdlrIIIUDWhAxCGNpcS9nvnj2OEdlzKn+c4Qk/OwfAl4vp2NU/4ghvAgjyA5D4wZh/
         idq/J3XKqFRj5BBATZplvfmbblf+Jj8DQB8evH3Ci1MoPs4pHAFJ2/So7c9rBgBlJ8+V
         SfA6If2Ub87op7hQldTnIfUnyssS+0gKnr27ryf+CYoxqAQqo/5ObS0HT17Ve3C+5YiV
         tldWgPkmn1GA5F/43FLP9NUxwlRevXievcNW0xRNzSE+x+sn7Y3MxOZ1ESkNNsuGqf//
         YABrhx4ixj62gGdavYX0EYP4yOAsO66GDgv+rm5mBvjlc8Aysj5kDZJN50elRp5EaB8X
         OWMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013279; x=1758618079;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=upMhvQF//L2bSGTsud4VXsSZCTKFm60OzLUP07Pokt0=;
        b=GaXi+/2HRL2HgxS6H0ecdHBA61kJhS92MWYdx6g0svYm3n5d3aAXTSSo9/P4uzO4wX
         QmoT8V43PcEg1pvzl1wvFXWnmdLpcBb6WdXy92Y2F2VTACK3F8V6skWZ8BttqEuBplIH
         8/qzlaTEGejtaJpinR4dAyu0lzBgL/E2g5S+HPZU3rOK1XJHbocgof5Ve86EjGGRrgbu
         lGwfa5Pvze7ykFGnlOoGueix6fB2PMZRUIjAmvXIb19wZQOusLbw1/E8BVIg+vAqPjQ1
         650vJ+m+rRQ2HuCIRP2fgVzvQMPKAmtR/fb7Y+DIynQZ+LIkmlg1QWRUVKaCBI8Yp6BM
         3ZsQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7CzzzusmEV0DTh6oarx1Pb+0W0TqJR5nJyFKJonOiv5Pfu+AT0PrPLSRZciP+LnQ7kRvGj2YEHNbmFNE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQZwtK1dDDFfT9B3TKuwEauRyFbFnvWHZM4siM2fzS/kKrwatp
	3n8/z8WIoBzeUCyBzTBgmxeMdqzAEjy/pjRJQ8XQMS4bXzn81KIvxaR1
X-Gm-Gg: ASbGncvep9G8bJraFoiaF1MokF7HjZ8gmcTO5DRwUWfhlOAdKQxa/PveV2uIBbkMnjI
	LC/ycLeezP3zqow/Ndllwp9dgZep1qnXUwX8K84hMDt6m5vphEryeuYKU1c86JeJxAFPe309kp6
	0fHIWHXvHWSl+YrHjgbwfCAbYn/xwJbuEvB47AhyY0BS3YdQRDEjspBkEfKiQFbX9gXZ3hXXrW0
	KTEzcHGYfOkFFUAvYMtASVd1a/oPDqYecnPZjhHWmz6fV3SXgJhoE+SG3q3Z0noSlJR/qMhZCWy
	+qYLB90Co94vVqA+QP/5+38Jgtdk8f4wC8IApnpW1z4Vm1Ug2/HAmfug9EEkbplY0RYRA/8qwKA
	Rhv8BP9dvu8JWiXhjekwG2haBNI/Xv9FO0nrqWWPkFQTJiEaJEmVO4WtQ2djvdEpnn6N6OAHJFf
	oXqVftOGVm1KjBRnnLBbxzbFs=
X-Google-Smtp-Source: AGHT+IFclWAKbjGgLv2K4m6q+aAL6mre53m9qB7bPaj17wvwDzoWsbTz12D9JPu/yEQ6xkF20lstyw==
X-Received: by 2002:a05:600c:a0b:b0:45b:74fc:d6ec with SMTP id 5b1f17b1804b1-45f211ca9dbmr161780395e9.8.1758013278551;
        Tue, 16 Sep 2025 02:01:18 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (42.16.79.34.bc.googleusercontent.com. [34.79.16.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm212975035e9.5.2025.09.16.02.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:01:17 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
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
	tarasmadan@google.com
Subject: [PATCH v1 0/10] KFuzzTest: a new kernel fuzzing framework
Date: Tue, 16 Sep 2025 09:00:59 +0000
Message-ID: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ethan Graham <ethangraham@google.com>

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
1. A `FUZZ_TEST(name, struct_type)` macro that allows developers to
   easily define a fuzz test.
2. A binary input format that allows a userspace fuzzer to serialize
   complex, pointer-rich C structures into a single buffer.
3. Metadata for test targets, constraints, and annotations, which is
   emitted into dedicated ELF sections to allow for discovery and
   inspection by userspace tools. These are found in
   ".kfuzztest_{targets, constraints, annotations}".

To demonstrate this framework's viability, support for KFuzzTest has been
prototyped in a development fork of syzkaller, enabling coverage-guided
fuzzing. To validate its end-to-end effectiveness, we performed an
experiment by manually introducing an off-by-one buffer over-read into
pkcs7_parse_message, like so:

- ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
+ ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);

A syzkaller instance fuzzing the new test_pkcs7_parse_message target
introduced in patch 7 successfully triggered the bug inside of
asn1_ber_decoder in under 30 seconds from a cold start. Similar
experiements on the other new fuzz targets (patches 8-9) also
successfully identified injected bugs, proving that KFuzzTest is
effective when paired with a coverage-guided fuzzing engine.

A note on build system integration: several new fuzz targets (patches
7-9) are included by conditionally importing a .c file when
CONFIG_KFUZZTEST=y. While this may seem unusual, it follows a pattern
used by some KUnit tests (e.g., in /fs/binfmt_elf.c). We considered
defining macros like VISIBLE_IF_KFUZZTEST, but believe the final
integration approach is best decided by subsystem maintainers. This
avoids creating a one-size-fits-all abstraction prematurely.

The patch series is structured as follows:
- Patch 1 adds and exposes kasan_poison_range for poisoning memory
  ranges with an unaligned start address and KASAN_GRANULE_SIZE aligned
  end address.
- Patch 2 introduces the core KFuzzTest API and data structures.
- Patch 3 adds the runtime implementation for the framework.
- Patch 4 adds a tool for sending structured inputs into a fuzz target.
- Patch 5 adds documentation.
- Patch 6 provides sample fuzz targets.
- Patch 7 defines fuzz targets for several functions in /crypto.
- Patch 8 defines a fuzz target for parse_xy in /drivers/auxdisplay.
- Patch 9 defines a fuzz target for load_script in /fs.
- Patch 10 adds maintainer information for KFuzzTest.

Changes since RFC v2:
- Per feedback from Ignat Korchagin a fuzz target has been defined for
  the load_script function in binfmt_script.c, and all fuzz targets are
  built with CONFIG_KFUZZTEST=y rather than a specialized configuration
  option per module.
- Per feedback from David Gow and Alexander Potapenko, KFuzzTest linkage
  definitions have been moved into the generic linkage header so that
  the framework isn't bound to x86_64.

Ethan Graham (10):
  mm/kasan: implement kasan_poison_range
  kfuzztest: add user-facing API and data structures
  kfuzztest: implement core module and input processing
  tools: add kfuzztest-bridge utility
  kfuzztest: add ReST documentation
  kfuzztest: add KFuzzTest sample fuzz targets
  crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
  drivers/auxdisplay: add a KFuzzTest for parse_xy()
  fs/binfmt_script: add KFuzzTest target for load_script
  MAINTAINERS: add maintainer information for KFuzzTest

 Documentation/dev-tools/index.rst             |   1 +
 Documentation/dev-tools/kfuzztest.rst         | 385 ++++++++++++++
 MAINTAINERS                                   |   8 +
 crypto/asymmetric_keys/Makefile               |   2 +
 crypto/asymmetric_keys/tests/Makefile         |   2 +
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    |  22 +
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  |  38 ++
 drivers/auxdisplay/charlcd.c                  |   8 +
 drivers/auxdisplay/tests/charlcd_kfuzz.c      |  20 +
 fs/binfmt_script.c                            |   8 +
 fs/tests/binfmt_script_kfuzz.c                |  51 ++
 include/asm-generic/vmlinux.lds.h             |  22 +-
 include/linux/kasan.h                         |  11 +
 include/linux/kfuzztest.h                     | 498 ++++++++++++++++++
 lib/Kconfig.debug                             |   1 +
 lib/Makefile                                  |   2 +
 lib/kfuzztest/Kconfig                         |  20 +
 lib/kfuzztest/Makefile                        |   4 +
 lib/kfuzztest/main.c                          | 240 +++++++++
 lib/kfuzztest/parse.c                         | 204 +++++++
 mm/kasan/shadow.c                             |  34 ++
 samples/Kconfig                               |   7 +
 samples/Makefile                              |   1 +
 samples/kfuzztest/Makefile                    |   3 +
 samples/kfuzztest/overflow_on_nested_buffer.c |  71 +++
 samples/kfuzztest/underflow_on_buffer.c       |  59 +++
 tools/Makefile                                |  15 +-
 tools/kfuzztest-bridge/.gitignore             |   2 +
 tools/kfuzztest-bridge/Build                  |   6 +
 tools/kfuzztest-bridge/Makefile               |  48 ++
 tools/kfuzztest-bridge/bridge.c               | 103 ++++
 tools/kfuzztest-bridge/byte_buffer.c          |  87 +++
 tools/kfuzztest-bridge/byte_buffer.h          |  31 ++
 tools/kfuzztest-bridge/encoder.c              | 391 ++++++++++++++
 tools/kfuzztest-bridge/encoder.h              |  16 +
 tools/kfuzztest-bridge/input_lexer.c          | 242 +++++++++
 tools/kfuzztest-bridge/input_lexer.h          |  57 ++
 tools/kfuzztest-bridge/input_parser.c         | 397 ++++++++++++++
 tools/kfuzztest-bridge/input_parser.h         |  81 +++
 tools/kfuzztest-bridge/rand_stream.c          |  77 +++
 tools/kfuzztest-bridge/rand_stream.h          |  57 ++
 41 files changed, 3325 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/dev-tools/kfuzztest.rst
 create mode 100644 crypto/asymmetric_keys/tests/Makefile
 create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
 create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
 create mode 100644 drivers/auxdisplay/tests/charlcd_kfuzz.c
 create mode 100644 fs/tests/binfmt_script_kfuzz.c
 create mode 100644 include/linux/kfuzztest.h
 create mode 100644 lib/kfuzztest/Kconfig
 create mode 100644 lib/kfuzztest/Makefile
 create mode 100644 lib/kfuzztest/main.c
 create mode 100644 lib/kfuzztest/parse.c
 create mode 100644 samples/kfuzztest/Makefile
 create mode 100644 samples/kfuzztest/overflow_on_nested_buffer.c
 create mode 100644 samples/kfuzztest/underflow_on_buffer.c
 create mode 100644 tools/kfuzztest-bridge/.gitignore
 create mode 100644 tools/kfuzztest-bridge/Build
 create mode 100644 tools/kfuzztest-bridge/Makefile
 create mode 100644 tools/kfuzztest-bridge/bridge.c
 create mode 100644 tools/kfuzztest-bridge/byte_buffer.c
 create mode 100644 tools/kfuzztest-bridge/byte_buffer.h
 create mode 100644 tools/kfuzztest-bridge/encoder.c
 create mode 100644 tools/kfuzztest-bridge/encoder.h
 create mode 100644 tools/kfuzztest-bridge/input_lexer.c
 create mode 100644 tools/kfuzztest-bridge/input_lexer.h
 create mode 100644 tools/kfuzztest-bridge/input_parser.c
 create mode 100644 tools/kfuzztest-bridge/input_parser.h
 create mode 100644 tools/kfuzztest-bridge/rand_stream.c
 create mode 100644 tools/kfuzztest-bridge/rand_stream.h

-- 
2.51.0.384.g4c02a37b29-goog

