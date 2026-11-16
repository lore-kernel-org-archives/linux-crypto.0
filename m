Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864414;
	b=YwrNfW2fX6L1PC/oq0EbrgHB+kQfJwTXhMKRZpbzvWPNRZmkAkU5WR9ttiIxUTRqM5zx
	 09XzOn3Fzb9rayJCaa9CvhUWJ9EyQ52p8W5uCLur0w5lIRpwEEjMlUYCvThFkCiR8LPI3
	 0//NwxykclFOGgljgoiCPHltOttLiSdEMajvfsRVzHmPWWsoKFavxhTZ8Y+Jiu1T4tKQ5
	 DyzOyrwPpJEYPYtBMICKGe3Rl/d/pniuSeP7ED6QT5cY/MmdQJSpf0zlI648CM4GLX2D7
	 2QwKXezAaMOm6THvS95CFYBb0WQtn5L1PVW3OM3CAvTeWQ+Q/LDh9rNSMXpHhhcu/iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864414;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=vT2VNwBxc63eyIezByShTBVkpV/95J6JPEp1UHJT0Ow=;
	b=v8P79J6zP0QMhtObnGa+pv2vuRAw3aIvaGvY8Y8pjhP5DAXtikANmIrYNRsoZa5nX/md
	 YGzNTfTTGtj6wzcNlDpg0knxhJcIajM1nHSYcHCP7WlmdpZ424KVDLJDv36En8R4MCMZh
	 +eDbCkLdgxnzDiKk0D/tQj7/sTqkQ/mg3iImY78c5EnOxiJHuPOIJDFoW+A+rV13MSDLd
	 A3HWrcbbtTeu4BDTa4obgovPomotf5yGbW/cxZFbVQiQe655fs2lGwh+ZQ3wgxTu7m9Lg
	 CxwHoNaPT/8PtwumKaWqBvBv/4vvz1KIpwYljhw2zFzYgfBce17kr6d6a0CJgZCt0bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MAURpxwo;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0398606A32A
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 21:26:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0398606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MAURpxwo
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso25500405e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 13:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864412; x=1795469212; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vT2VNwBxc63eyIezByShTBVkpV/95J6JPEp1UHJT0Ow=;
        b=MAURpxwoicsksSVnc2WAsPB6JHUpT01pe/omkWv1cyD9LfvrkdfTpz9XI4PTsY+lD4
         SGrVtbMkILUcB8UlVxbff+5OGS2lWyRPg4+99wfZZJ3kK751LFxY/m8LTjr6oiMVus8k
         NLNpqxitTryKXQIbIcsKSMHDOxKylCzOFabOSB6t/1IlelEkuKnAU8DjjPvXU/qZDKLp
         LUS0foLTPneGc0r/9RGpT435PfWh/Tw1+g5u3NiaPw6KH3UroKGAVTBs+bDKLGIwpZ8n
         3wkffWoIIDLNuNqC9dnlPrAPuX1jUL9NxQr36U7VkPrRC2O736zzBd6z1/JXDHPc7i5T
         PENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864412; x=1795469212;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vT2VNwBxc63eyIezByShTBVkpV/95J6JPEp1UHJT0Ow=;
        b=Ro9n3xlJ4UQdmPednZ42jtFXp5PfVDqUQfL2tAIeQGsd+axKETGvavmDQsPXArIxUi
         7LatnEFRXpxKhW3dKpNErLWGCKSm60GjAhdnyAiSyC4ZASf1ESe8sXnhPoUWFTiIUUnR
         2neQfSdkcf7FxW2U6Q6n0Sm9/x3grFxfyf4dC0KVM0uiMzMq8pJUVtDniLVlxm82nL3P
         W2fWfLIL0r1FeLbvfSk8adEYdkxdgXjVEemrc3LA3Bpo/u6RKGtxwrlEraqV4DJH9fz1
         SMPW7S65gRgk+MxP6PJvO74+Fo9Ho5yMrT+1UPq8U2V9pgbhyibB5X7ytpXjNZpM1Qnn
         j8cg==
X-Forwarded-Encrypted: i=1; AL+hErFDsb4ETsx1yiZKSCjmjykE8Dxuq43ns6l6l9a8HAI3GCHIZC6d6DeQnhdxdokWEm+llMxkUl/s7Gg9vE4=@vger.kernel.org
X-Gm-Message-State: APuU4Z+2l7TfJFREyUqkbM3Bfw7bPeAc9bnexHECxPWm44F2SZ1xP9tZ
	focf2jgOOKQODgTs6M4umWSytk2lKmqEJdE3HRYQdoc3OSl919NCYFXY
X-Gm-Gg: AYBFou15b6JoJ/sUozSVwe5aaioW6IiNDXSk5RzAhpi9az75uNRpdDxBZgjHZYg1PUv
	edig/0cXHTDEgG9Owx+VeYbtq3Zil6O6AsaBV81Abm87Vpsro5zXqCQtG0BgZ3nBMA39uiJa0Hu
	LdddiS3LQsrE3+7V8rvp1DORIS799nqDkANfBqmo3I85UiGPjv03jSAZ4uu0ufKcqgFFkOJzIXY
	4joFAvV21s4DX2VVgt3GqA7q9GluikcuISy/bR8HG4meZEV2rLPlabCaxVmOKI6tyXGjUwYEMGv
	XHTDgMxDxRBn65Q8KvEFIpKIVChu3X6vtG5NsOB3fLltwjAsffOvG0xB2NjVhERaTOzjYepUrs4
	XKwfqdA/I7iIrcm7+pZ8TOX9P7OXvMymlcURwXHcE/efPCX4ybWxobaP3A0E3hf32s5jZb9eHF8
	A+pk0FxvuHQwMTAKUgrx119g/9K/52ypxiF3A/47zjt/zmJNRLu4ulzj4zW9MX+17SYmoOilBHG
	zuIKWMZUyL4GGwnALmvC4NIuhulKquzszSb5pxu29QK29BbXq09GmH6KfnauX6aTvI/aqM+unDO
	2QbMHtPXcMdiGhB3qdaZObmV/1Yyt5Nbdv2HMcOU
X-Received: by 2002:a05:600c:3d92:b0:4ba:e7:ef3d with SMTP id 5b1f17b1804b1-4bb559f7044mr243891145e9.1.1794864412296;
        Mon, 16 Nov 2026 13:26:52 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:26:51 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:19 +0000
Subject: [PATCH v2 03/16] dt-bindings: mfd: qcom,tcsr: Add Halliday TCSR
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
Message-Id: <20261116-halliday-dts-v2-3-2c92438c6c46@gmail.com>
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
 linux-pm@vger.kernel.org, Stanislav Aleksandrov <lightofmysoul@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=720;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=sz0jgm6yJ2qfmdfMMgsqR7Wg9ExS4UZymLewfvVCvH0=;
 b=FqcgSljUbrxAce/Wb8/tWQg7D8BxyY05VfRoM3lIlKWOtWcZxkvJ+EYJdvTvvxol8FPPRApKu
 mw5+dUw4O8RDXBA5aD2L3Fg9fYj7OF5FtJNOsGNYBuFx4Z8h2/2ns31
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the TCSR block on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml b/Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml
index a021e4dea486..e8a681b5e6ad 100644
--- a/Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml
+++ b/Documentation/devicetree/bindings/mfd/qcom,tcsr.yaml
@@ -17,6 +17,7 @@ properties:
   compatible:
     items:
       - enum:
+          - qcom,halliday-tcsr
           - qcom,hawi-tcsr
           - qcom,maili-tcsr
           - qcom,msm8976-tcsr

-- 
2.55.0

