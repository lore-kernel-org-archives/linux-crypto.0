Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184454;
	b=luSnzv8iH6Yi7RBKyMLPvZHSKyBPgdtl7Dff7H0DNN3WfogFzRuKOdmTP0O9hgboQJ5T
	 gHwDUer0lwsX9gTg4nYVonqQdhlfFSOr0Du/XxdOFdgtWsJ6osIHK/OYdlskfJNmu+z1t
	 z3hm7L3AtDat/HQyYBFsbAMYhjfWSOwYXgrfzcU/ddVO/tFv/Rye9saAMUsoy9KLhhO9j
	 X38WDd106qOFp3AI9dW+TSEQcU+NMRXjCFsW4Xaq9lecAFiHENXA+4dvDNqDuOplMVGej
	 KnCL+yxBzKXSf0qfJWldPlYmBO4eqY1h605iYkKsxQrQe7T1sDmFZBy/gQMWilieJVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184454;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=s/ljkdQydKv0eJnuPEQK47y3qmQ4duXo8otCxl59TOE=;
	b=RbSy7TRTxj9toL0r5P8CFjwRGbw6q59U4BWn1pqxfLikRpMUxuBQCVDn3lhR89Kc/5xh
	 Dw+2Rk9xPvk5gFpSxzy/gerqxaFfb/n9CZf0Zo/eW7rIz5vQ9mzQDjp/wo7J9cf8uURBg
	 yUc6QmmmQuZk1rVxqUW2qd4oMt5ZqS+PDcD9REWrmJaskbvDf7nn0p5n5tgvOaEe2CrxO
	 N4nvQvDy+PboUjWWXKP3g1MXzFme5J74d4PtVx+0VBz1bLhmrsSLooL4jpNKYsvkR5y1k
	 KhiWHu2nczY9nGE7oGSpBcykq3LUbjuI5kuuDN54Qh7tmiEcx2GWE846W/074j+vlGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=umF6j5At;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D716082BD9
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 00:34:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50D716082BD9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=umF6j5At
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-49134c8509fso284708f8f.1
        for <linux-crypto@vger.kernel.org>; Sun, 08 Nov 2026 16:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184453; x=1794789253; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s/ljkdQydKv0eJnuPEQK47y3qmQ4duXo8otCxl59TOE=;
        b=umF6j5AttmWrzMlF/KQZyI0KXH1YwvPaczptCwrQT345yLijjcx6iSsqOlX5KCD1Mk
         81IVQcYSQByved1oLZtfvz31EEtFJl8JdhoQ65nRSPU0kQDnBOItbKbX1fUEejMPZy6p
         METpa5VGRkb7v9AxKCwn06Ti2a+76f2PAO1fYp6OK7f3YoHRXXgMtR6eIOyl0wZr1XR+
         Q+Q0b8evofiGdpmVDTQLjHcuU3ANrLntmTVs+p4/Be+4Iw0IjImFcnD8OEhWh+sz8qV3
         VCshHfU3qUyeCBVw7vIdWPRJVTwUI9OA/sBzhqc3Q3wO+TOkhOJYlKm5WwJwlbBly7NM
         zXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184453; x=1794789253;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s/ljkdQydKv0eJnuPEQK47y3qmQ4duXo8otCxl59TOE=;
        b=UnLChiqu0RvY4O+ToZHB07eUN0e6uzQ+VMFEewOy9dm37jZ3zXfwmOOIQ2C+vl98Dl
         8QbWmcIu9vugP3rrZYrzH+ZxOMAiyt3FVzT+pgmadV4dlG+MP6hl6yk4P/RyhcVdo8IA
         ECKnJUDZmirJ1L58tAim9qV54oNQWnRZu4bsbiosYad+AlOTM+1ZKdtlUM/+1YCPxPr3
         TLmuObqw6vtTN8M0nw56wej6s3HkDld4UlDxqEnY4oh8h9wt4YyzJyP79A4in7Ef0viv
         P0m8aBa+0jtBuHEKd6IHazImE0h/VA20pkb9q19aucOErWrba0DrAI2S4bCYqAHhuoJZ
         HB3A==
X-Forwarded-Encrypted: i=1; AL+hErFRxfgYwyDmYBNMCDVT2SwXb9Au5D1/8Gp+qnS8pM7ATNir1ZKmSNwdlKvGrkRqbmtoa4Bgmv1zb76euV4=@vger.kernel.org
X-Gm-Message-State: APuU4Z9WUzAjJB2du1Em4Z57XkYujq4gHsTHa6w3+NrXpCg6NN9SaWCd
	kR24y6o33Jc7L66edMr7E/JKfNuLxtZjGikTvltwBrV32wncT0zkc2xQ
X-Gm-Gg: AYBFou3AUdCmhxSnVZ9I9/XI8eHb7XwgK63dlQcXFkCcia0n3EgSoaTRz8wDnscKrh9
	3fx/CeBEi5voh1VmjUiT9Tu3QIvG3gPb0+HF8PIq/NfQ2tQSonzzG19zvqQqoD5yP+z6u73j36e
	EGz5sLSRC6k4qHs8EABHSSoX0DqxKhPjmmaGEUD5HenLzAuxfl5ryDC2B5+hNmfkGLZj7qofZDl
	kz6mNblxNBCD1InbCtmCY69wUQrD2jZgrnbrPeC9XTzCvoMMZqalB+SCv2msNwHNAhjlR+tSm3s
	Ww4+M8hhIjggZH9kI5wo6ssnB2kNrJCe0lUirjG3rmqm/3UdhUFLmi6XsXV1G+cYJnbLo0utODn
	Gbz6U0VUU2uWIyGuuOtL9uWhnFTnlRbGh+HLtmjneEmJnOyRtWdwwYOmMYFCy9ntgb11GSeOstN
	uGu539MFK5k+NIQc18GL7slC0gTG02JK8VoDNhRYFsWA5iPq9uvWHo3NMfkajDS08p70ooTUC9/
	ZdqnxGmfg+Bo+w871oE8lhNcD1DrFdMz/c8EbH59cfKsS02/3frO/gYspuKseSub03r+dHz/o7s
	QO10coTnIp6u2+pkPNWDF0j+dwbIBAINwKkkWPU0
X-Received: by 2002:a05:6000:40db:b0:48e:3d2:44b1 with SMTP id ffacd0b85a97d-49585ca3e5dmr5109174f8f.52.1794184452788;
        Sun, 08 Nov 2026 16:34:12 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:11 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:21 +0000
Subject: [PATCH 09/17] dt-bindings: ufs: qcom,sc7180-ufshc: Add Halliday
 UFS
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
Message-Id: <20261109-halliday-dts-v1-9-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=1028;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=e5+pG0dDXEqC2bp77Ez+oDydvwUzWtL2BPwcLeGQJvE=;
 b=iWkySt37dA02PFmmfguFJEKrCwxdhGzWk24XOJRJESzAH3T4aPp1n4WJJawTbnHxhzVp2Ej2x
 6zP4CwoB/ABAxTrRpUZjqAEi2nTiW6DG09fAo8ednu84TwNnmQyJB1n
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the UFS host controller on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
index 3c407426d697..5d1784baddd7 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
@@ -15,6 +15,7 @@ select:
     compatible:
       contains:
         enum:
+          - qcom,halliday-ufshc
           - qcom,milos-ufshc
           - qcom,msm8998-ufshc
           - qcom,qcs8300-ufshc
@@ -40,6 +41,7 @@ properties:
           - const: qcom,ufshc
       - items:
           - enum:
+              - qcom,halliday-ufshc
               - qcom,milos-ufshc
               - qcom,msm8998-ufshc
               - qcom,qcs8300-ufshc

-- 
2.55.0

