Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060523;
	b=HexmmCPRHfaYegLA+Doi0mi4ZNRMwIyUU4CqBtFuxuAh5oclTMdtU4XrZ9Kpg9jVykpq
	 dSovUXvgkUh5fE256sTQamGaYJzdQie/jg90mC/vdzYZXRsAaLHFVJY/g/1RlS9iKjGGd
	 NEzcaAHGt1sV2oSpEaoMfaByXQaws8820wEhSQG7JU0qzhIEHmSpPHKucN0INKI/PMWEU
	 YdDa5041eGlF5BfwRR9DcdM8gr/ncyQ05opLrYd7TrigaRhPscFVfNmqFgHJyeY15w45Q
	 jpWb3v5P88mQJwdK4XfCgSJb/VdKi5HR2X1aVowSuYz7xfbxfMWR8ClvWeqSSQrLdEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WEt/YL0S6oFg190mD8vgDrEaHyqe24Y1ZZy6luJKlZ0=;
	b=5WJk1w2BZD96ybFMzlZbHD4uY/w16t1bboC6izMxsNhteE9iF+XqtAfChAEAhMu1O8ga
	 1HRo7Mtq1YIJD7adrnt19DtYToGazoWp2ULJ5POpZ8Z4n1SKUIqyFX6z0Wx1tecMZy6hp
	 b/clcpcXhCQH280/P8swwBYQci2kpRXfxAAeBOygtE+UuItkqjpjm+VqRT0EYuenbn37h
	 yte3siZUP0q/nyehVZiP/PqDl/pbFCViQcHniSf7sPe7MOLEAEwJ1t0D1Vk4w82C9nG1I
	 dUIQtoHH8b0AEZ4v6goHdwUbq9CKRtoYXpYGlBIkBPzAJFkZm6QPp0ZfNLQYv0V5+nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hk4HoXWf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DE0606A320;
	Thu, 19 Nov 2026 03:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hk4HoXWf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67FD1F000C5;
	Thu, 19 Nov 2026 03:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060523;
	bh=WEt/YL0S6oFg190mD8vgDrEaHyqe24Y1ZZy6luJKlZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hk4HoXWfmCXcQIgoMofTfvC4uO+AzKLP7f/rRNS0G1uxFdyYNFmJIXIxkaYWDTgSf
	 JAuI9zuycffw8fpD3dyVblVbjhUF03YwXlei2ZJRnJdwa+MFJiDPkJyJDPWAAl3x+C
	 MUSShllo2eRhmRl1IxOGbMFrbNGiOqq9dSLuMuXw=
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
Subject: [PATCH 5.10 1228/1848] crypto: amlogic - Fix dma_map_sg error check
Date: Wed, 18 Nov 2026 15:54:26 +0100
Message-ID: <20261118150011.316782510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 652e72d030bb0..43f1c6a691bf5 100644
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



