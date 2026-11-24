Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795508567;
	b=gzzdHWP3fK1NVMY4asY2Xvl3U8UIOIuzfIW/41gvdg1a0jWw8O31lbHQg/aAAOwHkPhc
	 Cx03mc+BsNJptyEBbU1YMcKZueIYGoJV5W6r50krKF7qc4SNONubgYDLGWdmIgDV2sgEg
	 +9cgSGEO8nK90MZv+rUTor1bhRK0YBD+WgOicFqT5kdkre4WM+L9sMnCO26R8X1u1eDGz
	 HYMQShxaDJrWuSvYfZKTvO8rXRSrSQp57/HeVoKFvO8a+zPH0Ig6DzGXnwzSsQNxCkNWK
	 OdSMEyCxF0ybXvdxpC14iWiLGfRWCMFS0NrbRcf03UeI/aj06+CJb3rW6o4UrQkgxpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795508567;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Transfer-Encoding:MIME-Version:Content-Type;
	bh=ImrZa/CtUYdIECWeql7+P6fyscSC7J3tVy4vOnUjZhA=;
	b=Lw7RCgqxM5otDKmk8dk4LvQAADZgvccBHr9BV6eKo8d1vmyQAodaolbKj132LYs2WQcw
	 r2PBDN+Aqadwx4a7//dm4n7FfP0shKG+IHwlQBaC+EkbkXeK+470TP0gRKWaJr4ZNr+qe
	 xJ5gq07mSyuEOXsU+xGItTW+G5BFnenYOX9RT9weE6enDu0Foz2x4I+wICK7K9lUyEirz
	 NQ3xL6Zl1zXxO90DeIItZQ396wRCX10S5EfQwiKgpOMmMmHdj76pjfxmo7wjgfm4rMP0D
	 2S1GJqpGqTvrPbnIyeWbvm4fD84yUMl+8P/IxJkm3nYbTqU9AyffvDBspMv2iIuHEnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zkXuyC4+;
	arc=none smtp.remote-ip=209.85.167.53
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCC8606A322
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 08:22:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DCC8606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zkXuyC4+
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5be3ed646a5so5760905e87.1
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 00:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795508565; x=1796113365; darn=vger.kernel.org;
        h=content-type:mime-version:content-transfer-encoding:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ImrZa/CtUYdIECWeql7+P6fyscSC7J3tVy4vOnUjZhA=;
        b=zkXuyC4+mi0RVbuDiKRWE7S/6//F7Y1g8YtJOfu/xreqveajHoDWGssE1j5ca4741Y
         +sNJrDz5yLDn9Id4mhswHYeiG2ntdWVEgZ4Ox1UwljiMD0G/lMCAqPEAHsHailAsn7c0
         YPZWxUS2sd4L6SzMuoa/ggHvAdvoeG4nPJKImtbs209PRTxPl2LDUdxJw8J3d1BgAOjQ
         gI1HiZd3vlWuyCbZ+lv9T3McTqLaF1lRe1TfwvwZTYFKfW+YAT1qAPPpMppEiGEeaQeF
         yOpEpUYPOOACl+qZtKi9vl+bcLCKD2oqCA50BzK5IVcJBhr166TKI2mC1jBqvrktQxrm
         rNKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795508565; x=1796113365;
        h=content-type:mime-version:content-transfer-encoding:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ImrZa/CtUYdIECWeql7+P6fyscSC7J3tVy4vOnUjZhA=;
        b=hpi1v0OUYiFfFzAifsOlqyo0eA1Gwrb2imAeNNt8xBHBAZrWvhQvajNbrUEsTsZ7KG
         WlFbCdYICFCO+LIFiHxpxt3wG4a3gyHw/j+9CDzn27zMbw53SZMTFLx9H3oW0Xt6ZJnx
         8YFsb0He6ImdA1TBLj/dY/O76/olL45OT7PhpfJmSkqeltwj3oOASDtd5GhKSF955WiP
         LCJLGzbp3SppCEV/VlP5oYmQH8+GEJsYtVcNleqQrcI8YTPj9ZQYeVgmMxu17CuLqTi3
         jcZzIfJ04hEPctd1bfN6eftSs7QLOJFDwLRb0hJjNGEY+RpFM462lNyz1PcENgZHzM4B
         SiNg==
X-Forwarded-Encrypted: i=1; AL+hErG0KqnGf06IRMQZ1KIqWbWp5EKHOhY0X09WgqzXod2sUX+N/dDOAKtqc83mXyTlstlJyP2fx0E0aUcQby0=@vger.kernel.org
X-Gm-Message-State: APuU4Z9WB+qIv+sGLsLxmrjxhC2Hp2iI3spNd0eFLmiiuKRHnaznwtDj
	+nJIMhj1K0fCj25tBmyfESIAlDbctUoBe7lwOeGeM9xI6Dbt0QdqRFLuxOMh00fxVIfsxg==
X-Gm-Gg: AZFdTZcPgqERJmkrjgIyAbOPtyijBjdISnWrNAQvtZvFQ0TxjDS9Oay8l3wncDIOxhY
	sx6XvUi6rxYQ5g/kObcjCkiOTrqElKydFIHYdmFGfa36u02yhrO7dRT1LxctRuwU7keXObtKHER
	dCw9ywXUbUt2xL8u8/Z5mhIjgaIJJ59kWWcu6DWn2Jdq5ZVDenOYkGPtYzC7bwjAJNwABVHJTlY
	YJZ0pjwFlmVA6u2mkKXu1lQjKkBvs75aWU1x6z0djercb3xlZ5b5hvNrOSv/jUJUeR8ynuC4rgx
	Wc8DSwLQfT34o8BTW6KtxO/URfGIcYDjLHFBGMETtTba+Fr32ucLPHrJLMGM/YBAGCVAnn7/tdA
	qwDCrhgSyTTgS7DW/4K3ZRJBoDQEku6gss4AfwcB15ki1qR+zBDpIMnIbwL3w+arDeVco9yqcyk
	+HVW/vyDHEFfKRuCRIE3LB9Jbt/P2HJ4hC/rVLxk3uqC/4nC6gc+bFH9+OasIg/R8eYFevLCbTV
	nWLXdH89us1IRmJb56JocArGmpz6rOGbEKFZyzFe5kTO6NMa2njgt1wpESdyDWLV1em4Ve49mli
	pXr/YknCUtWO8G6A9HF0JvLGmjSn9ZVnouMojqE3yPuDLjQ6nV0cr3M=
X-Received: by 2002:a05:6512:108a:b0:5c1:4e18:39d7 with SMTP id 2adb3069b0e04-5c1bc7bccd9mr4434489e87.12.1795508565068;
        Tue, 24 Nov 2026 00:22:45 -0800 (PST)
Received: from [127.0.1.1] (ip-024-180.users.dtel.ru. [91.210.24.180])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bd0563casm3560147e87.67.2026.11.24.00.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 00:22:44 -0800 (PST)
From: Fil Dunsky <filipp.dunsky@gmail.com>
To: Uwe =?utf-8?q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] hwrng: Add Cortina Systems CS7542 TRNG driver
In-Reply-To: <awU2-KjkZB7WvqfX@monoceros>
References: <20261123-b4-cs7542-trng-v1-0-92d9ffcee531@gmail.com>
 <20261123-b4-cs7542-trng-v1-2-92d9ffcee531@gmail.com>
 <awU2-KjkZB7WvqfX@monoceros>
Date: Tue, 24 Nov 2026 11:22:01 +0300
Message-ID: <179550852171.3.3520172407021510093@gmail.com>
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="fixed"

Hi Uwe,

Thanks, I removed the redundant linux/mod_devicetable.h include in v2.

During the additional source review I also found the vendor's A0 reseeding
erratum workaround. The driver now checks the global SoC identification
register and limits hardware reseeding to CS7542 A1, rather than adopting
the vendor's RTC/timer-derived nonce workaround. Our Almond+ is A1; its
identification register was checked read-only as well.

The built-in and module ARM builds were repeated with COMPILE_TEST=n.
The A1 generation path is unchanged; the new guard and its error paths
were tested with the actual C code, without claiming a new entropy test.

Sent v2:
https://lore.kernel.org/all/20261124-b4-cs7542-trng-v2-0-0192937b44be@gmail.com/

Thanks,
Fil

