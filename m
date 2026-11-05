Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793867354;
	b=FDz/U2auwU5aji5z5FMsa+eCCMkgQPNjLxaz6MhXbj7boWZWc0jNLOPG79ndmx0+Fq6z
	 m17VIYK+ZCTuE+uSLB9m8yOmX75m9Oj3TY3jXXrCUrFjqpfFte3vADkD7gIy7wX0auI48
	 zYACD9vvn7H/iYT6k8QhPHupPtRt5eeIxpzSEdqO9Hwmrb6SlOoCze9Dbs5PsLPmyGmgd
	 Q5jFDO+7PACcaiFfpLCRWLRD920vdFBfyXVyrLgaMKBR35kUk2kIcQz0jb1UjnK5OhPpK
	 igejrkuDofyE2V6qQzKmtVgH9YO6Pxc7AhruvCbdC0OZ+1eGN01jxy198XD7BPBd0Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793867354;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=+rrAtFHqeMqdCjqPxg36A60/bzAo4VX4pdxWOCoyrs8=;
	b=UDmTUImCDmYQ0rPBYg+inf3Fp4IUeAnGDfT2TBcUzVAtOg1TBdOZeWMES0tw1mgnGMXe
	 d5+sck9I3WPufJbxN25uQ51VXOT/TYs01Rn6/T76Lagg2AmBfpPqFrBtJK64+YRBarDWr
	 Se9UrvdVsgz70le2wFptJB2DQ9iEZjFomPmfE1tUPNTEcJIVe42CbM5pTZguFQ5I/doua
	 r+d0WRZzVCw2sdHUz3ifZR5d6lBhKLjE/45+3t9dy7uyHuCnqSVZnQJ97qwk69RXEjZyZ
	 6PdTsZdpKp5eYF/n8f2tuKIvSnQIN+LyNb9S/DQh518eaiwys9+myfEbPRKdJ9uem6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=g141u7p8;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2675D606A333
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 08:29:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2675D606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=g141u7p8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793867353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+rrAtFHqeMqdCjqPxg36A60/bzAo4VX4pdxWOCoyrs8=;
	b=g141u7p87nJuV/sIpxF/YpVZAEVQFHyOtF+pCDsf8TKm7wIH9neE8MUjAn5chfr6TJuVHy
	hN0ifwSva2FdouuP9HeKKzWpkN/39qBO4cHFMq5s7egbsEFuNtoDfPQTiYJo6YFm9MUYZR
	cFj2gayFpL8Jmmc3DPBUauJv5epLxag=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-355-dAP-xzHIOrWZ4hyhPfNwKw-1; Thu,
 05 Nov 2026 03:29:08 -0500
X-MC-Unique: dAP-xzHIOrWZ4hyhPfNwKw-1
X-Mimecast-MFC-AGG-ID: dAP-xzHIOrWZ4hyhPfNwKw_1793867346
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8674A19560B8;
	Thu,  5 Nov 2026 08:29:06 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.66])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 46F3D188458A;
	Thu,  5 Nov 2026 08:29:03 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2] lib/crypto: Add a sentence about zeroizing raw key structures
Date: Thu,  5 Nov 2026 09:29:02 +0100
Message-ID: <20261105082902.327526-1-thuth@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Let's make it clear that raw key material has to be zeroized, too.

Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 v2: Move the information into a separate paragraph

 Documentation/crypto/libcrypto-zeroization.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/crypto/libcrypto-zeroization.rst b/Documentation/crypto/libcrypto-zeroization.rst
index 76b6506711634..af3a4559b4963 100644
--- a/Documentation/crypto/libcrypto-zeroization.rst
+++ b/Documentation/crypto/libcrypto-zeroization.rst
@@ -43,6 +43,11 @@ two purposes:
 What to zeroize
 ---------------
 
+Raw key material (e.g. a plain AES key stored in an array or a caller-
+defined struct) must also be zeroized as soon as it is no longer needed,
+for example right after it has been used to populate one of the key
+structures below.
+
 The following types of structures hold sensitive material and should be
 zeroized after use:
 
-- 
2.56.0

