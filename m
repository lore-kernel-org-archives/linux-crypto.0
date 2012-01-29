From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] In crypto_add_alg(), 'exact' wants to be initialized to 0
Date: Sun, 29 Jan 2012 23:39:22 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1201292337390.27749@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We declare 'exact' without initializing it and then do:

[...]
	if (strlen(p->cru_driver_name))
		exact = 1;

	if (priority && !exact)
		return -EINVAL;

[...]

If the first 'if' is not true, then the second will test an
uninitialized 'exact'.
As far as I can tell, what we want is for 'exact' to be initialized to
0 (zero/false).

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 crypto/crypto_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

  Compile tested only.

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 16f8693..36a2af7 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -304,7 +304,7 @@ static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			  struct nlattr **attrs)
 {
-	int exact;
+	int exact = 0;
 	const char *name;
 	struct crypto_alg *alg;
 	struct crypto_user_alg *p = nlmsg_data(nlh);
-- 
1.7.8.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
