From: "Darren Jenkins\\" <darrenrjenkins@gmail.com>
Subject: [PATCH] crypto/tcrypt.c fix resource leak
Date: Tue, 08 Jul 2008 05:24:14 +1000
Message-ID: <1215458654.8316.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: kernel Janitors <kernel-janitors@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	jmorris@interco
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:39742 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbYGHHLf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jul 2008 03:11:35 -0400
Received: by py-out-1112.google.com with SMTP id p76so1119491pyb.10
        for <linux-crypto@vger.kernel.org>; Tue, 08 Jul 2008 00:11:34 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

G'day people,

Coverity CID: 2306 & 2307 RESOURCE_LEAK

In the second for loop in test_cipher(), data is allocated space with
kzalloc() and is only ever freed in an error case.
Looking at this loop, data is written to this memory but nothing seems
to read from it.=20
So here is a patch removing the allocation, I think this is the right
fix.

Only compile tested.

=EF=BB=BFSigned-off-by: Darren Jenkins <darrenrjenkins@gmailcom>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6beabc5..e47f6e0 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -586,12 +586,6 @@ static void test_cipher(char *algo, int enc,
 	j =3D 0;
 	for (i =3D 0; i < tcount; i++) {
=20
-		data =3D kzalloc(template[i].ilen, GFP_KERNEL);
-		if (!data)
-			continue;
-
-		memcpy(data, template[i].input, template[i].ilen);
