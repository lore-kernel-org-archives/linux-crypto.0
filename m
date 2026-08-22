Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [93.188.205.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525FB34FF79;
	Sat, 22 Aug 2026 08:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.188.205.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787387981; cv=none; b=pCDbkBnmN/sRv0aeSZ1ssyM16ePUO3hrwJzPh4uNMXeuQ7w5oPvOsvaL79xPncjqS4KonQUwt6f7r4o7nOzvISBRXycW4igMH8K6nxZMxXkOjiYMa4QFS+fF2yVs27C2vtF56cVqmtJCni8Vd1DxmJYX/HxKRpalVLPYsCKARSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787387981; c=relaxed/simple;
	bh=IByip44c4mzM/PU31oE5SNo2spQ+VThEYwPm17Z08OY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nrqGUT+T3Z4Mtyr+ZFITNKrAVJRPPPGK+YeTpJNhbj1l3/8JkKTF3wjvwVilnrmM9wBNOL7AMihdYebYqrqxw6hNP5vann2f/T/O/RrNGt3V4m1/0QJDFOmRfQeE4N5iz1EJbBDe3M9VL1eo8QywwAkSlJtpdaVVExzlTLONDEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=WNdekIp0; arc=none smtp.client-ip=93.188.205.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b="WNdekIp0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1787387458;
	bh=IByip44c4mzM/PU31oE5SNo2spQ+VThEYwPm17Z08OY=;
	h=From:To:Cc:Subject:Date:From;
	b=WNdekIp0UNQE4ZM1KxhxSmtA7YCPYc0GfORo5thUBCTOtnm+Qgvx0xUX4d9bQfrWT
	 dBkBN0o6lgFtVnEF0tH7j5Ad6xuOLLnw4DHxgFYk91HnKZ6isIyqwEK5MwOniE+Ieu
	 KHUWKIRyCX4qG5yxS6GClbOv0Pm0+QM43oNxbuXjXHvMek8Yp9dbqnOnXnWn+2S9++
	 mne5IiA0TpsOdQ0pUjS5AoV24sDRw4jFvj9jqBU1nGf4Ob+Cnc9regmqwh//CzNj+f
	 5cr0QGpOnzYP4bbV/N3xfggSAg0641K/r09z7esTrf4jqAlot6o+DMENapURa/iASU
	 FWLf2OX6lvsbA==
Received: from gca-msk-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id 6E0BE1F987;
	Sat, 22 Aug 2026 11:30:58 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Sat, 22 Aug 2026 11:30:56 +0300 (MSK)
Received: from astra.astra.ru (unknown [10.198.17.65])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4hRr3h4jy7zrB4;
	Sat, 22 Aug 2026 11:30:56 +0300 (MSK)
From: Timofei Novikov <tnovikov@astralinux.ru>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Timofei Novikov <tnovikov@astralinux.ru>
Subject: [PATCH 0/3] Add X.509 CRL support
Date: Sat, 22 Aug 2026 11:26:39 +0300
Message-ID: <20260822082642.48936-1-tnovikov@astralinux.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: tnovikov@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 116 0.3.116 e16f906af7c720a8bd440e8c76eb19faffaac9ce, {diag_burst_silent}, {Tracking_ml_letters}, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;astralinux.ru:7.1.1;new-mail.astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 205480 [Aug 21 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/08/22 08:00:00 #28528350
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

This series adds X.509 Certificate Revocation List (CRL) parsing with
indirect CRL support per RFC 5280. Revoked certificates are blacklisted
using SHA-256 hash of serial+issuer.

The ASN.1 compiler is fixed to handle OPTIONAL fields in SEQUENCE/SET OF
and TYPE_REF constructs, which is required for the new CRL definitions.

Timofei Novikov (3):
  ASN.1: fix OPTIONAL for SEQUENCE OF and TYPE_REF
  x509: add CRL parser with indirect CRL support
  x509: add CRL signature verification support

 certs/blacklist.c                         |  17 ++-
 crypto/asymmetric_keys/Makefile           |   8 +-
 crypto/asymmetric_keys/x509_cert_parser.c | 132 ++++++++++++++++++++++
 crypto/asymmetric_keys/x509_crl.asn1      |  59 ++++++++++
 crypto/asymmetric_keys/x509_idp.asn1      |  12 ++
 crypto/asymmetric_keys/x509_loader.c      | 113 ++++++++++++++++++
 crypto/asymmetric_keys/x509_parser.h      |  18 +++
 crypto/asymmetric_keys/x509_public_key.c  |  21 ++++
 include/keys/asymmetric-type.h            |   4 +
 include/keys/system_keyring.h             |   2 +
 include/linux/oid_registry.h              |   4 +
 scripts/asn1_compiler.c                   |  12 +-
 12 files changed, 395 insertions(+), 7 deletions(-)
 create mode 100644 crypto/asymmetric_keys/x509_crl.asn1
 create mode 100644 crypto/asymmetric_keys/x509_idp.asn1

-- 
2.43.0

