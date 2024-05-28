Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E1D1DFDE;
	Tue, 28 May 2024 13:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716902787; cv=none; b=VL3Bg4G+XgUqBmWg9d1/2PUy8ZztlvcgyO0IM8Mnc9TjLH2o4C8FnbgPUEjvZLI3OqrwuB4NRm5S5XMyC4pbPoY9UkraAAmfiKwDGSVVOW98C3xwwMm+0DPO5dU+BOuwaGq+DtzF+pK6uin4H8tSswP2dq1UqlePE04qP8oFKak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716902787; c=relaxed/simple;
	bh=Ad8wMojTt/79CqziBKqun2/2NRJA2NX2PQ6ZHoAzIHc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=tSbSb48tIHSjCfsD3xPqva/NB6QoKQaEuw23YFxdQcK8mXWfl8qcMo5b24NkF/+GTuJTy75KRWfgRy5zkem5jddPVp6ZqPwlTlm5GCbGqWNacXSF/cZDceEELUebMEYIfQ7pYtR+v+WdjDsStNL+726Ex4iXxR5dUNFpFwzhl3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IEG2uhgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IEG2uhgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC388C3277B;
	Tue, 28 May 2024 13:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716902785;
	bh=Ad8wMojTt/79CqziBKqun2/2NRJA2NX2PQ6ZHoAzIHc=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=IEG2uhgUUPyYbAsWUxyVlsBO6Y7DwuhBtwLGqCAzr79tUURXZ7LIgqCi4Vzd5cvVb
	 ImfYzaTkzsSEV1xefnhhAgDb5Dy6nDEd4JwnNFt1SL40OpikjIXypidjro4TXhAnqb
	 2FKre9bGUfOYBKzbsgflLd+fVZMPzcjxFnIYG75I949ToSYWYBYS0j3K1I7HmCsnsl
	 8JMK13VJk1FML3SLmV+EO5erme1ByaNjvVXP5e6iN7EvMjQB/kG/DPVjfQvVdTCx0V
	 QGwnxU+/GbDKJzWC86DrsfpZJXC35lbQ+eKdeShmy6u0nKcIJOJUzDYby7/f0Kk+Kc
	 YYLqBqpYlo5mQ==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 May 2024 16:26:22 +0300
Message-Id: <D1LB8PVCTP1S.JDCEWNODTGTQ@kernel.org>
Cc: <linux-crypto@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: ecdsa: Fix the public key format description
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Stefan Berger" <stefanb@linux.ibm.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>
X-Mailer: aerc 0.17.0
References: <20240527202840.4818-1-jarkko@kernel.org>
 <D1KQDPOZRWCW.1763CCYF1B84X@kernel.org>
 <D1KRILI1KRQ8.2CNPU7PFES0VI@kernel.org>
 <D1KRXI87G4S0.1ROKTQENIZHT7@kernel.org>
 <D1KS7LCALKD4.1J13QGYGZ6LBW@kernel.org>
 <D1KSLKGUWGFO.21T4OBXQQ88D@kernel.org>
 <D1KSSWD7FA94.5705Z3J7LKZA@kernel.org>
 <b5ff9003-065f-437f-bf6b-7f1ae0a0364a@linux.ibm.com>
In-Reply-To: <b5ff9003-065f-437f-bf6b-7f1ae0a0364a@linux.ibm.com>

On Tue May 28, 2024 at 3:37 PM EEST, Stefan Berger wrote:
>      Signature Value:
>          30:45:02:21:00:d9:d7:64:ba:5d:03:07:ee:20:a0:12:16:46:
>          31:e6:8e:66:0c:17:0d:74:07:87:58:5a:13:fc:14:62:98:9a:
>          99:02:20:59:ff:29:9c:52:b9:0a:35:3c:4b:03:bb:47:0e:c8:
>          3e:2d:cb:3e:1c:d3:51:88:91:b1:40:e3:03:86:1b:2a:e8
>
> 30:45 =3D> sequence containing 69 bytes
>    02:21: =3D> first coordinate with 0x21 bytes
>      00:d9 =3D> 0x21 bytes of ASN.1 integer with leading 0 to make the=20
> following 0x20-byte integer a positive number (its most significant bit=
=20
> is set).
>    02:20: =3D> int with 0x20 bytes
>     ...

This actually helped me located the bug in my code: I had 32 bytes for
the first one, with no leading zero. I.e. total length was off-by-one.

So I'll just extend either or both based on msb?=20

BR, Jarkko
