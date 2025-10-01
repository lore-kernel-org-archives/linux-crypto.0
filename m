Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A0C45948
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 13:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759324140; cv=none; b=pXlVubC5gBc/zNZrIV36LCxCZwpiUweTX128DeMQtLrSOVKoLyy9uISg+7WLLPOYkabN9x0fUOvz33SeFDDBB7kCfafxKfLPUbaK8RtQgiH4YCdQH7R/wMzNI2BfZHF0OxrjanEQQt7GS/x6lv6xIKLClgsFQNtHuN5JP0S440Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759324140; c=relaxed/simple;
	bh=NXombjEvK45v7hsR7SZUdrLFiOyXgZdEHiE9/56juIc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hMcLyIGqAnmfnfr3QTHZEGTrHNKjZxIhaIMZgCLgKNyFRc0huWi4+5VWEBo87HpZBpqS2xzQOZiPm/T+hFi7yX59Oihmjvn/LXtdNivq/D+DOy8fUIY8gapvRsJx6i2RnJgHdtMF4QZVW0oCejjIN4B1NNVo6oSxW9jWwKUYzXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JuQ2SXf2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JuQ2SXf2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759324138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WP3f0zOZ6OFcfw5W8xudfPi4PAAH25VCJR7O/Rt3NOU=;
	b=JuQ2SXf22h7nnbe8PgtvUL+v27W7Hx4zC71jHs7EO2a6NBWkN38mf7MDj4NzJqgf3cVmGz
	JrjgY/VEccGWTtvsqeoVa56s4niJVVwsQ9kLJIodJthXLpIH/dXGq7q38W3j/9nqzvMJsS
	WJMSDpRB9fCBR2ll+Vgbe1iXlMW9YOw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-I5eI6eFNO4-tFAinDILhJw-1; Wed,
 01 Oct 2025 09:08:55 -0400
X-MC-Unique: I5eI6eFNO4-tFAinDILhJw-1
X-Mimecast-MFC-AGG-ID: I5eI6eFNO4-tFAinDILhJw_1759324133
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5AE241800294;
	Wed,  1 Oct 2025 13:08:53 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BCB5F1956095;
	Wed,  1 Oct 2025 13:08:50 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/5] lib/crypto: Add SHAKE128/256 support and move SHA3 to lib/crypto
Date: Wed,  1 Oct 2025 14:08:39 +0100
Message-ID: <20251001130846.2284946-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Eric, Herbert,

Here's a set of patches does the following:

 (1) Renames s390 and arm64 sha3_* functions to avoid name collisions.

 (2) Copies the core of SHA3 support from crypto/ to lib/crypto/.

 (3) Simplifies the internal code to maintain the buffer in little endian
     form, thereby simplifying the update and extraction code which don't
     then need to worry about this.  Instead, the state buffer is
     byteswapped before and after.

 (4) Moves the Iota transform into the function with the rest of the
     transforms.

 (5) Adds SHAKE128 and SHAKE256 support (needed for ML-DSA).

 (6) Adds a kunit test for SHA3 in lib/crypto/tests/.

 (7) Adds proper API documentation for SHA3.

Note that only the generic code is moved across; the asm-optimised stuff is
not touched as I'm not familiar with that.

This is based on Eric's libcrypto-next branch.

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-pqc

David

Changes
=======
ver #4)
 - Fix a couple of arm64 build problems.
 - Doc fixes:
   - Fix the description of the algorithm to be closer to the NIST spec's
     terminology.
   - Don't talk of finialising the context for XOFs.
   - Don't say "Return: None".
   - Declare the "Context" to be "Any context" and make no mention of the
     fact that it might use the FPU.
   - Change "initialise" to "initialize".
   - Don't warn that the context is relatively large for stack use.
 - Use size_t for size parameters/variables.
 - Make the module_exit unconditional.
 - Dropped the crypto/ dir-affecting patches for the moment.

ver #3)
 - Renamed conflicting arm64 functions.
 - Made a separate wrapper API for each algorithm in the family.
 - Removed sha3_init(), sha3_reinit() and sha3_final().
 - Removed sha3_ctx::digest_size.
 - Renamed sha3_ctx::partial to sha3_ctx::absorb_offset.
 - Refer to the output of SHAKE* as "output" not "digest".
 - Moved the Iota transform into the one-round function.
 - Made sha3_update() warn if called after sha3_squeeze().
 - Simplified the module-load test to not do update after squeeze.
 - Added Return: and Context: kdoc statements and expanded the kdoc
   headers.
 - Added an API description document.
 - Overhauled the kunit tests.
   - Only have one kunit test.
   - Only call the general hash tester on one algo.
   - Add separate simple cursory checks for the other algos.
   - Add resqueezing tests.
   - Add some NIST example tests.
 - Changed crypto/sha3_generic to use this
 - Added SHAKE128/256 to crypto/sha3_generic and crypto/testmgr
 - Folded struct sha3_state into struct sha3_ctx.

ver #2)
  - Simplify the endianness handling.
  - Rename sha3_final() to sha3_squeeze() and don't clear the context at the
    end as it's permitted to continue calling sha3_final() to extract
    continuations of the digest (needed by ML-DSA).
  - Don't reapply the end marker to the hash state in continuation
    sha3_squeeze() unless sha3_update() gets called again (needed by
    ML-DSA).
  - Give sha3_squeeze() the amount of digest to produce as a parameter
    rather than using ctx->digest_size and don't return the amount digested.
  - Reimplement sha3_final() as a wrapper around sha3_squeeze() that
    extracts ctx->digest_size amount of digest and then zeroes out the
    context.  The latter is necessary to avoid upsetting
    hash-test-template.h.
  - Provide a sha3_reinit() function to clear the state, but to leave the
    parameters that indicate the hash properties unaffected, allowing for
    reuse.
  - Provide a sha3_set_digestsize() function to change the size of the
    digest to be extracted by sha3_final().  sha3_squeeze() takes a
    parameter for this instead.
  - Don't pass the digest size as a parameter to shake128/256_init() but
    rather default to 128/256 bits as per the function name.
  - Provide a sha3_clear() function to zero out the context.

David Howells (5):
  s390/sha3: Rename conflicting functions
  arm64/sha3: Rename conflicting functions
  lib/crypto: Add SHA3-224, SHA3-256, SHA3-384, SHA3-512, SHAKE128,
    SHAKE256
  lib/crypto: Move the SHA3 Iota transform into the single round
    function
  lib/crypto: Add SHA3 kunit tests

 Documentation/crypto/index.rst      |   1 +
 Documentation/crypto/sha3.rst       | 241 +++++++++++++
 arch/arm64/crypto/sha3-ce-glue.c    |  22 +-
 arch/s390/crypto/sha3_256_s390.c    |  26 +-
 arch/s390/crypto/sha3_512_s390.c    |  26 +-
 include/crypto/sha3.h               | 433 ++++++++++++++++++++++-
 lib/crypto/Kconfig                  |   7 +
 lib/crypto/Makefile                 |   6 +
 lib/crypto/sha3.c                   | 512 ++++++++++++++++++++++++++++
 lib/crypto/tests/Kconfig            |  12 +
 lib/crypto/tests/Makefile           |   1 +
 lib/crypto/tests/sha3_kunit.c       | 338 ++++++++++++++++++
 lib/crypto/tests/sha3_testvecs.h    | 231 +++++++++++++
 scripts/crypto/gen-hash-testvecs.py |   8 +-
 14 files changed, 1824 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/crypto/sha3.rst
 create mode 100644 lib/crypto/sha3.c
 create mode 100644 lib/crypto/tests/sha3_kunit.c
 create mode 100644 lib/crypto/tests/sha3_testvecs.h

