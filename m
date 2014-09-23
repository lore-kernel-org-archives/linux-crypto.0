From: behanw@converseincode.com
Subject: [PATCH v4 02/12] btrfs: LLVMLinux: Remove VLAIS
Date: Mon, 22 Sep 2014 21:42:07 -0700
Message-ID: <1411447337-22362-3-git-send-email-behanw@converseincode.com>
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
	=?UTF-8?q?Vin=C3=ADcius=20Tinti?= <viniciustinti@gmail.com>,
	Behan Webster <behanw@converseincode.com>
To: agk@redhat.com, clm@fb.com, davem@davemloft.net,
	dm-devel@redhat.com, fabf@skynet.be, herbert@gondor.apana.org.au,
	jbacik@fb.com, snitzer@redhat.com, tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:55725 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbaIWEmu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Sep 2014 00:42:50 -0400
Received: by mail-pd0-f172.google.com with SMTP id y10so5809530pdj.31
        for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2014 21:42:49 -0700 (PDT)
In-Reply-To: <1411447337-22362-1-git-send-email-behanw@converseincode.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Vin=C3=ADcius Tinti <viniciustinti@gmail.com>

Replaced the use of a Variable Length Array In Struct (VLAIS) with a C9=
9
compliant equivalent.  This patch instead allocates the appropriate amo=
unt of
memory using a char array using the SHASH_DESC_ON_STACK macro.

The new code can be compiled with both gcc and clang.

Signed-off-by: Vin=C3=ADcius Tinti <viniciustinti@gmail.com>
Reviewed-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Acked-by: Chris Mason <clm@fb.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 fs/btrfs/hash.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/hash.c b/fs/btrfs/hash.c
index 85889aa..4bf4d3a 100644
--- a/fs/btrfs/hash.c
+++ b/fs/btrfs/hash.c
@@ -33,18 +33,16 @@ void btrfs_hash_exit(void)
=20
 u32 btrfs_crc32c(u32 crc, const void *address, unsigned int length)
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
--=20
1.9.1
