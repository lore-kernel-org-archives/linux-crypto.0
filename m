Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616817AE5D
	for <linux-crypto@vger.kernel.org>; Mon, 13 May 2024 20:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715631996; cv=none; b=rndkZfBXL5q0r8s/uF6vGwk5zhSseP8nsdih+v6xD4fLOQuiFhmHXLDTeIp1gxFDkPcJbxP4GJmfGaPxZJKj4sPYMQLU8z/Ztg6DDggsvaGmyxFGJyd6YJRpH1NToxyt8erh2j7dRANIfbu72PrtTe3uR8qo8hBTykBuJJrmuWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715631996; c=relaxed/simple;
	bh=cNGeaflSmAEnCGZR1rkFunly5KPHgcR29cpK6hQnl4U=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=uI1u32fmbbX79bOFFWYLoZdkn3MnNKsJ6cBiUL/caTY1mpt0+OJWBvQyEarQRoCCrxTZoLcp0YdijePLnN9TAX5MgIR/AiNZBWwOofNydgOQVHL5OOM22EFoSQZS18TVF/bmT2mfgyaYiBwfXjD1VWHLhRo8J5ho6tRXUiMJsYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XEtil62+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XEtil62+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F14FC113CC;
	Mon, 13 May 2024 20:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715631995;
	bh=cNGeaflSmAEnCGZR1rkFunly5KPHgcR29cpK6hQnl4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XEtil62+umRIZkQUA/SkzEcVMjG/WI/LL4rM5jEX1EsYP0y0DARc32sVZxriVgQ2F
	 EY1Jrq4VOH1IanEZDrUziZUw+nuKgs1lY6ip3VdIqLVnKYjaP2SAtpgfdCBOgiS4Fp
	 x0KNUIjrjvZi9zgsmUp3niRTedtrSlQXep/q1oOxdDwL+AU0KT0rMUZD6Hw0zrJFM/
	 ShJ8XfblfJEKYZ+7M+dPQNKFpho5y2vxwwY/2lQ7h3shf0NNrbKOU+8IPCKpeiSzlR
	 B5U3xy/i8N9FUS5zyPicsxvG3XxTEQGXCOeUg+6cXKbLzcwGK+XILPJ1bcpDUxTY4e
	 2ZiEegwtsekkQ==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 May 2024 23:26:32 +0300
Message-Id: <D18SS8X9VV7L.28F9PNZ1PM96L@kernel.org>
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Joachim Vandersmissen" <git@jvdsn.com>, <linux-crypto@vger.kernel.org>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: "David Howells" <dhowells@redhat.com>, "Simo Sorce" <simo@redhat.com>,
 "Stephan Mueller" <smueller@chronox.de>
Subject: Re: [PATCH v5 1/2] certs: Move RSA self-test data to separate file
X-Mailer: aerc 0.17.0
References: <20240513045507.25615-1-git@jvdsn.com>
In-Reply-To: <20240513045507.25615-1-git@jvdsn.com>

On Mon May 13, 2024 at 7:55 AM EEST, Joachim Vandersmissen wrote:
> +	pkcs7 =3D pkcs7_parse_message(sig, sig_len);
> +	if (IS_ERR(pkcs7))
> +		panic("Certs %s selftest: pkcs7_parse_message() =3D %d\n", name, ret);

Off-topic: wondering if Linux had similar helpers for PKCS#1 padding
(and if not, are they difficult to add)?

Anyway, looks good to me:

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
