Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270F01A2C0D;
	Sun, 26 May 2024 08:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716713625; cv=none; b=IGO2r33XA/Z5dyWBmzPxirqCCd6sxiSADsGPgMke1PDKN4yWdhlm21Q3ii0/xB/Srmiqf84MLsAPHRYaq7XCSBlItfN52MEmlVXmvcyPKKo8wMM0OVSaNRqsFbT3aZqJ2Eky4pprODT5ukP+RdheKUYBJBxfxoVThsyuN9NhwxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716713625; c=relaxed/simple;
	bh=ee7945mSyysXsIKupnhg9BhZJrX5CE0mIN2ytUkSWS0=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=SuyurOu+APagsLQ+uKcajpBEvdrR67VC7PsjHOudr4gfRYrCniZx8t9yzwzT4UsSrnlrtnlIfNCfQwXrBSL2QazpSil7j2B+nqpqf3U6YH7pgXaXonhR2ePUiXAVi+vaCRj4OmhVVHblMLwY8JCdou8KcvYecDx/dT36YW5zEh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=YUihc3q1; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="YUihc3q1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1716713586; x=1717318386; i=markus.elfring@web.de;
	bh=ee7945mSyysXsIKupnhg9BhZJrX5CE0mIN2ytUkSWS0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=YUihc3q1lEaPzTWXunNad9GX8Xj3+gIKWVUfFPgjQXoIDCr8O6w/yMNQBPqLHsD6
	 h7FYBojDTqORMYU6Odu9y2X+Rm7Re2TOIBdAlIYmDyzuEPum7yqUo2eXFGzAFc6OD
	 JYfWzIyq0t2fWkS/Auwa8fcmYEiq5l5toiUbzCEzeT+Bqg6lGi6eJQSzRDSpnasPt
	 6IzozLe/Wrh9SinwI+XQMeW0L3Y9dG5KRPTbFjMHIj8XmBVtZD7N9LwB0MbZ5hDbV
	 MqNxmKngJ2f4nc+l03GjwVcxXjIHqHYpskeMDy9HzADmjMPnP7nDPOQAyiJQ1u/+X
	 3oYru3LP07y0bA9DNQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.83.95]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MwR05-1sTvZ12Bi1-00sGUW; Sun, 26
 May 2024 10:53:06 +0200
Message-ID: <084d77ec-5eaa-487f-a9c1-d90454ace234@web.de>
Date: Sun, 26 May 2024 10:53:01 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Lothar Rubusch <l.rubusch@gmail.com>, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, "David S. Miller"
 <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Claudiu Beznea <claudiu.beznea@tuxon.dev>,
 Dan Carpenter <dan.carpenter@linaro.org>,
 Nicolas Ferre <nicolas.ferre@microchip.com>
References: <20240525192237.9837-1-l.rubusch@gmail.com>
Subject: Re: [PATCH] crypto: atmel-sha204a - fix negated return value
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20240525192237.9837-1-l.rubusch@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:PGlmwAdNFRPbKeW4ueabV7+uSMzURZ+xy6eV1pN6OhVQILr3DG6
 K1UDa2KINy6kFs5T1mfiGUrmE3U1+B4pRcEih+1ZQmk7xwz7aFpoKPQqdVhQKdKrjs95luc
 GtEwxsEYRVpizyk2pTVtEiAuK41Qb/WyLxIAi4J+tp5YpxuqurrrO87Lq255X/HRk1DQoSj
 SAIAg+tzmjTV6TOqRYeew==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:YUniRF5HCNQ=;yKqI/BxDd7CB5lBEv7HzD1t/EVn
 /ccqYgOfVc0V5tcspAni/kjdfC7jFvzP0W6nxcVdg4SyyMA58Jwzm5QO2ReTWdn+ZUi1M1UUM
 M3W+eBxFJgR+HdbaevjUTaW+kfUFdGQ028nu2ZdBmN5dJZ8e7ox43iZVVisUaZ6QfChsMeeHS
 jOBw+TlY6lNmWpOaUQfwbnz09bZCPpfstHYKoAVSTxYNTNYtYhzoMaOAG99nO2AeKBF02G7wL
 DpgZtAlgYsoL0j1uPRSsvZdV2Ic3iDoMYPvYUmhycPSFg7EEXVb4B7i0ofcv/K8Dmfa/Zr7jm
 9FJhqJaTIxGcY92zyJC1mBHycCA701lNWzmw9DfkyRaUnO31ujkl2zYuKxK/nYUSn5KTjsDeG
 e7q78IwGE4YPOkvp6tG1KHv0cPzml+cq3nBSV34r6mFXz/F0EpAZGPgLkSqEU9Dy/QNn7Xc0o
 P+M79Ja0i3ovv1Q4Gv4FJyLMSNV1tkjjiA/+Yes4CelibigMlTIsQBHhSbFpxKDbDkTkczKtl
 ykdhyB6w6fSkZnWY5cSO2Qz/7dT2GWBfNbsdJNpkZ2WpYzNYrV/a66GrDNEQlGLUI8b29y5o7
 cODHjmQgjm3liRMxSEWkbGTqCfzGqi7A24cnHKxrDgvqpLbivAVkldOGp15o0Nycpsa58B7HH
 IezL6Ms+mKUIdjIVu+kxqlN/UH6D+hX5lMA7O3aBKqvXBa15MN6aWgzETfNgHMR5mE75R/567
 4q9WWgW4h7CLBK2/0is6z11dN8DCyAYdoV6xim65dr1J54ksfLJ04RQN8yRx0XQiTc/7+JDfh
 yEerOP3sI59DUHfUbpRIAj5ZfrINsNaRHrckT61Vugtvs=

> Fix negated variable return value.

Will it be helpful to add the tag =E2=80=9CFixes=E2=80=9D?

Regards,
Markus
