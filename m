Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9E32EB10;
	Mon,  3 Aug 2026 19:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785785196; cv=none; b=u9M5QRZzJcYl46fEUQIq0bIsLWivCOJ+8zEQuQIIltazH6pXYv/nbhPT5ms/10Q8XgBhrgK8hyciPggrtiFMTvU/UQJqJnP2sMVfQGYBFbacnltjpJsAuFU7XKX8n3l3zLSe1Dhn0+7htsDYlaIotIO98xcTUitdgtomOUOe4uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785785196; c=relaxed/simple;
	bh=W0kMbjzjWAGND9imMKHUBJHLrFROLriDAaQ6p578I7A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ilTXqSWNMO30e3D5mxGR0437pMwXhWBkNyYrssOixKEpWtai7pFe+uLWTdp1aOJzxD6hW35lUrjrjkcoqIfpNU7LJTnD34b6aYGQliDEHLcbu4MMY8X3Q7OA9cGpH6scLU7GXz9EjA+JrKUL0avHlnYBzU56HEUtQaItoL99hkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jaseg.de; spf=pass smtp.mailfrom=jaseg.de; dkim=pass (2048-bit key) header.d=jaseg.de header.i=@jaseg.de header.b=Cs4IEpuX; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hfxofbS0; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jaseg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaseg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jaseg.de header.i=@jaseg.de header.b="Cs4IEpuX";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hfxofbS0"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 413A81400126;
	Mon,  3 Aug 2026 15:26:33 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 03 Aug 2026 15:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm3; t=1785785193; x=1785871593; bh=t5
	hAQpPB7p4uV6q+AeOeWN5xHerKAB6WAVVZKZQCWsQ=; b=Cs4IEpuXzkCT/gJ7zI
	g3X4S8CvhmrO+7uOB1PtrunOSfThCVatD/qs2EsfcshtpZ4W7HWz378eQh7ECB9R
	RtVkmA9J1yp2JHLizrjBEY7T7VrGT71yRHqu83aJmoyCSnkU5jSvvpJ+0IwNJqil
	q7pgqjxIQuTyKKJiwLZ7MHgHXo6mg/oBjZ1Sd0EAIgQknSoyKv9fnrJHVKH42iXL
	fetZL1au1zYY+SqCQw7R6NEbEQl/RYh5mX9Ld5nB8Q36c4RuIY8hxF/yXzH6nQqG
	7Jmw8gcE1XJqy46njH/Y3Iaag6yjp4KyN8geR+vUW63dKoAQY656K4Yv/7NyynBc
	jMCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1785785193; x=1785871593; bh=t5hAQpPB7p4uV6q+AeOeWN5xHerK
	AB6WAVVZKZQCWsQ=; b=hfxofbS0jwFUPIkxozq006PA5hYgUyuQJbAuxRyWUgoL
	hxLsqlgkKEFxyBQoIMLVO1ProIHT+8oMfphZmcf5yKsty1S7R8JMcyE0JRDzbwlA
	KdcDDnJJSxXpxytLDsHLwZQs5FxE3gHsj9gIssC3spV3Vzgrq+btFc8Qy9m185SK
	r8XF85VuZjB+mT5WUloTFukqpsdHHURYzr6XHC168xHHKWifZIokSd3Wr/GO6V3N
	+DC3wIpOfEQAkFhUqHThK7okTb8Aktui06aKk2ATZOuR1ZvwQGSDyVFzRjhuZnC0
	WHNYzHO/p2Y64pl3mpatloKewQx0+C0gIvUSxP9I7Q==
X-ME-Sender: <xms:aOtwakCfiMTMYJTLxFh58A5exunPmLumwZFbgsgQ1o_7ITwKuAn6Jw>
    <xme:aOtwauofPuf7IKMbJjkFYT_nM6IkpawkqO78yPHfyKMQOZ_gCFSYukIbmr12Vcx3c
    e1iN4l5AFh5nUdURjCDUGCFb_sq6GSBSGu4eS1fT4kPm39jm13pyw>
X-ME-Received: <xmr:aOtwanHgcGdxqacQj08GfdpUozgLu48gRGn2PLx6fhbCavHoCvsL7TDz4i3NYMag>
X-ME-Proxy-Cause: dmFkZTFQqyA3AqtRYGz+SS4hTrroSKjYNUyknrmwM5Rt3nwIEii8+lIbORiXH6uikYKjzy
    cD2iuIYxYwetHGqzcKHAA5e/S1NrszRsjrSup3o6mJl4dXKpZMEWJEoG347EZ/uiP57b8F
    yuAPALbaNp47rtEa2k0Prmwj2rUBf9a0vBs0AO/2QRXtblaUZv5c8RHOYJ1tZK/T9FWZR8
    KYUvvdqWZDPAThL/UtylBKyZkmYODZ6//13Fa4OF764NpVaTHXM1bI+doRCRUPMv5gHhj1
    4pt9pzLnNj661yqfhY9SVQVGoft0wMDWXhMOEkIoyDkM25HdObftX3ykF+BMos3sFAXqVz
    ADU0aXvUu/mz8qNOAGVF6jHFmjO/XvUm7N5luIAkWETGUtw4XHTbJtymZXdnvLVXkMJZIM
    mqDP+zWu4YgNFuCozR71MfHThvHCcNygRjUDcmQTuVOUpw9dytqPoVf2GfU8Aya8CCDDgs
    z6WY/dWmPbyBT5xNQsqSiNuUwfcbjlfYzaTmVkdJJYY7kcBKQKShCdKuJ6qb9lhhmWdIOC
    Ww4RPB2to/RrfYLInkqbQ1BkZr0yvZMgqlXcFmRebGUFbaiqCXy9APDjQqrD2UeOsdGsEs
    RKDsf2cAkdq+pDbz6f/PM1jX1JrhGLP/1WQ6wb++969JWYmwyXfDvSVREcWw
X-ME-Proxy: <xmx:aOtwaquUS608hQqoTIf72oJtPfFQteM5EvnpGBH1ADM3ejGzDnDPMg>
    <xmx:aOtwalYQVIUJtV9QMA2t1G7TjUnagY2vyEfiV77w1FgUxImzTI1j2w>
    <xmx:aOtwai7YLVTBwAqXXz6Rk3YVIJGaasAjh5oNlxkk2VFv9ZidILXPFQ>
    <xmx:aOtwal9qEM-ex897NH_9XeZehQO7cFSjWPAioi8X7cSP6oGPZkTpLg>
    <xmx:aetwaukSj9thpMTEGsh9TcIei9ziRbOwPFfjpnRR-e7ZjbHkCnYVoAms>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Aug 2026 15:26:30 -0400 (EDT)
From: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	David Howells <dhowells@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	=?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>,
	stable@vger.kernel.org
Subject: [PATCH] crypto/krb5: use kfree_sensitive() for derived key buffers
Date: Mon,  3 Aug 2026 21:26:21 +0200
Message-ID: <20260803192621.329577-1-linux@jaseg.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

crypto_krb5_prepare_encryption() and crypto_krb5_prepare_checksum()
free the buffer holding the freshly derived keys with plain kfree(),
leaving the key material behind in the freed slab object.

Fixes: 3936f02bf2d3 ("crypto/krb5: Implement Kerberos crypto core")
Cc: stable@vger.kernel.org
Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 crypto/krb5/krb5_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/krb5/krb5_api.c b/crypto/krb5/krb5_api.c
index 03395b89cc61..b377f4f7558d 100644
--- a/crypto/krb5/krb5_api.c
+++ b/crypto/krb5/krb5_api.c
@@ -263,10 +263,10 @@ struct crypto_aead *crypto_krb5_prepare_encryption(const struct krb5_enctype *kr
 		goto err;
 	}
 
-	kfree(keys.data);
+	kfree_sensitive(keys.data);
 	return ci;
 err:
-	kfree(keys.data);
+	kfree_sensitive(keys.data);
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(crypto_krb5_prepare_encryption);
@@ -333,10 +333,10 @@ struct crypto_shash *crypto_krb5_prepare_checksum(const struct krb5_enctype *krb
 		goto err;
 	}
 
-	kfree(keys.data);
+	kfree_sensitive(keys.data);
 	return ci;
 err:
-	kfree(keys.data);
+	kfree_sensitive(keys.data);
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(crypto_krb5_prepare_checksum);
-- 
2.53.0

