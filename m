Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795447998;
	b=5qtkK6qu/dw72FLlEylHfzR8kEXiA82bUyyoV1ZG7CICnABzvG2PVKrBWj8Kukum3+88
	 XPyHDnBSb2aEC5f6yF/eMUPm1C6FQtngfivqY5BkGjzDSxmt+52hZa7QdBPHYfMk3tWhH
	 YCHniPX7rc9riws9RRqRDW8J5+JP/mB7mvJC2lNwfFmu02sGVS5pHV7yZyAvFLjcaGM9u
	 4/o0b/khzBXBRcCLwDmg5CPldrPsIJILvv7SJ4ytzQBuE5nCl30x3yGGW8+czYnzGjFrb
	 TWb2H4IVLtrkx/UGu2hnBWuPG3DvYakGegHMF/alOLgeyGu4ZI5lGJDIsv99osMSApw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447998;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LTw5++e2w+iexPjIRtRx5h43jD4fgvwWeeA/d7rdnwU=;
	b=Csy3Wim9Up9mcFceKgQX5aFWCQhZTXKQ35s980261W+ER7LogsGyGrdDjAvNTwdW0d4/
	 dqotcMjPncYe/w9S15Qg9pxgegaLg8QJW8JmP0nDXmra3R5C2WsFDCJw49NjWUyKhS/MK
	 Tne7JlNvJwKTh5sRwQqsrwcopZDmlqjSQHtkvAnxmeMczaWNcR3Sb4IoYaum3yLeej+xk
	 hUpHSSMk4hA3oaX/eTls8N49cCYvCsy7JBkd8v8CbzEH7AbSCTprBw6lU1LsTH8Oy1KuB
	 V1GPaKn6Diz98DzisSRIA8IgjNwb0v2MyMDy+Z6Kbn30CfKb47jm/Dzr9W3b8GZamVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xb2TsqU5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 1D357606A686;
	Mon, 23 Nov 2026 15:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xb2TsqU5
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A4A931F01579;
	Mon, 23 Nov 2026 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795447997;
	bh=LTw5++e2w+iexPjIRtRx5h43jD4fgvwWeeA/d7rdnwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xb2TsqU5YYSD3jZjrnJrtsCsRy/v4kKm9OuiUBjCOIICg1zfa0qLJLc9D7Rp3+0Pq
	 0xyHyCaRDMuAC5RW9qLMH6Am9MtlGjOmfZwOFD8yBXrQiTlDFX0uifeMTb2i/Eziox
	 fg3xYcuv5EmgQ/Qi7dkkCrC6rUApm0aBi100EMATlOHtankVSSrc/OcNSGvcH3Rnud
	 B4bAxRRIiPqYiqEdjvjpTIuKTeMrTahXa15wZAD914BNW4s3Dy8PHkj3qrVX2AnUmc
	 Akon25eAKRtGMhIthecrRwodFVNCrZHGlvaAg53qcq2DHk1YapdiZUMaEaL0k8hCFA
	 xn0OLAOuwyHlg==
Date: Mon, 23 Nov 2026 16:33:14 +0100
From: Bartosz Golaszewski <brgl@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, 
	Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Eric Biggers <ebiggers@kernel.org>, Demi Marie Obenour <demiobenour@gmail.com>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>, 
	Abel Vesa <abel.vesa@oss.qualcomm.com>
Subject: Re: [PATCH v12 2/4] soc: qcom: add core driver for the Qualcomm
 Crypto Engine
Message-ID: <4yshvsbpon3tzq4ujrtls5jd6usnbn4m7udlsx437hnqzkqyhs@kxcn72solzax>
References: <20261120-qce-fix-self-tests-v12-0-b5a2a44bc5ae@oss.qualcomm.com>
 <20261120-qce-fix-self-tests-v12-2-b5a2a44bc5ae@oss.qualcomm.com>
 <7818fa09-8f9c-4d42-b746-0ec74ee1aa08@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7818fa09-8f9c-4d42-b746-0ec74ee1aa08@kernel.org>

On Sat, Nov 21, 2026 at 12:32:34PM +0100, Krzysztof Kozlowski wrote:
> On 20/11/2026 20:34, Bartosz Golaszewski wrote:
> > Add the core driver for the Qualcomm crypto engine. Its task is to bind
> > to the qce DT node, set up runtime PM for interconnect down-scaling and
> > register the auxiliary device using the crypto offloader driver.
> 
> I dislike the "core driver" in the commit msg and subject. It suggests
> there is some core feature or core stuff, but that's not true. You are
> adding STUB driver only to handle Linux RPM things (which have impact on
> interconnects, of course).
> 
> The Kconfig has it nicely explained, but here I see it as confusing.
> 

It's not really a stub. It's more like an MFD core driver. Currently it
only spawns a single aux device but we'll introduce a second sub-driver
with Sumit soonish. I think naming it "core" actually makes sense.

> > 
> > Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> > Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
> > Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> > ---
> >  drivers/soc/qcom/Kconfig    | 11 ++++++
> >  drivers/soc/qcom/Makefile   |  1 +
> >  drivers/soc/qcom/qce-core.c | 92 +++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 104 insertions(+)
> > 
> > diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
> > index 535c8619197b3e889e536da072ab89d3bb729804..67d54d5211ff21bae77cd8408fa47af630060949 100644
> > --- a/drivers/soc/qcom/Kconfig
> > +++ b/drivers/soc/qcom/Kconfig
> > @@ -121,6 +121,17 @@ config QCOM_PMIC_GLINK
> >  	  Say yes here to support USB-C and battery status on modern Qualcomm
> >  	  platforms.
> >  
> 
> ...
> 
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_DESCRIPTION("Qualcomm crypto engine core driver");
> > +MODULE_ALIAS("platform:" KBUILD_MODNAME);
> 
> You should not need MODULE_ALIAS() in normal cases. If you need it,
> usually it means your device ID table is wrong (e.g. misses either
> entries or MODULE_DEVICE_TABLE()). MODULE_ALIAS() is not a substitute
> for incomplete ID table.
>

Sure, thanks.

Bartosz
