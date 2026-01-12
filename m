Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEE4311C17
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 19:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768246123; cv=none; b=d1t58g+AtGPsMllZkH5ui2mP5IArVnSLCy9zpJnzBwTgh0aYkuZdBaCUYm8w3aNwqB+IgDxHBhxJM3MY2oLYfjM5nTqDgxebJlgkVZ7ebJuxoVHNrIE5UDh0ETPhUkVYe22IxJdw2S/eaB/2pkAChh8d6GRAZKbmNNDtFeMRW98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768246123; c=relaxed/simple;
	bh=P/xCm9B+5KAEyQ1qfcZ8mgBzb6s/VqdCC9Btij3XqM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iQPrBSinrijvGecZJABgOcTvqNbVYmvDmscywj8N5BYJcXK/2QvpVhDHxws56HmWYpIgvVTPupTRQQpkPar9UW3LcrXHgcOZPq5JXPMWsPXHMuQUwAeCQjJMPNZkF2S9SHO9+BX33sfZIuluoRHiYQTHmL9aT/NGQUTC934pF4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUFgUo1r; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUFgUo1r"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64b9dfc146fso1716094a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 11:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768246120; x=1768850920; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a8RC3/jOXChgUFu7fWCHeysuCImlO6A97UJW0JalKx0=;
        b=aUFgUo1rZFLwFw2/7/udF0DHXW9dv40/a9g59x+kYJLVjJOl7aQjPzVQ/pXhQEavFt
         0qEaa/mfJFJ1tFA0oGfhCS9ci7e43TS9PsvglK1lN2tCHRZ56jDAObDLfVkQHKLs+zMg
         QUe3bC03UYEBDQpw8jnDLjsHVud0twk3vKt4bpqtAf2OGf7oK2kdv9gopBTqKJSPhy43
         50kLGl/KjIxTAMnSuJDh0DFZfC4DhhvxXjTCZKcNAk8BrUnjqSnLoJbIBaenEQhHVhvJ
         bs0NFLawVWDlSYJIUFE2TAEYWk0WG7Lv/4uciqM+9PtEAYacBBWdFtuOsp++vT/g1RJG
         AMFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246120; x=1768850920;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a8RC3/jOXChgUFu7fWCHeysuCImlO6A97UJW0JalKx0=;
        b=Ja/v8ZA/j4YLbyky6nEFnttr7W4rW9bpmo4oAnXdZxopFXOQAHRLDJBpB/fpCZs6Vb
         IojufcjVpcgtBKM77Ey2m16RWw/GkrXh7PLuSSJr3OBUCDZbOnWACaOC5UCajSDVF2ZY
         ZSqJOEAd1CGd1lnjcDBoPizX0C7sAXfba//0oYZp6hQKXsoTR+HOtt+iguereAZyzK/O
         Ka3qVsoq3QQJdgau2/j+A42oTuY/SUPL8F7YUQMBVA72RiByWcV/V++5B96xs6yqa/QQ
         cIdBKoSHljkFSiqHYdEwBTtIsvgRWBpCn4sYGucVxQszM3RqUkw/w46Znjlq0ZQh07CU
         +Drw==
X-Forwarded-Encrypted: i=1; AJvYcCWVCJyJViGhCPyxI7omlGdO7yuMbUkiKnE8egSMZoXNL5hdifty0YWcN4v+ZbEIILGiB9TcFwNF8dyKnxs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4i4NbEwtaV21cnLRBslhJylTIcbbJUI8ixpd7ioOatuPHyZ3z
	kLd/9brBdtdDMxcN7URCw7Rz72mOmX5Kkf0e7z7onCfTxL123R49JxXc
X-Gm-Gg: AY/fxX4VZ75TVSxOAAij72rjxxREatSbh/jdmAJVMpgEa6WX1QnTdfZRwAdYnUMXsnL
	XptMOxOBKmw84zSsASavjMOOR9+MOckMsspnt78G8izOPUy36jfLCvqxZsY/7oZkByrerjbmrXG
	IDSEih46bHA9TVV7R5SRXuUudaTLcEaMXbFj64UPYVnFT9gZxbZqVXrfPRaUOGLi/hGVV3qoFDy
	tjii8ieHMZXFJGYkmo+c7mNfpUV64RsakK5JhwBdWiinE3v4GEy9BqTB+UzhuajMQjIHfEJMT54
	P5PrRu6gd5HZCsgScy+WuL1a5TkFoLX3UKH0tKDQFjpKjuzNTvG4OqSvpGoclD5OxGOKmpCUhhl
	lSle7ApuLsAC/keXp59x2zDVGOwaiFUjSqab63A5B7HtV409ftMlOSno1JDT97cKS7YJBbUTAiu
	NTbOHmL2+UIKNfKz/I5AynANHGetGf380B5IizItqWYS+pTVq1ag==
X-Received: by 2002:a05:6402:326:b0:641:88ff:10ad with SMTP id 4fb4d7f45d1cf-652e58769e9mr330944a12.14.1768246119781;
        Mon, 12 Jan 2026 11:28:39 -0800 (PST)
Received: from ethan-tp (xdsl-31-164-106-179.adslplus.ch. [31.164.106.179])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf667fcsm18108959a12.29.2026.01.12.11.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:38 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: akpm@linux-foundation.org,
	andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	ebiggers@kernel.org,
	elver@google.com,
	gregkh@linuxfoundation.org,
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
	mcgrof@kernel.org,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	skhan@linuxfoundation.org,
	tarasmadan@google.com,
	wentaoz5@illinois.edu
Subject: [PATCH v4 0/6] KFuzzTest: a new kernel fuzzing framework 
Date: Mon, 12 Jan 2026 20:28:21 +0100
Message-ID: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
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
dependencies be stubbed out.

Following feedback from the Linux Plumbers Conference and mailing list
discussions, this version of the framework has been significantly
simplified. It now focuses exclusively on handling raw binary inputs,
removing the complexity of the custom serialization format and DWARF
parsing found in previous iterations.

The core design consists of two main parts:
1. The `FUZZ_TEST_SIMPLE(name)` macro, which allows developers to define
   a fuzz test that accepts a buffer and its length.
2. A simplified debugfs interface that allows userspace fuzzers (or
   simple command-line tools) to pass raw binary blobs directly to the
   target function.

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

This patch series is structured as follows:
- Patch 1 introduces the core KFuzzTest API, including the main
  FUZZ_TEST_SIMPLE macro.
- Patch 2 adds the runtime implementation for the framework
- Patch 3 adds documentation.
- Patch 4 provides sample fuzz targets.
- Patch 5 defines fuzz targets for several functions in crypto/.
- Patch 6 adds maintainer information for KFuzzTest.

Changes since PR v3:
- Major simplification of the architecture, removing the complex
  `FUZZ_TEST` macro, the custom serialization format, domain
  constraints, annotations, and associated DWARF metadata regions.
- The framework now only supports `FUZZ_TEST_SIMPLE` targets, which
  accept raw binary data.
- Removed the userspace bridge tool as it is no longer required for
  serializing inputs.
- Updated documentation and samples to reflect the "simple-only"
  approach.

Ethan Graham (6):
  kfuzztest: add user-facing API and data structures
  kfuzztest: implement core module and input processing
  kfuzztest: add ReST documentation
  kfuzztest: add KFuzzTest sample fuzz targets
  crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
  MAINTAINERS: add maintainer information for KFuzzTest

 Documentation/dev-tools/index.rst             |   1 +
 Documentation/dev-tools/kfuzztest.rst         | 152 ++++++++++++++++++
 MAINTAINERS                                   |   7 +
 crypto/asymmetric_keys/Makefile               |   2 +
 crypto/asymmetric_keys/tests/Makefile         |   4 +
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    |  18 +++
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  |  24 +++
 include/asm-generic/vmlinux.lds.h             |  14 +-
 include/linux/kfuzztest.h                     |  90 +++++++++++
 lib/Kconfig.debug                             |   1 +
 lib/Makefile                                  |   2 +
 lib/kfuzztest/Kconfig                         |  16 ++
 lib/kfuzztest/Makefile                        |   4 +
 lib/kfuzztest/input.c                         |  47 ++++++
 lib/kfuzztest/main.c                          | 142 ++++++++++++++++
 samples/Kconfig                               |   7 +
 samples/Makefile                              |   1 +
 samples/kfuzztest/Makefile                    |   3 +
 samples/kfuzztest/underflow_on_buffer.c       |  52 ++++++
 19 files changed, 586 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/dev-tools/kfuzztest.rst
 create mode 100644 crypto/asymmetric_keys/tests/Makefile
 create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
 create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
 create mode 100644 include/linux/kfuzztest.h
 create mode 100644 lib/kfuzztest/Kconfig
 create mode 100644 lib/kfuzztest/Makefile
 create mode 100644 lib/kfuzztest/input.c
 create mode 100644 lib/kfuzztest/main.c
 create mode 100644 samples/kfuzztest/Makefile
 create mode 100644 samples/kfuzztest/underflow_on_buffer.c

-- 
2.51.0

