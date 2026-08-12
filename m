Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6DC45C6E3
	for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 16:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786552442; cv=none; b=uUuKyQLIkx2YCUR+1CgzBDVnOCgIEcqmAAYa9t3lfuNvsQKK2vynYlWt9vm5cRLEWcFXRb/QCT5v1ejF+ixReUn2l9QNNVyNPAhChhJb3QVX2XCMXfJyZdaoLVU+qON8C8tKje2kf7zHRrasalom00e1BlhNGCBW/ekvnZdielw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786552442; c=relaxed/simple;
	bh=NDp3Vd12rzkA/ZJykS/xD+g+JQZQBLffiGBXkCzfwnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n0PBJFW2vI+0beQ/wUKBqsU39sEfS6WeS9OsTKr/OZ8a3QyylR3l+7PTJnNaYydDEmczBBih85FKDVXBBE95gcr6FnP/qHPvuIzGNMUb22J9RdL2FPw3zuem76R8NLbmnzqcCKR/v4uhtY4MlxCcSHWIMXbErzRV3Aczg9iCiBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CpnMRN+k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CpnMRN+k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786552439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RkjfW0V6QK9jLNGp2NUwa62pkh9v96iM8ZiETmKV+W4=;
	b=CpnMRN+kWal4nE+NWyQ+M2Uydc8asLENAv6ZCs5HphPLjuvdGVfRj7EVeIu+jFFWNEYPqu
	b1eoYq3EwbkLYpj5lG2RDlaopUpK9SjBTdk4muiNKuO13MzObTHsw9dpnyWXXXziKkkkPA
	lrgeX3UuYKIDz7vUeyV6U4+nkNCFpK4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-ky4p98H3NMujqn4BMh4hrA-1; Wed,
 12 Aug 2026 12:33:46 -0400
X-MC-Unique: ky4p98H3NMujqn4BMh4hrA-1
X-Mimecast-MFC-AGG-ID: ky4p98H3NMujqn4BMh4hrA_1786552424
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F102180064B;
	Wed, 12 Aug 2026 16:33:43 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C93473001DAF;
	Wed, 12 Aug 2026 16:33:37 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Mimi Zohar <zohar@linux.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH 0/3] lib/crypto: Provide a function for zeroizing hmac_sha1_ctx
Date: Wed, 12 Aug 2026 18:33:33 +0200
Message-ID: <20260812163336.3103835-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

It's maybe not worth the effort for hmac_sha1_ctx right now (since there
is only one spot that forgot to zeroize the structure in case of errors),
but offering a function for zeroizing the data via __cleanup might help to
get future code into the proper shape right from the start. Thus let's
introduce a hmac_sha1_zeroize_ctx() function now and use it in the
appropriate spots.

Thomas Huth (3):
  crypto: Provide a wrapper for zeroizing hmac_sha1_ctx
  security: keys: trusted: always clear the hmac_sha1_ctx before
    returning
  lib/crypto: sha1: Use hmac_sha1_zeroize_ctx() instead of
    memzero_explicit()

 include/crypto/sha1.h                     | 17 +++++++++++++++++
 lib/crypto/sha1.c                         |  2 +-
 security/keys/trusted-keys/trusted_tpm1.c |  2 +-
 3 files changed, 19 insertions(+), 2 deletions(-)

-- 
2.55.0

