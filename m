Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1926815CD74
	for <linux-crypto@vger.kernel.org>; Mon, 30 Sep 2024 07:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727681932; cv=none; b=iSEd/+qKEBumaHumwIDJvzjmlxgr4/ZxQJiUG9j9bnu6jCCryyZtRLlzeMwZmy0Wv2VQtDc2r9fUPLsnwKnI9plOEvUd5eWgPleWnhbUERKGNwntihZTL5Rqf0JV0yN0eU9u5fw7A7mgWg0Iy2Ek8TYbWQyLc7wpmfzZenkKKGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727681932; c=relaxed/simple;
	bh=mnXyjA99r+I4vi5MP23mVdJb3eIlFCw2FUcVFrjxtcU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rvl2sktNnRBMi9TXoCyuxBv3/ISxhs/iE7c8fv53d1LK2iGR/NYh6v/vvv27NY5yFGHvGPS2Znaz8GAVSaTsBvaYVzx7d6YLOWy5vfyTwfOmgc04UaDJwRi6LJLWXfODAb32/3jmYv21N3MR+IhU6l//fZr+cyBQr9yljk1FIyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EURiu0jt; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EURiu0jt"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c88b5c375fso2339050a12.3
        for <linux-crypto@vger.kernel.org>; Mon, 30 Sep 2024 00:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727681929; x=1728286729; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mu1FB52TfR8Hv6dzBjCHh1EvkBSWyJUL9d5aFAmGK1E=;
        b=EURiu0jtP5zv9/AWsr5O87hTBAGCwk7qSbr8MzyEHlQLowxEKNHlub4w5zVkyYHGz5
         KloI4K/gz+czD0ZesD2Yn9s7qXlNW/SNHQq0LRiiKeBz0B4Lz4p7UiiKrCACdhIY+TRe
         KgYRo//RB16K6ZwQE3ZDw7riqNIgROYDfZqdRhK5SSvpIX4vyTrwJpMFI7WYRUQ5XM/A
         cmzvZQksPrtzXhJNRtS8Wx1A652c11Jp4Xb+lFBbmhA7uL4yqJ6SeLr1kMsK+kUj1bUn
         GeqylJxG9tsXqn9ZZmt6sDnwS1+Z2Xi1saJYObdjmZ1yY2YoLDUwuqXYjuhqttxj3JPm
         ZJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727681929; x=1728286729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mu1FB52TfR8Hv6dzBjCHh1EvkBSWyJUL9d5aFAmGK1E=;
        b=CL+p+zrl7gC4M0X7nmOLqiRYx80vd/m3yWKX8/1o9VrZTEkoexFLHox6g6rXps9k9D
         fle2NwD2lTnbarrmxaLC7heSaBzy+0nL1+6ft1lmra67rsAiji36MijGqh30bqw1Ugkr
         mc+v42uzT1khq5HqrOsM26Tye0jqW4kb+/uUIe7SGAAGb5qsJDK5Mo2zJHv1ypdGGPJ6
         i+p80TZP8awXNY56R1zEln9OApnyTNaWvJl9978L7fR7LZHrQle/7P/Idm239/vpFw74
         BXNRQ4VBViifVQ5UCJHnsff5LrmoHqrlsFnIzzNA5W5GqGTps6tplO6f9WSSpGn5tg2j
         6CEQ==
X-Gm-Message-State: AOJu0Ywm/6dJH4QWhQFVMI7C7thRuJMsGi/pdqbEe+Xu+8r5UO3UP4rF
	NFQV8D7amKA+0ZorejSWUv3oSmiWQtCd0FKsGyZGu6qRisOM9g58wJAMBOsYfUZQu9b+ILDnww3
	6Gb8rSaW0tYHqP5V7cb5gKOyfeSz6BIjbftQ=
X-Google-Smtp-Source: AGHT+IFKej1xaZ7y+n3ncyPcgirncJ717KwW+uNWKSuzeE9uguEUxmn9bOQYe+6rAMu5ep2DNbGRb5Yw9G+VeEpE1h4=
X-Received: by 2002:a05:6402:50d4:b0:5c5:c4b9:e68f with SMTP id
 4fb4d7f45d1cf-5c8824ccc1dmr10333983a12.5.1727681929185; Mon, 30 Sep 2024
 00:38:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFXBA=kKHa5gGqOKGnJ5vN=XF9i3GB=OTUZZxbfpU5cks=fW3A@mail.gmail.com>
 <ZvEasINIFePe1tE7@gondor.apana.org.au>
In-Reply-To: <ZvEasINIFePe1tE7@gondor.apana.org.au>
From: Harsh Jain <harshjain.prof@gmail.com>
Date: Mon, 30 Sep 2024 13:08:37 +0530
Message-ID: <CAFXBA=nKkV8tviqpzYFCqY1rjOKKDD8Z_T=poqjStWTLcP1Kbg@mail.gmail.com>
Subject: Re: HASH_MAX_DESCSIZE warn_on on init tfm with HMAC template
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Stephan Mueller <smueller@chronox.de>, h.jain@amd.com, 
	harsha.harsha@amd.com, sarat.chand.savitala@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2024 at 1:07=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Mon, Sep 23, 2024 at 12:39:11PM +0530, Harsh Jain wrote:
> >
> > What should be the preferred fix for this.
> > 1. Increase the size of HASH_MAX_DESCSIZE macro by 8.
> > 2. Register "versal-sha3-384" as ahash algo.
>
> Please hold onto your algorithm for a while.  When I'm done with
> the multibuffer ahash interface hopefully we can say goodbye to
> shash once and for all.
>
> The plan is to allow ahash users to supply virtual pointer addresses
> instead to SG lists (if they wish), and the API will provide help
> to the drivers by automatically copying them and turning them into
> SG lists.
>
> For the shash algorithms the API will walk the input data for them
> and if the input is a virtual pointer, then there will be no overhead
> at all.
>
> Thanks,

Hi Herbert,

Any idea when multi buffer ahash related changes will be pushed?

> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
