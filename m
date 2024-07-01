Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A98F14A098
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jul 2024 12:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719836863; cv=none; b=svstFOfwVzP0V1RYUT9GA62wxAw2LPhVHLD2wzGGZlPLgsUDvl0CXXu13CewQ2u7oTVTP1slMXbAC/jqh4LrYyg3FFb7aScI7Qap1Cjr+ii6mO958WgGsST2S5J5XK3oGVmcAaNfNm5LEgNbNPu91pkRORuMF1TOjq8qTeL4cHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719836863; c=relaxed/simple;
	bh=DKtxpPgVNtsn7K3hHeygsIzw1BFxEqTpvfTeM+AQT+s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hn6UfWNAUMB4zFe84Pcd3Wph2rwYA+tlaE67HZXroHXTdoB69LD2OsGxqCyTi7p7+j9pNuQPzK44j/eh6RQ0vXUz/x4d6Dm41wSODfY+QUaXrK3gy1rEq+LuTMDnDHXVuOiEA/efdInDSJcZiJRBC5nxdz5qGPXaTQxRaro03P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Hb26X+hW; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Hb26X+hW"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-354b722fe81so2035289f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jul 2024 05:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719836861; x=1720441661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IbKJ1+fHrcfsxoNPssv5ufXQjSB4NnSOZ79R2VobUDs=;
        b=Hb26X+hWtdxku4kNvWXx2QTDnVXqfsxei5cJwNrLYvRB8BZ2vid8FHRGW1/UnU27Wn
         xe2aq0si6KQ8yIUcNgEjjh5rzdVDR6IYF96DmAPlgqLQmQBUMvX4TObcGPOu6GDpTXlN
         oOW5mq81QcpjRsP1Qo+Jg0xXqhSwcjw/uRZyAnridOfHTyifQzJIEQjIJUUesdsleCxS
         gS85qnhb6qErGTozxsyGFvGWCKuZ87UXCRvzp7CVnI+hhARkLLHSQP5/+ViLCr3PedNR
         MoxMmgkpqTs0ZWawGcL8g3j2ioyAh8atXsCfki+ZrFBNAPau9Fai1b/s8I+fsR8sajDj
         kRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719836861; x=1720441661;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IbKJ1+fHrcfsxoNPssv5ufXQjSB4NnSOZ79R2VobUDs=;
        b=f5hJ5YLgMGvugWTegU3CzMhiknhfUULJgtydxKHRNlexDUDSjKawHmScV8g8WexcqZ
         XUSS7rJb02Ce2KQ/ONgvisw99jGUM5YcV7d+Drgv1aPxzoGlaO/oLK8giEJcQDoEB4rd
         AmoYWR0H4s4klIDpa2QG2m2zxMYibKGWGQu2PdzMItTN7s10YolpcUhw0Pr384ovsQwj
         FbeQ3Ih8ony48+jB4YHbpWLXgoK10I2YCPvmCNpUfazJxaCZJ3rbFsSP1KE1CxHaRJR+
         c/hY6pcVZ2dzsubUZVDfEs30UGj/Nk4le7eZNwRYX6HDaIjl8KUQI02aAzUnpibvzlWH
         I5VA==
X-Forwarded-Encrypted: i=1; AJvYcCXdbuxKsiVIBaakw720XJagK5VPjFuIK5mOXIL0u3UEgIgiiRF8gE8hX48vlXHJgT8CdI4o0s4a3ZK77DoZBANvko10bhC97xBxOMey
X-Gm-Message-State: AOJu0Yz5eZwvfs38HcPiY24wWTf9RRP2BzN/xuy0XdvxWHMuvTU1nDrt
	AdiLq0C9hLz4G0kL/hxeByEafQO+bKsM1wr1TgWkDQkr89sGO+KaxgKwYkyR4kCZxXMrfhfFMAD
	x
X-Google-Smtp-Source: AGHT+IFH35xxvg5N4AtgQdVncudDweLagl90Mb/QWe2ODsQ64shBW9nGUOgVWRgqPVDQN+ts6wv3Yw==
X-Received: by 2002:adf:ab17:0:b0:364:a733:74de with SMTP id ffacd0b85a97d-367756a9394mr3104569f8f.28.1719836860636;
        Mon, 01 Jul 2024 05:27:40 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.219.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3675a0d90d5sm9961414f8f.31.2024.07.01.05.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 05:27:39 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: =?utf-8?q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Sam Protsenko <semen.protsenko@linaro.org>
Cc: Anand Moon <linux.amoon@gmail.com>, Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Alim Akhtar <alim.akhtar@samsung.com>, linux-samsung-soc@vger.kernel.org, 
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20240618204523.9563-8-semen.protsenko@linaro.org>
References: <20240618204523.9563-1-semen.protsenko@linaro.org>
 <20240618204523.9563-8-semen.protsenko@linaro.org>
Subject: Re: (subset) [PATCH v2 7/7] arm64: dts: exynos850: Enable TRNG
Message-Id: <171983685912.414640.3760379043384228947.b4-ty@linaro.org>
Date: Mon, 01 Jul 2024 14:27:39 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Tue, 18 Jun 2024 15:45:23 -0500, Sam Protsenko wrote:
> Add True Random Number Generator (TRNG) node to Exynos850 SoC dtsi.
> 
> 

Applied, thanks!

[7/7] arm64: dts: exynos850: Enable TRNG
      https://git.kernel.org/krzk/linux/c/64c7ea42fcc2b972fc8d108642f4b8fabf0999c3

Best regards,
-- 
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

