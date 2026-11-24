Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795508433;
	b=qHsgToQilQyvnkCOigjSXfPtzTNGCYI1TiBgLraQyG7q9qabqWqqKW1kiaLRN1B4rxhG
	 QbdGz0lfX0mLj44K60+j9aPiCHD+TOvsWjgD4nhiREPmqWtwE5MDKOiYyrJbdekVwhk1R
	 MchTkxIW/H3ZMvfNZjbG83QrL40Olhe8iL8hzaz9BlM0H2r4KCN3r+c6QmA4EZ2Qq8VMu
	 BKAoZlhifjFK2Um0Eat0sLg9P01eJR6uHgLZ1VM5bP/L46gIEm72w9Dff6ppk502Q37vw
	 PlsLictUEkpoqgBgdH9li2rk1oTANQq+H3CrHA+rN+pAg3iyozKdIfSGwofIWBQzdyw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795508433;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=x/k/1K6IfLcckBF6B7BnUJei+H5Q3WU5NtpHwL0e5HI=;
	b=UmEQFVYIFL8BOu5j0n1rSi0MFq9SMM8YqUtMDR0GglRiIO4j3W8T42U+obltsjzM7AKF
	 uODK3KHI8WY0R78G5+IzvBrJOE3qNJph2we9cq8srmxVfM5kk8fFuJm+VTRpJumDNqULl
	 F9ZyiUnSHp5k0ACB0ku+OV8nU8BlIUTJuukNXxY0aLzx/81i+hr2xbEjl8DYFcgbWySvr
	 kGCABiVyHsB7dHoE315HzMTlXvcIcBKs/51QZ/FDR3RoogBX3LcSVbXTRqXRnvGKjuRR9
	 RaoWb+GzQckwXa5Nwhb0cY0m2YgAjLleqnrR6hQIXPWD5tcEQgutUkczdAYr4hz9CFw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fhdd1cqJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E95606A32C;
	Tue, 24 Nov 2026 08:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fhdd1cqJ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795508433;
	b=p0WU6qpTs0YQOqjB9QlzMsUZynmSbIIvciLj0yd39oGXjUaWhRsdywxUZAYHyaA9Xs+I
	 MhmFKGxHmDVDIhFICObkSP8YP8I4tn1zelCFQyY76TDwfB6ANZc3utBvDFmRQoPdVmusC
	 CgPIbHE3blTj159Hnbkw/2cZUoNMacouYW4WQ9GX9Ub/bxUuLnYUC7eVI9NaYVb/Dpv8b
	 lzXLqbpcq0VQQvxq3AdCiShjBt2qNohZquiylpFqdCkLK+jw+p4cWEGVqhhXebnSemKMk
	 11zbyLAPQgjVjH1RdTcUxbSBTqo2qz/LyhZa+5bRUEgrdID5+JJT3Hp+DQ6Dn6FugmA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795508433;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=x/k/1K6IfLcckBF6B7BnUJei+H5Q3WU5NtpHwL0e5HI=;
	b=svoG4JjC1j3dc8gGVYP2PQF72AYunOS4M12xMvctxkQ1tz01CK8WLnzNJ9p6oQLhVzBC
	 jLPuo1Uh7hSwhuCtBd7xclyVhlsGbdbu2tA8EpxhZQN/CdjZ/Y3AeSucUlXmMUvgfUPvW
	 6SCt3Sj/str5HzOwNhTXUcGjiNS1ojY80PT9uxkfw+ea/HYYL9SWUDKqVNd0wG7Qo6ej4
	 /mVqKBoq9+/1ePHcMNUeZdBmqb/cQcmLnzrhQ9K52y37NDmX4gupbhzd4Rz2VRYYiKgHl
	 sDOSqbRklfVP/xKRHUQ7CPsNCdr2BKc0zVJhzDfxlqThXtjZ6sBH25KMWgO8+/cn+rA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 69FE81F000C6;
	Tue, 24 Nov 2026 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795508433;
	bh=x/k/1K6IfLcckBF6B7BnUJei+H5Q3WU5NtpHwL0e5HI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=fhdd1cqJqepn0Oib1oLenJ6STpyu8A/6HyjpLKN1bw+3C2j74y/d3Gw1ntR92Aopm
	 jH3cqljXwgHHW7MCIXF3U10XiFRuIfygLxOXZEYC+jdPc/+UIWpNoM3MFVswCEzH9S
	 XP84aEV5EwRh2uU4FrqLV74n6tO+N+h1MNS/TSiEqbNMs/LhW/+V6VAY9iydF6o878
	 eYjSSWayEPQy6h8pBBLjSCsARw9XKewLVcRs8atyY6Y8ut+N8OHzBTOdvH/6iwik79
	 NYfxXGy8iCdhMZJM22jBZ74rDAGpLlprH66nPPXLRt1UvaOr7NyDRqFIzqW5kX0hdu
	 PxK0TveLmjrvQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E13C14C935;
	Tue, 24 Nov 2026 08:20:20 +0000 (UTC)
From: Fil Dunsky via B4 Relay <devnull+filipp.dunsky.gmail.com@kernel.org>
Date: Tue, 24 Nov 2026 11:20:19 +0300
Subject: [PATCH v2 1/3] dt-bindings: rng: Add Cortina Systems CS7542 TRNG
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
Message-Id: <20261124-b4-cs7542-trng-v2-1-0192937b44be@gmail.com>
References: <20261124-b4-cs7542-trng-v2-0-0192937b44be@gmail.com>
In-Reply-To: <20261124-b4-cs7542-trng-v2-0-0192937b44be@gmail.com>
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: =?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>, 
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795508418; l=1739;
 i=filipp.dunsky@gmail.com; s=20260930; h=from:subject:message-id;
 bh=l1fROYGvUCU9bKrkug2vK1Rka6sqX2RjZb2LewzoVUM=;
 b=KLrAWWXkmpFw430BX6JJHZ2JmgYjVP9RW3wKNQj2b9SDOaf+FmseKvatXmzjfdl0MRUiQdzXQ
 5dkdxpSSjRdA0IB4U4Vfw7jq2aEYzV7SNV1ywSouWEbmCFbODJV8GzI
X-Developer-Key: i=filipp.dunsky@gmail.com; a=ed25519;
 pk=JAYP8e2rJ54DHOmhNtXud8rl1igAaAXoOHxtJmVXI1g=
X-Endpoint-Received: by B4 Relay for filipp.dunsky@gmail.com/20260930 with
 auth_id=1085
X-Original-From: Fil Dunsky <filipp.dunsky@gmail.com>
Reply-To: filipp.dunsky@gmail.com
Content-Transfer-Encoding: 7bit

From: Fil Dunsky <filipp.dunsky@gmail.com>

Describe the Elliptic TRNG register block and its reference to the
shared global control syscon.

Signed-off-by: Fil Dunsky <filipp.dunsky@gmail.com>
---
 .../bindings/rng/cortina,cs7542-trng.yaml          | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/Documentation/devicetree/bindings/rng/cortina,cs7542-trng.yaml b/Documentation/devicetree/bindings/rng/cortina,cs7542-trng.yaml
new file mode 100644
index 000000000..2a3890650
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/cortina,cs7542-trng.yaml
@@ -0,0 +1,43 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/cortina,cs7542-trng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Cortina Systems CS7542 true random number generator
+
+description: |
+  The CS7542 A0 revision is affected by reseeding erratum 28891.
+  Hardware entropy reseeding requires the CS7542 A1 revision.
+
+maintainers:
+  - Fil Dunsky <filipp.dunsky@gmail.com>
+
+properties:
+  compatible:
+    const: cortina,cs7542-trng
+
+  reg:
+    maxItems: 1
+
+  cortina,syscon:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Global control syscon containing the SoC identification register at
+      offset 0x00 and the scratch register at offset 0xc0.
+      Bit 5 is set before initializing the random number generator.
+
+required:
+  - compatible
+  - reg
+  - cortina,syscon
+
+additionalProperties: false
+
+examples:
+  - |
+    rng@f0600000 {
+        compatible = "cortina,cs7542-trng";
+        reg = <0xf0600000 0x20>;
+        cortina,syscon = <&global_control>;
+    };

-- 
2.53.0


