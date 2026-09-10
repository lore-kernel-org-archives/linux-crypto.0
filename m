Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DC74BFE9F
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 12:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789044113; cv=none; b=KnJE8Jjgh/dLQHeBCfTLkvEh3NpLsFSo25Nrc3GwRsP4ABRPMXmhVDoJ+h1yriKz5zPJOVbmeB3ipdiG9oMOYKtKkUh0KMAa4biAc4MDP4tqwCI6poJwES0yHDG0hsF41h0DnVK5byaQx83uoAPLR7SEngkhsf20B2sNHrnRjlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789044113; c=relaxed/simple;
	bh=4vxzKrnv2JllHNizh3Y1G1b9R2X7Bo68Ih31K/fl/EU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aJX6tNaumyrriovx/rRvajSDt1dIuD/YQ0eU9lI2SdsFmHs1d+aqlo7PGl1br2pGWxgzBQccvO0wk+VUEYXY/6tlS8tAAWkbAizEPiaw/5JGDW66bT6UXkLv/JTvZRJ0QW41Kl1jjsNjJvDOYXZ+73DDJA6r8MqWahalqLfEV6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CgAKFeXh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CgAKFeXh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789044110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sj/7Juy6QvKAcHbVPloSfwE//2kWf08qu5nTC4cFTmM=;
	b=CgAKFeXh/ceNUkgbEouY9/mj6hOlI+MGnbN5hUKksc+T0G5kaJAj5/tOFblKoOdA5pwiZi
	hOm3FgF0UePTbBmAripEV3kOsPiEwsQDB5bAIucBvDYnKizn+sA7TwALm0SrkVLikRVtTa
	ZeJ3gbpCJv8mKnGndCDKTT4DCChfj9g=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-q2ZTHy4RM0C4TtrRqq4IIQ-1; Thu,
 10 Sep 2026 08:41:46 -0400
X-MC-Unique: q2ZTHy4RM0C4TtrRqq4IIQ-1
X-Mimecast-MFC-AGG-ID: q2ZTHy4RM0C4TtrRqq4IIQ_1789044105
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D40151954238;
	Thu, 10 Sep 2026 12:41:43 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A9F3E30001A2;
	Thu, 10 Sep 2026 12:41:39 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v3 00/13] libcrypto: Provide more __cleanup functions for zeroizing data
Date: Thu, 10 Sep 2026 14:41:19 +0200
Message-ID: <20260910124138.417439-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Code that uses crypto-related structures (containing keys or context data)
should zeroize their local structures on the stack after use to avoid
leaking this sensitive material via the stack when the function returns.
Using the __cleanup() marker is a very elegant way to assert that the
data is zeroized without having to painfully verify that each early return
in a function might miss it.

Thus this series introduces zeroization functions for many crypto-related
structures that can be used with __cleanup(). The series focuses on the
introduction of the functions - most call sights will be adjusted to use
these new functions in separate patch series later (since each subsystem
needs separate review from the corresponding maintainer).

Note there is one minor ugliness in the patch "Compile purgatory.c with
-D__NO_FORTIFY":  Since sha2.h is also used in the x86 purgatory code,
and that code ships with its own implementation of string functions, we
have to compile the purgatory.c file with -D__NO_FORTIFY now to be able
to include <linux/string.h> in sha2.h. I hope that solution is OK
(especially since the sha256.c file in the same folder gets that treatment
already, too), if not - I'm certainly open for other suggestions here!

v3:
- Don't put function names into ``quotes`` in the last patch, so the
  cross-references will be generated right now.
- Added a missing #include <linux/string.h> in the sm3 patch

v2:
- Dropped some patches that have been picked up elsewhere already
- Merged the patches that introduce the zeroization functions and
  that update the callsites in lib/crypto/ - I think reviewing is
  easier this way
- Add more patches to zeroize structs that weren't handled in v1 yet
- Keep the kerneldoc comments simple and add a final patch for the
  Documentation folder instead that describes the zeroization needs.

Thomas Huth (13):
  lib/crypto: aes: Provide functions for zeroizing aes_key and
    aes_enckey
  lib/crypto: aes-xts: Provide function for zeroizing aes_xts_key
  lib/crypto: aes-gcm: Provide functions for zeroizing aes_gcm*
    structures
  lib/crypto: aes-ccm: Provide functions for zeroizing aes_ccm*
    structures
  lib/crypto: md5: Provide a function for zeroizing hmac_md5 structures
  lib/crypto: sm3: Provide a function for zeroizing the sm3_ctx
    structure
  lib/crypto: blake2: Provide functions for zeroizing blake2*_ctx
    structures
  lib/crypto: sha1: Provide functions for zeroizing hmac_sha1 structures
  security: keys: trusted: always clear the hmac_sha1_ctx before
    returning
  x86/purgatory: Compile purgatory.c with -D__NO_FORTIFY
  lib/crypto: sha2: Provide functions for zeroizing SHA2 hmac_sha*
    structures
  smb: client: Use hmac_sha256_zeroize_ctx function to clear
    hmac_sha256_ctx
  lib/crypto: Add documentation about zeroization of key and context
    data

 .../crypto/libcrypto-zeroization.rst          | 129 ++++++++++++++++++
 Documentation/crypto/libcrypto.rst            |   1 +
 arch/x86/purgatory/Makefile                   |   1 +
 fs/smb/client/smb2transport.c                 |   3 +-
 include/crypto/aes-ccm.h                      |  22 ++-
 include/crypto/aes-gcm.h                      |  22 ++-
 include/crypto/aes-xts.h                      |  13 +-
 include/crypto/aes.h                          |  18 +++
 include/crypto/blake2b.h                      |   9 ++
 include/crypto/blake2s.h                      |   9 ++
 include/crypto/md5.h                          |  19 +++
 include/crypto/sha1.h                         |  19 +++
 include/crypto/sha2.h                         |  73 ++++++++++
 include/crypto/sm3.h                          |  10 ++
 lib/crypto/aes.c                              |  28 ++--
 lib/crypto/blake2b.c                          |   2 +-
 lib/crypto/blake2s.c                          |   2 +-
 lib/crypto/md5.c                              |   2 +-
 lib/crypto/sha1.c                             |   2 +-
 lib/crypto/sm3.c                              |   2 +-
 security/keys/trusted-keys/trusted_tpm1.c     |   2 +-
 21 files changed, 358 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/crypto/libcrypto-zeroization.rst

-- 
2.55.0

