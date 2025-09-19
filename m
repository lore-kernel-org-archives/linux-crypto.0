Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC021246BD5
	for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 14:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758293882; cv=none; b=F2gMQ/PgRHFWnSi31wybKSjSshu7MrBgOSFo6UuV9Aqeq8h9SZflIMjhk4yHjxRXIP8hz8XnrCFGPV7wMg+EonOgT2uKpIDSU0kEpLFfZncXJLMjmw+LCWrYLTTzJ6o3+PFasRv7s41W+tHcYUw9grUuJRQ+d1DPKf3/jQqx02Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758293882; c=relaxed/simple;
	bh=QI5oQhF7XTaRZCE0IZXd/hI1EffGdeBxbG4OgNy30vA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=do3IxJ552B7ZDAQkdJ8qqxCw0fENR+bXQ0xMoiPj2VTvOBMWZ0iyM6Rpmv5lEya12SxBLkbJZBKrx0qvzMehIRmRTe+6QUexWx043If/Ql6/CeNfxivvomhkT4K+es5Bk3EVkhIeZzKCLu3ESl8Do4D7FR4w6m1Loug8bShbmFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OjLpykMv; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OjLpykMv"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3f1aff41e7eso440069f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 19 Sep 2025 07:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758293879; x=1758898679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gkRYzWYSGqW8b5cMZYzB+a2FlxSRz9tBtPdwTZuG88Q=;
        b=OjLpykMvSy1RnP9ureitc6zliX7lwQUdDGMpnc+nDIrtoXE08uH3VsTI/6GTYEsPBR
         UUWTusjDGmliBl8M7cbM4mSqqJdFBxaQuVDi+1q9GAimgy8+UpXcNuMU2LBIVEL5EW1f
         pbA/mTJPd/GizhexuAypr8tErmDX4jkI8Dkni2nnJn2ldrto+Awn3mRuOAfUkDrBA19U
         uEbRla79nnpDWeBtHiWOVNREMil4L1QioMuCB8Fe2R+WlJWNDnaklfnDsHzZngLTrJFt
         wzQixIfgpX2iOuSGPnKujcnMsNv5Lgn8gd/2FS54G63bA+Dt0CyG8uAsoE7fKtVp0WzA
         R6EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293879; x=1758898679;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gkRYzWYSGqW8b5cMZYzB+a2FlxSRz9tBtPdwTZuG88Q=;
        b=veUMm0AEGBTf+5oX4TRHhW/D9WGLGq2PrNOB8yXQ0m9y6TCUhI5XtcPNUpZD4/4Ex2
         1p7FRZcJuaGbqz80k9dyRXvv/uSiNYq7jLkH7q06igxyYj7Os1zC/Pf2k/qfQsF/lxnS
         wKu0VAsz7jWC9skv5YSeJIzYR/9+XhOUcS7f5OWIBaoVH+cZ/zOm93EKWgm4WWJeKMpP
         LGtp76axw/RDc32vktoVmGm4Ia4/BL6+uJJIcahER4bkiJ4IhBguv7TFk7oAmBZgh/qk
         OugJd4knN5otiG76uyO4O2Vv4xvVY0Q58WPNwfB+PG8zKQaq5GHtpx1VC+UIPOGnnQEE
         GPCg==
X-Forwarded-Encrypted: i=1; AJvYcCXoVOYijaZ9tb4AVQsx+wjTsMg4HeNMMqy8XQR5wPq4pUH+4b2qXFMc1xdpUTD/Mw8pVsbzfe8DeVo2gOc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGc4cXv7g5iKFXgEoNxfO9jSOdoLvSD+VCXBTOFK5yoeuEMxPb
	qzeLvEVvuTPh5yEKH57FtkPbMG51z+ZgqJ5Xw/lOVu5oz6R+y8JQoNtL
X-Gm-Gg: ASbGnctCUDXtEWHfz1zKaP+vvMw+Ia0oIftS0OMu2w5ZhckNAJnH38xifKAN8O5t8VL
	27Bof//X/zBzRM09FcNSS1nN3NVPox1YpWm4Hnjh5xdmAhfRo/YN08VFMcErlptwGGwr/iq5hhM
	Rq/hHiKvegk6xK3RkU35/U9qqLqWfuU9tggPv6PvFROl2q6kqva7oaS7nBhsvHQMdTFM72mwYtv
	r8npOfcdsQjBH98RoOUPATfch1yKUAizRA7pXzjzaHp9YDB+wdunsjBhrFg+X3193KAyrePnmQ7
	Tv0vygNGxFqkj8qqAWYE9+o66zNms1RbkANnfQAFe4qA/CSqyfibhSpy8SEotW7cQf/psU5Grov
	9s0GdFgPNeJf4PVQa84K0cyndUuJgd4PjslLy0KVTyFL6k4698b60fG4s4KPAoV5XS46PL1oR0t
	EMpB9+4zD5t+6B1rQ=
X-Google-Smtp-Source: AGHT+IEdudVdUm6YZvrWF2hjwiXm8E9sMaoH4gzwvAVRyn4SxIgwEo9osEfanV2V+L8caLBnEhd6kw==
X-Received: by 2002:a05:6000:605:b0:3ec:db87:e908 with SMTP id ffacd0b85a97d-3ee7da56fbdmr3112750f8f.7.1758293878859;
        Fri, 19 Sep 2025 07:57:58 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (124.62.78.34.bc.googleusercontent.com. [34.78.62.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7188sm8551386f8f.37.2025.09.19.07.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 07:57:58 -0700 (PDT)
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
	sj@kernel.org,
	tarasmadan@google.com
Subject: [PATCH v2 0/10] KFuzzTest: a new kernel fuzzing framework
Date: Fri, 19 Sep 2025 14:57:40 +0000
Message-ID: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
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

Changes since PR v1:
- Per feedback from SeongJae Park, move kfuzztest-bridge into the
  testing/tools directory, and update the Makefile accordingly.
- Per review from Alexander Potapenko, address some cleanup issues and
  nits.
- Fix build issues identified by the kernel test robot <lkp@intel.com>.

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
 crypto/asymmetric_keys/tests/Makefile         |   4 +
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    |  26 +
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  |  38 ++
 drivers/auxdisplay/charlcd.c                  |   8 +
 drivers/auxdisplay/tests/charlcd_kfuzz.c      |  20 +
 fs/binfmt_script.c                            |   8 +
 fs/tests/binfmt_script_kfuzz.c                |  58 ++
 include/asm-generic/vmlinux.lds.h             |  22 +-
 include/linux/kasan.h                         |  11 +
 include/linux/kfuzztest.h                     | 497 ++++++++++++++++++
 lib/Kconfig.debug                             |   1 +
 lib/Makefile                                  |   2 +
 lib/kfuzztest/Kconfig                         |  20 +
 lib/kfuzztest/Makefile                        |   4 +
 lib/kfuzztest/main.c                          | 242 +++++++++
 lib/kfuzztest/parse.c                         | 204 +++++++
 mm/kasan/shadow.c                             |  34 ++
 samples/Kconfig                               |   7 +
 samples/Makefile                              |   1 +
 samples/kfuzztest/Makefile                    |   3 +
 samples/kfuzztest/overflow_on_nested_buffer.c |  71 +++
 samples/kfuzztest/underflow_on_buffer.c       |  59 +++
 tools/Makefile                                |  18 +-
 tools/testing/kfuzztest-bridge/.gitignore     |   2 +
 tools/testing/kfuzztest-bridge/Build          |   6 +
 tools/testing/kfuzztest-bridge/Makefile       |  49 ++
 tools/testing/kfuzztest-bridge/bridge.c       | 115 ++++
 tools/testing/kfuzztest-bridge/byte_buffer.c  |  85 +++
 tools/testing/kfuzztest-bridge/byte_buffer.h  |  31 ++
 tools/testing/kfuzztest-bridge/encoder.c      | 390 ++++++++++++++
 tools/testing/kfuzztest-bridge/encoder.h      |  16 +
 tools/testing/kfuzztest-bridge/input_lexer.c  | 256 +++++++++
 tools/testing/kfuzztest-bridge/input_lexer.h  |  58 ++
 tools/testing/kfuzztest-bridge/input_parser.c | 425 +++++++++++++++
 tools/testing/kfuzztest-bridge/input_parser.h |  82 +++
 tools/testing/kfuzztest-bridge/rand_stream.c  |  77 +++
 tools/testing/kfuzztest-bridge/rand_stream.h  |  57 ++
 41 files changed, 3399 insertions(+), 4 deletions(-)
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
 create mode 100644 tools/testing/kfuzztest-bridge/rand_stream.c
 create mode 100644 tools/testing/kfuzztest-bridge/rand_stream.h

-- 
2.51.0.470.ga7dc726c21-goog

