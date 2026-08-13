Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045A8481231
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 13:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629019; cv=none; b=hySDt5ei0AQoMfMcUx9N/wnMrwk8vmX4VMJicb/ogN6+AN68MxLmD8T7XGU5MifUS1gAOOnhlechD+cVe/nlg17iMzMEmG4a9bPQa9K1mkr6AW74Rv6hwG349yBD3b2iwOzzs7BV4Edk1oiMpLlptxI0rLLTubvI+oPt/YyAzn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629019; c=relaxed/simple;
	bh=ZbTsJ0WTVaLWuBTjaby7coUT1iY0xb/DnzZo2l6c8t0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DYZ2GIJqzJjMKz7pfwFfH1JzxYFZ4cW0x/v0dfY6XTA4q+WRSKWNM4Uabf+hDGy/XlKbmrr/yahSB8NkWYilPtnMys0TOxXO/QXXBVMk/GrgJwci/KIC+8s6xCkbKX92KaL+1sbr7+WENJfxckM9dLSjw+fSg4GZPV1/6M+PeKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BzgMJ68h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BzgMJ68h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786629017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5HM1KwGTRWBEwfF6aCOsdB2xe40B6m+QMgcrbZdcy3A=;
	b=BzgMJ68hPfCniEJ/fH6wYwpkCq4RV2LalQ3RXXbo0UX4ymoiMAX1hbqnl+XRL8c58Qjro0
	V7zyLtsmabd11gVPOwCQdHB1vrFGZUH+j8d7jAwzJjt0PExSIhpUIq1mopPLDR9TUaq9QA
	g8BQjm5onj5bdhnxg+v+JnF7cpapgho=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-22-lnrK56-WPRmlhlg6op6ZSQ-1; Thu,
 13 Aug 2026 09:50:00 -0400
X-MC-Unique: lnrK56-WPRmlhlg6op6ZSQ-1
X-Mimecast-MFC-AGG-ID: lnrK56-WPRmlhlg6op6ZSQ_1786628999
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9383619560AB;
	Thu, 13 Aug 2026 13:49:58 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3E5791800348;
	Thu, 13 Aug 2026 13:49:54 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: x86@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] libcrypto: Provide more __cleanup functions for zeroizing data
Date: Thu, 13 Aug 2026 15:49:38 +0200
Message-ID: <20260813134953.979481-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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
needs separate review from the corresponding maintainer). However, I
already included the two "safexcel" patches, since they already got ack'ed
by the maintainer Antoine, so I think they should be fine to go via the
libcrypto tree.

Note there is one minor ugliness in patch 10: Since sha2.h is also used
in the x86 purgatory code, and that code ships with its own implementation
of string functions, we have to compile the purgatory.c file with
-D__NO_FORTIFY now to be able to include <linux/string.h> in sha2.h.
I hope that solution is OK (especially since the sha256.c file in the
same folder gets that treatment already, too), if not - I'm certainly
open for other suggestions here!

Thomas Huth (11):
  lib/crypto: aes: Provide a wrapper function for zeroizing
    crypto_aes_ctx
  crypto: safexcel - Simplify the check for a valid AES key
  crypto: safexcel - zeroize crypto_aes_ctx with
    __cleanup(aes_zeroize_ctx)
  lib/crypto: aes: Provide functions for zeroizing aes_key and
    aes_enckey
  lib/crypto: aes: Use aes_zeroize_*key() instead of memzero_explicit()
  lib/crypto: md5: Provide a function for zeroizing hmac_md5_ctx
    structures
  lib/crypto: md5: Use hmac_md5_zeroize_ctx() instead of
    memzero_explicit()
  lib/crypto: sha1: Provide a wrapper for zeroizing hmac_sha1_ctx
  lib/crypto: sha1: Use hmac_sha1_zeroize_ctx() instead of
    memzero_explicit()
  x86/purgatory: Compile purgatory.c with -D__NO_FORTIFY
  lib/crypto: sha2: Provide wrappers for zeroizing SHA2 hmac_sha*_ctx
    structures

 arch/x86/purgatory/Makefile                   |  1 +
 .../crypto/inside-secure/safexcel_cipher.c    | 16 ++----
 drivers/crypto/inside-secure/safexcel_hash.c  |  3 +-
 include/crypto/aes.h                          | 40 +++++++++++++
 include/crypto/md5.h                          | 15 +++++
 include/crypto/sha1.h                         | 17 ++++++
 include/crypto/sha2.h                         | 57 +++++++++++++++++++
 lib/crypto/aes.c                              | 10 ++--
 lib/crypto/md5.c                              |  2 +-
 lib/crypto/sha1.c                             |  2 +-
 10 files changed, 143 insertions(+), 20 deletions(-)

-- 
2.55.0

