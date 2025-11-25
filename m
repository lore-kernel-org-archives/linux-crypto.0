Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB4618BBAE
	for <linux-crypto@vger.kernel.org>; Tue, 25 Nov 2025 19:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764097409; cv=none; b=KHdDH/yXHnhjWe6A0KuuHoQUgnm3zDan2SrQGDGennRGYMAOWzeazVe2slyXuNQNImAkL1hZjSsWI0BOk9mA9voWeBHb5i9LKSmJtpx8gLvd24KfRF/0A3c1l6v3UML0MwUJM6qy+uBULmzeUNaNPyB+9jP9sOKcFEeWAUY6IsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764097409; c=relaxed/simple;
	bh=CfCXkUmu0XUOmNwgpcNNIYN8K1H1miO0sdrShOV3Ql4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IPAWJs//WmoLzUfE/fZKWxaDSqdjTh1+bA4wVrN99k+957yev0o00fBq4Fdp2sRKFMoxc8nj8F8QsaBMHBPGhkyV44bEhCLzmtP3h/myQrjUgcqK85vDM4uo4Cr7MlpRM7N/Hwg0K4J5RFnQgSgvnfkr0siyOj+bG23ZUCFZ9Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=EC84biBI; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="EC84biBI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1764097406;
	bh=CfCXkUmu0XUOmNwgpcNNIYN8K1H1miO0sdrShOV3Ql4=;
	h=From:To:Subject:Date:Message-ID:From;
	b=EC84biBI8KGdXe7e/rd7N93WZFy17N2Y6/gowIU0NI7rY3jh4nQn/7L5S7AO9+s41
	 R0mdIcr5GNNmCoM/GlK2e9r7/tTTrJAxqs+SuThMrBGisH/aKUk9Bbk9FYSb/0A2PA
	 tDl7n9Pt4g7prXsUW3YINi/eNroW5xgaHj7iV8mU=
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id 5A1721C015F;
	Tue, 25 Nov 2025 14:03:26 -0500 (EST)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: [PATCH 0/2] pkcs7: better handling of signed attributes
Date: Tue, 25 Nov 2025 14:02:54 -0500
Message-ID: <20251125190256.4034-1-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Although the biggest use of signed attributes is PKCS#7 and X509
specific data, they can be added to a signature to support arbitrary
and verifiable objects.  This makes them particularly useful when you
want to take an existing signature scheme and extend it with
additional (but always verified) data in such a way that it still
looks valid to both the old and new schemes.

The first patch in this series is the implementation that allows
extraction of arbitrary signed attributes by OID.  Since our
predominant use case is single signing, the search just stops when it
finds any authenticated attribute matching the OID. The second patch
uses the pkcs7 test module key type to validate that the code is
working (it looks for the message digest OID which must be present).
I think it's a useful illustration of how this works, but it doesn't
have to go upstream.

Regards,

James


James Bottomley (2):
  crypto: pkcs7: add ability to extract signed attributes by OID
  crypto: pkcs7: add tests for pkcs7_get_authattr

 crypto/asymmetric_keys/Makefile         |  4 +-
 crypto/asymmetric_keys/pkcs7_aa.asn1    | 18 ++++++
 crypto/asymmetric_keys/pkcs7_key_type.c | 27 +++++++-
 crypto/asymmetric_keys/pkcs7_parser.c   | 84 +++++++++++++++++++++++++
 include/crypto/pkcs7.h                  |  4 ++
 5 files changed, 135 insertions(+), 2 deletions(-)
 create mode 100644 crypto/asymmetric_keys/pkcs7_aa.asn1

-- 
2.51.0

