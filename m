Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CC13B0595
	for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 21:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789506042; cv=none; b=J9AsOA0eXZR50kQ2DTz4Rzs14+pdEMWxREyTf2qfEHx9v6qxI+BC1E6UNXHe2OzrvwuOlevIOJkpl0yz9EIyQ0Jq6H8IQZ//toluJV5wMi+p2ZB3qorTzIQPr+R8Rj+/mxj8zxVzDk0uUfaZmDxG7AHptcWPzzgSxThrHnqKNRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789506042; c=relaxed/simple;
	bh=3NlwmlgeR9UStztzEJOa5XxE0OKSg9rGXxb09yHnIZY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EKzrchqheT1fcMQUE2E0YFrc8Qeyvio+6QxtyPbEl9QG1dKkRAV/v6fTWg1dvY3wHEMAyzDZf5fxxvtwb1NLY75PiGLeN1GZj6dpeb6XgC6uP37pgvQG42z0oN/A94vywui4sSN8btMR9ntFc3/dnHgnwaO65noo4RIuA9H6ziE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OIMvNrJX; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OIMvNrJX"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc42c773d05so18157a12.3
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 14:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789506039; x=1790110839; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wnvNRJTUsdTr1CADcV3hYsbAspY/4YujciextqHo7XU=;
        b=OIMvNrJXZTiWrkry1QwhcUj3CbDaE2vZUvx7LmScDOlSaexeFtFd007VOergZTEC7l
         OSEfLRXo66pbbmwIJylTCksYSuAvh7TBQJaUdx1J33tSLE2+c1ikSqWJbxI1A5BMkXoQ
         P5iTifbtP/kazNhc/NwVxP/Do/j1lMQtcG4yLKwKFDL3yKe0SMx4R9mrWOf0CDaPFyCX
         7lcmS7kPX/XT6VqcJfsWKXyFVI5S7Lw2b3MfWB1dqnx1bBkV8xyXOz44lHlLea/ywiqq
         g0VAh4sx0RDTPh48aXlhNXsFxwDWvwXcOZ/d5STDyoEeuQTX7R+io+/MUiPgDVv2Rybn
         74nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789506039; x=1790110839;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wnvNRJTUsdTr1CADcV3hYsbAspY/4YujciextqHo7XU=;
        b=l/3bjogXI++gXamDrR6Z+2UnO/chp1uBWbqw+MsvVomMeZ6y1g+9lDXeRrJISzPDuW
         ObPiV7U64L+De5BVsCE3U9AK3zJTYhBYeLt4SaudqbY1prnx5H1i9H92nahhxt2HR4tp
         LaAix7f+PvlpD9kc3CiQTrMZeeBj+ywpK7nzIoP/mkgsAVlodC1b3HDoZgUcBBHzA0UF
         1jxofbVOdl21JkaZsL+TaiS3VNDPLbYW4/LUGPy8QUB1Fuzh3C2jq+V6ZYK/NGgg4VJc
         GgLscds+LjC8BmGYIgwoqaEdV1CkU0iNPK4M9O5mcGYi00FfKTItENVt81j3WeGineiS
         E2jg==
X-Forwarded-Encrypted: i=1; AKwUvBy29VGId0SRqS8tho7M/mbU0HiyVykYt+7hePAya9bEd28Jffsr4w0c9xhoRrKdGsV09iqy9icE6RXChDE=@vger.kernel.org
X-Gm-Message-State: AFuF++kkpX5OkSElwOij0z5SXOrPi8REla0j4Y4o6VYrp70H076tNGx3
	D5lczrUSNWdN+4U77KvGE3yRKhjHCIvhqI4YA2kr4DOPLC/4WijKbtkK
X-Gm-Gg: AYBFou2x8++HF0THJReIrLNualm50H8W3N8oHraRA4fpv9OwW8D/KKe4oY1qKeB49i/
	ke5w7wAJsGf6MjApqZ8mH1ptIRZTP3Ae8fpdM85FGa3g1jfb9hHi/S6+F44Y9p+BnER9cWL2XuX
	QIdqtE3J6aa2cfsNfhi0DuSTLfLbk6ap/JwNNC41j0fvk4+HD81DquWukBm2oG1fBjFTo6PqA5H
	Vj7VhQmS+e4RBrqBKZFFBfPaaF9Xb+DuCprItXx+AZLSBtTNrOxcSPq51rFo3lUiFzHWDW61uAB
	uHHcU7kqJeAi42m2qeEJJkVWRwfVT3xC9eQTe1AnExyT8B7lUnv/RFegaVOdQHrkS4+Y73TA0mJ
	Nu5TIEoYcYnEuir0bpT4I8h2gb+WiKNPmceYuspmPTOMi92XCo/sdwiYFFjWwprTXY05hmufzSP
	Pu8qXc6ea2x/IjRfmBeWft0DuYF8XtoK+6vW6qcnZHpu51rP/FefNCSl3QKdT6b6cst9fpicIwu
	nHeyzI3saY=
X-Received: by 2002:a17:90b:2250:b0:39d:e1f2:3400 with SMTP id 98e67ed59e1d1-39e1e5285d8mr118300a91.5.1789506039587;
        Tue, 15 Sep 2026 14:00:39 -0700 (PDT)
Received: from [10.107.92.252] ([2409:40c2:5413:87f7:9fa7:eb18:a8e7:30a7])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc50abb1483sm465432a12.26.2026.09.15.14.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 14:00:39 -0700 (PDT)
From: Bhargav Joshi <j.bhargav.u@gmail.com>
Date: Wed, 16 Sep 2026 02:29:40 +0530
Subject: [PATCH v2 3/4] dt-bindings: crypto: ti,omap-sham: Add OMAP3
 compatible and deprecate ti,hwmods
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-ti-dra7-omap-sham-fix-v2-3-4eadb60081e5@gmail.com>
References: <20260916-ti-dra7-omap-sham-fix-v2-0-4eadb60081e5@gmail.com>
In-Reply-To: <20260916-ti-dra7-omap-sham-fix-v2-0-4eadb60081e5@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>, 
 Andreas Kemnade <andreas@kemnade.info>, Kevin Hilman <khilman@baylibre.com>, 
 Roger Quadros <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Animesh Agarwal <animeshagarwal28@gmail.com>
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
 j.bhargav.u@gmail.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789505986; l=1381;
 i=j.bhargav.u@gmail.com; h=from:subject:message-id;
 bh=3NlwmlgeR9UStztzEJOa5XxE0OKSg9rGXxb09yHnIZY=;
 b=ZXwjniFsJyTCSkhGvIbLpRhULkdgCB1/C4/QtgW1ponKnqrQv+R+rEN+sSL8c9Q+PWN93nCPH
 5czedkWgtzcDcn6Jf6cbKfzpFYJPQpyBOOEkwg929QDKmLqi8guHMLK
X-Developer-Key: i=j.bhargav.u@gmail.com; a=ed25519;
 pk=IqNDwUZKECEA+n8wXctFLBbYL9NhFstZNbOznm/nX1k=

The OMAP SHAM driver supports OMAP3 SoCs, and "ti,omap3-sham" is
actively used in existing dts. However, it was previously missing from
binding. Add "ti,omap3-sham" to the list of valid compatibles.

The legacy "ti,hwmods" property is no longer needed as TI OMAP mirgrated
to "ti-sysc". Mark it as deprecated and remove it from the required
properties.

Signed-off-by: Bhargav Joshi <j.bhargav.u@gmail.com>
---
 Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml b/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml
index d69b50228009..3ef05890e13a 100644
--- a/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml
+++ b/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml
@@ -13,6 +13,7 @@ properties:
   compatible:
     enum:
       - ti,omap2-sham
+      - ti,omap3-sham
       - ti,omap4-sham
       - ti,omap5-sham
 
@@ -32,6 +33,7 @@ properties:
     description: Name of the hwmod associated with the SHAM module
     $ref: /schemas/types.yaml#/definitions/string
     enum: [sham]
+    deprecated: true
 
 dependencies:
   dmas: [dma-names]
@@ -40,7 +42,6 @@ additionalProperties: false
 
 required:
   - compatible
-  - ti,hwmods
   - reg
   - interrupts
 

-- 
2.55.0

