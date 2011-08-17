From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v2 02/15] crypto: Add userspace configuration API
Date: Wed, 17 Aug 2011 14:10:13 +0200
Message-ID: <20110817121013.GZ16877@secunet.com>
References: <20110817120859.GX16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:41230 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab1HQMJg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2011 08:09:36 -0400
Content-Disposition: inline
In-Reply-To: <20110817120859.GX16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a basic userspace configuration API for the crypto layer.
With this it is possible to instantiate, remove and to show crypto
algorithms from userspace.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/Kconfig             |    7 +
 crypto/Makefile            |    1 +
 crypto/crypto_user.c       |  331 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cryptouser.h |   57 ++++++++
 include/linux/netlink.h    |    1 +
 5 files changed, 397 insertions(+), 0 deletions(-)
 create mode 100644 crypto/crypto_user.c
 create mode 100644 include/linux/cryptouser.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 55c50cd..c05d0df 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -100,6 +100,13 @@ config CRYPTO_MANAGER2
 	select CRYPTO_BLKCIPHER2
 	select CRYPTO_PCOMP2
 
+config CRYPTO_USER
+	tristate "Userspace cryptographic algorithm configuration"
+	select CRYPTO_MANAGER
+	help
+	  Userapace configuration for cryptographic instantiations such as
+	  cbc(aes).
+
 config CRYPTO_MANAGER_DISABLE_TESTS
 	bool "Disable run-time self tests"
 	default y
diff --git a/crypto/Makefile b/crypto/Makefile
index ce5a813..4c4171b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
 cryptomgr-y := algboss.o testmgr.o
 
 obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
+obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
 obj-$(CONFIG_CRYPTO_VMAC) += vmac.o
 obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
new file mode 100644
index 0000000..4edd015
--- /dev/null
+++ b/crypto/crypto_user.c
@@ -0,0 +1,331 @@
+/*
+ * Crypto user configuration API.
+ *
+ * Copyright (C) 2011 secunet Security Networks AG
+ * Copyright (C) 2011 Steffen Klassert <steffen.klassert@secunet.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/cryptouser.h>
+#include <net/netlink.h>
+#include <linux/security.h>
+#include <net/net_namespace.h>
+#include "internal.h"
+
+DEFINE_MUTEX(crypto_cfg_mutex);
+
+/* The crypto netlink socket */
+static struct sock *crypto_nlsk;
+
+struct crypto_dump_info {
+	struct sk_buff *in_skb;
+	struct sk_buff *out_skb;
+	u32 nlmsg_seq;
+	u16 nlmsg_flags;
+};
+
+static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p)
+{
+	int match;
+	struct crypto_alg *q, *alg = NULL;
+
+	down_read(&crypto_alg_sem);
+
+	if (list_empty(&crypto_alg_list))
+		return NULL;
+
+	list_for_each_entry(q, &crypto_alg_list, cra_list) {
+
+		if ((q->cra_flags ^ p->type) & p->mask)
+			continue;
+
+		if (strlen(p->cru_driver_name))
+			match = !strcmp(q->cra_driver_name,
+					p->cru_driver_name);
+		else
+			match = !strcmp(q->cra_name, p->cru_name);
+		if (match) {
+			alg = q;
+			break;
+		}
+	}
+
+	up_read(&crypto_alg_sem);
+
+	return alg;
+}
+
+static int crypto_report_one(struct crypto_alg *alg,
+			     struct crypto_report_base *rb, struct sk_buff *skb)
+{
+	memcpy(&rb->name, &alg->cra_name, sizeof(rb->name));
+	memcpy(&rb->driver_name, &alg->cra_driver_name, sizeof(rb->driver_name));
+	memcpy(&rb->module_name, module_name(alg->cra_module), CRYPTO_MAX_ALG_NAME);
+	snprintf(rb->selftest, CRYPTO_MAX_ALG_NAME, "%s",
+		 (alg->cra_flags & CRYPTO_ALG_TESTED) ? "passed" : "unknown");
+
+	rb->priority = alg->cra_priority;
+	rb->refcnt = atomic_read(&alg->cra_refcnt);
+
+	return 0;
+}
+
+static int crypto_report_alg(struct crypto_alg *alg,
+			     struct crypto_dump_info *info)
+{
+	struct sk_buff *in_skb = info->in_skb;
+	struct sk_buff *skb = info->out_skb;
+	struct nlmsghdr *nlh;
+	struct crypto_report_base *rb;
+	int err = 0;
+
+	nlh = nlmsg_put(skb, NETLINK_CB(in_skb).pid, info->nlmsg_seq,
+			CRYPTO_MSG_GETALG, sizeof(*rb), info->nlmsg_flags);
+	if (!nlh) {
+		err = -EMSGSIZE;
+		goto out;
+	}
+
+	rb = nlmsg_data(nlh);
+
+	err = crypto_report_one(alg, rb, skb);
+	if (err) {
+		nlmsg_cancel(skb, nlh);
+		goto out;
+	}
+
+	nlmsg_end(skb, nlh);
+
+out:
+	return err;
+}
+
+static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
+			 struct nlattr **attrs)
+{
+	struct crypto_user_alg *p = nlmsg_data(in_nlh);
+	struct crypto_alg *alg;
+	struct sk_buff *skb;
+	struct crypto_dump_info info;
+	int err;
+
+	if (!p->cru_driver_name)
+		return -EINVAL;
+
+	alg = crypto_alg_match(p);
+	if (!alg)
+		return -ENOENT;
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	info.in_skb = in_skb;
+	info.out_skb = skb;
+	info.nlmsg_seq = in_nlh->nlmsg_seq;
+	info.nlmsg_flags = 0;
+
+	err = crypto_report_alg(alg, &info);
+	if (err)
+		return err;
+
+	return nlmsg_unicast(crypto_nlsk, skb, NETLINK_CB(in_skb).pid);
+}
+
+static int crypto_dump_report(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct crypto_alg *alg;
+	struct crypto_dump_info info;
+	int err;
+
+	if (cb->args[0])
+		goto out;
+
+	cb->args[0] = 1;
+
+	info.in_skb = cb->skb;
+	info.out_skb = skb;
+	info.nlmsg_seq = cb->nlh->nlmsg_seq;
+	info.nlmsg_flags = NLM_F_MULTI;
+
+	list_for_each_entry(alg, &crypto_alg_list, cra_list) {
+		err = crypto_report_alg(alg, &info);
+		if (err)
+			goto out_err;
+	}
+
+out:
+	return skb->len;
+out_err:
+	return err;
+}
+
+static int crypto_dump_report_done(struct netlink_callback *cb)
+{
+	return 0;
+}
+
+static int crypto_del_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
+			  struct nlattr **attrs)
+{
+	struct crypto_alg *alg;
+	struct crypto_user_alg *p = nlmsg_data(nlh);
+
+	alg = crypto_alg_match(p);
+	if (!alg)
+		return -ENOENT;
+
+	/* We can not unregister core algorithms such as aes-generic.
+	 * We would loose the reference in the crypto_alg_list to this algorithm
+	 * if we try to unregister. Unregistering such an algorithm without
+	 * removing the module is not possible, so we restrict to crypto
+	 * instances that are build from templates. */
+	if (!(alg->cra_flags & CRYPTO_ALG_INSTANCE))
+		return -EINVAL;
+
+	if (atomic_read(&alg->cra_refcnt) != 1)
+		return -EBUSY;
+
+	return crypto_unregister_alg(alg);
+}
+
+static int crypto_add_alg(struct sk_buff *skb, struct nlmsghdr *nlh,
+			  struct nlattr **attrs)
+{
+	const char *name;
+	struct crypto_alg *alg;
+	struct crypto_user_alg *p = nlmsg_data(nlh);
+	struct nlattr *priority = attrs[CRYPTOCFGA_PRIORITY_VAL];
+
+	if (priority && !strlen(p->cru_driver_name))
+		return -EINVAL;
+
+	alg = crypto_alg_match(p);
+	if (alg)
+		return -EEXIST;
+
+	if (strlen(p->cru_driver_name))
+		name = p->cru_driver_name;
+	else
+		name = p->cru_name;
+
+	alg = crypto_alg_mod_lookup(name, p->type, p->mask);
+	if (IS_ERR(alg))
+		return PTR_ERR(alg);
+
+	down_write(&crypto_alg_sem);
+
+	if (priority)
+		alg->cra_priority = nla_get_u32(priority);
+
+	up_write(&crypto_alg_sem);
+
+	crypto_mod_put(alg);
+
+	return 0;
+}
+
+#define MSGSIZE(type) sizeof(struct type)
+
+static const int crypto_msg_min[CRYPTO_NR_MSGTYPES] = {
+	[CRYPTO_MSG_NEWALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
+	[CRYPTO_MSG_DELALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
+	[CRYPTO_MSG_GETALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
+};
+
+static const struct nla_policy crypto_policy[CRYPTOCFGA_MAX+1] = {
+	[CRYPTOCFGA_PRIORITY_VAL]   = { .type = NLA_U32},
+};
+
+#undef MSGSIZE
+
+static struct crypto_link {
+	int (*doit)(struct sk_buff *, struct nlmsghdr *, struct nlattr **);
+	int (*dump)(struct sk_buff *, struct netlink_callback *);
+	int (*done)(struct netlink_callback *);
+} crypto_dispatch[CRYPTO_NR_MSGTYPES] = {
+	[CRYPTO_MSG_NEWALG	- CRYPTO_MSG_BASE] = { .doit = crypto_add_alg},
+	[CRYPTO_MSG_DELALG	- CRYPTO_MSG_BASE] = { .doit = crypto_del_alg},
+	[CRYPTO_MSG_GETALG	- CRYPTO_MSG_BASE] = { .doit = crypto_report,
+						       .dump = crypto_dump_report,
+						       .done = crypto_dump_report_done},
+};
+
+static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
+{
+	struct nlattr *attrs[CRYPTOCFGA_MAX+1];
+	struct crypto_link *link;
+	int type, err;
+
+	type = nlh->nlmsg_type;
+	if (type > CRYPTO_MSG_MAX)
+		return -EINVAL;
+
+	type -= CRYPTO_MSG_BASE;
+	link = &crypto_dispatch[type];
+
+	if (security_netlink_recv(skb, CAP_NET_ADMIN))
+		return -EPERM;
+
+	if ((type == (CRYPTO_MSG_GETALG - CRYPTO_MSG_BASE) &&
+	    (nlh->nlmsg_flags & NLM_F_DUMP))) {
+		if (link->dump == NULL)
+			return -EINVAL;
+
+		return netlink_dump_start(crypto_nlsk, skb, nlh,
+					  link->dump, link->done, 0);
+	}
+
+	err = nlmsg_parse(nlh, crypto_msg_min[type], attrs, CRYPTOCFGA_MAX,
+			  crypto_policy);
+	if (err < 0)
+		return err;
+
+	if (link->doit == NULL)
+		return -EINVAL;
+
+	return link->doit(skb, nlh, attrs);
+}
+
+static void crypto_netlink_rcv(struct sk_buff *skb)
+{
+	mutex_lock(&crypto_cfg_mutex);
+	netlink_rcv_skb(skb, &crypto_user_rcv_msg);
+	mutex_unlock(&crypto_cfg_mutex);
+}
+
+static int __init crypto_user_init(void)
+{
+	crypto_nlsk = netlink_kernel_create(&init_net, NETLINK_CRYPTO,
+					    0, crypto_netlink_rcv,
+					    NULL, THIS_MODULE);
+	if (!crypto_nlsk)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void __exit crypto_user_exit(void)
+{
+	netlink_kernel_release(crypto_nlsk);
+}
+
+module_init(crypto_user_init);
+module_exit(crypto_user_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Steffen Klassert <steffen.klassert@secunet.com>");
+MODULE_DESCRIPTION("Crypto userspace configuration API");
diff --git a/include/linux/cryptouser.h b/include/linux/cryptouser.h
new file mode 100644
index 0000000..3245081
--- /dev/null
+++ b/include/linux/cryptouser.h
@@ -0,0 +1,57 @@
+/*
+ * Crypto user configuration API.
+ *
+ * Copyright (C) 2011 secunet Security Networks AG
+ * Copyright (C) 2011 Steffen Klassert <steffen.klassert@secunet.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+/* Netlink configuration messages.  */
+enum {
+	CRYPTO_MSG_BASE = 0x10,
+	CRYPTO_MSG_NEWALG = 0x10,
+	CRYPTO_MSG_DELALG,
+	CRYPTO_MSG_GETALG,
+	__CRYPTO_MSG_MAX
+};
+#define CRYPTO_MSG_MAX (__CRYPTO_MSG_MAX - 1)
+#define CRYPTO_NR_MSGTYPES (CRYPTO_MSG_MAX + 1 - CRYPTO_MSG_BASE)
+
+/* Netlink message attributes.  */
+enum crypto_attr_type_t {
+	CRYPTOCFGA_UNSPEC,
+	CRYPTOCFGA_PRIORITY_VAL,	/* __u32 */
+	__CRYPTOCFGA_MAX
+
+#define CRYPTOCFGA_MAX (__CRYPTOCFGA_MAX - 1)
+};
+
+struct crypto_user_alg {
+	char cru_name[CRYPTO_MAX_ALG_NAME];
+	char cru_driver_name[CRYPTO_MAX_ALG_NAME];
+	__u32 type;
+	__u32 mask;
+};
+
+#define CRYPTO_MAX_NAME CRYPTO_MAX_ALG_NAME
+
+struct crypto_report_base {
+	char name[CRYPTO_MAX_ALG_NAME];
+	char driver_name[CRYPTO_MAX_ALG_NAME];
+	char module_name[CRYPTO_MAX_NAME];
+	char selftest[CRYPTO_MAX_NAME];
+	int priority;
+	int refcnt;
+};
diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 2e17c5d..464ace0 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -25,6 +25,7 @@
 #define NETLINK_SCSITRANSPORT	18	/* SCSI Transports */
 #define NETLINK_ECRYPTFS	19
 #define NETLINK_RDMA		20
+#define NETLINK_CRYPTO		21	/* Crypto layer */
 
 #define MAX_LINKS 32		
 
-- 
1.7.0.4
