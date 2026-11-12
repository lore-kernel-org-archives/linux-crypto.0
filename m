Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794469450;
	b=jjvSdsXEI+r8lRUNKU5mRm6FOG1QeTcRGbQoOCRJSeryyAYJNlSotdAbwKUpA6U+0zYC
	 dZjFlUKeGm1fZU1AGTB+X9jDAWD6pEtaS79Z7HuEUNXNeCDje9o7iV/5McICT4KjyyJwK
	 8ltsnU7pYlmsHnzoMPzmWa/KEwd5LDduo9Q1n9eCuxNJLVRhKs72xtn+otxKOYAEl/5dd
	 r6bteSQeSh4KQL7qTwEwzY5xv3qKtnzDsbMrE3KDiShYnSYQV/yoWdphPFqljaPsU9kEB
	 7xRKqPJcXiJnOVBrlzXAGPyvQupKLsv2Q4WYU9eLUncg5zSBVxQ68isfA69Xtbrodsw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469450;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-ZohoMailClient;
	bh=mSJLVROgaKfi4x8itWwRnCfWD46xUMzXQx4yk957PDE=;
	b=QRCfpwlutADMK6kWdNaHE3AMxteCFJVsAgCRbaU9zxxHZ27oNA1WNCefgZwJvjiGdGDd
	 BO1JhCi+jzIN0R0OxWUhwU37ej1W37n3zI7NenZ1YBvqFCmfJidt30LPSEDBLARLrvWqy
	 GpQWmFvS6irNKBPx44ldj6tOdT+0++bWPTttz0kcrWlSt1FzclFRJjJt6mgMrP/PgtPoV
	 qbEuy/ftvHZlfuvva8pTZy76lTNcHYd7a41iRPgix+2oTLVM2WjauOJik1OpSMu7H8k6h
	 JJBWlVAWqpciOAmR9eL1FSvkh7CAGLxDOo3GWY7WwEtf5Lpuh7OfcpohsdosXWw8HHQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=laveeshbansal.com;
	spf=pass smtp.mailfrom=laveeshbansal.com;
	dkim=pass header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b="bXFG/Vcj";
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.15
Received: from sender5-op-o15.zoho.com (sender5-op-o15.zoho.com [165.173.182.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF05606A33C;
	Thu, 12 Nov 2026 07:44:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FF05606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=bXFG/Vcj
ARC-Seal: i=1; a=rsa-sha256; t=1794469408; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=TKuRns2t0/BmagPiYEINGbIbLFADGpmjfS0M1q1p2bzBUqcFugGtQFY/spnnAybkyv27+i1imAU7uWnxSay2NzEGae5qdgC9c2dmKjBkFRI+evHeaZUwoB2b2XKh0KrV5c46ynWBoIPxSErUS+QFjVHkvSd49pPfdscfJKWzbbA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1794469408; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=mSJLVROgaKfi4x8itWwRnCfWD46xUMzXQx4yk957PDE=; 
	b=Qof/VxTGBaotCmpjsjDkSI8zjgBmdxdHu+NHZN/8GYATuBfRvxgn1232eggmVk4GvfKkXFRhJg4F8DcIfz1yE0hkctAe/DoixNRWXv/cAA8qHsXNAaiYXDZAlqL6Spk9foJgxAegLwnkVnivVIhsIlM3UEBNN9ONLXe6haBApFU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: a=rsa-sha256; b=bXFG/VcjdtnCkkkCmqnhSGPZJ+cKOFIEieOe13qE3H2pW3GzJzonXvKFED2MpaqyDIBgKjrE2jYjr3HBrHixa0j/M29pa7OnVxQbkoIGFFCwUHWBbXtmGIxszeQKsll6VTeEYTV1EKpgBkz5Nn6U+IdzzgJzYXMdLX9g+dkBvl8=; c=relaxed/relaxed; s=zoho; d=laveeshbansal.com; v=1; bh=mSJLVROgaKfi4x8itWwRnCfWD46xUMzXQx4yk957PDE=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1794469407514543.1695659804527;
	Wed, 11 Nov 2026 23:43:27 -0800 (PST)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>,
	Denis Kenzior <denkenz@gmail.com>,
	Maximilian Stahlberg <maximilian.stahlberg@uni-bremen.de>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] X.509: Accept a certificate with an empty subject
Date: Wed, 11 Nov 2026 23:42:44 -0800
Message-ID: <20261112074246.99421-1-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Patch 1 fixes loading a certificate with an empty Subject, which iwd
hits with an eduroam server certificate [1]. Patch 2 adds a KUnit test
for it.

I developed this series using an LLM coding assistant.

[1] https://lore.kernel.org/r/9b05b89cf296b8a6392bbe6327228c1bc2f05c49.camel@uni-bremen.de


Laveesh Bansal (2):
  X.509: Accept a certificate with an empty subject
  X.509: Add KUnit tests for the certificate parser

 crypto/asymmetric_keys/Kconfig            |  11 ++
 crypto/asymmetric_keys/Makefile           |   1 +
 crypto/asymmetric_keys/x509.asn1          |   8 +-
 crypto/asymmetric_keys/x509_parser_test.c | 160 ++++++++++++++++++++++
 4 files changed, 179 insertions(+), 1 deletion(-)
 create mode 100644 crypto/asymmetric_keys/x509_parser_test.c

-- 
2.54.0

