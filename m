Received: from smtpcmd0642.aruba.it (smtpcmd0642.aruba.it [62.149.156.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD47A20126A
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 08:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757925834; cv=none; b=bNdC5QB/+xHhHMzT2b8jPDHBBOIjLSHL13KDTFiH9YRwI2onuZKPIhljY05RfAkmJaZ1sQ+odNG0x3Mj1hDOa8vo+UNZlY8Cj76qYbwNtiQtY5n0onRiGuop+HzPovBZSfkbiWrLM0lK2si11J5sgH4kvz5WbSyUD9P68ZQ66oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757925834; c=relaxed/simple;
	bh=FtiiLUfD5X9Tzkf79Y/E13biPfmUFzyk4R0bUCoQWB4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZMEQ3mfwCYtF9IWVoNe7WbKYeDNGP6CcApzp6Nuy6Bvrb4H46EEI0yl8izLM/QE4Ju2u1aLP2oRxfn1J27kZYWeGjFzwP/icGiVUBNzGKZNLH3jiCtnZK95MzrRLJLhXovzzKvx0Db5R6sHx3ClAmTUAw8gxFSEWKZ++heIgbwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com; spf=pass smtp.mailfrom=enneenne.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=OD++8e7d; arc=none smtp.client-ip=62.149.156.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="OD++8e7d"
Received: from polimar.homenet.telecomitalia.it ([79.0.204.227])
	by Aruba SMTP with ESMTPSA
	id y4lLumNEnL0Iyy4lMuiWhb; Mon, 15 Sep 2025 10:40:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1757925641; bh=FtiiLUfD5X9Tzkf79Y/E13biPfmUFzyk4R0bUCoQWB4=;
	h=From:To:Subject:Date:MIME-Version;
	b=OD++8e7djdqKWtHKQu5qkYpv19zLVTKTmUBC8zf57+gf+YrIrKGtGktuXK5q3MY4h
	 MwHy1XljSdvSbyJ5npGuOchKBzozZIpT/w13C6T4kATzmtz9xajiRm6RxKqFgDzVFB
	 y2lcTvnlbvQxJqm8edrs4yS4tBGv9bBmXJIa5SiVqQDirTa43QruEBo6bV12VdYZxz
	 Fry341quRPkcoAyNlNq9JDiT58b4+DG+HPgsAtgzEhI1yR4aF/VSr2v/T+1rSJ3A4S
	 ri+DBeCa01D9epdvkjkthfFvHwNdf5TYbhbp9CKE7LxtjM0OpurbppMQAwfJ4hBJpD
	 C2CQxnjvoUQEQ==
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rodolfo Giometti <giometti@enneenne.com>
Subject: [V1 0/4] User API for KPP
Date: Mon, 15 Sep 2025 10:40:35 +0200
Message-Id: <20250915084039.2848952-1-giometti@enneenne.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfOrdSnTy6aGUheSaeHuq2fLET0sbwdBPstiNi97WtbflMzFWGRuBdT77JZcQEoGauyrUj7eUDHNZZXAk1ahNMXcuhGL137S2IFace7Y7G0spwR5SK4xv
 5JUPc2TXHJ1gbDomOn1O2W7C8aUmMWM9n5WI9Nn4hTafF7goC+sKX/ou4viH6o2MI36FnLyBE00d7aJqZ0xmqSMgw3KmLmBYgxmBK+FIGfuXUmFhMlNJopn4
 IxXP5eZGOkZmYlkE4E4QwYnvuWlo/HDZ6WyDoTvyUTOjRIRoW6kahDW4jz5J0od0GNKKT+vRQlth4OLcFnToBWhhmnwnlivQrvxgMIYyHMU=

This patchset adds a dedicated user interface for the Key-agreement
Protocol Primitive (KPP).

From user applications, we can now use the following specification for
AF_ALG sockets:

    struct sockaddr_alg sa = {
            .salg_family = AF_ALG,
            .salg_type = "kpp",
            .salg_name = "ecdh-nist-p256",
    };

Once the private key is set with ALG_SET_KEY or (preferably)
ALG_SET_KEY_BY_KEY_SERIAL, the user program reads its public key from
the socket and then writes the peer's public key to the socket.

The shared secret calculated by the selected kernel algorithm is then
available for reading.

For example, if we create a trusted key like this:

    kpriv_id=$(keyctl add trusted kpriv "new 32" @u)

A simple example code is as follows:

    key_serial_t key_id;

    /* Generate the socket for KPP operation */
    sk_fd = socket(AF_ALG, SOCK_SEQPACKET, 0);
    bind(sk_fd, (struct sockaddr *)&sa, sizeof(sa));

    /* kpriv_id holds the trusted key ID */
    setsockopt(sk_fd, SOL_ALG, ALG_SET_KEY_BY_KEY_SERIAL,
               &key_id, sizeof(key_id));

    /* Get the operational socket */
    op_fd = accept(sk_fd, NULL, 0);

    /* Read our public key */
    recv(op_fd, pubkey, pubkey_len, 0);

    /* Write the peer's public key */
    send(op_fd, peer_pubkey, peer_pubkey_len, 0);

    /* Read the shared secret */
    len = recv(op_fd, secret, secret_len, 0);

Each time we write a peer's public key, we can read a different shared
secret.

Rodolfo Giometti (4):
  crypto ecdh.h: set key memory region as const
  crypto kpp.h: add new method set_secret_raw in struct kpp_alg
  crypto ecdh.c: define the ECDH set_secret_raw method
  crypto: add user-space interface for KPP algorithms

 crypto/Kconfig        |   8 ++
 crypto/Makefile       |   1 +
 crypto/algif_kpp.c    | 286 ++++++++++++++++++++++++++++++++++++++++++
 crypto/ecdh.c         |  31 +++++
 include/crypto/ecdh.h |   2 +-
 include/crypto/kpp.h  |  29 +++++
 6 files changed, 356 insertions(+), 1 deletion(-)
 create mode 100644 crypto/algif_kpp.c

-- 
2.34.1

