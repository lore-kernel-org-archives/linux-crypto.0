Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F9C33F8AE
	for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 14:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768142768; cv=none; b=o6BqKTam8leYA6PKD++TnDP/IHX3q0K5jAcP3BkTN07G0OfcgB5Vuhe1l1IWXj/8IqNI+A6ynQbQwNeSq8lpCYZEmS1BkqydXZTLj8i98lNTMyVYqTjkyY2tr5rbSyFWXy9vMkFghb8y6+HQjd7if7anbpG3+8/l0R60X+0byT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768142768; c=relaxed/simple;
	bh=E3fIUBLPFnEXAfwoSTB7dOLky4Cj+/epBMllkCL2GpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S4ipeaNDt54g6LxAMFHhXYXvDEhHUwWUKbm6XAQk9K8d9bIOYtMw4BmW6ppotHXkUczSFncl6qa+jHh0IyUsl0TxmhRDbPFEGSoXTPl+98TgpOqLA2OnfIGYWVXRWGb6hnh8Q5FybhEo3MPC3NIDvJj7eyUlDChQYekxzu12l/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=ZFz5/xt1; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="ZFz5/xt1"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64b7318f1b0so7925578a12.2
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 06:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1768142765; x=1768747565; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xSh5A9C/ikcooPDg3GNmd0+fIcS/l8zoJ1QKaA55bnM=;
        b=ZFz5/xt1R3RPg0IfhqILS6DeIcAi+Q7dknvvl7zujx9QVOvzKxPv6PbFWkA+xsWdwy
         q4RvbDBtR/HjlASIiVjVE8AqQ+cFMmSpSmHz/9zLrH9twpLhuoDOp2ifbX2+2rz35r8W
         EZggkt2Z25Ce3wkYydKW1eTb6s6zNkVGI4+qfKwk56y0v5hgCqKDZMbRcQU8iiV6WcXD
         bNlH8BXPaurlSjuMuJ8jWyp7GKnMkFz+dHJmqtCjFfpct6Tch/J1+bYJfTm+imAjQNT4
         bYlIO26xS8CbA20ia+8l9ila1DeJP0BiFxQQHuZUchuSBxxfuj1eBGaY4zansROWmVws
         ybLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768142765; x=1768747565;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xSh5A9C/ikcooPDg3GNmd0+fIcS/l8zoJ1QKaA55bnM=;
        b=WMs1SkJQtLEImCpp2/HKu9ObyAbMxIY0lezyX611QSXvuN7ZhLt3rH6eBeJZlkO/cv
         akSMEoHR2DkR4T15JZzS5nruJGT0wIF12mB9foyaFEt7iUzdO2snU9vRuUnubzU8PyGM
         3PE7rbvexkhv1Vd+rHAmFI7PWI/D70CQ/rfiMaDsUYwcNwO+B9C/6zEtfMIuVGrZVccM
         NDYJuHOhyNp89lLVZsxnf0PR1LUTBo68/DZXZKKZ2rXKRw3NR5ubxY4heNeC/QJ2QC7L
         9GMWbonFenqn3uBl96KXGAXwzDqaTfxAUtUR0AZdUXhpEYNzrk+gJeMF54+Ca8oxINBI
         pC8A==
X-Forwarded-Encrypted: i=1; AJvYcCVmoMOrcKCM4qcR/wlVWAYhK/OQMUt8r7UKH+chkrVR5fwdqW3ngDMiD50dsR7JJK/PD5NW5opVfSy0ZIs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9qhEbYLWfJlubdCe67/IAO5k12nxHypAaUGS88mFLNZ5mOMme
	bfz7LqVg9OaF03wrUZkeuyLUgIQkYFUKg8pyCa1+B01pIQ/DkS8hNSHxGd0jqu2mZqk=
X-Gm-Gg: AY/fxX5dyLng/Ugov9niMzbXGkO11Vn0tF2fIyTGyfojZZU1/eUGZI07/ZmsPf+O3qK
	YloGkTy6Uv4ki5Kp4Q4w3ILOOAX4fTTSKyvWKaHQQlYykJWtWM4N4C6uNMDmXKtcvaukLymy6k1
	IT3kR3fEorrqGXDMBUJS/jnOapa7Obm4Fd6WTbmtoEjLGcM+1L5PS50UC9KiD3KZVU78+n0m4k0
	FO27St7lmkoJXjCj+eXiVvxEpYDZUFV7XMMWeINYVFXA7LDrTEd3oaCz/fbzEr1e6oSF4wYZd68
	ZgIy1v3emE+D12hpk6qOiXOQITjS+Ircyfhxl0RAWLCtPSRptiQP6qZAMvOC2mukx+rLT9SQNL5
	uSR0CXAgn9l2rFLWDLA7/zS4+mST9VDA8HpD6I5Rrpov04oJKQJf21kigujaTu1P714LRx5RBE3
	7a2HodT0ugukIB6TWoA4DZSSI=
X-Google-Smtp-Source: AGHT+IHdSgN1j5CfCwzzuZuuUE6k4oOsy7A6FyHYN7fpU3s7QMByt1Yrcz5j8phSUL1uwYAKt/FfvA==
X-Received: by 2002:a17:907:3c8a:b0:b87:1b2b:32fc with SMTP id a640c23a62f3a-b871b2b3d67mr52172166b.0.1768142765029;
        Sun, 11 Jan 2026 06:46:05 -0800 (PST)
Received: from [10.216.106.246] ([213.233.110.57])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b870b0dba4esm216046666b.17.2026.01.11.06.46.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 06:46:04 -0800 (PST)
Message-ID: <dd70bce6-77c5-4d73-96ae-6a0bd8ab7b22@tuxon.dev>
Date: Sun, 11 Jan 2026 16:46:00 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/15] dt-bindings: pinctrl: pinctrl-microchip-sgpio:
 add LAN969x
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
 <20251229184004.571837-12-robert.marko@sartura.hr>
Content-Language: en-US
From: claudiu beznea <claudiu.beznea@tuxon.dev>
In-Reply-To: <20251229184004.571837-12-robert.marko@sartura.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/29/25 20:37, Robert Marko wrote:
> Document LAN969x compatibles for SGPIO.
> 
> Signed-off-by: Robert Marko<robert.marko@sartura.hr>
> Acked-by: Conor Dooley<conor.dooley@microchip.com>

Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
