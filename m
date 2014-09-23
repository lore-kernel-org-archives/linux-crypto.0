From: behanw@converseincode.com
Subject: [PATCH v4 10/12] crypto: LLVMLinux: Remove VLAIS usage from libcrc32c.c
Date: Mon, 22 Sep 2014 21:42:15 -0700
Message-ID: <1411447337-22362-11-git-send-email-behanw@converseincode.com>
References: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, bruce.w.allan@intel.com,
	d.kasatkin@samsung.com, james.l.morris@oracle.com,
	john.griffin@intel.com, linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-ima-devel@lists.sourceforge.net,
	linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
	neilb@suse.de, qat-linux@intel.com, serge@hallyn.com,
	thomas.lendacky@amd.com, zohar@linux.vnet.ibm.com,
	torvalds@linux-foundation.org,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
	Behan Webster <behanw@converseincode.com>, pageexec@freemail.hu
To: agk@redhat.com, clm@fb.com, davem@davemloft.net,
	dm-devel@redhat.com, fabf@skynet.be, herbert@gondor.apana.org.au,
	jbacik@fb.com, snitzer@redhat.com, tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34243 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbaIWEnN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Sep 2014 00:43:13 -0400
Received: by mail-pd0-f174.google.com with SMTP id g10so5250866pdj.33
        for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2014 21:43:12 -0700 (PDT)
In-Reply-To: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>

Replaced the use of a Variable Length Array In Struct (VLAIS) with a C9=
9
compliant equivalent. This patch allocates the appropriate amount of me=
mory
using a char array using the SHASH_DESC_ON_STACK macro.

The new code can be compiled with both gcc and clang.

Signed-off-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: pageexec@freemail.hu
Cc: "David S. Miller" <davem@davemloft.net>
---
 lib/libcrc32c.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index b3131f5..6a08ce7 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -41,20 +41,18 @@ static struct crypto_shash *tfm;
=20
 u32 crc32c(u32 crc, const void *address, unsigned int length)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm)];
-	} desc;
+	SHASH_DESC_ON_STACK(shash, tfm);
+	u32 *ctx =3D (u32 *)shash_desc_ctx(shash);
 	int err;
=20
-	desc.shash.tfm =3D tfm;
-	desc.shash.flags =3D 0;
-	*(u32 *)desc.ctx =3D crc;
+	shash->tfm =3D tfm;
+	shash->flags =3D 0;
+	*ctx =3D crc;
=20
-	err =3D crypto_shash_update(&desc.shash, address, length);
+	err =3D crypto_shash_update(shash, address, length);
 	BUG_ON(err);
=20
-	return *(u32 *)desc.ctx;
+	return *ctx;
 }
=20
 EXPORT_SYMBOL(crc32c);
--=20
1.9.1
