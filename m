Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793679269;
	b=u6WRXlJT0cp5/kUdgNdbEh8Zi1+OxfzkyQQn2Q9D4Y0zFU5YvLG42baWESvS4hYO2GSo
	 cUb8uf0e16pj+6T0bW4qkaF+Q8xSRguI6oGd9GNcINq9DiF+j93WdjDnH9u9XkHu6PUG6
	 Ms+pgpYkX6y+i40IIxUkOp+LIokTXf37ruTTwcgKkGviU3UBcP6W3lOvU4OMjE2VwYGZz
	 /LnGZFH0qtnGPXXzSrrRNvSpa58hKwY6LPmRuZqXhTv4F/UI8tj0+WVJIBDw6X/kIwCJt
	 na1LfVe3RcI28+omEfMnmotzRuPvAV7FJkWt2xOkSEjawjys72Fj0cOxWaH2+/JPc3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793679269;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8kizTq969MMG4ZmGsWzf/eUqjfpKRrKiIja6oeumpC0=;
	b=MEARZwU0UNxXRAcguU/3gMvile7YWO8YnttbAjgsRGVe6RzeGudrLhHxjl4Fn0Jv+fk6
	 uDGkM12Ybmjj8oq2+VytTTN3ql35WsjV8siHKpvvjgXKLQwiQoHecS20+2ijQDOof6D/+
	 2J3ieLGJP9tR0UFXfuwI4tde1qRvkcmYQSEqxFzYU3BxJJlYfDtocTpusxFosgwVMAcTP
	 xjIB8gy8Iz26TTm15q7OUoKZ+WBaSzpH7zxEQ/kUaKxZKCLAEzFI0WMSCYTWIRgumfapN
	 OItUPi2xt06pqjI0lcFn1oeF8clFUqNO/tRFQCO9Id24AgGOfVnHlrVf6e41Wd13M3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zi6uix4u;
	arc=none smtp.remote-ip=209.85.214.181
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B34606D823
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 04:14:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2B34606D823
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zi6uix4u
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e5fb79ce82so24345665ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Nov 2026 20:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793679268; x=1794284068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8kizTq969MMG4ZmGsWzf/eUqjfpKRrKiIja6oeumpC0=;
        b=Zi6uix4u7aXuz6apso6LznxjPJQg9eYwZVSuJ80M4bymN8qnbfdlpmsTag/HfyE2BA
         AI4E2GNOzCn4+zzpbRpjPV7rTAzZN7/HmvlYHbY5l+6I1pO8Cjxg+dzu+CUWAQZls8q+
         CJAPhOduNod28zGMYl87MbpZ3WFBurCGBM91AUm2GZAXCqa9n78u0m0Kp2SIxcoeNnAI
         CJHAqkiPR0fU7ZH0uGgi/uTk1AU2N8tUEbfNsXS2ihyhLYKXsN/Jv/Vl27swLjD507ez
         ptKsDHf7F6/4s/P2X2cOqxbvOgj0N1C4W+8nADWPSFK3wlW83dGaROwNae4jBzA6+Yji
         EdXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793679268; x=1794284068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8kizTq969MMG4ZmGsWzf/eUqjfpKRrKiIja6oeumpC0=;
        b=NZ9xpP9gNRt6ual90THyp005yZqa5n8NKWa3uEQNNpPTsMbjA4OZ76AKmXwoGG8y5I
         bvlvXvFgpgkLy/iDbX+Ev+o8m8np3cr+jVtMTFGdcQkkulBVOFt3vbMbT3ltMkwGny0Q
         Buu1l+rKUwh8fIhhsKTKkcIYBZi1Vs5ON/oRRn8uXNvSC3QNTVtBBXNncCcbfn2tnl4X
         tRYjaScC3dR7ZDBY+Uoab/jiBAXYjMSzq/nLmrga9LkhJee67QMlVDTwSVwHCIpU42w+
         MOXzof7lNTa5FKWnHKJ5Tr+jDRfqNLbI/fY8kzAQ1sd0VTPI2i7IhKQhoaX32jPFuGMO
         Z12Q==
X-Gm-Message-State: APuU4Z/OHXMzWKsrnj+VnVIaq82+S6SM+C2NiArt/HiNft4OGYYVQcME
	cfioajvdE0C2Nzuk1ghFlBuqeDH5536OmkOp2oj2m4i1ZkRqYKUXYQJs+alpCg==
X-Gm-Gg: AYBFou1OPJcj0fCc4/6dLiRuRRuEIAec6GK9pZ6f+TEhjOH+8IAZ+ScskQQ7z6tMPAX
	ggB8LcYPVLxJkcZSFn6hfhDwrkZeoRtuPAxTNofDYcqR9XReWknjckN31LRbmElkfWbqT1hwnhj
	7WjO6eRVcuSHGW4vdCBYZdsCP1m3Gc4fINKJdFlUKgerWsGvwzGC8hVhmWfPQonXp97TSTSddwP
	sQdeFR+jKHWDV63hmxNJUzaUZId+D/RQQnYLhvvYvpVTo8Fw1Ni7+mnvnF6gXoQrbebRqgwW8lx
	eTydZV0xEJZ+1Zm2Dl8yi4L52VObbUzxaZsob7mzSechsKqO+TJsFjwCU3eKieL9y0LVs4X7ntT
	+iG+kAvNsJqM9T/glfvCUhH1ShTeed2oNXOEoXN3h7vkETGRi5eMpyDtXorcjoiMQTWIaKza8S8
	blQREcv7zhCnWK7Rv/PUR3aeIerMj3RfOlH2LZpP5JvKSMYyzh2kSwIdgdIp+/MZlNCRCv5YWVH
	t2BxVmkRYCb35eGF/KXWSVL+SX9e/kwEjQ7h9E6uAgiYklWws44+iGMQhh7ZPdIJXTINdKjID8p
	ezb3Amu/bVMghfruF+JuGB5URQK5QZ0IZcIsV9FCAWPG4hZeWCRm
X-Received: by 2002:a17:90b:4e83:b0:3aa:f4af:1e0f with SMTP id 98e67ed59e1d1-3ae89536c2emr9621091a91.8.1793679268202;
        Mon, 02 Nov 2026 20:14:28 -0800 (PST)
Received: from d.home.yangfl.dn42 ([2a09:bac1:7680:28::4:396])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c6740a1sm1989659a91.10.2026.11.02.20.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 20:14:27 -0800 (PST)
From: David Yang <mmyangfl@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: David Yang <mmyangfl@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Danilo Krummrich <dakr@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] hwrng: histb: use device messages
Date: Tue,  3 Nov 2026 12:14:00 +0800
Message-ID: <20261103041403.4071708-3-mmyangfl@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103041403.4071708-1-mmyangfl@gmail.com>
References: <20261103041403.4071708-1-mmyangfl@gmail.com>
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

pr_*() prints without saying which device the message came from. Print
with dev_*() instead and adjust error messages.

Signed-off-by: David Yang <mmyangfl@gmail.com>
---
 drivers/char/hw_random/histb-rng.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/histb-rng.c b/drivers/char/hw_random/histb-rng.c
index d435d4ab9aa7..d28cc84e8367 100644
--- a/drivers/char/hw_random/histb-rng.c
+++ b/drivers/char/hw_random/histb-rng.c
@@ -22,6 +22,7 @@
 
 struct histb_rng_priv {
 	struct hwrng rng;
+	struct device *dev;
 	void __iomem *base;
 };
 
@@ -71,8 +72,9 @@ static int histb_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 			if (!wait)
 				return i;
 			if (histb_rng_wait(base)) {
-				pr_err("failed to generate random number, generated %d\n",
-				       i);
+				dev_err(priv->dev,
+					"RNG timeout, generated %d of %zu bytes\n",
+					i, max);
 				return i ? i : -ETIMEDOUT;
 			}
 		}
@@ -142,6 +144,7 @@ static int histb_rng_probe(struct platform_device *pdev)
 	}
 
 	priv->base = base;
+	priv->dev = dev;
 	priv->rng.name = pdev->name;
 	priv->rng.read = histb_rng_read;
 	ret = devm_hwrng_register(dev, &priv->rng);
-- 
2.53.0

