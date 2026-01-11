Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7AE33B962
	for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 14:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768140344; cv=none; b=o+ZsjfNX18FWBfjtzinGT3SZ11cFPXvpu/6FoUuw9pW8kLKgFC0TmrODQOzMjh+yU6RE4TwWUMoSHayhswkrQitjzDvNDgKNaHYNinyRz6j1SJKLLc0UzOBzNZz32SRq/Z+ftvjWrCD26CVcbOKJw9rvwyO1SbQ/yph2tCfoyIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768140344; c=relaxed/simple;
	bh=La7kZA2oSwRqBuL7cT5ghruILrR4PN0GG8fEmUQohxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lvtP5cEU6nDnTLkc7ZkPl0NLcMJFNJ3gOlKR31ad2YZkhBfHdbWNNhnjTFlPct8b22oIIE+BTLm4k273Bv1MmXP/9GP35EKLDULO02bBMXppuTHmHRylIq7mjds/+guwxF00aCaTcYUQ48f0s4hedHiaW6MehKiQXN0InF1KH10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=A5h3J93L; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="A5h3J93L"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b8010b8f078so925387266b.0
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 06:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1768140340; x=1768745140; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TXunsOKck5NLaqPP1pj13fhYNQN15zYs+l2jwEoFO8U=;
        b=A5h3J93LIBKbImOKSk/PuMD1cA9Z5C6EZEowbXbuQQWRqoIAibYcsoDlQw3TBJfR+T
         u0BiOjCEJXktgpsZjOdLv3j4NKLAL6vWzf02hINhGw9gtNLdyMqKWd3DOyEcZSvo3jYX
         8ZK4HrP0vXDrFAoG6NVNSCZ3YaSVLqWlNr0VD2t95cLlw4Jh61dPCSWNeQ6oulesS2tN
         wj79fRG7ILgJ3A7li2jIzTbZtZZjrXs2jKlLHtMo0WNwEe++CfnFmumACmX2K4HiMsrY
         hZYR2bZ1STtKcGYBa3SuMqw2+bwsgdTMBUMyBFpULbdi1sES9VrFIvs1UBE/wqWbzzwP
         APAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768140340; x=1768745140;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TXunsOKck5NLaqPP1pj13fhYNQN15zYs+l2jwEoFO8U=;
        b=smOT7QBTM+syD2qmxDOXsO71A2bQKmY5/jdZIygzcbWpGcw2gP0tIyP2/mI4MN/SKI
         6nxbl/WahFAJ05YtK3QyI8eqoT0wn1FZNgCxg4grl8EoMZDRMtKGoMngLmkx9g0Ft9GM
         2/KnrSX0ZmLhNv7eCzIOUPEJnIuOoi6yPss5KmTQD4Vm8J+gx6ReaJD1ih2gz3T7CwEI
         WKcVNVNcccnUqZV7y7vZJOdDvM5ZvodqsHT4+gNocpkL+TUBNN8y9BB0NGXF/E+Nittu
         mVjocXj1vr2oqkUrwVPP8dKUVFpkFiR2L7k1xlVtPFLuiy4+kW+8gHLq4okYMK1fx90N
         8JTw==
X-Forwarded-Encrypted: i=1; AJvYcCV6GjiaPDC6slTq02Mn6RknvEHsZi812t1OO89FVacQP2z7mgw4dLMKHPcbEhYeBjxBDt8DYYZhYBs2+0E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzB2o1FQKjmUppUDKR/MDUGP49zfHQ2srSVuYLrreChSiHNAiEy
	tMfpsSfUPCmB69Qls29LNMHyWbm+g8iIIOHgLKJFf7lkjE1O1zvBaSDmCq0uV1E2XEw=
X-Gm-Gg: AY/fxX7MvZdgi5/wBUijTj5QIrIp2kGMeQcRwUVx4vsyYCMRLV4kOJl2IkMXlnOsNpw
	y2le002l8K/nJl/iiwwVB/vaPc93WNUP5D5bT44QPO6bY4QRAaaIHvIYR/hB33Wt0Ut044s4Fn4
	6iVBZjb7Cc9YbN8zHjb19hDEl4w3980N/mmrsGoMCEvGViqwjP+wefm5krZx6SHhEheWxwQcYqZ
	P9wQj6boRDqasQHFTid8RxCynkd+wnQP0ryiWvbNT5eQ+M/X/dAO5hvhdT5wbuqiIs4Gu8yrGq6
	I6pmtzBmmvGELOSN4aR4Ynb6atmU7sZeOnsSao2BhBI0q6FD/rqOBm1GD6aOYN88mQyZdX5YN3m
	3Ft4DE2x4jKFVHVphUNG1+J54dnbSOeUPHfdEJx777BCU4nEtDJ059UKXTv8Y08pn5tV0tBQt6o
	9Y3AG+mqxQ+pN6jzsSLJmPP91AODlUJ5U3UQ==
X-Google-Smtp-Source: AGHT+IGAomJOik8MqjiZHm7eirNShLlujIRGUrfTNhxgz3sez9ZGd+euk5Raj7DyHYRFF75x4SXADw==
X-Received: by 2002:a17:907:3fa1:b0:b87:908:9aca with SMTP id a640c23a62f3a-b870908b37bmr200612566b.9.1768140340256;
        Sun, 11 Jan 2026 06:05:40 -0800 (PST)
Received: from [10.216.106.246] ([213.233.110.57])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b86f1e95273sm439916866b.62.2026.01.11.06.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 06:05:39 -0800 (PST)
Message-ID: <05184245-9767-45ef-a4a6-d221f90fd20b@tuxon.dev>
Date: Sun, 11 Jan 2026 16:05:33 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 13/15] arm64: dts: microchip: add LAN969x support
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
Cc: luka.perkov@sartura.hr
References: <20251229184004.571837-1-robert.marko@sartura.hr>
 <20251229184004.571837-14-robert.marko@sartura.hr>
Content-Language: en-US
From: claudiu beznea <claudiu.beznea@tuxon.dev>
In-Reply-To: <20251229184004.571837-14-robert.marko@sartura.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/29/25 20:37, Robert Marko wrote:
> Add support for Microchip LAN969x switch SoC series by adding the SoC DTSI.
> 
> Signed-off-by: Robert Marko<robert.marko@sartura.hr>

Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
