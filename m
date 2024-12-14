Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EB6192D63;
	Sat, 14 Dec 2024 13:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734182929; cv=none; b=e0k7rjTtuJbA2wl3i3kfx3COVAVA8q2MhGQmKxYrcCycgwWAzRkOe+JTw5vfamoe1H4WU2CFvCzHF9trd+Y+c1vYYjMyYdPQXob/NqsJpKSpkN+zfHPW0fAnC0fVgLMPd4YcLfAkl2kFWG6Kaixd6CTOMXF5i6zv3ai/6gVlXFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734182929; c=relaxed/simple;
	bh=E8cFp+bHGIU6pZjCwgdyEMfWXs0JQy/krXTTtrw2utY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpsuIn2lIbQoogqf8fDF3ZjL34LHEdLDYtbNtfNrHSXTZ85mm6nmfIAzyQSws84CHk2H2XWL2uCK4qqxmmZvAwKc9pfahnWX3vkDky52ano+NYDgJv2LS4venIIwYhh8J3m/2yVIuNSpSPxIhLFIIJKPDFMEAVToTnqmCaYVB6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZOgxvop2; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZOgxvop2"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-38637614567so1209953f8f.3;
        Sat, 14 Dec 2024 05:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734182926; x=1734787726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i0cVLwNBaKmRixL4jHSZNuCFVNGOC7PS8Cjxhvb4LMQ=;
        b=ZOgxvop22RiPQzQkcPFDOsMaqxv9WBWeoqW5duAHlpc8LojpMUyKqWAq86espw0zzl
         BTD6AgT3C+60euPUEtUXh8SU0Z8Hrgg4l3OhvzpwTmjSC50pt2TnjXg+EYyfQUxvCvKS
         3zyRP0v0RWH3qMI1kayTrLaADe0SxKX9ty9C7YAI7QoUIrJjIIHAYhsf1joQQ8TIBZCo
         t/LmP8jMbam3Osp9+DA4MwNJM1lWEY+0F2Ut2++SsM+wpOFdX9MRF4LYoVn6K7JWcFq/
         AsvWpAMAbSSuGrx1JX+rQC1dLynt93p2jNKhUGQGWJ2wM/axt8Vqoe/KeDpym7x4jKxF
         QGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734182926; x=1734787726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i0cVLwNBaKmRixL4jHSZNuCFVNGOC7PS8Cjxhvb4LMQ=;
        b=E1IZZl78DnWbAIkvWGkM+CFA7D8Z2Rf2Y0J1GMPVJ7DEyl6uIRlbPk1gyCFBrmT3mW
         OJaigJlV/o8DXvdmisB/yTSGkqjpqE2kQk41Oa7WDoDMDXDiHRoDJwovPa53IFfDjT7k
         XRF3wc4jCyJa4n8+Y/CTS2vNPkePl5hfZSawZxdXF/TUmDIsc8l4ehJQDq5ORVuKNkfe
         VsvIHL2HD4OQ5ZAObscXJqlkVqV7M8+Tb7PtuC5I9C+16RV+IsHcPYRlC7TkLCOqHjfr
         rcpcLdje+eW5vV16/9qaNCdmyB8aviNj27beu5+hiK/fk0GSDOk4Ku/FEOFz2j3qBjbV
         Y3WQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKcSiF01FJfFsSc4j16l5Kxu20VgzNHEOXS6GaXY/DUK5lfgV4VQv/ufWkcuA4cy3OXE6c5431VMDxSrkl@vger.kernel.org, AJvYcCVGrhbUbRrl5kKWP1XOvSa9NkWjEFMG5TysIHAp48YYCkwyF0Bs+6Jm8uli0nNwoh7t++w9UNBZkBBz@vger.kernel.org, AJvYcCXASs/yQ6QUzVtHRFJEhnjdMRPK4Jy/e9vVcowqhGVLtHrcUlK5prCndbllZ404beQep3RqRphF4Ghazc92@vger.kernel.org
X-Gm-Message-State: AOJu0YwXP2IEY3ABS8x1xc28kZAYZooMJh6+Ni6Z+d35B4uqe8qILIlj
	HqXP2hlhNleVo9Jac3aNaom33DgJ271xhIa1OL4ga2nC5XJxw2Di
X-Gm-Gg: ASbGnctQXjreMY25mrMR6rtbqqVCD4MloWG4chsl/FPRI7juv2kXcdMz3ojYV4Yh/7i
	DzRX/71dtg7bfGj8xp1ssf4Rf+GrIOzPwKHwhQUESOSVlVNdSpH/SiYnavusAnJ4xgLAG+VegJi
	DcCzQnZwaZbxaY+8XITA1d3Aykl2EKSU7kAQb/ckzzIGmJlwJ82I03Jhecvras9USqYIQYErwmj
	IA68hVb7/ES/b5OKNa2eZ86A0NHT13nNP6uaRyaqmKnd+3iMrLrb0O5BXnZ2Jcyle44dPKOQPqq
	DKlK9ZiaIQVLoR1WKL4C3akOWg==
X-Google-Smtp-Source: AGHT+IHWOOjAx92o0UkZW27B4uW0stxX940JFjTYyBWPuPIFZaoCv+Fku6fPNjhiKs2/AftSrP3jQw==
X-Received: by 2002:a05:6000:71e:b0:386:373f:47c4 with SMTP id ffacd0b85a97d-3888e0be376mr4821291f8f.49.1734182925995;
        Sat, 14 Dec 2024 05:28:45 -0800 (PST)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-388c80162a6sm2559850f8f.33.2024.12.14.05.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2024 05:28:45 -0800 (PST)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	upstream@airoha.com
Subject: [PATCH v9 2/3] dt-bindings: crypto: Add Inside Secure SafeXcel EIP-93 crypto engine
Date: Sat, 14 Dec 2024 14:27:53 +0100
Message-ID: <20241214132808.19449-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241214132808.19449-1-ansuelsmth@gmail.com>
References: <20241214132808.19449-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add bindings for the Inside Secure SafeXcel EIP-93 crypto engine.

The IP is present on Airoha SoC and on various Mediatek devices and
other SoC under different names like mtk-eip93 or PKTE.

All the compatible that currently doesn't have any user are defined but
rejected waiting for an actual device that makes use of them.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../crypto/inside-secure,safexcel-eip93.yaml  | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
new file mode 100644
index 000000000000..997bf9717f9e
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
@@ -0,0 +1,67 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/inside-secure,safexcel-eip93.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Inside Secure SafeXcel EIP-93 cryptographic engine
+
+maintainers:
+  - Christian Marangi <ansuelsmth@gmail.com>
+
+description: |
+  The Inside Secure SafeXcel EIP-93 is a cryptographic engine IP block
+  integrated in varios devices with very different and generic name from
+  PKTE to simply vendor+EIP93. The real IP under the hood is actually
+  developed by Inside Secure and given to license to vendors.
+
+  The IP block is sold with different model based on what feature are
+  needed and are identified with the final letter. Each letter correspond
+  to a specific set of feature and multiple letter reflect the sum of the
+  feature set.
+
+  EIP-93 models:
+    - EIP-93i: (basic) DES/Triple DES, AES, PRNG, IPsec ESP, SRTP, SHA1
+    - EIP-93ie: i + SHA224/256, AES-192/256
+    - EIP-93is: i + SSL/DTLS/DTLS, MD5, ARC4
+    - EIP-93ies: i + e + s
+    - EIP-93iw: i + AES-XCB-MAC, AES-CCM
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - const: airoha,en7581-eip93
+          - const: inside-secure,safexcel-eip93ies
+      - items:
+          - not: {}
+            description: Need a SoC specific compatible
+          - enum:
+              - inside-secure,safexcel-eip93i
+              - inside-secure,safexcel-eip93ie
+              - inside-secure,safexcel-eip93is
+              - inside-secure,safexcel-eip93iw
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    crypto@1e004000 {
+      compatible = "airoha,en7581-eip93", "inside-secure,safexcel-eip93ies";
+      reg = <0x1fb70000 0x1000>;
+
+      interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+    };
-- 
2.45.2

