Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BCE1CDB474
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbjJVITI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbjJVISw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9720119
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F0AC43397
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962727;
        bh=zfSB2jxlCfaaPSwCofpCsy6YtucmgVuL9a+n18n5RTE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PBV1rRpG0UIUCqZ2R/Rp5Q25boqNg37IrijTsyUbbDPQIct1wAoZA9Ud6YM7zYcyj
         YGi/7Woe3l5K9paFSi60xuLijLAjHIoF3zoTlZYbJWmfZHcbjGH/MxdcgwXULkTyG2
         umPqFDDu1hK0yKtkp9dLVgVbFwImofCafY0hittihPV5wB7kMlYbtNzPebMi2IQ806
         fMxmNM+I619XUnAtJ21du8kUBw77eP7vqn9AXV1BjvHYHMse28I8YgOoxLnla5ex5n
         tScj1xfur8DV/24+hJqYF8kKnviFu79JIOILGM+VsT7fTDcxTAnDH8UzDTAaIXJtVP
         H7OqKxkHOocqA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 19/30] net: ipv6: stop checking crypto_ahash_alignmask
Date:   Sun, 22 Oct 2023 01:10:49 -0700
Message-ID: <20231022081100.123613-20-ebiggers@kernel.org>
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
preparation for this, stop checking crypto_ahash_alignmask() in ah6.c.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/ipv6/ah6.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 56f9282ec5df4..2016e90e6e1d2 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -44,23 +44,21 @@ struct ah_skb_cb {
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
@@ -68,24 +66,23 @@ static void *ah_alloc_tmp(struct crypto_ahash *ahash, int nfrags,
 static inline struct tmp_ext *ah_tmp_ext(void *base)
 {
 	return base + IPV6HDR_BASELEN;
 }
 
 static inline u8 *ah_tmp_auth(u8 *tmp, unsigned int offset)
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
 
@@ -292,21 +289,21 @@ static void ah6_output_done(void *data, int err)
 	struct ipv6hdr *top_iph = ipv6_hdr(skb);
 	struct ip_auth_hdr *ah = ip_auth_hdr(skb);
 	struct tmp_ext *iph_ext;
 
 	extlen = skb_network_header_len(skb) - sizeof(struct ipv6hdr);
 	if (extlen)
 		extlen += sizeof(*iph_ext);
 
 	iph_base = AH_SKB_CB(skb)->tmp;
 	iph_ext = ah_tmp_ext(iph_base);
-	icv = ah_tmp_icv(ahp->ahash, iph_ext, extlen);
+	icv = ah_tmp_icv(iph_ext, extlen);
 
 	memcpy(ah->auth_data, icv, ahp->icv_trunc_len);
 	memcpy(top_iph, iph_base, IPV6HDR_BASELEN);
 
 	if (extlen) {
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
 		memcpy(&top_iph->saddr, iph_ext, extlen);
 #else
 		memcpy(&top_iph->daddr, iph_ext, extlen);
 #endif
@@ -355,21 +352,21 @@ static int ah6_output(struct xfrm_state *x, struct sk_buff *skb)
 		seqhi_len = sizeof(*seqhi);
 	}
 	err = -ENOMEM;
 	iph_base = ah_alloc_tmp(ahash, nfrags + sglists, IPV6HDR_BASELEN +
 				extlen + seqhi_len);
 	if (!iph_base)
 		goto out;
 
 	iph_ext = ah_tmp_ext(iph_base);
 	seqhi = (__be32 *)((char *)iph_ext + extlen);
-	icv = ah_tmp_icv(ahash, seqhi, seqhi_len);
+	icv = ah_tmp_icv(seqhi, seqhi_len);
 	req = ah_tmp_req(ahash, icv);
 	sg = ah_req_sg(ahash, req);
 	seqhisg = sg + nfrags;
 
 	ah = ip_auth_hdr(skb);
 	memset(ah->auth_data, 0, ahp->icv_trunc_len);
 
 	top_iph = ipv6_hdr(skb);
 	top_iph->payload_len = htons(skb->len - sizeof(*top_iph));
 
@@ -461,21 +458,21 @@ static void ah6_input_done(void *data, int err)
 	struct ah_data *ahp = x->data;
 	struct ip_auth_hdr *ah = ip_auth_hdr(skb);
 	int hdr_len = skb_network_header_len(skb);
 	int ah_hlen = ipv6_authlen(ah);
 
 	if (err)
 		goto out;
 
 	work_iph = AH_SKB_CB(skb)->tmp;
 	auth_data = ah_tmp_auth(work_iph, hdr_len);
-	icv = ah_tmp_icv(ahp->ahash, auth_data, ahp->icv_trunc_len);
+	icv = ah_tmp_icv(auth_data, ahp->icv_trunc_len);
 
 	err = crypto_memneq(icv, auth_data, ahp->icv_trunc_len) ? -EBADMSG : 0;
 	if (err)
 		goto out;
 
 	err = ah->nexthdr;
 
 	skb->network_header += ah_hlen;
 	memcpy(skb_network_header(skb), work_iph, hdr_len);
 	__skb_pull(skb, ah_hlen + hdr_len);
@@ -569,21 +566,21 @@ static int ah6_input(struct xfrm_state *x, struct sk_buff *skb)
 
 	work_iph = ah_alloc_tmp(ahash, nfrags + sglists, hdr_len +
 				ahp->icv_trunc_len + seqhi_len);
 	if (!work_iph) {
 		err = -ENOMEM;
 		goto out;
 	}
 
 	auth_data = ah_tmp_auth((u8 *)work_iph, hdr_len);
 	seqhi = (__be32 *)(auth_data + ahp->icv_trunc_len);
-	icv = ah_tmp_icv(ahash, seqhi, seqhi_len);
+	icv = ah_tmp_icv(seqhi, seqhi_len);
 	req = ah_tmp_req(ahash, icv);
 	sg = ah_req_sg(ahash, req);
 	seqhisg = sg + nfrags;
 
 	memcpy(work_iph, ip6h, hdr_len);
 	memcpy(auth_data, ah->auth_data, ahp->icv_trunc_len);
 	memset(ah->auth_data, 0, ahp->icv_trunc_len);
 
 	err = ipv6_clear_mutable_options(ip6h, hdr_len, XFRM_POLICY_IN);
 	if (err)
-- 
2.42.0

