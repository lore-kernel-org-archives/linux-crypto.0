From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] crypto/testmgr: fix uninitialized warning from gcc
Date: Wed,  9 Dec 2009 06:52:04 -0500
Message-ID: <1260359524-15515-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48717 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289AbZLILv7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2009 06:51:59 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since err is not set to a value if tcount is 0, gcc issues a warning:
crypto/testmgr.c: In function =E2=80=98test_cprng=E2=80=99:
crypto/testmgr.c:1204: warning: =E2=80=98err=E2=80=99 may be used unini=
tialized in this function

Since this is test code, forcing initialized sanity should be fine.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 crypto/testmgr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 7620bfc..90c4254 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1214,6 +1214,7 @@ static int test_cprng(struct crypto_rng *tfm, str=
uct cprng_testvec *template,
 		return -ENOMEM;
 	}
=20
+	err =3D 0; /* sanity in case tcount is 0 */
 	for (i =3D 0; i < tcount; i++) {
 		memset(result, 0, 32);
=20
--=20
1.6.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
