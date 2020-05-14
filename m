Return-Path: <SRS0=peSz=64=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D65EC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 07:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43D4C20675
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 07:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgENHyZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 May 2020 03:54:25 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:4317 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbgENHyZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 May 2020 03:54:25 -0400
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04E7s1H2023047;
        Thu, 14 May 2020 00:54:17 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        manojmalviya@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next 1/2] Crypto/chcr: Fixes compilations warnings
Date:   Thu, 14 May 2020 13:23:29 +0530
Message-Id: <20200514075330.25542-2-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.26.0.rc1.11.g30e9940
In-Reply-To: <20200514075330.25542-1-ayush.sawal@chelsio.com>
References: <20200514075330.25542-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes the compilation warnings displayed by sparse tool for
chcr driver.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c  | 8 ++++----
 drivers/crypto/chelsio/chcr_ipsec.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index b8c1c4dd3ef0..1aed0e8d6558 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -256,7 +256,7 @@ static void get_aes_decrypt_key(unsigned char *dec_key,
 		return;
 	}
 	for (i = 0; i < nk; i++)
-		w_ring[i] = be32_to_cpu(*(u32 *)&key[4 * i]);
+		w_ring[i] = be32_to_cpu(*(__be32 *)&key[4 * i]);
 
 	i = 0;
 	temp = w_ring[nk - 1];
@@ -275,7 +275,7 @@ static void get_aes_decrypt_key(unsigned char *dec_key,
 	}
 	i--;
 	for (k = 0, j = i % nk; k < nk; k++) {
-		*((u32 *)dec_key + k) = htonl(w_ring[j]);
+		*((__be32 *)dec_key + k) = htonl(w_ring[j]);
 		j--;
 		if (j < 0)
 			j += nk;
@@ -2926,7 +2926,7 @@ static int ccm_format_packet(struct aead_request *req,
 		memcpy(ivptr, req->iv, 16);
 	}
 	if (assoclen)
-		*((unsigned short *)(reqctx->scratch_pad + 16)) =
+		*((__be16 *)(reqctx->scratch_pad + 16)) =
 				htons(assoclen);
 
 	rc = generate_b0(req, ivptr, op_type);
@@ -3201,7 +3201,7 @@ static struct sk_buff *create_gcm_wr(struct aead_request *req,
 	} else {
 		memcpy(ivptr, req->iv, GCM_AES_IV_SIZE);
 	}
-	*((unsigned int *)(ivptr + 12)) = htonl(0x01);
+	*((__be32 *)(ivptr + 12)) = htonl(0x01);
 
 	ulptx = (struct ulptx_sgl *)(ivptr + 16);
 
diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index d25689837b26..3a10f51ad6fd 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -403,7 +403,7 @@ inline void *copy_esn_pktxt(struct sk_buff *skb,
 	xo = xfrm_offload(skb);
 
 	aadiv->spi = (esphdr->spi);
-	seqlo = htonl(esphdr->seq_no);
+	seqlo = ntohl(esphdr->seq_no);
 	seqno = cpu_to_be64(seqlo + ((u64)xo->seq.hi << 32));
 	memcpy(aadiv->seq_no, &seqno, 8);
 	iv = skb_transport_header(skb) + sizeof(struct ip_esp_hdr);
-- 
2.26.0.rc1.11.g30e9940

