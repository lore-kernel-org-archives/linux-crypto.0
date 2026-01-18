Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C801A32B9A3
	for <linux-crypto@vger.kernel.org>; Sun, 18 Jan 2026 14:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768744995; cv=none; b=a15S/NYXF+bwbzQTVDoEKLmx0lxfWdeOCTJfUOpBEoxKkytiqTRX0LSRKFuUk46BOQQZAoWVZdv9eXHX+ejIytX0fs82OSXG67CIr/cZ9KmZL3/mHyEWRj5wk96RPsGXt0mJRc3Gk/SbQct5TVfj0R9AXHs192LLcc1QRnEPI/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768744995; c=relaxed/simple;
	bh=/GsF+Uwls1Cn2yinM71Z8W+ioXcZeW9vpkl4szRkNjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rFqA0IddFy5+EaOp7LWKZFze7N4nscVTFMjYiqqWE2Y+rAw1xpd8LtSbNK7ffZ7vT2S+WJnw0zMXMztWIyO9at319DpQWCRBvBnq6LfYKsF+ZF3PeQXYqbCD6j0AHt2ZWHiUjWF7Un15qTOYRcBc32iW2kX7GwW4f2MhlqQPUTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=AU1u6WOt; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="AU1u6WOt"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-47ee937ecf2so24775495e9.0
        for <linux-crypto@vger.kernel.org>; Sun, 18 Jan 2026 06:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1768744991; x=1769349791; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IMK1YqKVaUf0IoyRsQOMCKJ4gS01F7A0JEX5JckEMXs=;
        b=AU1u6WOtLoi8xhtxE3eZH2de7tMEOJBbWbxjQ3yhiZkjPT2U+TxzYsQSeFKocZiPFp
         AfUR8WeygLNHXiE9Viiw1RtzFAsj1KyVxaWitGd2d8N3ANyj+Y7kO43+hm5JZhbBq+Lb
         lPvGKm4ZddOA32TKUnbLjuE3F06FWBpu3jNeWG8PxL6W7eEJcdrnLaI8SrtPWsd/V4W6
         +EAvlq2BKqQ/VvftFp9V9f78dx1EN5wahowO2gdSHzutwK6Z8mTGZRreowFvAg6oCWZ7
         I8ZU60NADPdABqce0/chNtZRxbKpG3J3sqT37gvVSYI6RT6C+EjRstJOaUfYQFkChaEz
         m0SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768744991; x=1769349791;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IMK1YqKVaUf0IoyRsQOMCKJ4gS01F7A0JEX5JckEMXs=;
        b=o7xu120EalAUyQzyOLj8KNvdAAaZboyr3cCEKeLldnD1bLm28oeP71JyQEW67mAdgd
         F6g/wsBgGtPDio6vSxYa6BTjl1rvRyCg90GI70G3+Je5t9WCu19FJitAemAp1VUzZQRU
         rw/I647pXNfrhn7nNusZYBgJFce2dcI22Ah5ef9PnwUvGA/gbvL50B/HRLSH+82nL0+7
         Wwr5v7fsF7DDOv0dlSn1MaoCIJ59A4L9X1dxyCyCNwNnqtMvgv30nkbILVAJNo3Srz6q
         4ByFhlVu2yCpBAJIoSO5dElXKF34MRpzpQYGxKHkEVHP0FZmIh1EGIMDaAxKLGSjl9Uw
         Dihw==
X-Forwarded-Encrypted: i=1; AJvYcCVO4PrjsRGlWfQRyL6faGIrxKLpJCj5DbI0VBFueYrpaU/ZvwtQV2w3beDSPvwkFmBToal9i6/8FTD41us=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj8uFwcquhK972OyWWgHm0GH+HaXrdLPCjNwHp5CilkONZVr2C
	eixEJuZthL8q/7tk7aF3mcpTYewOKtIgyi2GCKC/3zFiwUmf1BI5lT3Qz0OgxBl7A+o=
X-Gm-Gg: AY/fxX6RBiQIfhjKA/EZmF+S4PISDAjaqpV1OG2UQCs4uyvp/p40rD2EldBNdbKYAzP
	S5XUjvNiNGnWexZg/ARUSL0rPnnCWmGktBj/XPwYQL2Goymnn8dvdcFUazz19zmjCBh8k2S7MMD
	UB08P4koOYJ200X4RqtRUE7QZeQiWfJyHAKa+bq9NIgcecEI+qS21DFzkkC0XL7hMbf04Z2pV7e
	BzeqVsMgm04ql0Uirfp/c8eIx8wMfM9MpUm6T7rZTSAhCIOpQFRU25TmxH9cXLqXpO1oduDi1xZ
	d1TDHG9mGyOoEczrp2QIsMf1GousxoLTHQMl2PmcyhKnuU31iYH6MPISuYmNP5yiF5bKSyuUvBg
	G9r+roELreaay10EX7Kj4uGTKvVWBid1nTeDo37yJSL4KK/UyIWxiCf7aWuBc4KMddgQSbDY2Gr
	EuBTL5ULPdDSIjSP+FpA==
X-Received: by 2002:a05:600c:4da3:b0:47d:7004:f488 with SMTP id 5b1f17b1804b1-47f428f5e9amr84049025e9.10.1768744990847;
        Sun, 18 Jan 2026 06:03:10 -0800 (PST)
Received: from [192.168.50.4] ([82.78.167.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43569921df9sm17725892f8f.3.2026.01.18.06.03.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jan 2026 06:03:10 -0800 (PST)
Message-ID: <9c34b805-8c6f-4711-9718-6c39a141d451@tuxon.dev>
Date: Sun, 18 Jan 2026 16:03:07 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/11] arm64: dts: microchip: add EV23X71A board
To: Robert Marko <robert.marko@sartura.hr>, robh@kernel.org,
 krzk+dt@kernel.org, conor+dt@kernel.org, nicolas.ferre@microchip.com,
 alexandre.belloni@bootlin.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, lee@kernel.org, andrew+netdev@lunn.ch,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 Steen.Hegelund@microchip.com, daniel.machon@microchip.com,
 UNGLinuxDriver@microchip.com, linusw@kernel.org, olivia@selenic.com,
 richard.genoud@bootlin.com, radu_nicolae.pirea@upb.ro,
 gregkh@linuxfoundation.org, richardcochran@gmail.com,
 horatiu.vultur@microchip.com, Ryan.Wanner@microchip.com,
 tudor.ambarus@linaro.org, kavyasree.kotagiri@microchip.com,
 lars.povlsen@microchip.com, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-spi@vger.kernel.org,
 linux-serial@vger.kernel.org
Cc: luka.perkov@sartura.hr
References: <20260115114021.111324-1-robert.marko@sartura.hr>
 <20260115114021.111324-12-robert.marko@sartura.hr>
Content-Language: en-US
From: Claudiu Beznea <claudiu.beznea@tuxon.dev>
In-Reply-To: <20260115114021.111324-12-robert.marko@sartura.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/15/26 13:37, Robert Marko wrote:
> Microchip EV23X71A is an LAN9696 based evaluation board.
> 
> Signed-off-by: Robert Marko<robert.marko@sartura.hr>

Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
