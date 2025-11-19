Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A6934C988;
	Wed, 19 Nov 2025 10:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763547782; cv=none; b=P7F3FDqKfOxbmTZ3hXh0qBWQ0FM6AmimuikSDQ2X/+wyG3qYX5zCQDNfIYH3ke44jHT3BoER8ENupPyN+FjGsZH4auvbEd8Tt9bpI9Czp0ZqeOD7eIXNh9Lh1CBhEc49x37bCESh+5PLiY83ZB35kmdxApJla8WyrA59RYfxE3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763547782; c=relaxed/simple;
	bh=etSxlk3VdiVuno4QNgeaBsata9waidEkviYpV9PQZHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nskjlETNbthL+TfPZmUtse8QNY2m239gekuC3USkUGfrF4zar9Zt3bwgJFmk4TAglw8JupRJV6P/n7iAGuyTAcxBoD6It0SJ3ggUjLVcYw9yQSz2WNhP4VJua6/7rQKZZEhP+g9g62r0SHYVxkLnXMVYBPjywTEO+jQCgGORMOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=NBvCl5mz; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="NBvCl5mz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1763547775; x=1764152575; i=markus.elfring@web.de;
	bh=tIGlYpdUl0sVRsSnYywWJ0QnlzCdlV+htmmqnf9W4h0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=NBvCl5mzcA0Z0FAmT/IvYxs1itUPBqizTf/IdGZOe2ZTcbmdlLB/42V8qQ05zgha
	 MLZ8CZUwhBAA0KKpi6eLitmKSjY+1pg7B5cSbbUKJ73etGuG12njj4Jqkk9Rf+CwU
	 ZfVmmdjzg/b61z19dbKSDfIBKc3sAQfNnWIY6ZA7bHfQ5FDK8ZiE7tAHodCD7qyx8
	 sIhb03TnGVm3GTkTEcFwrBjnSAKZPDFFT1YgvlzfgyF6oQrr6zDYqdBGTJOchrEi5
	 ck6PiG/uVssbSZO3k3HDk+q2BbHmowEq33iMbZCLllmzgB0bAh0KDiTESjFRL500F
	 P1wdXqAb0OY4c8/3TA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.228]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MZjET-1vgvhE0fFn-00OfgR; Wed, 19
 Nov 2025 11:16:43 +0100
Message-ID: <af38ab0e-79b8-432d-a923-16d2af129154@web.de>
Date: Wed, 19 Nov 2025 11:16:22 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: rng - Combine two seq_printf() calls into one in
 crypto_rng_show()
To: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Neil Horman <nhorman@tuxdriver.com>, LKML <linux-kernel@vger.kernel.org>
References: <d9574f40-8d0f-4f14-bc9f-b29c56069b8b@web.de>
 <aR1LcMOO0B6qUdOX@gondor.apana.org.au>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <aR1LcMOO0B6qUdOX@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:VWM2MQ5W6BCYVcyQbH4/QP8OGNhnSqnxLVGkLz6GcdTghW+Hq1c
 nG0UNMvsS5kr6bXKn9e72tC2K9r2vAljq/yAzUQiJa8cKlEeoyeWv7cp056odTaT4hOyR03
 LT7hAEhjs/ByPP45jgV5OYhHOvRQH7T2UqXn3Asb2B/CZRFpyBxKpYvx0qOJmxD/TeakkFr
 SOj/59QdZB9IaLqXo+erQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:22ZrfbNc1rY=;j/xWTvtIXaHlXqDLdqIDnSdE8/k
 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
 yus3zHF7vDXZtYTco=

=E2=80=A6>> +++ b/crypto/rng.c
>> @@ -81,8 +81,7 @@ static void crypto_rng_show(struct seq_file *m, struc=
t crypto_alg *alg)
>>  	__maybe_unused;
>>  static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg=
)
>>  {
>> -	seq_printf(m, "type         : rng\n");
>> -	seq_printf(m, "seedsize     : %u\n", seedsize(alg));
>> +	seq_printf(m, "type         : rng\nseedsize     : %u\n", seedsize(alg=
));
>=20
> This makes the code look worse and appears to be an optimisation
> that isn't really needed.

Would you expect to specify still two string literals at such a source cod=
e place?

Regards,
Markus
