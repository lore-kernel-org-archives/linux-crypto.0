Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05749471436
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 12:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786107545; cv=none; b=mgikHZqjcr44y3LepmDMTZhik9AJHsMhc7Fg+994zWNMW10qfQvy1SwewaRA8a0xMsUUbSGVj6hfqCC2y37xeX3yEiGm8gunOlu720FEkTQUEO55QcoYlmlM2Lbux5Bhjn2SeCaOQ+osW/kNAKE9QsxrI42dN6h8CPYtJSFgf84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786107545; c=relaxed/simple;
	bh=ic15TBQA87sZ6aCnKPTY/mG0uoAX/3RGeuPprGL2JCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jKGTCnDpFbAKqV1HZDCBtHiULBT+KKx83mRQtQVGti/DCB1jkq4t3lTrp+xpG/6U5SnuGPw32hZpsbSF1ZltaKWYfP/FGvV+e10bIRrg+4DlOd+XjfQkpTNFcHXf9hCe29tjUnWJBIdJccWTDI++h7+iLoCakE7WXoBosS2bcuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SgE5oOJF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SgE5oOJF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786107534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=q87bLIat8PUuHfoyR9lXtePJB5sfUijAF/hC2U03Goo=;
	b=SgE5oOJFT/OHGF9eb+nPe1FS8d/LGgtkIcIb1w30vXD9ktVQBn6LDIW1CCNJq+QDWXM07S
	F7QnaOhPAV5wsa6CgSrahwNtKHBNClv60B4Fq9PXa7u+TsOJs8C89DD1+c6+fdqR+er0Ho
	TaGdhzAOZi5zu4rss0U/QLgsFBKeC3I=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-674-oe_4pOwHPoKTeK2Z1nPJEQ-1; Fri,
 07 Aug 2026 08:58:51 -0400
X-MC-Unique: oe_4pOwHPoKTeK2Z1nPJEQ-1
X-Mimecast-MFC-AGG-ID: oe_4pOwHPoKTeK2Z1nPJEQ_1786107530
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C409C19560AB;
	Fri,  7 Aug 2026 12:58:49 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 04A0530001A2;
	Fri,  7 Aug 2026 12:58:46 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 0/6] crypto: Add __cleanup functions for zeroizing aes_cmac_key & aes_cmac_ctx
Date: Fri,  7 Aug 2026 14:58:37 +0200
Message-ID: <20260807125845.1477067-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Code that uses AES-CMAC might need to zeroize their local aes_cmac_key
and/or aes_cmac_ctx structures after use to avoid leaking sensitive
material on the stack.

The first patch introduces an aes_cmac_zeroize_key() and an
aes_cmac_zeroize_ctx() helper function that can be used with __cleanup()
to automatically clear the key and context when they go out of scope.

Patches 2 - 4 add the __cleanup markers to spots in the code that
missed to clean up the structures so far.

The final two patches are just cosmetics and change some memzero_explicit()
calls to use the __cleanup() way instead.

Note: There are more spots in the smb, tcp-ao and bluetooth code that
need some zeroization of sensitive data on the stack. I will tackle
those in later patches, this series here focuses on the new __cleanup
wrappers.

v2:
- Update comments and positions of the functions in the 1st patch
- Also clear tmp[] in the bluetooth patch (the patch is pointless otherwise)

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
 include/crypto/aes-cbc-macs.h | 34 ++++++++++++++++++++++++++++++++++
 lib/crypto/aes.c              |  3 +--
 net/bluetooth/smp.c           |  3 ++-
 net/ipv4/tcp_ao.c             |  2 +-
 net/mac80211/fils_aead.c      |  3 +--
 7 files changed, 42 insertions(+), 9 deletions(-)

-- 
2.55.0

