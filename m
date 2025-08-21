Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BBE393DE4
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 20:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755809344; cv=none; b=Pb3cO6y26GLs1wHCHpgqgoUHkWMctoC4ROxYXLz5f7bQXB3NPDSoxnYiOVnizHKnaEFiZiabHYcIYwLY+S3Es+lR0DINq8E+dpUDcD29WUvW40hyqK5VJZmdSpSHCJWR8eTgOQSEQ0ieDiuEWgH5MPbSdo4GmqBxevLzjuUbR6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755809344; c=relaxed/simple;
	bh=P7VmqtsherRidKWSkMgPVHZ0fhC0684onDgMYVMO0ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjyKnYUvPlC84UPp4tfDG26l6QjyOMdmFRQgO9Wyqk6Gs82EiQ36KHtx4XvfIQFNNBAOoFW7plCri8dmHynhhbwDiVpWlquK/AMSOYBmiWsAJg3qH9LLmhnT5nT5/+6RaH+aRzAafpQ9Lkjyrr45CKiaMTm6XR+d8m3uAd1yJ6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gU1j41Fq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gU1j41Fq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755809340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5i20GP63u2qqR/CFD3DZ5ARyopi8xiCc7jkM0fjQKEU=;
	b=gU1j41FqxDmBK4FvH/I88w8rBE3B1yFDJbQX4982z/70QMhxpmgwochd1tyYOAfySzVbTp
	6fnKSMsgMRDqj7Y1r4k4MSgsRS0h0il9N3fSKqoLeI1ceViUJZWLCyWuaYgtjnqbIej3Ci
	pmHhYvNNW7ocR/HYP5xugwD8C4R6grk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-247-y7e1yRIHPc2hefvWdAitQg-1; Thu,
 21 Aug 2025 16:48:57 -0400
X-MC-Unique: y7e1yRIHPc2hefvWdAitQg-1
X-Mimecast-MFC-AGG-ID: y7e1yRIHPc2hefvWdAitQg_1755809335
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83D1819560A2;
	Thu, 21 Aug 2025 20:48:54 +0000 (UTC)
Received: from my-developer-toolbox-latest.redhat.com (unknown [10.2.16.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9F40D1977689;
	Thu, 21 Aug 2025 20:48:51 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: linux-nvme@lists.infradead.org,
	Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 1/2] nvme-auth: add hkdf_expand_label()
Date: Thu, 21 Aug 2025 13:48:15 -0700
Message-ID: <20250821204816.2091293-2-cleech@redhat.com>
In-Reply-To: <20250821204816.2091293-1-cleech@redhat.com>
References: <20250821204816.2091293-1-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Provide an implementation of RFC 8446 (TLS 1.3) HKDF-Expand-Label

Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/nvme/common/auth.c | 53 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 91e273b89fea3..c6eae8e6b6f99 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -683,6 +683,59 @@ int nvme_auth_generate_digest(u8 hmac_id, u8 *psk, size_t psk_len,
 }
 EXPORT_SYMBOL_GPL(nvme_auth_generate_digest);
 
+/**
+ * hkdf_expand_label - HKDF-Expand-Label (RFC 8846 section 7.1)
+ * @hmac_tfm: hash context keyed with pseudorandom key
+ * @label: ASCII label without "tls13 " prefix
+ * @labellen: length of @label
+ * @context: context bytes
+ * @contextlen: length of @context
+ * @okm: output keying material
+ * @okmlen: length of @okm
+ *
+ * Build the TLS 1.3 HkdfLabel structure and invoke hkdf_expand().
+ *
+ * Returns 0 on success with output keying material stored in @okm,
+ * or a negative errno value otherwise.
+ */
+static int hkdf_expand_label(struct crypto_shash *hmac_tfm,
+		const u8 *label, unsigned int labellen,
+		const u8 *context, unsigned int contextlen,
+		u8 *okm, unsigned int okmlen)
+{
+	int err;
+	u8 *info;
+	unsigned int infolen;
+	const char *tls13_prefix = "tls13 ";
+	unsigned int prefixlen = strlen(tls13_prefix);
+
+	if (WARN_ON(labellen > (255 - prefixlen)))
+		return -EINVAL;
+	if (WARN_ON(contextlen > 255))
+		return -EINVAL;
+
+	infolen = 2 + (1 + prefixlen + labellen) + (1 + contextlen);
+	info = kzalloc(infolen, GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	/* HkdfLabel.Length */
+	put_unaligned_be16(okmlen, info);
+
+	/* HkdfLabel.Label */
+	info[2] = prefixlen + labellen;
+	memcpy(info + 3, tls13_prefix, prefixlen);
+	memcpy(info + 3 + prefixlen, label, labellen);
+
+	/* HkdfLabel.Context */
+	info[3 + prefixlen + labellen] = contextlen;
+	memcpy(info + 4 + prefixlen + labellen, context, contextlen);
+
+	err = hkdf_expand(hmac_tfm, info, infolen, okm, okmlen);
+	kfree_sensitive(info);
+	return err;
+}
+
 /**
  * nvme_auth_derive_tls_psk - Derive TLS PSK
  * @hmac_id: Hash function identifier
-- 
2.50.1

