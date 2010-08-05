From: =?ISO-8859-1?Q?Szilveszter_=D6rd=F6g?= <slipszi@gmail.com>
Subject: [PATCH] crypto: hash - Fix handling of small unaligned buffers
Date: Thu, 5 Aug 2010 12:05:49 +0200
Message-ID: <AANLkTinw0a9NJNwLRg7d_HQWSFayRdRQH1cULKmmWEFP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37660 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760079Ab0HEKFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Aug 2010 06:05:50 -0400
Received: by gxk23 with SMTP id 23so2440128gxk.19
        for <linux-crypto@vger.kernel.org>; Thu, 05 Aug 2010 03:05:49 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If a scatterwalk chain contains an entry with an unaligned offset then
hash_walk_next() will cut off the next step at the next alignment point=
=2E

However, if the entry ends before the next alignment point then we a lo=
op,
which leads to a kernel oops.

=46ix this by checking whether the next aligment point is before the en=
d of the
current entry.

Signed-off-by: Szilveszter =D6rd=F6g <slipszi@gmail.com>
---
Added the Signed-off-by line

 crypto/ahash.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index b8c59b8..f669822 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -47,8 +47,11 @@ static int hash_walk_next(struct crypto_hash_walk *w=
alk)
 	walk->data =3D crypto_kmap(walk->pg, 0);
 	walk->data +=3D offset;

-	if (offset & alignmask)
-		nbytes =3D alignmask + 1 - (offset & alignmask);
+	if (offset & alignmask) {
+		unsigned int unaligned =3D alignmask + 1 - (offset & alignmask);
+		if (nbytes > unaligned)
+			nbytes =3D unaligned;
+	}

 	walk->entrylen -=3D nbytes;
 	return nbytes;
--=20
1.5.5.6
