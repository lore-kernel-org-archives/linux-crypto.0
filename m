Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98333074A7
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 11:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758023783; cv=none; b=YScI+VwYenBPhELMaK3iH3TWr8teF7uKf5yzRXNn1e8iYqXEWSMhHEQa0uKpjPLvDB9PQ+2AXXoRGKqUpILu+9ZhVTva2eLwoPYBET/D4AeTRw1Sbgl9DFBFPg1VFaEPWOOAN1h9ixkH3RKNXCxUTS2GyFUSWs4mlltbuJd9THU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758023783; c=relaxed/simple;
	bh=d/HCKLiLTFUfU2Tu5U0IGixHlZ89/CY18NgoU2X4C6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bkyl4ffdEiTP1tZkZICt/KlrsBQbucFEikDbPJQMJMgSkDi3/v4ZHqPof3HADaWzq8ofOas6mr7un4Bq+tqwk2U1sa2ebKf7WjPyyWd0p0gBBhOx0TtIbQfOVwk/FNa0uM7xnRu7O8koCM7JbPC8pWjPCuLjskanq4RMmQiXZa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=BkDU+Wx0; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="BkDU+Wx0"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-55f76454f69so5817089e87.0
        for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 04:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1758023780; x=1758628580; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H6rt10mul3EQttwRTQeGYrQf5uqA9rRPNVzaZ7mnpLA=;
        b=BkDU+Wx0Qczmb0NDDC3r19/5HAd2rSrkvVGisn4iYaw1RFpcYVOd5XzFJTZOd2zmVW
         TTNBiNyb7KgMny2XobQ0DX1ZwpP0lR+Y7TgM+okdSDIZ4XYYPwEiQGLe6/zf6wxPlVqM
         uq37bDCmwNiXfilMtMJW1/mLk++dyegojcbKO0/kIH2RNFWAx5u3zgVJya4JWgeLhAy+
         DfCALuZ7gaFlu45H131Kc+K3Ts3xobXxXva4pbE4T9BwWHsenX+lfNrlHnYkXrjvRXSv
         YKSw8FH35i9/Kf89kWLro6Z622l8FeV0UpsR1QXOOMc9IbPa3hLQ7bPIsnLYG9cGejm1
         OF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758023780; x=1758628580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H6rt10mul3EQttwRTQeGYrQf5uqA9rRPNVzaZ7mnpLA=;
        b=ZXWRB2O11M+9x55mVi7Ay0vdeB+lN28Funl4eQEKxXqj2wJ/++NlbpVi2YB2in+E82
         pvW3ht0AN/WzGI0x5JiZLslTsHbKbAJ/KFimaIyYGFvjBeZSlmkzQP5omlbRteDfmMso
         peiCE1V2/osxP0hNVFHnDJVgTejSBQxeqfpblOEbNtEpWVTPlHg41uo4OBDdYe1SfoT8
         boK7aU+7tJVl/6hd8no2a6BkGj0DTOMIhlXqVfYQnuv7Fnlv0e0DjpE+R/aKXTGOoEg4
         Lv5xx86OBjtr8D7N+2VVRu+w+gdDH//XU3s773cwVuXCcyg421VSm1eZYmbU60OZqdHL
         j6zQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIo7Pc0CENchBPjW9GpsaEImf5Krv3R4a0Dgzz7v1ad2PB2pG+LPHFc3IIR60zw0t50ofMXrMn7hqrvAo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzC/5+RdkX8pv2+5a6iWr08WosSHNDXo6ZVcz9HezCOmYSY2ob/
	U8lZJ/IIZQX6MgPnisbWkNVvPy7rCoj+7o6JWflN2po/L3cSNYYyIRrKbSmZvknS5hq/K+QJpiL
	3cW2CcCIJ2bUWaICeFKFp/yZTKf1tnNkItF4m0G1GYg==
X-Gm-Gg: ASbGncs28kUpxmd6idW3DbjnJhfEw8Jgsr7m6qUJ0Gcr6Nd6UNyEW067WL+F9b289E6
	rP1n7I2NKsu+YW8icvgmupRynzlFLKBysa2crSw7jqAQimTmn2sB+jLU0qpHQaP4PVarYT7XHIG
	r/96ZWMKjdlquUH2lb+IeGOJ4i2915SI2laFlZisxwDQ/i51MbdNKQwQCBtqcNfeEiBypYtCfU7
	e5NhCaJo7gZ8oyanQtexzYEzjoufIUbyA==
X-Google-Smtp-Source: AGHT+IGZHIJms1PdfdobCF0PHag54tV/vQ2luqF5yML0HzIEjgy410kiDpDIgcy5Oo7sjnurHziZpkbkNojCCCse7cA=
X-Received: by 2002:a2e:a993:0:b0:337:e4a0:ccf9 with SMTP id
 38308e7fff4ca-3513969d23amr50439561fa.6.1758023779695; Tue, 16 Sep 2025
 04:56:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250915084039.2848952-1-giometti@enneenne.com>
 <20250915145059.GC1993@quark> <87f17424-b50e-45a0-aefa-b1c7a996c36c@enneenne.com>
 <aMjjPV21x2M_Joi1@gondor.apana.org.au> <fc1459db-2ce7-4e99-9f5b-e8ebd599f5bc@enneenne.com>
 <CALrw=nEadhZVifwy-SrFdEcrjrBxufVpTr0BSnnCJOODioE1WA@mail.gmail.com> <ef47b718-8c6b-4711-9062-cc8b6c7dc004@enneenne.com>
In-Reply-To: <ef47b718-8c6b-4711-9062-cc8b6c7dc004@enneenne.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Tue, 16 Sep 2025 12:56:08 +0100
X-Gm-Features: AS18NWBsAGjsbtFBKx49_gD23Voi-xBG3_uoA627mbeoTytoWiD_LmneZ3QclxI
Message-ID: <CALrw=nGHDW=FZcVG94GuuX9AOBC-N5OC2aXiybfAro6E8VNzPQ@mail.gmail.com>
Subject: Re: [V1 0/4] User API for KPP
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@kernel.org>, 
	linux-crypto@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, 
	keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Lukas Wunner <lukas@wunner.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 12:21=E2=80=AFPM Rodolfo Giometti <giometti@enneenn=
e.com> wrote:
>
> On 16/09/25 12:21, Ignat Korchagin wrote:
> > On Tue, Sep 16, 2025 at 9:22=E2=80=AFAM Rodolfo Giometti <giometti@enne=
enne.com> wrote:
> >>
> >> On 16/09/25 06:10, Herbert Xu wrote:
> >>> On Mon, Sep 15, 2025 at 05:47:56PM +0200, Rodolfo Giometti wrote:
> >>>>
> >>>> The main purpose of using this implementation is to be able to use t=
he
> >>>> kernel's trusted keys as private keys. Trusted keys are protected by=
 a TPM
> >>>> or other hardware device, and being able to generate private keys th=
at can
> >>>> only be (de)encapsulated within them is (IMHO) a very useful and sec=
ure
> >>>> mechanism for storing a private key.
> >>>
> >>> If the issue is key management then you should be working with
> >>> David Howell on creating an interface that sits on top of the
> >>> keyring subsystem.
> >>>
> >>> The Crypto API doesn't care about keys.
> >>
> >> No, the problem concerns the use of the Linux keyring (specifically, t=
rusted
> >> keys and other hardware-managed keys) with cryptographic algorithms.
> >>
> >>   From a security standpoint, AF_ALG and keyctl's trusted keys are a p=
erfect
> >> match to manage secure encryption and decryption, so why not do the sa=
me with
> >> KPP operations (or other cryptographic operations)?
> >
> > I generally find the AF_ALG API ugly to use, but I can see the use
> > case for symmetric algorithms, where one needs to encrypt/decrypt a
> > large stream in chunks. For asymmetric operations, like signing and
> > KPP it doesn't make much sense to go through the socket API. In fact
> > we already have an established interface through keyctl(2).
>
> I see, but if we consider shared secret support, for example, keyctl does=
n't
> support ECDH, while AF_ALG allows you to choose whether to use DH or ECDH=
.

But this is exactly the point: unlike symmetric algorithms, where you
can just use any blob with any algorithm, you can't use an RSA key for
ECDH for example. That is, you cannot arbitrarily select an algorithm
for any key and the algorithm is a property attached to the key
itself. So if you "cast" a blob to an EC key, you would need to select
the algorithm at cast time and the implementation should validate if
the blob actually represents a valid EC key (with all the proper
checks, like if the key is an a big in and is less than the order
group etc). With AF_ALG you would need to do this validation for every
crypto operation, which is not very efficient at the very least.

> Furthermore, AF_ALG allows us to choose which driver actually performs th=
e
> encryption operation!

This is indeed a limitation of the current keyctl interface, but again
- we probably should not select the algorithm here, but we should
consider extending it so the user can specify a particular crypto
driver/implementation.

> In my opinion, keyctl is excellent for managing key generation and access=
, but
> using AF_ALG for using them isn't entirely wrong even in the case of asym=
metric
> keys and, in my opinion, is much more versatile.
>
> > Now, in my opinion, the fundamental problem here is that we want to
> > use trusted keys as asymmetric keys, where currently they are just
> > binary blobs from a kernel perspective (so suitable only for symmetric
> > use). So instead of the AF_ALG extension we need a way to "cast" a
> > trusted key to an asymmetric key and once it is "cast" (or type
> > changed somehow) - we can use the established keyring interfaces both
> > for signatures and KPP.
>
> IMHO the fact that trusted keys are binary blobs is perfect for use with =
AF_ALG,
> where we can specify different algorithms to operate on. :)
>
> Ciao,
>
> Rodolfo
>
> --
> GNU/Linux Solutions                  e-mail: giometti@enneenne.com
> Linux Device Driver                          giometti@linux.it
> Embedded Systems                     phone:  +39 349 2432127
> UNIX programming
