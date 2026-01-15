Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B538837C0F8
	for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 11:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768477320; cv=none; b=orFII5xrqX121+o8B0khEfVgCvis5JgRZEvWSqAu4PhZCEDYvSFUa72B5nXUP8h8KItY9GmzAs77EvWwrxj2i77Kuq4/8L7gQjf+G848X8a68yWAvfMzw5cww1DxQMZK+X2DjpJmvdsbq4bGAXUWlof0xQAMImFeiiEh+1tWjc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768477320; c=relaxed/simple;
	bh=mkQUI++SFEZY6715sy/bRzpJpUAliolL1r9lnHRs51k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpQ57DQThQVYfcBsrBwgmcxrCn4e5vmVFqLWGraxUq0FY0E8lamb5Fgkm1kiDqzD2rZE3nbk982+qm/vXUMwZK++NgOShc5V/DwHWXZeduVYfM/V6+isunEmx0+xspYNF2Wjjktq56KAlXZn1ODpSMcJ0CbzA10r1qhbqIIDgMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=l53qBHHO; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="l53qBHHO"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-12331482b8fso2545542c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 03:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1768477318; x=1769082118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zmhD7xqaP3tJ0Ge3gQd2f9t6bDUERo+PNGIof7/k4qE=;
        b=l53qBHHOC3NN4gnjGmjzOZAahtk/NF+6fvAt9wqb9Im8E7JMc1M/45s2CqXUlB4W0a
         uuZHwx4eFrwNmU2bh3yp7Eoqb2WQitklVmlOsuVApYFjbE5nlv2cINFaj7P3hSAHunTe
         pxT/zsrKT3jXCVb542lNbKos3OrWTtwoQdJiYrKU1WflD0OQ1m8m/renMuVafFd28Gqr
         rFCo2UZhdRHYm+CMV1XgbKCZ7bJhNoY4ZNLDTqzC7wzp28ixZ0q/WqsPxCq8rlwFUG0k
         0Z/Wl4MKmwhFIkRPobQHpEa7OLi5f2q0uVYnp7z22N78r0M+hg8tJi9X5eKpxq2Z64yw
         mk9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768477318; x=1769082118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zmhD7xqaP3tJ0Ge3gQd2f9t6bDUERo+PNGIof7/k4qE=;
        b=lBvlH3HBO9h0sCVRHwb3+WJmaEzVEqKY3CS1qscnDwhHA6iein5rYNMH5WYYNLYAIj
         yZ1U9vzt9Bs86MdV6aSkiFPDwo1TyAAb7jewfp/CqG12NM4rs3vD/TcNGTNga2xmByMk
         7fVE8VYQhL4TDu9n+ITTu4Edth9x1wIWcQtAeZmCVHkJJzaSHh7tOiwpgH61Gl5rNHK2
         HcpBeQKLCKqPMYtPjLd5a0CpbVJlRszIiBIGWoseMPq3dpdDxaQ77egAhpR1DzT0pVyk
         X+uJkgRYCDSrz5yit18LjIViUX8hgBTTZ40UG7AZ0QiIuOmCMvgHZFDqm8znEbk3TC86
         JG5A==
X-Forwarded-Encrypted: i=1; AJvYcCVPiu1yXyB7j7apNqEQ7vjeHmRKS+ihbg07ZPjacVB/fefEgD8vg2b07rlVL6JVgbxfDlMDC0DOxZvPUvg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKtzX63r3zdCcS9jLpWQLjBfs9pglg6hOpCmKF8jib/t7fyHer
	WFqP+NXGqqKvo+VwW8lOUm/jSRixSceUx7fHdwaPJOjf/pVqBNb7VEKJE/PCjpSn7Io=
X-Gm-Gg: AY/fxX4wdlNQ8VoVHECowEqL8HryDN1RmTtbbk6nmi4HTGyWe6jl/cOAqwdwnQFCoay
	gex6w4w83A4TMkSfPoQk2XIplaaByQvar7hMuq7RyXcz/P45ObwS+qmGv8BehGe49xbKBKeZNH3
	TIv9cOrsVpNGhOqfTVtfmgvE4/xyy04BMR7uTdvBwNJjA0cIb1zOTEqre+LOakRSGqVvCEI07oy
	bGESxzRtrVfelGhX0H1Jafsudyfku96gsgchTbJc608DjDCs4nmBMbaZ69SYeuGOUaDU0zk8Kcx
	ZLss8GawDCXELHgXfnNRx/yFjcBCGT9jE3s6UdLmyZPyMVjOe6iEeeAP+wZ0HBdx2JvlXaBDGKH
	j5vSlNKoczwRyQX7YeA3DLPwjc791AuCbvg5K17A5t+D0814nQZPtmlmvuyWq5Me4hxi02HgD4+
	2NFd/8TcG166d4E/RJPbwt5rDUvKc3zvKW3wKJ6LHUKeulf4J2wBkTnZPzy584o/8jM1fSmWye4
	RCvwAng
X-Received: by 2002:a05:7022:6184:b0:11d:e2a3:2070 with SMTP id a92af1059eb24-1233778b5f3mr6944456c88.44.1768477317748;
        Thu, 15 Jan 2026 03:41:57 -0800 (PST)
Received: from fedora (dh207-14-52.xnet.hr. [88.207.14.52])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-123370a051esm4875347c88.15.2026.01.15.03.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 03:41:57 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	lee@kernel.org,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	Steen.Hegelund@microchip.com,
	daniel.machon@microchip.com,
	UNGLinuxDriver@microchip.com,
	linusw@kernel.org,
	olivia@selenic.com,
	richard.genoud@bootlin.com,
	radu_nicolae.pirea@upb.ro,
	gregkh@linuxfoundation.org,
	richardcochran@gmail.com,
	horatiu.vultur@microchip.com,
	Ryan.Wanner@microchip.com,
	tudor.ambarus@linaro.org,
	kavyasree.kotagiri@microchip.com,
	lars.povlsen@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v5 10/11] dt-bindings: net: sparx5: do not require phys when RGMII is used
Date: Thu, 15 Jan 2026 12:37:35 +0100
Message-ID: <20260115114021.111324-11-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115114021.111324-1-robert.marko@sartura.hr>
References: <20260115114021.111324-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LAN969x has 2 dedicated RGMII ports, so regular SERDES lanes are not used
for RGMII.

So, lets not require phys to be defined when any of the rgmii phy-modes are
set.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 .../bindings/net/microchip,sparx5-switch.yaml     | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
index 5491d0775ede..75c7c8d1f411 100644
--- a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
@@ -151,10 +151,23 @@ properties:
 
         required:
           - reg
-          - phys
           - phy-mode
           - microchip,bandwidth
 
+        if:
+          not:
+            properties:
+              phy-mode:
+                contains:
+                  enum:
+                    - rgmii
+                    - rgmii-id
+                    - rgmii-rxid
+                    - rgmii-txid
+        then:
+          required:
+            - phys
+
         oneOf:
           - required:
               - phy-handle
-- 
2.52.0

