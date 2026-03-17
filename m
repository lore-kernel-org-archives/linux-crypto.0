Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2053ED10D
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773756844; cv=pass; b=F9zA598EBZArteWyFRmkzHNVqrRNc3p20UrXQZx3lxqC/r66KLPNXfnQvSEB5lS5JiAwHRp0Y8t8dvs68HTboA9i7xSYy/GiumYacYJQPHHA0568heUNe/9oJy7V+LFRxGfphgM7Y16ub8gwAD1ziym9s69A8o9tyPlrptZRims=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773756844; c=relaxed/simple;
	bh=EdqnQ/ee9hXi08kIYDisfAokTsXv/oY+z6ZTg1VNQQo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XWtdeaWM304U6ULg/6zQUEgc3YbjO5+/gIXSnLh1Fn0iRVk/EQcSWKIRR8v547DhCs3FMdnC2FEPlBCoOhHuvOkY+bO6gc0PcJ2DKcMMTQzE8tQP4NlnbZBA68wb3ycuY2dHhbfa/mnTga8tXC3hc0ab8JekUFZbKDuDzXXVxbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fmSHWHx9; arc=pass smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fmSHWHx9"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-128d7db88b9so6914329c88.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 07:14:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773756842; cv=none;
        d=google.com; s=arc-20240605;
        b=DL5VW5CRYyLVoLmq2fDUVmX/5PmLlz1W/gl44Dg9jTF+jlGYSaRkH3IeNmP9amUdjn
         EQk4QYjrK8NzIR31HoBMQG0JSdnhDj8hZWY8N+42um27nRiWQexQCb7aTJVb5CVjgIA8
         g1EbHpStAA3UNetT3v2cAYyoHZ/auBoDubsKB6gxAJ13JdPf6HIRqtklWtn7XUd4YOCV
         o/fWDcgwg0Xx0q5aV+s3wxvY1SQBGBVBcdLHLfBcAUlDU79K5ElzHAKIuP2FFzCIue4h
         rX6rGWdhpVWPwyljG1OAR3KvTTcctI+6Oveyq69GDd/YNEU6fYpioyN2cBWuXBHX7llz
         9E6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xn/itZbZbF5nwf/139mTUaS6349g0FmeD4vfOEoMPrU=;
        fh=Iu5xLBG1+50pgE412Djau/cuAlS9+MuF/UkXn9tdCiU=;
        b=YLf/rLCXcNcr+IUGXyQKB/0wk+XDRjTIgHePOlf98Gr89o/Qj98+1P7+Yl5H56/92G
         YmVOLvnElPr44FW6IqiiYafbJzKq9vYmt2i1b+ip83yMIt9lbe7c33ZffBpUSzsLm4ot
         Y2ROg/3aSpDISoGR1mYOCoSrqiThF4ftDGRjT3m9JRzSEOvaG+IkOH9bl5IfDRaFEPLn
         6RyDhgY7q+WWf0BhPzCY5girosCsmLKy4O5jft2isn+NwjUQr/kuxmk49eJzcd+znrTU
         9w9GvbnxhBadZi0kSpUSZiKt29Sg0mmKAw5K2p+KOdb/pp6D5MlRxMY6NfhfgXfsi7Zn
         jhFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773756842; x=1774361642; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xn/itZbZbF5nwf/139mTUaS6349g0FmeD4vfOEoMPrU=;
        b=fmSHWHx9dXPAErt44YRpyvkLs8p4i3xNZnFGfcK4gzr/8x7XQFyJYPvrlWkMbE7Bb8
         QktYlpBuV8fCv5QYq4xuEcJ3GjSAlLURXw3j9A4l8RxSJ5b9axEzi+zs4chvMG70ucCO
         dm/SIroG2d3RbfaOKAfYbmbGbjRHG/LCvikZpLi+5h/M5fFim2qjhuGETWVH24RWVbQP
         iqOfF71+P4fNb8dSOge+OkjE6sUXwFR00xQpuY12e3wti5bO/d+fhaLH2Jee+tlA0q4Z
         ZXHF6oqZ6w2HflphSxZBZKXQIxPOtqc/WOlPHD9mNHGqfNYkXwX8wH4QpqqAaE0g0c7u
         m4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756842; x=1774361642;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xn/itZbZbF5nwf/139mTUaS6349g0FmeD4vfOEoMPrU=;
        b=SAhNR7m8KrnUWbB8Ddfpt5TZ0DiKHx56az0BBbF3ci0wwH7yVg+MV5475R3QsA07kJ
         G3Jvh7rIXLtVziJ90Lg4S4FhNwTc0dT83+meopu7GF7gjKIEyaoXIsWvXHGJqNVu5rKz
         CjSWXM7z12mbi0WhiR/MCv4LXQFTUg6VXHrsFRLPbDVXfsl7dn8lY5fOSFCWtELRfgvQ
         MuXqMKFrR8BpvJ3fCpZ7i+tAI9ocDCRc5wMCymvvrbF3zU4BRSTJiZpe1MhT9rXiMEQm
         hJjzXpRW3mOgCyO+T5YFuxi/bMEdhPoac3FLAkzstboo0S/32tvX+4V6atAb5/8W7GHj
         pPbw==
X-Forwarded-Encrypted: i=1; AJvYcCUB0tiPHLjAeEvAFci7stlepqHkHkbKBBGOG9Ip/CL0NFstyCwQ2wZwbfa2TNOhHABPr0QzRYgiy5casn4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcIsb2Qy2nq7YSC1DXsCca9RrWPpumGcZGEKw3YiQWkwmD5WX2
	zKRDXo8JLF2DwPaz+o10Ms4Ut1HBHRePfSK7Cg7ScyVj3lsr/7JaNtFXjRA8GFeD1D+L5a1DLLQ
	gpLzvmfKek2eOCdGh4+aGLHPxYrRZyx4=
X-Gm-Gg: ATEYQzzaXVT+2Yd9tQlyM1R2dJOJ985snVEDpHBeApfQ/oCKyV62M5yijivoqU6Bj5F
	RfbkQkk/rmmVi8b4HNHe0YeYs2mszlaIM+92C5WsU/xD4uaeR478eYIWifFiJflg4FYgrqucqpP
	iacCgbpWB1M4DKjc8rGNaBQ5vtcGccC5l4VtbP5EfBbaL/3Bfto33aGj6YG3eY9RTPVxxbTjNsn
	FgBvOr9VshJDUSCyj6cQuMrn6reLFYMQVKzIBGOUYAxqvWFS7jA7iWQAD+8xUYAjdakw+VYMQwM
	T4Sj47sWrnP6j5UJj6cC9KfMX/SDwZLE9X5N6BiA6pf9a+karKE=
X-Received: by 2002:a05:7022:51b:b0:128:d2d1:8a5c with SMTP id
 a92af1059eb24-128f3d4681fmr6943205c88.19.1773756842325; Tue, 17 Mar 2026
 07:14:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312053933.53012-1-ebiggers@kernel.org> <1c5f16f0913bae48bf2f24feaaaf3525ecdf4c97.camel@linux.ibm.com>
 <20260314182501.GA40504@quark>
In-Reply-To: <20260314182501.GA40504@quark>
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Date: Tue, 17 Mar 2026 16:13:49 +0200
X-Gm-Features: AaiRm50EY-Jww0f9BnxQWlTlgvfUmiFvfTcAZE0nG1rtFf2YfTEdbV6WxDtjKlU
Message-ID: <CACE9dm9mZmPMYF7Soeo+ACgmQ-zH_JCaV1jyL8drZEZMq8cCtA@mail.gmail.com>
Subject: Re: [PATCH] ima: remove buggy support for asynchronous hashes
To: Eric Biggers <ebiggers@kernel.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, 
	Roberto Sassu <roberto.sassu@huawei.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 14 Mar 2026 at 20:25, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Mar 12, 2026 at 07:29:05PM -0400, Mimi Zohar wrote:
> > On Wed, 2026-03-11 at 22:39 -0700, Eric Biggers wrote:
> > > IMA computes hashes using the crypto_shash or crypto_ahash API.  The
> > > latter is used only when ima.ahash_minsize is set on the command line,
> > > and its purpose is ostensibly to make the hash computation faster.
> > >
> > > However, going off the CPU to a crypto engine and back again is actually
> > > quite slow, especially compared with the acceleration that is built into
> > > modern CPUs and the kernel now enables by default for most algorithms.
> > > Typical performance results for SHA-256 on a modern platform can be
> > > found at https://lore.kernel.org/linux-crypto/20250615184638.GA1480@sol/
> > >
> > > Partly for this reason, several other kernel subsystems have already
> > > dropped support for the crypto_ahash API.
> >
> > The performance benefit was the ability of reading and filling a buffer from
> > disk, which was slow, while the other buffer was sent to the crypto engine.
>
> On normal filesystems, sequential reads from a file already kick off
> async readahead.  So the hashing and disk reads can already happen
> concurrently anyway.
>
> - Eric

I think this is fine. It was developed to be used on OMAP processors a
long time ago.
It can go away..

Ack
