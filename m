Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054993;
	b=FZL9FVKcqM2qwEWLaasZyjLsVEDaQZZ7uCWL2hCFkvKVqmcRB80A/EF0di/bfqmZJ1YF
	 SX7NRuok0rlyDab1nTe3wsX2v3Z/IeM2F24N/0DOeHSqFofc0bktpwbiUueImPImiaclf
	 L0PUtw4uuARL68DkvN8I/6La1R+GyPv4xUbyU67sZ2AbdvPbuP0GJpi6g6igtjzni+FVq
	 HleQeuPhVjJ4Io63QOeOF1gb2VluLbs2kxnudVr8s/wvPLksvRyjK0fdRmLd+bINieDiG
	 qIN5sDbkZhkAQ2UARXdhL2y5te5n2+jkPIm/iJsBGi0A4nqznPcN181P6qLwzL136Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=muBtTw03L5Q+ktViRHTg43LW47QauHPdA3EAg4zKHgQ=;
	b=sZJPcTTd5eAC4CMCseAXEhG8LyjSWaEgGy3q+M29GfA60G5NBl7eF6eGYGjPM6WZALSu
	 oXwSSUl9YrphzURKounsaC3p7RmkGPkDZjOfmZU9ciWMKio4uv7qI7Zn++D7+NYqgstxG
	 4gpgtmfoESwc0tnXiUFI8cK4tnJYkG0WybLmRoGS+IWg88Kygy5EIWcokYAnYUL5oFQRF
	 o46c/Vl3XhPJgIpZTxlCB8QLxLc95BCTu+jVwRJBK0RBfgaNFSRe475ugFd/F5+/2kaSL
	 0DhSgBU2u64ciaFBVxcNXQwhcsHdW5qVluvXCvAMrZBoGDzMxEcPG7It3r3UA+b0Wqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SNG9njAR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E589F606A31C;
	Thu, 19 Nov 2026 02:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SNG9njAR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BF51F000C7;
	Thu, 19 Nov 2026 02:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054992;
	bh=muBtTw03L5Q+ktViRHTg43LW47QauHPdA3EAg4zKHgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SNG9njARziaXtEHSElrg/Wp6NNx7U0+Cxmy4BtndUZ8ljw0EkiYfFObiUaCh9BrOv
	 jNinBl/8NdGv+xyMypU9KLL7vWeFrXWG0moumvazG6swe8sD/tYsLJMKQUmMaEXvyt
	 8NpqL5IcDixIujGsVDYp/uCF16B+8OgupSSRpKe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@ionos.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1473/2214] crypto: amlogic - Fix dma_map_sg error check
Date: Wed, 18 Nov 2026 15:52:29 +0100
Message-ID: <20261118150110.101789092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 45fa321e7de604146603e24ee5bf3c0b766efe46 ]

dma_map_sg return 0 on error.

Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-amlogic@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 6c2373dd818b ("crypto: amlogic - Fix DMA memory leak in cipher error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index e79514fce731f..af017a087ebf0 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -177,7 +177,7 @@ static int meson_cipher(struct skcipher_request *areq)
 	if (areq->src == areq->dst) {
 		nr_sgs = dma_map_sg(mc->dev, areq->src, sg_nents(areq->src),
 				    DMA_BIDIRECTIONAL);
-		if (nr_sgs < 0) {
+		if (!nr_sgs) {
 			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgs);
 			err = -EINVAL;
 			goto theend;
@@ -186,14 +186,14 @@ static int meson_cipher(struct skcipher_request *areq)
 	} else {
 		nr_sgs = dma_map_sg(mc->dev, areq->src, sg_nents(areq->src),
 				    DMA_TO_DEVICE);
-		if (nr_sgs < 0 || nr_sgs > MAXDESC - 3) {
+		if (!nr_sgs || nr_sgs > MAXDESC - 3) {
 			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgs);
 			err = -EINVAL;
 			goto theend;
 		}
 		nr_sgd = dma_map_sg(mc->dev, areq->dst, sg_nents(areq->dst),
 				    DMA_FROM_DEVICE);
-		if (nr_sgd < 0 || nr_sgd > MAXDESC - 3) {
+		if (!nr_sgd || nr_sgd > MAXDESC - 3) {
 			dev_err(mc->dev, "Invalid SG count %d\n", nr_sgd);
 			err = -EINVAL;
 			goto theend;
-- 
2.53.0



