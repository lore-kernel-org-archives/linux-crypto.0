From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH RFC 1/3] crypto: Prevent to register duplicate cra_driver_name
Date: Wed, 20 Dec 2017 20:09:25 +0000
Message-ID: <1513800567-12764-2-git-send-email-clabbe@baylibre.com>
References: <1513800567-12764-1-git-send-email-clabbe@baylibre.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513800567-12764-1-git-send-email-clabbe@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Each crypto algorithm "cra_name" can have multiple implementation called
"cra_driver_name".
If two different implementation have the same cra_driver_name, nothing
can easily differentiate them.
Furthermore the mechanism for getting a crypto algorithm with its
implementation name (crypto_alg_match() in crypto/crypto_user.c) will
get only the first one found.

So this patch prevent the registration of two implementation with the
same cra_driver_name.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/algapi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 60d7366ed343..b8f6122f37e9 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -208,6 +208,11 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
 				goto err;
 			continue;
 		}
+		if (!strcmp(q->cra_driver_name, alg->cra_driver_name)) {
+			pr_err("Cannot register since cra_driver_name %s is already used\n",
+			       alg->cra_driver_name);
+			goto err;
+		}
 
 		if (!strcmp(q->cra_driver_name, alg->cra_name) ||
 		    !strcmp(q->cra_name, alg->cra_driver_name))
-- 
2.13.6
