Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D4B380FC7
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 07:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786086488; cv=none; b=r1TRIJqHoVXibK7IhHoumaJ4IomXhhjC6BRG+IQkaNwyh2jU0k4scV7Knf0z99keNH2m3jLJUzALSLM9Ctd0it3k80Si/6gl3QUxiC3CVFL2aF/a/Bw6ywtkFxcMHK5KVfv2sJFUyDxU0Rtw3SyBJvG9B7NSg4BRiQolt9t8nbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786086488; c=relaxed/simple;
	bh=+2itxTEjDhgrlU9L38NydCzJu6wHqDD2rUYoPz/V1LE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AfdjqUybQPpV4LnIJAbnj+9C++4qL/X6wbH1KdaAx/JPYE6W1MHSDdBahyyTq7EHBdBdyJCVVPQMWmUXlB5SRJE//VdcThZOmh+At87FkikSVAnUGSfAlujYrL4j6zBYdBGqd1jeB/E8YLgneCdKdcHPskiKvReee4CogxxFEFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P2MLfNQw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P2MLfNQw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786086486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WOiZTBFOSfsy9vZtX7DJ7LasbDkxgrXTocmUP+i2rAs=;
	b=P2MLfNQwDKg5gOSUpdJLkLV59KNn7Pm0gFJHTQxICJ2GLOzM5cxkFuniDg+ZbdfYSm9/mq
	tc2IkiN4DQyrqUlcytRNN8BOA93ZQ12f8xLUS1owDHWzX5IjWbGGIRNZs90YZRnB+t6ctp
	rOvWDLXP2m4iQNeo5FPADSQ9gpzUGSI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-557-KN1QdOytN6agoIdBsuf2CA-1; Fri,
 07 Aug 2026 03:06:57 -0400
X-MC-Unique: KN1QdOytN6agoIdBsuf2CA-1
X-Mimecast-MFC-AGG-ID: KN1QdOytN6agoIdBsuf2CA_1786086416
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B1DB1800652;
	Fri,  7 Aug 2026 07:06:55 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 143661956094;
	Fri,  7 Aug 2026 07:06:52 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 00/10] crypto: Provide a function for zeroizing crypto_aes_ctx
Date: Fri,  7 Aug 2026 09:06:27 +0200
Message-ID: <20260807070651.228713-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Several crypto drivers need to zeroize their local crypto_aes_ctx
structures after use to avoid leaking key material on the stack.
Currently some call sites do this with their own memzero_explicit()
call, which is error-prone since it is easy to miss a return path
(what already happened in a driver). Some other call sites miss
to clear crypto_aes_ctx completely.

To improve this situation, the first patch introduces an aes_zeroize_ctx()
helper that can be used with __cleanup() to automatically zeroize the
context when it goes out of scope. The following 6 patches add this
__cleanup() to spots in the code where this has been forgotten so far.
The final patches change some files to do the zeroization with
the new __cleanup() way instead of calling memzero_explicit() manually.

v4:
- Updated the function description in the first patch
- Fixed "return err" bug in the "safexcel - Rework cleanup..." patch

v3:
- Renamed aes_clear_ctx() to aes_zeroize_ctx()
- Split up the safeexcel patch to rework safexcel_aead_setkey in a
  separate patch
- Removed goto in the padlock patch

v2:
- Rebased onto cryptodev master branch, updated the "qat" patch accordingly

Thomas Huth (10):
  crypto: Provide a wrapper function for zeroizing crypto_aes_ctx
  crypto: aspeed - clear the crypto_aes_ctx when done
  crypto: inside-secure/eip93 - clear the crypto_aes_ctx when done
  crypto: padlock-aes - clear the crypto_aes_ctx when done
  crypto: sa2ul - clear the crypto_aes_ctx when done
  crypto: arm/aes-neonbs - clear the crypto_aes_ctx when done
  crypto: arm64/aes-neonbs - clear the crypto_aes_ctx when done
  crypto: qat - zeroize crypto_aes_ctx with __cleanup(aes_zeroize_ctx)
  crypto: safexcel - Rework cleanup of sensitive structs in
    safexcel_aead_setkey
  crypto: safexcel - zeroize crypto_aes_ctx with
    __cleanup(aes_zeroize_ctx)

 arch/arm/crypto/aes-neonbs-glue.c             |  2 +-
 arch/arm64/crypto/aes-neonbs-glue.c           |  2 +-
 drivers/crypto/aspeed/aspeed-hace-crypto.c    |  3 +-
 .../crypto/inside-secure/eip93/eip93-aead.c   |  2 +-
 .../crypto/inside-secure/eip93/eip93-cipher.c |  2 +-
 .../crypto/inside-secure/safexcel_cipher.c    | 40 +++++++------------
 drivers/crypto/inside-secure/safexcel_hash.c  |  3 +-
 .../crypto/intel/qat/qat_common/qat_algs.c    |  3 +-
 drivers/crypto/padlock-aes.c                  | 22 +++++-----
 drivers/crypto/sa2ul.c                        |  2 +-
 include/crypto/aes.h                          | 13 ++++++
 11 files changed, 46 insertions(+), 48 deletions(-)

-- 
2.55.0

