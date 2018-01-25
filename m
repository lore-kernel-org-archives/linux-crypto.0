From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] crypto: crypto_user: Replace GFP_ATOMIC with GFP_KERNEL in crypto_report
Date: Thu, 25 Jan 2018 18:06:02 +0800
Message-ID: <1516874762-12046-1-git-send-email-baijiaju1990@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

After checking all possible call chains to crypto_report here,
my tool finds that crypto_report is never called in atomic context.
And crypto_report calls crypto_alg_match which calls down_read, 
thus it proves again that crypto_report can call functions which may sleep.
Thus GFP_ATOMIC is not necessary, and it can be replaced with GFP_KERNEL.

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 crypto/crypto_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 0dbe2be7..23baef1 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -271,7 +271,7 @@ static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
 		return -ENOENT;
 
 	err = -ENOMEM;
-	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!skb)
 		goto drop_alg;
 
-- 
1.7.9.5
