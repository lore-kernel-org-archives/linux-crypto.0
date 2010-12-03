From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH] Make sure sk_security is initialized on accept()ed sockets
Date: Fri,  3 Dec 2010 12:41:48 +0100
Message-ID: <1291376508-6902-1-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	=?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab0LCLlx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Dec 2010 06:41:53 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Miloslav Trma=C4=8D <mitr@redhat.com>
---
 crypto/af_alg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index cabed0e..bd9e53c 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -242,6 +242,7 @@ int af_alg_accept(struct sock *sk, struct socket *n=
ewsock)
 		goto unlock;
=20
 	sock_init_data(newsock, sk2);
+	sock_graft(sk2, newsock);
=20
 	err =3D type->accept(ask->private, sk2);
 	if (err) {
--=20
1.7.3.2
