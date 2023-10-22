Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76126C25B46
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjJVITD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjJVISw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C9F124
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AFEC43395
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962727;
        bh=ADeN/ZcvSOtk0xzds/Rjes9cMXM9bWKAFg7ZICtWoM8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hZmDwLHuWTchSz0dU+RKvEja8fZQDN4a+LyPmzn2k3XsRsNqzC5CTgJTknvsuImlw
         D/hG2I2XOmmbSaxaLQZ6/FrE7ckPtknEG3+u+UrLCknJJA0OPVtKg49Irqh1dHw1Ts
         YSZ2RhBB6Cqm9suQtKiihL5GkztkD9iztjMkOg7MDHIlpa3pHs8Vc7yTrPv2bJLLfz
         F0gcitYXOQkcfy244Str7LnQ3sLH5LYOEMwFelPEwZMLp2L+cr5AqmKtoybKuVtRhX
         intThyYDDXyYoGkd8apaTXgrrC9j9d6tV16tdczDq0vqGGe03IMneTLxl+LxSkJ5Nk
         M/0d8ejQ4dy2A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 18/30] net: ipv4: stop checking crypto_ahash_alignmask
Date:   Sun, 22 Oct 2023 01:10:48 -0700
Message-ID: <20231022081100.123613-19-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that the alignmask for ahash and shash algorithms is always 0,
crypto_ahash_alignmask() always returns 0 and will be removed.  In
preparation for this, stop checking crypto_ahash_alignmask() in ah4.c.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/ipv4/ah4.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index bc0f968c5d5b4..a2e6e1fdf82be 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -20,43 +20,40 @@ struct ah_skb_cb {
 	void *tmp;
 };
 
 #define AH_SKB_CB(__skb) ((struct ah_skb_cb *)&((__skb)->cb[0]))
 
 static void *ah_alloc_tmp(struct crypto_ahash *ahash, int nfrags,
 			  unsigned int size)
 {
 	unsigned int len;
 
-	len = size + crypto_ahash_digestsize(ahash) +
-	      (crypto_ahash_alignmask(ahash) &
-	       ~(crypto_tfm_ctx_alignment() - 1));
+	len = size + crypto_ahash_digestsize(ahash);
 
 	len = ALIGN(len, crypto_tfm_ctx_alignment());
 
 	len += sizeof(struct ahash_request) + crypto_ahash_reqsize(ahash);
 	len = ALIGN(len, __alignof__(struct scatterlist));
 
 	len += sizeof(struct scatterlist) * nfrags;
 
 	return kmalloc(len, GFP_ATOMIC);
 }
 
 static inline u8 *ah_tmp_auth(void *tmp, unsigned int offset)
 {
 	return tmp + offset;
 }
 
-static inline u8 *ah_tmp_icv(struct crypto_ahash *ahash, void *tmp,
-			     unsigned int offset)
+static inline u8 *ah_tmp_icv(void *tmp, unsigned int offset)
 {
-	return PTR_ALIGN((u8 *)tmp + offset, crypto_ahash_alignmask(ahash) + 1);
+	return tmp + offset;
 }
 
 static inline struct ahash_request *ah_tmp_req(struct crypto_ahash *ahash,
 					       u8 *icv)
 {
 	struct ahash_request *req;
 
 	req = (void *)PTR_ALIGN(icv + crypto_ahash_digestsize(ahash),
 				crypto_tfm_ctx_alignment());
 
@@ -122,21 +119,21 @@ static void ah_output_done(void *data, int err)
 	u8 *icv;
 	struct iphdr *iph;
 	struct sk_buff *skb = data;
 	struct xfrm_state *x = skb_dst(skb)->xfrm;
 	struct ah_data *ahp = x->data;
 	struct iphdr *top_iph = ip_hdr(skb);
 	struct ip_auth_hdr *ah = ip_auth_hdr(skb);
 	int ihl = ip_hdrlen(skb);
 
 	iph = AH_SKB_CB(skb)->tmp;
-	icv = ah_tmp_icv(ahp->ahash, iph, ihl);
+	icv = ah_tmp_icv(iph, ihl);
 	memcpy(ah->auth_data, icv, ahp->icv_trunc_len);
 
 	top_iph->tos = iph->tos;
 	top_iph->ttl = iph->ttl;
 	top_iph->frag_off = iph->frag_off;
 	if (top_iph->ihl != 5) {
 		top_iph->daddr = iph->daddr;
 		memcpy(top_iph+1, iph+1, top_iph->ihl*4 - sizeof(struct iphdr));
 	}
 
@@ -175,21 +172,21 @@ static int ah_output(struct xfrm_state *x, struct sk_buff *skb)
 
 	if (x->props.flags & XFRM_STATE_ESN) {
 		sglists = 1;
 		seqhi_len = sizeof(*seqhi);
 	}
 	err = -ENOMEM;
 	iph = ah_alloc_tmp(ahash, nfrags + sglists, ihl + seqhi_len);
 	if (!iph)
 		goto out;
 	seqhi = (__be32 *)((char *)iph + ihl);
-	icv = ah_tmp_icv(ahash, seqhi, seqhi_len);
+	icv = ah_tmp_icv(seqhi, seqhi_len);
 	req = ah_tmp_req(ahash, icv);
 	sg = ah_req_sg(ahash, req);
 	seqhisg = sg + nfrags;
 
 	memset(ah->auth_data, 0, ahp->icv_trunc_len);
 
 	top_iph = ip_hdr(skb);
 
 	iph->tos = top_iph->tos;
 	iph->ttl = top_iph->ttl;
@@ -272,21 +269,21 @@ static void ah_input_done(void *data, int err)
 	struct ah_data *ahp = x->data;
 	struct ip_auth_hdr *ah = ip_auth_hdr(skb);
 	int ihl = ip_hdrlen(skb);
 	int ah_hlen = (ah->hdrlen + 2) << 2;
 
 	if (err)
 		goto out;
 
 	work_iph = AH_SKB_CB(skb)->tmp;
 	auth_data = ah_tmp_auth(work_iph, ihl);
-	icv = ah_tmp_icv(ahp->ahash, auth_data, ahp->icv_trunc_len);
+	icv = ah_tmp_icv(auth_data, ahp->icv_trunc_len);
 
 	err = crypto_memneq(icv, auth_data, ahp->icv_trunc_len) ? -EBADMSG : 0;
 	if (err)
 		goto out;
 
 	err = ah->nexthdr;
 
 	skb->network_header += ah_hlen;
 	memcpy(skb_network_header(skb), work_iph, ihl);
 	__skb_pull(skb, ah_hlen + ihl);
@@ -367,21 +364,21 @@ static int ah_input(struct xfrm_state *x, struct sk_buff *skb)
 
 	work_iph = ah_alloc_tmp(ahash, nfrags + sglists, ihl +
 				ahp->icv_trunc_len + seqhi_len);
 	if (!work_iph) {
 		err = -ENOMEM;
 		goto out;
 	}
 
 	seqhi = (__be32 *)((char *)work_iph + ihl);
 	auth_data = ah_tmp_auth(seqhi, seqhi_len);
-	icv = ah_tmp_icv(ahash, auth_data, ahp->icv_trunc_len);
+	icv = ah_tmp_icv(auth_data, ahp->icv_trunc_len);
 	req = ah_tmp_req(ahash, icv);
 	sg = ah_req_sg(ahash, req);
 	seqhisg = sg + nfrags;
 
 	memcpy(work_iph, iph, ihl);
 	memcpy(auth_data, ah->auth_data, ahp->icv_trunc_len);
 	memset(ah->auth_data, 0, ahp->icv_trunc_len);
 
 	iph->ttl = 0;
 	iph->tos = 0;
-- 
2.42.0

