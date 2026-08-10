Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26913B059B
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 09:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786354226; cv=none; b=WhH18SPN5q/A/qA6A/vJ2rg6BDaG6F72MNr/DD1dUbtrgi1QxmxEOcIf7L5MuJpmwCr7vgW4MFR0SeBgYA5Dec6fsQE9ZPTJEqrzcbaSiQIbepNv8wKBNUqXx+b3BTzclhr3hWR4tGqqvQqKDWxcvWRgaABvRwHFPvG/XunNwvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786354226; c=relaxed/simple;
	bh=DQ/AEtXWDmv29NELNsr6W3wQP1FdSNHmT4LhXDj2H9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mhzTltnvUsdAYXkUpa/JT6eEWmbkQRlQ+SCSPuh/rPZN58ZDddMP/YYf/ryMiE992s8wM6ePPgxRyt/ubZi2TY5S/q53gTtvqnnGQUSQduaHusN3JZNkneWHwi05U6MZGZOdJ6SlTDKN/yyP0W6TxRNLlnVNLUBpUUdo6eWDxac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AY3F3j5R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AY3F3j5R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786354222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aGyrDBtnIXBQCmBfFGRjNkHONdkkOB3bpTtf07YeKno=;
	b=AY3F3j5RzEa/sWVu9JE+Rmzc68VYF8/Mcr3T4zaywHgFiwaRnULb2+dUinPTY9c8o1naPM
	NwFoEtZUxF2Q375sbtYsUCC3v5BO5Kr3G4EvqMiBJxKlF6Euex/sMLNz9QlWQaAd41pbvE
	lhNdZ0rGZf+SZzj/ex92zVkN/boHnvE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-557-nNlGgP44Ng2wvgLOltQ0aw-1; Mon,
 10 Aug 2026 05:30:16 -0400
X-MC-Unique: nNlGgP44Ng2wvgLOltQ0aw-1
X-Mimecast-MFC-AGG-ID: nNlGgP44Ng2wvgLOltQ0aw_1786354215
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87ECA1954B0F;
	Mon, 10 Aug 2026 09:30:13 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C6813001D3A;
	Mon, 10 Aug 2026 09:30:10 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org,
	Antoine Tenart <atenart@kernel.org>
Subject: [PATCH v5 00/10] crypto: Provide a function for zeroizing crypto_aes_ctx
Date: Mon, 10 Aug 2026 11:29:55 +0200
Message-ID: <20260810093009.608090-1-thuth@redhat.com>
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

v5:
- Use aes_check_keylen() in the eip93 patch and in the 1st safexcel patch

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
  crypto: padlock-aes - clear the crypto_aes_ctx when done
  crypto: sa2ul - clear the crypto_aes_ctx when done
  crypto: arm/aes-neonbs - clear the crypto_aes_ctx when done
  crypto: arm64/aes-neonbs - clear the crypto_aes_ctx when done
  crypto: qat - zeroize crypto_aes_ctx with __cleanup(aes_zeroize_ctx)
  crypto: safexcel - Simplify the check for a valid AES key
  crypto: safexcel - zeroize crypto_aes_ctx with
    __cleanup(aes_zeroize_ctx)
  crypto: eip93 - Simplify the check for a valid AES key

 arch/arm/crypto/aes-neonbs-glue.c             |  2 +-
 arch/arm64/crypto/aes-neonbs-glue.c           |  2 +-
 drivers/crypto/aspeed/aspeed-hace-crypto.c    |  3 +--
 .../crypto/inside-secure/eip93/eip93-aead.c   |  3 +--
 .../crypto/inside-secure/safexcel_cipher.c    | 16 +++++---------
 drivers/crypto/inside-secure/safexcel_hash.c  |  3 +--
 .../crypto/intel/qat/qat_common/qat_algs.c    |  3 +--
 drivers/crypto/padlock-aes.c                  | 22 +++++++++----------
 drivers/crypto/sa2ul.c                        |  2 +-
 include/crypto/aes.h                          | 13 +++++++++++
 10 files changed, 35 insertions(+), 34 deletions(-)

-- 
2.55.0

