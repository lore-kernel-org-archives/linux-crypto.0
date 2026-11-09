Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184472;
	b=uFZEGRXYhmTUhzv1BTInHgRZOBp77XToehIyaqV79Hka7n8wGKQBj0KDSJ53Gp4BEs9h
	 EngyywhJDPZpZhokLOZNalAiwWwgVT9UOpBad7D1lrp+UUn0v/X5MQxA44oiGQTiG3cXz
	 qvlDWW/0oSzuEbf36Va63YwJnwhVy330BYhJAWbMXM0s6vpnWHWkexqtZLzWuzQH4Dicv
	 Mse4XlPBoQySq/0k/9A7r2z9QtMhbg3pU7EZAffKuFys8vVmr9htfyQAEaCVtrYZvCoNI
	 pqZr5Zo4lveWMvA4btWO+jJfk7BLoIZPlsTvxLrKPW1XsaIHyuIb13y6WyeHcK0ea9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184472;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=sqWf0ZqjfW7jYj0FTgNGieSVB4q6BkczPYaUBzocbio=;
	b=WTwhXfVeSwdJItaRmG5Pkp4qKXSp1MM35cxlmC58ysAYQm3a1Q8uZt8utUfmShoKggxh
	 JMjAczAxSOPccwU8z6SYFfYnO/cmceXyUIlVj+mq9Hnj7XBq1KcKbUn8pzX+CTdkLEBbZ
	 Twmodd5H4nEZIMAMmueCXskOxyJNazGQ+jBCW4xU8lMF86Dta6eW6LpZJnYOFEfcxv+ov
	 8u7llaarseejNWN0wgkYgtuYftY0xCNotkmE0c0/tpImli2zN+5pxn/gKuKAVNPhXmywN
	 hhnAvbIG3eCRtj0ygWs+fZ+U4v+QW2aKpsEqARrwdVrxAdXrPscgUKsum4HdZuf4rBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WxbEJWOi;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D728606D808
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 00:34:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D728606D808
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WxbEJWOi
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so3570825e9.2
        for <linux-crypto@vger.kernel.org>; Sun, 08 Nov 2026 16:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184471; x=1794789271; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sqWf0ZqjfW7jYj0FTgNGieSVB4q6BkczPYaUBzocbio=;
        b=WxbEJWOi9QdqpPLO6Ad59r7g0ryBxuqjlkvMlrQfNlNetGvjWt7UZRvYSw+EsMrTpW
         lC9Ie+ZhXXPAOXc/xUS/3xT7VZPYdyIrqbQ4f9+1R+vIuQl6Fyl9S79VIfv31Dbc/jGd
         vGp6btvqST0z/IyGK7MXpRl8Ji5Gqj0cFHFckWgLhahaHcURIkKvM/P6NzmrGrBItv3I
         3zj4CTFNQ6tD4YqUCDb2a3wuovRyO4zKtvVaIcNQHgt8RUQbgVx8yBYj/ZUGL8NsS9F6
         o/Nomd+IFGlBsQVBOxzy5yoHKZeSfZtvQwpc+6rScaPo/xpz5CxWsa8i3RZBbutcR8Iv
         R52A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184471; x=1794789271;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sqWf0ZqjfW7jYj0FTgNGieSVB4q6BkczPYaUBzocbio=;
        b=lPCU+PQZ2g4yzsk35Fim8KCQvsMLP8kOAaTqVkZM/TQxkn/n6uwZZmq2ESylj1M38p
         KRKHYzK21pZBoAo9xVksItWCF1Har2zJgheFd++1HUzbWFDnRu3pYJ4mHvuYAf37wnw1
         yvom2q7dyu4hfPyV3sKWm0A1WVuXmoYJsCYlNLJIM6mrLCZMmnAcx0Gge6WelP+6Jahd
         EkYcBD65cxKtPZj7KbkKtyzqrCUn8dvqRVBEWYWnWM5uPk7+qugZOpcXpMx/I+jxH2Vq
         rbYTQJB7yr8YSrZngXUBm2v6rkXgm+NGeSDCydCB/4m41UUHO4fzF1TgU1K2eo/h2wik
         8CSQ==
X-Forwarded-Encrypted: i=1; AL+hErFElKqI9agvh6wK5KXUmgsSpxd2kTkEhrtw0E5OyTpTUaf68zjWGen2doxBAkSLPDH5NJWSi+7Utf0QW0U=@vger.kernel.org
X-Gm-Message-State: APuU4Z9luNDgn9LNIUWVIgivrFRyDR8ssDaN7qUbBq9EF7D79gOASNSZ
	dRJRSSQsoB1gZfmd04VCCwjrMMnbNiVN57CQy6EtPdlcFAps46TIbT2M
X-Gm-Gg: AYBFou1RLgIsDaipAOD7IAwO61bnzm9B7s6M/hUj6S+tTyaIf/2WQOds+YGSXpTRlwH
	vH8zgxzfW3nQky7UEfIAG9PPkGGfeYogQvnkNkOZgaR9nbczJ9ARhYrT0fCMrexnZ5niSZNALt+
	L/NI/fj8XoVGMvCWVQkjrjWB4ZuO6Tgose/9JD6SUo5/rUANoSIqTY3NxGfDR6VmTLhWwbdfpdy
	gh1UHiNy9BJ92lilXbzSSvd8Kdcyb+M9GJYXyFKB8uFNzpOrwS4CPqmjGXGQK/s/GiFsSIfRPbU
	VgKjNY5uVDrZfOwJnoSi0VUqHWE2mk+eSWkWcukb1+CLepqDaBPkoX0gTshCi3W0NTHJhAC3WD5
	K83k0LSbY7CM22lYM58M6b052mSkF9A4og5VIEUDby2nQEne8yeM6f5b26d5MmXOSPgXJ+aW3Qx
	n0lsjB4+ykZvnBwMNJiI8YDhxw+yqq+K0uvrZxmGBAmnIcrlLX7N7rSbUq0x1O1pdF5o4WfO3Lc
	M5tFjn51M2aVzfi6kZXhEyXsUAPmYrEKIIQy85JYMIHBXavNA8cEO8lUGtA3E6HQQNahI5QlOJG
	+RdTy5SN++JzQbQEJU7wOhA8DXA/n8bjM38qZWk8
X-Received: by 2002:a05:600c:46d2:b0:4a1:df52:3e36 with SMTP id 5b1f17b1804b1-4b963c814b4mr45217895e9.27.1794184470772;
        Sun, 08 Nov 2026 16:34:30 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:29 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:24 +0000
Subject: [PATCH 12/17] dt-bindings: cpufreq: qcom-hw: Document Halliday
 CPUFREQ hardware
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
Message-Id: <20261109-halliday-dts-v1-12-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=1136;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=/5q7xJNdAtVYNP2eKqnOFRxkwGs69ZAxtJgwpCpPYPc=;
 b=gh19qIBvqo941uuBuTtSY86YfaNCAEdG9vJI0o/4tLOqHDCaja10/kLnOnTQrwdqkmy4TCdF6
 7e+ZDYLm+CcCb5BN2fAjGQTjhEqtQqzl3jdn43oLAWX5E1v6iUbyst4
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the CPUFREQ hardware (EPSS) on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml b/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml
index 98eb36bff172..d6040cd293f9 100644
--- a/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml
+++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml
@@ -36,6 +36,7 @@ properties:
         items:
           - enum:
               - qcom,eliza-cpufreq-epss
+              - qcom,halliday-cpufreq-epss
               - qcom,milos-cpufreq-epss
               - qcom,qcs8300-cpufreq-epss
               - qcom,qdu1000-cpufreq-epss
@@ -135,6 +136,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,halliday-cpufreq-epss
               - qcom,qcs615-cpufreq-hw
               - qcom,qdu1000-cpufreq-epss
               - qcom,sa8255p-cpufreq-epss

-- 
2.55.0

