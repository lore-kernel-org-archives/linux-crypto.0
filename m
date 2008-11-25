From: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] crypto: fix error flow of crypto/testmgr.c:test_comp()
Date: Tue, 25 Nov 2008 09:58:21 +0100
Message-ID: <20081125085820.GA11401@elte.hu>
References: <20080421024306.GA6813@gondor.apana.org.au> <20080714121403.GA28523@gondor.apana.org.au> <20081010070918.GA28057@gondor.apana.org.au> <alpine.LFD.2.00.0810101118050.3503@nehalem.linux-foundation.org> <20081011021357.GB3685@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:60516 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbYKYI6g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Nov 2008 03:58:36 -0500
Content-Disposition: inline
In-Reply-To: <20081011021357.GB3685@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Noticed the bug below while running our -Werror x86 randconfig build=20
tests against tip/master. Please double check my control flow=20
analysis.

	Ingo

---------->
=46rom e5c3b90a18b73d593bba2a3f927a79469b6218d7 Mon Sep 17 00:00:00 200=
1
=46rom: Ingo Molnar <mingo@elte.hu>
Date: Tue, 25 Nov 2008 09:47:28 +0100
Subject: [PATCH] crypto: fix error flow of crypto/testmgr.c:test_comp()
MIME-Version: 1.0
Content-Type: text/plain; charset=3Dutf-8
Content-Transfer-Encoding: 8bit

this warning:

  crypto/testmgr.c: In function =E2=80=98test_comp=E2=80=99:
  crypto/testmgr.c:829: warning: =E2=80=98ret=E2=80=99 may be used unin=
itialized in this function

triggers because GCC correctly notices that in the ctcount =3D=3D 0 &&
dtcount !=3D 0 input condition case this function can return an undefin=
ed
value, if the second loop fails.

Remove the shadowed 'ret' variable from the second loop that was probab=
ly
unintended.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 crypto/testmgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b828c6c..0cf0ae3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -853,7 +853,7 @@ static int test_comp(struct crypto_comp *tfm, struc=
t comp_testvec *ctemplate,
 	}
=20
 	for (i =3D 0; i < dtcount; i++) {
-		int ilen, ret, dlen =3D COMP_BUF_SIZE;
+		int ilen, dlen =3D COMP_BUF_SIZE;
=20
 		memset(result, 0, sizeof (result));
=20

--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
