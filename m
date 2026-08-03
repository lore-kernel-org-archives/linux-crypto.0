Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221013FCB2C
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 11:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785755924; cv=none; b=T5m8b+WTNgeYLF3q4qQMO/52M5zBEGqcnTmYzc7ge1MJPuZJm5xqhxvOmlpl3Jr+iqJok0waoPOgi2E7jIy4s/7iTDlIcnaH3KLHZdBpvV8PUWODfdTEPeW5QjRSixkzr9N9fz9BoQuLoznGXMhT68uMloYo3Hs9XpuQYbLZ8PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785755924; c=relaxed/simple;
	bh=ZKvjWxcvTqaYbrLPBephh33/+O5PaRp0Fm6YzqI8XG0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=SFVWrNMdvTn5qZ85j/9fxu6hvirHJFAtJLsJsR8KSchBh4KdHFlOs9aCnYHzHLpmcVGd6TrTD7vHE0tsOe8SQUARcyb9Bi7M703PQMb9Ff7eYF2xBSHHbVw5Qz/RA4uRP9BlnTxRVpS3szDeQ+2G7yfJ2kLUm6u16ZrO+Yf/UHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YmIckMfW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YmIckMfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD421F00A3A;
	Mon,  3 Aug 2026 11:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755922;
	bh=Ei+JIrB4PQI98W74kw+bi1lUAZD5gKKWciXheVotzV0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=YmIckMfWlTE2ioFOGrnCxBu8xSWZjNSIiTJgjX1IBUFch+s41MSZOR7dYY7dOwTYR
	 aZLYcmYb3UFF4gZ/aldmJP/5V+/w5WydKQO6NJFpGJQRIJ7cpFCtJ6kyM9tQ4rKpqC
	 lq8GULSBXpLEuPjfgv3YMSfLC29AyXQ4o2uQBvutS4r6nzfWsb6Afq6r8hwO+xcXZk
	 OVs/nPZ6p067WKRqevS6XpjPnW4pAermxKHrxKm8yYtKK+Zwn1cPQisPGUwOPKcRgP
	 gTXDwpOSa1VUnUzQYizIraEIBjm1lSO2xqSem2d3I0t8A/m0i5wbOACXFVu0TIm02n
	 JCKI+SzvKW2/w==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 03E711980078;
	Mon,  3 Aug 2026 07:18:41 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 03 Aug 2026 07:18:41 -0400
X-ME-Sender: <xms:D3lwavUdjOGxhdbRf028C1Dr6Cam14UURjY3F9zkEazD9h9QeleIcA>
    <xme:D3lwaiaz_dqznzg0mQ483OWedDX5yCD5zCyF8J8yRMAoimu3H2XhYfFrzAmRv7nrd
    F2KjVAue9XoflyN5x6o8zzf1gMvf2HrDmGt1UgD1nyjAJcoZnD-y4OL>
X-ME-Proxy-Cause: dmFkZTEPytod8A6izGFNuLGpjEf15FBiBQB99xmpySHZvVc9Ue4RYD2lTLPllCtBTpETvA
    9m3nL48kwW2633qRdQ9aynGI0Qbk7cZE3NRJVhsDrpyt8NBX+Pf4gFA5ery97PmfOxVrVb
    6oOmE0C97w//GaZahotkQLuw3t1ACyW3TWZOOpaaP2rW9wUSDTNhTa5TMGkAk/9lYs30ca
    uRnRmrQnY3HwUvQnX/b2b/dPQysDP+PIIvRpjBNhDPUP1a5/IR5chkdbEqEnnHMdBlfBkN
    7uElJgX16UjQH4LcHS9INUTjz6XnuG8Ykq2gX7DvZ6I6xd/PZNEjeZ4zHdzgIAxMhWMwV2
    GZHtCSq6Z1LlVQSquZwsocKP09jzcPDKLevSaCSSK/qZ5xfoxN8ctnfIvHeCuhn/UDu/UU
    PAPB2BSaZraYjpPFsRGIwlLl7TJ+4/Tbso9PxSbnWrum/Hcj1+MAE7/a/iluxH27J+LoNR
    roI/rECzqLrNCMsJb5tI5uiq9/N48VOuR2FWj7VS/Fs+yiqXr0c2RbhvbuElr6w3mti51m
    15vVnCZdrEe1ehiNh1/nAthlYavnO9UAg15pDPrm0EOZAkEtaCGAo+fp3f062XHkq1VNyo
    4+uvh3X8tsC5LuJBrjvo+5K1oJ4X2tLDcvEXyoCoYiqmc2qMqhhAQQ78hpgw
X-ME-Proxy: <xmx:EHlwatAavHpjt4aShOULcRP6xZSi75Xssk9SeqMOKWMV_tLzqqgA_Q>
    <xmx:EXlwak262z0-9XnVCfH1yYNXusDIa86fJLY3mWFOp5Z95Fe1e51Qww>
    <xmx:EXlwav1PYasNMtkMVeOUR7kVVhw7C-CkS4rE1Pf5cWcxGSImfQzyeA>
    <xmx:EXlwapB7uBhpo07KJa5fD_IaWx9xChR2nEFqLt_Bomin3-75MxdXKQ>
    <xmx:EXlwau5yWBxbEQLq_IVI8n9CIJCodm_0D1CTAk6oSW6pY79CYZAQD4Ag>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 41379F8005D; Mon,  3 Aug 2026 07:18:39 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 03 Aug 2026 14:18:17 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <88b0a052-425c-49ac-8e5d-0d77279377f7@app.fastmail.com>
In-Reply-To: <20260802222408.91757-1-ebiggers@kernel.org>
References: <20260802222408.91757-1-ebiggers@kernel.org>
Subject: Re: [PATCH 0/3] lib/crypto: FIPS self-tests for AES encryption modes
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 3 Aug 2026, at 01:24, Eric Biggers wrote:
> Add FIPS self-tests for all the FIPS-approved AES modes implemented in
> aes.c.  These are needed to exercise the inverse direction of the block
> cipher, and to prepare for the planned integration of
> architecture-optimized implementations of individual modes.
>
> Eric Biggers (3):
>   lib/crypto: fips: Split fips.h into fips-aes.h and fips-sha.h
>   lib/crypto: aes: Add FIPS self-tests for unauthenticated modes
>   lib/crypto: aes: Add FIPS self-tests for GCM and CCM
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
