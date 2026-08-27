Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1D43A1A26
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 07:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787817352; cv=none; b=k+Q4kxUvumjj9l1rdSmA0SoCEc3qWf5YY3GxxL2D1w/Ask4/ImkYtkbX2KY0q3g6QCWEkpMviWmb2m19mfkvRSDyb1R77L8zRzzhUtyqHyJ/8bBZTCoDmSgW1BdpyLlj89+ciAGBtGzZMSwX5TWyv6khlHNF1Bb+IrztzJkpmng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787817352; c=relaxed/simple;
	bh=t4/SR8SWQmaZ5WztW+CHvg/QC5M34jhKztRXj5DMFzw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MKgr8PsLFsIioTVW0sET4Yn2wNeC1foe2tR7RZlk1fihJXns5aE02yVsTWq9FkWqrvdKcTiqmjENx/f8GtwVZ2KrkQ+FOkLYQWJFyv4qtiecqDBIRcDBt6l9EYp/ZItS/q2o9SMAEsveT+Ztm5ia50mCFlv0DS70pLFPOiysIUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org; spf=fail smtp.mailfrom=beagleboard.org; dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b=tQggt716; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b="tQggt716"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d72ae08fa1so3722845ad.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 00:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1787817350; x=1788422150; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vj8h83cNWEkfF8w29lRmAWs8Ge/MzQCuHu+NZTz6F+o=;
        b=tQggt716SVGx8C7jywRVtAm9cJxP04Xwt4qonOqre1trhG2kGNyRaxGUv5S/yNeB7Z
         hKn3gLJa/7l+HB2PCjpLYjTMl76WF6HuGae4QzT4jNUX+DdEcr97x+pP8LyVNPn4ir+n
         RhF6xs0tv3g3mA5t2UoEvxeyvZkYrKFjTyWSqf+7iYxMT0/8b4JReDe2Y84s4Q1dUtzo
         /gG5OB0RBKn+8sYqQvWnoO3ls+/fpAdrhG3eO1oEL6sBbE2UhIfDavp5N+rzi7dHMGnv
         DL4UbWIcxoNg0DL3gB0kF5FPx6ILTTOYeIhOuBFhaqaZT8K1cY9iN1KYZb5BkrLuyBSu
         PJyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787817350; x=1788422150;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vj8h83cNWEkfF8w29lRmAWs8Ge/MzQCuHu+NZTz6F+o=;
        b=lZ+qPPrav/8WF97YkSO7zSli8fWRkOHeb6okiDsFl+5k1rEME5zTf/V8Xd53141bYA
         ePhmK6wBxNDcg5lhghfJ6XbmRvXMNGKMv5+buCISmnYAlT3mKp9uoxfLS9B1ijpog+Bq
         nqmb27KZs33Gj/EsMYBKHZtj6pSxG7/qRt9Lgs3NRFT+OvcLfBVbwp/6SOXr2izp8Dqb
         J7/b+ffSJ194PYxYF6gbIK7ZJaoRhuNm1H/yeNMFmMO7yfCnQbNDuRJ7HTjJEjRYVYq4
         dvHRHuWZwOUioLABpSzq6MCKBgz7kjyhdiB0g4A8tTW2YtTi6mMNEq2RSv6uQefW5LY3
         EvYQ==
X-Forwarded-Encrypted: i=1; AHgh+RqnCjKA5AtbliFOhX+U8qGSrXvR52hPUm1FSn88nLRB1xRsnd4oZS2uinRhPhaEBtfqCfqJWNihtw8YHMg=@vger.kernel.org
X-Gm-Message-State: AFuF++lwDKUlhiH6i/rSwADj7N6oM6Yb2zhFZmPXB6wnFt2OGMFYTiZf
	1KrKLhBIRaZvIEnintN229rRXT5Uls42c+VeZVVMkAIfXscqTdeEShygcUKZbEw4lQ==
X-Gm-Gg: AR+sD101CfUms1UcKIQOWEel95F7onsWTYdYFC4jnIsbU+ZsCcVR2UGgVxW0m6YWtMC
	z6XJx6KzusK2sPDxn7jl8BsFjRZ3VturKMrr0REExAzxqN5diKe1E2aLfxl+3GPA3/PRuuRMy6E
	yyami4O+zQiZHARQzBIhw0MMq/rutif43E2siRsWIMzurxaY6gsFmw/39uUjXKE7PyG8ujh7tRo
	HtBNeeA2WN/B6I/BGUQgTdibl4T3x7ViuGVRztUJNslLZ0A4X33xO2RiGXTdPA20azwEXG1lCdI
	Ak4myn/aSjQXx8/TymRD87S8lF6WeY/eTyttvQG9b0lGA7Mfbz4sYOE6EZ+rEboOZejJjlKhfxp
	6R50DapKZYkAzIdPlHfjyRWrjBQtHEFFwcCMr53wK43gOLwid81FETsYoFGBG0697WQk4iYC5P5
	SznuPRN52X4IrgUlRbfnTAPHWUNPv0TippVu0VPmSSEa+gyQTopkKSHpG1VIN3gnCNJ3BkkNk=
X-Received: by 2002:a17:903:380b:b0:2d6:fec3:bd57 with SMTP id d9443c01a7336-2d707b6ca38mr268151405ad.14.1787817350050;
        Thu, 27 Aug 2026 00:55:50 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283d60c2b4sm24641685eec.5.2026.08.27.00.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 00:55:49 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Date: Thu, 27 Aug 2026 13:24:42 +0530
Subject: [PATCH v2 6/7] dt-bindings: beagle: Add BeagleConnect Freedom
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260827-gb-uart-transport-v2-6-a03bb1f5fbd1@beagleboard.org>
References: <20260827-gb-uart-transport-v2-0-a03bb1f5fbd1@beagleboard.org>
In-Reply-To: <20260827-gb-uart-transport-v2-0-a03bb1f5fbd1@beagleboard.org>
To: Jason Kridner <jkridner@beagleboard.org>, robertcnelson@gmail.com, 
 Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
 Ayush Singh <ayush@beagleboard.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, Ayush Singh <ayush@beagleboard.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2301; i=ayush@beagleboard.org;
 h=from:subject:message-id; bh=t4/SR8SWQmaZ5WztW+CHvg/QC5M34jhKztRXj5DMFzw=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBqj+1DBpvxBrw6gBdnsE8wvudZhudc7tdhHKrtM
 d+ionZN1JmJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCao/tQwAKCRAFzvXHieVa
 dLcbEAC6bUVXSX32NXCQRkssEbDKvah2Wau0ZPIEkRI1pohKltxCcJ+J3gLeAEpqmfWoMh9XSUm
 2Pd/ZQt/fEy31azAHIzO/axqtKGNag2/NAMd1cl8N5tcbN406xM2E2KnOUKqt84uKCwyCfcHuM6
 wIU2QlsxGzVahCuy2WN7r6Rpgi7MU/Wfo/XIGUucg7Wo528MIJNh+Doz/ytrJ6lVv53ZCdHoAIt
 ezSnprvifKwMDsQoGLd0vsggeVkOcXIing6/4EgcDPqKv9CKnEf7Rz6g4N3xCWLXLooN8PEwkr2
 5G//BAWasSbfFE9t5Zvxf5WxllIEDJfYn6Mx6Zca8RwSXtjAXHVl2BGCms/s7wScrgyEN4ydIfB
 L3LcZYu6VvPPSL2swqF/dI4DEHapg0EHc/PihXoZyQqQGGEUoe6TGpTk+7CGYA43gKxoDJFgMtg
 q5Psoq50HSpAO06AlWcwqZ/6zSwGSc8jvyIhEEU8Hf5lIQ4RLn9EZ/vKx/4AUw4xS2MzbSr75tz
 82qbRWMJIbQ0YOM27IAGIEu3VczXQr5+LrELfzhSdCwv82Wu8F73v9LK62KosEbNEdmKSce3qGc
 SNjQlt6CArQ+m+Gc9WQaWl44SCxoM6y4lt6Cz3ar6TsksOb0fhj4AGoLnGYEW9JTkcoiLtgMWGF
 +reexnLazFuUAFw==
X-Developer-Key: i=ayush@beagleboard.org; a=openpgp;
 fpr=DFCC131EF24F2D656FA504D605CEF5C789E55A74

Add devicetree bindings for the BeagleBoard.org BeagleConnect Freedom,
a wireless-enabled board based on the TI CC1352P7. The board exposes an
MCU that can be attached to a host over USB, UART, SPI or I2C, and is
described as a child node of the corresponding bus.

Signed-off-by: Ayush Singh <ayush@beagleboard.org>
---
 .../beagle/beagle,beagleconnect-freedom.yaml       | 39 ++++++++++++++++++++++
 MAINTAINERS                                        |  6 ++++
 2 files changed, 45 insertions(+)

diff --git a/Documentation/devicetree/bindings/beagle/beagle,beagleconnect-freedom.yaml b/Documentation/devicetree/bindings/beagle/beagle,beagleconnect-freedom.yaml
new file mode 100644
index 000000000000..be051a39acdc
--- /dev/null
+++ b/Documentation/devicetree/bindings/beagle/beagle,beagleconnect-freedom.yaml
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/beagle/beagle,beagleconnect-freedom.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: BeagleBoard.org BeagleConnect Freedom
+
+description:
+  The BeagleBoard.org BeagleConnect Freedom board connected over USB, UART, SPI or I2C.
+
+maintainers:
+  - Ayush Singh <ayush@beagleboard.org>
+
+properties:
+  compatible:
+    const: beagle,beagleconnect-freedom
+
+  reg:
+    maxItems: 1
+
+  vbat-supply: true
+
+required:
+  - compatible
+
+allOf:
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    serial {
+      mcu {
+        compatible = "beagle,beagleconnect-freedom";
+        vbat-supply = <&vbat>;
+      };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 3ba56cdbf056..d047090be5f4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11334,6 +11334,12 @@ L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/greybus/gb_softsvc.rs
 
+GREYBUS UART NODE DRIVERS
+M:	Ayush Singh <ayush@beagleboard.com>
+L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
+S:	Maintained
+F:	Documentation/devicetree/bindings/beagle/beagle,beagleconnect-freedom.yaml
+
 GREYBUS SUBSYSTEM
 M:	Johan Hovold <johan@kernel.org>
 M:	Alex Elder <elder@kernel.org>

-- 
2.55.0

