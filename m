Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828391862;
	Thu,  9 Jul 2026 02:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783564076; cv=none; b=SxT5mgn9/LzyjcsyK04BE1Z5qrVMzbVIoT/e9Fmsdl4/RP/FkMC/+7I97H+ovgcuKqr7dvPcm1bahAF6eW8obbVkNXSIaxY2aVdOYSQMJBHIvBlJbK0KBFSGsZt2UaF79mi1ZSgu8D5VDlRiPwbXoip2spcpf48MxAXklKl5zyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783564076; c=relaxed/simple;
	bh=wJ3i75ZiGk/YEJsPBDUEHKxxQOKkTk7TcjnUdqfg16Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s4Sb/6KsujI7FV+XzzAjtpCcXTvZLJgy2T0JDLH+wkVg6KjDyPHT5KneUF2Ddie5ajpZcIyXtZ/4o7FbiP/bARccaSWyPnQtpfCYz8v2c58ix/90pOyuQ01Jf8ie2l6/dgtMJne4ia8o+Wyyr5eQP0c4S8Yh3EhtqsORnq/371U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1dzcQ3z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1dzcQ3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48611F000E9;
	Thu,  9 Jul 2026 02:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783564075;
	bh=tGxBJV9z1KaAx6vSMzeYfvuuwaQ+zg5gqBXPbh42KdI=;
	h=From:To:Cc:Subject:Date;
	b=T1dzcQ3zMrrsG69sao/GZSq3gZ5LeJOGD2TkTbCymb2C7O7vAO29LwM/dw4/BUYJ+
	 lpjRuYWkHP8SCSolKHbS4ni5zUmZrsa7Kh6CrOJtwcHg++8KiX9pspp9dSPVxBmy9I
	 H7P5wLXkYabfANcbOav9a9cHDihF06svec1f26gwxmhqyaypByvmLzSsmpHo2iK7kS
	 i7cJ1SJEX8q7M3g7gM07b+7rEA/6QNGSCX0moDLyob0MPSQlvOjY8JzCSUKYpErSB+
	 YagHlA+5eLVzeEEYzuUQpMIVs1xa+Sip7vniAWJLEveWp9ipohT5FhBN72a8TG6rqb
	 oxZKZiP+ox+yw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: docs: Improve introduction sentence
Date: Wed,  8 Jul 2026 22:27:47 -0400
Message-ID: <20260709022747.44635-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make it clear that lib/crypto/ is a kernel-internal library.  It's easy
for people to come across this page, especially the HTML version online,
without that context.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/crypto/libcrypto.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/crypto/libcrypto.rst b/Documentation/crypto/libcrypto.rst
index a1557d45b0e5..0733e603d229 100644
--- a/Documentation/crypto/libcrypto.rst
+++ b/Documentation/crypto/libcrypto.rst
@@ -4,8 +4,9 @@
 Crypto library
 ==============
 
-``lib/crypto/`` provides faster and easier access to cryptographic algorithms
-than the traditional crypto API.
+The Linux kernel's crypto library (``lib/crypto/``) provides kernel-internal
+users of cryptographic algorithms with faster and easier access to those
+algorithms than the traditional kernel crypto API.
 
 Each cryptographic algorithm is supported via a set of dedicated functions.
 "Crypto agility", where needed, is left to calling code.

base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
2.55.0

