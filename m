Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9ED477983
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2026 18:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785522724; cv=none; b=AzUW2n22x2EjbgFiAtzg89YUvdifgfA3fxsEAhx/69Bg6E8fs/7tejA46UI7qNcVrdpHMsQvH1c4K3bSqLKtUxJHBVvFbSDDw6UbukE0UNBLkx/0vvwmGv8kJGsYD6Il5cECWNJCxsJPmRpbLBrZxJA/SVLFlimFKn4jNaO77t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785522724; c=relaxed/simple;
	bh=WtJ5MLapSs/5+OHOfelAdhfT+m5cHtdwpiikQ9In/tI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tt5yGks8bBkQEP3k1MCiww3MFKAhW2F0EFpJkMJLmBZ0T62wQF1GUQisoc2fAAsGePnGmfPf1J/rIoN/nNRdFZe6oiSRFRMEd/sJTpz8RpkPxwRmC9h9Ok8y/54m0gGrvHsEQ5yth5olyxrT8X8m7puFDGQTw/+jFzHA/2Dla5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LegumlpE; arc=none smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LegumlpE"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6681e7911b0so1648451d50.0
        for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2026 11:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785522722; x=1786127522; darn=vger.kernel.org;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1pgvz5gAD7Hw+MqfudMvXhhl6EBpJRyIn40riGMqdVs=;
        b=LegumlpE+ea8c8V6Xy2aYV3NinlSwoFwk+Z4+UAHyVYZ12e2hL8ExYAAdSbMGDYWKs
         sTd16EmWhpSHktOvShUUnpnuYuJ+MsdhJo56yXsL196Q6WBHd/mQNkRmCQMsUSCVBj4R
         ruez2/ggAxxMv6JbrqhYzRDerk54Raq+Fz6cBzq2MJUb2+daLo9to6bC7CbgE3pTf7IY
         CPk1v15ytecQ12k33afdvZ+5CHN4H6MBnm1NOInxB/dIfRk8G1hVbQsg8cPLExiqSVi2
         VS5Wlt+T9rzc9EBjTEaOSZscwv7Np/Yxm6dkNzEvfG76SIsTzzASKYGaZPu1UHEMk+6D
         Ji7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785522722; x=1786127522;
        h=content-type:in-reply-to:autocrypt:from:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1pgvz5gAD7Hw+MqfudMvXhhl6EBpJRyIn40riGMqdVs=;
        b=oOwYqZhtvFf11WZoW54PhRCCWVYsdQ9Yml6rwsQZbZ/Lxe19r+z7K3UzgEEBPazf1X
         O6Gv7xJ95sBi7c0qxRZ9yIwaYJYkQ3yNgikPGZNTbPrGsM3GCiKyz8BTb+9LSHNwC8do
         I1A7Qe5raasil5nwVV8sprv0iQ0u5c5ENBcIXbXYCV5TVIDAwBqzqT+LIWWECHjKRM6m
         pg6RkDyHJqYArrJsNhnzIYsuQcriob2Dpyc2x631i6wg2FgTyRo/afK0zvyKRQ4pdLwn
         7StLB3URzkeAobHQH4bVCscDNILlc/WUxA9hTgXHWcb+QL3nsWLm7M9MwDAMI6UcwCYV
         ciQg==
X-Forwarded-Encrypted: i=1; AHgh+Rp0p34USVQJnNBhKuUnJEOKIbE3o/MmV2G/Vbmsan64vH/iCqpZ8zG4BsimfW9/iGA7IvfQVuGDh3QSQvg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu4oLktL8Nc1HW1CjfBJE72lTPi/FSM2+BwHNsHlNV4COg2uE4
	mgwjo9K7eFBZjAMrVapcC6MIdXtZuD0It2JWE7papSCvM5ySXLGYjQJR
X-Gm-Gg: AR+sD111gYbetFLirJOUf/cuf1tIz5vyAFZd4BlxkqG8COvn3FKOZEnpsbuTE6JL/5l
	xinQtV/tXVq1pM5hwZIA2SMkUWYa7CodloZp8ozNYya5/zLgGMXKLyFqPAysKpoDFoy8IA1z15e
	Pg8flB+FYeyFr5p/UgXeqNP/RKc+6tFoykfB7SlrPt10Z+WEWWFStFb38KvHZMn1s+ZRHLoc3wd
	xjXA00pwC+vPi6io+YCXlEKn956CjS8CmSsEO3sq5KrvaLvBOcaOoNcq52WSmaODBgXYMrtLi7h
	HNMBZYBWWe9LWnwvFXGC/cyWM33j81UU18ZBaQNibDvcJ6wkCH/0/wvJXDdEGhKnh8jKZZvl/Cf
	n4KMKkWkfFd3mC3djgzBXplM26MqRAjVMEB1CbvUUCYgN9CECsProu/tbIImEvIqC1NTeXg7j4X
	T1YHOq5VwL9utBt9qYGN5SDkrAPzofChAyLS5p21qhln1PvIj86z3H+WZiRsySkY8=
X-Received: by 2002:a05:690e:4811:b0:652:5567:b3ec with SMTP id 956f58d0204a3-6694f1baaeamr929342d50.37.1785522721944;
        Fri, 31 Jul 2026 11:32:01 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66948cff660sm1073441d50.3.2026.07.31.11.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 11:32:00 -0700 (PDT)
Message-ID: <3ba57269-3305-4d80-b3f2-aa82fa59b59d@gmail.com>
Date: Fri, 31 Jul 2026 14:31:45 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
To: Krzysztof Kozlowski <krzk@kernel.org>, Eric Biggers
 <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Bartosz Golaszewski <brgl@kernel.org>,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20260731050838.158825-1-ebiggers@kernel.org>
 <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------HdbkbXaosHtNrC3ZM5XYZQZq"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------HdbkbXaosHtNrC3ZM5XYZQZq
Content-Type: multipart/mixed; boundary="------------xNPkSkf7BAKQGc6JdueYE4T0";
 protected-headers="v1"; hp="clear"
Message-ID: <3ba57269-3305-4d80-b3f2-aa82fa59b59d@gmail.com>
Date: Fri, 31 Jul 2026 14:31:45 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
To: Krzysztof Kozlowski <krzk@kernel.org>, Eric Biggers
 <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Bartosz Golaszewski <brgl@kernel.org>,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20260731050838.158825-1-ebiggers@kernel.org>
 <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
Content-Language: en-US
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>

--------------xNPkSkf7BAKQGc6JdueYE4T0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 7/31/26 05:06, Krzysztof Kozlowski wrote:
> On 31/07/2026 07:08, Eric Biggers wrote:
>> None of the algorithms the QCE driver registers with the crypto API ar=
e
>> even close to being useful.  They're massively outperformed by the
>=20
> The amount of patches you send towards removal of QCE is really
> stunning. Or rather worrying. This is like third approach or so.
>=20
> Your previous approaches received valid feedback, including even fixes
> and committment of new maintainer.
>=20
> But you even complained that it does receive fixes! [1]
>=20
> We removed the driver temporarily from typical configurations, so no on=
e
> will be affected, by whatever is found now and not yet fixed. Still not=

> enough! For you this was reason to remove the driver (AGAIN!) [2]

A stub driver needs to be added for power management reasons.  It turns
out that if there is no driver, power consumption is very high.

> This is beyond comprehension and very unpleasant, because you actively
> work against the community with this approach.

I trust that Bartosz can fix the driver with enough work.  However,
even if the QCE driver had never had a single bug, it would still not
be worth using.  Its performance is so poor that one should always
use CPU-based crypto instead.  In the default configuration, that is
in fact what happens.

The QCE's algorithm implementations only provide a way people can
misconfigure their systems and ruin their performance.  There are
debug options that also severely harm performance, but they have
legitimate uses during development.  The current QCE driver doesn't.

I have no problem with a driver for the QCE that does something actually
useful.  While there are disagreements about whether restricted media
processing is a feature or an anti-feature, my view is that it is
better for it to be implemented upstream than in an out-of-tree driver.
However, the driver as it currently exists does not implement this.

I expect that such a driver would not use the crypto API at all.
Instead, I suspect it would use dmabufs for source and destination
buffers and integrate with the secure world firmware in some way.
That means that the driver doesn't belong under drivers/crypto.

These are the reasons I submitted a patch to mark the driver as BROKEN,
which Herbert Xu has since accepted.

> NAK
>=20
> Nacked-by: Krzysztof Kozlowski <krzk@kernel.org>
>=20
>=20
> [1] https://lore.kernel.org/all/20260728152241.GA4281@quark/
> [2] https://lore.kernel.org/all/20260724050645.223799-1-ebiggers@kernel=
=2Eorg/
>=20
>> CPU-based crypto (even actually using far more CPU cycles than the
>> CPU-based crypto, due to the massive driver overhead), don't provide a=
ny
>> security benefits over the CPU-based crypto, and have various other
>> issues.  They're also unrelated to the Inline Crypto Engine which work=
s
>> far better and is what is actually being used these days.
>>
>> Due to the major performance problems people experienced when
>> accidentally using this driver, the algorithms were already demoted to=

>> below the priority of ARMv8 CE in the crypto API several years ago.
>> Regardless of priority, these algorithms also aren't compatible with t=
he
>> most common uses of in-kernel crypto; for example, they don't support
>> dm-crypt because they allocate memory, and they don't support IPsec
>> since they take a mutex which isn't compatible with softirq context.
>>
>> It's time to move on and just drop this obsolete functionality entirel=
y.
>=20
> Best regards,
> Krzysztof


--=20
Sincerely,
Demi Marie Obenour (she/her/hers)

--------------xNPkSkf7BAKQGc6JdueYE4T0--

--------------HdbkbXaosHtNrC3ZM5XYZQZq
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmps6hsACgkQszaHOrMp
8lNwUBAAptSx+21WOpvepRQf2mxAoPgmKhOGw1fC0yyfvoukdVfEZyHnJIDWgy5V
S7pRzbRzJo4rCQh5G8pkdCQFWm3HAT2O9rG3t4KT1NF8Rag3s8G38TsTVzaaOzae
V5HYh8JxgImWPMP2pS087NR97KbQR+WfyYEjCXIERuMc9dW3ksM6fXj0Des36KpW
6hfqwmZWNThhThoAJqr5j/8nPNk/FCPyhMi6vuZlzFuMlsv2kgWxKhZjEpHYnYak
oopcGAQMPuqX2/lKblSeKEbW1fSa9faTcmDeH152e7p/fw/WRq5XSsK+DIhiP3ie
wyWSNTBbGhLgH84rdIfBhNsSA6NchJFMYfMe0hfLIhFmv2mjtlOX/YW53nHzqZ0+
8K847CDDhrz79DhYxhyYhGjmUhTxteaAei+gO1vzY49Ysf/9+6Vccc8YIDMdcoAS
22PMQkYJkTjzIfHLcYToxu38LoDJPQy3neM9XUvsLSYp2uQTb/TJSoy+HoPYXy6+
kS8zb3jTMJ3iCCOdM9CabOUplA5Rgxa92Gy87OEBZwPcRWf9w1LYI4Cob4XHEuub
41dku0PWGWuas8MKLH2NTRctKrvLvC9BClbC165SiQRm6QsgnJja+L9IvZzRqtfw
V55UjORv9Il8pY96/wo+0lg2UamEkcInsTMULyFdlelhPQe/02g=
=D3dI
-----END PGP SIGNATURE-----

--------------HdbkbXaosHtNrC3ZM5XYZQZq--
