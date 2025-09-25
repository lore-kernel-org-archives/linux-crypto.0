Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE4130C604
	for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 16:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758818459; cv=none; b=KvaxRr0lTR5Av16qZTBO0i0HSx/ZCXybp5QyDkBGFu4P14ByImbjlc/FnZSy38UKiHbr+QOCVi6smMIJF0foi8su4uZgCMvImTrTYgCbf2mKFbwta91nzW1edUz98pD1nQYQFTezzbNwSYQkXbjRGuivC1Cs/MpLtbydCvo5blc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758818459; c=relaxed/simple;
	bh=v7/bGU7ZHCKWwoPLxIX6yU+W6cwtgrDMpcJa/blq4Ig=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iam91O2ZZh0xPdYAh1WaRtfQgutO4SamZ8KAqVVY68VzS0TUBgFRIYmqWtAv1BlPJtMqhckey2OnuIJ5mb4Rsvw3Simqgdgr1/9yrQLOoo4wYPx1nPP181UwsBuxmnlZL7pRMEB5NAQ3VmdYFHqThXImNIEp+ryvhcwsqzeCxDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XWmYQdQe; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XWmYQdQe"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3f1aff41e7eso1253013f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 09:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758818456; x=1759423256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LOcrIoNr25HDz/QJv/9nz1km8B+JKQd3A3tnWDgtjkQ=;
        b=XWmYQdQe39PjSYHTPfQ8BN8pIXpLGrUwjcy4s+P2SIQkq1CDiIsZ/ivXG80BvKdPf2
         0YEp6AwNRZNF3Qfy3axo7zfu5Q+zAFRuSY/toJLvRa/l2uSf4Z1Yp2fR2vcf/TOe/e/A
         r4G08N/d5aJlPwNXX/Nx+uQ5fk+f87BsXjmjxWdvcaQ4RrXmilNdSi1D6ENpUXiZPM1u
         c7FLQiAqdpr9xexiVRdelXH32dsWLQkuXbRzt0cuwmFUjELJO5wcofLuubbvBYOwpnHf
         6QuK+z42d5AX7GXFlFCLHgofUpE5v+yWUBMzigUnowWU3WvQnrogzi7ULa3KNGq5p//h
         Cmzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758818456; x=1759423256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LOcrIoNr25HDz/QJv/9nz1km8B+JKQd3A3tnWDgtjkQ=;
        b=VJHnALzLYE/gkzx6svwYuqcWY67F39y46XG8fXALmiFoPj3UFoIUXQmh5jEVG9pzsj
         3p8Gl1y4kRXq82k8b5d4uSTn/SthsgVrrtr7uHesiKijoQSZWqk147loAj9XgO0FpQnH
         Z3TbipFedhdNQa533WmMbnSFKBUE//OsUv0W90Nyg9itjnaw1wm8GEqMY9v3om0NqwGM
         SvsN1rrmdAf4nOFFRLrqj8OK4xE1uHq5xTX2LZY0qCA2rXHI643RyJx+RcIwXpSKYWT5
         Urd61Yg1PzTRhnr6vBP3z8Kq+aLku7bxIFg+TtjVeQfYIv25GqV9TEm6dkFxiMtOPWHv
         ROsg==
X-Forwarded-Encrypted: i=1; AJvYcCVvYHCiOu2+dyJIAWx35eCn2+zrHYqTwKYrqWinZBK9XP8G6ZBef5DKYqWhqfrYiTd3uep1N+fqLcmPBIM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaAbJmgmsGEre4NTqWgLuM6Z+xyQrjFR0oNkV7lwbr2rAILeZi
	IzuoSWnCv1JaGsadRuVbI2D/lbxCCHvQfS+U2SKhU5N02TR0kSXLpFLO
X-Gm-Gg: ASbGncslaVIDr/NNe0/fiI6o2yQArZQJlOTe7YX/hPYDL9P91mhMhthpbFpX1Ej+Is5
	MV2DoiWymeU6cZgEVM+KCpWhOoa802p2D5x6DVe3SpRAmctWT25Tci5b+HvjBOxqaDg5jUb0Ife
	D08WG76l5bplNT51FZpK9eBdQjBatb0K3wG6IpvrBV2BElPIi7SMZkkfafC3tCqmI/zPovh1SAU
	GQuNhrNmumqs+nadH/dSpeKWaPebmE6w6Ft85P4JbTRNSALPQXP5Qo3595QB1FpTu7Yp74/4bdB
	OMQMH6MEqkUXnPsVlY8VVr59SkqD1gXeEHvceR9fMYsFOdoE0oVW0NnPemmMa2F2XG55nGylhB/
	OUb5opYENPEBUSBAgTaaHOeckzz4l1kFlrJjH+pJbWC3jeEEscidi7fB/V8Ud5VFJunbzy7c=
X-Google-Smtp-Source: AGHT+IHX/CI2L/vfg9Dj8p1oMbt+FsoCRcXjcK4DCzITBXnWVWzmuBAbvqxNfCx8Z5RM2iRB5ODlEw==
X-Received: by 2002:adf:8b88:0:b0:410:3a4f:1298 with SMTP id ffacd0b85a97d-4103a4f15e3mr2182661f8f.15.1758818455924;
        Thu, 25 Sep 2025 09:40:55 -0700 (PDT)
Received: from Ansuel-XPS24 (host-95-249-236-54.retail.telecomitalia.it. [95.249.236.54])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-40fc6921f4esm3591904f8f.44.2025.09.25.09.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 09:40:55 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	John Crispin <john@phrozen.org>,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-watchdog@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v3 3/4] dt-bindings: arm64: dts: airoha: Add AN7583 compatible
Date: Thu, 25 Sep 2025 18:40:36 +0200
Message-ID: <20250925164038.13987-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925164038.13987-1-ansuelsmth@gmail.com>
References: <20250925164038.13987-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Airoha AN7583 compatible to the list of enum for Airoha Supported
SoCs.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/arm/airoha.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/airoha.yaml b/Documentation/devicetree/bindings/arm/airoha.yaml
index 7c38c08dbf3f..df897227b870 100644
--- a/Documentation/devicetree/bindings/arm/airoha.yaml
+++ b/Documentation/devicetree/bindings/arm/airoha.yaml
@@ -18,6 +18,10 @@ properties:
     const: '/'
   compatible:
     oneOf:
+      - items:
+          - enum:
+              - airoha,an7583-evb
+          - const: airoha,an7583
       - items:
           - enum:
               - airoha,en7523-evb
-- 
2.51.0

