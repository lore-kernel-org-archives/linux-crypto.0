Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFEE34A3B1
	for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 14:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768142745; cv=none; b=AurPCYE/lM18RWow/wUZmXA2zz57E6Mmwtdru4edWptLul4GfPCrqxXEpJOH60ivkOX/L6jTTv3setvD8jOdCXd2BrdrtxDGZ/SMEJukbuzP01PSikmXMBGIyvuEThPZG+/2qk0oKY/HxEdRBxSxw632n26nsuU3kRoLsFwA2RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768142745; c=relaxed/simple;
	bh=8+o9CrQDP9rR7vhYrkmBD4TEK1Ah1Um118V33OBjIn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lu0a0WjYjVYLfZqSSAK0xesUC1ihYDusWrQ5db3FcBGYYD8s8Vd7kJuP0DXXd8ApLsjD6uiEb8XZcojBU2M88S0PaU58GEe4JRmjgce4FGAC+QWTzJ9VYjyo8sSJhY2kfEZ4QOo7EmeiKD/1YzMw2Bj0KWiA8n3ZMUND3lucgvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=g58+wShN; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="g58+wShN"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6505d3adc3aso8879913a12.1
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 06:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1768142741; x=1768747541; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lfDtjbPnZQpFER+nbClQWcn44IBaDvTgM6H9iNz+Pz0=;
        b=g58+wShNUGm4cSq/cIFs5BcjtBtziWlVwOnRIYJ0JBVThU79/8vxkDEUyOzt7AzJBB
         cTZ9e0Q9nDikPkEBLmzCCkAYBMC9A64/OO6AU4Ed+EOGygTBTQEKuknv7Bvpc0Hq4pfW
         tWuCEazhna5tzsEGgmV/QS1mDV7AI8F7irWQCIvLFAdd6UBceXKAjkUon+m8Sp9IuWPs
         p2XYZJYaezhBjl4awlNqxLX5lYDftU2jHR0SSz7JmKdP4CM//mkBYchNBUXZFooCPe+6
         dp21GWl3JMqXh5qWiJlPzG2nBfXylKpA9kssFDHJxDnXDPKiHgK0Z6Kpaw+F7SivT7OY
         h9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768142741; x=1768747541;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lfDtjbPnZQpFER+nbClQWcn44IBaDvTgM6H9iNz+Pz0=;
        b=figKQUHO5GMELzX7bJrUHXDL9WOn1NdcpNlDbfTQteZWik8MNoiFWyO2p/sl8i7vnL
         /ttvqybeCpfK4R//i7YLDHdJZmELHHGHfnsGPYPtAaIe7QtTChC/rdOIdpzWuYsffcnY
         GarA3adxBtoYmbgHwglF3KM0srHTPMqxthDAw9DeHMye68oRtnzo2MqHb/SIrwB9pTg2
         AjQ7h27wr7KhUyR5AM6pxxNdmGnes7/MUruaJwG3WPFoUzuRpsBLnJQkMGivyNAfNS2O
         ZapB7URXl1SZSDdDPNXPcKNqgaAbc0PugOQrfqsdJ/8TWQsc3NSMrB6Erox6u5gTFtHl
         XtKg==
X-Forwarded-Encrypted: i=1; AJvYcCXZ1QAocubLi0N4UTa947+TkK0h8i/QiGY2tJmRbrfhcW6y6p/QJ4EuB3gUf/A4A6Hr7K1oCE7ZCWr5+dY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwG7n37bQUIrZzzBkQX5Ldyq/7CIqoqaCwYf+BCf0WIvdm8nXUU
	JACeHYGjrXDRam/ZOUifa/5DxgKy4aSSsJaqy5R3ayzYS9+ECrvRY0kTffBbq2gRxSo=
X-Gm-Gg: AY/fxX73J+Vn449yKTpiVBSPHYN/fT/Ih5wDp0oDLBj42/GYPrNDbQf0i/vKNW3JjGy
	VkvCXwqnqCkgrQp0LRRQjKXlmH1hJcIFYFynwF29h95RSx0A2EgI7hx+x79ewlRlqin4TDUl5d3
	zv2xZOlCqtcAlImSc3E2T9A2KpFoGObvEBJfFsTeGM+DglvPif0EqdP+T7/LUz3VluURLWkud3Z
	SbVZHySoepG0jSwW9HXDKsITUcXp2RxUiXMKbhKf6wJ1fEakZAHGORzRtfACBsPJz/Pd5a3B2+c
	riK21FaNlCyzpb1sO8elm4Fv2QLsIOK8kwXE8DhzMsgUpKWHoTrej0y7A/LVmzClPMMAZkf9oSW
	e+QWLnKbG/3bHL3Rom7p/F1xX6FXomy0O5K8N0X52DTR+LXF85KmIRKZbeQylGFniXWEia5Q2HN
	ykE2QbsKYiob2kKCYgrTr0bQQ=
X-Google-Smtp-Source: AGHT+IGzzRSG9JPiSsYLBto386guzGNBLdjrzZm8+JQDEKUQ0tWs5J3FidjE880cd/bBYxLZJrvW2A==
X-Received: by 2002:a17:907:9455:b0:b3b:5fe6:577a with SMTP id a640c23a62f3a-b8445169517mr1585237766b.8.1768142741298;
        Sun, 11 Jan 2026 06:45:41 -0800 (PST)
Received: from [10.216.106.246] ([213.233.110.57])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8706c2604bsm260020066b.16.2026.01.11.06.45.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 06:45:40 -0800 (PST)
Message-ID: <555883af-66da-43a0-a4d6-bd3bc52581b6@tuxon.dev>
Date: Sun, 11 Jan 2026 16:45:36 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/15] dt-bindings: net: mscc-miim: add
 microchip,lan9691-miim
To: Robert Marko <robert.marko@sartura.hr>, robh@kernel.org,
 krzk+dt@kernel.org, conor+dt@kernel.org, nicolas.ferre@microchip.com,
 alexandre.belloni@bootlin.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, vkoul@kernel.org, andi.shyti@kernel.org,
 lee@kernel.org, andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, linusw@kernel.org, Steen.Hegelund@microchip.com,
 daniel.machon@microchip.com, UNGLinuxDriver@microchip.com,
 olivia@selenic.com, radu_nicolae.pirea@upb.ro, richard.genoud@bootlin.com,
 gregkh@linuxfoundation.org, jirislaby@kernel.org, broonie@kernel.org,
 lars.povlsen@microchip.com, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
 linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-spi@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-usb@vger.kernel.org
Cc: luka.perkov@sartura.hr, Conor Dooley <conor.dooley@microchip.com>
References: <20251229184004.571837-1-robert.marko@sartura.hr>
 <20251229184004.571837-11-robert.marko@sartura.hr>
Content-Language: en-US
From: claudiu beznea <claudiu.beznea@tuxon.dev>
In-Reply-To: <20251229184004.571837-11-robert.marko@sartura.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/29/25 20:37, Robert Marko wrote:
> Document Microchip LAN969x MIIM compatible.
> 
> Signed-off-by: Robert Marko<robert.marko@sartura.hr>
> Acked-by: Conor Dooley<conor.dooley@microchip.com>

Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
