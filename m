From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-crypt: disable block encryption with arc4
Date: Mon, 25 Jan 2010 13:29:30 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1001251324310.18309@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
	linux-crypto@vger.kernel.org
To: dm-devel@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab0AYS3h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2010 13:29:37 -0500
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0PITaKO016724
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-crypto@vger.kernel.org>; Mon, 25 Jan 2010 13:29:37 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi

When using arc4 to encrypt a block device, the resulting device is 
unreliable. It reads garbage. That's because arc4 is a stream cipher, if 
you write something, it advances its state and if you attempt to decrypt 
the same sector, it uses new state that is different.

This patch disables the use of arc4 on block devices.

A question to crypto maintainers: Is there some general method how to 
determine that the cipher is a stream cipher, changes its state as it 
progresses and thus is unusable for block devices? I haven't found any 
flag for that.

Mikulas

---

Disable arc4 for encrypting block device

Arc4 is a stream cipher, it's once initialized with a key, it outputs a stream
of bytes (that are xored with the data to be encrypted) and changes it's
internal state.

Because the cipher changes it's internal state, it is not useable for encrypting
block devices --- once someone encrypts a sector of data, the internal state
changes --- and further attempts to decrypt the same block of data use the new
internal state. Thus, the encrypted device returns garbage.

This patch disables the use of arc4 for dm-crypt.

If we wanted to use arc4, we would have to setup the key before encrypting each
sector. That is slow. Because arc4 works by xoring the bitstream with the data,
it is not suitable for encrypting block devices anyway: if the attacker obtains
two images of the same block device at two different times, he can xor them with
each other, eliminating the cipher and getting two xored plaintexts.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6.32-devel/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.32-devel.orig/drivers/md/dm-crypt.c	2010-01-25 18:55:14.000000000 +0100
+++ linux-2.6.32-devel/drivers/md/dm-crypt.c	2010-01-25 18:57:02.000000000 +0100
@@ -1035,6 +1035,11 @@ static int crypt_ctr(struct dm_target *t
 		goto bad_cipher;
 	}
 
+	if (!strcmp(cc->cipher, "arc4")) {
+		ti->error = "Stream cipher arc4 not supported";
+		goto bad_cipher;
+	}
+
 	if (snprintf(cc->cipher, CRYPTO_MAX_ALG_NAME, "%s(%s)",
 		     chainmode, cipher) >= CRYPTO_MAX_ALG_NAME) {
 		ti->error = "Chain mode + cipher name is too long";
