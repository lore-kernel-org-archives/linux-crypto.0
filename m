Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7D230EF82
	for <linux-crypto@vger.kernel.org>; Thu, 19 Mar 2026 19:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773947538; cv=none; b=Y9ItPzctQ6Ewe7lP4ZZnJxl95j0w9GUHhHVLltPeUX6wOGSra8MxbGXVp31VmK2iv7JDlOujaUQ7plzUxSyHhobwLbJTzEBHJb00dwoHJS86hEkS/dJBWbP3z1cS5692feeq7PC0g2iu41vjfM7xgLU/yonAXSVezF8KKkQRDKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773947538; c=relaxed/simple;
	bh=trbiVUTP13adI2TZp4WnwV3pXAeXa/avcsZqEY5o9ec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J00aZZCjbzW4Sv0SFNdzY45Hcl2uKXFmN9plL4S8VcjBnNW+NSmrR8uI27EcDFR2D2PJlXHXxQxsjXIfUaqEl6p/Rz8KWOQGoW+TAxdy6V+/4YgB3CSp1OqS6XlkLOSnViGOP47yfi+Zasxx9DL8xEkOET0AsPE51tcfuT60FyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=JoUahBr5; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="JoUahBr5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1773947534;
	bh=trbiVUTP13adI2TZp4WnwV3pXAeXa/avcsZqEY5o9ec=;
	h=From:To:Subject:Date:Message-ID:From;
	b=JoUahBr587dpQV2BQ3aRAplrNIfqiaAQZ+6hLNTqK0GNlJZD1vlMOix/5qr83NU01
	 XpDL0Gw2DkvjRp/U7mUY1HW0Eyx1TU13FKcVHjP2S4U/UUOUPJIkiVITy3tg7opYZs
	 K8E7ERR6eUkps7NjR1pMzBa6C055LLXxOrv0rAyo=
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id A90781C02C6;
	Thu, 19 Mar 2026 15:12:14 -0400 (EDT)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: [PATCH v4 0/3] pkcs7: better handling of signed attributes
Date: Thu, 19 Mar 2026 15:12:05 -0400
Message-ID: <20260319191208.831-1-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v4: the patch set got much smaller thanks to dumping the ability to
verify only the signature itself without having to supply the buffer
for verification (all potential consumers confirmed they have the
buffer and it's not a huge overhead).  So the use flow now is parse
the pkcs7, call the existing verify_pkcs7_message_sig to get the trust
for the signed attributes and then extract them.

v3 updates for the now-upstream ml-dsa.  The ml-dsa patches actually
changed the definition of authattrs in struct pkcs7_signed_info, which
means I now don't have to justify stepping one back in patch 4
(thanks!).  Just in case I checked that nothing else was affected by
this change.

Original cover letter:

Although the biggest use of signed attributes is PKCS#7 and X509
specific data, they can be added to a signature to support arbitrary
and verifiable objects.  This makes them particularly useful when you
want to take an existing signature scheme and extend it with
additional (but always verified) data in such a way that it still
looks valid to both the old and new schemes.

To use a scheme like this to extend signatures requires that the
authenticated attribute only be pulled out of a signer info that can
be verified by one of the trusted keys, so the implementation loops
over all signer infos, discarding those that haven't been verified and
returns the first OID match it finds in the verified ones.  Note that
if you reparse a pkcs7 it starts out with no trusted signer infos, and
you must anchor trust by calling validate_pkcs7_trust() with the
trusted keyring.

The first three patches in this series are new to v2.  They add the
new validate_pkcs7_trust() call, thread a verified flag through struct
pkcs7_signer_info so we can tell which signers have been validated
against the trusted keyring. And finally thread pkcs7_digest through
the pkcs7_validate functions so they can operate on a plain parsed
pkcs7 structure that hasn't gone through pkcs7_verify.  Note we could
simply drop the last patch and insist that the pkcs7 be re-verified;
it just looked a bit inefficient, especially as the default way of
doing this (verify_pkcs7_signature() frees the pkcs7 structure before
returning.

The final two patches search for the authenticated attribute by OID,
stopping at the first one it finds belonging to a verified signer
info.  The final patch demonstrates how to use it.  I've added a check
to show that if you don't in any way validate the pkcs7 then no signed
attributes get returned.

Regards,

James

---

James Bottomley (3):
  crypto: pkcs7: add flag for validated trust on a signed info block
  crypto: pkcs7: add ability to extract signed attributes by OID
  crypto: pkcs7: add tests for pkcs7_get_authattr

 certs/system_keyring.c                  |  1 +
 crypto/asymmetric_keys/Makefile         |  4 +-
 crypto/asymmetric_keys/pkcs7_aa.asn1    | 18 ++++++
 crypto/asymmetric_keys/pkcs7_key_type.c | 44 +++++++++++++-
 crypto/asymmetric_keys/pkcs7_parser.c   | 81 +++++++++++++++++++++++++
 crypto/asymmetric_keys/pkcs7_parser.h   |  1 +
 crypto/asymmetric_keys/pkcs7_trust.c    |  1 +
 include/crypto/pkcs7.h                  |  4 ++
 8 files changed, 152 insertions(+), 2 deletions(-)
 create mode 100644 crypto/asymmetric_keys/pkcs7_aa.asn1

-- 
2.51.0

