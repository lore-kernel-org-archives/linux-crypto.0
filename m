Return-Path: <SRS0=EmbF=5Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E43C2D0F4
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 18:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8BC320784
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Apr 2020 18:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgDHSyC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Apr 2020 14:54:02 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:44715 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbgDHSyB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Apr 2020 14:54:01 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MgARS-1iniQS3Ncc-00heB6; Wed, 08 Apr 2020 20:53:34 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        YueHaibing <yuehaibing@huawei.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cxgb4/chcr: fix building without IPv6
Date:   Wed,  8 Apr 2020 20:53:06 +0200
Message-Id: <20200408185330.190658-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:wAyktI553TRtAYJswrpygJEuztlihckN+PSEPstYcFGyO2DZuG0
 swT5EivRwrnOxA8z729paYsUgWczyE0IxDgOrAFDY7HYvfDjCfSQ5OrNUnQDq1AaYCABvlN
 BeCk63j1UHkRHmGiQhTPFHNZOp3w6JMocotYGqYkOp9VzfHUehhqgnJEHRYv0Ag8cPD1k1r
 +ESsCDrRbIJsUAQe9parQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Gz73c4HLR7A=:tMA24IJYXr+7DJoSwQLnEq
 DiH00rmQA/0to7AMAIRqT5DAoos0rOGPHmLxZy8mFgf9Lh+GCvCYV1g2zyOER57XBylTXQ4R+
 /n95wABJtYahmJBtG3AmesmY/UklE/r4p7EP5ZOzLu80VW2rDNEuc6FVh1llF3y2WVqtWYhoU
 xVvWE1jwrIrN24PggrMfVM3b/uI9p4ZjTSakY9n7M+mabEs9LZz5hR+aq9WSC9FCeDkwWcoD6
 p7tXKfYnCF2+s3FL4BSgwWBrUkyD16hPJ0Td7jInQyed6Y5GY7b1mTUlNxE0+nD103ekxfKGh
 paOKEvWMa5qNU2pWieZ/XQW7Fl4R9BBk+FRU9Ms0jJvzKDBEAvv4uaZaAISXpjY1jwufqc67F
 uy6XhqSrof/VTq0juB5nf0B+YBC4ogv6sWKHXnc/HdvUHdXCx7DQCN9+js2p6/aGEZQqu42kq
 +wP23F8VgWVeKs9jMpR1cS+L2GtU5ca6ozKuoHZmuhydmHQPY5zw7Cty2H2AMftCcNZFh68A1
 XRMAA6O8zQ3HiC5DmRYZNk/4Tr4PEGTrQSA5pcWUCn5tO4QxmjfF/WL9GcyemZe2vDIAF0lPE
 llrNCB8mzeXLd9rSVt6rxzP0E3coZ9u1SAdS44zdsbpfyB4ho4+8hgc0PyqpgpqyEaW0rhgZ9
 v+M+xQe1gqPhE7yLaAJd4op1mBbGjogQUGn3zg2BktORuOiTE8UiK/AEQ/5Zx4CQ++RrmW2OZ
 ktvC5m6W1xYA6a45S4u5qoWMAKg4S06BzrgSKmQWdBDS4F6My3aEgCNF/ocne7wQOoraa/3s6
 8FeuoczEhHV2I6P1JOoMnC6dDFibOEM1t7cyEn7ITzvb9NPdk8=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When IPv6 support is completely disabled, the chelsio driver fails
to build with

drivers/crypto/chelsio/chcr_ktls.c: In function 'chcr_ktls_act_open_req6':
include/net/sock.h:380:37: error: 'struct sock_common' has no member named 'skc_v6_rcv_saddr'; did you mean 'skc_rcv_saddr'?
  380 | #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
      |                                     ^~~~~~~~~~~~~~~~
drivers/crypto/chelsio/chcr_ktls.c:258:37: note: in expansion of macro 'sk_v6_rcv_saddr'
  258 |  cpl->local_ip_hi = *(__be64 *)&sk->sk_v6_rcv_saddr.in6_u.u6_addr8[0];
      |                                     ^~~~~~~~~~~~~~~
drivers/crypto/chelsio/chcr_ktls.c:260:36: note: in expansion of macro 'sk_v6_daddr'
  260 |  cpl->peer_ip_hi = *(__be64 *)&sk->sk_v6_daddr.in6_u.u6_addr8[0];
      |                                    ^~~~~~~~~~~
drivers/crypto/chelsio/chcr_ktls.c:261:36: note: in expansion of macro 'sk_v6_daddr'
  261 |  cpl->peer_ip_lo = *(__be64 *)&sk->sk_v6_daddr.in6_u.u6_addr8[8];
      |                                    ^~~~~~~~~~~
drivers/crypto/chelsio/chcr_ktls.c:296:27: note: in expansion of macro 'sk_v6_daddr'
  296 |       ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
      |                           ^~~~~~~~~~~
drivers/crypto/chelsio/chcr_ktls.c:303:29: note: in expansion of macro 'sk_v6_rcv_saddr'
  303 |           (const u32 *)&sk->sk_v6_rcv_saddr.in6_u.u6_addr8,
      |                             ^~~~~~~~~~~~~~~
drivers/crypto/chelsio/chcr_ktls.c: In function 'chcr_ktls_dev_del':
drivers/crypto/chelsio/chcr_ktls.c:401:26: note: in expansion of macro 'sk_v6_daddr'
  401 |        (const u32 *)&sk->sk_v6_daddr.in6_u.u6_addr8,
      |                          ^~~~~~~~~~~
drivers/crypto/chelsio/chcr_ktls.c: In function 'chcr_ktls_dev_add':
drivers/crypto/chelsio/chcr_ktls.c:495:27: note: in expansion of macro 'sk_v6_daddr'
  495 |       ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
      |                           ^~~~~~~~~~~
drivers/crypto/chelsio/chcr_ktls.c:498:22: note: in expansion of macro 'sk_v6_daddr'
  498 |   memcpy(daaddr, sk->sk_v6_daddr.in6_u.u6_addr8, 16);
      |                      ^~~~~~~~~~~

There is probably a good way to fix it, but this patch just adds a
bunch of #if checks to get it to build again, which gets a bit
ugly.

Fixes: 62370a4f346d ("cxgb4/chcr: Add ipv6 support and statistics")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
If you have a better idea to fix it, please send a different patch
instead and treat this as a bug report. ;-)
---
 drivers/crypto/chelsio/chcr_ktls.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ktls.c b/drivers/crypto/chelsio/chcr_ktls.c
index 73658b71d4a3..3d3f8dfa4e96 100644
--- a/drivers/crypto/chelsio/chcr_ktls.c
+++ b/drivers/crypto/chelsio/chcr_ktls.c
@@ -222,6 +222,7 @@ static int chcr_ktls_act_open_req(struct sock *sk,
 	return cxgb4_l2t_send(tx_info->netdev, skb, tx_info->l2te);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 /*
  * chcr_ktls_act_open_req6: creates TCB entry for ipv6 connection.
  * @sk - tcp socket.
@@ -271,6 +272,7 @@ static int chcr_ktls_act_open_req6(struct sock *sk,
 
 	return cxgb4_l2t_send(tx_info->netdev, skb, tx_info->l2te);
 }
+#endif
 
 /*
  * chcr_setup_connection:  create a TCB entry so that TP will form tcp packets.
@@ -291,12 +293,16 @@ static int chcr_setup_connection(struct sock *sk,
 	tx_info->atid = atid;
 	tx_info->ip_family = sk->sk_family;
 
-	if (sk->sk_family == AF_INET ||
-	    (sk->sk_family == AF_INET6 && !sk->sk_ipv6only &&
-	     ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
+	if (sk->sk_family == AF_INET
+#if IS_ENABLED(CONFIG_IPV6)
+	    || (sk->sk_family == AF_INET6 && !sk->sk_ipv6only &&
+	     ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)
+#endif
+	    ) {
 		tx_info->ip_family = AF_INET;
 		ret = chcr_ktls_act_open_req(sk, tx_info, atid);
 	} else {
+#if IS_ENABLED(CONFIG_IPV6)
 		tx_info->ip_family = AF_INET6;
 		ret =
 		cxgb4_clip_get(tx_info->netdev,
@@ -305,6 +311,7 @@ static int chcr_setup_connection(struct sock *sk,
 		if (ret)
 			goto out;
 		ret = chcr_ktls_act_open_req6(sk, tx_info, atid);
+#endif
 	}
 
 	/* if return type is NET_XMIT_CN, msg will be sent but delayed, mark ret
@@ -395,11 +402,13 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 	if (tx_info->l2te)
 		cxgb4_l2t_release(tx_info->l2te);
 
+#if IS_ENABLED(CONFIG_IPV6)
 	/* clear clip entry */
 	if (tx_info->ip_family == AF_INET6)
 		cxgb4_clip_release(netdev,
 				   (const u32 *)&sk->sk_v6_daddr.in6_u.u6_addr8,
 				   1);
+#endif
 
 	/* clear tid */
 	if (tx_info->tid != -1) {
@@ -490,12 +499,17 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 		goto out2;
 
 	/* get peer ip */
-	if (sk->sk_family == AF_INET ||
-	    (sk->sk_family == AF_INET6 && !sk->sk_ipv6only &&
-	     ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)) {
+	if (sk->sk_family == AF_INET
+#if IS_ENABLED(CONFIG_IPV6)
+	    || (sk->sk_family == AF_INET6 && !sk->sk_ipv6only &&
+	     ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED)
+#endif
+	    ) {
 		memcpy(daaddr, &sk->sk_daddr, 4);
 	} else {
+#if IS_ENABLED(CONFIG_IPV6)
 		memcpy(daaddr, sk->sk_v6_daddr.in6_u.u6_addr8, 16);
+#endif
 	}
 
 	/* get the l2t index */
-- 
2.26.0

