Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE58221D88
	for <linux-crypto@vger.kernel.org>; Tue, 10 Jun 2025 06:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749538667; cv=none; b=XRnvCBWnjJGOe8Yy/taSxHn25mhFrEiazsTfmWyVSaDtv42Zxw8Ezfdfsar0YmTOpskCFWW9L/EmwoKZ0pc+yiuHTNSQ+mfbrbc5qWtJWi1ad8wfrr5ZPk0oeDPbwl+BNZPPjlzkcCiqAgSFSvsdU6iphUJ/R2WdXH+g3kVU+Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749538667; c=relaxed/simple;
	bh=wQDRUTlp4sE+EN0pOSIBNf7ckPMmbxmA2pRLWs5QQLQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=qmrRBOoOvvipHqs7raEcL4p3eprPKSxbulTWYVLVqdfAflLwtURnR5Vghe1gnws5Yis3JcvR58zA5xuwxmnZXylFwqBcK69lDOw8RKGw6oMXZFQ8Xq3hTsxEvnlL+hKOCuG3NeyZL8aCW/7V85hs+znp/mQRJ9Zg7wLBPjzDeEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hbil9UVJ; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hbil9UVJ"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-747fc7506d4so4840058b3a.0
        for <linux-crypto@vger.kernel.org>; Mon, 09 Jun 2025 23:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749538665; x=1750143465; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/L4xukjuXu3o0NcLfkD4BlUya4WbjsrMWpKI/1kjJCc=;
        b=hbil9UVJ/m8ZcXFv0cO2ZgnI2cK/ItAF29KSm3adrp/wpvpVsQjKx3FOgvwZdqEMjp
         XeGauhwaQ/s0iyxJpRf+i5+8hDbK16/lWYrImmBNg9d451qj9g9+2GevX8jsA0wAsFPb
         KGGMTI0MRiXMmgwd8dWFgWnKLS4/o4dFKj5FRX0PtPF6crXxzy9tGox4OYMqGNaDkn3B
         g125BxWNc6gNcHidVeFP3inv6mdVlzbhBSTjBA1AModD3F41xwzWIvtmx9NDglVWIBV6
         eg3UN6oP/5sXaIsSo4bu5KU0h8+oJjKxfxJzDSllH8zHzq6tWfYGX3FiIDqtzzNp5Vl/
         Mjqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749538665; x=1750143465;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/L4xukjuXu3o0NcLfkD4BlUya4WbjsrMWpKI/1kjJCc=;
        b=xRTs/4Hph4rLnURRKaCx7Dm9JHkHLGfNiLZpBBcx5FhD/Y6gVhLFQK9xS+WXRY6v+Q
         DaZoDI8vp849HoRUR4/zTQ+HQ+/v1YBJEjAOwuL9aHeRe1IemxVqt2gddc3ncA3NrLlf
         9sIMpl+hNshwwUG1WfcCDP86VJ68Nh7ipodfh9cU3SfRA9HcDoVyFOYLTPTMmkMucF+b
         3atIwD32yPGW05IWd4i0gPfOOuRQv5mGwIT3kdiT+hHW90jO2zViIx34fmaFZ1gwYzhf
         T/YFzo8A51l+WhVvg6rY1qrKiBAokAHTR7+qNhJSxNoGxBBl2be37egEasKwjeoTbZjN
         vDdA==
X-Gm-Message-State: AOJu0Yw/gTTp+fQleAXJ//Y8mmMqGosV3SyYvREp/IHsiQW/RzqF0p5w
	LJWcgKTF6XJnp016LCWXD3QtniM5oXzbwDDsv5JxhihMSY2DNo+48g11
X-Gm-Gg: ASbGncs02ZhdVWxdOOnbmHUIypzg3nQSt9y6H1pKLQv6uFZgUJowE6zJIEAkhxsFOTN
	QFRyWoJrUV9k+W8ga9B4ezKroaNUqVQY6ryq1YmW1+dk4z7BL4dEU/oCuD76vPwEsYZo/uXp2Io
	9p8Je+DfMuTxHv6hhLkIJNwKSGUpRv34G9YyH/H8qxPoODuZdVu8b2weg4FcKOYEZWK6s8cqmCS
	lANkoS/ojTLKP0iGVsPfzI1dMUIJ2RKrYt9UoadXEPJfot8WMHowZqUzK/EYupMJ6kf5wNLKzAv
	i9NS98IfJ6xElMUfPjBvLAThTA5s+mZW5PXrv/DA6evxvP3z5UhBeSMvw7zeUkThIKQa9VnbFoh
	7YKc=
X-Google-Smtp-Source: AGHT+IG6tv88xFQX7tTKnmx1Z06D9bzktopIlpbOEWGl21HHrzZknBpwvuCOgIhMhL+mdSY7sqzIRA==
X-Received: by 2002:a05:6300:6199:b0:21d:fd1:9be with SMTP id adf61e73a8af0-21ee24fe8f1mr23220004637.12.1749538665430;
        Mon, 09 Jun 2025 23:57:45 -0700 (PDT)
Received: from smtpclient.apple ([209.9.201.203])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482b0c5f73sm6736719b3a.126.2025.06.09.23.57.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jun 2025 23:57:45 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH v3] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
From: Zhihang Shao <zhihang.shao.iscas@gmail.com>
In-Reply-To: <20250609201306.GD1255@sol>
Date: Tue, 10 Jun 2025 14:57:29 +0800
Cc: linux-crypto@vger.kernel.org,
 linux-riscv@lists.infradead.org,
 herbert@gondor.apana.org.au,
 paul.walmsley@sifive.com,
 alex@ghiti.fr,
 appro@cryptogams.org,
 zhang.lyra@gmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <EC8AB5A0-D5C9-4D18-A986-DE66BE46E09A@gmail.com>
References: <20250609074655.203572-3-zhihang.shao.iscas@gmail.com>
 <20250609201306.GD1255@sol>
To: Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3826.600.51.1.1)


>> +void poly1305_blocks_arch(struct poly1305_block_state *state, const =
u8 *src,
>> +  unsigned int len, u32 padbit)
>> +{
>> + len =3D round_down(len, POLY1305_BLOCK_SIZE);
>> + poly1305_blocks(state, src, len, 1);
>> +}
>> +EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
>=20
> This is ignoring the padbit and forcing it to 1, so this will compute =
the wrong
> Poly1305 value for messages with length not a multiple of 16 bytes.

So Does this mean here the argument of poly1305_blocks should be fixed =
as poly1305_blocks(state, src, len, padbit)?
But since the padbit is set to 1 in poly1305_blocks_arch according to =
the implementation in lib/crypto/poly1305.c,=20
it seems to be no difference here.

Looking forward to your reply.=
