Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B13D2877F7
	for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 08:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760690251; cv=none; b=BP/MacnbO9NPSGdzk9BCWUXTzZEzwbV2gIcxb8SNRFKRo6ja5W+ET8JcWDVNyf9MWWq4XbZ7Zu6A4JHTXpV9fZSqwJH3moDqiBwmWtjW5ydRIGsW+52wd3jd+70zIo+AZo6L3rbnThj67mgK113rkyjvo2yE8/Ntmqpn8EGERds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760690251; c=relaxed/simple;
	bh=4gBHm0hg/izrnX9TOrYcTxdW+FZhrbeI7DucFVe4NUs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tUn6dsWOTq/POxowzr0hhnZZL/+OVevvfxNUruzrobCWYNLhnlPFQSa/j8j7mbUGxq5hm0GiMeUyERzi2j7WASP3fChf4T0g1OsqDg07Y1vd0Xobhvnb7PQU3e5kjZP3BhgtXJj+rwrCFyydpxWNhgHkyqkqLEAsXGh18T+hR3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=E9m0BOgI; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="E9m0BOgI"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-63bbf5f77daso1738444d50.3
        for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 01:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1760690249; x=1761295049; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UEugzOHABBcNtf7WRv870XNmGYg6euUpqckoSgZhyIg=;
        b=E9m0BOgIYXjSnKst81q1r7r2jEEItDNv5NKuppLmZAwiU6rzYKTg+JvP5HgqXYGqbz
         9dUwaSq7draPqDx962qd8xKEUXVR3kMSjTWr5sfhTRxb3c0iPqlN1ujxzs6Vgr8UKzmf
         qwQy9uQsvprIPH2cUB8bKYIdgJdWUrY38Yy7E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760690249; x=1761295049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UEugzOHABBcNtf7WRv870XNmGYg6euUpqckoSgZhyIg=;
        b=g+gLxES7CFOgdzpZ8yNzHjHsH4F2Zfs8UbuMrhzJPef9PCvqNt7bYoWxxY1QpDqeiL
         4FLD5FKM5VgYI/WKZP6gYXS9eEZVA1DBR2xsH2CQWDQqAwGPGeHNenOeAf7l15YneMJe
         9M+FHA8SZZAELLeug5EreSnYPCtPzNMQh7znVsDYuo15dUSyjaLkonJGtFSFJ8CG+mdY
         YbVu0nWJUDgTJL2Xkanbkt/lKjCFl5O31TAUAEEDMmHHm9cELKKHQ++Z4CMjwQg9P7rY
         EnN0g0kNo3Xn+tJxFyQK3v7fIzb0qF722vE9xVHLYbROdzvPvP0FFdk5EiytDbll+lOl
         Jo3Q==
X-Forwarded-Encrypted: i=1; AJvYcCU6Id1jFVC8vBPJyMm5ZbGDEqIh3TqazDYKezQAPa9LmQmewktcnAsoLdfBDIl5Ib39xVJPzLRgzNLbaBE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj9osVUGTK6/a0dKLhGIetRjjdiipd5ltgIvkwij89jPvOrNO9
	GLDXsKO44n9GSUtJLZ8p0pwV9fOOT/qkIvjTaXEfXDhKYb46Kpcg2o8rsnq6AulNFHh4wTnsTgt
	KCDprPspLKlbvNZzhzhPjIrC84vYqbVvOaVa9nE2Tcg==
X-Gm-Gg: ASbGncse7E0Pxidjn2JansJxwKqvdHOtTAefT0RtMLmoCZ+BXmCqLboYhGwmy4blkOR
	iTxb+T2wsia8B9G07lVuCrqZGbR18CZ2LCZpNntoefXHsXTu48QxH9g26FClf/2OPOVeJCP2byQ
	QpXWnowOpuXsc5wr7ydGfC5dj/Wv3q51Aj3f5oHL/A79hFGJxfPtt5c23AXEbmeRoDZiDyq6NAx
	xyfzr2KF2vbmzg4CePylbTVZ31PaGZX8a2HGxpUbiSlq2LsiowHdoQw09gf6hHqdpzox8y8a7QP
	iJ0p7QZVQMkah8gpHz/smtpDzKjyRA==
X-Google-Smtp-Source: AGHT+IEBawDSgiE20pPoTet4nKGmNqzWfwqDDZv+tdibV8JI2CAptyqGAH85n3YwH/kLHb1q2TIij4NCoDlZL2WIN2s=
X-Received: by 2002:a05:690e:400d:b0:63d:318a:efb4 with SMTP id
 956f58d0204a3-63e161f10b9mr2335639d50.63.1760690249015; Fri, 17 Oct 2025
 01:37:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251007065020.495008-3-pavitrakumarm@vayavyalabs.com> <9ba77ca2-7b22-44da-beaf-dc66801252b5@web.de>
In-Reply-To: <9ba77ca2-7b22-44da-beaf-dc66801252b5@web.de>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Fri, 17 Oct 2025 14:07:17 +0530
X-Gm-Features: AS18NWDmYVv2zfDmUEDPEl-EPatrNn-j8Tww2-bbNu5S-jqfIjsD5sH7k8FMEBM
Message-ID: <CALxtO0kbD44Ek4mUoW-0i+5H6FUyzeOWru7Lqckj0j9Yrzv1=w@mail.gmail.com>
Subject: Re: [PATCH v7 2/4] Add SPAcc ahash support
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>, 
	Manjunath Hadli <manjunath.hadli@vayavyalabs.com>, Ruud Derwig <Ruud.Derwig@synopsys.com>, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Aditya Kulkarni <adityak@vayavyalabs.com>, 
	Conor Dooley <conor+dt@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, T Pratham <t-pratham@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Markus,
  Thanks for the review. My comments are embedded below.

Warm regards,
PK

On Thu, Oct 16, 2025 at 11:45=E2=80=AFPM Markus Elfring <Markus.Elfring@web=
.de> wrote:
>
> > Add ahash support to SPAcc driver.
> =E2=80=A6
>
> Please choose a corresponding subsystem specification for the patch subje=
ct.
PK: Ack, will fix that

>
>
> =E2=80=A6
> > +++ b/drivers/crypto/dwc-spacc/spacc_ahash.c
> > @@ -0,0 +1,980 @@
> =E2=80=A6
> > +static int spacc_register_hash(struct spacc_alg *salg)
> > +{
> =E2=80=A6
> > +     mutex_lock(&spacc_hash_alg_mutex);
> > +     list_add(&salg->list, &spacc_hash_alg_list);
> > +     mutex_unlock(&spacc_hash_alg_mutex);
> > +
> > +     return 0;
> > +}
> =E2=80=A6
>
> Under which circumstances would you become interested to apply a statemen=
t
> like =E2=80=9Cguard(mutex)(&spacc_hash_alg_mutex);=E2=80=9D?
> https://elixir.bootlin.com/linux/v6.17.1/source/include/linux/mutex.h#L22=
8
PK: Ack, thanks for that, this is much better, will update the code.

>
> Regards,
> Markus
