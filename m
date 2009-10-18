From: Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 3/7] crypto: testmgr: fix warning
Date: Mon, 19 Oct 2009 01:54:30 +0300
Message-ID: <1255906474-25091-4-git-send-email-felipe.contreras@gmail.com>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	Felipe Contreras <felipe.contreras@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jarod Wilson <jarod@redhat.com>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	linux-crypto@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:24064 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbZJRW4u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2009 18:56:50 -0400
In-Reply-To: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto/testmgr.c: In function =E2=80=98test_cprng=E2=80=99:
crypto/testmgr.c:1204: warning: =E2=80=98err=E2=80=99 may be used unini=
tialized in this function

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 crypto/testmgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6d5b746..1f2357b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1201,7 +1201,7 @@ static int test_cprng(struct crypto_rng *tfm, str=
uct cprng_testvec *template,
 		      unsigned int tcount)
 {
 	const char *algo =3D crypto_tfm_alg_driver_name(crypto_rng_tfm(tfm));
-	int err, i, j, seedsize;
+	int err =3D 0, i, j, seedsize;
 	u8 *seed;
 	char result[32];
=20
--=20
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
