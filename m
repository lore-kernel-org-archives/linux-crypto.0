Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725BC292B44
	for <linux-crypto@vger.kernel.org>; Wed,  7 Jan 2026 08:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767773197; cv=none; b=DtTa4VlEELAgUqZsTyiz3fTFPvNY0cKFvDwH0NHvDS2DrLF9qCmcgKc1nIS44o6zEqg3IOuGGqLlTvuw0awrj7iNIp30029IXJxhddIWQcwOO/dseuGd7SPbK6jDEtHOsho9K6AyCGs9QgPrkjhCvWiYEhfDM4JWZ33z9TJzdFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767773197; c=relaxed/simple;
	bh=0ExZVYfM/y4rcjDL5laO5mxUp+YApKspdR42MpTi6T0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ubvgifPIYWKNHTQiXvLBQjvPsEUmH313MI/D5c3IuZMGlk7Xmjc7+fnuJmHGH3oH2MxEvq7tcSENi7AZxmu3PBiTIlcT2p1QAdTzDWHXy1LWdRmaEi9OH/dHXJp4Ar40YJzgnEWUw9AXcc5xR9QsIsO/2g898MhM/H1Xc0Dw75E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=JFD6WeeV; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="JFD6WeeV"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64b9b0b4d5dso3654701a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 07 Jan 2026 00:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1767773193; x=1768377993; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/i8ATthAaWuqmGUIVSIUdUu3CIf2MrTEFPyEW8I+YrY=;
        b=JFD6WeeVsFMBOGz7dNWZffHEu9YeEdCbhr8+r+9/XMya77+zQxQJPftHbue7TRHe3T
         2A2UEkbV0aCs76MspJywpM2hmQKRFs4ECoCB/YGTMZ8gd/5GR5+h9vU+blUgnz9ZO+qe
         /W9zqCTKSnbS4VhMCdePv3kx5tz/den15GnzKfZaCw7dchw8q3GcBAPXGc2BZmyaQ69g
         cvZuQzR6XNI4ITKLNI9aXjoGj7yFuj1qfb5MH2TYt14z7c5RYTpM0+m7yzwoPvPa+BBa
         lHuLTYjowkCckedrFJEobiUp9lD9Z7FvMvZlU5KmrH+MxXCdKd5O+JygiwU14kXyIG6M
         WH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767773193; x=1768377993;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/i8ATthAaWuqmGUIVSIUdUu3CIf2MrTEFPyEW8I+YrY=;
        b=edqYSu9Dh06yxoBaDtrtut+dxEiRmlZ7Q4qMdOmtDeTeFmMMgwIALCnPAbiryRpM9G
         jjz3QGfsnAkeyaZ8wIjKVN3OE1Hw01HQmYgkkw41R+QC5gVZD/njD6S9kCvEMD9Okamb
         wCvkS/KLdaFufjVy+Lzrg2dY8xvva1Kk+EoT0UVByAc30eLIPLZQQRugfGWx9QOH6vd7
         s/AuSiy8AaG9KqIxOBa61Ci8cwzFGhx9PHsIaWfZhfM3mOoMVqrfQU6uM4zD5Me+Ww6O
         LPmgXwOyPcKALU8gsuY+oYuGTiUVbcJ/sRhQ11L99DAHwbX8FcLmL/xlPst8+76w+4EW
         F5iQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/2tylKpeiTEZYSXhedykpi6i3jHdSDbBbC3JEEgicXoH0n3rcOxoiSUt1vt8YGLhsVWePvV2VbjQj7FA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvktJomaFF7t9vtrYgnc7/St2vRlBE51Qqm3FNBfyG4HWpKPAZ
	ZOPJXDzukYwLHqV1dsEc9iqmEkvb/+NQQCH2R1q3rfedZuFdrKZgKDWwT4l1NOufGno=
X-Gm-Gg: AY/fxX5ciTjrGONzv8Z86qg4bTt6XwDAHBuGPEajDUB+cSC8rdd5ic08mUUZUiUa8gM
	Oo0SbQnasxURqm5dbLif25DJ+RGDKyC2H8AE6xD4OdDvTy+xDyuplVXs/hsyNpKaerhlhPh3SjM
	2ol0lfYNNProBwr1m0TtXDhrFfWNLcCfnQelptd6j7BeI/gdrSaUdww71dvzD6fnFhkfY+QfnB6
	QjkXho9k35O00+fUIPn5PrmkUOqD6T5YJKxJN5RAPNB6Zop2hlC+M4Kz9eeMJB1oJk7d/5loTYB
	hgHij4S/4nZvAUtCmVtYSpckWzyFTRSIaksynN0bPF2q14mklLrVm32buRt4EYO7ZRVWig3CkH0
	2Mt5QYnbQuej1znoToYQ8sJbHBKJynznqxkxWO49JYm6GDsFW9pwbxKPLUuQsHkV84stA6LqfUY
	jd8ir4IeNuFHo85ssK2Y3OLfKoIw==
X-Google-Smtp-Source: AGHT+IHJ+kf1Owv26cSF28vuEM1MMU6N6BChtOdWOK1Y0tMkxyy7by9CzZtm/qgGX2Td8KERFqr5yw==
X-Received: by 2002:a05:6402:2554:b0:64b:946a:4a3a with SMTP id 4fb4d7f45d1cf-65097e75079mr1338292a12.31.1767773193114;
        Wed, 07 Jan 2026 00:06:33 -0800 (PST)
Received: from [192.168.224.78] ([213.208.157.247])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf6d5absm3941299a12.33.2026.01.07.00.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 00:06:32 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 07 Jan 2026 09:05:56 +0100
Subject: [PATCH 6/6] arm64: dts: qcom: milos-fairphone-fp6: Enable UFS
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260107-milos-ufs-v1-6-6982ab20d0ac@fairphone.com>
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
In-Reply-To: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, 
 Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1767773155; l=971;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=0ExZVYfM/y4rcjDL5laO5mxUp+YApKspdR42MpTi6T0=;
 b=OuUeeB9WBtMh0NzBeD2CtxzVjBzIAGe/EJcU8G/bdiV/SxKNG4rjbhcWGJctZTKikNOCzM2jj
 leav4MG9O16CTfjnQYITZkPwM5W6n1oQkcroJQw5KKq7O3xx2gAleXB
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Configure and enable the nodes for UFS, so that we can access the
internal storage.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts b/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
index 3a7f2f2b3a59..7629ceddde2a 100644
--- a/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
+++ b/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
@@ -819,6 +819,24 @@ &uart5 {
 	status = "okay";
 };
 
+&ufs_mem_hc {
+	reset-gpios = <&tlmm 167 GPIO_ACTIVE_LOW>;
+
+	vcc-supply = <&vreg_l12b>;
+	vcc-max-microamp = <800000>;
+	vccq-supply = <&vreg_l5f>;
+	vccq-max-microamp = <750000>;
+
+	status = "okay";
+};
+
+&ufs_mem_phy {
+	vdda-phy-supply = <&vreg_l2b>;
+	vdda-pll-supply = <&vreg_l4b>;
+
+	status = "okay";
+};
+
 &usb_1 {
 	dr_mode = "otg";
 

-- 
2.52.0

