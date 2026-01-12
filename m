Received: from mail-ej1-f65.google.com (mail-ej1-f65.google.com [209.85.218.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398E935C19B
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 13:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768226003; cv=none; b=CcQVc5pNQWprmXTKFO/x7d3y/OlDDjKXzMIgJGSElRex/lQ+L+ynMVT3yEow8CgSUmKK8WIVmCIP1ZlKT4mQKmbPx5QoNlP+yGfk0NdMpExjBOdSgc0HmkpY6yDcsiMH91cbu8i1G2dzTx1nNWxY3vDc3WTpONclTgeV9Bz2gKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768226003; c=relaxed/simple;
	bh=zh3of1YDtgoe8pLqLNknTMRnkRoApxNn8uXmHT9Ljkc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SvD6sVd/iPVno8JxkvwJRXgy9cm9Fum94cjGJEFdoJnTksEt/Rqo7kaPe5RBD2nPzsVwtYmTl8uao4oEljwIWDYHwlBGrlknIQjHabcd6huUKhC645uUOGcQHLuNIiGRUHgKZFk9pCAjtRL6XVAspAjsPt1Lk3vMxfX0wVYAlGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=FZYi5v0Q; arc=none smtp.client-ip=209.85.218.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="FZYi5v0Q"
Received: by mail-ej1-f65.google.com with SMTP id a640c23a62f3a-b872de50c91so65935966b.2
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 05:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1768225999; x=1768830799; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Riko22R3LEFHoPXODAPQuN7cY7xnzdRvNV/1KcDSv4c=;
        b=FZYi5v0QHK7CLjQ4KJRVOKYeki3+Oy4moavTOxJPhlzpNM0MguroNhdIO62jhl/W84
         bKyk17RqL9gKoirR19TtrODdDGOL9z06TUo9sGILQgGri+bnzuXWNuogypkTPoudynu9
         ImrWqhpnvA42IMRGdbfmXO8vRdJyxpT80x0RUzuqJEro3twawBJ6wkXJx7cIVbnS2eIg
         zH4jJtuPfHTSL3dXNjysfnfG7MdztHemN4FHJYI2Kd24wArusdXJv5hW3B0YSuHyzM3L
         05mkFAOdCowhTuyu9rstE/EUip59pq7iK1kVbH4o28mMU4PeDwVMCkxT5q1Ikv/JtIB5
         2pNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768225999; x=1768830799;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Riko22R3LEFHoPXODAPQuN7cY7xnzdRvNV/1KcDSv4c=;
        b=Zx50hskusp6bucmKbCCL149H5QoYFQvxHDIAtgr9+fXjFAHMZy41FAo2moSsSzu8U0
         g/xfYBhwhoVxwhKP/S9dLT7iAZaT40Cs7UjNASL+50kiCxqrxxTKJX1P/uiPPTcoBYoz
         dQYwe0fpvJYDBSD0sPUf2zCE6rDMve7AKuqUkalMdktWmxrfhb+uP5yIXRKU4RLznGeN
         iwKgQozAdA+x3JiIYMvbJncwdk8E9K3k5XVXz4BY66kEiFp6rai8XamXOHt+LrXrU7Fd
         K3cM4+kx8S5cwl42cDSvGjXqgRm/tncSBBQWOiJBk+Y/+O8jxCda/KMtmLdJiLt8Zvky
         /Nsw==
X-Forwarded-Encrypted: i=1; AJvYcCUlA5kzxA0095q1VM3Ejs7lIHjHqAjkAdt2MMBCDcMwQ5bflhU5gRt+39ja8txyhQSNa5a6giHSEnBcBC0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyV+ZSZn347wbYOdE5U5pEgb8dB+48Y3dU+SpqmOCCHuQBYFhOa
	EQr4bYxU8YzrU+Slr4OimxfzKsuXKwAmXl5MFKks4gz8hcASnMdV/HdDXpIANEY8cvw=
X-Gm-Gg: AY/fxX6IM4nIBZgJxZFkPs3yK7NojW9WpapvjhOvlcTU/+3pwvBIMcAMtea3IMMyqGw
	xwxz2/v6tp+FYiQ3V3F3QM1lTZJ79jQpLKStF5NQpLzgevhNqcVH7WouCeI8aYtkKXDd9YY4z2F
	7yEB51o7hGge7t6Aqa4ZZLB976xJ7WCEth7nEFpFkJ6XThDoaNqVGrTWGAYLudfUOnFYOImyhS3
	N14pQ92f//Yn7RcjDShz63KZXUYpRdsnrGTDT2v9Jmq6mQFUSuKvZ3JFYcOfkuzFjXkI5xu8qJs
	h2rTqDvfz8EVtIbjJjkyRWKntSnrez5zWBvrDe87gP2QBhNOD4VePIdMeovOFMUfc/dMS2/ov78
	t/7qttDf9ZR4xP3Rm764hDDVpz/r4r+qBikfaCyibm96zluVxCh1GQeiRtgZxrMosb9Y0hqwR8l
	QkhP8MU6EFTZ9QgI65OqVBug5GpCA5Jrt+CfqPoqng7M9H3/gkreKOenseh87Op9uw
X-Google-Smtp-Source: AGHT+IHdJLxmu0+/UyOYC9vMKy7oBS2ps3RobFJH7GN6mmniuulIiVjJJaG/v4t7llHwrgOamXjL4A==
X-Received: by 2002:a17:907:6d0b:b0:b87:fc5:40bf with SMTP id a640c23a62f3a-b870fc61e5dmr388903366b.5.1768225999475;
        Mon, 12 Jan 2026 05:53:19 -0800 (PST)
Received: from [172.16.240.99] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8731f071e4sm25700466b.66.2026.01.12.05.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:53:18 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Mon, 12 Jan 2026 14:53:16 +0100
Subject: [PATCH v2 3/6] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy:
 document the Milos QMP UFS PHY
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-milos-ufs-v2-3-d3ce4f61f030@fairphone.com>
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
In-Reply-To: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
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
 Luca Weiss <luca.weiss@fairphone.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768225995; l=1204;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=zh3of1YDtgoe8pLqLNknTMRnkRoApxNn8uXmHT9Ljkc=;
 b=ab3LaAh0nqDakMPE7Y+uZxb7TiZnokZj/MjVglhe9gkUgHWQNgJhpTwAQV0kbZgOi7A7Kifjn
 B5zA13NSsnBCN3I5HDHb6fWcmf0WZDLqXXo1vlbop7PFojeA8ZII4xA
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the QMP UFS PHY on the Milos SoC.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index fba7b2549dde..0b59b21b024c 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -29,6 +29,7 @@ properties:
               - qcom,kaanapali-qmp-ufs-phy
           - const: qcom,sm8750-qmp-ufs-phy
       - enum:
+          - qcom,milos-qmp-ufs-phy
           - qcom,msm8996-qmp-ufs-phy
           - qcom,msm8998-qmp-ufs-phy
           - qcom,sa8775p-qmp-ufs-phy
@@ -98,6 +99,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,milos-qmp-ufs-phy
               - qcom,msm8998-qmp-ufs-phy
               - qcom,sa8775p-qmp-ufs-phy
               - qcom,sc7180-qmp-ufs-phy

-- 
2.52.0

