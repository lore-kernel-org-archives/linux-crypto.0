Received: from sonic310-13.consmr.mail.bf2.yahoo.com (sonic310-13.consmr.mail.bf2.yahoo.com [74.6.135.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E06112AAF7
	for <linux-crypto@vger.kernel.org>; Thu, 15 Feb 2024 11:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.135.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996848; cv=none; b=jheTEOiBFqUGn02tQXPSQgU3zCHySqBbF+EsglC5gr4+JGMR07DKtml9myxFsjoRW2w9N4tQlPZwIQiP6FB/lU7d+6DAlCjEgdmfn/W/pDTSYAqxSiJyQKsEn4jPPjxguydPDW9oPmn75bI1ds332P8gWcbGZFvsv4UQE62ihaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996848; c=relaxed/simple;
	bh=hDIOLjrbNNDIabUnTZKrYddHujpONz0pPmVUS/WxIks=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=ZUXfJEIy+UMahujTiav0+CRlxo9NB3ROhwtCDrN3nqkC+BmgfAX9n4+5DYgII8sWZSpRXESxxozPqdhRy1M5nKP9MjD7XW2sqdKBVKVM1szCpTSdKCon/KjLbstIcLRFjjOu/WJDM6oq572IS29kLcANObqIeMjVCTOoqhaAepc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=FnhxNbqY; arc=none smtp.client-ip=74.6.135.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="FnhxNbqY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1707996845; bh=hDIOLjrbNNDIabUnTZKrYddHujpONz0pPmVUS/WxIks=; h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=FnhxNbqYfh8cOADXTRu+Vc+DeOuJGF6NL+VQiD1sF0yFtxnrap7l53dwOFi1px+16hYduidorB31cE2j63BLLfnja+1FtSBNTJ1yTFNwT6PYuAX4XccuW5Di4PdH0QAse1wl3gHDWyjzyP4QfYNlOxQXRR9UiRtKIp6c014++7U8JwxWbpdj73rmkRmV1LFO4Sq7wXkGYb5czYimgxwxEH17NQF9ks99fVi3ajBXURA1qE9ywKRw1l+8D6bH0RZEuHdg03AlzJ0kjJi8V83c95LBS3R+ck+DU5+YtCRgtke6bdSlpBhkK0hhUKChgrF4seKmK1pKKTv0s25SqcBkgg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1707996845; bh=rTBSlXtNpCWn4FVH0Be8KiNEqUVVVkHKklc/amo1/Wz=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=qpEA2J+iQgEVHYK1D9Hgn5nGqm4MgGr8wR4AKw9h6gsyf/aQ3eqrlURdjwoad6Yu6/QSAk/6H9QUlPzqsFyck9dhufVl30JhAwc09relJHE2Bal/sy0NA/N8D7Pl62jwGGhyMbQePJT85OUFM0GvLeFCvr87xDKmWR7vg7oSLcyT7Bveu+sbgLsNAuEjA3SqB9wVWBW7mjXBdtagjLUkbgU/fAhw5STPZPZAhpUORDtCvSaONz2TbraW+Yd1BAL3g6NbLuPb5p58qbwV3zpOuNRAgopABJGF5ON3MhoUSkHUntBHC02D+A6nnN/aGgVb+cu3YhrOGEikM/e+WvHXZw==
X-YMail-OSG: 6rn0cI0VM1lB5x7TuaTdlfddTw2f2STqW3KVjnZ48avGRc2yh4n5zaGtcgaD0rC
 PGBcvsYP3b7nW3ZCXpNp9IgHqMMQmtQqioUaDrZhm7c_pjajhgHJ_YdKe3O7Ci6BUsH8bvU7UNex
 Sf5HByYeioUZ8AW9U2fvm3x01u4zDkH7OKEfL9DEV.8ebexDGVQFlvQFh4kYjeGagjmji9TK2Kza
 q5SwSR2Gv9nLZaFR33lk4S54ZDxKk8D332Oi8KHm7Az0MAUF1ZBx1NIcARMRmDhvjg1qzvdg7YNM
 bt82NSynXWiQFD.G2T1VOzV3HOGeu_fHNWIpL1D0xgmPByADLBnAFnftJoNiJgDgnv8zBo8IV4S2
 _AF3N.siUN0ZafQnSDF.GUDFRuxLaZ8trK.LcrEQm54uOuBlxe0JSlPqenQPqCEgSUMY3QHC4bsW
 1r_7YEnPdO.oqwv1T0P2KyTDJZ.pERYaQmDJzV98t71SR2c3IFaBDe.29OYblmFIqNuiGEgB.YGQ
 AvX9bQsxCVLCgm1fmWsTPZEqr2bF1icyhwJFLtqWkoCwwOORpkCOegEf1mo3ZSZmO45seHeZHb3O
 UFy8b52.XTr1jFJoqErGeNt0kHTzYyU0O3wt2prhJIo5N2j2n1LufIPqpEF5X9sp2jm2pfpIlOCp
 SpT402b1Mg1M.3WftTAg_ui3VUvOZ5JGjBziCX_tv.6K2vAAmhVjcvPxc_fahOLoDB2MIQWqWQxb
 onMPmUJdIwpfA8IaVX9EjF_yx5M2XauIYN9dB.XFEwWSEoVLuY04ATrV8WEdMIVFx.fJnkv2LUl2
 e5Gb.hiKL5f6qUvNZ.kQKEqOl39QRnMVkjmXGU_kDfMuiWryh9JBiFwhzmQGuryWWDEVme5VW3aQ
 Ck5LZAvtBPd3tTE6uB38EHjEbIl06G_eNpRq7BZ3zR9C2JFX1dT89X4YHVyrlJ2XeWKJDHAlQUtq
 HIui8U2LjPa85_1h0rUwydW_.76hA7UJkQxO5.xz6WzBwrjT2dEVaVdkeNlviGYrBo14bq4wiwkK
 5i6UR5pEvout1wZjidSzSlv8xxQPd32ZY1veW4_JKd1j0vNL1QnAuAqyMYXvvDB4ylGdCPa7.REm
 hnnbHtV_zHH_NPjMFiE2qfsf6zKv1a2flzX3UYrNNGMwwdHu7tlyKlt8mCLF.cT0C2o4iIO_FqOC
 uQWS12W2MJVLWtuigkE8blZT1PoS_UNNHn0KH1u7rkRjtN2zco806LKdWIi6gFbaOFsWoH1bkxiP
 em3dqqTY2kI4B9dzPwUcM2kNR.FlX3piC09wZ7KoqhXJK2b2He.w.ny2ARIZ4zWepK8JqJ0BjIFe
 CPvWXPrH5t2FYF2gJ99bwg7s376wGvpuEl8fayExWGM3INW1xS07TeMAwA03yFLWz54IHAmSXb0o
 0MhIbjMmvacRno_dxE0A_2rocAVUW5VSBldVYO.Snz16Hfp7EJiP_Mq6coJ0ebUsqoNIoMv95jyc
 gnsEkRyd8Jt0qc59mT8PTDzFRcqnFtDwx2z2ktUOws9DPb7LazWIHTyOAEJ9Jry8f4xnvvVtpfMS
 W8CMAiiSx067cbnoCWWQY4jdSS.nXGbsSyBX9czoJ4HD_t3Wn578izCgBFP7BwvfKl6PIL1WknhN
 _8bewncuphFCRne4h4zsFUdc9LNsus3BnP3PTiAIGRc4RXl9UCfNlm3cLTQPt.3fyKMy3n59ztQR
 NZBBUtlcerQxXJ.kk4Y4ZNYp2vGGxTEdTJFvu4armSO4fc7VrHq4TK.BsSZgmO6bt63qMeeikajQ
 MUNSKKH63fO7rFHjCtQnJhcp9LX.5Y2rVZDdHQhM.mK.jjQaQdEhDcqcBDcYrSC5oVFS.yvS8err
 yJLSsQVxTgkXSYfQSRo5XSMw1iNLx0EVm78u0vkh_w.va7ezoDD39ocNOqoH2GrdSSPF53qgOlvj
 g0djJNoQvKrjeCDn8FCRTKsEXrdFPR42g4Fv8OC0z.SLSQysFX7woT0W3N45o1E__VKKazJgBo.k
 5nM.wa3C1EXVR_l8OsmkXTvDewSUfHQX59PiDR4ZeMZkRoYY8xmx1irwlwOMzDwqUS5qTnI1RcVL
 YRhteovJk8V3SfhZpaGff9PfpsTngZ8mSGxNH9tjBEQeHk6n6CcUOD73X_09xujSWpOUTCYvVi1x
 hvihsMoBqS0gVWihE1Ed0JNPm4u9rpA2lICkZb7D7BvLQb3fPr6mqTNJ1iFS4THUlCyXa4CPqgXy
 GvCUVZCuefXKCVZnnHczTKnEgCyRA73auaaM4gajW_ZqmFrKVhenW7DdD08xxe7az7zNwJlczI7S
 hGfGSja1Qmxi9FCkxtrIdATc-
X-Sonic-MF: <helenz98@yahoo.com>
X-Sonic-ID: b18f5f10-45fd-475b-904c-b17f2faad8bc
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Thu, 15 Feb 2024 11:34:05 +0000
Date: Thu, 15 Feb 2024 11:34:01 +0000 (UTC)
From: HelenH Zhang <helenz98@yahoo.com>
Reply-To: HelenH Zhang <helenz98@yahoo.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"davem@davemloft.net" <davem@davemloft.net>
Message-ID: <406531870.1502858.1707996841786@mail.yahoo.com>
In-Reply-To: <Zc1yebAjAJoY2rwW@gondor.apana.org.au>
References: <334623130.1130500.1707860532447.ref@mail.yahoo.com> <334623130.1130500.1707860532447@mail.yahoo.com> <Zc1yebAjAJoY2rwW@gondor.apana.org.au>
Subject: Re: code question for dh to kernel v6.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.22077 YMailNorrin

>
> at line 373:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 n =3D roundup_pow_of_two(2 * safe_prime->max_strength);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 WARN_ON_ONCE(n & ((1u << 6) - 1));
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0n >>=3D 6; /* Convert N into units of u64. */

n is the number of 8-byte words at this point and is used as such
to allocate memory.

>>> n is the number of 8-byte words. 8 bytes only needs to right shift 3, n=
ot 6.

> at line 444:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 /* n is in units of u64, convert to bytes. */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 *key_size =3D n << 3;

This converts n to a number of bytes again.

Helen
