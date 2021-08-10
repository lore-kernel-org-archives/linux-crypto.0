Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B840CC43214
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Aug 2021 12:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E3E160EFF
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Aug 2021 12:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240713AbhHJMnZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Aug 2021 08:43:25 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:43718 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240734AbhHJMnQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Aug 2021 08:43:16 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3BCFE200B3;
        Tue, 10 Aug 2021 12:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628599372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MUoNB1RE7VhyoT1+GvVF1n3f2kAKysSACL4JZIm62EA=;
        b=EX2vEI9iPdolviNRyMxdRU3CU11O4eOfGgO6VJpppShc8sUqjxev9d8M8aYZqSw13WphTh
        EoeWw5f+xYhnlDlZw3hGORRaLLLTc54ZtVzdxDiembtjbjJnVe7cZfHlfaKpB/iGuF19Ds
        USY31qdDkSHXqLG7pQCqGdzXbMJT5xQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628599372;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MUoNB1RE7VhyoT1+GvVF1n3f2kAKysSACL4JZIm62EA=;
        b=WFcQNkEFlZB//F5QFZeBEPxbYqgMdFIqhGS24JWxwebjGtKxSY9wgEMcjgmh5jYRMiu64y
        +/IoSmOIaqtRnfAQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 20CD7A3B96;
        Tue, 10 Aug 2021 12:42:52 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 8D902518C55A; Tue, 10 Aug 2021 14:42:50 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/13] nvme: add non-standard ECDH and curve25517 algorithms
Date:   Tue, 10 Aug 2021 14:42:30 +0200
Message-Id: <20210810124230.12161-14-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210810124230.12161-1-hare@suse.de>
References: <20210810124230.12161-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

TLS 1.3 specifies ECDH and curve25517 in addition to the FFDHE
groups, and these are already implemented in the kernel.
So add support for these non-standard groups for NVMe in-band
authentication to validate the augmented challenge implementation.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/host/auth.c | 34 +++++++++++++++++++++++++++++++++-
 include/linux/nvme.h     |  2 ++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index e73b5be4a4b0..6de2910eec80 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -9,6 +9,8 @@
 #include <crypto/hash.h>
 #include <crypto/dh.h>
 #include <crypto/ffdhe.h>
+#include <crypto/ecdh.h>
+#include <crypto/curve25519.h>
 #include "nvme.h"
 #include "fabrics.h"
 #include "auth.h"
@@ -69,6 +71,13 @@ static struct nvme_auth_dhgroup_map {
 	{ .id = NVME_AUTH_DHCHAP_DHGROUP_8192,
 	  .name = "ffdhe8192", .kpp = "dh",
 	  .privkey_size = 1024, .pubkey_size = 1024 },
+	{ .id = NVME_AUTH_DHCHAP_DHGROUP_ECDH,
+	  .name = "ecdh", .kpp = "ecdh-nist-p256",
+	  .privkey_size = 32, .pubkey_size = 64 },
+	{ .id = NVME_AUTH_DHCHAP_DHGROUP_25519,
+	  .name = "curve25519", .kpp = "curve25519",
+	  .privkey_size = CURVE25519_KEY_SIZE,
+	  .pubkey_size = CURVE25519_KEY_SIZE },
 };
 
 const char *nvme_auth_dhgroup_name(int dhgroup_id)
@@ -424,6 +433,27 @@ int nvme_auth_gen_privkey(struct crypto_kpp *dh_tfm, int dh_gid)
 			kfree_sensitive(dh_secret);
 			goto out;
 		}
+	} else if (dh_gid == NVME_AUTH_DHCHAP_DHGROUP_ECDH) {
+		struct ecdh p = {0};
+
+		pkey_len = crypto_ecdh_key_len(&p);
+		pkey = kmalloc(pkey_len, GFP_KERNEL);
+		if (!pkey)
+			return -ENOMEM;
+
+		get_random_bytes(pkey, pkey_len);
+		ret = crypto_ecdh_encode_key(pkey, pkey_len, &p);
+		if (ret) {
+			pr_debug("failed to encode private key, error %d\n",
+				 ret);
+			goto out;
+		}
+	} else if (dh_gid == NVME_AUTH_DHCHAP_DHGROUP_25519) {
+		pkey_len = CURVE25519_KEY_SIZE;
+		pkey = kmalloc(pkey_len, GFP_KERNEL);
+		if (!pkey)
+			return -ENOMEM;
+		get_random_bytes(pkey, pkey_len);
 	} else {
 		pr_warn("invalid dh group %d\n", dh_gid);
 		return -EINVAL;
@@ -597,7 +627,7 @@ static int nvme_auth_set_dhchap_negotiate_data(struct nvme_ctrl *ctrl,
 	data->napd = 1;
 	data->auth_protocol[0].dhchap.authid = NVME_AUTH_DHCHAP_AUTH_ID;
 	data->auth_protocol[0].dhchap.halen = 3;
-	data->auth_protocol[0].dhchap.dhlen = 6;
+	data->auth_protocol[0].dhchap.dhlen = 8;
 	data->auth_protocol[0].dhchap.idlist[0] = NVME_AUTH_DHCHAP_SHA256;
 	data->auth_protocol[0].dhchap.idlist[1] = NVME_AUTH_DHCHAP_SHA384;
 	data->auth_protocol[0].dhchap.idlist[2] = NVME_AUTH_DHCHAP_SHA512;
@@ -607,6 +637,8 @@ static int nvme_auth_set_dhchap_negotiate_data(struct nvme_ctrl *ctrl,
 	data->auth_protocol[0].dhchap.idlist[6] = NVME_AUTH_DHCHAP_DHGROUP_4096;
 	data->auth_protocol[0].dhchap.idlist[7] = NVME_AUTH_DHCHAP_DHGROUP_6144;
 	data->auth_protocol[0].dhchap.idlist[8] = NVME_AUTH_DHCHAP_DHGROUP_8192;
+	data->auth_protocol[0].dhchap.idlist[9] = NVME_AUTH_DHCHAP_DHGROUP_ECDH;
+	data->auth_protocol[0].dhchap.idlist[10] = NVME_AUTH_DHCHAP_DHGROUP_25519;
 
 	return size;
 }
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index e2142e3246eb..e1145bbfc92f 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -1477,6 +1477,8 @@ enum {
 	NVME_AUTH_DHCHAP_DHGROUP_4096	= 0x03,
 	NVME_AUTH_DHCHAP_DHGROUP_6144	= 0x04,
 	NVME_AUTH_DHCHAP_DHGROUP_8192	= 0x05,
+	NVME_AUTH_DHCHAP_DHGROUP_ECDH   = 0x0e,
+	NVME_AUTH_DHCHAP_DHGROUP_25519  = 0x0f,
 };
 
 union nvmf_auth_protocol {
-- 
2.29.2

