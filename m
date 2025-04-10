Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F07E26B0A2;
	Thu, 10 Apr 2025 09:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744278715; cv=none; b=QMDsuzn04ya6bj7KaDO7/AagmDhhvgme8UrXcme7d0D7uQmsDP6u6UfwyjKim2k5U+2iu2eRpZQ5hI1w/SsY2K+5F8NXIwytsdJPMbv/NS7lApyXFIzUR4kbJ12k1dJHuEfvExItzLM00HanvR8exsPfzDxsz7lo1f5oLjExu4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744278715; c=relaxed/simple;
	bh=6PJaYm5P/NviqMk6kV3Jh7Ha7oefRv1KzDsI0FZwZBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O/1Xi28unImsCMBXOEVGVlE/h+FUNuXrPJHaK60UVu552qo1tlne0w2HqUaBiBAgLeKwcfnE9gtfIQRP6wWLvuua5uOVUUwjXiwf6PHWGLXbK2as+G1SHd4RijRGVzeVxE6uP6XUWyZ23sk8Kc2WsN2aM8RFr1TAKRaB7DasT6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=uNJTSIAC; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="uNJTSIAC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1744278701; x=1744883501; i=markus.elfring@web.de;
	bh=vSPtDJBBCPKpz5rvbsYOOueaz2bMZDd9bsU+wbrmbcM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=uNJTSIACyASdjTcRckv2AYHUAAfql049+cxwSxa0bnxGRoSkp6C9mSuacBk292GN
	 jns+fIlNpfhauKawNrKOHfDYH0fQ0liEGgg7TD4kVQYA3cgDwBKZrxOGSF2QpA67C
	 zaevTXFNYDdN+ML9plVzFADlJYXYjxWgDyUOjoGWNYajIM/T9EpuqsQdb2ilAM1AJ
	 7pgHztMeD7/mGSMQqiJKjnVEmGl+/XL5HgaGq/+BbbIrAkjOX8pisavOJJ9VunaHL
	 Evmt2SGmALAiAhKFe1jeiN2+hDxpQlWiRZbUW7Vadwu/hGpsASPN3mJlaJ8CgYm3d
	 +uKxXTKjEPTxtlOKjQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.70.83]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MnX1L-1tJKrg2oKL-00aV4K; Thu, 10
 Apr 2025 11:51:41 +0200
Message-ID: <47681eb7-11b5-4a75-b100-93bc5ccc1c8b@web.de>
Date: Thu, 10 Apr 2025 11:51:30 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: crypto: sun8i-ce-hash - Refine exception handling in
 sun8i_ce_hash_run()
To: =?UTF-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@gmail.com>,
 Andre Przywara <andre.przywara@arm.com>, linux-sunxi@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Chen-Yu Tsai <wens@csie.org>, Corentin Labbe <clabbe.montjoie@gmail.com>,
 "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
 Samuel Holland <samuel@sholland.org>, LKML <linux-kernel@vger.kernel.org>,
 Julia Lawall <julia.lawall@inria.fr>
References: <3727de04-7993-4b81-80c0-adb40b847307@web.de>
 <20250409133610.59d42bec@donnerap.manchester.arm.com>
 <2774682.mvXUDI8C0e@jernej-laptop>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <2774682.mvXUDI8C0e@jernej-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:hwJLNn0l4SKDqj00GqpCYLwpSlnmBFbcsAzjdkoHdNAyDzfJjqA
 cVOLLWsODyxVOnyi0U4Xp9SR14AQAiClqqwnvfEpYYplTw/vOLVgNt+GaDsUpmTqwTh5/11
 yLUVrGoaXrE7440Iz+8ts0one8l2XSTFMi7/71GpPnvLiCl5pfyV1AsTDfMqhnJbmsh9JPX
 L0vEEFPgulu/0pt0cwARA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:aPD+U6ytqzM=;3juoI7tli45UC7oVR/Bw81F+FNl
 tIJSaD6SCDLINBFGIXvDu1w50HUXMTh3TiGWYgCk7NCXe2qf7Z7t/ygJQUryl/sTxmtak55md
 CTGghy+uVZBiYKKfWxASqdMU6a1yJXaNX5E8Xvldg8zU02/hzaBuq1viJW0a0qoVCjgbpbTah
 9/gGwEsx0uaBxMu2Ryxvj87r3q5zyvbB0wfgv3KdrN8viH/vp1MVwmnAP02dfyHW7+MkU4LKN
 kof9akYD1J6t4p4RlhtWtJaRodyDD62KNqvjkR6VaRwV3HznbsAQDHfRdxL1rbjX2Etg1H9HU
 8QgtRUJAimxbUf4+Vo7RtZAY/eIgw01wF5yaiOiH5w5KNYxUfVaHRdHUDjeSEhsVRTiFWggyv
 agXyaj95ABVJors1a+vKTu/dvBhBAMMbWoUAnzMFBjQ55tTlEiq9TZq2Evc665Un7pTLT0FQA
 WNtC0UahR6uQhe7dXmSeRslGAcWnoLk2+8PIgi/hgQhR7TUknT9LY/XMRvcTpwcCqXOSD9DYh
 FT2C25b9tsAkItS4QNDrOijYtwXtxjQx5RM4wIpq8OmbpyFTkTxf53AvBVxdv1ZRipYSZrzHB
 LoNybxR16nwI1oLQ/of4XN88FffJQA7d6yVPKsVtqp+GYGmERw2jEcSZ5UcaTNvSpWXjXfeox
 0oXE+l+vejVDNDdiBkYeVULRrVB+qsGTgdJd7ldA1hUvCS+JRArC0Li8+91H2P24bsRVIwSkX
 ef+HYS95Vdfn52nMnU9ZOh1HiXpAeAN7deJPxC29q9lUENRfw76sYc0yW+pj5JPh9LsK+K1CS
 CLNJBJk/1ClRIlO2G2k71iZsxbl7Xp0MCrB0bOUq+ucUZdG3D0kMFNc7Ax6+epzjv63XCYTKQ
 4BhTPP9eKaSVMd8sYkSdzVBarDhKcB6WEy1eTRA1W2XxxIchY7Se+YlNyi+dtQ6v1Syt7Gpb5
 6tScQYWIBxm/bLK3UApil8DWBOfhZPrGrUNEFbBZbaTb4EV3+0r6d1Z3Zm4z064Dmun+hTz+Z
 rmSJa7TxHuHiWBt4KO3uiM9iOwhGjoSVsZv7IRGWvH26eMY9TpJbSon6DL0qU+HMeduDX+MAY
 q66HNoBcYYx2iGcV+3ELyCmvtMB6+c2C/REJQQ2MxzjG0tPD+mGXxHF7hWX+Z6yN8uL7FN8a7
 rwMnE8yuO1SMQuIq8V/VKd7QQldWvlBdW57dTCd/78w2eO4sMtlDi1RDxhJU9MAWHfpSiMw0M
 VrrCW7xibXjchciMJdpBtAdDz8/rTdjzL7O6XMC9zukrYdf0H5EqW4dKyCIvGAcT/A2uxq1cl
 4AVO2Ry7xa2qKKvX8QqUmbX6mSHPaPzIf4Z5jseax91MsGpv5Jca7ptaJJ7pSrDI6Wos+RNe8
 UgjPjvlp9Dm1C8HLBMGilbtB8zXkj9twzLu/1eKatcwdvZzsGioj7FKCR0IRPBlZNFGYq23iM
 hyDrv6cZWetOiSGvZAy5HI9cjjO63DlUNF8j9tQAlUiE9lXBs

> I'm not a fan of this patch either. As Andre said, current code is easier to
> read

I dare to propose a small source code adjustment according to another
software design option.


>      and such optimizations are more for compiler to make than us.
Do you know any compiler versions which would support the presented
transformation directly?

Regards,
Markus
