Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815F3304BB4
	for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 11:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759146570; cv=none; b=sHSfeYybqB2vg+fuYgbNT1gA9tNn5W38EsbwIbK0KGTtcAH6AOSZai7CXzRfg0ocuTLs8VLyfVLQD0kccXiZkiirw2ildfStHHj4mmOAAqi6HqdtVwla9Wy5zTloUY8allufd2GTfGgcyZ/90ZBjzKuOnuqzi5/q5UBjCwDB/uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759146570; c=relaxed/simple;
	bh=/3d+DNZ4lwjm+XshHn87ADcx87J0m4/hD0vp82cIobE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VisMEfpJvFhi/DWOh6MGVDrNSLaDFej5L5yGRYIY2tl6sSyY6or1ISBseHwDIuaMPmPdMQxG8kig23vJPId7fresKdKLwwCWnXsCTLk8hUwMCBr4p6lgVyJ6oLniLi9zQChPkCGVjaTzxpGUYIcer0ELHrhf/tRRcDVlfS9Dahs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U3yj2FzA; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U3yj2FzA"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e37d10ed2so43575885e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 04:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759146567; x=1759751367; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eYKIS6AUB4jbN6LRMHpfAVlAKJeZBTFDpfK2oWN9FEQ=;
        b=U3yj2FzAbuZabJWr30ta6Vu6V0YKyL7onfjk7bUGso4t/c/EReg+D1o5KlwsyK1C/U
         mrwvK8dBP5xy+I4H6akbQRoOtbVOrSyOrpyXXE7lGbmKhZMJXJKgIvVYWvnrwFHVjaFO
         tmxoiO2vuX2XcbkKsO5KuGJivrWuM7TqmeXevvV0LSUwKqoLfZIvAkIrf4rZ2xxBcPPI
         730fAOBM6BCtQZkAv+5Rp8amAfbXoVczRblU+0sghTdqd00jVs06M5Wp4LOvV9avCFLL
         DQhLLx0IfMbebSiaieEFPO42UqT2BPM4/epx69XBW/BI5qgVf1xQnDndssv0NHBd25vo
         ZPMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759146567; x=1759751367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eYKIS6AUB4jbN6LRMHpfAVlAKJeZBTFDpfK2oWN9FEQ=;
        b=SNGRpyAnpIEBHkEeUedjfdETgj4Zp5XAr9v8Rod+Gc0HScCQRx89j3AnsX6TLEqCSu
         TeYplzI7DTCcQxP/ElxbVL10HAzZIbSUoSwZVd1hl9BGblINUlzxWr6VzXwgU31gMG0T
         HwU/58JRxpPv70BGlbxfAhd6xTyGAl8dB2VnYIDOZtjnhQN/XyWrJSmkSa3P6v4FB/Fa
         bLyp0TJxkKl5J6/UDNK/yjxsiHD0iXzVK/CSK5E5NXoU8YngzRmGAVu0x4rF47jcHAH4
         l56JZiwrMeUbdjtudcL3rTE6uAVa0mMhhWLPS/kEuLASrzHXywDZoEsrtGisT3o1NOTO
         luKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHH9NMi+FVZ6U6MLVv7mfh5th3+KvmDxZ1gkJg51vUCmtGR8SjJMGGpKf6nRH4qn6WzqwC2CCoWDeRg/A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqQvZSD/fRtsqVxsrEBLUJ+yJkwL3MoTL7YQ2MmRjRyVo4/sma
	qKMMUpF6NqMLWBEQZW3OT8lph7KCwZKF1VgtOoVKTr1flYqqHpNgyHJU
X-Gm-Gg: ASbGncsI/ZOo7unszt80+qiB4rBTzg36nztffsi1p0ulgB31qjsIj44VB1N2yDJ/aXz
	2Ygey570NAR63Jrh9oZb+Guq73VghRuRdKgUJzD6RfJpj9Y3+yJj2+XDb+ntotM4cFqzOKnWqHr
	D2kkVhVRiza8Q11lDjFudi20XuU9+PM9AUbUb64glCyXMYnJTv9vGQm0fu9Q6Se4jWtwaFm2q1a
	OGYT9IwQo/6bE929Y6oHzRnMmNKUPb5YrpeBC0upl4w93kZiq8keGSbrKps5SbZUba+eBjrD4qI
	5OZ8nnbTHiu3xTSt5WhKBYOH/34V0vreJL54cIziip5rQhsTb5WSsincLuFcVX5SkCb6DWqZkXI
	INUhwpmWnoLAXwq0NTDamoWc2E81s9x7tiRp+tXtu9Gzq4mhFqVdsAn/dCcZFfJvFIcPVOAg=
X-Google-Smtp-Source: AGHT+IGuqXMPmewneHZfTKdYco1M53FvKmmiliFcGFMcT7OaxUtdD6+QR3/I0y4H9RP2qzHFLrfHpg==
X-Received: by 2002:a05:600c:468a:b0:46e:4705:4958 with SMTP id 5b1f17b1804b1-46e47054a6fmr69438625e9.30.1759146566851;
        Mon, 29 Sep 2025 04:49:26 -0700 (PDT)
Received: from Ansuel-XPS24 (host-95-249-236-54.retail.telecomitalia.it. [95.249.236.54])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-46e56f77956sm10030835e9.20.2025.09.29.04.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 04:49:25 -0700 (PDT)
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
Subject: [PATCH v4 1/4] dt-bindings: crypto: Add support for Airoha AN7583 SoC
Date: Mon, 29 Sep 2025 13:49:12 +0200
Message-ID: <20250929114917.5501-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250929114917.5501-1-ansuelsmth@gmail.com>
References: <20250929114917.5501-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add compatible for Airoha AN7583 SoC. The implementation is exactly the
same of Airoha EN7581 hence we add the compatible in addition to EN7581
ones.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 .../bindings/crypto/inside-secure,safexcel-eip93.yaml         | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
index 997bf9717f9e..2269d78a4a80 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
@@ -30,6 +30,10 @@ description: |
 properties:
   compatible:
     oneOf:
+      - items:
+          - const: airoha,an7583-eip93
+          - const: airoha,en7581-eip93
+          - const: inside-secure,safexcel-eip93ies
       - items:
           - const: airoha,en7581-eip93
           - const: inside-secure,safexcel-eip93ies
-- 
2.51.0

