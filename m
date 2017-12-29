From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: algapi - fix NULL dereference in crypto_remove_spawns()
Date: Fri, 29 Dec 2017 14:30:19 -0600
Message-ID: <20171229203019.1413-1-ebiggers3@gmail.com>
References: <001a1141c43ad30ccf055efb76ed@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:38139 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbdL2Ubh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Dec 2017 15:31:37 -0500
In-Reply-To: <001a1141c43ad30ccf055efb76ed@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

syzkaller triggered a NULL pointer dereference in crypto_remove_spawns()
via a program that repeatedly and concurrently requests AEADs
"authenc(cmac(des3_ede-asm),pcbc-aes-aesni)" and hashes "cmac(des3_ede)"
through AF_ALG, where the hashes are requested as "untested"
(CRYPTO_ALG_TESTED is set in ->salg_mask but clear in ->salg_feat; this
causes the template to be instantiated for every request).

Although AF_ALG users really shouldn't be able to request an "untested"
algorithm, the NULL pointer dereference is actually caused by a
longstanding race condition where crypto_remove_spawns() can encounter
an instance which has had spawn(s) "grabbed" but hasn't yet been
registered, resulting in ->cra_users still being NULL.

We probably should properly initialize ->cra_users earlier, but that
would require updating many templates individually.  For now just fix
the bug in a simple way that can easily be backported: make
crypto_remove_spawns() treat a NULL ->cra_users list as empty.

Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algapi.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 9895cafcce7e..395b082d03a9 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -166,6 +166,18 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 
 			spawn->alg = NULL;
 			spawns = &inst->alg.cra_users;
+
+			/*
+			 * We may encounter an unregistered instance here, since
+			 * an instance's spawns are set up prior to the instance
+			 * being registered.  An unregistered instance will have
+			 * NULL ->cra_users.next, since ->cra_users isn't
+			 * properly initialized until registration.  But an
+			 * unregistered instance cannot have any users, so treat
+			 * it the same as ->cra_users being empty.
+			 */
+			if (spawns->next == NULL)
+				break;
 		}
 	} while ((spawns = crypto_more_spawns(alg, &stack, &top,
 					      &secondary_spawns)));
-- 
2.15.1
