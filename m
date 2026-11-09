Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184486;
	b=4J/EDayKI9EnGV3qNaDjzeulTFCV7hPoAWBwWa8e9EBTLNRrQxhtfN7sg1GEGqCTX10O
	 kqo7YeOYmiNlS5yOhImHEm4qGX4rFgX9JynIaTmopkSk3ESM0ppG4ep7HNPhcR/m/XzAy
	 IGbpFD14kIdzNjR7Omv1x6pZloOcERnM7h0h2ATJVm2zUvSZejp464Wb8T58sh/rcv35H
	 Jd7HR9oaFpGDhDJ2UWLdsSHagq2BVeccstxvQBcvnsyDbAyS9os0ywwTj7VBb+8I5G8Ir
	 7Suwy0nyvhaxtCf2vEIUdDeUo5nJ+lbuB/wHgfEe0wK4r49Tcj6SkfVvY3ndvUEpswA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184486;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=RVY15LYwgm0Qc/TTM/+0NaikfZtjUT6nkNDgccuwjcg=;
	b=hEtJ5q5V7xYr9eNQ4ARE2GG2N1Hbr8j1EMNCO+Ks2wsa7aEhJOebYxUR0WcpmwQNyhOE
	 rn4fL/nSRO5rWd/KCFv3DAZD8VNsEA+GQ31Qorbgt/kNhd5KaY1qy8paNi60FyBz2kdsC
	 oJp4k97G4NsBcbvFo9Jsm18Zzz3Wx58YNWR6EZmkdOF88LOHarSP/RBzCwR94y4z3dkpn
	 oIZZsY8aGh5RZ9RpTiC14FX3vssX+9kq9C2bJxZscV+XNcn+EJ67KkRu/jfWLyxlLHyp5
	 33YAiw5Z5qt/6D3JyR3PiE6PungVBZB0XCJ6CC32tcERx95MKdMO6C3uOiUDR60GPqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ar0o+lOa;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A41660A2629
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 00:34:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A41660A2629
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ar0o+lOa
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-491aaed7565so189483f8f.2
        for <linux-crypto@vger.kernel.org>; Sun, 08 Nov 2026 16:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184485; x=1794789285; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RVY15LYwgm0Qc/TTM/+0NaikfZtjUT6nkNDgccuwjcg=;
        b=Ar0o+lOaLQ36hMaSQhz240QICDkzMHtmQDPTHSSCzgvKoRRu6+3NEyf5r8UGihmdVO
         YbL8kGYlIwYFzt0m+P3LcvsNsXWFp1DnoXb2XeAAeHKjD0e3mSdbFDeNhE2C064eHQKn
         FBw+L6yYJJRGThN5FTZYemlT04n3GfqgGq87rIHUjOJoGNcaF4/DfTtKARyZDeZ/xjrR
         b2ektKO2o/QtZcCAYpaDtUDybpL+f8B/n0nKzY3lo3ZuY+C94fC/nTZn1362e+1nZpVD
         khlpFRfxsUKvqLFNzImO1bvZjdT7ysUCEMcuRxy31zGl1OqROACCKC3fKd/G1KVQ4t4X
         QYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184485; x=1794789285;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RVY15LYwgm0Qc/TTM/+0NaikfZtjUT6nkNDgccuwjcg=;
        b=dNhGvlS5fC8YDKCrEYDmcTxk6F9dfHhzWE0usuQze55Vg+yqdf5nIKD618KPpeMlFY
         AJyJiF3Kqj3k2gbZlZN1OwLpI8n+ImK7dGgzBvuICm760GZL3hV6S7rt+9gwY0baUZlM
         51ldvdkF5MYxdZHIhDZGTusKUmRenNR92hw2xH758szb3G2bfq5kwvJE5EwXV9CTzRoL
         udoDnUE5eKkFwEW6395lFmCWqv3FdTs6wsKf8vTW/c8FiJL3nmbZQxkYt+t+wN2rwin/
         6p2m4hM4Mpzki2JXDYFyCRae/mS/NebMKvQdhDRv5I6I5fPB5b6arOKv+beqcdE/oUrr
         SPrQ==
X-Forwarded-Encrypted: i=1; AL+hErGV3FZeOO0j41Kqx/3TXWdYyu93cFdtflUhpRFAA9iy7zg+2Fa1PG4Dk2Lb426QYLvYk1NMsHkT2axWHIs=@vger.kernel.org
X-Gm-Message-State: APuU4Z95GlhJ9C/68VtcZiOs17p4009dy5KsNDwnG/96PAVGs6YDdhO2
	Yu6Q06ToQ4SIOlaZY1DmGX/en+rHV76bvDRvAqfPL3eKmjOHcyC37c26
X-Gm-Gg: AYBFou1GLaFxxjdrrmXayF8zYETPFlYybg13s3ov53LU+xBd9BaJr2LqRkAwHMORr3o
	TGIl6au3XnM1dueuXInKOyrbyP52H/U87DWYXQOAS7MYVlwILCCSXzruI7gNpOe5qIvw1mL4XaE
	y9mhtnR8cJUadNjKyOV5HcRKo03Y5VWU3v2rzAcRiXc0VDdrgY6w2CY9+evZy8aNl2pFKsNy8Br
	vq01xDcMsLMA6IB+ZgcrgpfqCSvZ/ueCh9fOjH+MRMMXdi+AW3rI65MkYOI8admghBD85Abit0H
	+2/3wM4IV6WYIw3NXfbdQU3Dp8VuM5vl8AquvRRT79VUyLucWyF8gNRkFON2H2uyYA43sA29R4O
	nG6K1xQTShyo3YWuu4nSTHmhm1EaVatZsoawlYZ+SxzJQsJy3g7/tEzMrlu5PCumRqQcEc5Ctgd
	8JV0oquT9KB4fC28Ue36rd8Xth61ClNIptXBcd5o03JbfdvWviD+kTO2G6cU1+0MPCFO4Ce0X2+
	cW9kqn339LEm1Bgexma+N28641w6g3KGZ7P36MNDJufDl39khCbifdm7hoGNNZt/oURgvDms683
	HYuA/FXsQTae2PjysDhmhFF0rfa1fIJN0VxGt1hH
X-Received: by 2002:a05:6000:481a:b0:48e:62a9:1a65 with SMTP id ffacd0b85a97d-49584690551mr4596063f8f.49.1794184484831;
        Sun, 08 Nov 2026 16:34:44 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:43 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:26 +0000
Subject: [PATCH 14/17] dt-bindings: interconnect: OSM L3: Add Halliday EPSS
 L3 compatible
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
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-halliday-dts-v1-14-289114ab8197@gmail.com>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
In-Reply-To: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Lee Jones <lee@kernel.org>, 
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Amit Kucheria <amitk@kernel.org>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, mfd@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
 linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-pm@vger.kernel.org, Stanislav Aleksandrov <lightofmysoul@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=844;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=gWRtexQl3K6zrJ8s8OX25X6Fe6c5gXvBp3k5tSGU4UU=;
 b=pnbK9TbDaJw63lMsp+XBx3cpAT1m6LlRO8M5pm7At3undTaYtmQjFmjLHcmBIU0XLq40cIoX8
 jdWhe4OxgWuCqPNlp+TJGp7ld3LSdzNJFNkDbr6brDzv5M8VXRxZg8B
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the EPSS L3 interconnect on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/interconnect/qcom,osm-l3.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/interconnect/qcom,osm-l3.yaml b/Documentation/devicetree/bindings/interconnect/qcom,osm-l3.yaml
index cd6685683bab..6c3475005a35 100644
--- a/Documentation/devicetree/bindings/interconnect/qcom,osm-l3.yaml
+++ b/Documentation/devicetree/bindings/interconnect/qcom,osm-l3.yaml
@@ -31,6 +31,7 @@ properties:
       - items:
           - enum:
               - qcom,eliza-epss-l3
+              - qcom,halliday-epss-l3
               - qcom,milos-epss-l3
               - qcom,sa8775p-epss-l3
               - qcom,sc7280-epss-l3

-- 
2.55.0

