Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B816309EFC;
	Wed,  5 Nov 2025 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762361794; cv=none; b=s9BncttxE0igG17dFKVjl6mZFwUzpx5PiE+R3CHmZxaDcStVU9s/kTFOOjgwuQbN7Jg2ck0B+oNPXKTJnRfkia9HNB8CJpvMW1cyW9weSCtInC1n2+jNYII/68EsbAg6YvKR3w02QgWqqGeb0ZHUe6cWZ/d3HINzpOpahXgfQhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762361794; c=relaxed/simple;
	bh=q831jl1cF8zNm8FS0acArMwbVgQD3zcUOSZNzIKNIHk=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=YGUuuqZgV/Co7BXLg7lcBU1AlCx7F4z3SlGOG3eREU6k2op+LISf+RTr8TB3Efdis35Tf2KX4UW8iSkcN6xHx0DZxwxO/Kn3Wu2YKJ+Xy3Yjkmi8JihB5Cjs+Px6B1J558ZCUXyrPNyi/3aafl541t5iGj8+kD+aNAGzBgL/yUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=EOfDwlEO; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="EOfDwlEO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1762361763; x=1762966563; i=markus.elfring@web.de;
	bh=7F1ptUCk3mTfddI3l+U3mYybiLgR31EFJTgVwt30kZM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=EOfDwlEOMkU7B5/JQb/6MdPre9HjWLBlPo665cwqw+XrfuQy+AR10267JDw9hnvv
	 AwVRl9WwiJY+p2k2gG4Wtkycm44+h60aay7woIQTq3Ar/E3j6r9r3tbze8ud+vDNS
	 NGx0zLeG2IWx96XgMQ90YFprVvWZ4rjCTWEFgOPTPHMiXwKc6cSDOCcU974tKZX0B
	 dDT5oeaovvuzMefzovwRDeV3F9KRQN+R+OhX7PGunkEVCMzoueSgKudmIjGqmjaQk
	 zTdN76CFwyxbmF6J0g1H/I3NkhRq521d4WVKYayoBkwDIatehjMXXbxhA+U9M0mm4
	 8IlAznA4MvVl+nEhcw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.250]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Mm9Va-1vyaBu3lSq-00jxTY; Wed, 05
 Nov 2025 17:56:02 +0100
Message-ID: <70685d39-9fc4-4e1d-a6a6-bd82cac9b007@web.de>
Date: Wed, 5 Nov 2025 17:55:56 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Karina Yankevich <k.yankevich@omp.ru>, linux-crypto@vger.kernel.org,
 linux-rockchip@lists.infradead.org, lvc-project@linuxtesting.org,
 Corentin Labbe <clabbe@baylibre.com>, Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>
References: <20251105145204.2888978-1-k.yankevich@omp.ru>
Subject: Re: [PATCH] crypto: rockchip - drop redundant
 crypto_skcipher_ivsize() calls
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251105145204.2888978-1-k.yankevich@omp.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:VE8lofZA5E4x7hKrt/DXhN2ckemiQDEGFrgEzzWcVo0irE5d07j
 NRWoDqGKjDTSGhb0V3qy3R3NrPMPbCy6mnsxfl3O0/wvgs9/SVgg7cPrpCyv3quv72yBq32
 abaRFvskZKXMDoBtx2c5pR8MVYWZ1jw9bRlCU37iCSaAZLEGPMRJTeotYLiobtPz6uEAS46
 nyDY/uonCgNi9OS7J0mCA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZtqK/5Ww9Ac=;UezMWwWflR+Xqxz50qf+Ak3Ansc
 a076EKznxBt97UsAAkXusukD2fsiq3wSKKVm3oRSIYZL6PeEeBouATvfQmKKYWkmrQwfXsivJ
 MVrX5szNyE9FHIeQ9yTLRRyZ07pCJEy5um3ZBo9Jj2M7ToxXjjtrNSja7IseZoIUtUeQYY0Jg
 R4+3Dd9SCZiByhkf1TJi+1CaE1x/R+fpxBTFQ2WuRPKyiI5ahGsY5rD8LJZFJHeBqyf3noSD0
 X/iZhNTX9KTLSLV3gsJiOWFq5MKNNuQ+2atttZMQntPR7gOPlOSs3c7JojqBtgfPgBNo6slaE
 3mbHq6hBzgPK41LD7lq3Bv7zoOK101f+jkkJgoxBQ9Ntpk03XhDyzw2J1d5RtbJwogb48tAZW
 BnHLDOZW0RVQLGuya/6Lv46Gv7TzjWXF5BK2ilPhJTLKsJ9vK0mynHJegw/HajQcXlVW20Ehh
 lGZBdJ+Jp8x94S/T2hwiG6/n4WBL34thTfBvP0dVsJzhuUTr7HwgoDbFyDuDhUn/siA17W70n
 wQW5fpclRH5PGC8Y0V2vHxTcpL9dijqPe0wbhUa5CAU4yyr/KBcaij60klmHXhHMqLOuorF3j
 1E+naDkOqq7ANmTKc2vc8MSm7rPWoJgbmdsCx79Zq1Vxe34wi+RkbsBy0ITMD6wwMmQkHPBpy
 ukcfBxRCJOKDQkn6Ha0fePKh2ETXWLw9gRamcNdJgSawTyKEL6EyMPTil6E/SLolQ2v8TOEur
 ZWAqqG/S5PpiQJ/Gt+7EVUiiqjsNrdxm7h4c+bDgW4aDnltMHR1309O8JQOcO4/lVnCD2u8zA
 1/THR/gxGjn5Q0ev7IbltQoa4CQj5Oowwlrofp3g1moUV8vpjUUgzVVco83x6u66SY6r65B55
 JrCyZeOLZUT7UCh4QvumfJMOT+wY2R6KowNTUKNNG3JG/tm1VGKWmU+reN/KyRK4Ywy+O0gWJ
 65yjP1vhvMKzPCKX/o+K+VRY+DyJ57X9Fv1/5/xswO4rTlN8SnsCDeJ6AUDgVk3ff/u53UUqL
 jJfULZdb75XxWPJPiHmQadpdkFfwXccTMTwsagHwyg32qtVFxG9T+g9RGvlXw7NBVTGyzzzCU
 dVgnwXcF/sA9LhqsRkKSlIombH5CfcZfnSd4YmWdDwAANqzImgtw8rd0T7/CuCmOQ2/oOK3uf
 gZCFdHWiY/1WOQccVm6OsIFE+KtXk/eu+IFQGTa9q+hsVGKkiky6R9PnYMyC/rMAyryOuFVCI
 YMssiIE9FBHGNrOkdnqx0tfI9fzi9JEY+viUb8pmBQbPEvMCS9Q4Td+mcEPLftkynckHBjNTb
 koxnB6iNWhWvyUC3yp6WrIfjZRKSgkvE2GjnxTGqkxrOx/Nn/TgANXUP3AKGl9T/EE1wGinay
 OTs6EKZ0L5rKbAcl/cLlEKFG/87XZeRA6JiuOSavPO8urg4tqD4krzFjbn8FqSYM3bnhlGnqi
 A7R/6jopz5OZeJpZmKtaCGbvsG/pPfO56wh4G37V2E5FP7he0zuEr5fUNN9i4kp0f060nKHDr
 sIgvIAtgpdBJPAyLgrHSiwCsjsYaHprOUHszSFuE/KIiiOa5LU8Up8Eqy/f28tqdqRSglDIVk
 truoaPJkymUyShX80S4Js5TU/d5UN9KXgsKu6yC8qIPPRdOiL5YE+eMvLWyQU5qUqrbO3i2/d
 u8qRSznUJOkdwZbDRoTcUEZRsSRZrUjC4/+KU4VOFZ9pFir4ACLoD48jBXjc7mkVF59CQmXBM
 qIRaCn1aVPzPn2Fdk2VGz81kPhXCzcm35Lkpq3p7RS9Tl0O1gQ4ZmmMbNJ3uKi8aFSgfGAlPH
 w7JycXwSoA55lk0agN6IZp0kUfsTRNiy8ADjFPlkrW9uy4i9BoY7bu0MxlJTdLYj9ncViyfBp
 6iu7mAuBQvr9z/PlnVLKVe770VHDbsVP2DV79b9XU0OdLw5nxbtYQGG3ALLB/4yOCswD/2nBl
 rYYtYO6tz2CsFyirM2de7oz8s8pujTrkfAUsZjMfcAeyacnU9hnvzbHVXwijhDAT26NKhOKU6
 6D5TyA4ojsagV2Bqp0I+9qpvLJkcnPkRqzx4vD9tAbOCYM/qGLyQwLzFfgOQ/Wf42HnTG1jLf
 XqUtsDZncOyicOCet7NMdCzaOCiN1R+6cpL6O06J/P/y1zmsYw3wJh2KXfWTCyAPFh18JD5t7
 fiviPewM56rvyAVJK/EXwbO7+NLfdehJ8eKk7z6KphXDXfP/ulA6u3U3GaUOohb5pkjIy89WR
 EWVCkYXJe7MqL2AHVN1FMJGnuS9IEfSxRTI5bt82h5F3OsxftPHMWCZSTJQcQFrSDIIlUfvFQ
 1+hsjuk/9K5u8Ujk5V5r8dMDdkaBCa82swDii7r8AyCFWxlptzZ89LmuHDLpRtJidyt3d496Z
 c2a8Rnux9A8wwkuhCATeYEhKiRF9xWCOC67gTOhQDOjU35zCEOXMEzkX25RabBOJdoecojmuL
 HnKqKrSjvTbrSUjP4J0npCUwCcm5zRi90VFKLICVIExcy3+fbBGfA529TBM4ANGqZbT3egPAu
 9W9iILaUvmHTWjD5IaldM135GZrL3AIZiv803GzDBuSkW20+W6iuF2YslFo63ZLhOIgA3jswD
 X5jnI1mXWopUI6JMDrPkYqDopplrQ+wGBtIPREIkASlHZR/qOD+SeO/Jv867wpRQx3bwd4lnR
 ycAP2nzqkRmDLX0JNstT90IWqhpc5sU9vjn+Nv9fGPJIcG4VDlShkVT3Ypb36FGaOfI0R1Dai
 hJVHW4MvhMWJWwqhxW97uNe0F24wVzfL9a9wQLPiaUUggQ5RbqfBG2Nm8zM3BDbKobaeQcRcQ
 6BNA1GcPOi+7je8Z+EV4U8MSS+XJl881xSaGEUM81rg67BbZxWyQ3aMv+p+2N/NrJgs4jGlZV
 9WdHYdMkUY9Mw7F3VoDiwyn+L1RUihBp6n7A4j5YL5XU4D8j8FLfwpsoxAnRn3BYztpptfgCE
 JCdOZR1r23YjQVv2xmHY33BUf86X6WqcESF40FFqDq1Cug8BpvMrnUg12LROmEn1tvX/MgnfO
 ce8r/daMt3uC3aCOtdKCUF/JOhKCqcAW6yUcjR+iuZI+ldiVpUYl//NREN31xQa05WWTveMUo
 iIhq+lKOcrvnHunp+o754YRGGOWemO+xaWb5np+mSgpNpmSjbmJ9rkJdIauCYbq9N+Ihl3KrU
 vQz6WdS21g8Y8K9iFthsf5QPTmLzIHY0ShI7OuksHe09Qs0JaBBx3Qrp/NowhiUfipKU5Xd9G
 KNOpayeyQUwrvoEOvbBthGHN79FbZM4RkNb3zLwdSpjy0OTb1UvBCJl1N0bknSfUzuM7RvBlm
 hyvi6WNHuUcEIfMQwE5JwIRdrqmf7zT9pxAYIs2c1TKSP8B1PMbV+IJWHHCt4QZV6ghfEe+Ph
 T2YrjlwLYoLpz8BiKCSg9bc7eWme+ZKFFTwBqzDUuw+KmHAJiTQYV8dbpUVpn4QEXrh6eGlqO
 r31ZodeVV4rr074ILwSwCG2tTpFvhYmtfOzTjqx0oXIJiP/wt1/CAaxmmHXMk0mRxwNqg4zi1
 UHCsuIy8QTs5poqRAlqNdYIYVq0ZaHcM0YB7iI4XuIMbqr9AY3yn3JjxcYslgaf7cCeFWlo+U
 c+qm+mjhSGN1LmubsyMpk3xd47LgTzqZRcr3luy8g/pi4HsTh4vm3vLUeRuMZSYsWKWWqcy3O
 yrdGNttKSOFxUCVQAmTeL1mGf8tEqnPITwOmd6k9o1KZWBeWWh+DVJ4fBMxvY+jhByrnnTJq3
 qD3RFm6AnPlfh27p2R9B8ydg+89mRdHvF4C7Mn2wjh7wnSvGqZiJBdy6n6AFt53pSJ3isVKQA
 JX5zMlzhAvfr+IyKo4pVVipCtsIpWnbQJGmo6p17uBoyvtDaA+3S3wCBMKPLE/SOWECnHPdTp
 tZxDiXz940KIZKJ2M5HGkNuvoeczFAoHmxnAADgWsKL5ZZgXG1J+n6S1OIDvt8o7UDEaz1RVd
 /HD2Z8XBk4R9z7uqaPQSUT7t5h76EXmG4o6HUbilkndRsnhfN7bilRYuGbD5cMwywjKTqSO5n
 C5Sm6zPOz6cFv5ausGgUzjXTGyRGvY//29Nh0KGpCwY/FC0/iBaYG8s64uUDczXN9UWb4TJsp
 eBW2K+WhxOvo4QVkj8eSjGa41CaeXt1khA9grrNVGILkMBIhX3BmsK6cmcMdtpgj9hD0b1j11
 LfVgbTaqTEet0OrdeK/OK03ZlwJOBe/o+1qPM0fMSX8b6SJZXaX0sekU4CNjIL0ifUN6Ebj+c
 OhP+KmuUAesW4FUOZk1b3WNEbPnhxmTPZMvGGKJaUIudFSxZ+YwJg7GV+oDZg44pemNtt5O0q
 jPB94149jLNv/PWrpGWSkCU15ucydbQFJbIT/VNHCJpmIiiy4QpLyKdTR1rRwBBhUNNKlMA6j
 ptY1EhG0Fx81MoZLL6efwO/fe4dkVHwVC+1Pn9X1hUZeRe7C7na0CNXs/yaxgvtYwkSOKvrBp
 4zoAm/MiTUoaX4Fd3EDtxvmxGIHojz+Ser+bqZ6QIkL5gCzO3R+oCmj5vCH+RItUT0YgyZhGY
 tlvpyCgxjuShHWQeg6BoLjG8eCvWnLcz7W1MDZXSfnrH2OQzy2u4lSJvw3wceyEsPdr+EG+Py
 r5Ba7gMC64JOFNeqUyAYmv1gi8PE+CztTafsBSKLtl7Ddtv1HCe5fQ2h9rWANCK+4RdAkoS9S
 3PuRcIXClZV+nqCr8U7phvVqdIZ7wsDZ9JhBxDGMor5OYyLr/sw8fHKPspJnANwO9kOpRpYOn
 z4Uw955A7j7UwgGY8oMl3RBl81VBkp9qhEuB2rRlsiSD6H7t6p8GdbOLvGSWqfNf/qTmqIP17
 wHjMJmKyh5dcPEjYuhZswzlzx3l3N4Ubpt0QK4BIxiLbmwznagF3Dlgpp3Arrs9/EMg5KlwjN
 m0lC/N+EvQvga1ZjfxoMxHla8WdULFGrzj0hYulczfQ6mdcYkSrzLUGWI7MTYqcAAqO/6fXcb
 g5+PpO63u3dYoDqXHeTZEYn0bFRHkERQG5ZtOSZeXoCDmAOZNy/VaUvuAWFoFVp5zZxFthhAP
 FcLQbwoczW6/0H99E7n40YPqus=

> The function already initialized the ivsize variable=20
> at the point of declaration, let's use it instead of=20
> calling crypto_skcipher_ivsize() extra couple times.
=E2=80=A6

* You may occasionally put more than 52 characters into text lines
  of such a change description.
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst?h=3Dv6.18-rc4#n658

* How do you think about to reduce the scope for such a local variable?


Regards,
Markus
