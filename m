Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7A4306489;
	Mon,  1 Sep 2025 16:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756744992; cv=none; b=eBQ+jeU7Yi/BgKOVxnOcrC+D1V/shpSfOTFbitzg70FaKJ8/XhhifDaMRod3/4ONxcdBXkRGGVvCXliw091OYoLA5Occpx8kdc0znqRFgLt7jH31VR+Ik2+GJaxN5wUn/QNg2ER/lj1+c/q+Ie6KWJrLr5Bzu6Bb0zpymM9NhzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756744992; c=relaxed/simple;
	bh=ETeOObltgow8UeI4fm+z2NTZj0k6vcfCPl/RQtJHzjg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jjOiZrZQzeT7FiliCgGTcBzEcRIcDcVe3ig6yGVEVCuw+0A7Su1vpFkPMiZiZYqwECUT8k6OtQTvsBGwdgdItwYphcCcpyqvK9P30/OWNw+0puwDHs7QhkWbBlE4DiwXVPeMDQMtUBDWhfiDhpWUkkiHVvMBRaOz4fFnZWlTKWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SRwP1+1c; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SRwP1+1c"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3d0dd9c9381so3105232f8f.1;
        Mon, 01 Sep 2025 09:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756744988; x=1757349788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ElLDxS3ISbpc9W3XX626CI0E8tPaybmhnhLj5C8PR/U=;
        b=SRwP1+1cfJtRbSY1hTLel4tV73LsWBsPzJSjnN0lmCkbqutCIqUn31zybZaUseW0JR
         wJ9kKG+qYELuaDcMMB736ME+w4i8ITAJNcxp9CAGHD2ajefMSDsWnjh/opOmIUzyvglz
         aKeGw7IRLm9uQaGnkE+5tBO4tNx9Vuj2roQRFGziI1xY8+wiwFhW/NRMPBPTG2k0kjPw
         F7oHEmNHuQGWoNaQnIvnVLG9ux6g8P3smAZGGR4yVocjLXla584dix+vZ7Ts8D9QVnlo
         oJIzWeiELz7UleiwXZMSoLWKv5OYooSP7ULfIOh5XLx6WOff8hcyziSVBqCTM0fTyXlL
         TOeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756744988; x=1757349788;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ElLDxS3ISbpc9W3XX626CI0E8tPaybmhnhLj5C8PR/U=;
        b=Mx0Nm5rjCZNSaJozwxIG/p3RNKahczyoE1Nud7HIIOhVIYwM9MlCjeyZNx+iyt4Ghi
         HZUm21wPG7LwRCl/iJTLzYRt8vm4kho36rg9h/gtBL9LglOh8K45BSLQ3oLWO2QTpVcg
         8jdWWU5dFJ5i+PCDIzzjsLgNigTDZd7hcC1Gnwmvj3Cjfde7Qdd2pbTCTNfUL7UU0XDz
         wDiy7Noeiu7b95KOO9/hT+w9lvuXGMNI7G1tSDaDeLoMRMElJRbLbxwEPRa4DeRY3+AN
         Yqf2ASG9oS6cNtvAEbxsUdQfsxgOVchvKrE6GZs0tjSv0/ZLBD4rdZ+5uBvOvXWtm5xj
         U7MQ==
X-Forwarded-Encrypted: i=1; AJvYcCV84OygrC5x8PW8/Gorkaw79XnqbuaOGbSW1fSYwLgfnne+qbtYYRjqMBmLcDG4g9rnRag6n/5O9GmEets=@vger.kernel.org, AJvYcCWkYK3foypOJLeNlnqILS/xZVfKDHjdoYwZ32tkZHmLJV6wkzspUP4KXnrFNEjNomxbrRIVASVgArLFgsu7@vger.kernel.org
X-Gm-Message-State: AOJu0YzB876vaoVzw2IrVkonhXcSHqqBA5hJ0YWN76vMbqjmo5pNrJzA
	LZ5d9LbXYIBQg4EdpwcK+N6ykaktkqjw4MJXOwPYOH1uA2ayAtmphRTtcVVoqhELY8Zeyg==
X-Gm-Gg: ASbGncvy7J3v5XdFZibIMNvfAnSpyKGjD4mtkLnF6uWdhdVWdZqiLMHgpxcAnt85Mey
	ft4BY8+TOu3YnSf/ytnJ/edasJUAeuZqLzENMsR4LPRYd+6c7WXqv0kgDQyXK2tTPMgIT5gypvb
	0zXyTFaaTCG9g35+B1Sg+4NZaGC8BeyPztZEQL22Y09dddTw3LUkwJkweLsgMC+55FFKMz6XjOI
	iv7BgBR7FETJVE1HG4djoJfOooFUxJ64qze9ARb5bYweeBy/wb1Wy/QNX2ELX0XTvfQQwgqQqzj
	mybEFrH9pMvIBh8d2GTjxMPJqoR8WH4Drr+FYS9j6gYlPFMAktyhyNDAPo8am35iNAn3bARxxNg
	RyTmAqiWCSzTYG0cJDSJ5uNuOt7+U8tbVv8hS35IeAJcuN9bl3ShBZr0AFXFjS/vt828Xf8p4+Y
	ejeCeVVwvFczT6vvydSA==
X-Google-Smtp-Source: AGHT+IHOSulzpXxvv8O/HIyZfodfZK0vimfSFP+L4jhbIEF86uvWEaupB/ivpnTlnTthHjg4SBGoAg==
X-Received: by 2002:a5d:5f50:0:b0:3b7:8da6:1bb4 with SMTP id ffacd0b85a97d-3d1df53be89mr6492296f8f.58.1756744988266;
        Mon, 01 Sep 2025 09:43:08 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (140.225.77.34.bc.googleusercontent.com. [34.77.225.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf274dde69sm15955362f8f.14.2025.09.01.09.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:43:07 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	brendan.higgins@linux.dev,
	davidgow@google.com,
	dvyukov@google.com,
	jannh@google.com,
	elver@google.com,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com,
	kasan-dev@googlegroups.com,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	dhowells@redhat.com,
	lukas@wunner.de,
	ignat@cloudflare.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 RFC 0/7] KFuzzTest: a new kernel fuzzing framework
Date: Mon,  1 Sep 2025 16:42:05 +0000
Message-ID: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
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

-ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
+ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);

A syzkaller instance fuzzing the new test_pkcs7_parse_message target
introduced in patch 7 successfully triggered the bug inside of
asn1_ber_decoder in under a 30 seconds from a cold start.

This RFC continues to seek feedback on the overall design of KFuzzTest
and the minor changes made in V2. We are particularly interested in
comments on:
- The ergonomics of the API for defining fuzz targets.
- The overall workflow and usability for a developer adding and running
  a new in-kernel fuzz target.
- The high-level architecture.

The patch series is structured as follows:
- Patch 1 adds and exposes a new KASAN function needed by KFuzzTest.
- Patch 2 introduces the core KFuzzTest API and data structures.
- Patch 3 adds the runtime implementation for the framework.
- Patch 4 adds a tool for sending structured inputs into a fuzz target.
- Patch 5 adds documentation.
- Patch 6 provides example fuzz targets.
- Patch 7 defines fuzz targets for real kernel functions.

Changes in v2:
- Per feedback from Eric Biggers and Ignat Korchagin, move the /crypto
  fuzz target samples into a new /crypto/tests directory to separate
  them from the functional source code.
- Per feedback from David Gow and Marco Elver, add the kfuzztest-bridge
  tool to generate structured inputs for fuzz targets. The tool can
  populate parts of the input structure with data from a file, enabling
  both simple randomized fuzzing (e.g, using /dev/urandom) and
  targeted testing with file-based inputs.

We would like to thank David Gow for his detailed feedback regarding the
potential integration with KUnit. The v1 discussion highlighted three
potential paths: making KFuzzTests a special case of KUnit tests, sharing
implementation details in a common library, or keeping the frameworks
separate while ensuring API familiarity.

Following a productive conversation with David, we are moving forward
with the third option for now. While tighter integration is an
attractive long-term goal, we believe the most practical first step is
to establish KFuzzTest as a valuable, standalone framework. This avoids
premature abstraction (e.g., creating a shared library with only one
user) and allows KFuzzTest's design to stabilize based on its specific
focus: fuzzing with complex, structured inputs.

Ethan Graham (7):
  mm/kasan: implement kasan_poison_range
  kfuzztest: add user-facing API and data structures
  kfuzztest: implement core module and input processing
  tools: add kfuzztest-bridge utility
  kfuzztest: add ReST documentation
  kfuzztest: add KFuzzTest sample fuzz targets
  crypto: implement KFuzzTest targets for PKCS7 and RSA parsing

 Documentation/dev-tools/index.rst             |   1 +
 Documentation/dev-tools/kfuzztest.rst         | 371 +++++++++++++
 arch/x86/kernel/vmlinux.lds.S                 |  22 +
 crypto/asymmetric_keys/Kconfig                |  15 +
 crypto/asymmetric_keys/Makefile               |   2 +
 crypto/asymmetric_keys/tests/Makefile         |   2 +
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    |  22 +
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  |  38 ++
 include/linux/kasan.h                         |  16 +
 include/linux/kfuzztest.h                     | 508 ++++++++++++++++++
 lib/Kconfig.debug                             |   1 +
 lib/Makefile                                  |   2 +
 lib/kfuzztest/Kconfig                         |  20 +
 lib/kfuzztest/Makefile                        |   4 +
 lib/kfuzztest/main.c                          | 163 ++++++
 lib/kfuzztest/parse.c                         | 208 +++++++
 mm/kasan/shadow.c                             |  31 ++
 samples/Kconfig                               |   7 +
 samples/Makefile                              |   1 +
 samples/kfuzztest/Makefile                    |   3 +
 samples/kfuzztest/overflow_on_nested_buffer.c |  52 ++
 samples/kfuzztest/underflow_on_buffer.c       |  41 ++
 tools/Makefile                                |  15 +-
 tools/kfuzztest-bridge/.gitignore             |   2 +
 tools/kfuzztest-bridge/Build                  |   6 +
 tools/kfuzztest-bridge/Makefile               |  48 ++
 tools/kfuzztest-bridge/bridge.c               |  93 ++++
 tools/kfuzztest-bridge/byte_buffer.c          |  87 +++
 tools/kfuzztest-bridge/byte_buffer.h          |  31 ++
 tools/kfuzztest-bridge/encoder.c              | 356 ++++++++++++
 tools/kfuzztest-bridge/encoder.h              |  16 +
 tools/kfuzztest-bridge/input_lexer.c          | 243 +++++++++
 tools/kfuzztest-bridge/input_lexer.h          |  57 ++
 tools/kfuzztest-bridge/input_parser.c         | 373 +++++++++++++
 tools/kfuzztest-bridge/input_parser.h         |  79 +++
 tools/kfuzztest-bridge/rand_stream.c          |  61 +++
 tools/kfuzztest-bridge/rand_stream.h          |  46 ++
 37 files changed, 3037 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/dev-tools/kfuzztest.rst
 create mode 100644 crypto/asymmetric_keys/tests/Makefile
 create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
 create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
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
2.51.0.318.gd7df087d1a-goog

