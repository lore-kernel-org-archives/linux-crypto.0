Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC9133A9F7
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 07:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768204598; cv=none; b=VEvZmB7q/ZNTK0sr185yiOmJg1QcOqRUpVs6K/1hErRyaeJ3DIEIlmWeNvAEfEXjZjNYwcA12/H53EZ3yDRbOpQqUxikzsqMdOvP/0SIv9W/9mI19VVb1cvUp+s06SkPgsSnZSOHJxB5PaaX9rYOUcMYS+5wjwZaEVAz4AsS6dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768204598; c=relaxed/simple;
	bh=Gf3lltzd84X9dIvu2pA3a5Jkaw8Zcskzh0E99P0ou0M=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=RApxzfrPqOjRPmDOhIsTKNxsz/Eyy/VN5gEl5P0Cbf8nnHwxuyYKZ9hTldJzF+c8/2Wnul0LuD3Ih+WcQvr0fP5Xi9Nbfxw/d3wEU4IfKbnWPZ7pL9thHQAQCfnyv7lWRRCHRlHyIax1GAR+JcM9seE5yjjyR8MOOcasSbVgw14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=Vc4pdsMm; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="Vc4pdsMm"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-650854c473fso591118a12.1
        for <linux-crypto@vger.kernel.org>; Sun, 11 Jan 2026 23:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1768204593; x=1768809393; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gf3lltzd84X9dIvu2pA3a5Jkaw8Zcskzh0E99P0ou0M=;
        b=Vc4pdsMmRyBsv3KmX3r5ZIySQolJAgqRaFfxfs5i+FqGpZqoIAWuL9cVnXzOk6RvYP
         qyqldHPIqJPgztVszC4cxUnKrunSQY6yPRdDNjyXsvHgZXc6px2Kf9xoqhhFynkdahY3
         s6AJuqC/TUmo/6wJBsZtvdxbsTt6PPaC4KBItv/ZB/bJa1Bg/K9hBCt++OAZZi3ANnEB
         1zL/eTE9oelWCQYNNLW9oRUvft97VDRdF0HfQQrPCJDuqg0YlCH0wO1X0vY4N5jdpZxf
         DGt8NYxDcmPeNNzyuflmO1d6dubmrRjQcIaWzQdzdp08ze7hDU6DarWRTkaqkuFo1WkE
         A47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768204593; x=1768809393;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gf3lltzd84X9dIvu2pA3a5Jkaw8Zcskzh0E99P0ou0M=;
        b=olVj2rjiDY0N4yXpUzgvI+j/EXgSeTpKGvJW94BC54SXa3DuujxZJ1b7d7W0WcBrvo
         aOGr51ecEqT3MMXz+C1gSi5BKVxb4sB0BUv7fMzkUnFnL44DSKXlzwxKtdZIqRZ//qHF
         qflbnmYX0jeySoWvu79UjbYji5Mt4xx7xWV++mTr1LCeA0dVdEWfN6TwCJjJGDsQDcTV
         VzOeXRFMlkCnsmKkkzhw38a1eGW8MA33BGgGDOvRbfbsiwZBbMsKmNFJ27qFApkUVwv9
         rU4x2n8n5zWB59qSniPin38nuQanHd8bO9e824ZpOj7drJi8YQ2lxoGjQJEt7k4PfncE
         Tr4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgntOu2kz8g2zCvv1MMrL5EWj1mP3Rt1P2vzwUMVSvjpbMvNzKAo2fZrf1P2lFsIllQstkJ5Sg/hHhCbs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjRNRSj6Njshjtq9Kjsk2Qoll9ugE9cZjR5IKHX56p9vRW4aJ8
	Dd0i99UAKdGhcxNofOQQr4MbecnJi/S3YIl8uN3mx9tZsmtDQtRhBCKu+uP2ta0dcvM=
X-Gm-Gg: AY/fxX4kmiCQl41gyzmpr8K1mMQfL56JKF7SgOTHWSZTLHZqLrm3EMUCuG3/abUdqEn
	zHO2hRrWdecz6eyIiCJRDIC1wZf62K9ocJRQcPmlZHJG/cEIzwecDVqkDks4VppP88Nfha/afVR
	B016VqMNxWx90XB/7ff4X1fjK2vwsRQMD50AkzEFUlXpHxHVI5eXeapYEC4qTDqY9vpnQitsOkP
	ViCL02kksB2gQjS15ZQpNdULmurp9FJrlibNLZN//l6CLXCupSVBjNxE2/WmpygJD/7ut2VR8fI
	HlaTxDXas+0VSZMqbX7V0HGWhd4BBqAjL14Dkk9MHm0TI4hysMrEPC4T810RvQCHkvUlR+UvI7Z
	/DRmYvUj/4n6N15NhbouE/Jv4zZFoqkCzzpqdh7NKjdamBTLTBdPfhODZ7W3hnh2ezi0LrPlGC1
	aFO38xB8Ddux+6mkcXasoAbWh0Qaq+py/Yfzw6JJH2Xc6SneAAKyvwrBWJ
X-Google-Smtp-Source: AGHT+IF4Co8aoQPdp/p5ff/3fLI8tNtSvixQwidRJsMSeJbryeMgmiZxjL+AqiLpgmcJiIOYnaXZoQ==
X-Received: by 2002:a05:6402:34d1:b0:636:2699:3812 with SMTP id 4fb4d7f45d1cf-650977df5e8mr17217698a12.0.1768204592725;
        Sun, 11 Jan 2026 23:56:32 -0800 (PST)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507b9d4c0asm17138294a12.9.2026.01.11.23.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 23:56:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 12 Jan 2026 08:56:31 +0100
Message-Id: <DFMG7RK9BACS.1LM96XH56V2VL@fairphone.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>,
 "Bjorn Andersson" <andersson@kernel.org>, "Alim Akhtar"
 <alim.akhtar@samsung.com>, "Avri Altman" <avri.altman@wdc.com>, "Bart Van
 Assche" <bvanassche@acm.org>, "Vinod Koul" <vkoul@kernel.org>, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Konrad Dybcio"
 <konradybcio@kernel.org>, <phone-devel@vger.kernel.org>,
 <linux-arm-msm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
 <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <linux-phy@lists.infradead.org>
Subject: Re: [PATCH 5/6] arm64: dts: qcom: milos: Add UFS nodes
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "Luca Weiss"
 <luca.weiss@fairphone.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
 <20260107-milos-ufs-v1-5-6982ab20d0ac@fairphone.com>
 <yq1a4yj5ysp.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1a4yj5ysp.fsf@ca-mkp.ca.oracle.com>

Hi Martin,

On Mon Jan 12, 2026 at 3:52 AM CET, Martin K. Petersen wrote:
>
> Hi Luca!
>
>> Add the nodes for the UFS PHY and UFS host controller, along with the
>> ICE used for UFS.
>
> arch/arm64/boot/dts/qcom/milos.dtsi isn't present in v6.19-rc1 so I am
> unable to apply this.

This patch is based on linux-next where milos.dtsi exists, but any arm64
qcom dts is for Bjorn to pick up, so please ignore this patch.

Regards
Luca
