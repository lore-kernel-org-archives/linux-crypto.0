Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 338AEC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Nov 2021 12:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236251AbhKWMl2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Nov 2021 07:41:28 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:38914 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236694AbhKWMlY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Nov 2021 07:41:24 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 429C61FD60;
        Tue, 23 Nov 2021 12:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637671094; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FJG465KfwdElrV0bTBUGPXoVhIfTfLAXHvVyDhAj6Zg=;
        b=zg3YA+2zdQ/MptSAcfBcHxoNTwaFHQ8M7yDLoZicWOLVwhtwTRCyEGZ6GcA8P7y6r3+LSk
        YCBdclkWNDHEiPQkJ0VIHS2H9iUk8QHsSQotWMY7DGtiYnKg87q6v2EWYJ+MicHSK5SzY2
        9BM0h9TLS7wAytHLur2pdpVe7WPE37o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637671094;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FJG465KfwdElrV0bTBUGPXoVhIfTfLAXHvVyDhAj6Zg=;
        b=MpKmmPE3eUT9XF+hgctCsPlALN4nktgq8etcr+NiT8C5qpiFAuuZ/XIWhDgwDYve/Rdy/E
        ePQK0q61v/+2vHDA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 2F6A7A3B90;
        Tue, 23 Nov 2021 12:38:14 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id A7BAA51918C4; Tue, 23 Nov 2021 13:38:12 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 05/12] nvme: add definitions for NVMe In-Band authentication
Date:   Tue, 23 Nov 2021 13:37:54 +0100
Message-Id: <20211123123801.73197-6-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211123123801.73197-1-hare@suse.de>
References: <20211123123801.73197-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add new definitions for NVMe In-band authentication as defined in
the NVMe Base Specification v2.0.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 include/linux/nvme.h | 188 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 187 insertions(+), 1 deletion(-)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 855dd9b3e84b..d84594426e85 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -19,6 +19,7 @@
 #define NVMF_TRSVCID_SIZE	32
 #define NVMF_TRADDR_SIZE	256
 #define NVMF_TSAS_SIZE		256
+#define NVMF_AUTH_HASH_LEN	64
 
 #define NVME_DISC_SUBSYS_NAME	"nqn.2014-08.org.nvmexpress.discovery"
 
@@ -1278,6 +1279,8 @@ enum nvmf_capsule_command {
 	nvme_fabrics_type_property_set	= 0x00,
 	nvme_fabrics_type_connect	= 0x01,
 	nvme_fabrics_type_property_get	= 0x04,
+	nvme_fabrics_type_auth_send	= 0x05,
+	nvme_fabrics_type_auth_receive	= 0x06,
 };
 
 #define nvme_fabrics_type_name(type)   { type, #type }
@@ -1285,7 +1288,9 @@ enum nvmf_capsule_command {
 	__print_symbolic(type,						\
 		nvme_fabrics_type_name(nvme_fabrics_type_property_set),	\
 		nvme_fabrics_type_name(nvme_fabrics_type_connect),	\
-		nvme_fabrics_type_name(nvme_fabrics_type_property_get))
+		nvme_fabrics_type_name(nvme_fabrics_type_property_get), \
+		nvme_fabrics_type_name(nvme_fabrics_type_auth_send),	\
+		nvme_fabrics_type_name(nvme_fabrics_type_auth_receive))
 
 /*
  * If not fabrics command, fctype will be ignored.
@@ -1415,6 +1420,185 @@ struct nvmf_property_get_command {
 	__u8		resv4[16];
 };
 
+struct nvmf_auth_send_command {
+	__u8		opcode;
+	__u8		resv1;
+	__u16		command_id;
+	__u8		fctype;
+	__u8		resv2[19];
+	union nvme_data_ptr dptr;
+	__u8		resv3;
+	__u8		spsp0;
+	__u8		spsp1;
+	__u8		secp;
+	__le32		tl;
+	__u8		resv4[16];
+};
+
+struct nvmf_auth_receive_command {
+	__u8		opcode;
+	__u8		resv1;
+	__u16		command_id;
+	__u8		fctype;
+	__u8		resv2[19];
+	union nvme_data_ptr dptr;
+	__u8		resv3;
+	__u8		spsp0;
+	__u8		spsp1;
+	__u8		secp;
+	__le32		al;
+	__u8		resv4[16];
+};
+
+/* Value for secp */
+enum {
+	NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER	= 0xe9,
+};
+
+/* Defined value for auth_type */
+enum {
+	NVME_AUTH_COMMON_MESSAGES	= 0x00,
+	NVME_AUTH_DHCHAP_MESSAGES	= 0x01,
+};
+
+/* Defined messages for auth_id */
+enum {
+	NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE	= 0x00,
+	NVME_AUTH_DHCHAP_MESSAGE_CHALLENGE	= 0x01,
+	NVME_AUTH_DHCHAP_MESSAGE_REPLY		= 0x02,
+	NVME_AUTH_DHCHAP_MESSAGE_SUCCESS1	= 0x03,
+	NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2	= 0x04,
+	NVME_AUTH_DHCHAP_MESSAGE_FAILURE2	= 0xf0,
+	NVME_AUTH_DHCHAP_MESSAGE_FAILURE1	= 0xf1,
+};
+
+struct nvmf_auth_dhchap_protocol_descriptor {
+	__u8		authid;
+	__u8		rsvd;
+	__u8		halen;
+	__u8		dhlen;
+	__u8		idlist[60];
+};
+
+enum {
+	NVME_AUTH_DHCHAP_AUTH_ID	= 0x01,
+};
+
+/* Defined hash functions for DH-HMAC-CHAP authentication */
+enum {
+	NVME_AUTH_HASH_SHA256	= 0x01,
+	NVME_AUTH_HASH_SHA384	= 0x02,
+	NVME_AUTH_HASH_SHA512	= 0x03,
+	NVME_AUTH_HASH_INVALID	= 0xff,
+};
+
+/* Defined Diffie-Hellman group identifiers for DH-HMAC-CHAP authentication */
+enum {
+	NVME_AUTH_DHGROUP_NULL		= 0x00,
+	NVME_AUTH_DHGROUP_2048		= 0x01,
+	NVME_AUTH_DHGROUP_3072		= 0x02,
+	NVME_AUTH_DHGROUP_4096		= 0x03,
+	NVME_AUTH_DHGROUP_6144		= 0x04,
+	NVME_AUTH_DHGROUP_8192		= 0x05,
+	NVME_AUTH_DHGROUP_INVALID	= 0xff,
+};
+
+union nvmf_auth_protocol {
+	struct nvmf_auth_dhchap_protocol_descriptor dhchap;
+};
+
+struct nvmf_auth_dhchap_negotiate_data {
+	__u8		auth_type;
+	__u8		auth_id;
+	__le16		rsvd;
+	__le16		t_id;
+	__u8		sc_c;
+	__u8		napd;
+	union nvmf_auth_protocol auth_protocol[];
+};
+
+struct nvmf_auth_dhchap_challenge_data {
+	__u8		auth_type;
+	__u8		auth_id;
+	__u16		rsvd1;
+	__le16		t_id;
+	__u8		hl;
+	__u8		rsvd2;
+	__u8		hashid;
+	__u8		dhgid;
+	__le16		dhvlen;
+	__le32		seqnum;
+	/* 'hl' bytes of challenge value */
+	__u8		cval[];
+	/* followed by 'dhvlen' bytes of DH value */
+};
+
+struct nvmf_auth_dhchap_reply_data {
+	__u8		auth_type;
+	__u8		auth_id;
+	__le16		rsvd1;
+	__le16		t_id;
+	__u8		hl;
+	__u8		rsvd2;
+	__u8		cvalid;
+	__u8		rsvd3;
+	__le16		dhvlen;
+	__le32		seqnum;
+	/* 'hl' bytes of response data */
+	__u8		rval[];
+	/* followed by 'hl' bytes of Challenge value */
+	/* followed by 'dhvlen' bytes of DH value */
+};
+
+enum {
+	NVME_AUTH_DHCHAP_RESPONSE_VALID	= (1 << 0),
+};
+
+struct nvmf_auth_dhchap_success1_data {
+	__u8		auth_type;
+	__u8		auth_id;
+	__le16		rsvd1;
+	__le16		t_id;
+	__u8		hl;
+	__u8		rsvd2;
+	__u8		rvalid;
+	__u8		rsvd3[7];
+	/* 'hl' bytes of response value if 'rvalid' is set */
+	__u8		rval[];
+};
+
+struct nvmf_auth_dhchap_success2_data {
+	__u8		auth_type;
+	__u8		auth_id;
+	__le16		rsvd1;
+	__le16		t_id;
+	__u8		rsvd2[10];
+};
+
+struct nvmf_auth_dhchap_failure_data {
+	__u8		auth_type;
+	__u8		auth_id;
+	__le16		rsvd1;
+	__le16		t_id;
+	__u8		rescode;
+	__u8		rescode_exp;
+};
+
+enum {
+	NVME_AUTH_DHCHAP_FAILURE_REASON_FAILED	= 0x01,
+};
+
+enum {
+	NVME_AUTH_DHCHAP_FAILURE_FAILED			= 0x01,
+	NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE		= 0x02,
+	NVME_AUTH_DHCHAP_FAILURE_CONCAT_MISMATCH	= 0x03,
+	NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE		= 0x04,
+	NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE	= 0x05,
+	NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD	= 0x06,
+	NVME_AUTH_DHCHAP_FAILURE_INCORRECT_MESSAGE	= 0x07,
+};
+
+
 struct nvme_dbbuf {
 	__u8			opcode;
 	__u8			flags;
@@ -1458,6 +1642,8 @@ struct nvme_command {
 		struct nvmf_connect_command connect;
 		struct nvmf_property_set_command prop_set;
 		struct nvmf_property_get_command prop_get;
+		struct nvmf_auth_send_command auth_send;
+		struct nvmf_auth_receive_command auth_receive;
 		struct nvme_dbbuf dbbuf;
 		struct nvme_directive_cmd directive;
 	};
-- 
2.29.2

