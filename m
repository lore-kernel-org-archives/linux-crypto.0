Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A243955FE
	for <linux-crypto@vger.kernel.org>; Sat, 23 May 2026 12:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779538550; cv=none; b=j+SDRpNIV3QN6W7mv4lvy08ZgSuPbqAZHkd84H8aiAp7LRMdtk3W02xg8Xdux8fJHyMux4KVk2jYdyF71XSOb5QUfHZ6rHSPkOTTcAzS8m7tqzrypAEe1uvyXJ1y3/fmhbkFod0eAMIToe6C+UKbbuJrCIi74jGNdgu43LlpS4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779538550; c=relaxed/simple;
	bh=8l4tyC4y5/Ak0oYZbkuWnFYCquWoCgn8Deh8zHDa4TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6NqDDyX5dNG2XIfrg9krW7fOVPNH5ewsLeywOgUa0v40Wg4e4uDCBuAb+CSl5KcFoBqcYH+pBVsltAu20Bn9dKmxZSGlS7M9J9sKu15yhl3NFZNN2byNJjD7cM78ZQ1GTOQTSzwoa2VUhyVe8gd5xsC31D/BvVWkiV+htNoJuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NqFuQuuy; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NqFuQuuy"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b9fcf7c91bso92549085ad.0
        for <linux-crypto@vger.kernel.org>; Sat, 23 May 2026 05:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779538544; x=1780143344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ptBan/oDFwIr7VXZlN8TdNfSiKDV9ouul3U9bPm2km8=;
        b=NqFuQuuyrFcUeHomeDO7Hu7KciKYD0AtdvZe5Fq1EApZxDErm6dOjtTJpdQaALo+qn
         INy/62H2MX0W9Vz2YkYQVAmNjYSZBT3JtCEDGnT1UWoKuwzPoNl3LPjDJ0LQQXwpN0z0
         m8CXesgDEjaCGeQIjPoOHNedW/w92IAsMHVfjcoSVdwRPb6te8P16e3FxKqtz/crX8zR
         w2mxQXLCCSmpgwqM8Ub3vUNz0rgYSqzmPj7i+kR79vn6LmNjqIm+RT5MeKW5Uj7oFDeU
         F0MRQSZebF4NqTm2IVL8F7Ii6a9VVE71qneF+H2nq1e+S/JbmuCkWsqZRhy3+TS0RTUq
         Wvdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779538544; x=1780143344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ptBan/oDFwIr7VXZlN8TdNfSiKDV9ouul3U9bPm2km8=;
        b=ZR2wDsOpFtQDpUb8ox+R2zc6Hg8/R9YR/C5sAoAfA5Fy/EeLTvIVwZ5dLyFuWmd4Y0
         h6FSockYGrAQUG6lCZdo+Ih3zrvD7vDF6+Qkf3M5OjvTKOsDGHpH9S7MVJHTkgYAwXr5
         /pqtu/6mP9yJwSluCymYRO/ByY0oQfFetmCDTN25NGAqxPDJH1tjjfq++Q4O9LozjZlG
         +Cl5HE5O1eg+ftWAyBaX1dChf170iT0tB3oyCJ51QXAuKW0B8IegYjizXNTlusuyBRpK
         xRyHa4/IRmauYB04g4XuaYVCmQGZH8XRBpKQ3zXkw1usXz6JmdG6Hmzl09bdyWAG7Y96
         DOwg==
X-Forwarded-Encrypted: i=1; AFNElJ+GRLhK109NymDWXPYVdiRG8gTpqb3b+mNQvDFNqTrCIo0vXlu2D+qS0TrcX60v3Sl7Wi/Wif+sA++PBXc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHjRXFvyJWEUP4wqW4d7HVgLv/CxVEvA7QyIQsRzAYJ+1KvkeJ
	Am/t14P5ntw+26BITyJUhBWhTqVWLUc0MOVL5gzMsbjNVPQFLHCQs4jH
X-Gm-Gg: Acq92OEpmm9fnU20WBPW78Yj4IOV1PUv3QbF6sgT1o0q2fJFia117loZpyZQacyuUyJ
	ItDwtFD9+uFZov66W+JBLC8qEIc9OTyQDuorHcjBdYSuiRQZP90g8PSldm/PzC5sUC9EuJl15eN
	mLmmDT+H+yXybBna8N0au5IsWJe9x5qDmAaVg10IjcGWP8PAci7NdAhbBdgJX36VQAKD4NP0zF8
	SZeIRuULVbKBnb7qdIKZTPimQwILbnQhqggV3Of95RjnUNR8RwfQTgvZ6RIyTpowym8G4kDg9Ei
	mzUwrki5smKYW/zSiku5hhgdOOSCvIin/w5+M2iLaa6hOQPmRgtCUDTT0AVFVVKgBqRb1vS11xZ
	S7Qqy1NWZkXl/VOyHD/F26IhkbbKBUXmBapF1a/f9XGGFntzSSDuig/gnEcGYDCbczsOvEw9J14
	ynBoT6Npt3KKfgR6QTQtQp9q+VU3IM+G1WF+k=
X-Received: by 2002:a17:903:3d10:b0:2bc:6784:5260 with SMTP id d9443c01a7336-2beb06eb0e4mr90794065ad.37.1779538543856;
        Sat, 23 May 2026 05:15:43 -0700 (PDT)
Received: from mincom1 ([125.149.177.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56ce4easm41746305ad.30.2026.05.23.05.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 05:15:43 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	netdev@vger.kernel.org,
	Jihong Min <hurryman2212@gmail.com>
Subject: [PATCH 1/3] xfrm: extend ESP offload infrastructure for packet engines
Date: Sat, 23 May 2026 21:15:20 +0900
Message-ID: <20260523121522.3023992-2-hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260523121522.3023992-1-hurryman2212@gmail.com>
References: <20260523121522.3023992-1-hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some ESP offload engines operate on whole ESP packets rather than the
generic software trailer layout. They can generate outbound ESP padding,
next-header and ICV bytes in hardware, and inbound decapsulation can
return an already-trimmed packet with the recovered next-header value.

Add a netdev offload callback for drivers to opt into hardware-generated
ESP TX trailers, carry the reserved ESP TX tail length in xfrm_offload,
and let ESP input skip software trailer removal when hardware has already
done it.

This keeps the default ESP offload behavior unchanged for existing devices
while providing the infrastructure needed by packet-mode ESP engines.

Assisted-by: Codex:gpt-5.5
Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 include/linux/netdevice.h |  3 +++
 include/net/xfrm.h        |  8 +++++++-
 net/ipv4/esp4.c           |  6 +++++-
 net/ipv4/esp4_offload.c   | 29 ++++++++++++++++++++++++++++-
 net/ipv6/esp6.c           |  6 +++++-
 net/ipv6/esp6_offload.c   | 29 ++++++++++++++++++++++++++++-
 6 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0e1e581efc5a..b6ff04c3df78 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1043,6 +1043,9 @@ struct xfrmdev_ops {
 				      struct xfrm_state *x);
 	bool	(*xdo_dev_offload_ok) (struct sk_buff *skb,
 				       struct xfrm_state *x);
+	/* Return true when the device generates the ESP trailer/ICV itself. */
+	bool	(*xdo_dev_esp_tx_hw_trailer)(struct sk_buff *skb,
+					     struct xfrm_state *x);
 	void	(*xdo_dev_state_advance_esn) (struct xfrm_state *x);
 	void	(*xdo_dev_state_update_stats) (struct xfrm_state *x);
 	int	(*xdo_dev_policy_add) (struct xfrm_policy *x, struct netlink_ext_ack *extack);
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 10d3edde6b2f..160069901e0a 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1141,7 +1141,7 @@ struct xfrm_offload {
 #define	CRYPTO_FALLBACK		8
 #define	XFRM_GSO_SEGMENT	16
 #define	XFRM_GRO		32
-/* 64 is free */
+#define	XFRM_ESP_NO_TRAILER	64
 #define	XFRM_DEV_RESUME		128
 #define	XFRM_XMIT		256
 
@@ -1158,6 +1158,12 @@ struct xfrm_offload {
 	/* Used to keep whole l2 header for transport mode GRO */
 	__u16			orig_mac_len;
 
+	/*
+	 * ESP packet engines can reserve tailroom in the generic ESP path and
+	 * generate padding, next-header and ICV bytes during device TX.
+	 */
+	__u16			esp_tx_tailen;
+
 	__u8			proto;
 	__u8			inner_ipproto;
 };
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 6a5febbdbee4..f21c8f2e60f7 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -720,7 +720,11 @@ int esp_input_done2(struct sk_buff *skb, int err)
 	if (unlikely(err))
 		goto out;
 
-	err = esp_remove_trailer(skb);
+	/* Hardware ESP decapsulation can already remove pad/trailer/ICV. */
+	if (xo && (xo->flags & XFRM_ESP_NO_TRAILER))
+		err = xo->proto;
+	else
+		err = esp_remove_trailer(skb);
 	if (unlikely(err < 0))
 		goto out;
 
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index abd77162f5e7..f00fff98b69f 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -270,8 +270,10 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 	struct xfrm_offload *xo;
 	struct ip_esp_hdr *esph;
 	struct crypto_aead *aead;
+	struct sk_buff *trailer;
 	struct esp_info esp;
 	bool hw_offload = true;
+	bool hw_trailer = false;
 	__u32 seq;
 	int encap_type = 0;
 
@@ -281,6 +283,7 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 
 	if (!xo)
 		return -EINVAL;
+	xo->esp_tx_tailen = 0;
 
 	if ((!(features & NETIF_F_HW_ESP) &&
 	     !(skb->dev->gso_partial_features & NETIF_F_HW_ESP)) ||
@@ -303,13 +306,37 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 	esp.clen = ALIGN(skb->len + 2 + esp.tfclen, blksize);
 	esp.plen = esp.clen - skb->len - esp.tfclen;
 	esp.tailen = esp.tfclen + esp.plen + alen;
+	if (esp.tailen > U16_MAX)
+		return -EINVAL;
 
 	esp.esph = ip_esp_hdr(skb);
 
 	if (x->encap)
 		encap_type = x->encap->encap_type;
 
-	if (!hw_offload || !skb_is_gso(skb) || (hw_offload && encap_type == UDP_ENCAP_ESPINUDP)) {
+	if (hw_offload && !skb_is_gso(skb) && !encap_type && x->xso.dev &&
+	    x->xso.dev->xfrmdev_ops &&
+	    x->xso.dev->xfrmdev_ops->xdo_dev_esp_tx_hw_trailer)
+		hw_trailer =
+			x->xso.dev->xfrmdev_ops->xdo_dev_esp_tx_hw_trailer(skb, x);
+
+	if (hw_trailer) {
+		int esph_offset;
+
+		/*
+		 * The device packet engine will write ESP padding, next-header
+		 * and ICV bytes. Keep skb->len unchanged here, but make sure the
+		 * later DMA writer owns enough linear tailroom.
+		 */
+		esph_offset = (unsigned char *)esp.esph - skb_transport_header(skb);
+		esp.nfrags = skb_cow_data(skb, esp.tailen, &trailer);
+		if (esp.nfrags < 0)
+			return esp.nfrags;
+		esp.esph = (struct ip_esp_hdr *)(skb_transport_header(skb) +
+						 esph_offset);
+		xo->esp_tx_tailen = esp.tailen;
+	} else if (!hw_offload || !skb_is_gso(skb) ||
+		   (hw_offload && encap_type == UDP_ENCAP_ESPINUDP)) {
 		esp.nfrags = esp_output_head(x, skb, &esp);
 		if (esp.nfrags < 0)
 			return esp.nfrags;
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 9c06c5a1419d..730588f8eaba 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -751,7 +751,11 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 	if (unlikely(err))
 		goto out;
 
-	err = esp_remove_trailer(skb);
+	/* Hardware ESP decapsulation can already remove pad/trailer/ICV. */
+	if (xo && (xo->flags & XFRM_ESP_NO_TRAILER))
+		err = xo->proto;
+	else
+		err = esp_remove_trailer(skb);
 	if (unlikely(err < 0))
 		goto out;
 
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 22895521a57d..d124493da40b 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -308,8 +308,10 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 	int blksize;
 	struct xfrm_offload *xo;
 	struct crypto_aead *aead;
+	struct sk_buff *trailer;
 	struct esp_info esp;
 	bool hw_offload = true;
+	bool hw_trailer = false;
 	__u32 seq;
 
 	esp.inplace = true;
@@ -318,6 +320,7 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 
 	if (!xo)
 		return -EINVAL;
+	xo->esp_tx_tailen = 0;
 
 	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev) {
 		xo->flags |= CRYPTO_FALLBACK;
@@ -338,8 +341,32 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 	esp.clen = ALIGN(skb->len + 2 + esp.tfclen, blksize);
 	esp.plen = esp.clen - skb->len - esp.tfclen;
 	esp.tailen = esp.tfclen + esp.plen + alen;
+	if (esp.tailen > U16_MAX)
+		return -EINVAL;
 
-	if (!hw_offload || !skb_is_gso(skb)) {
+	if (hw_offload && !skb_is_gso(skb) && !x->encap && x->xso.dev &&
+	    x->xso.dev->xfrmdev_ops &&
+	    x->xso.dev->xfrmdev_ops->xdo_dev_esp_tx_hw_trailer)
+		hw_trailer =
+			x->xso.dev->xfrmdev_ops->xdo_dev_esp_tx_hw_trailer(skb, x);
+
+	if (hw_trailer) {
+		int esph_offset;
+
+		/*
+		 * The device packet engine will write ESP padding, next-header
+		 * and ICV bytes. Keep skb->len unchanged here, but make sure the
+		 * later DMA writer owns enough linear tailroom.
+		 */
+		esp.esph = ip_esp_hdr(skb);
+		esph_offset = (unsigned char *)esp.esph - skb_transport_header(skb);
+		esp.nfrags = skb_cow_data(skb, esp.tailen, &trailer);
+		if (esp.nfrags < 0)
+			return esp.nfrags;
+		esp.esph = (struct ip_esp_hdr *)(skb_transport_header(skb) +
+						 esph_offset);
+		xo->esp_tx_tailen = esp.tailen;
+	} else if (!hw_offload || !skb_is_gso(skb)) {
 		esp.nfrags = esp6_output_head(x, skb, &esp);
 		if (esp.nfrags < 0)
 			return esp.nfrags;
-- 
2.53.0

