Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B00422A1E4
	for <linux-crypto@vger.kernel.org>; Mon, 10 Mar 2025 12:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741611250; cv=none; b=did/4wnWlfUna1czijjRd1PdYSlRzuFiEjnugPu9eXXdua31dQYST0my3ki4/mFhZGG8AuDzMHqjgNkdwAIVqNNuPJELcZXakjBkmO1SropTKCqgpcJttRChEkECIh/wUH3xtUZjQrDAjchAY6kBU/4A4uolB/ffpn0JK2L7YYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741611250; c=relaxed/simple;
	bh=xsKwuaT+kl/9LxkTzq9+F+i2EjGR0W72fihNUXW6VbA=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=Sb/1HeYxrAa6/Cywr4GsjMlvZaFO0hMv8Udk0jPaKaRvY1n5QJeLH6Lv7Jh0/miZFfQTL+lcALtcjv++GqKqm6CLPsEwW+xXW+5GWGvSzUvO1A/USpwVz3L2OhVcjreOxwJVtEyG4PVjEbkrnNJlzICbaUgqvT7ZrH6Yy9f6hAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fgCvehcY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fgCvehcY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741611246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QOWCKaCbmlFC0Efy5SeEAE0DBijaDRqz9slfsvo05nc=;
	b=fgCvehcY+MVj+z425s1kTpge7J7Bh6zdzlAgdTtWwgqDRz1usqAPPeFBVsIAPTxMC8YpIa
	jAOSPzAtFuxgrE3dBCCGjAifqzdWw/NWKNX26uPebEq3rI7E2XB8sMKhyezjf2Au/IpI1b
	XNdHUcrQtPyKoIYgdzLAWQjfWsvbXUk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-155-jIPLHhpaPTWVNadJ5e4jKQ-1; Mon,
 10 Mar 2025 08:54:03 -0400
X-MC-Unique: jIPLHhpaPTWVNadJ5e4jKQ-1
X-Mimecast-MFC-AGG-ID: jIPLHhpaPTWVNadJ5e4jKQ_1741611241
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4531B1955D6C;
	Mon, 10 Mar 2025 12:54:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.61])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DC13B1828A8C;
	Mon, 10 Mar 2025 12:53:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
    Marc Dionne <marc.dionne@auristor.com>,
    Jakub Kicinski <kuba@kernel.org>,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
    Simon Horman <horms@kernel.org>,
    Chuck Lever <chuck.lever@oracle.com>, linux-crypto@vger.kernel.org,
    linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: [GIT PULL net-next] crypto: Add Kerberos crypto lib
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <953586.1741611236.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 10 Mar 2025 12:53:56 +0000
Message-ID: <953587.1741611236@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi,

Could you pull this into the net-next tree please (it has been pulled into
the crypto tree[1])?  This provides the Kerberos-5 crypto parts needed by
the AF_RXRPC RxGK (GSSAPI) security class.  In the future, it could also b=
e
used by NFS and SunRPC as much of the code is abstracted from there.  This
is a prerequisite for the rxrpc patches[2].

It does a couple of things:

 (1) Provide an AEAD crypto driver, krb5enc, that mirrors the authenc
     driver, but that hashes the plaintext, not the ciphertext.  This was
     made a separate module rather than just being a part of the authenc
     driver because it has to do all of the constituent operations in the
     opposite order - which impacts the async op handling.

     Testmgr data is provided for AES+SHA2 and Camellia combinations of
     authenc and krb5enc used by the krb5 library.  AES+SHA1 is not
     provided as the RFCs don't contain usable test vectors.

 (2) Provide a Kerberos 5 crypto library.  This is an extract from the
     sunrpc driver as that code can be shared between sunrpc/nfs and
     rxrpc/afs.  This provides encryption, decryption, get MIC and verify
     MIC routines that use and wrap the crypto functions, along with some
     functions to provide layout management.

     This supports AES+SHA1, AES+SHA2 and Camellia encryption types.

     Self-testing is provided that goes further than is possible with
     testmgr, doing subkey derivation as well.

David

Link: https://lore.kernel.org/linux-crypto/3709378.1740991489@warthog.proc=
yon.org.uk/ [1]
Link: https://web.git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-f=
s.git/log/?h=3Drxrpc-next [2]

---
The following changes since commit 1e15510b71c99c6e49134d756df91069f7d1814=
1:

  Merge tag 'net-6.14-rc5' of git://git.kernel.org/pub/scm/linux/kernel/gi=
t/netdev/net (2025-02-27 09:32:42 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags=
/crypto-krb5-20250228

for you to fetch changes up to 0dd8f8533a833eeb8e51034072a59930bcbec725:

  crypto/krb5: Implement crypto self-testing (2025-02-28 09:42:42 +0000)

----------------------------------------------------------------
crypto: Add Kerberos crypto lib

----------------------------------------------------------------
David Howells (17):
      crypto/krb5: Add API Documentation
      crypto/krb5: Add some constants out of sunrpc headers
      crypto: Add 'krb5enc' hash and cipher AEAD algorithm
      crypto/krb5: Test manager data
      crypto/krb5: Implement Kerberos crypto core
      crypto/krb5: Add an API to query the layout of the crypto section
      crypto/krb5: Add an API to alloc and prepare a crypto object
      crypto/krb5: Add an API to perform requests
      crypto/krb5: Provide infrastructure and key derivation
      crypto/krb5: Implement the Kerberos5 rfc3961 key derivation
      crypto/krb5: Provide RFC3961 setkey packaging functions
      crypto/krb5: Implement the Kerberos5 rfc3961 encrypt and decrypt fun=
ctions
      crypto/krb5: Implement the Kerberos5 rfc3961 get_mic and verify_mic
      crypto/krb5: Implement the AES enctypes from rfc3962
      crypto/krb5: Implement the AES enctypes from rfc8009
      crypto/krb5: Implement the Camellia enctypes from rfc6803
      crypto/krb5: Implement crypto self-testing

 Documentation/crypto/index.rst   |   1 +
 Documentation/crypto/krb5.rst    | 262 +++++++++++++
 crypto/Kconfig                   |  13 +
 crypto/Makefile                  |   3 +
 crypto/krb5/Kconfig              |  26 ++
 crypto/krb5/Makefile             |  18 +
 crypto/krb5/internal.h           | 247 ++++++++++++
 crypto/krb5/krb5_api.c           | 452 ++++++++++++++++++++++
 crypto/krb5/krb5_kdf.c           | 145 +++++++
 crypto/krb5/rfc3961_simplified.c | 797 ++++++++++++++++++++++++++++++++++=
+++++
 crypto/krb5/rfc3962_aes.c        | 115 ++++++
 crypto/krb5/rfc6803_camellia.c   | 237 ++++++++++++
 crypto/krb5/rfc8009_aes2.c       | 362 ++++++++++++++++++
 crypto/krb5/selftest.c           | 544 ++++++++++++++++++++++++++
 crypto/krb5/selftest_data.c      | 291 ++++++++++++++
 crypto/krb5enc.c                 | 504 +++++++++++++++++++++++++
 crypto/testmgr.c                 |  16 +
 crypto/testmgr.h                 | 351 +++++++++++++++++
 include/crypto/authenc.h         |   2 +
 include/crypto/krb5.h            | 160 ++++++++
 20 files changed, 4546 insertions(+)
 create mode 100644 Documentation/crypto/krb5.rst
 create mode 100644 crypto/krb5/Kconfig
 create mode 100644 crypto/krb5/Makefile
 create mode 100644 crypto/krb5/internal.h
 create mode 100644 crypto/krb5/krb5_api.c
 create mode 100644 crypto/krb5/krb5_kdf.c
 create mode 100644 crypto/krb5/rfc3961_simplified.c
 create mode 100644 crypto/krb5/rfc3962_aes.c
 create mode 100644 crypto/krb5/rfc6803_camellia.c
 create mode 100644 crypto/krb5/rfc8009_aes2.c
 create mode 100644 crypto/krb5/selftest.c
 create mode 100644 crypto/krb5/selftest_data.c
 create mode 100644 crypto/krb5enc.c
 create mode 100644 include/crypto/krb5.h

