Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184436;
	b=gZ+nNdR8gLeW9OE6BYd+Y00PT7qjxKEeMJS/001hrSBKVycJM9YKmztJiSctjMl4VMJ9
	 IQj38oV+MjCZEFMPESi50F9FPh5eW+2ahxxivVr16R5ncE24bpgOuKNWktL8xi61sIzY2
	 NSqZ9JiiWM4kC8xEr2gqqYp8S97oK4VdQT5EAq4wFuBwQA7tAhDU+5N1QsgV0RaXfBcvP
	 4fSpRsJ871MGv1NBNMNGtOYBsog8ilHQTr7/fboUXgruJTIwU4nMN9UeBaoNQ6Oe9arhf
	 htGdlQh13zbt0sZVD73yQ5hg/vCKfDxuvYHxbmaI7HlGOBJaJ2akVEsNEV61SBLdLVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184436;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=b3VvGqgW7w89m51V5OtlQCJq1vHDswwHimQMB9pEHTM=;
	b=pYlt3+W7bNmnqf5efl/oA6jHn4lBJJTgNyYAkxp2MeBhj/lLef2AF2wdsBtc0q5ouxj1
	 1zbd878i9lObmHTnTPCot6YlATM0XG6CxvhnbGLvm8UTCNNvWV3HqeE9k/gj4zRKqnKyW
	 JlxxantqiUUPbxCQz+05fVp8JPpIRVhEeB91G973DqI5w5S33C7VcT8ui8o6zLGClyNkI
	 SYKG5Rbp7IuUACR7cxtmxMX0IOSJoIpsgE7hGU7VkUQOpkaZJlL7bdCv66wevZLFLDVNk
	 nkyog3gd9OS9czZY7KVB8pE+XHEVDUNAFDrBXLcfy6MP8iH8l94nLj0v+RC6zd73yZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EjJzEiWq;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DB1606D815
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 00:33:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1DB1606D815
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EjJzEiWq
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48e47347279so204931f8f.1
        for <linux-crypto@vger.kernel.org>; Sun, 08 Nov 2026 16:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184434; x=1794789234; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b3VvGqgW7w89m51V5OtlQCJq1vHDswwHimQMB9pEHTM=;
        b=EjJzEiWqX7bP8p2RpKx0A8Mw4VIgcyhMxrNGNGYks9jT5K7ErZactzYCM9t6cwd4kq
         HaawBIqhzJIoLY4VKt7M7axDUH3ltzAQECL2DA4uwdXfdrRmzhjFbqCwUEKRsgMmA3OT
         yUx4/q4gfrM7qxWKUVkUiMy+1fv7O8bhhnA2B0BUCSLouXNRGcMKyshx7XYeRBPj5cMQ
         wqd9SPL1tAWpz/KhUuAGxUxS4NdfwwA1C8dkrWO405Sx1TUg/iTb9/AsEtLF0Uiqhn/2
         2FoNSTstnuusd6jY9eQoW6qa0bQaccSOIzfX/PXknfF9DEqb996bbOcC6TQtKxYLJM+a
         m8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184434; x=1794789234;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b3VvGqgW7w89m51V5OtlQCJq1vHDswwHimQMB9pEHTM=;
        b=FmwSwJPKa67z+IsRdop7CW4NYAkz6u0mJ48rKBE9xwqViYb0xNWGFArfZZfCeGdndP
         AYo4a2jDj8NKN/U3xtDbBw77XCAvcuVNglEqQkpoLgT5rRwRnHu5FKS6/eJpZBP/BSGw
         9pcKZ/gqih/auJZl6pckd5vFotB7cTVxiqz59/CDKnUxwF0z2HVNyIuhZDNxGz7YjXvj
         2C4WolhJNRv7+GUW92a49Uw63iCGObRLyJsD5UOzTn5/rM25OAmt/XmUhfODJHfw983/
         vpa0NEuZMuqNs63LYdxe88lUrotlNd8AVJ2YoVIJlAMX/UmATGvRmVLL/qgVRoEencbF
         YuKQ==
X-Forwarded-Encrypted: i=1; AL+hErE14Lk1Q8pSjdiuS4qHlTarg4z2bMoKx5bm6Do8fQWJSQMVq05iF9+NIxtE71QzJuVKmLGEgQNl8j0yYRA=@vger.kernel.org
X-Gm-Message-State: APuU4Z/qXQl1tAYBG4xiyLuHT8dMysaWL4ysUKJOvfKN+bm178BRRCBw
	sG8Eb7q7CyOHMlpSVJS5/OmF3tscSjqb6LqfegJSZRC8izWsVV7KRjw/
X-Gm-Gg: AYBFou3rf5RgEArzamnZoJ944F+It+hiYpwSCfPUmrVzu2HgkbfwGwVlWwEd1gm2I0q
	wEcQkFgVCLvBBpxjyDYcFEPzelUol3X98Edq1UB1Hr9jjmODfSoEGiJshFQCBwZcVlN3MLEKonk
	LFWuLHRHW6TCx6y1HBZPxQJOrB0Omav93Amtidul502G4Dm3wBVGbKVQNnGQx01lJbkG3Fw6658
	EYOJ6JB7DJiDLh+TXfWw5donL++h8BBOAlYh3afdvm+l1Y5c09Eq08dkTMpjFEN7ur50TYyLl2G
	TKtI7c7FGRDMEdQKn3nglnqpnFgm8pxieU7PourvrxV7EOANYHRKd9xKgENtPQGDm1VjoNe/rcU
	fDwUTNbSYilybqzWwNHjTD+Hv5vc5AlwoXOeNldZu/6a8WlghGCT8prCVWj2pLCdKN+8rfnK8n3
	XvR+JdPe5zlwky9e37FEes2HT2ddoUm7XgkhVVWgFFGPQwkr98AXNRweWCyW4CBzQbLTNbpHPBy
	AM3kgwMLFhFott0XnnbPLpC9rDf/QhXF6X3j0uGpgpNGmAYUSrxepJS47AeIUHvrqLEmbq38ZHK
	u6tXjCWKJlOsoKnUxGb7nPFlqxzn8saEstrro+WJcA==
X-Received: by 2002:a05:6000:186c:b0:493:2eb8:e7fb with SMTP id ffacd0b85a97d-495856e15f7mr5379354f8f.41.1794184434351;
        Sun, 08 Nov 2026 16:33:54 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:33:53 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:18 +0000
Subject: [PATCH 06/17] dt-bindings: arm-smmu: Add Halliday SMMU
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
Message-Id: <20261109-halliday-dts-v1-6-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=1112;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=ePrzoruUVeLDRq3OCS+DiCl1d/Uk3kZuK6w1BATsFKY=;
 b=pH81WehGSEFzi7T7LS+ShwXYAfu5lsev7imaA1JaeNifItRSFvMkK3a/y3Fr2K8IwuXgQfeAv
 1F1xnpR5tNxDdiiDmSxt0TVIqWh9HxtwfbMTz8uhxpsozlK3LlCAs7D
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the SMMU-500 on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/iommu/arm,smmu.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/iommu/arm,smmu.yaml b/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
index 6748351c7812..925afa8cca8d 100644
--- a/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
+++ b/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
@@ -37,6 +37,7 @@ properties:
           - enum:
               - qcom,eliza-smmu-500
               - qcom,glymur-smmu-500
+              - qcom,halliday-smmu-500
               - qcom,hawi-smmu-500
               - qcom,ipq9650-smmu-500
               - qcom,kaanapali-smmu-500
@@ -629,6 +630,7 @@ allOf:
             - enum:
                 - qcom,eliza-smmu-500
                 - qcom,glymur-smmu-500
+                - qcom,halliday-smmu-500
                 - qcom,hawi-smmu-500
                 - qcom,ipq9650-smmu-500
                 - qcom,kaanapali-smmu-500

-- 
2.55.0

