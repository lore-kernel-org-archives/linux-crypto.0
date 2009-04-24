From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH v2 3/4] xfrm: Add a netlink attribute for software
	crypto accelerators
Date: Fri, 24 Apr 2009 12:28:28 +0200
Message-ID: <20090424102828.GE12680@secunet.com>
References: <20090424102451.GB12680@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:42609 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbZDXK0X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Apr 2009 06:26:23 -0400
Content-Disposition: inline
In-Reply-To: <20090424102451.GB12680@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a netlink attribute for software crypto
accelerators like pcrypt. This makes it possible to choose a
crypto accelerator template by it's name from the userspace.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/xfrm.h |   10 ++++++++++
 include/net/xfrm.h   |    3 +++
 net/xfrm/xfrm_user.c |    8 ++++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/xfrm.h b/include/linux/xfrm.h
index 2d4ec15..e20b74e 100644
--- a/include/linux/xfrm.h
+++ b/include/linux/xfrm.h
@@ -240,6 +240,15 @@ struct xfrm_encap_tmpl {
 	xfrm_address_t	encap_oa;
 };
 
+struct xfrm_accl {
+	char	name[64];
+	__u8	type;
+#define XFRM_ACCL_ENC	1
+#define XFRM_ACCL_AUTH	2	
+#define XFRM_ACCL_COMP	4
+#define XFRM_ACCL_AEAD	8
+};
+
 /* AEVENT flags  */
 enum xfrm_ae_ftype_t {
 	XFRM_AE_UNSPEC,
@@ -283,6 +292,7 @@ enum xfrm_attr_type_t {
 	XFRMA_MIGRATE,
 	XFRMA_ALG_AEAD,		/* struct xfrm_algo_aead */
 	XFRMA_KMADDRESS,        /* struct xfrm_user_kmaddress */
+	XFRMA_CRYPTO_ACCL,	/* struct xfrm_accl */
 	__XFRMA_MAX
 
 #define XFRMA_MAX (__XFRMA_MAX - 1)
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 2e9f5c0..b574147 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -171,6 +171,9 @@ struct xfrm_state
 	/* Data for care-of address */
 	xfrm_address_t	*coaddr;
 
+	/* Data for crypto accelerator */
+	struct xfrm_accl	*accl;
+
 	/* IPComp needs an IPIP tunnel for handling uncompressed packets */
 	struct xfrm_state	*tunnel;
 
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index b95a2d6..5272cbc 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -359,6 +359,13 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 			goto error;
 	}
 
+	if (attrs[XFRMA_CRYPTO_ACCL]) {
+		x->accl = kmemdup(nla_data(attrs[XFRMA_CRYPTO_ACCL]),
+				    sizeof(*x->accl), GFP_KERNEL);
+		if (x->accl == NULL)
+			goto error;
+	}
+
 	err = xfrm_init_state(x);
 	if (err)
 		goto error;
@@ -1958,6 +1965,7 @@ static const struct nla_policy xfrma_policy[XFRMA_MAX+1] = {
 	[XFRMA_POLICY_TYPE]	= { .len = sizeof(struct xfrm_userpolicy_type)},
 	[XFRMA_MIGRATE]		= { .len = sizeof(struct xfrm_user_migrate) },
 	[XFRMA_KMADDRESS]	= { .len = sizeof(struct xfrm_user_kmaddress) },
+	[XFRMA_CRYPTO_ACCL]	= { .len = sizeof(struct xfrm_accl) },
 };
 
 static struct xfrm_link {
-- 
1.5.4.2

