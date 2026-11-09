Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184461;
	b=SygUkdlZPpuJwkD8Dec5RlC2Xeszz/O95AX4JIx6Qjvsm5Ace0E8T8TXxoWDNfcDS5AT
	 z8DdEDT3FIH5MW9BBzw3FZcVqT7ajSFWlShnAEscFI7i0WKTa6n9JHDNd6LVhiWVwGDbl
	 tHvI39wg3IT92E6voKWDYSIc5QIcxaHx++RCPOPA2cDUDtaD0r8c7LcQxNMPVlYfbv4Yd
	 EPpBS4a8wXQ9BtorpMqyvvwb84c6oKRct/uy1M/Ytdqx04hABYF2kJxbNFHIYs73yff0J
	 l4bwGJGYURCfJ5QJW8rq7iYidzf++1eWFETFbQOmSclF6EncYCdjoiYfza5c6TIuf0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184461;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=w98VdCA9EtnwfzZZ4SHf5Gk3YVXSBdJ/uT/O1NuBZJI=;
	b=ouJ4Z7LYHSr+8nDV1GjmGfoXow1e1AduiypUKWiDv7CgN/QhD1ELkFEFq1CFnsieiumO
	 zckb8y9zVLNTYOIbOKAH4GjpUPjSsu/ixl2+6KhUEyGnAZR55PZd9b45bdpscTRwHfmt0
	 a9tpHo0fB70bAvLmXCbN3Tcl0HAIiOhlgb6nX5MOR3g/cwn6tn6MAdjPHlvQJKFGAS8ak
	 S5PJbREg5PCxiTUr/fYcwa51vksZkza9Tb+HgQhy1gY6bpQfdj9LtYkf2s6CCgBlbHzXW
	 r0B/zrArIpYj8WZc/FSvWqGUdqloFhz9nAMZdZBpglcum4moA0raxvX9X8yPwfTOqHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N7tYZs96;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44396083608
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 00:34:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D44396083608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N7tYZs96
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4910b863b84so218852f8f.0
        for <linux-crypto@vger.kernel.org>; Sun, 08 Nov 2026 16:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184459; x=1794789259; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w98VdCA9EtnwfzZZ4SHf5Gk3YVXSBdJ/uT/O1NuBZJI=;
        b=N7tYZs96oQb/Ryz4NJ3+wLdB8gJYPV0iNzi0rgwTg8Dg6VnhJLQB9NE7KBBYmhqD6Q
         axv3akcYK460vYrVrYt3Y8pjMRxB16kOVcf0K48qc42a/8TGC86FwwuNSDSXLA1hshxp
         XP5NnH8JLh/r0xGiHagFvOyQe9k2AUIS1Pm+4EFPEOHWnjDLNssuwbLINZZGdJZhmIDh
         kbRkGnA3vcUMtNJahy6FnKi9GjefzyQbTZDRLiSLqJFXP5eAwsWARsf6et9MsoIBKEzN
         cBe8CuhK7MiiqlUEWwipkjXVaoHzBrSnLgAUTUGXqGTOzI71CsQIVtEWNZdH6oir6Aec
         712A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184459; x=1794789259;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w98VdCA9EtnwfzZZ4SHf5Gk3YVXSBdJ/uT/O1NuBZJI=;
        b=bcFcaAtMnSHjhNbPyqchesauVQ4sCGpXSuu6QTMkamCzpT2Pzn00L6VtJU8Z9HAleE
         PIyA61mOLmXRZdEHaoeQzAOf1pLG27NLTR5SKEX/8gV9VSyMkvPJe2hO2TJG7Q6nFQNq
         QHC/aNYDoOgac58oT1o4b92Trk3vtIAxiSkASXC8Kgyz3Q/aF22SyjB8cB9tPcodDocj
         XeBBWYXqE/Ok3JDjiZY5Oxa6p6vat1v1YgSeKcaSbBpRk50O0+jL5H5+pu8MF9W7Ags9
         egrkmKucqXTMp4qgtQFgxbWcNQsiB+D1q/s7fg5B5UnW+Hwvf2ej+JhIkaGF7VG2iS6F
         q7aA==
X-Forwarded-Encrypted: i=1; AL+hErEuJ948glb0gL+jlap4hRlBYrqsXs/pvE7C3i5xTFZGCQSEKBzJ684TNr81OkSoYZ0my0q01jXGXpURscM=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Af4yjkg8IUFD933pBePqikW29vbfCffuUjnVFRn25Ss4ScjpU
	fSBjtZuNNYlJd0pNdK6+axv1ofBTvNfOhnpkvl/D7gYlx67ou4rIS/Au
X-Gm-Gg: AYBFou2HMeFRCwQjpY/44jtPH3U100f3Ik1j9xhe5FTr6IYL+qSoPlJwdsFj6RFGcKQ
	CvZhhdfIJmvU/P7MPRKMqf1hZuETqo3uJUacbjePxv/SgDGY3x2Qe3A78U7Aw8X+qbGPbUKZlO7
	3tqnozafTUBUwitF2KJmlGpAd/KSaCrRnq58AT8Y2s8zlIwJM8GncxRmQkZr81M5RtjAmobP7tW
	t+6Zoxd87l23nCBrpmc1xYxc6SVwtfVV3nI9Y+RSBEZhRVINiR26wRyPHIP1EyVco29hG9kELxq
	dJ7rcT7cJMtnKhDf/V8dXQBG80aNlEQhLpfY8PN78UWu/Ma/MfdH83WarT0uBRVsUPWoGXCxOqP
	hk+vkGdmkq/c5trnn65j75VNK48oMDytLnQKr+4qqQYknI8fr25nCLecOYO/dWAUajvByyAuXYl
	NnKFSl5zKv75v/Y7W4d1Nz7RCP4E/FQCFolsBBN3/OX+yj7IRah9sBag6wZT/ejtJYH6zrTWNnO
	D4gv9LuFxOxbrQPy9R8OyZQ5OhBN9N8+n5R7iY9G9B8CtFtBBc1y3u3SgO7Npyho5jab8ZfVSyB
	3WWOYeuEvMIs0YuV0VPB2cxZ6K0WlkSpj3+wskwX
X-Received: by 2002:a05:6000:2511:b0:48e:d7c:4bc3 with SMTP id ffacd0b85a97d-494248ee013mr10847131f8f.21.1794184459219;
        Sun, 08 Nov 2026 16:34:19 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:17 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:22 +0000
Subject: [PATCH 10/17] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add
 Halliday
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
Message-Id: <20261109-halliday-dts-v1-10-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=993;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=Os3dtyGi4Umq8bQ7AEz34h0NK9e+Ws6GY42XJz6qujA=;
 b=whHNXCMkWBlbyRe6Xqxsfmk8vbhGS1Ie1Ck2sCxfwGhqRMBxKE4lbZ1T0XWovH16DltXzjMRT
 ok60qvi/6qNA6DJ9tcvRYuZUzSKXMRRZZv1H2XgMMF2zBm+cXxEQ/SB
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the QMP UFS PHY on the Qualcomm Halliday SoC, which is
compatible with the SM8450 one.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index 10435a0b5230..a42bba9b550d 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -28,6 +28,10 @@ properties:
           - enum:
               - qcom,qcs615-qmp-ufs-phy
           - const: qcom,sm6115-qmp-ufs-phy
+      - items:
+          - enum:
+              - qcom,halliday-qmp-ufs-phy
+          - const: qcom,sm8450-qmp-ufs-phy
       - items:
           - enum:
               - qcom,x1e80100-qmp-ufs-phy

-- 
2.55.0

