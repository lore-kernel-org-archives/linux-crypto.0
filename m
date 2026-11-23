Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446665;
	b=Qito3PJJtqiHQJxkHeO97r4F0zlsp0pJ31kL/g3LJGRDwl2vBoQ5VwZUzqsrWIjhGEmB
	 N3YBAWSJd7O5oaa142qHOQWAaAO+SZHRrXmSaTne/eu7IbaPULSI7ro6QyUGoc5cxPt6b
	 T9POu6zHzxD784sFzbC5itfIvjFSOZy44bcyXgdF28rg/UQEVqolKiCAceLixcGdFvr57
	 5XkJPcBNQ9MmmErFZKqV3dJNtFT/p0mRNybc9Pe1ZMF/QYEX85gR/qxpsqA2jAWjRUBeK
	 wulHE6rWRNhHVSzoYZB3bE91TLUbYO7FxaFP8rQ2Z/iPUsIpgSojOWXUcTT1gjNMkoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2rXwqdKcXils5ZX0aUJ4kLahSvMQRVDM5PZVEx1DXik=;
	b=U3ovmN7HmPYhyQ/ncwi1k9KjWQOtVl1UHXeN3SHpHdBz2+WNCDHGSLjIA7fRvrbauftd
	 2YO7A+9Eot8lo6xBa6BGWkHzPMoF9ybaEcAxb1rAX4c/z4YRNk6+jTKQLHIz3DyQBcOKL
	 iG+zkUS28a2cyexzGyA6iLEKRXrINuirSMr2t+zG7ah+4MJ7W+rX3CmWmamH9fhZ+Hijr
	 SvMaxeI0gI5QQL7ogk5iEoYylICyH3LI+STKDn0eBCRqFf620RkXNrIxRdXauNAmEOHsd
	 K0vPnztjICpB85NNgPjr9G2+87f1oQJhgRip4so3BYWhh7xH6f4Fcj//PZ6Bym9g2Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vk93L+Dt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4A8606A31A;
	Mon, 23 Nov 2026 15:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vk93L+Dt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5906A1F000D2;
	Mon, 23 Nov 2026 15:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446665;
	bh=2rXwqdKcXils5ZX0aUJ4kLahSvMQRVDM5PZVEx1DXik=;
	h=From:To:Cc:Subject:Date;
	b=Vk93L+Dt9YLMBXzvXYfSpC+H3lffXA2iZOKJX2mWjUeIaeUHbBaqwNoa5LUcMB6lC
	 JfWNJXpQxz1SBDTRWQGOikzJIMIbAB/RORvCqKOBB5G8dP0T7z/v8TERi9xkaGAtTP
	 i/qTJZHV3ue2mzAkVJz6r0ecPZwLtyJNsWjW0ciNe8zX9EEQBVbnR4zAiGXI35M6Lc
	 XPRdP/r12xXxidCz58UwmLi6cuT0gObPoQw96fM9tMr1jvlk+CL6VV44kNCS4nV8un
	 ZhcPhVMQ5QpqHxKmRiROaRwQswAgRC1oWqN45oCedzrzy2erJ0kxIHoMmWX3AgLV8d
	 mtMQtwbFYf9Mg==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org
Cc: linux-kernel@vger.kernel.org,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Antoine Tenart <atenart@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Bulent Abali <abali@us.ibm.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Dan Streetman <ddstreet@ieee.org>,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Haren Myneni <haren@us.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	Longfang Liu <liulongfang@huawei.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	Meng Yu <yumeng18@huawei.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Nicolas Royer <nicolas@eukrea.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
	Paul Louvel <paul.louvel@bootlin.com>,
	Robert Jennings <rcj@linux.vnet.ibm.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Samuel Holland <samuel@sholland.org>,
	Seth Jennings <sjenning@linux.vnet.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Srujana Challa <schalla@marvell.com>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Steffen Trumtrar <kernel@pengutronix.de>,
	Thorsten Blum <blum@kernel.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Weili Qian <qianweili@huawei.com>,
	Zaibo Xu <xuzaibo@huawei.com>,
	Zhiqi Song <songzhiqi1@huawei.com>
Subject: [PATCH 00/10] crypto: Assorted bug fixes across crypto drivers
Date: Mon, 23 Nov 2026 15:09:51 +0000
Message-ID: <20261123151055.2533735-1-lee@kernel.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
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

These issues were reported by Sashiko.

None of these changes have been tested on physical hardware.

Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Horia Geantă" <horia.geanta@nxp.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Bartosz Golaszewski <brgl@kernel.org>
Cc: Bharat Bhushan <bbhushan2@marvell.com>
Cc: bui duc phuc <phucduc.bui@gmail.com>
Cc: Bulent Abali <abali@us.ibm.com>
Cc: Chen-Yu Tsai <wens@kernel.org>
Cc: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Haren Myneni <haren@us.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
Cc: Kim Phillips <kim.phillips@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-arm-msm@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-sunxi@lists.linux.dev
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Longfang Liu <liulongfang@huawei.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
Cc: Meng Yu <yumeng18@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Nicolas Royer <nicolas@eukrea.com>
Cc: Pankaj Gupta <pankaj.gupta@nxp.com>
Cc: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
Cc: Paul Louvel <paul.louvel@bootlin.com>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Sahil Malhotra <sahil.malhotra@nxp.com>
Cc: Samuel Holland <samuel@sholland.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Srujana Challa <schalla@marvell.com>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Steffen Trumtrar <kernel@pengutronix.de>
Cc: Thorsten Blum <blum@kernel.org>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: Weili Qian <qianweili@huawei.com>
Cc: Zaibo Xu <xuzaibo@huawei.com>
Cc: Zhiqi Song <songzhiqi1@huawei.com>

Lee Jones (10):
  crypto: caam - Fix descriptor buffer overflow in caam_process_blob()
  crypto: marvell - Fix AEAD key buffer overflow for SHA-384/512 HMAC
  crypto: nx - Fix bounce buffer copy overflow in decompress()
  crypto: sun8i-ss - Fix scatterlist array overflow for HMAC requests
  crypto: hisilicon/hpre - Fix buffer overflow on odd ECDH input size
  crypto: talitos - Remove duplicate IV unmap in AEAD encrypt path
  crypto: safexcel - Check scatterlist errors before max() for in-place
  crypto: qce - Pass mapped scatterlist count to qce_dma_prep_sgs()
  crypto: qce - Terminate RX DMA channel if TX preparation fails
  crypto: atmel-tdes - Update output IV before clearing busy flag

 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c  |  7 +++++--
 drivers/crypto/atmel-tdes.c                        |  7 +++++--
 drivers/crypto/caam/blob_gen.c                     | 12 ++++++++----
 drivers/crypto/hisilicon/hpre/hpre_crypto.c        |  5 +++--
 drivers/crypto/inside-secure/safexcel_cipher.c     |  7 +++----
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.h   |  2 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h |  2 +-
 drivers/crypto/nx/nx-842.c                         |  5 ++++-
 drivers/crypto/qce/dma.c                           |  8 ++++++--
 drivers/crypto/qce/sha.c                           |  9 +++++----
 drivers/crypto/talitos.c                           |  4 ----
 11 files changed, 41 insertions(+), 27 deletions(-)

-- 
2.56.1.750.gf70dc682cf-goog

