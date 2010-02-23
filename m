From: Szilveszter Ordog <slipszi@gmail.com>
Subject: [PATCH] crypto: ahash - Fix handling of unaligned buffers
Date: Tue, 23 Feb 2010 12:50:01 +0100
Message-ID: <ac67d9131002230350o9618b9apd111f0da1bba15b1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:26131 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0BWLuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Feb 2010 06:50:03 -0500
Received: by fg-out-1718.google.com with SMTP id e21so746732fga.1
        for <linux-crypto@vger.kernel.org>; Tue, 23 Feb 2010 03:50:01 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The correct way to calculate the start of the aligned part of an
unaligned buffer is:

  offset =3D ALIGN(offset, alignmask + 1);

However, crypto_hash_walk_done() has:

  offset +=3D alignmask - 1;
  offset =3D ALIGN(offset, alignmask + 1);

which actually skips a whole block unless offset % (alignmask + 1) =3D=3D=
 1.

This patch fixes the problem.

Signed-off-by: Szilveszter =D6rd=F6g <slipszi@gmail.com>
---
 crypto/ahash.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index f347637..db42202 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -65,7 +65,6 @@ int crypto_hash_walk_done(struct crypto_hash_walk
*walk, int err)
 	walk->data -=3D walk->offset;

 	if (nbytes && walk->offset & alignmask && !err) {
-		walk->offset +=3D alignmask - 1;
 		walk->offset =3D ALIGN(walk->offset, alignmask + 1);
 		walk->data +=3D walk->offset;

--=20
1.5.5.6
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
