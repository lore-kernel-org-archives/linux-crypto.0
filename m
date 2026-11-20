Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795203479;
	b=SfU0zt+qAead2OmgxRzahXMQq69gXuguCNbuDwfBxvGALPW99SHU8heWLYbDt+QFg8nv
	 DxpObCqUknPxa7kFmj1pycXrvWgn6MYQTA0qcewQGttnRw7VYLgF/qrthJem425UDwn+V
	 /NXIXps/flmFSInjWNiTTQs/g4bJPMaTSLVeZB4EvTmdQ0clsqH0BvmGf7/405g3pM3Ju
	 +LXbZQWigkNHtky7/1IAX1BCBbPAJWpakqV5Rbqouj5tI4cUduoknURxqKeWm7ThI6VJE
	 RbRP+ACZpSNy6RLObxbYuSltYEbwPS5mxFvgQgbw/VB+Mjo+dCF8XMaj0h7AehOjb1g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795203479;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Em0edyn/UFSKerdnnGi3ZguO8FU2mf56wvYpLvq+YBQ=;
	b=1oCbxkLaKZnMN7HjrwQ8Sl30gp9xUOLsrAInx2mrN9ipFPaL9JywAH8zvb4IRyYSXOLn
	 /qTvwdAnfZXns+SEkG4mQRpK2fGsAthwqKKL/mudAMajmyPElEq+HAtWddi3ZijT4ZZJk
	 LusYX9qWVfHJ81CUKBxeHrpt6cTt3wC0bNZgqVj7HQkR6WIuU/heOT2ijvy7klut07AZL
	 mgftQQeJjhHPvptj2ogBGuq+M6FhJRnMv/FeMXK/eY8hklbJhBdCS7VDhl/mj3gYDTSlL
	 KqwW4wj+el1Db7MEZPl4zz/FKu+nSxx1EHZuIYCtVR/Ie8RyRt4Zfb19xSTdr+YoY6Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NaS5t03Y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D96F606A6E2;
	Fri, 20 Nov 2026 19:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NaS5t03Y
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795203478;
	b=AlE4N5zUNzJr3575OCjKDNENBnF4eKcjVF9tp3XfM75sH+M/5f2M4ZfDHSo0Bk1nN1bl
	 7a3ZMMb4LECLZ6tSOZo42ok/6RbHauzlwUR97o8n7x59K1bjep4RG87Pheo7Sszc6XR9q
	 jBxODysOMBRVwp3Y5SzjJNG4xZA0gVxr9fLSYtetywu4qqbTMKe7RbcU8eSiKSlCNl2yw
	 C5z0sOZErMLFKntKD8hdEiugBkZH5QsrP345FcuQNa/UVHERWb6rQqATjRYZMWRKHCwx2
	 C2BIBrmloNrc/jLVGlTJRG9vk5H3eT0IOpdbMTJwr00Nu7O3/KKsAeQdW/O7SdjQvnA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795203478;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Em0edyn/UFSKerdnnGi3ZguO8FU2mf56wvYpLvq+YBQ=;
	b=wpLCs+5f3jA7ATZ7MoVQ4WidA/aeCkEjkyn3wdqFZVOT65nwGyIDBvbg3S0VVdS95vZ0
	 4k+yvbcB82IHoHYMvGSQPid35y6+Xi3S1JCa+QY6OtalLh4AZNTXeKVgP2jxSKTUHNoS8
	 FX14yGYQ528KBT7CnPUl7VyRPQNdRmnGcGROv1dr96/k/GJpUuKpKTIrBN3UIlthOjui9
	 6tpjppvZ8fsY5mR6s8QAasita6ife7aSbefhcOy/S66/ZHFJ123iyEE3oyyc0DuqkZv0q
	 dUHQzqawNS4SMOs9QhmUhKrs6UAglOcWUkIHlh/kW+h7dYn4lHHoFUYY3R15TfVlrwg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 357BF1F000C0;
	Fri, 20 Nov 2026 19:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795203478;
	bh=Em0edyn/UFSKerdnnGi3ZguO8FU2mf56wvYpLvq+YBQ=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=NaS5t03Y1cvYGBSY02fXmQOxtjwF8bmYvkuJhEbxMj0027XKxr1kKFTBAz8OzGHsh
	 K8RSX7le4m9xZJK4gEEv722Z4MJNAQQEw4P8bWiadAjfyBZbdUeIAuigUJaVI0OgoE
	 qe9vpcLz1OOJsz7hd7HkkqWd/ux4NdjDav7xblWUty18DijGbu0Yrgs15DTUzJhJzn
	 A+8nuWdFZZJkA7n5XPo9t2x/DP1+wM4S+eX7RFZ5MWjoWjXFEiYPAmQ3ONCCqv9kZC
	 Tjs+S1FdO30xQb3OJZEBqPg4YjP5C9+r4MTCsGKdX0ry0ixaR7uJujVrN2gkqkvffG
	 eCINg+Ue/CnaA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id AA19A4B9BA;
	Fri, 20 Nov 2026 19:37:52 +0000 (UTC)
From: Gleb Pesin via B4 Relay <devnull+dormancygrace.gmail.com@kernel.org>
Date: Fri, 20 Nov 2026 19:37:18 +0000
Subject: [PATCH] crypto: eip93 - return request validation errors
 synchronously
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-eip93-sync-errors-v1-1-1a83ae607181@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMTQ6CQAxA4auQrmkyHYP8XIW40KFIWQykBaOZc
 HcHXX6L9xIYq7BBVyRQfonJEjOoLCBM9/hklCEbvPNXIu+QZW0vaJ8YkFUXNRyH2rnQtDVVBLl
 blUd5/5797W/bHzOH7RzBcXwBVOfKRXUAAAA=
X-Change-ID: 20261120-eip93-sync-errors-fd700c897151
To: Christian Marangi <ansuelsmth@gmail.com>, 
 Antoine Tenart <atenart@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795203472; l=2301;
 i=dormancygrace@gmail.com; s=eip93-20261120; h=from:subject:message-id;
 bh=+TERzP8CffsbpcQ4hBerOf52PVosyn07V8S4OEMiU+s=;
 b=PZQlB1FHao03xhRgyUZoCNx9qVq7bZcoCSRfK8UXjiMndmeNRgXSkKxLZPA4fO2R5XtMKl+Oi
 Pej7t3wOQrnB1J95q7sjZIt+4R0fumYtk6gHihhEiNW83n+1qkOiHRU
X-Developer-Key: i=dormancygrace@gmail.com; a=ed25519;
 pk=XHpoYk1e6byKypiKa/3bDHJ2i4leWLeZDDjx4gJVsmc=
X-Endpoint-Received: by B4 Relay for dormancygrace@gmail.com/eip93-20261120
 with auth_id=1587
X-Original-From: Gleb Pesin <dormancygrace@gmail.com>
Reply-To: dormancygrace@gmail.com
Content-Transfer-Encoding: 7bit

From: Gleb Pesin <dormancygrace@gmail.com>

The skcipher and AEAD paths validate requests before submitting them
to the hardware. On validation failure they invoke the completion
callback and return the same error. Callers handle that return value
as a synchronous failure and can complete the request a second time.

Return the validation error directly in both paths. Keep completion
callbacks in the hardware result handlers.

Codex (gpt-6.2-sol) assisted with comparing the two paths, preparing the
change and writing the changelog. The corresponding OpenWrt 6.18.64
driver object was cross-compiled on MIPS.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
Closes: https://lore.kernel.org/linux-crypto/aXxmIuU9PKJiDs7n@gondor.apana.org.au/
Signed-off-by: Gleb Pesin <dormancygrace@gmail.com>
---
 drivers/crypto/inside-secure/eip93/eip93-aead.c   | 4 +---
 drivers/crypto/inside-secure/eip93/eip93-cipher.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-aead.c b/drivers/crypto/inside-secure/eip93/eip93-aead.c
index 0b7a899b1..12134b6aa 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-aead.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-aead.c
@@ -47,10 +47,8 @@ static int eip93_aead_send_req(struct crypto_async_request *async)
 	int err;
 
 	err = check_valid_request(rctx);
-	if (err) {
-		aead_request_complete(req, err);
+	if (err)
 		return err;
-	}
 
 	return eip93_send_req(async, req->iv, rctx);
 }
diff --git a/drivers/crypto/inside-secure/eip93/eip93-cipher.c b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
index 4dd7ab750..7b6d510f4 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-cipher.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
@@ -38,10 +38,8 @@ static int eip93_skcipher_send_req(struct crypto_async_request *async)
 
 	err = check_valid_request(rctx);
 
-	if (err) {
-		skcipher_request_complete(req, err);
+	if (err)
 		return err;
-	}
 
 	return eip93_send_req(async, req->iv, rctx);
 }

---
base-commit: 26ca5f34841f0a86d0883664a1c13be89a01d351
change-id: 20261120-eip93-sync-errors-fd700c897151

Best regards,
--  
Gleb Pesin <dormancygrace@gmail.com>


