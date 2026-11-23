Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446711;
	b=UL/M2wmhhuDZZ4XX23fnHEddqzzqxmkEVKT973QZMX2yHii8L29LYFE8sG61qVE2ZDV3
	 RJNsn4KPs4ZTd9UFzFIK/h81ZjbfqXlzPzz1xlZCxQ2UBQM8FmhgVPG54oTIdHa1EWjEG
	 3STULPQaLVBq6a05Is7UgP6QGNlzIkl31MvcgcDU/qJiExLHa9w1j+axwSd76RwWWw20G
	 0jIgM3PNRdTi+NTifobnBljn2vOPjDGIz+W1OKTl+0bKTGFJxWsnAAkAlLCMGo8SGZEl4
	 0Zj7iU7ZS3zsV2nxEx80uzr7uCFrBV+whCnicVBLfO8sup728l02q5ibcTF8NvwzfHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=d/VrQVHzdC2ORMF8gPWt+43yYcp6kMrDuz5euFAcF/k=;
	b=dY99bSmKWTmukJ+FQQsemm6OAUdXwF8k2hLhJcSqBkfkeBetAlUU4YzO9lBZCizURHq7
	 todWdefwQS0iNf3exXsHyQbhhvDqSiHJhpDdmGD13WSsrQIOVLcti+nVKqXjQfsHhCDPM
	 USgAYqJkpjH0MDPPUum46m/hK6omIYUwpV7+9vTCtfUus5UVkw6afbOlEiyHicS+DIgVE
	 b4sBlm/KOKsvu8A8ixfSUMUnqa/60PnwsWKAQVLeqpcUZ+YN7eM+02xPuqeJBwCB1z+cc
	 Wg4Wfoh6vG0mfqTkziRhJ3WwZPXRm1Mb1gqJv2I2T4pTKM0/kMWgpDK/juZ25WFkWFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HL0PyEeJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36459606A68E;
	Mon, 23 Nov 2026 15:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HL0PyEeJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F44B1F00A19;
	Mon, 23 Nov 2026 15:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446710;
	bh=d/VrQVHzdC2ORMF8gPWt+43yYcp6kMrDuz5euFAcF/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HL0PyEeJWgxglixqn5Er03aoiYzscO7y1BanBQxp+azIgIovhb4VB1Pkfwc4qjjoE
	 18FCrbzUJBjeWfQNAugEnhBewVQb3/l4e5gsdEUt8GF3jX7ZpakaAniyRQG0bwpU6m
	 CsNBpsiuFnU1W56hew3Cxo7Hg9Y4SB0OzwrvWg/iHuIHJqjB9oI04UJjNiDoZYIB+s
	 zEX9uU+lzlVc4jnT/+B/9+2eyhkGTCPHo73qFIEyZWLpYIHf4Cn8Z6pkTvY1i1unoP
	 amTbe+GqJFQQBbxWSRtukT0iyR+Lfqt68MTMUXJKsKLKtz+j8DRrFbfd/oq9lVfMOD
	 bSRCejgfzYf2w==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Paul Louvel <paul.louvel@bootlin.com>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Kim Phillips <kim.phillips@freescale.com>,
	Christophe Leroy <chleroy@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 06/10] crypto: talitos - Remove duplicate IV unmap in AEAD encrypt path
Date: Mon, 23 Nov 2026 15:09:57 +0000
Message-ID: <20261123151055.2533735-7-lee@kernel.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <20261123151055.2533735-1-lee@kernel.org>
References: <20261123151055.2533735-1-lee@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 2e13ce0812c6 ("crypto: talitos - DMA map key in setkey()") moved
key DMA mapping into setkey(), but inadvertently added an extra
dma_unmap_single() call on edesc->iv_dma in ipsec_esp_encrypt_done().

Because ipsec_esp() populates civ_ptr with edesc->iv_dma and
ipsec_esp_unmap() already unmaps civ_ptr via
unmap_single_talitos_ptr(), calling dma_unmap_single() on edesc->iv_dma
after ipsec_esp_unmap() unmaps the same IV DMA address twice on every
completed AEAD encryption request.

Remove the duplicate dma_unmap_single() call and the now-unused local
variables from ipsec_esp_encrypt_done().

Fixes: 2e13ce0812c6 ("crypto: talitos - DMA map key in setkey()")
Closes: https://sashiko.dev/#/bug/linux-d3edc145-eaef-4da2-b463-3374b9a54d57
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/crypto/talitos.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 8a9f0d1e7df9..e9af242c7134 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1097,16 +1097,12 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 				   int err)
 {
 	struct aead_request *areq = context;
-	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
-	unsigned int ivsize = crypto_aead_ivsize(authenc);
 	struct talitos_edesc *edesc;
 
 	edesc = container_of(desc, struct talitos_edesc, desc);
 
 	ipsec_esp_unmap(dev, edesc, areq, true);
 
-	dma_unmap_single(dev, edesc->iv_dma, ivsize, DMA_TO_DEVICE);
-
 	kfree(edesc);
 
 	aead_request_complete(areq, err);
-- 
2.56.1.750.gf70dc682cf-goog

