Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBBC388397
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 14:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785940591; cv=none; b=ddAkWUob89DFquFMJVIuSoRSVxdM2e3FKVTFLJBHUEeJHJzrLBilcg5Q3zFsp86qPZSgPKhGvag149I1LtZ1WXC1N6RhQGQgcJRjgNQHveKcMcdvaRZVVlgNLn0htM+zy6b37iOCM5UA+RfspsHZoi7+0e6A6ftYaB0wnehy1Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785940591; c=relaxed/simple;
	bh=UYL6My7pm3tLGKpGXlZ1D4SGTN84LEoa1eCoh39+Lj4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V/5oqQbG2vegwQAqGWdLq9FMLgel7PcQ9oLJWKRP72Ml7pHrV2zm2cEBIwo39K4Jo8WuPbQOIJLhs63ZgRFMxpOTKoffIo6a3+13EeqbCxcJ9AR91uPJee+xtLUiBcfy3riQtvt73pAevTzrJ+3h0XnSmUwXqd/igu5NEWMs8R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PA/4AC9X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PA/4AC9X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785940579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yRIJ1CGU9Af4njTkw1E2I6Cet+jMYujQY22MYML5uxY=;
	b=PA/4AC9XZO+idL1zyNbypG4jy9B264shlXoeiYwRXpJEL/AvHw/5vj8u24O8kHxjolg/AL
	R6KcXKKNZJv7CrQ8JUfboBPszwPCPnUwPDTQJiE/Os/5IvLu2ZWcYrnt/th/e9TPEytlQu
	u1zEXYEbvkRPE18ShvpxHSjMd4HkbvA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-ztoOZ_Y2Mzik7iJzhVIydg-1; Wed,
 05 Aug 2026 10:36:16 -0400
X-MC-Unique: ztoOZ_Y2Mzik7iJzhVIydg-1
X-Mimecast-MFC-AGG-ID: ztoOZ_Y2Mzik7iJzhVIydg_1785940575
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 663F81800655;
	Wed,  5 Aug 2026 14:36:15 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.209])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 31CB41800598;
	Wed,  5 Aug 2026 14:36:12 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] crypto: Add __cleanup functions for zeroizing aes_cmac_key & aes_cmac_ctx
Date: Wed,  5 Aug 2026 16:36:03 +0200
Message-ID: <20260805143611.818559-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Code that uses AES-CMAC might need to zeroize their local aes_cmac_key
and/or aes_cmac_ctx structures after use to avoid leaking sensitive
material on the stack.

The first patch introduces an aes_cmac_zeroize_key() and an
aes_cmac_zeroize_ctx() helper function that can be used with __cleanup()
to automatically clear the key and context when they go out of scope.

Patches 2 - 3 add the __cleanup markers to spots in the code that
missed to clean up the structures so far.

The final two patches are just cosmetics and change some memzero_explicit()
calls to use the __cleanup() way instead.

Thomas Huth (6):
  crypto: Provide wrapper functions for zeroizing aes_cmac_key and
    aes_cmac_ctx
  smb: clear the aes_cmac_key and aes_cmac_ctx when done
  net/tcp-ao: clear the aes_cmac_key when done
  Bluetooth: SMP: clear the aes_cmac_key when done
  lib/crypto: aes: Use _cleanup() for aes_cmac_key instead of
    memzero_explicit()
  mac80211: fils_aead: Use _cleanup for aes_cmac_key instead of
    memzero_explicit

 fs/smb/client/smb2transport.c |  4 ++--
 fs/smb/server/auth.c          |  2 +-
 include/crypto/aes-cbc-macs.h | 26 ++++++++++++++++++++++++++
 lib/crypto/aes.c              |  3 +--
 net/bluetooth/smp.c           |  2 +-
 net/ipv4/tcp_ao.c             |  2 +-
 net/mac80211/fils_aead.c      |  3 +--
 7 files changed, 33 insertions(+), 9 deletions(-)

-- 
2.55.0

