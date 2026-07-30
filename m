Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C013A7F4D
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 07:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785398205; cv=none; b=Edw2zT3MDYAjtk1geeH07EUccKpWe9US2t0A4v/FKcfbmLEymhczVtxOw7J1K+20dSB7c4zhePGq4D/Ibswy5tJp4gAuaZh0fKynt5/8OKKXE0tZ9rOrOAEbrZkWUrChfvEnQ7MrtvCPWZG1foibb0/MjjueNzK2edwVJUSOhHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785398205; c=relaxed/simple;
	bh=B1cUqlCpcer7gGpO1vw87PJHWnKhNCbGZjUEdCWawHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=et9CVXaw7VrdjH73UvVGwCmR0qVIpW2J9akC4LDU+BOiCYQg2bEUM8WCpuqM7lTdPU+qdg7zbGhChPQuoJGNprtMgMjXO72BXkkDXoxBCybRsT+cRqsS+n+ROAm00h9ICGRYXQYqLccO8O970g6DLoJINuCkm4E1E4S/2WOtVXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=g+RwDxyA; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="g+RwDxyA"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47f703a9d05so1235792f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 00:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1785398202; x=1786003002; darn=vger.kernel.org;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B1cUqlCpcer7gGpO1vw87PJHWnKhNCbGZjUEdCWawHA=;
        b=g+RwDxyAn3slj2ZNdJ8o+OZCJxvDZYfuke4PWGsNwLtssMqTEvW3ka5qbMZv3yxClK
         0VBvP6xOc+ISZHDIex7lvT9q1i/Oao+VM5/M62gxxc7uc6ak6sJWDIODOSWjhNDWEY0A
         wedXmc64LHa14QPWIxUHWMqF78yWF1ifE4etwkLfmZOBxtsR+4b6AQT6rRp7NJ/+Ynad
         fqNXJBlf6R+x4P9IHIqKgxLe2Y+bPkNOC+ZSUmt61VQYqwKoEplO1qdKsaHKZQ4D67Fe
         nX2/8g3hERZO7Eh5x9nlpMP1GUXhWSBQ2M63pawJr/zlAdgYvD2MwU4IIzmCAQd3not8
         WuhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785398202; x=1786003002;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B1cUqlCpcer7gGpO1vw87PJHWnKhNCbGZjUEdCWawHA=;
        b=Oa6KQCrkWheId5rCUD/hWHKW6TxqZ7u1ua34HanxQILOWqta3IiuhKmJFM6M7M18xr
         IFNAHxtkpxq4PYC6vLNV7wVHMpibdtE0nsIWHAKz80tzIptEfTfjY3r14T42pZCT2NKk
         wVwghZvI5P++N73Fy5m6MyXS6mzI2khcRRdSr3kIR8mgYIqIJc7aU42c7GMH/mtSZFWm
         IOGLtoAXTLwPLIqx+JvM/DBf6E3lQV1qclkwRHKy58z5jhBpgNSqs/J/jtXA1jeplU+z
         gVSetXR3/Ql0eohLLvyNUU/taiq8d2EbL03g2ytxB7kpkJwiFukbwnaCCVkja86VzyS1
         g4mw==
X-Forwarded-Encrypted: i=1; AHgh+RpUiEQzDxF055x2XNwvtKc2BbGhED4oxtdcUin9+FGuOhuUW5fIQy5QdOrUlNW5zCvMA+20WVE0zkt9Upk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnvumGIseH0aFPY2V6UC0DVSKuvUI+yFzuYqmiLsgFxPVgJ0OJ
	urvVN5uLjbHTG4bDHbncd84wYQROEmMTsYLvwckmceMU8sh7s3O2M3eW6rj9N/raEaw=
X-Gm-Gg: AR+sD13WmSO7TKF7ceapVIeP7gB6Wr+wwrS/5d96F0ryzxtB/XMOXeJLQp6rP3uJVo6
	nmjJ+TB3hhAv0iwc/Q8MGw3RAiQJoN3RYp0GnzTvln+y2tawwr5t+3FwB1lLciwhWdvpH8z5AxD
	YlNqoxqIleSCL2F94snh1oGPkzwmxziTNPKSdqTeSHPd3A/DhopjDrUD/EoUtovEcz45bLw5DvO
	+L6IjOyDLh+BuyXFfpE+saSn5Ic++EAyFBjhSmgpm/k7EqIOoJWp/a8cMDFPvnBEAQmQqJQKbo6
	FWqBGgrnot0qWUczqhbMPFpOPXRA7QRAeJhSudaOLYesomvF/Qr6GH15CSIBeR9DUk43R0mYc37
	aPhv9TrQNbO28eWaaAZ5iMF8p4UHxZsPT2iodxxv2QDWVnvjgVrjXJrzFh9fuxCxTfVBrrNA0Nf
	kEdd60AfL3Esa6AzWURL7XtO4LTpH56S/uB+8PyF247MIyZ94tUkMJBxpn885fkKvvLZPRjdfG
X-Received: by 2002:a05:6000:4212:b0:47f:921f:3a2f with SMTP id ffacd0b85a97d-47fc8331e6amr1958966f8f.25.1785398202169;
        Thu, 30 Jul 2026 00:56:42 -0700 (PDT)
Received: from somecomputer ([82.150.214.1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc893516asm4214375f8f.25.2026.07.30.00.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 00:56:41 -0700 (PDT)
From: Richard Weinberger <richard@sigma-star.at>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Richard Weinberger <richard@nod.at>, upstream@sigma-star.at,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 demiobenour@gmail.com, davem@davemloft.net, ebiggers@kernel.org,
 upstream+linux@sigma-star.at
Subject: Re: [PATCH] crypto: af_alg: Allow cbc(paes)
Date: Thu, 30 Jul 2026 09:56:41 +0200
Message-ID: <4313653.jTJXf6HLCa@nailgun>
In-Reply-To: <amsDLRticYiBYeVP@gondor.apana.org.au>
References:
 <20260726192716.2351505-1-richard@nod.at> <5915345.sfYGdeWWPf@nailgun>
 <amsDLRticYiBYeVP@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Donnerstag, 30. Juli 2026 09:54 Herbert Xu wrote:
> On Thu, Jul 30, 2026 at 09:52:44AM +0200, Richard Weinberger wrote:
> >
> > Eric asked me to wait a bit before I send a patch for next:
> > https://lore.kernel.org/linux-crypto/20260727172004.GA877700@google.com/
>=20
> Well if I'm going to apply your patch I need to know what you want
> this to do in next.
>=20
> Are you happy to leave it as denied for next?

No.
I'll happily send a patch for next just.

I just did what Eric told me and waited.

Thanks,
//richard

=2D-=20
=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8Bsigma star gmbh | Eduard-Bodem=
=2DGasse 6, 6020 Innsbruck, AUT UID/VAT Nr:
ATU 66964118 | FN: 374287y


