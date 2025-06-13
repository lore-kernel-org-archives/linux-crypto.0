Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E0D1AD3FA
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 15:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749829405; cv=none; b=gcPY7FrQ4cYRFkBJQ2YxoVuU3rTRr8k7FPpfaXnDmmUufkr1GcqWBRyiVVfSfkVOVJB4SfDDXDzRRX+rvzMJVRI+iXryM8Pv/Rz9VsMjrYzK1iZwkvGI13P6voY1gub2bfWNW+JTzY3jqxsssIZWhH5a4Nb2X/mHV0RIDGo2GI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749829405; c=relaxed/simple;
	bh=ErljPl4av/QaQOhDCXeS4el6raSxykJe0R1j3QAerS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eBtIYvHetJ4+W2/EFNIefOZkLiXBuXDTSTZZy1ZD+X5zWCIjUK+Gh6xL2JwK+F64z+ObgONJCB4i/tAmS9UFMnFHzbVW+NPfRBI/QXDKLIGKWZxApU0Jpupy+RAxoH3iYJrvOaNdwOVAxmQnLNd+GRsCX8GHPPadmlJiKuv7K+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V4aBVBCK; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V4aBVBCK"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ade5b8aab41so473878666b.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 08:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1749829402; x=1750434202; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FcZeGwCm22Kaq6Zayr5a6cqDxVP6CQrhoWJiO/5RmRE=;
        b=V4aBVBCKgcFz5PpDzpbTCY73ocfms0i8kisAnkkvJZrqqZ7o9Y4/+NAo9aTstVWA8X
         2r/jpYJUfzPOnrPKA1vL4DFVYOOxUTMWcI6kp5XBYWdXXz0DrsQbcJq5VFEg/Oejthdc
         c4B14iV5JgVp8dOc3gVMWdtX7D0p44krAmLfU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749829402; x=1750434202;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FcZeGwCm22Kaq6Zayr5a6cqDxVP6CQrhoWJiO/5RmRE=;
        b=CmfMEzubHX57FuUSWA18B6uHsaghf1x0jURH3vT9w4mZdcRnJ6vaRaKp4gQ4Gb0A3h
         TuVrd1tZPIz6X4HRAJ0fbVFTnsfl+naf046nPyp1KRxgaY6VufhW/xV5VyazdAFoC4KV
         bkK3jcIh4YO7/pkVpqU8TEcXIcnFdFqPEDLeRq/VkmTU0PAlrujNUFr1a+HNWaUqvK4Y
         MWkyB74sChJ67eU85X/WT96+SEg0nCZm9Q4pIvyY6xiiETPA382il/Joant6qClI4m7T
         smumzxCArKTQvK4+/Gak6T14BW3QjtHxoEHJ7CvC1nbqMQ6rCWKdwW7Qqh4/GArX7LWN
         f68g==
X-Forwarded-Encrypted: i=1; AJvYcCV2x2msLuqZOF0YzxZjkV8Rgep5W+YsQd1H8C6voQUkiMHajKStsVs64TG8vyDGrInxuzNCpz5pif89rWo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqCXq4teXQh3Casl8FhjU0jjWpB3LQHTrjwkvRmibzAmujvxYX
	LLQtI4BlGNCljwEXgoQmtmUyi4C7TrZnLgFmt+W0jBjwvecp5rGO7w2+PGaRk7+m2nidYCYLThn
	J6KuMA0c=
X-Gm-Gg: ASbGncslKJeMDoDnqsyPm+m6TSK0Vvx/AMun92p8O3xgLxEIMLTSnqYuQqg5eyf2wL6
	rsyGh7CRC9J4aR5ubS/f3z81fJQGKoQpKpQg2JFQq7ZVn5JL7Q+nrvVNctE+9wk8EW3anIUUHCb
	gk+gZwMkdjzloFN7Xj2HSkFiwP23DNBiqOYDjSi4bHoc0CQ2VKJj2IIur4uMD00/HH/xOATjy2O
	tbiuEKkDAjkrfgBlT+oJhXkKzaHFvN008F1KV8WRi3mzNHXlVLydq215EjzjprBguvQraC/2FaU
	mF/r9g9o6gO2zN9Uno9iMTxwX2/pDfcEt5DLjxTPdBYI3iU/A/6PA43Gi9ymOOdKmI/C/Y73L9e
	NAehOOagWE75cS4zENLMh/GTBUmOq6wB/Pvv4
X-Google-Smtp-Source: AGHT+IF7fo8LriFtn5Q+0VPD9iG8kWU8oVlmoFCPaiZogpo+Oqk7k2GlvDQ52yiczRKwftAqS5hpPQ==
X-Received: by 2002:a17:907:971e:b0:ade:32fa:739e with SMTP id a640c23a62f3a-adec54dac66mr387584966b.2.1749829401730;
        Fri, 13 Jun 2025 08:43:21 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adec89292e4sm143542066b.124.2025.06.13.08.43.20
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 08:43:20 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-60700a745e5so5145869a12.3
        for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 08:43:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVjxpqVtI4lMvnfZFt+kEYyqG6h0j+FYwvdHB/TD7oJ/H/lx7vo8X2uZll0/G2dbxGoiwG0i2xUS/Q8BHc=@vger.kernel.org
X-Received: by 2002:a05:6402:26c7:b0:607:eb04:72f0 with SMTP id
 4fb4d7f45d1cf-608b4910f1emr3292023a12.4.1749829399723; Fri, 13 Jun 2025
 08:43:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <501216.1749826470@warthog.procyon.org.uk>
In-Reply-To: <501216.1749826470@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jun 2025 08:43:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgYdf08uju5UrDZ9kEgsC9yrtBNOTzSX6zAbOdRfg+JkA@mail.gmail.com>
X-Gm-Features: AX0GCFtHIfBeIIpdLiCaIbjGHR268VNaR19hWtgTk1l0lqwTG5TIoyTmne_dSmw
Message-ID: <CAHk-=wgYdf08uju5UrDZ9kEgsC9yrtBNOTzSX6zAbOdRfg+JkA@mail.gmail.com>
Subject: Re: Module signing and post-quantum crypto public key algorithms
To: David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Stephan Mueller <smueller@chronox.de>, 
	Simo Sorce <simo@redhat.com>, Paul Moore <paul@paul-moore.com>, Lukas Wunner <lukas@wunner.de>, 
	Ignat Korchagin <ignat@cloudflare.com>, Clemens Lang <cllang@redhat.com>, 
	David Bohannon <dbohanno@redhat.com>, Roberto Sassu <roberto.sassu@huawei.com>, keyrings@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Jun 2025 at 07:54, David Howells <dhowells@redhat.com> wrote:
>
> So we need to do something about the impending quantum-related obsolescence [..]

I'd suggest you worry more about the rumors that Kazakhstan is growing
a veritable army of gerbils, and giving them all ABACUSES!

What's your plan for that imminent attack vector? Because they could
be here any day.

Yes, yes, please stop using RSA and relying over-much on big prime
numbers. But let's not throw the "Post Quantum" word around as if it
was reality.

The reality of kernel security remains actual bugs - both in hardware
and in software - not some buzzword.

             Linus
