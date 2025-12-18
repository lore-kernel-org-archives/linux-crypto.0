Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DD32D5432
	for <linux-crypto@vger.kernel.org>; Thu, 18 Dec 2025 18:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766084335; cv=none; b=hrd8ayCmSpLajckeq0DHnvPTwmk5W/xzTir/Ecco8nxkai8jo9tvGljf15SKWDdzkuAZcWgmUV+nJnYVHM52mKIkj0bbelj5FSBgiUZHThsSnOImDzxd5673xP2TOJdsEmcHekFKbd/b168XCEsYb7K+XOHmGwz3bA+9scxfjgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766084335; c=relaxed/simple;
	bh=Jku28IM/c1IYSHnKsavbvy9aaLBIgMj3F4YQHgrupho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kdYzLXBKShH+Wf53N5qEOW5ETlBdFEueh3yc7N98Bbas3897lQy3DMiIpnbbbQkAYTENkxf++rw/UcgD0TA1l6tGDf1rL6UnPqf/8+gO6O2dYC7x5ejGlxrw7LhhTr6vz1mKYZT/iUndIU10rKY9tJr0E+n9E3SUTfE3fNl1BZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NzOjmPrn; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NzOjmPrn"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7aa9be9f03aso918935b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 18 Dec 2025 10:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766084317; x=1766689117; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AQfRVSe9fO1PObUKRZHse1cNpjrf0uUXBusNVMTFfiA=;
        b=NzOjmPrn46f7eL94kTiu7+0zvL7EqcBFTL/HGLf3Rc6h3rBZjvJM5i3qCCD2fYrXy7
         eJklrOOWGmpDdYURm2bD9+/3PlBRsY8WKHCZ2GLGzwLcw74QlWuQ3QwUrvnoh8XgWay8
         gOij/Oftk04H9HcDeMjrum7Gp/tJMDS9TcpBQwDo75WutLi+yiY8j3WBiG0hbm0He5W7
         e9CpO9bAAOVDpz+N+io0xTJRBjOcs9kNkjAd+Z+kY0znjtSG4hOPaCJlbg1PV1xakEpj
         cFYP81lVX+QhyL2f1NFGqqWTbtem9suiHwzZLYFwy//KO+NJmpEmbUADkYq65Km/0XcM
         myZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766084317; x=1766689117;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AQfRVSe9fO1PObUKRZHse1cNpjrf0uUXBusNVMTFfiA=;
        b=h+0A6UGZHtSYe1Ipa6E9bAtaT47CG/JYMs0QIHPrlSPQOv3SDI5G2ScTty8oz+ymT1
         8gUd9oG7k/zOA64BpK/NnufJkhQBRLVJCO39RYiZY3NUeWGcXXxdiZzi0uDlDs+WXd4I
         /Hdft8i99jUP6G73s/WEsH10HaVq+43EnPgdewBVdgXuhJRwrFwWFiJ1UPaFQYaiLub5
         yajOHe0lTqGxCiyYOakncVRNICttcq3apLsu7UNLMhNoom8PAg92Ks9yBMG/+FWIl8C5
         HHOVGymNTMwkQmDR/97IFGWe3QTHb5Bu4loEb5CIl2Qe8Gq5ra6Qu/x4KtX3CCY0fDtR
         da9Q==
X-Forwarded-Encrypted: i=1; AJvYcCU8PFezlmofGXAgbT/jI1yZbFGPYaiZYpwEkRmmxSu9xDTMfEnbd2JmzpWi16v0ADNJmJj+PbSFPsfK14I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxFmEVlR+M4X1ipZBklLzJvIECBBI7tW7brbEXFO0UXpYwrb85
	CmlUkPeVAcIKaRwCDRRpMKZviOvp9+otAT9SiDThApckXvWiofNajfnv
X-Gm-Gg: AY/fxX5Yzw5gjTGnhvjTOQwzp1pkA9Ykq+Tarn1dM1UGOq4muARrmT1wUpNXyPWTYTh
	gOYyGjWIrHg8/me7YjFO8eb42/+d8bAZqRmPdxms/lLdLoQ6o4ce//49/tx1EmDenveT9kbrQ2+
	/nOAVKZsWDpt4St6Dn7qfAJmGsCvWiA97kRoL+sEHMQ8V16iJnGhTT348e56Krq+amLlvjWQDKy
	Q567/Ryk9XKhLrTAxSRoSe1GSPW73nODOI1i5CmmSgrrP9hi7WgCqiRT4NJcsdsjOU1FYzM63er
	ffbprfYMwBbfwOSh71O7xtaDiju3hsnnw0I3/Bl/E5M+jzoRc3L1Ah32QCJXtlw6KunC6hXazvb
	Bkbl9iSmih6A2liTAhLw8qKgmYEGM2qI81qxD6/EsAFYS6LaQHQOSCTz7g3xu3EIV1LR7j4KhTg
	U89E0SQd1c7WTQDb0N6MSqqkU4
X-Google-Smtp-Source: AGHT+IFf3D0xeHaQPPXEeazhorZHgIgTwRHiyRuussKNgJjGtFBYIJhQUMgRhb/IHzjPiFdB5lKzgg==
X-Received: by 2002:a05:7022:3705:b0:119:e56b:91e9 with SMTP id a92af1059eb24-121722dff1cmr177764c88.26.1766084317443;
        Thu, 18 Dec 2025 10:58:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217253c0c6sm299016c88.12.2025.12.18.10.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 10:58:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 18 Dec 2025 10:58:35 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Robert Marko <robert.marko@sartura.hr>
Cc: robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, Steen.Hegelund@microchip.com,
	daniel.machon@microchip.com, UNGLinuxDriver@microchip.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, vkoul@kernel.org,
	andi.shyti@kernel.org, lee@kernel.org, andrew+netdev@lunn.ch,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	linusw@kernel.org, olivia@selenic.com, radu_nicolae.pirea@upb.ro,
	richard.genoud@bootlin.com, gregkh@linuxfoundation.org,
	jirislaby@kernel.org, mturquette@baylibre.com, sboyd@kernel.org,
	richardcochran@gmail.com, wsa+renesas@sang-engineering.com,
	romain.sioen@microchip.com, Ryan.Wanner@microchip.com,
	lars.povlsen@microchip.com, tudor.ambarus@linaro.org,
	charan.pedumuru@microchip.com, kavyasree.kotagiri@microchip.com,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org, linux-hwmon@vger.kernel.org,
	linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-clk@vger.kernel.org, mwalle@kernel.org,
	luka.perkov@sartura.hr
Subject: Re: [PATCH v2 15/19] dt-bindings: hwmon: sparx5: add
 microchip,lan9691-temp
Message-ID: <8462a516-4e8f-413c-813d-e7ff0e6eaa1d@roeck-us.net>
References: <20251215163820.1584926-1-robert.marko@sartura.hr>
 <20251215163820.1584926-15-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215163820.1584926-15-robert.marko@sartura.hr>

On Mon, Dec 15, 2025 at 05:35:32PM +0100, Robert Marko wrote:
> Document LAN969x hwmon temperature sensor compatible.
> 
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>

Applied.

Thanks,
Guenter
