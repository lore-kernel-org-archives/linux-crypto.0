Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7401D1E25E3
	for <linux-crypto@vger.kernel.org>; Thu, 23 Oct 2025 17:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761241978; cv=none; b=XjGUk/t9RQe/+fANVkkzBbtJMJoJwfNPhgkjN6x4VVFaU6mQsT9MlmQrIpy8xOMAcLXKri78bUVFKcRpUtgxIe/8T3QDIa40bvRuhvQfb3A1NfUR66+8OqiBUtCAF6YqvjHjaBfUW1Yaww4sm7rJG157IM+mW/1ux8EJ5VO5LVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761241978; c=relaxed/simple;
	bh=3/Hb62kc+NYq2C0hsOSogiX9/a2NhcysJRz/S17ajqo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=guKR00HfvN1Lp0cYcakRZ+oyHRWzOiH0UcOtJCKTc6nfmoWgCwUYA3Lcw2xQVcNx12dvjMIujK+vxJ0zLDUF1z2mHPujNIHaWSeQ5mvwrBzoJuO0Qmoybg1L836B3gDKQmKhRQ+y9T7czw6aIwU8n6+1uNqRugh2XQfMxlX+dpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J6jXXkXM; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J6jXXkXM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761241963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vENFCP7b3Pf6ElRkmq5+rmKi7BK0xmEqT+h7PKf7AdY=;
	b=J6jXXkXMi8Ubq7RroFsuYEnRLp8rKwwL6hlNp0XDYItLFMdhPWHPb5Hn5PwIZhfMh/cdwb
	NOPmbD/jd23Pk3v5Sbd7GPkIrW2MeVDMzak4b00jtpZ5ktFeMlxdVKsflh3kZBuFsiDCsw
	/fsTnKEcza+D9bagRrMkNpLuzQUXQrI=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] keys: Annotate struct asymmetric_key_id with __counted_by
Date: Thu, 23 Oct 2025 19:48:11 +0200
Message-ID: <20251023174810.75805-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add the __counted_by() compiler attribute to the flexible array member
'data' to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
CONFIG_FORTIFY_SOURCE.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 include/keys/asymmetric-type.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/keys/asymmetric-type.h b/include/keys/asymmetric-type.h
index 69a13e1e5b2e..1b91c8f98688 100644
--- a/include/keys/asymmetric-type.h
+++ b/include/keys/asymmetric-type.h
@@ -49,7 +49,7 @@ enum asymmetric_payload_bits {
  */
 struct asymmetric_key_id {
 	unsigned short	len;
-	unsigned char	data[];
+	unsigned char	data[] __counted_by(len);
 };
 
 struct asymmetric_key_ids {
-- 
2.51.0

