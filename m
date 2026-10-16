Received: from 5.mo560.mail-out.ovh.net (5.mo560.mail-out.ovh.net [87.98.181.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DED45D92B
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 10:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=87.98.181.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792146144; cv=none; b=p/JUo0fEzbDoDnRHnJtTt7HZEmn7uwil1sQASmJOpLQHfemNhnB/CGTSHIemOh9ubVffut/7CmvS0sBA/gBApsKjEG0yp6B9sQikdCixwdTIpQnjBH+nDtNE9uE+KQIA5BAqDZWyXTiJRDlcVZrTdlfzrV8B7pVhwH8gN207ISs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792146144; c=relaxed/simple;
	bh=Q0ET48T5kgmvhDWW6V1583s0V4siUNHdEUiqObL6GsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvLt82LpN9Ug3/2+wk8M3qbQG7cuQE9qKGQ4VSdt+5/cF9szK+midk8rmzdZVK+2BsHkNVfjNS+9RgANLld7VzpKRP7kb+4zBekDoavw9auRl0aG7TL+B3A5ws9Q/OQ6S7SBQE3soDilNO2o8oehMPCR7EhxsF+emlY9C8y/U6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cynove.com; spf=pass smtp.mailfrom=cynove.com; dkim=pass (2048-bit key) header.d=cynove.com header.i=@cynove.com header.b=RViDwafa; arc=none smtp.client-ip=87.98.181.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cynove.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cynove.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cynove.com header.i=@cynove.com header.b="RViDwafa"
Received: from director3.ghost.mail-out.ovh.net (unknown [10.110.58.102])
	by mo560.mail-out.ovh.net (Postfix) with ESMTP id 4j5fBH6rXbzBPsR
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 09:03:51 +0000 (UTC)
Received: from ghost-submission-7ccd8bbbb6-4kjr4 (unknown [10.111.174.188])
	by director3.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 46763C0D11;
	Fri, 16 Oct 2026 09:03:51 +0000 (UTC)
Received: from cynove.com ([37.59.142.97])
	by ghost-submission-7ccd8bbbb6-4kjr4 with ESMTPSA
	id fClPE3Xo0WpZ/AEAmtFogg:T2
	(envelope-from <stephane.debusne@cynove.com>); Fri, 16 Oct 2026 09:03:51 +0000
Authentication-Results:garm.ovh; auth=pass (GARM-97G002356f9ba6-d7b5-4ce0-a9a4-835329139dfb,
                    49BC7871EA8B080B249AF49F55FA702C3B4DE52D) smtp.auth=Stephane.Debusne@cynove.com
X-OVh-ClientIp:176.150.47.247
From: Stephane Debusne <stephane.debusne@cynove.com>
To: herbert@gondor.apana.org.au,
	lukas@wunner.de
Cc: ignat@cloudflare.com,
	davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stephane Debusne <stephane.debusne@cynove.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] crypto: akcipher - use a separate buffer in the sync helpers
Date: Fri, 16 Oct 2026 11:03:32 +0200
Message-ID: <20261016090333.2247764-2-stephane.debusne@cynove.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016090333.2247764-1-stephane.debusne@cynove.com>
References: <20261016090333.2247764-1-stephane.debusne@cynove.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
x-ovh-tracer-id: 16750857340520291099
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: dmFkZTGD4nW62LQB9KssNcZQuK5kWrFQh+w6Vz+V+RAD8MnUAde72M/FLWE8ieu2/logkQIvP3h+HxkwhNQElJPI8dksBAWHsBdG4nOBhE97wdBgSrq7i9Dr7HTzEIPNJ9r0nStZP+4SxoAOI00vFHP+uMc2VAR7sYwcGJsPfO6GsKeTbDbZqUoT/dClNmsHiZliUHARqZfNmZpbXqR+OyK7tCsyhTiGvjmRA5ZoJHO4AiXlGsWEh0ULl2YyjVayzCXrjJyQQpi+DCuYI7TAzwqHsddO0+B9C81cyWecg6aiOCtYZJ4PPYAinicFtLLV81oPd4bQfiHnVg0dZa0FsvCqAOufhcs8fgLROCFM8wS2bhRCkp1PTaUdw1OAZR5OjJEW40K21/6e1PvLxNd+l1HNLXDxKe+zatkuMfQXcBW9U2f2QTycWFFolOnzHitOc3DbiRgFEJXCfEOIoLIOak0i4bEBjIOPByzdHRUIrteEPgPvPJMCkPS7nw0uQtDiWc1oTMet22Wtqcr7zaESKR43lS7CANBUrhtZNfABU7lxSODWeLTWCKJKMWp54vHOl3zuLJu/QCwy/2ijcPNJkInIYeDf9z8klWqXmn1lE/u+9LWSvPZKr3rmgnBJbFGLft91BlKH+x51c2JegYPkBt3+hKwAxONk80Z11jXA8W+9r9uhzA
DKIM-Signature: a=rsa-sha256; bh=1+xUyMr4KllGTv9LUAcboLMXAuFRnwjR1tKUjAHdUr0=;
 c=relaxed/relaxed; d=cynove.com; h=From; s=ovhmo4616632-selector1;
 t=1792141432; v=1;
 b=RViDwafaWZvbkymGTsEFVsp0D/sA2VLkQ5yXMVPU+0ab2DjdkjZ7ArW9HpdowsIlMrKBWuIc
 N4BuszVt6vpR5fkg4kO10RQ03Xlxj8IqxozHFMtPozNgu4ALHB65M1yUeTdG66jjaBWdDdm1PtM
 xg44ltqu2USgQva6QzALqWx79qm9xGrbSKVtIIdHWa9LuI0FQGqLRN3ATsMjdDsJvMj6ZzM8C3l
 uZ0/lDfLjqFSSKDbV8N8bFPt9VgCn642kp7qJwJWvNz5IrcQg0pGuGruyoW5UxCyog7tIpf5yAd
 SMmy7MqZSX+oBoxaolDqW35KtGKlokxnBOwA3xQiGHyNA==

crypto_akcipher_sync_prep() places the data buffer right after the
request context, in the same allocation, and passes it to the driver
in place (src == dst).

On non-coherent DMA, the start of this buffer may share a cache line
with the end of the request context. A DMA-based driver such as the
CAAM (caampkc) writes req_ctx->edesc and req_ctx->akcipher_op_done
after dma_map_sg() of the destination, which dirties that line. On
arm64, dma_unmap_sg(DMA_FROM_DEVICE) cleans and invalidates partial
lines (dc civac), so the stale CPU copy is written back over the result
written by the device.

crypto_akcipher_sync_encrypt() and crypto_akcipher_sync_decrypt() are
used by rsassa_pkcs1_sign() and by software_key_eds_op() (keyctl
pkey_encrypt and pkey_decrypt), so RSA signing and encryption through
rsa-caam are affected.

On i.MX8M Mini (CAAM era 9, rsa-caam, 6.18), the buffer starts at
offset 40 of a 64-byte line shared with the end of the request context,
and crypto_akcipher_sync_encrypt() returns a result whose first 24
bytes still hold the input in 199 of 200 calls.

Allocate the data buffer separately, so that it is DMA-safe like any
kmalloc() buffer.

Fixes: addde1f2c966 ("crypto: akcipher - Add sync interface without SG lists")
Cc: stable@vger.kernel.org
Signed-off-by: Stephane Debusne <stephane.debusne@cynove.com>
---
 crypto/akcipher.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 630bb1973..2381ed43b 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -170,23 +170,29 @@ static int crypto_akcipher_sync_prep(struct crypto_akcipher_sync_data *data)
 	struct akcipher_request *req;
 	struct scatterlist *sg;
 	unsigned int mlen;
-	unsigned int len;
 	u8 *buf;
 
 	mlen = max(data->slen, data->dlen);
 
-	len = sizeof(*req) + reqsize + mlen;
-	if (len < mlen)
-		return -EOVERFLOW;
-
-	req = kzalloc(len, GFP_KERNEL);
+	req = kzalloc(sizeof(*req) + reqsize, GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
 
+	/*
+	 * The data buffer is mapped for DMA by hardware drivers. Keep it in
+	 * its own allocation: placed right after the request context, it
+	 * may share a cache line with fields the driver writes while the
+	 * buffer is mapped, which corrupts the result on non-coherent DMA.
+	 */
+	buf = kzalloc(mlen, GFP_KERNEL);
+	if (!buf) {
+		kfree(req);
+		return -ENOMEM;
+	}
+
 	data->req = req;
 	akcipher_request_set_tfm(req, data->tfm);
 
-	buf = (u8 *)(req + 1) + reqsize;
 	data->buf = buf;
 	memcpy(buf, data->src, data->slen);
 
@@ -207,6 +213,7 @@ static int crypto_akcipher_sync_post(struct crypto_akcipher_sync_data *data,
 	err = crypto_wait_req(err, &data->cwait);
 	memcpy(data->dst, data->buf, data->dlen);
 	data->dlen = data->req->dst_len;
+	kfree_sensitive(data->buf);
 	kfree_sensitive(data->req);
 	return err;
 }
-- 
2.43.0

