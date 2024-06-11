Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23234171E60;
	Tue, 11 Jun 2024 12:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718107429; cv=none; b=JzSwVYetZYhZdQVoEKoB55570RtMIKx1ECeFOr0lkeToq9siLIjoF4RymkLsoLc7gEh3Ihy3RgbKzHFLBXRHU7K9asCzm4e4GI0pbq7cKvbOmND4nwGsvCGdgtgKacx57LsISgKpJM7VF+4cq5eWDasg+8bn+bvX7rPU2BLnM7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718107429; c=relaxed/simple;
	bh=6iL5d5+TpVoppRR7mPjEQaHzLpdbiQSHhhT9BJKLh3I=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=NvvxSbtX9/7l6oyWZko3P0joa/f+1FXFszmF5krQRnj43rjXqMdnxOx0TxbXQMS7H6G+yYqWyoMyPoTfO05WGd45cDId0u4zwZUyxSq59r1CONz4BDHX9SGNdGFzoNx304OQ49Xljqfj9ot8qoWT8V8Zuq3UVo03iSCfT5x0u8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=v4UzXkw7; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="v4UzXkw7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1718107378; x=1718712178; i=markus.elfring@web.de;
	bh=v4MG0q9MnuPY4++cJH4EjME8ABWNsolzfGyYD+ZIsYU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=v4UzXkw7bizGPdAA35we5ZahpMfu+ZtwZNGftCytLLW7WsytaCSWwTVnydrGfkf1
	 oK/ZgNXHm3vpMwOwPNJaTR1ozrYCotWRwmkEjkvwqSxaKtXnFCdvWl7BWkUzIqFCS
	 gIZagFE4szymyPe2/f4PTzw8l/ZSBWTr6Javsc6tAMAUPJBNgae9OxCZAV80jPYbh
	 NaigegF64eXlcvvhNoh0riYBNQAcs9DfWfqcn5GNVlVHnCuc6XKWXtoPFQveEsvl2
	 ywNmQI4Yqagr0EUDQODHk9pq5lLKLP27RCYJ1ytTAQJG7IzSDUY5u0ZSF4xH3Od3g
	 ph0NW7vK707lcLT9gQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.83.95]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mc1ZT-1sq3Jt0QsJ-00jIxb; Tue, 11
 Jun 2024 14:02:58 +0200
Message-ID: <32303d99-c5ba-4fec-8981-9b9966dc3291@web.de>
Date: Tue, 11 Jun 2024 14:02:52 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Kamlesh Gurudasani <kamlesh@ti.com>, devicetree@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com,
 Herbert Xu <herbert@gondor.apana.org.au>, Tero Kristo <kristo@kernel.org>,
 Will Deacon <will@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Conor Dooley
 <conor+dt@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>, Rob Herring <robh@kernel.org>,
 Vignesh Raghavendra <vigneshr@ti.com>
References: <20240524-mcrc64-upstream-v3-4-24b94d8e8578@ti.com>
Subject: Re: [PATCH v3 4/6] crypto: ti - add driver for MCRC64 engine
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20240524-mcrc64-upstream-v3-4-24b94d8e8578@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:TJ+M3A+ZwHBv8zbRqkd8DEM7qjVhITuWZRUhZtq7FNJIWGkAGBW
 3CoM26cD78kPrZKl9pVWI0m31RFhWOtge/YrCgXqxxV5jOYOmntQo7ZymX+uPbr1E54hC4g
 2xYdC00lN417YXdoybmTuYwz5Fszf18GbPLT86PKnchC2KQ7FeKSSpyNPzVqFKprfp7WCKK
 iS3XbhLEABKTBCzWlaBZw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:YogUS1Yz1Ys=;phEEUBQ3iH6xYdFv8skbZzBR14h
 X+6Sz3DaRZye53CTBaNq5iAc3w2zfBrL0OMLLDI7LbCNNbCdBr/D4WTeCEoTtVjJ6Xg3Cz636
 yXCpyBv1pv97bbuTZMENguGkw8NMIl0r1j3svqVgPM9Ga5wOd+gLLqhscwaPD0vi2gyTrWBqj
 w2ONOFtEUdjQx7Vj3gpWrxfNDbqVklHCu5zaZX5b9OKbpKyRI5JIx0rJ5JNGRYqhC4qidhpTb
 zQj2fIl/nIJd7l9KmtF4gvONU3TndNcRrwkGf0Vof27i6MienOPKxS4ds+a7nZ73MBIyXb/R2
 1w391fKmFkSuaRPjaYn8Lt1xC0NRVXS8w7j3nYT2DvEf8Yp+7i7PcE3/zYwBXBfQOo2RvKFyT
 3s7OHuqCJygN0ECVZ57Aiat6FL2evaSmaAvpl46VGhruRblcmRIvwNMdmo3hCz3SRlQf3VDnP
 aO59pXvfXJvR2DbVUWPtCaCKbyww/Fi/lRfMS/J0rKEOxOz8qJ6gzaErPnBn1VZHDJUdi2KVG
 wDHqn9Y8MKbM3GHjUv289hSAXlWFLdkND2BnKcFdoMYLAo7T2L2vVeSOgK0SYgh+cPtTrCL9u
 Pg/A2En23qftgKq6bluP9KC1QKm3Zbj4g3azip3R2avn8d51eaMrR3S/9jhOiDvhPFctnQAD3
 Yy3WkRkUk6KgmJAIMH+PDeZpLRObzXy+N5DUqgnXbaZwNVRh30u+GjhvAODjj10La3DRLkxOq
 6qN1/0vPgbsSgGmnPVzYQtiL1+WEjnexyZ+u6mBa5/KDVF9MA+AzYPfIbS7+erBP0mYnvA4zG
 Eez1Dz4hRxH5b4QSa6kObgEBkhBJI0lV9uv4wEB1k1EmY=

=E2=80=A6
> +++ b/drivers/crypto/ti/mcrc64.c
=E2=80=A6
> +static int mcrc64_probe(struct platform_device *pdev)
> +{
=E2=80=A6
> +	platform_set_drvdata(pdev, dev_data);
> +
> +	spin_lock(&mcrc64_dev_list.lock);
> +	list_add(&dev_data->list, &mcrc64_dev_list.dev_list);
> +	spin_unlock(&mcrc64_dev_list.lock);
> +
> +	mutex_lock(&refcnt_lock);
> +	if (!refcnt) {
> +		ret =3D crypto_register_shashes(algs, ARRAY_SIZE(algs));
=E2=80=A6
> +	}
> +	refcnt++;
> +	mutex_unlock(&refcnt_lock);
=E2=80=A6

Would you become interested to apply lock guards?
https://elixir.bootlin.com/linux/v6.10-rc2/source/include/linux/cleanup.h#=
L124

Regards,
Markus
