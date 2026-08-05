Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508C6449B26
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 11:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785931080; cv=none; b=R0tHDUMOLNywG4Yby+xMnGpP1+dcYLfFj13juFJufC/sxZWgN152j47OcavZPIIlHrDnv8uq2czl54t/jsPMjXjSGw8MIfh8oJ/2pt36BKSFT6Zbmy43d9uQhe08GMlG768eH7KaXX8Efi9KTXaf7LJHdypIq6s8WDERvboTIRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785931080; c=relaxed/simple;
	bh=C6S596h1U8ThRBSG1Sa6HwQlPVw/6atgx1zgFCc25XM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=plgBjxqKARC6i1qqJaHDhlcz6Ar8LAJqNdEOWiYsmocg7aF4AXd233S11iYF5BWB497IUbzVDkMoLx4EwwnlLMhYNPZrzsMlQiwdACU+zafKpxIVzSXNPp11ug7sKr/WlRbXQqi5Ew6Bm6ZqzUrK1rlnnUFZCbfkjtT4ntPqsrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=buVbvNMc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="buVbvNMc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785931078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KAQau49K6PdbxBeKZpalhBihFhStP7jwxsPBUK/wej4=;
	b=buVbvNMcakOLF5Ai5Zz0JLYcrRwZ6u5qjJ+aYKMIWx+L5Vo2Cuh6ym1Yq8sgwsaAeQErlf
	DpLqTq+zD8Se49NKU27AhT2LMjtFtVv4OpGs4KVHTdiZhfVYdHasiSXLuRV5vpzZ/ecGJL
	2D0cAS9yw9X/MZtIU5/4n1J5VitTN6A=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-522-Y8HMHzytOamyQQToJgGOLg-1; Wed,
 05 Aug 2026 07:57:54 -0400
X-MC-Unique: Y8HMHzytOamyQQToJgGOLg-1
X-Mimecast-MFC-AGG-ID: Y8HMHzytOamyQQToJgGOLg_1785931073
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C7FB195608E;
	Wed,  5 Aug 2026 11:57:53 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.202])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C06730001A2;
	Wed,  5 Aug 2026 11:57:50 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 00/10] crypto: Provide a function for zeroizing crypto_aes_ctx
Date: Wed,  5 Aug 2026 13:57:38 +0200
Message-ID: <20260805115749.392672-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

