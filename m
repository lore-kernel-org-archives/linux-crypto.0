Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578254;
	b=mtgAMxv9qjm5NEIfG+s3BuI8SGDwBJaDWlHsPIdw+aWhFFJV0iopQ4csU7RcVfd3oVGV
	 WrkuUPv/O+aq8MdXWzabGmUvTE04pVOcdj32B7FFf1p1n2xZQLMG6GyeXVjZFHDlJFdF/
	 93lA7aZpXI+Mxw9UCAD+haftXA6dpBphxLks2OuB2g4NdSNb97DOaWQdnox4QkEYgrt9V
	 64lZKBJCmcVNQLD6PEMiUqRnIAxS70NMAYAMI+cEqUq1ozzv55GCrW1441iwcl48tHHfq
	 WNavBJglqZ8IJD+iEbyx0lpLK7AxlWXHdbeTgWgAJNBDWQkA0oFlZjk7shOyMgoa1YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578254;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=0gMkbbLOot3bX7ZvRSJsql+Zsoh4W/ttXNIHMpReErE=;
	b=fcQFZvFSH0VaPdw09VFukpdt4bk1jniKj/YatNLav+WXBBp60J7Ss7wQKbF4d88CbFq0
	 kzgwWJflnJz8EzqpqLAJaftU86rWGtef+wor9b372FGOPFbWAgpKYJNR/UEfcc7oOTKIq
	 LB63Zucm9jO15/ayloYtklinmEt7z8pJkstBNuj5BZJFfeAizEU/gmA9Z8CYtHE05JvC1
	 XR0x8vgQzSBylT3V6WsN+fOk/PT+6z7P1EO/msBtfWM43UpfWV3RK9DHMihegGCBcx77f
	 poFegD0fJBC8z/iiakcYuysZDlwoGgpm6mgT3JhFDrO8VglMSLaE2r6Q/8xiX4EOdrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lEdBuKcF;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA88606A33B
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 03:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECA88606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lEdBuKcF
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so51567365e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 19:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578252; x=1796183052; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0gMkbbLOot3bX7ZvRSJsql+Zsoh4W/ttXNIHMpReErE=;
        b=lEdBuKcF0JncIpcutUemWRCVLwcBptVk45nftYoXdUPaaPEMjOXhRvlDgUBMqszRSi
         GjVW7ES9OlK67a/2KLB5I65GkIV14Ylzo/LfhicqUla0tHCcqXUHFVnVhyXZGsWk1GYi
         30KWFrA88HI/8R90LcNab9RdDuPnarcq6aW8IuA8Dbg3UasrVz81iXsAmAz52FFpSxkl
         kwCNrdjoDvsHBIUIV7L7pGx49IZu2fqgEP7oIu858HUHqjSUGsKRfpJS4Xm/DgASvkCY
         ohconOG9BXS7zsTTxG601/wjTYdl90IpxPDLaEEQRmhw8dfhpInmpWHAFkRnignmsUL1
         jNnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578252; x=1796183052;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0gMkbbLOot3bX7ZvRSJsql+Zsoh4W/ttXNIHMpReErE=;
        b=CUSoYNyYGh2m2FsDE4GpomWBs+wDBzurEaUABQ3ifYhMgiErZ4G9stbL+XuGsTJO75
         A+ebLhVttzdEex3dcgYZt0ibAsoX2FghuRQ2rMlvGNZo2US+Aj6cpWH5iHQ9e0obTY3l
         1p3Rc5Pl7JZvxRH60JrdXrNHaym4EPJVy66WLqXo7UnLIjFRITywWw3heUJNxHbJkmqq
         Uy/c0iUqeQlybBDf+29Mi2y6WxfJLhPU+mOHfFHK7PTpqsJZ8MgojThbmDNgU3Qa20GC
         cXHs70Kam4MP9U07bpMvfFugw0Z1lc3f+/zb5jQvs10OfP9AY/TZsnP/Dc7+k6REPhel
         sp8A==
X-Forwarded-Encrypted: i=1; AL+hErHF/U2gTK5VM3kmG160WeZJ1GGCOzXFrC/6c22XsNJ8o5hnMIUMiAzRdWw+cwYr68bp5QBbRtT0/HH9fHE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/XJyjPiyt3EMiiTA/GZDb90YW1rp+aHYZMbxCIEX1MiFs7ZnxR
	MIYrpdtt0NqevV8At9rSqRO+gb2//JnCbjwts2+PZ1ohySmzNtCxpbFk
X-Gm-Gg: AZFdTZdn/x44KMHOWFjMWpt6h1Bykquo2x9kbJZl0hvzWuLC6k+Sc0ZiVcL2dnsozrk
	YUIYp0jNzc2srDS4YSZohIk11pcFMz5mhUbv/6byOuSqaehoZTB6WOZsXX3x9M1v7dilzw49z0J
	3bjrIkkgPEiyNphFTS5pmyRr1JwsDQfP5cnJAWkgxPWZgzYu+ozeMs+xNj6lRyLmgeWT5jeen7k
	t7LqYD6jX+y7nr6ahYw8pV729CJYzW4PvdS835hmT+6pN5hVSWFsw2sTy/CpsqKArkdslgsiljO
	Go6R4Chv1AZ1l9UUOaU9dHKAL3waP70ahSRFB8txhvYzKJRtiaah/ZTKYArkvokNUBZwbnw6EWJ
	8KkECmlLfvsHKrmxYxjH8PvJ36u7I32rwNeoT1dam7hC0psnjHfiMfYrSq5Ivb828a+zvIfBm8j
	f2FErQQUTcsZyfndmAQMZTGJDwGt/t81hhgJTG/ns/7WnRDM9twARGEFEpSP8kSLTuG+WDzJYat
	vNvrLN8o7CpeT306JtC/hq2f8xbprXuOgnRwAx5qxjDJA7q9+ffMfLxNennf9PJK/IZjBV9pIsY
	w8JszvHDmnm/Ez7TR+Dqg8eqiRbPJPw8LfrUoj91f2GKgwd2P7S4eKOtC6c=
X-Received: by 2002:a05:600c:3b84:b0:4bb:6f45:2a6d with SMTP id 5b1f17b1804b1-4bb888074bbmr399963545e9.12.1795578252392;
        Tue, 24 Nov 2026 19:44:12 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:44:10 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:43:04 +0000
Subject: [PATCH v3 08/14] dt-bindings: crypto: qcom,inline-crypto-engine:
 Add Halliday
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
Message-Id: <20261125-halliday-dts-v3-8-5c8311c0b70b@gmail.com>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
In-Reply-To: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
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
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 iommu@lists.linux.dev, linux-usb@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org, 
 Stanislav Aleksandrov <lightofmysoul@gmail.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=991;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=iODhhsd3yfvGtcciUvxgx8qkDXgsEtkBlczLh6ZRfrQ=;
 b=lvcDevXHoUjfOVIKmGcAADmxVZULBy9zMoHqx2H32a0E3wUM2ikLAFlGNM8+8Y16B1yXdXwzE
 0y99BcDJDu0At3F9ibFbmmvIZEbRo82dQ3K+iKDoR8DVQfXtRsOln6S
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Inline Crypto Engine on the Qualcomm Halliday SoC.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 23bf98c2b9fa..1512fd1d7471 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -14,6 +14,7 @@ properties:
     items:
       - enum:
           - qcom,eliza-inline-crypto-engine
+          - qcom,halliday-inline-crypto-engine
           - qcom,hawi-inline-crypto-engine
           - qcom,kaanapali-inline-crypto-engine
           - qcom,maili-inline-crypto-engine

-- 
2.55.0

