Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D64A2571D7;
	Sun, 26 Jul 2026 19:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.167.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785094048; cv=none; b=O4JoNxNCZAgDg4VRtfACrX6GEr7aLVmxx9PoETln7S+eAUTyoECcq+mcustZIO4MEwP39X9cEdJoLkWwlt1fNEOlkvAQ5TO/tEq7vo6UgU3tlXluaYp0JjYyMPLgUxoJ7Jv0ly30z9h/il2huH7Mx2umByRUm8R8u3xpZAad2ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785094048; c=relaxed/simple;
	bh=Sc+s6xiQkgjcU/Ou2prRG6iJ4EKWkKdbBWyJ0mwlOIs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ITAUw4o5liXzo9qJSL2yS7gv93fO8C9QY93J8IjkeTf6uYoXBKqyOIXRLMU609MhnIt4RgERtKCG4/0BFOzNettqiHvG3rt7VEFNvikM3tNGLFg7y8O8PBI6EJs5A3eIvaCo4RxZp7QtTxZTD5jYOWCdESJUny8f6JOJnbDQ/KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at; spf=fail smtp.mailfrom=nod.at; arc=none smtp.client-ip=116.203.167.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id D3B2B2698C0;
	Sun, 26 Jul 2026 21:27:22 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id f7W_AlANAO1x; Sun, 26 Jul 2026 21:27:22 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 70EA62698C1;
	Sun, 26 Jul 2026 21:27:22 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id UDHHpDByr2-s; Sun, 26 Jul 2026 21:27:22 +0200 (CEST)
Received: from nailgun.corp.sigma-star.at (85-127-105-26.dsl.dynamic.surfer.at [85.127.105.26])
	by lithops.sigma-star.at (Postfix) with ESMTPSA id 106402698C0;
	Sun, 26 Jul 2026 21:27:22 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	demiobenour@gmail.com,
	davem@davemloft.net,
	herbert@gondor.apana.org.au,
	ebiggers@kernel.org,
	upstream+linux@sigma-star.at,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH] crypto: af_alg: Allow cbc(paes)
Date: Sun, 26 Jul 2026 21:27:16 +0200
Message-ID: <20260726192716.2351505-1-richard@nod.at>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Commit 7524070f26d8 ("crypto: af_alg - Drop support for off-CPU cryptogra=
phy")
breaks a special use case.  The cbc-paes-caam driver implements the
algorithm cbc(paes), it offers a way to use AES in CBC mode with key
material unknown to userspace.  Instead of an AES key a CAAM BLOB is
passed to the kernel.  So, this crypto operation cannot be
implemented in a userspace library and needs always help from the
kernel.

Explicitly allow this use case.

Cc: Demi Marie Obenour <demiobenour@gmail.com>
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 7524070f26d8 ("crypto: af_alg - Drop support for off-CPU cryptogra=
phy")
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 crypto/algif_skcipher.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index df20bdfe1f1f..035fed7db81f 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -32,6 +32,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/net.h>
+#include <linux/string.h>
 #include <net/sock.h>
=20
 static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
@@ -309,7 +310,12 @@ static struct proto_ops algif_skcipher_ops_nokey =3D=
 {
=20
 static void *skcipher_bind(const char *name)
 {
-	return crypto_alloc_skcipher(name, 0, AF_ALG_CRYPTOAPI_MASK);
+	u32 mask =3D AF_ALG_CRYPTOAPI_MASK;
+
+	if (strcmp(name, "cbc(paes)") =3D=3D 0)
+		mask =3D 0;
+
+	return crypto_alloc_skcipher(name, 0, mask);
 }
=20
 static void skcipher_release(void *private)
--=20
2.51.0

