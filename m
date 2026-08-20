Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239CE432BFB;
	Thu, 20 Aug 2026 11:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787225512; cv=none; b=YRSt9ZpCcJIS2By9Tkf6MYQN9xKMJxcOZIkj0x21+DSVun6Mw+HXTebW/afrHUJr0ghVwsdQfUGjhCJWs1jVKBhUs1UlRjpjUClxC754YRY1UwmnXrpLzQyoI9BnsHV65BwO1XqezrpBrWmmkJPHQJ3dhZjyCxPcfPdKnMtwKoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787225512; c=relaxed/simple;
	bh=IEBn9Xl4Qu7nfVpqOYsme5TDAaABuNc1ihgRqOYu0kc=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=qKxDABIeEmXugv+rgMoeM3oawZ8xICBBKdomCDVLyXeFbgAT+JFBPbs8ptEsDXBc+yx0k2D/50vuikejBpgAKR3mMwXIb4Grwf02zNagkP6w0yt1HjemtLlCdxflKyjCIxSUM2Qu6i1KOo0b5fe8RF/iywOqFjMevwecagrc+ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=kMN+LMpA; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="kMN+LMpA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1787225482; x=1787830282; i=markus.elfring@web.de;
	bh=IEBn9Xl4Qu7nfVpqOYsme5TDAaABuNc1ihgRqOYu0kc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=kMN+LMpAEAhpER4OD73b6vHlPTQa9PLP/tkQPwpwLkYSmHGB7DwI6SYSxfg/Pqrs
	 js72sYaIpA0xubopxyrqIJyvJ6MppvL64Yc2F0T83n0mUKiTHaqG3X/49eVKhRbtM
	 3wC10p+izYLvdTBUSCfQ9VsmeTxn+rY0bMZezUhwe7nLoVmKYVR5qo4PIxVCETOPz
	 eU0qMoUvTtGPDOJ3n2pfKpj31YD1yGc/IcZYEM8G3FvMcWTPlI7la8EFwOwuUUSuZ
	 Nwu4hDmnpjjms7lADSr8q24hJ1dKZatkrVqo1exdYIZYlb7a3bkCmkphKcvNpDH6n
	 g5eURLG3ezj89fjNsg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MQ8ai-1xIxj82utk-00XJaB; Thu, 20
 Aug 2026 13:31:22 +0200
Message-ID: <c03599bd-e3fb-4446-af91-2b197a94ac49@web.de>
Date: Thu, 20 Aug 2026 13:31:18 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: 1298662399@qq.com, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Jia Jie Ho <jiajie.ho@starfivetech.com>,
 William Qiu <william.qiu@starfivetech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <tencent_3C130FE0F8AF7CA544FD44D113E4966E8E06@qq.com>
Subject: Re: [PATCH] crypto: jh7110-cryp: handle clock enable failures
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <tencent_3C130FE0F8AF7CA544FD44D113E4966E8E06@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:7Hax3clQcobptpTFXLEchLA2o1uLbKqww4cpcpx/D+CmDO1upol
 lPcskoUCKurCsIwgHBMhO2XEq4WeUmS6G3BHiIF8PznpK2xtJ4dnntGoNav0NwvR/KISe6k
 GbubFVGu/xFUl9umFrLaeUDabLbREg8ySZBSbUuhyjaFiia0K82L4gMJLq8uuanTYHUaz8a
 ad8I+HhJ/RZNtHxuxt9zQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:xuo2dwNu2bM=;J2JfAqsk3yjhH95EYc+AKljuLiW
 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

=E2=80=A6
> Check consecutive clk_prepare_enable(cryp->hclk)/cryp->ahb returns in
> starfive_cryp_probe.

I find such a wording approach improvable.
How do you think about to add any tags (like =E2=80=9CFixes=E2=80=9D and =
=E2=80=9CCc=E2=80=9D) accordingly?

See also once more:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/stable-kernel-rules.rst?h=3Dv7.2#n34
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv7.2#n145
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv7.2#n792

Regards,
Markus
