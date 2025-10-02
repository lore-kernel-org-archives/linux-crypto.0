Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E359238DF9
	for <linux-crypto@vger.kernel.org>; Thu,  2 Oct 2025 14:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759413816; cv=none; b=BgVEKxbDBW5sS/f/7QZ6ZzRv6T7rDXX+z+gf5ejNgo8kpD91YABDo9IE4Ng296s3pgMacUKcadkQVN8aelrSFyG/eKjivNGwY6rMkbi27N71hQ7tus8hGot1gwBwET6qKyGujP0o7o9+FPaY5Jo/Mron+xvqGR5lbguxQ3q2bCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759413816; c=relaxed/simple;
	bh=DSbgudIchH9DAt30RTp4fiNJ8PDEmcx8oxGKlwDPGfs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eVjwbxQiaM0tXUFucv40UM7iGwwqT7Bk5MeZMlIt9cPRDX2gn3bvoqLYt82Flvxg0cjx6PCpbiy52LaR1gnjJn5W/z5YeX9pzEWd7kFzwI+mdVoCvcRyT6rCUsI2S4/rOWb3nekuEY0MJiCiPjXrh8WsS7dsLY35TXQkjme1M28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GIlpTnbC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GIlpTnbC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759413813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NP8ldv0CyO1BcEgFjrm3XpdWSlmAVGwUojKxT2KIJbk=;
	b=GIlpTnbCOFLxyun9WTcNs6SsPzKekx6JJzsxLSzVDct5my/rkIeWFklPMcEZkWxAVToRk3
	2fFBjQfLEtG88PMhhV1mT+uGhbJRupMmuuFXCXDqC6YQi/JTPxnX8UKGIt5yc6u5G3kHA9
	S8LOvjpWgTY5ollmP+J0UFvtLYhnaU4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-215-1J_vkfy0Nmuiqp8IOMK2qQ-1; Thu,
 02 Oct 2025 10:03:29 -0400
X-MC-Unique: 1J_vkfy0Nmuiqp8IOMK2qQ-1
X-Mimecast-MFC-AGG-ID: 1J_vkfy0Nmuiqp8IOMK2qQ_1759413807
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 10E9619560AE;
	Thu,  2 Oct 2025 14:03:27 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 62A021953945;
	Thu,  2 Oct 2025 14:03:24 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/5] lib/crypto: Add SHAKE128/256 support and move SHA3 to lib/crypto
Date: Thu,  2 Oct 2025 15:03:14 +0100
Message-ID: <20251002140321.2639064-1-dhowells@redhat.com>
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
ver #5)
 - Fix gen-hash-testvecs.py to correctly handle algo names that contain a
   dash.
 - Fix gen-hash-testvecs.py to not generate HMAC for SHA3-* or SHAKE* as
   these don't currently have HMAC variants implemented.
 - Fix algo names to be correct.
 - Fix kunit module description as it now tests all SHA3 variants.

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
 lib/crypto/tests/Kconfig            |  11 +
 lib/crypto/tests/Makefile           |   1 +
 lib/crypto/tests/sha3_kunit.c       | 342 +++++++++++++++++++
 lib/crypto/tests/sha3_testvecs.h    | 231 +++++++++++++
 scripts/crypto/gen-hash-testvecs.py |  10 +-
 14 files changed, 1829 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/crypto/sha3.rst
 create mode 100644 lib/crypto/sha3.c
 create mode 100644 lib/crypto/tests/sha3_kunit.c
 create mode 100644 lib/crypto/tests/sha3_testvecs.h

