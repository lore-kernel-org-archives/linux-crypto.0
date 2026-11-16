Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864401;
	b=ON9WiGtQmBRIhTi8Iq85AwJcR00G+BGrjP4hfBUHTd27roVQ4IErTYgDhoeNiCoD6RKJ
	 y5ozEUbmiR7JmrT1JWT+4osxKBl/a6Gkm/d9o7nDEipHuYGal9xhFIibjwZmt3pXrhN5E
	 tbAw0n7AOgvHqyGPRBkQ7KnZX6ga/dmFL/OVrzk2kV5Lz99vhXPD2StVdRM3DCy4NaSvy
	 pzhvjZf//eeTWXePMgF9yWxgKtFA9+LQe2zQeDbvLMUA6jJjw0OEaFlJhbJY1+aJZfLmm
	 zOwKPCQeZVU7C7vC2fCAjWR7+CimS0d2jvcjkmPkZI9P0ypKi9/EOL3fJg2y97PpbWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864401;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=drwleRdoQE3pkKiq8NvL3TA0ZreOLUUT7TR68lPFDhc=;
	b=mhzXsWSdSW7Hnq3nKIrXBRKDoBbn2Lgw1V4Xor65vSUdAO+yNwOUZBo2hHd1ylBIOkpo
	 McSv7tSAXVQZBkMraajNrADuI/9KCxJSIxZ1ev0PGfRJpGKv8firGDwkDsGLKgjobcrZT
	 9pid+MTbNIoaisM55paVNG5B5ecI0MuOt7dn9wMz6toTfzgr/Ef/WMgnLhtEAwBTxCMpN
	 Hcvr2qdGlydB3ckyS7n1oeT3HfKffRkFpSuQGGhnYsKGKcIVOytkzTnZ8dcMibl59w1J2
	 SjEtkvRoSJ230nSWdsReEEL8zdtNf/ZiIX5tq5M/s6JVcpQ85be+6V9s1dD+n7HJBzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=y3jIIAKb;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D985606A323
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 21:26:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D985606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=y3jIIAKb
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb61185057so16924925e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 13:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864399; x=1795469199; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=drwleRdoQE3pkKiq8NvL3TA0ZreOLUUT7TR68lPFDhc=;
        b=y3jIIAKbbbSqQMJBSkJHyd7OrigIp9VoXLj5TrsVjC1P5SJK1+6GfH/CwfjSUDChdp
         aSUwKzVMSzcpqSu+dYj881QSy5uTr/mR1OuilOAa2PvT9ykPWZFupXWFXDJUWg+Evv7+
         YMfIN375w4C+9j10ZwuEeWRYPJesN+qvcukrs197w5O55lUuxshj1qTYZTKsY4pTkB8q
         AmWVhst/9ZLMgOWXi9rzj5DYH6Nkhc6djSlUphB9PtYcVDNyHJItRCJ/2xhCROn2FZJc
         u07Cqgc9tSSpuyxqc+gXNYk6FMS5PVUI7wsv9LBks2s6FQbonvj25Ul9GhnE9u2M+hED
         rhww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864399; x=1795469199;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=drwleRdoQE3pkKiq8NvL3TA0ZreOLUUT7TR68lPFDhc=;
        b=qE9cqnkmf+7Pkn+rZHo0LAC7EWcO++GrivnvqSmBdHt9k5BSOJJ1fzqj/8uI27/epx
         A/I3r3nLb7owEEXf1UKAEe1ikMCWFtV2xCdsOIOIP+Lfdy3D2/5vnG2smf/ECCXkJvQk
         I+c2AC26eUKqEOpZ7uAD+rHH/UG4PSq5hezFGUp/OFz3LL+UpsZ1CMgWs04Diytgvi5K
         aHSfcAlpQqUFhxdNAQ2fbXjjMSS443BrTIFv0lbgB1Mjyy+b+4a6I1BW16fjppLsQ673
         9CV9CV0KeD9+sbA4c2IqXHeA1zwMXqZMdjHw0TsjucR2T9bSHb/yOohIz1ei5iqQoJgI
         TzBw==
X-Forwarded-Encrypted: i=1; AL+hErEY2GaBekYugyksMxWPbQ8Mh2iZu608VKZwfGLUotjXKcf8g9KDDaj3upAH7f43ibFw1btTyrEQWq3Wrus=@vger.kernel.org
X-Gm-Message-State: APuU4Z9fV50sct/aEU6bif9Huj3H3T6UR3+Q4SW+dw8cnmaySfyJQEjo
	0R2d+JScGS/XdEQuGdOnL9lWRpKtATfLMXTmbJ22arnor9pMrNHyihpV
X-Gm-Gg: AYBFou3vI/kWMpYGzbS5vLmioPeYQi6vGvOULhHV6MZ+T5fuOV/Rkpfei5lYJyZ7Eg0
	CliEoHnI/X/zk5FDQkf1Uc8Fd+o0l4ZNmu6eohKKLSJYRbe6w8oPtNxyQ13gdnWmUBm7csKxUu6
	76H9bm1PE93IzoSQTG/Dokr+MIv3oWeMqKSRD/8C3iecMT25bo0Ez2raaZi7DeqG+YTkIXj6vAV
	M5RPMpnosGJ2sb1+50C23wUmEED/vqrFHQ0lZwy/lCL76EHVeySkSgEL5tr7/esZlHaTSCjqxpb
	kBOwYvItcdUgqsYCVEv7sE2UhAUGE7TgOCMAyRzoUjjQZIqGdhKwcxFdMsx5osFH9R1wLYgRS5a
	H4VQiqSKqdysGF/j2lIfHfXrLQQZ60apYAm2GKzXafGa44VRdbnEMjxcRnYekxHYe6bXv3GKHJ6
	5Mbr8yiaOpas86MrgDOjqnBNVUjuxdHKY4uFR6JLXWZA5e+H337tf66yW7hjnELnTF4UdTvrSZP
	1z85JWxSmaoaV8rm7y0GtYnGGdxudCaFAMfCqupcDYgjf6I1la+MBtQv3W9Rwe13CbFm5vT6VhA
	kSG/4tHYKxX3y+VlXmjnQvY/mteK5RHSLo7RLs+q
X-Received: by 2002:a05:600c:3509:b0:4b4:262b:88a2 with SMTP id 5b1f17b1804b1-4bb559f3633mr229913355e9.1.1794864399079;
        Mon, 16 Nov 2026 13:26:39 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:26:38 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:17 +0000
Subject: [PATCH v2 01/16] dt-bindings: interrupt-controller: qcom,pdc:
 Document Halliday PDC
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
Message-Id: <20261116-halliday-dts-v2-1-2c92438c6c46@gmail.com>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
In-Reply-To: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
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
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, mfd@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
 linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-pm@vger.kernel.org, Stanislav Aleksandrov <lightofmysoul@gmail.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=910;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=TIEe9N/cyAzKgpuoZBtDZhrBfZnBIMsVZBId/jMf7sU=;
 b=dpF7p0w+OJpIxiGvX34+YlsXwN/di/jZgfYFaXfY2LGvx7anrS9naa9DX6XaW0R3KAm0CLz0p
 0yoxibSkrgQC5/lkQjgDmvTXyvnDrKaMbIZimtpZ/81OcVIj7o3EQjp
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Power Domain Controller on the Qualcomm Halliday SoC.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
index 8401d3b48e0f..cf20041e86c8 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
@@ -28,6 +28,7 @@ properties:
       - enum:
           - qcom,eliza-pdc
           - qcom,glymur-pdc
+          - qcom,halliday-pdc
           - qcom,hawi-pdc
           - qcom,kaanapali-pdc
           - qcom,kuno-pdc

-- 
2.55.0

