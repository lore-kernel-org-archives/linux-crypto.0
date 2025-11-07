Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CDA258EF3
	for <linux-crypto@vger.kernel.org>; Fri,  7 Nov 2025 16:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762532215; cv=none; b=lDybtp7A7IX3KVTv1gfSwa7s2SlM15r6ws21u2dSsxtrZAQ9XEDFDSUtTUxI9qr1CoSf0hU65q8ZlmUgYAweRPj78MAMiIhozTCzboOSjOyaEflF+4e7PAx5WKnjVNtx3LFXz7soEDLFaPN/5JfZRYUFxE0iEg1VpVqduE6+0Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762532215; c=relaxed/simple;
	bh=m6h5md15vl7XA18igPsSaXDaZbae5jLpA/oiBVEflwY=;
	h=Message-ID:Date:From:To:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GYagJqfPw+q8keTCUMwCzi8Avkiv+9UFDBDzGMvSgCvPsFbAsZtjxIYq8X4/PGc3yUrJkY0bYk3qYxPtGDkylu5U8cGIiPAuoACgRBGwh+6yr3mNX6u1lLtWQ9LW7Z+CdoJprsHZG+aZ3rAqR8mPg4pGj77rXfQp46yZZvnVBBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lBAuiat4; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lBAuiat4"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-429bf011e6cso930545f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 07 Nov 2025 08:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762532212; x=1763137012; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:to
         :from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Rq+cWEKtg2ZUTyxd/Vz8Kc9fcT1gEAUEGw1yp5hm07k=;
        b=lBAuiat4NMzoJBjXdGf6qV7UglfWMm+nvXHO3L2Qt2rnXJ+qJG5BJEwl5MFGAaccCn
         trEVCZTD8Vp4BKGuOOereI4JMkCdUQJXcC83WhEN+K6VnsZTeQA7RVicoGjWNk3LrU6Y
         J5CNW3PTG/9RPOQnn9w8KZXDrCza8rlPA+GWrUdmJxrYI69XQuXhJPiaMEy5t2WrGZl7
         JqZda9N09B23SRzFW9SEU7/0C65qQe4NGDf67EMXiac5wcZhzXMel+cXsw7Gy/xDSQ5I
         7UzaHhqZgntXBo80wTCKt7UxHTRFPR18gAvDzPcVS8oKs1uBzTicON7OPR+s8FE4zWzb
         U+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762532212; x=1763137012;
        h=in-reply-to:content-disposition:mime-version:references:subject:to
         :from:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Rq+cWEKtg2ZUTyxd/Vz8Kc9fcT1gEAUEGw1yp5hm07k=;
        b=pXvzrYWjpesn+6VYQoAIgSpAB4e3b/ovmP3NFQhM6YAPi+4zRNbKhsbfCdIcZCMZDm
         svVp0U+c7wzCuo1BxtSFnl5EG7N5xdI9mBwe8Jdhx0hQiGegOQVfLZYx7JM1oUErzQp5
         DYNS0669YbHdcf4StIDBFFtFALhrff+SHoVss7uWNZB1Ca23HbKtpUB5etJxF9hn6LhW
         Zz1No4FHbog9TK/Dv+7jxKEfxcJDnUucBsg6T3c9BYKr7x4ufko/dB0i459r8DlbisAH
         Qp71+WFSgdJ2edB81fitiq5qUXa3tyVsGSFADpoF5XBrPRirEdbuv0pYZAQ2RHMzM7Wt
         A2AA==
X-Forwarded-Encrypted: i=1; AJvYcCXb0J0mQQ2gBCKzCaBjIpkhMBLHZL+QREWkcqlorlBQgNyZBP4e/rqLXNgm8zuagyi1AYQZdvEdh1oY6J4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzawaDcu9jtCpOoZwIlF4RGaKordR0r6hbd6KJUoroymGsj2Fad
	MdcVHkvGtw4r/qj3UMNGLwEC23TIX3qXKZbHMpaU4Lw1l3mIC+uj/hCc
X-Gm-Gg: ASbGncstyG024D+LFzGv1uHvVtIWWet2azPdBomr7/Jp4H9+O9t8RcY8Y+4ogbRJSgk
	wbhFVwuFd5pw5wX5UnHNanHiEoQzN/pW0ntfHbEaKfEo6Puhij7SCdl7LNIp2JcfZJwy2Zz9xD2
	PhhJpCTDmFwTsKfVn4UfqXkcPYAljEUgUfBMePgm46RGLGQWo2AWBZVqDZT8JTgWf41IJqJrE3F
	Ml2tq2edX1nyqe+AP5OX5izjy8WphmWo3Y5uudBCaSr65z45mgcXhbs+/EMAR5uhaFzPPABZN2D
	G3AWmk7rLhHBLrtCoSI12CMpWeKRmiodn/uuHbMSzNn8i1deLfpIN9nVA8x4K6W8S4JEqf+f5hV
	YuzhJQVhHh2+tPxyxHST5Kq4b1s9sZAJyhg8+WF+DfU8Eh3hYOXnLj6vM05oa7z8UqKEocD1wSz
	I6e75DVwQNgX/oHE45yNThJzCHubrp
X-Google-Smtp-Source: AGHT+IGBls4w5DXj4dsI+iVzj/lD1T2JS8LC5CnrQ6tP++E+okDJx9McJEWsKb0hTWxZy1/eytT3yA==
X-Received: by 2002:a05:6000:26c9:b0:429:cf03:8b1a with SMTP id ffacd0b85a97d-42ae5ae9995mr3350125f8f.45.1762532212275;
        Fri, 07 Nov 2025 08:16:52 -0800 (PST)
Received: from Ansuel-XPS. (93-34-90-37.ip49.fastwebnet.it. [93.34.90.37])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42abe63e131sm6344445f8f.20.2025.11.07.08.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 08:16:51 -0800 (PST)
Message-ID: <690e1b73.df0a0220.312af7.18e3@mx.google.com>
X-Google-Original-Message-ID: <aQ4bcJDWhgQINJry@Ansuel-XPS.>
Date: Fri, 7 Nov 2025 17:16:48 +0100
From: Christian Marangi <ansuelsmth@gmail.com>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-watchdog@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v4 0/4] arm64: Add AN7583 DTSI
References: <20250929114917.5501-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929114917.5501-1-ansuelsmth@gmail.com>

On Mon, Sep 29, 2025 at 01:49:11PM +0200, Christian Marangi wrote:
> Simple series to add initial AN7583 DTSI. More node will be
> included as they will be supported.
> 
> Changes v4:
> - Add review tag
> - Fix alphabetical order in Makefile
> - Move PSCI node after CPU node
> Changes v3:
> - Fix typo EN7583 -> AN7583
> - Add specific compatible for watchdog and crypto engine
> Changes v2:
> - Fix DTB BOT warning (fix crypto compatible and OPP node name)
> 
> Christian Marangi (4):
>   dt-bindings: crypto: Add support for Airoha AN7583 SoC
>   dt-bindings: watchdog: airoha: Add support for Airoha AN7583 SoC
>   dt-bindings: arm64: dts: airoha: Add AN7583 compatible
>   arm64: dts: Add Airoha AN7583 SoC and AN7583 Evaluation Board
> 
>  .../devicetree/bindings/arm/airoha.yaml       |   4 +
>  .../crypto/inside-secure,safexcel-eip93.yaml  |   4 +
>  .../bindings/watchdog/airoha,en7581-wdt.yaml  |   6 +-
>  arch/arm64/boot/dts/airoha/Makefile           |   1 +
>  arch/arm64/boot/dts/airoha/an7583-evb.dts     |  22 ++
>  arch/arm64/boot/dts/airoha/an7583.dtsi        | 283 ++++++++++++++++++
>  6 files changed, 319 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/boot/dts/airoha/an7583-evb.dts
>  create mode 100644 arch/arm64/boot/dts/airoha/an7583.dtsi
> 

Any chance this can be picked? All the patch got a review tag I assume.

-- 
	Ansuel
