Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC2934A3DA
	for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 14:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768142711; cv=none; b=KdcdL5yCsEsO53E4AGht6st0xJVVdYpBuEG/LRchFKqyCVW3SO4eT8xydIMlpLlq0CId50AMJVmsRkOzRwwq8jJhLi/azsLTr0xz5YKXLExTOQPI2m1bHEIKMxuCNCk5Nr32/JsRhERJobjvvTma4jY02mbPeIfh4/4M6SOjt3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768142711; c=relaxed/simple;
	bh=gDiL7diPPllfiqdrICUaz2pklt2cpfwEzlq/42pPJS8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V6sbWRdwMSl8OrPv4yOuwuAiioTyWvljLJrfT6sArFUjqFm+NcdQX5FE1q5625lvb46BMN3Vpd8+ozAUhvIJHckCiv4gOZUqZEepuKXo94M4waSauixIB5FKGEfXhF9BpQQ4BgBi9xQFI70gh7XzejlwUzYrP9O+NSQlRzl2Z1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=K9ADx+2q; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="K9ADx+2q"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b8710c9cddbso52188066b.2
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 06:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1768142707; x=1768747507; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bR5pMB9Z21CNTk1B6+opWEfUH+WjtdKh40K9u7GvYSs=;
        b=K9ADx+2q85hi1Y4+enhphqyqyZpZ50jBbUQejVQ9+lAyuPt1J7eUMJcsTH5Bdu91+/
         8uKGBqR2SSjJrxX/lCcEn9SiYTF/WVBgYkIGEyzvckX0wje75OhEfcmjaMUigKJwIZRs
         e06XzNxpm7i19SZ0LSNbNWyN8H9SmAT8nuB4Q15uT1Uv8OpT/U/AiGflgqftkaUx04wS
         FC9tKAq3ltBYaTZkCdn5SXY0EGMBHqbdzuQwDPZYYV0jMRzS64ApUPcVOjXPvySqbrOy
         U8+WS76PxjSbXLX1BI4gqBrNFoWcvXvKZgA6KNPOhcW9KOI4VzIXbxSQNQP75cdKv3IF
         4osQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768142707; x=1768747507;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bR5pMB9Z21CNTk1B6+opWEfUH+WjtdKh40K9u7GvYSs=;
        b=AIDKQSEK7Zaq3R0PnwtXoWzvqTCvQCTOv2wOOIs4lgWDNR3BAS+Pdy0aRsGbScYYqp
         ujMJjPMlTsmpjZBilVVxujmhwFJikN3PDZfHhYP1DOhVR0L8LzvlAs/HPkyeJiJxxLD4
         HsTR3e6UcUpKA4ihi7UdQqB6ymYUpDPhjD/s7Dm9wnUlvVD6968YD/0kM90bOGY3KeTN
         DowT7N6xqiTJdzfm11TmV+w/hHsw1Zk7/UbFqBLu8JEvbNVvR2cEq43HEvWpHzbBxAMa
         ewkRdbIToM2kGM9EX1W6ret7WsD7nMSlrPy3IxmXt9c/ltM0ZimqVReg+e8voFgfp3Kr
         IRPw==
X-Forwarded-Encrypted: i=1; AJvYcCWnYcd+gfvTetq+HFDgh9B2KBGRLVBPt4Z5cSSDywUlVqePCtctW4szbtHwsWhumCHwb2zwKcQXwWhujFk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvD0F0u8czqJdjo0Ms/3qxYjLO/Xq5NHZWtQqIZsO0BemKSsGZ
	q0ZemTYOgytC1x4Zn8wrYdj1MJBvy13cA2opZfVOhvSlJ6mW1+c3KCjVd3gp272hOMI=
X-Gm-Gg: AY/fxX7Ceqwq11fldoBcIp3XaoIqXeTESmYbm+632DEPqJYjnP07vODPScladv501Qf
	Asr1K2XgVbkrCcVH1KOpwKxFfeRFBifp5+VheVpgTo7dwlqgSas924A5w/UYNzaSWlIucGJ3cjX
	3tDiBkfRsKspkSlkEuYm8qRSm/sngdl4E9XcN9MEVgx+eUUxwmtGbN3zfe/z+eNH1lFLxDCGkFW
	trqUQKcTiFAnPiuJTz8i1uGiXg+QBk7DEmjiLlLbR/7gCWisM1wrODN8tQl2VlRTfrEvglKljIR
	y1DOAuWshKS/+LVzYwBMulOPB1sgU9Oobx5PwfEz4dCbJBqiE5ycmv0uMFcL3fVtAykHhpE40L/
	ODAQOLCalVSqsH/LZfcgoC6REL+QjWFh+K9Z4zQGGDgxADHqLfidwuylq6slKLM8d8Mua1Z5SUi
	lJQcCDy/T+7K+59k6+4OhWk5qj/uyT2eJoHw==
X-Google-Smtp-Source: AGHT+IEnRprofKW6iUFW+aOMnt2p1AYruny/NjK8tSS/dtcvBYVRc/tCV4eudi2xBk8lGr0c6zLI/A==
X-Received: by 2002:a17:906:dc94:b0:b87:b87:cdbf with SMTP id a640c23a62f3a-b870b880077mr194416066b.53.1768142707046;
        Sun, 11 Jan 2026 06:45:07 -0800 (PST)
Received: from [10.216.106.246] ([213.233.110.57])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a235c0fsm1673227466b.9.2026.01.11.06.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 06:45:06 -0800 (PST)
Message-ID: <19f25a94-fc90-4298-b3ea-58bd66cad11d@tuxon.dev>
Date: Sun, 11 Jan 2026 16:45:01 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/15] dt-bindings: crypto: atmel,at91sam9g46-sha: add
 microchip,lan9691-sha
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
 <20251229184004.571837-9-robert.marko@sartura.hr>
Content-Language: en-US
From: claudiu beznea <claudiu.beznea@tuxon.dev>
In-Reply-To: <20251229184004.571837-9-robert.marko@sartura.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/29/25 20:37, Robert Marko wrote:
> Document Microchip LAN969x SHA compatible.
> 
> Signed-off-by: Robert Marko<robert.marko@sartura.hr>
> Acked-by: Conor Dooley<conor.dooley@microchip.com>

Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
