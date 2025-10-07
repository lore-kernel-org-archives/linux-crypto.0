Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9CF2E92D0
	for <linux-crypto@vger.kernel.org>; Tue,  7 Oct 2025 18:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759863179; cv=none; b=DHBjyuqF9c2BgdjQX9r5P17CDW2VXf1kvFwaylIIhw1Z7uS8fAoWeG0fprx2RekvQ+35wP4Lne+k4w7xRPdqtgm+P2aHLuWpoSStyyJHeDTcEU8cV90kWb7GP8N/X5pHbXBqWOq2v5luklAgLaT0AdpDB24HLMTtmrHQN1yMpes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759863179; c=relaxed/simple;
	bh=4m44Ymet5W/5/uIvPoZ02pG/bxDo49W6g7xko/lB0ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/pIMR8zmOtDC2klkE4nht3XrOV25fQero1zOKwfIR8gnhy410m3lvulfM176qmn1VQU/ofIw9MtXCnPmWQQ/Hxj4ctJwC4YGTkEj2+0w7onTnjXYrYq/j/yj6UdlrqIu+8YxV1jiDev4Wtmvdzt3MsP6ODeT+9Zs393Wb63kbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c/qh2+xB; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c/qh2+xB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759863174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZtvehMqki1j4i5SsYl1BCYkhBIs55uGz0PHlwImo8Q8=;
	b=c/qh2+xBTtl8IoDIk0w0aI+8c2xsh2E0v+wvBTDpOp4D64cYgx30VjaN7TN6veXH+qNYno
	BlPURXDUGeeaZ1FR/Xr0KveaqhGgBQi4iYtl0NbstkD5Vu2cltee6YeE1TlvAZWq2VA7yF
	6YH68CK+VEwsl9j8ZHwRxUwqPFoTbbc=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: asymmetric_keys - simplify asymmetric_key_hex_to_key_id
Date: Tue,  7 Oct 2025 20:52:21 +0200
Message-ID: <20251007185220.234611-3-thorsten.blum@linux.dev>
In-Reply-To: <20251007185220.234611-2-thorsten.blum@linux.dev>
References: <20251007185220.234611-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use struct_size() to calculate the number of bytes to allocate for the
asymmetric key id.  Add a local variable to store the hex data length
instead of recalculating it.

The variable 'ret', whose name implies a return variable, is only used
to temporarily store the result of __asymmetric_key_hex_to_key_id(). Use
the result directly and remove the local variable.

No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/asymmetric_keys/asymmetric_type.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index aea925c88973..b73b8b983bfa 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -228,7 +228,7 @@ struct asymmetric_key_id *asymmetric_key_hex_to_key_id(const char *id)
 {
 	struct asymmetric_key_id *match_id;
 	size_t asciihexlen;
-	int ret;
+	size_t hexlen;
 
 	if (!*id)
 		return ERR_PTR(-EINVAL);
@@ -236,12 +236,11 @@ struct asymmetric_key_id *asymmetric_key_hex_to_key_id(const char *id)
 	if (asciihexlen & 1)
 		return ERR_PTR(-EINVAL);
 
-	match_id = kmalloc(sizeof(struct asymmetric_key_id) + asciihexlen / 2,
-			   GFP_KERNEL);
+	hexlen = asciihexlen / 2;
+	match_id = kmalloc(struct_size(match_id, data, hexlen), GFP_KERNEL);
 	if (!match_id)
 		return ERR_PTR(-ENOMEM);
-	ret = __asymmetric_key_hex_to_key_id(id, match_id, asciihexlen / 2);
-	if (ret < 0) {
+	if (__asymmetric_key_hex_to_key_id(id, match_id, hexlen) < 0) {
 		kfree(match_id);
 		return ERR_PTR(-EINVAL);
 	}
-- 
2.51.0

