Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B713E389114
	for <linux-crypto@vger.kernel.org>; Wed,  5 Aug 2026 14:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785940602; cv=none; b=HPnOZjPcLxj82ypimUFOezRA9NA82emtNmbcg5az6nfLMJThbbBBS3ioFjXIf+EXwvHi3dgsTlAtC53LWjaI6/gmIFipGPOyIp6Bq7UO1CicBxULV8MleqIIgkanGxX3dWDa7eO7gUKPQKvOcORYTUVOU2lLaLsR4FhhYkZHge0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785940602; c=relaxed/simple;
	bh=GWQOgUmGaCnW/7J1hwEvhzsgx1F8Z9pgSpV7rwx1RuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPqkzx/L2qnbX4vPZmUZ8LqdiXdQyDBjoUs2JpElK67Pvec1Zk+FrxFXvG1Lt6gPDQcnDmOpxqqr7rkqqNuw/Glz8K0ukbmX1eZINm/uxGHQfsic7/4qeiriCocSUJBaxxx+PJlv+dwB0mf3hGHr8ORiAdzXgIFkUnyzS2+mmhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cs53YjBs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cs53YjBs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785940595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQdZ/4Ujf8RSEA8hIdmgFuDrtIelJbLig2Mv6B2/+tw=;
	b=cs53YjBs1PWj2UbiETm/SruwCWH+FoUjNi9si8lbouOa4eLnGb7VPpuENLofigZ2IQfu2h
	pQaMEHl4y5Tdf6hJ47aFiF1aV/7xwlIDXjH5LTCP0GneEYA/u3dm/W/4lhEljBy2MeUP7W
	yw435B8a7/IhngOax9Vr7pfwue6zP6c=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-287-JfPA_c8AOhe6fu5NQ65d_Q-1; Wed,
 05 Aug 2026 10:36:33 -0400
X-MC-Unique: JfPA_c8AOhe6fu5NQ65d_Q-1
X-Mimecast-MFC-AGG-ID: JfPA_c8AOhe6fu5NQ65d_Q_1785940592
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 062081800115;
	Wed,  5 Aug 2026 14:36:32 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.48.209])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 467BE180049F;
	Wed,  5 Aug 2026 14:36:29 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH 4/6] Bluetooth: SMP: clear the aes_cmac_key when done
Date: Wed,  5 Aug 2026 16:36:07 +0200
Message-ID: <20260805143611.818559-5-thuth@redhat.com>
In-Reply-To: <20260805143611.818559-1-thuth@redhat.com>
References: <20260805143611.818559-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

From: Thomas Huth <thuth@redhat.com>

Clear the local aes_cmac_key structure via __cleanup() function
when we're done with it to avoid that sensitive data could leak on
the stack.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 net/bluetooth/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 031d3022cb1e5..ed30ca0d773f1 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -164,7 +164,7 @@ static inline void swap_buf(const u8 *src, u8 *dst, size_t len)
 static int smp_aes_cmac(const u8 k[16], const u8 *m, size_t len, u8 mac[16])
 {
 	uint8_t tmp[16], mac_msb[16], msg_msb[CMAC_MSG_MAX];
-	struct aes_cmac_key key;
+	struct aes_cmac_key key __cleanup(aes_cmac_zeroize_key);
 	int err;
 
 	if (len > CMAC_MSG_MAX)
-- 
2.55.0

