Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578267;
	b=RzpkW16yC4XS61SDMXaxDNM1K3nYM1wUHPw/tA8ytMLFFdMxlfp2uYY0lMuAGOreNeyc
	 MEmtdTpMKe6u6nmPNt4stNFYsT66KF6OLkF+kpGUbpd6M+gcI7aG01mKBYpkKhwNdpM6W
	 lm119bEAKzFccmy9Yn+S16g1hVpasKJZz3vP7nI8HN1+Lhr1DWCGhVRqDGyLKVFIwpkVx
	 yrz/ypGtqeqyvL0Uub6sRxznzA77wJCEtKIg7g5gkX2Wyw0OsMQm5l2zXi83tIgpKA+oI
	 h2OOtpkjGccXPVejRk8zs6MWoIBmF8GDZ8GirmHR31RJd+MustQ2c4gS9HhAb3ZgmcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578267;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=+ZKraDRr1i3pFiLzoYIEWaHhHBRYyhj/gKsvyx4GUpo=;
	b=wVoLDv0oGJWJG95MY74j9hnSJfVViiyedDJXSW5UhB6FqUMRl3tudGyAsiVl+g+c9Bku
	 XpnX2s1a91rThbXnSOW7IKPpo4QwtxMVyFGrfCwKhf+mGRCuW2WLwj0TuvJE9oyxTzZGI
	 eG3BdaKME76dzae+GYsFN+U9AxTc5fwwk/ry6sdIRs6Y6UVadGSSxkmkN/qvor/BGJW+r
	 MNYyHKvLaI43JPbKq4rEwNwVRFjxCsJDuE7YMTsKjuDQvQafp6ce8rMJEpvoXVzpVVvkR
	 M2xv89wbpsrT2TvUM3ykUGYNbEav7QJUrMEawfNovIK6MDZEGEVfgIEqCLTz1gCiWPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SufE44Nf;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB09606A326
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 03:44:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCB09606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SufE44Nf
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4b467581b98so50805505e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 19:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578265; x=1796183065; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ZKraDRr1i3pFiLzoYIEWaHhHBRYyhj/gKsvyx4GUpo=;
        b=SufE44Nf0iNE9uoja8l5aVwkLELQGBnnQSJnkwjjhyh+2xNjpXzsAoozPYmtygloR8
         XCTUXFjT3+t29S/3sDK7LcWZlA16n33y9wijZwHX6Ju80HJAddDGn4X7BJuoxGfZyLYj
         hkVfLXm4ntm+nwjdWfyzsw22laugJbD+VlTiUS51WFqjYW+ZG6kVM4gFIN/QsaW+Y1fC
         aAU1Ie+c77crPXv7rlxquXOEpdq5iUcbk9Bw/fQXVPCbH8V6mcT5VSFCrAHpkFwLMwqW
         r+ANRdiqb4fabO9ULg0rSB9NuToAJUGV4l4allUCaSpFyElERTRBJNdlXqDf8UMAlmtw
         OvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578265; x=1796183065;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+ZKraDRr1i3pFiLzoYIEWaHhHBRYyhj/gKsvyx4GUpo=;
        b=yllxqX4iXKojtJqqmoMnLqGhqDjRft/yRjvMMxMtS4UltwSnRwpfUb5dQgIuARdJWh
         6LPVzOLbr9OzBI9pbAJ5Dx1CSyzrLSrDF2RaxKGOdQ2/yvelkCVX/G7zLcMwcl6DFQQE
         Rzmu7vH+rhjL+6HysbG3hcarlETLaiCyLZVSGoZPj2gi2iUHsuCtqI65yShT+xtbDJJB
         0d35L8PJSEkERwn5Uz38UdvK9v+CZtLBSizFAvus8O5v6caqAA62sxtAMqzPzZdk8ssi
         GK+yOmB0GhBrG7cUeKoFR6iwvqENYdaP/hBCmueg26ZiahTBYK4cioKEPG23ssHTt8mE
         xCQQ==
X-Forwarded-Encrypted: i=1; AL+hErG4a55NMfwHPOVSG2y5x1tkYQxEPLhUzF15KbP95ktlYlEb8REsgfiV0P4BcL4r3FIGKBR8Lf0fgtYS0xY=@vger.kernel.org
X-Gm-Message-State: APuU4Z8Qkg/0JyBhnePcmt5rtXbXLnBRBigf66at939lqp6N165l2aAR
	9y+Df7UDfGnmCeEfsFyRdDnCQ9x8XyYHTNTWpOhhhOovO9vGhl5Oqp4g
X-Gm-Gg: AZFdTZcgBVdZaUDIl3Aio3DWr2OuLkZFd2jTwsVJdBGM/YDmZcAOadXaPzXlPNL7aVx
	8vkPa9YyzX8Hwsw4CJVJNgg2h9n5Ww6q1wZar7WdnYtCKJpDsDIB87+vcgdJJ2Oz42Rii5bFwVZ
	biZ3vfZH7a0atvswGyIjy5XzqDjl5XVlkEDzwc53jQ0i7KLbSvAq/KH4bRsHAYUicfHD4Z0dz5T
	3nD/dcZHyapZ6bmj8/PcvZCy3+fMcNrqojXpoFg5tJQS4qEfC6TqWnvLTGEjtenQWGC7NCKhK1V
	Ijg26/3I/Dre0a8dsmXcw5i2vpADqFFnLJDaDMWTtmk7+fnY+rMmfggIp0cHx3OZjD/J3RifAm4
	QK5Ui8o1RCRwvfb3gpX/JPGrqfxhs3Wa52KlzM5+wJxkwFnBU+ENkBkXPVe/5lNp6EczfEawHDP
	JjDFK0JyAgnbyMcOXFj+EDPOaAQmQ9d9HfBczoqe5sLnVjUEq+dc8jMg16ftKfUeXSWy494b1D1
	uwWWC5PQ+h6hhKzNGX9SwmOFydhxzxJeR71lg+D0YiUAimweKUxg16PrlBiRshf7RnNaokgWz72
	xmNiZnoAzqueeTo9RjL/UX5R2E2n/8yAdrcVN0s=
X-Received: by 2002:a05:600c:670b:b0:4a6:30c3:1114 with SMTP id 5b1f17b1804b1-4bb88922df3mr314413945e9.12.1795578265228;
        Tue, 24 Nov 2026 19:44:25 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:44:24 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:43:06 +0000
Subject: [PATCH v3 10/14] dt-bindings: firmware: qcom,scm: Document
 Halliday SCM
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
Message-Id: <20261125-halliday-dts-v3-10-5c8311c0b70b@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=1106;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=OQO+LwEeY64jVYcmV4r5bBUUpcSQt6/n4JPVT4Z/sxw=;
 b=ASSSZ1iPRbCJcDXI+svsrzgQJoNbt/i5IYWaxMLqGZRF5nHWw5kJhARXjldkVDjeYGCb2JyQL
 2OZ0LHRj/DeD6xQR3UFBtL7exxUKJQpjnA5HrXZmN3rAlw9HlvDVkc9
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the SCM on the Qualcomm Halliday SoC.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/firmware/qcom,scm.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/firmware/qcom,scm.yaml b/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
index 40a267c54b00..fb3da66443ed 100644
--- a/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
+++ b/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
@@ -25,6 +25,7 @@ properties:
           - qcom,scm-apq8084
           - qcom,scm-eliza
           - qcom,scm-glymur
+          - qcom,scm-halliday
           - qcom,scm-hawi
           - qcom,scm-ipq4019
           - qcom,scm-ipq5018
@@ -225,6 +226,7 @@ allOf:
             contains:
               enum:
                 - qcom,scm-eliza
+                - qcom,scm-halliday
                 - qcom,scm-hawi
                 - qcom,scm-kaanapali
                 - qcom,scm-maili

-- 
2.55.0

