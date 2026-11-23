Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446718;
	b=kbAFppQA3tKCPtGkMDkZYyZIvk99OiWwkVSozOZ7deYdGEKNNNXOcqC+fRzYk5DBATDI
	 96wWnljy7vD2uEb8nNGpQSphlw33Os4/urZwGlxBwqKJ8uLAxj5PKdgqloN4QFN8USAWW
	 LZPm5QkXldOZW4pr9Lo35PU+RsQ1J2DUD/ZwC7gkuOiIhv7x3yVrVDoxc5IkeCukYbTBE
	 yZnu+bolc8bLRLDgJSOg+Pks1gkP8YaCHlg6dVTooUNv+LrMK8UV6YJQFcK/xfPAbgiBO
	 nnaYMFdvzBOUxbYMygkeNcm6/s56S3VvKkJVgcqnlYoWHsd3f7Obs49uDIjZjsBwWUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=6643fNZDuUxhCwALNEhgGFYDgNWm1w7VsffiZE74HlA=;
	b=UnouXkqco7Nr+QGdp+vKyzTNcadGF+he6B6neLzVICUZ4OsIAiK+PENrmxUk/PikE9qY
	 4PhtQH6knT8JGtYcgJ5tjH3xVPqqSvWjGYy05CEdZqOp33fHlacaU94nTtNcZlAY8EyEh
	 HQdboAIz3Uia1yermvf0aEbH5bq3dfSGIgx4CFx/ZhvYhT/tTVz032FFj+cTnkZtn1lVG
	 sVLc+AtWSj9+CoKMujBbL5AsbnBhipCTqnk5lb5jBaWKL4QFigjU/7rDcmFah3A6So5m9
	 Jh6UbFmW1bzqddmJ/x/kkrKnqAhuRdPepJ6RWWCGS9WhYS1XHdEqGNscynQHf25pUSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XX2+g375;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A0D606A683;
	Mon, 23 Nov 2026 15:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XX2+g375
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7571F01565;
	Mon, 23 Nov 2026 15:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446717;
	bh=6643fNZDuUxhCwALNEhgGFYDgNWm1w7VsffiZE74HlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XX2+g375BvGN8E7aMpa/SBTswpN0EJgovGcreVhozXmkAyD+kCWBvDGdDgD3avrdq
	 uJRlCqrkWzco8xvtjp3ar7FXT7VXp8BmO+2EUmvXwi+4qpt+6XlrhVTGRaU3u6hi0+
	 kS8nyY4F6aa/yTGZvm8cfN1YtMtPItdAtEkc5W6dxiW0eYBWaSB9oBQcGgCinbOM8O
	 FH3zhZRpIjn8DDMNF/2uLHsk2Fe+E8Mq2Dz5dlFtICoAvFvAoGWXZ5+3yFVq7ORAFv
	 3uO2KSDUSll/MZYBsVlG4uRQ85/s1AuW/63yKfTp3BvJ0P/aCCDoLMAKAEfCSYJU3/
	 Z/Cgiz5rho+Hg==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 07/10] crypto: safexcel - Check scatterlist errors before max() for in-place
Date: Mon, 23 Nov 2026 15:09:58 +0000
Message-ID: <20261123151055.2533735-8-lee@kernel.org>
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

In safexcel_send_req(), sg_nents_for_len() returns -EINVAL when a
scatterlist is shorter than the required payload length.  For in-place
requests (src == dst), the driver combines sreq->nr_src and
sreq->nr_dst using max() before checking for errors.

When an in-place AEAD encryption request provides a scatterlist large
enough for totlen_src (sreq->nr_src > 0) but too short for the
appended authentication tag in totlen_dst (sreq->nr_dst == -EINVAL),
max() selects the positive sreq->nr_src and discards -EINVAL.  The
driver then maps only the undersized buffer while programming the
engine token to emit totlen_dst bytes.

Check both sreq->nr_src and sreq->nr_dst for negative error values
before combining them with max().

Fixes: 19b347b32bb1 ("crypto: inside-secure - fix scatter/gather list to descriptor conversion")
Closes: https://sashiko.dev/#/bug/linux-78f87af5-af5e-439c-bb52-de4c8c53fdee
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index b031cb9652ec..e7816f6ddeaa 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -736,14 +736,13 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 	queued = totlen_src;
 
 	if (src == dst) {
-		sreq->nr_src = max(sreq->nr_src, sreq->nr_dst);
-		sreq->nr_dst = sreq->nr_src;
-		if (unlikely((totlen_src || totlen_dst) &&
-		    (sreq->nr_src <= 0))) {
+		if (unlikely(sreq->nr_src < 0 || sreq->nr_dst < 0)) {
 			dev_err(priv->dev, "In-place buffer not large enough (need %d bytes)!",
 				max(totlen_src, totlen_dst));
 			return -EINVAL;
 		}
+		sreq->nr_src = max(sreq->nr_src, sreq->nr_dst);
+		sreq->nr_dst = sreq->nr_src;
 		if (sreq->nr_src > 0 &&
 		    !dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL))
 			return -EIO;
-- 
2.56.1.750.gf70dc682cf-goog

