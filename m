Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B52C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 18 May 2022 11:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbiERLXB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 May 2022 07:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbiERLW7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 May 2022 07:22:59 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2679F15E4BC
        for <linux-crypto@vger.kernel.org>; Wed, 18 May 2022 04:22:54 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5A2D61F8CD;
        Wed, 18 May 2022 11:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652872973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=izhHAncDilHcZDgL+iXPx4vIKbUbUyLFl3LebJoaW4k=;
        b=bbcGYVfyxSuGY0f1lx2SEIp4SlpUL41JXiW2PM+xpTa8F+BQdx5gplFjiU5Dllm4aSd62H
        5NQBtd7PvqRRuHX8jAl2R9ylOcuDdGhotglK1rlr4wqIet4xCkF4Nce1IDJmAUtUbLQEtp
        wZk1HCt8khUXCBI02p4lw8zv1q30AOg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652872973;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=izhHAncDilHcZDgL+iXPx4vIKbUbUyLFl3LebJoaW4k=;
        b=p7tym9l+j4zjz/8T0yrro6oGbq3Hkly9y019QwJ2ce/YhDjSIrDY8dLgWKG05JXP1fEbeN
        iqZSMisiSlFiKFDQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 4A29E2C141;
        Wed, 18 May 2022 11:22:52 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 8217C519450D; Wed, 18 May 2022 13:22:52 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH 04/11] nvme: add definitions for NVMe In-Band authentication
Date:   Wed, 18 May 2022 13:22:27 +0200
Message-Id: <20220518112234.24264-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220518112234.24264-1-hare@suse.de>
References: <20220518112234.24264-1-hare@suse.de>
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
 include/linux/nvme.h | 204 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 203 insertions(+), 1 deletion(-)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 5f6d432fa06a..66190a4691c1 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -19,6 +19,7 @@
 #define NVMF_TRSVCID_SIZE	32
 #define NVMF_TRADDR_SIZE	256
 #define NVMF_TSAS_SIZE		256
+#define NVMF_AUTH_HASH_LEN	64
 
 #define NVME_DISC_SUBSYS_NAME	"nqn.2014-08.org.nvmexpress.discovery"
 
@@ -1337,6 +1338,8 @@ enum nvmf_capsule_command {
 	nvme_fabrics_type_property_set	= 0x00,
 	nvme_fabrics_type_connect	= 0x01,
 	nvme_fabrics_type_property_get	= 0x04,
+	nvme_fabrics_type_auth_send	= 0x05,
+	nvme_fabrics_type_auth_receive	= 0x06,
 };
 
 #define nvme_fabrics_type_name(type)   { type, #type }
@@ -1344,7 +1347,9 @@ enum nvmf_capsule_command {
 	__print_symbolic(type,						\
 		nvme_fabrics_type_name(nvme_fabrics_type_property_set),	\
 		nvme_fabrics_type_name(nvme_fabrics_type_connect),	\
-		nvme_fabrics_type_name(nvme_fabrics_type_property_get))
+		nvme_fabrics_type_name(nvme_fabrics_type_property_get), \
+		nvme_fabrics_type_name(nvme_fabrics_type_auth_send),	\
+		nvme_fabrics_type_name(nvme_fabrics_type_auth_receive))
 
 /*
  * If not fabrics command, fctype will be ignored.
@@ -1474,6 +1479,200 @@ struct nvmf_property_get_command {
 	__u8		resv4[16];
 };
 
+struct nvmf_auth_common_command {
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
+	__le32		al_tl;
+	__u8		resv4[16];
+};
+
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
@@ -1517,6 +1716,9 @@ struct nvme_command {
 		struct nvmf_connect_command connect;
 		struct nvmf_property_set_command prop_set;
 		struct nvmf_property_get_command prop_get;
+		struct nvmf_auth_common_command auth_common;
+		struct nvmf_auth_send_command auth_send;
+		struct nvmf_auth_receive_command auth_receive;
 		struct nvme_dbbuf dbbuf;
 		struct nvme_directive_cmd directive;
 	};
-- 
2.29.2

