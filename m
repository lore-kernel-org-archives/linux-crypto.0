Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB91633C18B;
	Sat, 18 Apr 2026 19:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776540249; cv=none; b=f6KVUxwQUojXRqFg9z3INZpSkmmdQq+o5PTdB9JCXKgSHU9XCday4mChuuXaNtAicX5IC/1XLD6AAnZlBCveyvK4nwk/genXlxRqfjG7vuiTwFWKlXYuXFhQms9Q/e8ZKHjXM+GqX+NmS4lnTLRhXoViI6hMCEiICin12+iudaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776540249; c=relaxed/simple;
	bh=SlLeqFH50ELWn9dsbfyTgrsuJB7Tr5gOriR7lR/b9XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pglQbp7ZTKV6in9VeC2eT4VX5vuWuPURnv5ixrtLn+TIKBRpuCLiuuQarJtCmFw/g0BC4/HIM04rAPaIMwG5ducdWuyfHp6NBZf/2JSBk/F8KFeAK7IkWY6V/d8Vx+qeIDAaNRossu6v8r/SA3yCQR+hwPblcgq5QDj1CcxIexU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=klRrsQr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="klRrsQr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE29C2BCB7;
	Sat, 18 Apr 2026 19:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776540249;
	bh=SlLeqFH50ELWn9dsbfyTgrsuJB7Tr5gOriR7lR/b9XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klRrsQr8hbYw2CyG+2caPFOi0IWAQ6E27rFh7mQoO/UZ58Zw5yV0M7LV8Xmmr7zzP
	 7f/0KG+qXPot/2+ZtxaLJ+Fsr9ssDfJbEFSuV/pqbubg0nBjvQ7FiImpsH8tl76MjS
	 BF/YMU9PCC1rJH7aRfJJvp1CKmJEXPtkZyaHuLHQfxIqD+A6Dq+7e0lk1HL8KUBRcS
	 BjN4WRJx0lDMSYLkaAc7PMRdpDxdMXnsBis9lXiYOnAfsOxbv7Vad9jh/z3TpQyOqd
	 0pviEzV9HNQkyaEdQSjbCieqAwLqc/t/AYemjBHALZSp2DZKK+LuURveQSTPm8ZosM
	 /2RP65v9aqKwA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-doc@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 2/2] lib/crypto: docs: Add rst documentation to Documentation/crypto/
Date: Sat, 18 Apr 2026 12:21:38 -0700
Message-ID: <20260418192138.15556-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418192138.15556-1-ebiggers@kernel.org>
References: <20260418192138.15556-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a documentation file Documentation/crypto/libcrypto.rst which
provides a high-level overview of lib/crypto/.

Also add several sub-pages which include the kernel-doc for the
algorithms that have it.  This makes the existing, quite extensive
kernel-doc start being included in the HTML and PDF documentation.

Note that the intent is very much *not* that everyone has to read these
Documentation/ files.  The library is intended to be straightforward and
use familiar conventions; generally it should be possible to dive right
into the kernel-doc.  You shouldn't need to read a lot of documentation
to just call `sha256()`, for example, or to run the unit tests if you're
already familiar with KUnit.  (This differs from the traditional crypto
API which has a larger barrier to entry.)

Nevertheless, this seems worth adding.  Hopefully it is useful and makes
LWN no longer consider the library to be "meticulously undocumented".

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/crypto/index.rst                |   2 +-
 .../crypto/libcrypto-blockcipher.rst          |  19 ++
 Documentation/crypto/libcrypto-hash.rst       |  86 +++++++++
 Documentation/crypto/libcrypto-signature.rst  |  11 ++
 Documentation/crypto/libcrypto-utils.rst      |   6 +
 Documentation/crypto/libcrypto.rst            | 165 ++++++++++++++++++
 Documentation/crypto/sha3.rst                 |   2 +
 7 files changed, 290 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/crypto/libcrypto-blockcipher.rst
 create mode 100644 Documentation/crypto/libcrypto-hash.rst
 create mode 100644 Documentation/crypto/libcrypto-signature.rst
 create mode 100644 Documentation/crypto/libcrypto-utils.rst
 create mode 100644 Documentation/crypto/libcrypto.rst

diff --git a/Documentation/crypto/index.rst b/Documentation/crypto/index.rst
index 4ee667c446f99..705f186d662ba 100644
--- a/Documentation/crypto/index.rst
+++ b/Documentation/crypto/index.rst
@@ -11,10 +11,11 @@ for cryptographic use cases, as well as programming examples.
 
 .. toctree::
    :caption: Table of contents
    :maxdepth: 2
 
+   libcrypto
    intro
    api-intro
    architecture
 
    async-tx-api
@@ -25,6 +26,5 @@ for cryptographic use cases, as well as programming examples.
    api
    api-samples
    descore-readme
    device_drivers/index
    krb5
-   sha3
diff --git a/Documentation/crypto/libcrypto-blockcipher.rst b/Documentation/crypto/libcrypto-blockcipher.rst
new file mode 100644
index 0000000000000..dd5ce2f8b5151
--- /dev/null
+++ b/Documentation/crypto/libcrypto-blockcipher.rst
@@ -0,0 +1,19 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+Block ciphers
+=============
+
+AES
+---
+
+Support for the AES block cipher.
+
+.. kernel-doc:: include/crypto/aes.h
+
+DES
+---
+
+Support for the DES block cipher.  This algorithm is obsolete and is supported
+only for backwards compatibility.
+
+.. kernel-doc:: include/crypto/des.h
diff --git a/Documentation/crypto/libcrypto-hash.rst b/Documentation/crypto/libcrypto-hash.rst
new file mode 100644
index 0000000000000..4248e6fdc9527
--- /dev/null
+++ b/Documentation/crypto/libcrypto-hash.rst
@@ -0,0 +1,86 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+Hash functions, MACs, and XOFs
+==============================
+
+AES-CMAC and AES-XCBC-MAC
+-------------------------
+
+Support for the AES-CMAC and AES-XCBC-MAC message authentication codes.
+
+.. kernel-doc:: include/crypto/aes-cbc-macs.h
+
+BLAKE2b
+-------
+
+Support for the BLAKE2b cryptographic hash function.
+
+.. kernel-doc:: include/crypto/blake2b.h
+
+BLAKE2s
+-------
+
+Support for the BLAKE2s cryptographic hash function.
+
+.. kernel-doc:: include/crypto/blake2s.h
+
+GHASH and POLYVAL
+-----------------
+
+Support for the GHASH and POLYVAL universal hash functions.  These algorithms
+are used only as internal components of other algorithms.
+
+.. kernel-doc:: include/crypto/gf128hash.h
+
+MD5
+---
+
+Support for the MD5 cryptographic hash function and HMAC-MD5.  This algorithm is
+obsolete and is supported only for backwards compatibility.
+
+.. kernel-doc:: include/crypto/md5.h
+
+NH
+--
+
+Support for the NH universal hash function.  This algorithm is used only as an
+internal component of other algorithms.
+
+.. kernel-doc:: include/crypto/nh.h
+
+Poly1305
+--------
+
+Support for the Poly1305 universal hash function.  This algorithm is used only
+as an internal component of other algorithms.
+
+.. kernel-doc:: include/crypto/poly1305.h
+
+SHA-1
+-----
+
+Support for the SHA-1 cryptographic hash function and HMAC-SHA1.  This algorithm
+is obsolete and is supported only for backwards compatibility.
+
+.. kernel-doc:: include/crypto/sha1.h
+
+SHA-2
+-----
+
+Support for the SHA-2 family of cryptographic hash functions, including SHA-224,
+SHA-256, SHA-384, and SHA-512.  This also includes their corresponding HMACs:
+HMAC-SHA224, HMAC-SHA256, HMAC-SHA384, and HMAC-SHA512.
+
+.. kernel-doc:: include/crypto/sha2.h
+
+SHA-3
+-----
+
+The SHA-3 functions are documented in :ref:`sha3`.
+
+SM3
+---
+
+Support for the SM3 cryptographic hash function.
+
+.. kernel-doc:: include/crypto/sm3.h
diff --git a/Documentation/crypto/libcrypto-signature.rst b/Documentation/crypto/libcrypto-signature.rst
new file mode 100644
index 0000000000000..e80d59fa51b6a
--- /dev/null
+++ b/Documentation/crypto/libcrypto-signature.rst
@@ -0,0 +1,11 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+Digital signature algorithms
+============================
+
+ML-DSA
+------
+
+Support for the ML-DSA digital signature algorithm.
+
+.. kernel-doc:: include/crypto/mldsa.h
diff --git a/Documentation/crypto/libcrypto-utils.rst b/Documentation/crypto/libcrypto-utils.rst
new file mode 100644
index 0000000000000..9d833f47ed390
--- /dev/null
+++ b/Documentation/crypto/libcrypto-utils.rst
@@ -0,0 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+Utility functions
+=================
+
+.. kernel-doc:: include/crypto/utils.h
diff --git a/Documentation/crypto/libcrypto.rst b/Documentation/crypto/libcrypto.rst
new file mode 100644
index 0000000000000..a1557d45b0e5a
--- /dev/null
+++ b/Documentation/crypto/libcrypto.rst
@@ -0,0 +1,165 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+==============
+Crypto library
+==============
+
+``lib/crypto/`` provides faster and easier access to cryptographic algorithms
+than the traditional crypto API.
+
+Each cryptographic algorithm is supported via a set of dedicated functions.
+"Crypto agility", where needed, is left to calling code.
+
+The crypto library functions are intended to be boring and straightforward, and
+to follow familiar conventions.  Their primary documentation is their (fairly
+extensive) kernel-doc.  This page just provides some extra high-level context.
+
+Note that the crypto library isn't entirely new.  ``lib/`` has contained some
+crypto functions since 2005.  Rather, it's just an approach that's been expanded
+over time as it's been found to work well.  It also largely just matches how the
+kernel already does things elsewhere.
+
+Scope and intended audience
+===========================
+
+The crypto library documentation is primarily meant for kernel developers who
+need to use a particular cryptographic algorithm(s) in kernel code.  For
+example, "I just need to compute a SHA-256 hash."  A secondary audience is
+developers working on the crypto algorithm implementations themselves.
+
+If you're looking for more general information about cryptography, like the
+differences between the different crypto algorithms or how to select an
+appropriate algorithm, you should refer to external sources which cover that
+type of information much more comprehensively.  If you need help selecting
+algorithms for a new kernel feature that doesn't already have its algorithms
+predefined, please reach out to ``linux-crypto@vger.kernel.org`` for advice.
+
+Code organization
+=================
+
+- ``lib/crypto/*.c``: the crypto algorithm implementations
+
+- ``lib/crypto/$(SRCARCH)/``: architecture-specific code for crypto algorithms.
+  It is here rather than somewhere in ``arch/`` partly because this allows
+  generic and architecture-optimized code to be easily built into a single
+  loadable module (when the algorithm is set to 'm' in the kconfig).
+
+- ``lib/crypto/tests/``: KUnit tests for the crypto algorithms
+
+- ``include/crypto/``: crypto headers, for both the crypto library and the
+  traditional crypto API
+
+Generally, there is one kernel module per algorithm.  Sometimes related
+algorithms are grouped into one module.  There is intentionally no common
+framework, though there are some utility functions that multiple algorithms use.
+
+Each algorithm module is controlled by a tristate kconfig symbol
+``CRYPTO_LIB_$(ALGORITHM)``.  As is the norm for library functions in the
+kernel, these are hidden symbols which don't show up in the kconfig menu.
+Instead, they are just selected by all the kconfig symbols that need them.
+
+Many of the algorithms have multiple implementations: a generic implementation
+and architecture-optimized implementation(s).  Each module initialization
+function, or initcall in the built-in case, automatically enables the best
+implementation based on the available CPU features.
+
+Note that the crypto library doesn't use the ``crypto/``,
+``arch/$(SRCARCH)/crypto/``, or ``drivers/crypto/`` directories.  These
+directories are used by the traditional crypto API.  When possible, algorithms
+in the traditional crypto API are implemented by calls into the library.
+
+Advantages
+==========
+
+Some of the advantages of the library over the traditional crypto API are:
+
+- The library functions tend to be much easier to use.  For example, a hash
+  value can be computed using only a single function call.  Most of the library
+  functions always succeed and return void, eliminating the need to write
+  error-handling code.  Most also accept standard virtual addresses, rather than
+  scatterlists which are difficult and less efficient to work with.
+
+- The library functions are usually faster, especially for short inputs.  They
+  call the crypto algorithms directly without inefficient indirect calls, memory
+  allocations, string parsing, lookups in an algorithm registry, and other
+  unnecessary API overhead.  Architecture-optimized code is enabled by default.
+
+- The library functions use standard link-time dependencies instead of
+  error-prone dynamic loading by name.  There's no need for workarounds such as
+  forcing algorithms to be built-in or adding module soft dependencies.
+
+- The library focuses on the approach that works the best on the vast majority
+  of systems: CPU-based implementations of the crypto algorithms, utilizing
+  on-CPU acceleration (such as AES instructions) when available.
+
+- The library uses standard KUnit tests, rather than custom ad-hoc tests.
+
+- The library tends to have higher assurance implementations of the crypto
+  algorithms.  This is both due to its simpler design and because more of its
+  code is being regularly tested.
+
+- The library supports features that don't fit into the rigid framework of the
+  traditional crypto API, for example interleaved hashing and XOFs.
+
+When to use it
+==============
+
+In-kernel users should use the library (rather than the traditional crypto API)
+whenever possible.  Many subsystems have already been converted.  It usually
+simplifies their code significantly and improves performance.
+
+Some kernel features allow userspace to provide an arbitrary string that selects
+an arbitrary algorithm from the traditional crypto API by name.  These features
+generally will have to keep using the traditional crypto API for backwards
+compatibility.
+
+Note: new kernel features shouldn't support every algorithm, but rather make a
+deliberate choice about what algorithm(s) to support.  History has shown that
+making a deliberate, thoughtful choice greatly simplifies code maintenance,
+reduces the chance for mistakes (such as using an obsolete, insecure, or
+inappropriate algorithm), and makes your feature easier to use.
+
+Testing
+=======
+
+The crypto library uses standard KUnit tests.  Like many of the kernel's other
+KUnit tests, they are included in the set of tests that is run by
+``tools/testing/kunit/kunit.py run --alltests``.
+
+A ``.kunitconfig`` file is also provided to run just the crypto library tests.
+For example, here's how to run them in user-mode Linux:
+
+.. code-block:: sh
+
+    tools/testing/kunit/kunit.py run --kunitconfig=lib/crypto/
+
+Many of the crypto algorithms have architecture-optimized implementations.
+Testing those requires building an appropriate kernel and running the tests
+either in QEMU or on appropriate hardware.  Here's one example with QEMU:
+
+.. code-block:: sh
+
+    tools/testing/kunit/kunit.py run --kunitconfig=lib/crypto/ --arch=arm64 --make_options LLVM=1
+
+Depending on the code being tested, flags may need to be passed to QEMU to
+emulate the correct type of hardware for the code to be reached.
+
+Since correctness is essential in cryptographic code, new architecture-optimized
+code is accepted only if it can be tested in QEMU.
+
+Note: the crypto library also includes FIPS 140 self-tests.  These are
+lightweight, are designed specifically to meet FIPS 140 requirements, and exist
+*only* to meet those requirements.  Normal testing done by kernel developers and
+integrators should use the much more comprehensive KUnit tests instead.
+
+API documentation
+=================
+
+.. toctree::
+   :maxdepth: 2
+
+   libcrypto-blockcipher
+   libcrypto-hash
+   libcrypto-signature
+   libcrypto-utils
+   sha3
diff --git a/Documentation/crypto/sha3.rst b/Documentation/crypto/sha3.rst
index 37640f295118b..250669c98f6ba 100644
--- a/Documentation/crypto/sha3.rst
+++ b/Documentation/crypto/sha3.rst
@@ -1,7 +1,9 @@
 .. SPDX-License-Identifier: GPL-2.0-or-later
 
+.. _sha3:
+
 ==========================
 SHA-3 Algorithm Collection
 ==========================
 
 .. contents::
-- 
2.53.0

