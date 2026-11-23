Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446738;
	b=5LqQZlLl1omy/J3l2hMt5i+AzPUH69pBaXkvIt00w4sFJgkfcMlsQ/fzpO2HN5yrBwOK
	 G2KYrGkJvBrRqJQiX+YRsMrJppTx7I3sezf1MR48DcIhlCf/dy/DaJisKKxynpIqottJY
	 jHq1CbA4V6jDoUSZnV88nMal0eZRcli5SEOX9BOhMBPJawviccF61RuzPBE0q11vYnC3R
	 sJi5g7jG6yRq5xmY9t86yabKXD+Jpeo5b8uSyRq7QxiQDfapKcBNVRGCdPXGZ657ome/o
	 MTYDHvdXmjbgZJddn+OPd6CZWRl5mdODJi/VGLpkF3ysPcfhByFohjJ4XyUQdlpKnAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Y3crQHbdpOlgtQVKmilOb/+IWL0/tt7WDZKDspXm67A=;
	b=0vnMTicYNh/28o6QS44HbFJa9IYbHDD83rTQe1KU5rbk1fCgUCBzApjPHBhTOhFK+8Az
	 sEdyEwG5zDrvC3KMGkO9g+EAA90cCeeOOjhmzOwXqe6oi2O1ruXPmiDH2StwUTK8IuEwm
	 0M2obxKt4mSKBOQXTQtsWLzxOQ/oQfc6mnQLNnYQfVy1R60O87dZwwXdM0pKJ8h1Z/jjE
	 PbpUB3rP0uK51Dj87iAqWhkvtW9PWS+zhS8EVb4cNv4q3h65/wL62A+GH8j9/qU1YEr8C
	 cKbjIlUJj7V07LZzNH8afZ1XApNMmVbXDC7mSc/Yet0oXtj3qGqNFIsziGVZbjdtO8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TKofGITs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235D4606A31E;
	Mon, 23 Nov 2026 15:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TKofGITs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AD91F000CA;
	Mon, 23 Nov 2026 15:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446737;
	bh=Y3crQHbdpOlgtQVKmilOb/+IWL0/tt7WDZKDspXm67A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKofGITszN1ewiDEtpVWMrbMfRwWCjDaHNbBen0MkvuNON/yK2SDQB6oS7h0PE5i7
	 tgeeEjk9sV/5XJ7z3G9kAxf6//s44qhgty+pZrzzDo61M+YdiXd76Le86YxIU2EAX/
	 HwSbyC1UA0W3Z4zrcXmIfMCafL1OGdpa/rgUknqiYoezjf1Y31SOQxHXpxa6hMZaQ6
	 UaVkSoFo7/YsqOymnRN90B9ffJ2A/R2G2juLmFoN7GZrDtN6Xkm8Ivv/YTgkknsdGa
	 jCfUfTf3VAzx6cPLRpi6voTlz17ryusbj9pR39GybniE9OqmDoPYwbl83F/U0wWxyD
	 2u7Vmxw9WVb1A==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Thorsten Blum <blum@kernel.org>,
	Nicolas Royer <nicolas@eukrea.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 10/10] crypto: atmel-tdes - Update output IV before clearing busy flag
Date: Mon, 23 Nov 2026 15:10:01 +0000
Message-ID: <20261123151055.2533735-11-lee@kernel.org>
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

In atmel_tdes_finish_req(), dd->flags clears TDES_FLAGS_BUSY without
holding dd->lock and before calling
atmel_tdes_set_iv_as_last_ciphertext_block().

As soon as TDES_FLAGS_BUSY is cleared, a concurrent
atmel_tdes_handle_queue() caller on another CPU can dequeue the next
request and overwrite dd->req (as well as modify dd->flags).  When
atmel_tdes_set_iv_as_last_ciphertext_block() then reads dd->req, it
overwrites the newly dequeued request's IV with the previous request's
ciphertext and leaves the completed request's output IV un-updated.

Update the output IV before clearing TDES_FLAGS_BUSY, and clear
TDES_FLAGS_BUSY under dd->lock to serialise flag updates with
atmel_tdes_handle_queue().

Fixes: 61b0dd664fa1 ("crypto: atmel-tdes - Set the IV after {en,de}crypt")
Closes: https://sashiko.dev/#/bug/linux-d6fd6f42-d6fc-47d0-86d5-f428e2203a64
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/crypto/atmel-tdes.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index c86d06169ab9..392a2a3a8b85 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -504,14 +504,17 @@ static void atmel_tdes_finish_req(struct atmel_tdes_dev *dd, int err)
 {
 	struct skcipher_request *req = dd->req;
 	struct atmel_tdes_reqctx *rctx = skcipher_request_ctx(req);
+	unsigned long flags;
 
 	clk_disable_unprepare(dd->iclk);
 
-	dd->flags &= ~TDES_FLAGS_BUSY;
-
 	if (!err && (rctx->mode & TDES_FLAGS_OPMODE_MASK) != TDES_FLAGS_ECB)
 		atmel_tdes_set_iv_as_last_ciphertext_block(dd);
 
+	spin_lock_irqsave(&dd->lock, flags);
+	dd->flags &= ~TDES_FLAGS_BUSY;
+	spin_unlock_irqrestore(&dd->lock, flags);
+
 	skcipher_request_complete(req, err);
 }
 
-- 
2.56.1.750.gf70dc682cf-goog

