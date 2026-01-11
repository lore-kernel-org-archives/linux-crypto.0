Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FF93491F2
	for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 14:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768142730; cv=none; b=til6awouU8RZF4eYUK6/qay0g27Lr6v+aljYIOBSHoyCMMGcutMeYlLMuJ8jXyBJLPIv4gSBhfAIPtgW/qbnATlzXeKqyqnVIrPyWlpSMdEmdhaTQYo+nNI5Nk5nqqP8lZjG2TapxI1KzCXFmzbpS3iuLC64HmAQnxuRjg6GhrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768142730; c=relaxed/simple;
	bh=YDHNGLJfluFKzT2RaL2uk9Ugi0ok4Sk7jIeMDkApg6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VPrxx7CxX55DtYc8w1/3F9UGoggDk6oWqqymvK+4OPfl2zlox1A6Ti+buGioxZCM3saW6yocBos36IQvxVbI81TWJWhsUdrcNtzW7SQvIisRj3T9M7m7vE15uUXGTTMa7k3dDtkXVCnfdpKePmtcGR2dA9cy+TL2OVdo9caMCoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=X9Wk2tta; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="X9Wk2tta"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b8719994ba4so21468366b.1
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 06:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1768142726; x=1768747526; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I6rwalswAWwTHAknUrP94zFyJo4NhuP+T6GegkCWM/M=;
        b=X9Wk2ttak/FxxYeh5WLK137PvXT2Bo+6f4tTd7DoZEvDfH1xyhWoL4n6yF/gvnCw8z
         z+h9Pq1VYPIop7EYoYHEF/ZvxNpxMSSGAdL55uhaBcqSfbLSS6+O0g3gtUKbcER1Z7IK
         s2S2cmElL/gpcQWFvwhm/u+qSVXzl+qK0VjAc1Dk2jlacBc88hyZK8whHoOR0r+uNnl3
         9BPa6sdp3h6wLWdtn2N8cV2+HuBUCgov4KQjwoG6XwRdQ8sxApffjIH+TQL/Pc4vRPxm
         y7mX4RoTw9OGMaAtnsluf6omcNfoTTI99nG19wYn4YbH2bFtmLM64ISHwLjSgcuMJIRj
         qGGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768142726; x=1768747526;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I6rwalswAWwTHAknUrP94zFyJo4NhuP+T6GegkCWM/M=;
        b=cHflfEdo5gt33C7XstGoPpbQA7HFpn7UYzoZS/zzsV1hUrDHAnMtKiZPyEGDtEhydH
         Bujl9Onem0fJgJR2dDWaJ09PqOC7eCgaSJFgmzlbEYdeMrjBrLVMWxvgye36krCtgxLA
         r910csBQKJ4Y4KuANPG1xApwdp0Aw68iWVxK+RUACPrukD06sRQZOLP0YSZ+dzHwaJ+l
         vVp3EbTxo+5Y3oEJqB86T4xjkhFzqIgTOOyUVGHep+qJJyeQofuySqwVeE5q4ZXBp0b2
         ejkZOtz1+cAP3/pOKJAsFr+zo29JiLaYcvy3kDvRGluJ4xIB1XRuumvNYPX9UsmIDtR5
         xwzA==
X-Forwarded-Encrypted: i=1; AJvYcCWcwh/rNj29GfFZUxnDBSqjGsBQAZ9JxQb/A6o8+nDFSgF2jpGcqxdbgLzdP8URBJmo3s83zM6oGpU8YfY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWtJXSpwTsukPhyoSbasy+wAbGE1SVR9dbsRw294EnzipSblY1
	C0HeP+YZ7rqzK+HfQfi9foMdW1p9MT6Kra5KO+xZyjoD8COzCEWstGHm0aiDqLSd4Do=
X-Gm-Gg: AY/fxX51Ho2yRgXYZFTtd2u8HNsPKA+uuxhltELIQxVK4X7IHfiw54sTzaQHq+rJJtn
	fGVB2X36U6diW1DoSs2OLK1t0/iEQwr+5aeOpOzoTcFJ7gKFUHf5RIHSfHmYfy1efU7Oe4T2ZqH
	XcSxLFXnvp2jPlwt8m+UlFDphDeTvMEJ1kVLvwG5SEU6JIvoJNvLLNNz9IkS5mMFnBUU+w5l3wu
	frAdV9l6jL2zPRZTwIRnco7XUiA75KwufEqAcPj85m7bmwOFYNyYV8EKmmEn3f6zJ/VMB9bpFGC
	Mqc/ZYo2Mz7LyNBFgf17O+mBDejCzZBwqPDBq70aswXNUslGJT2b1dfB6I7s5dfW41+N3pTP81e
	xAFWovHN9IU68u294dFDDQbWi3lUW1tDoVNBEdmJ+E2y6ZtFOXXv4lqrtcJp5ZKg2nO2kbD22vt
	G6b+cUHChST1KQfBRm4rFXIIQ=
X-Google-Smtp-Source: AGHT+IGvS7IBApFn5Y6caZIpVWCcEKkW6+CPDWe6wxvm6P/BpWNKX4ZQoy1X15u9d+HjeZrWR8LDZA==
X-Received: by 2002:a17:907:6d10:b0:b84:40e1:c1c8 with SMTP id a640c23a62f3a-b8444f4afb5mr1764352266b.33.1768142726523;
        Sun, 11 Jan 2026 06:45:26 -0800 (PST)
Received: from [10.216.106.246] ([213.233.110.57])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a56962esm1699865166b.66.2026.01.11.06.45.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 06:45:25 -0800 (PST)
Message-ID: <7081b61b-599d-4a59-8a27-291c55a0e52a@tuxon.dev>
Date: Sun, 11 Jan 2026 16:45:20 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/15] dt-bindings: dma: atmel: add
 microchip,lan9691-dma
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
 <20251229184004.571837-10-robert.marko@sartura.hr>
Content-Language: en-US
From: claudiu beznea <claudiu.beznea@tuxon.dev>
In-Reply-To: <20251229184004.571837-10-robert.marko@sartura.hr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/29/25 20:37, Robert Marko wrote:
> Document Microchip LAN969x DMA compatible which is compatible to SAMA7G5.
> 
> Signed-off-by: Robert Marko<robert.marko@sartura.hr>

Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
