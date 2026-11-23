Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795448116;
	b=bvtLW0jqZDn6qihvOWFgeCX2CQhKwKLzPTHVRzVSiKpLUrZRcPsSebAn6U1z5FgfUJdg
	 GE1rVtSzb4W+yvvLO8xe0L4dbzsfjkFGGzohBoAfz0n3OUAxH1onQBcvyM08kPIowWwUx
	 /IM5J50x7orhsXRbDJXY4XNwr1O9QGWa66NMkaYOIUcF74iDB2Wuf54b8R9t8pdKk4tGt
	 d6x/uT6U3fp8XiGysodMgc35aV0U2jKgN09jYx24x2ylUTIFgPhoYdBFlgNH1iZGwZCUa
	 W1vZ0CyHvIWoLG83olsvDsMFtpqKM2Wkq3iyxByny5oiA5E+jQH7Xj6Gn+MVmB8kMMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795448116;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=NrKgzfcLZFljaKhwZAHVe0DSjWSfUpDmRRp+D9I8Z5M=;
	b=clZRXzKaUjWFpAqJYDVaSG9fnTXhVV10Io+E3kw0ob5IOGJ4tDgElWn7eoxWmKRJUi0V
	 8ICWqMXy6FIMoh4yTIlV9qjq2mgqrXOTrzLdMps6BUZ+o4YfqsZYQD0rnoMkbSSEPcp3B
	 URAfKOZmSYJ+/nzXJC3z5jnDKeCUhA5JdnZcW/hi014A/4uPLefAFzFJiis2eR2SkilvY
	 I0PozXJoG6sgWqJ2okwJ+hJYBJi5jXgZ8aovoO2Edi3o4saJoe1Gr+xejOz4hFL67uN6Y
	 zHZQpbAB884fINjIrE5W530NipbHpRxNgf3n/92XOHyJr6c/FxRoJBzAO/mEybD9NzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mUg64a7U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3CEAC606A327;
	Mon, 23 Nov 2026 15:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mUg64a7U
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1F8121F000CA;
	Mon, 23 Nov 2026 15:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795448115;
	bh=NrKgzfcLZFljaKhwZAHVe0DSjWSfUpDmRRp+D9I8Z5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mUg64a7UkZwIbJ8HajTqlauh9v4J6st9Ev173OIHS3l6CBfz+3ChN12Hg5qDqpM2/
	 SycAiy/PkMBtodaeZvL6Pjhcq7EXJxBHQOiuLS46gY2Q/HGp7vWd6hHZwdI5DR2Hse
	 WXkB72nQv59nw7S4RkNHUWEPqgCn/L3VKL4Bx0KlN41su24+LZQywhkpjN5pqxhZta
	 RrkRA44WZEx/u36m1OBzeu1O+gH54a3KZ6L5IWruRVOH6XEa+Dx5yQ9O3oOsYM6gWE
	 6cEyhav0eT1A5KPBrrcBTDNZ8FV+ld+UpaMNroNyQWMgiLGoZ66NiyhYOxaxEOZxA5
	 ouKg7PRjrmn+w==
Date: Mon, 23 Nov 2026 16:35:12 +0100
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
	linux-arm-kernel@lists.infradead.org, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v12 4/4] arm: multi_v7_defconfig: update the Qualcomm
 Crypto Engine entry
Message-ID: <67x7gbbhew4xkqhy2wpg2pqjges6kbbswlgpuxhcjuzaj5jtm3@aseuedq5zf5z>
References: <20261120-qce-fix-self-tests-v12-0-b5a2a44bc5ae@oss.qualcomm.com>
 <20261120-qce-fix-self-tests-v12-4-b5a2a44bc5ae@oss.qualcomm.com>
 <e3d2cca6-056f-4ce1-8701-a2592b18b729@kernel.org>
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
In-Reply-To: <e3d2cca6-056f-4ce1-8701-a2592b18b729@kernel.org>

On Sat, Nov 21, 2026 at 02:07:40PM +0100, Krzysztof Kozlowski wrote:
> On 20/11/2026 20:34, Bartosz Golaszewski wrote:
> >  CONFIG_KEYSTONE_NAVIGATOR_QMSS=y
> > @@ -1306,7 +1307,6 @@ CONFIG_CRYPTO_DEV_ATMEL_AES=m
> >  CONFIG_CRYPTO_DEV_ATMEL_TDES=m
> >  CONFIG_CRYPTO_DEV_ATMEL_SHA=m
> >  CONFIG_CRYPTO_DEV_MARVELL_CESA=m
> > -CONFIG_CRYPTO_DEV_QCE=m
> 
> I don't understand what is the base here. base-commit from cover letter
> is unknown for my tree.
> 
> There is no such code for half a year.
>

What? Base commit is just next-20261120, full hash in cover letter is
909ef7a9a30fa139e69e555e3606680f5cca7726.

Bart
