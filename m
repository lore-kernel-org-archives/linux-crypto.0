Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795799011;
	b=fhhOxpHrDCgbfibV/HwH8Fq8IvUdVKQN/FlgWNiTo2Vyugxo9Mr9X5qeiQBpcdctysOm
	 vjXsqWe+14Pd+WR4luTvlV0a8OUvAljaSfY6ausTXOLWd4qEHAc3Qpcddz97YylcAurUu
	 M9di6MKkjWpD6y7Syf6+XoOKnHlw/AmnfaF5jpiXqDufmdA7x9C0qbomHtpndZPXUOiBk
	 tWpT6Z9wxgc091YOzGziTxFZsjjzCDP91jN9k3GMZuMO7bAlWJrPhUsewTS99uERMMD5p
	 UUFVrTYcA7QKNJvl4n3jz9DLtaD6Sox1BM85VEsqzH3Xa926ij1iKH1MTE9fGmrCeLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795799011;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=n/rsmG3FiGD5JF7kMgaJyBlIxTvJ/3kpRDtF2VUvB18=;
	b=G9rUEi5WS1K77F2DgHD7TiRjoj+5amCfLP+tju3qo3MQOJ++cIc1wLCGdWk9mX3mp4F3
	 VS7NmlfFNGMXVTcgQm9QlhMf+eroaaReb8WIm8G5IrRWqkbw/z+2V9o7kimgxTEi6hwze
	 CEimMpYqTLyD5ufZnn0NrrVKrtns9XnQqNGvPSp0b9pmkEHWLbWiZEVAyJszWA39Zptfk
	 3aZUcectacARKy4hbhZ6n87Xg9FFM7YqvjCTsGh75cRPqjBdihjB7pXdjBOBIIRyZl0SG
	 enJIO3X43Z+nl5i5BDSWciJn/WhdDTu5MnetF/mmaq4dViIM7vV8erlEPK7JvNRVcXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ztnZMdZO;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BB4606A31E
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 17:03:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73BB4606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ztnZMdZO
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4bb995ade6cso6265425e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 09:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795799010; x=1796403810; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n/rsmG3FiGD5JF7kMgaJyBlIxTvJ/3kpRDtF2VUvB18=;
        b=ztnZMdZOX2jBt+ZK4PnUsmvjkbVGItNMycAKUDMByLEp5jSlSiLLjgcFFSUHF186at
         fw9mYPdfwDoh4XYlxvWX5jkysSxzMUF27VEFeRga+/FMPYGW7TmH9+tAPVxp5FhJSLxC
         IfT4FNIoKiOce25DsDklYDASSChvmvFv2RwCbVDJ1gDIAidadZaX+EQkwdQ6AqGU8X4P
         aoUoBMTc9JwJpi8ci05YHu3wQvMSfjd2TGC3yZMqHljZ9ooxHXIRRcHumdtZRB0pkyk+
         vRZtOE6pghMkTsJ4AYqgFrr0U9FJ7/cNZWNfLGnC1wd9SHxxvWGmx+SslBOuOFJNZD0/
         Q1/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795799010; x=1796403810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n/rsmG3FiGD5JF7kMgaJyBlIxTvJ/3kpRDtF2VUvB18=;
        b=Yz/nhmsjpaFnmpxr3Xy97B8ozxn4iXeQfGnInasUYHgirTNnOi4/2Sc7GaVO8IxsLf
         natyVCc91EEovIUOb9xWTHVhVIPKAcEwsAguuO9Zc8qvEJHgRUHtRPgVbyaikia4f1Xm
         i9MxWBA0wd0D+tg1N9OlfnZ5vy4cwMIJc9o8d5dGOmI9ofZFGAOUYSuzRtu2FzeSlLAb
         I44A8BBdEN2jOXpZsbZL80kyZf8WqQRXOqo2YRnCrYlox4vfK5uA6kJlvAGWdWVAgeRp
         6iVje9YBrUgEMkVilUZenUtrbX/en50Vj0Du0xacr+gvdpFoU7zCqERNoq7NszSowegL
         vePg==
X-Forwarded-Encrypted: i=1; AL+hErGcXuwaFytySGV2JghAhaGwq65FCcIGExzd5QtSu80Jd6mYXm1oX+L5me9vNdEagoBP4Y1h6MsMlUSyvjQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z8DBfTR8or/hFBGl5IWPzZenC732D3y8VuxIsnO+4h4ffdobFmC
	axwllMPTcEQlJqMtwEHPv7ijLq+KMH7HvTQ1OOy8XcdCOd6irvfus1uDUfU4uWdf
X-Gm-Gg: AZFdTZfBfPxT+dk9JSZK+D0TyA3yGRS0p2bibCRCccSHf9E7jeace/vlqnIDUv2ZbUw
	U9ej2AdT9fkuIQuApVq5SD+48jOgPxo4cPHznt+N0lilnJyvaQ012O+2jEyBHLQXrbYS3Fu4uhW
	6vZjzK4UbuVAXZw3WH8a0r/AycLMYqrAM/+PqG8XDM+8XBUZiTHJ6avB3W3CswZCRjIBkJJdWOg
	tBrvGPbtQxDz43Yk9Gwint/lsAPmAwhjvyHA5p3976uPC2+ehfQocWrpzHViCvtcNc2jjRaL+hc
	rPj1O672f9xmfm1NDejNVFJPNBFvtiHSa5W8yb9mVvLAf1M0LLoD+WljH26PA1v8iuU8NFjWkdy
	GcDuDtbuow/rgtob6nj7SyKi4VN7K3CRloNdbc9XF04y3T/OcJzgk0B5ZwrfV+yVADqA0rVR7JC
	9KkgdGrrnmiU2Q0srT5QnZoFv2NoHgKzveTEGl10Zakzjc6Y7hrlTq4cbE7SUFtEK+sDupqrCtI
	02sR93gS8S+3rg/qgd9hX8BjQHg/VlQcinyV+Dc83Yzb67dhpKhzcdpvdY3vE7tOVI6Iro5mbeF
	1LSqciG/RE6oo+PXLra9AJUgEZ5CryIeaOBPkgr/QjR3IcvERLkV+IbfOOTkIcK418N3YQRxYos
	mllJCL30cpChuUabVSxMW
X-Received: by 2002:a05:600c:2909:b0:4bb:b39d:d447 with SMTP id 5b1f17b1804b1-4bbb39dd4famr49921115e9.1.1795799008808;
        Fri, 27 Nov 2026 09:03:28 -0800 (PST)
Received: from thomas-precision3591.paris.inria.fr (wifi-pro-83-006.paris.inria.fr. [128.93.83.6])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4bb8533579csm607680575e9.2.2026.11.27.09.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 09:03:28 -0800 (PST)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Wei Yongjun <weiyongjun1@huawei.com>,
	linux-crypto@vger.kernel.org (open list:QUALCOMM CRYPTO DRIVERS),
	linux-arm-msm@vger.kernel.org (open list:QUALCOMM CRYPTO DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: qce - aead: unmap the scatterlist that was mapped
Date: Fri, 27 Nov 2026 18:01:59 +0100
Message-ID: <20261127170201.62667-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

qce_aead_async_req_handle() maps rctx->src_sg, which for CCM with
src != dst is a table built by the driver and not req->src, but its
error path unmaps req->src. The mapping result is also checked with
"< 0" although dma_map_sg() returns 0 on failure.

Unmap rctx->src_sg like qce_aead_done() does and treat a zero return of
dma_map_sg() as an error.

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Fixes: 5c0ecc2e81ec ("crypto: qce - Fix some error handling path")
---
 drivers/crypto/qce/aead.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index e0061bfab216..54cc6bb8fd4b 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -450,8 +450,8 @@ qce_aead_async_req_handle(struct crypto_async_request *async_req)
 
 	if (diff_dst) {
 		src_nents = dma_map_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
-		if (src_nents < 0) {
-			ret = src_nents;
+		if (!src_nents) {
+			ret = -EIO;
 			goto error_unmap_dst;
 		}
 	} else {
@@ -478,7 +478,7 @@ qce_aead_async_req_handle(struct crypto_async_request *async_req)
 	qce_dma_terminate_all(&qce->dma);
 error_unmap_src:
 	if (diff_dst)
-		dma_unmap_sg(qce->dev, req->src, rctx->src_nents, dir_src);
+		dma_unmap_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
 error_unmap_dst:
 	dma_unmap_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
 error_free:
-- 
2.53.0

