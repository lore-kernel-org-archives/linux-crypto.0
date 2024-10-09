Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB391A01C6;
	Wed,  9 Oct 2024 12:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728478316; cv=none; b=EJLkbJUPLNsWPDVCs4XpqBneXi8DInADbtxrk/0dplV1UKvP/0LAZHPW5L5G6UwrEXCltgpDIDLr12l+qpKRC37YBGjuSw8WJZnm5Z0PZJfyDd9FDe8Ijnq6PwmjobpEMYxiZTuvtAbQ87xKuL2wW3RWT+y5y0fKSgFXa+9/y1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728478316; c=relaxed/simple;
	bh=hy/UVlyi6rxF48X/G1Kq4R0+HByVVk5EECGXWzpMrG8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=o/04WMFowMX+VC9J/SA0tBNKKD591oaGYlbpBFFHESEm/7VdB7hoM9xrBQnXZn3l0YiX/6AfhkLA5ukeKzRbdU1ZOH9VIZnl8Mcs1ftZJBvTsUyRBCiOxQ/ljVAEU5i9UW59sgQXd6zGkqOUkbBGXn3pmbkMUHHujCBVnemYzJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VvUzAxBT; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VvUzAxBT"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-71e10ae746aso1720913b3a.2;
        Wed, 09 Oct 2024 05:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728478314; x=1729083114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wCH1SCXKVWPdC0SJl7GJabRXEfjMw/vXoAmrAv75uc8=;
        b=VvUzAxBTW/PLPIahAMrbEhDOlSuDdTwjkkMSvuobOFPLT4nOUSeOPuURb1SjfVuHzY
         42gz354lxT966V1JlMQYW4cD2yV5UT2tY/XPPGU+BihxRGpdGJFsoKiMrAZxMzaxY8Nj
         MO/Auh9IUZUHqb3QCDjuz9+WeiviKYrZOybBPlOtcvQd34q+xys1+86PdhNViXIEOEQs
         bDXmQsO2tnNTRouP4YT2AJyYvOQgpPERPRp6N389mN2B6TMPs7Vwca/VIdCMtSCgQ9J7
         y/MbzAj/vYDg+JYe+JazZT+/Im0Px2SGA+l+DOWfxxDRifL95w2WlWkVCKdg1BnlxlAw
         fuWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728478314; x=1729083114;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wCH1SCXKVWPdC0SJl7GJabRXEfjMw/vXoAmrAv75uc8=;
        b=DGLWvGuf+pV3plK45vWTY61FU4mIE4NPiOnj03GTY189TGPTD6nKMyFGYZOx7puw1d
         V/I1nmF0F9fzAh49xKIJiKpK9hGx/iWv+VKhHQVpZBXpT3vfV0cOsfSViBsWelBMppXE
         OrVX7gFfKgA6kOSx6MwRJIEKe/1lljWoJ1PLSIowmALnjlVXYUnZJ0bON3s4AZPpYVAU
         eaT0Ynmd7xGDs9LSKZwFrKngYrYDAwGIXB9lD/v1VacuXqWV+3fQ91zzca/dqIpI2o0y
         JSXfDAnT9H13VMehFMAl2NrUjDkuI5vBBCXQtRocd0FDypdjeoQYZm9xYDO3VQk5mLYa
         cqtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqbuwhVdT8RZzt9Jinl6KYn58treIbEYj0H1vofwsFzSNEn8yUvlYI9+j9hsrP4/Wk9mC52mKbLGjteT8p@vger.kernel.org, AJvYcCXicfGSjbFzpAcZRSWcIj+JUPWngVcU9nj88N87u9ausfrYHS4iVhWg6HTrEtrPZLz+YeYxFjEHtWWj@vger.kernel.org
X-Gm-Message-State: AOJu0Ywok3LgakpV64p0+l9rjYOhel/5aVvmB3qDUBuvVqkxI8IPGmVf
	9YI13FGwZURadUOUCaNBv6gP7evB9MvDPCtJkPIaRlvk/06KL8uJ
X-Google-Smtp-Source: AGHT+IHvl+cp2IznZl4CcbOGdM7qvrvOgDNFcCltcnUcAP/w36jv6sBmSH8iV6Jx/WS3FKJlnocmgQ==
X-Received: by 2002:a05:6a00:3cd3:b0:71d:fb83:6301 with SMTP id d2e1a72fcca58-71e1db878d0mr3346565b3a.16.1728478314112;
        Wed, 09 Oct 2024 05:51:54 -0700 (PDT)
Received: from fabio-Precision-3551.. ([2804:14c:485:4b61:9940:fb1e:b49f:c49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d7d2f3sm7665905b3a.201.2024.10.09.05.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 05:51:53 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: herbert@gondor.apana.org.au
Cc: olivia@selenic.com,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	Fabio Estevam <festevam@denx.de>
Subject: [PATCH] dt-bindings: imx-rng: Allow passing only "fsl,imx31-rnga"
Date: Wed,  9 Oct 2024 09:51:44 -0300
Message-Id: <20241009125144.560941-1-festevam@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fabio Estevam <festevam@denx.de>

On imx31.dtsi the rng compatible string contains "fsl,imx31-rnga" only.

Adjust the binding to accept passing "fsl,imx31-rnga" only.

This fixes the following dt-schema warning:

imx31-lite.dtb: rng@53fb0000: compatible: 'oneOf' conditional failed, one must be fixed:
	['fsl,imx31-rnga'] is too short
	'fsl,imx21-rnga' was expected
	'fsl,imx25-rngb' was expected
	'fsl,imx31-rnga' is not one of ['fsl,imx6sl-rngb', 'fsl,imx6sll-rngb', 'fsl,imx6ull-rngb']
	'fsl,imx35-rngc' was expected

Signed-off-by: Fabio Estevam <festevam@denx.de>
---
 Documentation/devicetree/bindings/rng/imx-rng.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/imx-rng.yaml b/Documentation/devicetree/bindings/rng/imx-rng.yaml
index 07f6ff89bcc1..252fa9a41abe 100644
--- a/Documentation/devicetree/bindings/rng/imx-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/imx-rng.yaml
@@ -14,8 +14,8 @@ properties:
     oneOf:
       - const: fsl,imx21-rnga
       - const: fsl,imx25-rngb
+      - const: fsl,imx31-rnga
       - items:
-          - const: fsl,imx31-rnga
           - const: fsl,imx21-rnga
       - items:
           - enum:
-- 
2.34.1

