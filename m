Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EAA45BD57
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 12:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778846749; cv=pass; b=Ve5DpNh0e3xaDxjk8CjkVr7m0gok3JTmhYAGNhoYSU8bKk+1ibNSxXFLv4zO8mWKlsveKqsUamFPD+TR+Au4pviINz5YqDagHw1c+wsUt0q02PqusCZJX3HUd58Q6fg2eemGn5Y5wlNVM7BiK2ajEUmeBtQhmnArZrq3HS/d/6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778846749; c=relaxed/simple;
	bh=kW/9C30akUjzDwJkUoDa2H1DV7Pw0sHZs6bPnj1YUMU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SXeq89DNQLHi9UOSPcJRfZDa4pgD+jyocE13sivZmhTjZv0DFAqOK5XuNDkPr4UAm/L8XB/mUElPStljZQwEgFvYO5lv63XJ8IwbY3/MaZ3vrdk5Slw4oq8a/O3LE2RXrJAhIcy+XcvWZVM143vhqzaB0DFWt9+/cwgE0gQXKZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ObRWGohN; arc=pass smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ObRWGohN"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-65c7efdb7d8so11874457d50.3
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 05:05:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778846747; cv=none;
        d=google.com; s=arc-20240605;
        b=GOez1c7a/IwoRv+58nzNxrSdPL0arqugnWaMphpEUkpztYY3FTNxdtsN/c3NMC3g3m
         ZiiN9zsW2iy4B6EkBcG9p5xvzNF7B9jCrhi8QA/x9WYeHwt3OopDhEs9ArB0VcAXjZDS
         tMmgugcZRKYygjQzQd6XCmflO5Qkrjl1w03NZ3MD1/1ROsEYuoa/wfqVOk4W17JCLHbF
         Fn3AKz0t03QDviYEXQu5iu1xudfdkcBp2RGE9/yWXLAnBseWJZy5Y/p+8+msxYWjG/OM
         fDr/kEydafOgYbI1YY2pOvDwuVoD03FyTV0ghqlTo7JtqWx9+MH9QrvtRpu5HcaiDcQK
         In4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5kVosTkW8SNhxTSi2C8qw8i0G8BjP9k3uqUmOQ8n5rQ=;
        fh=KQt55VT0N3/YP6aqKKFLsr3yYCdSolWTjnnRDiI1OO8=;
        b=GkAn95ek+/5MzTz8wpJ5lNrUAQhdNHYlqbuRSbTGIF031o+Khit3QkXM6FMffF62SB
         sklT1qYay0VvyCqO5GhXznq0FbX9kDsHXBJYRL40cE3kci/vryixz8Mg0OeEVvB2+Wyp
         v2YQKt+BtXQpHZhHTuLAmCfjHg6q4NYvPnANl6F8A539RqWyiTsrDqWRqRwMbxc9ugpr
         uaCxlr+rkbH9l1Kzs2Te9RQQvDDD3K4+7SXzRt9VOVYGCrihT8LWjVSArWTyb6XTRH/0
         Hv0sHKs3i1qZIDNK4RUKCvWwOSYOU9P9kOIHJDJzmbRbJEFCEbRRj8O7dOO7BcUn9i8e
         boVQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778846747; x=1779451547; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5kVosTkW8SNhxTSi2C8qw8i0G8BjP9k3uqUmOQ8n5rQ=;
        b=ObRWGohNPKlEIwNYMDzlGOfDGrfA0/ChbEswY1kRthJJGcNomAK0xpDMuew4l0iLhr
         +MGUgLRQhLOGdUXc7C2xZ34+D0oC5mTRS14fw/8q+yWwoVLpzoZZZRdQrUSkn3xg8D7B
         SdCtX0BU4KJ4PlWy0Y7q73GXg/LsTukEJd2c2eiD6Y3CxdHMg3dQPz0hy1qiPSCZ7461
         0GwxtKhYgSYuWTQBy5dlc8BzBY71LPkuea4d9z/4jRKxP6knqbINdSx4Ui9MZrVz9isL
         WiPegBHtAO/W5c1jWEUzDyWwqmvnFCzcCRXFpm545Dl9b8dIRfUw2vJFph/4roNXxywC
         uA7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778846747; x=1779451547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5kVosTkW8SNhxTSi2C8qw8i0G8BjP9k3uqUmOQ8n5rQ=;
        b=sIKbxzbj2ar202IYmu13o7XKHMSF2L6JlGn4mQSfytNXmvZ/GGW0dmPCkdLj/V2/u9
         MxcmL3lyr+uda6ISfVGSrTDAVUpur5maV2CKHfZtE0iBTPPWbOFKdgVT1FoaJUgqDcP6
         0pKwP4wCkgbhmebEzmdoBe46fC1ZPB+CgutXCSLOXqze1YcPFbSGpBOGj7PnNEbRRs3L
         YqxWDjM47mbctawmpJfFOKMvzTGTAJMGJIZB4vIwrVieWO3QQIkXY08/jlJLlHB9Tfdw
         rX6+oZycWHbo5UXW3xpWYq67Vb1WpwlFA+m+r68g/btAPSMkUVT9Svg76ITI2GxfcCzV
         +PEw==
X-Forwarded-Encrypted: i=1; AFNElJ+kmQvJAKGE4feLbUr/EwQa2L3GKaTEqoqeC1TRS82hbJOZKg1jsvcGcpRPKJIE0OOgoPUge5qCORnkRaI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy24AbhL0ju4BE9kU1arkYH2JdD7aqWXuBffm+ABjR4wTI0xs54
	MvjWsPFCvIGZ+O8BLq2g1Ax89qQenA2VM+Ih/Lwv0AJ5Xm6TsLfv8xWoQYHiNJvNKyZN2lAS24M
	UuOKYivhdJokRwybzsElG2/flqQk/yTE=
X-Gm-Gg: Acq92OE/Fp6SqyjbOaG+AOjxP/1XIucBz/hcTQJpCFodc9CcUn8GHq2O0ZMql1jnIUs
	PhAdU1JGCkJwD7Gd/2CAi+lppWo32Q4IvxL1/t7Hno2HsS/ngywavrqsGNYQzUFIc/DEKHisVpm
	FhDojNHwQvYS0FvU27DuaDVaORAgQmh53gzcWe0im+poaJq/FLgA4/3yiX9XEgKFVBYSD1s/z9Z
	gf3XmAh5rNH6cWxUEd5G4wKvs8nJ0zIGGueucibH6p2GYSXOg5dno9Ukv0cCYBteyiDsojcPZVx
	YC5CWun3Svq9G/fy+JpAgkb7Xtyd8T0YOzrP
X-Received: by 2002:a05:690e:686:b0:65c:5bfd:b205 with SMTP id
 956f58d0204a3-65e2290ca0amr2685003d50.62.1778846746950; Fri, 15 May 2026
 05:05:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260502132506.1936358-1-michael.bommarito@gmail.com>
 <20260510232455.2245650-1-michael.bommarito@gmail.com> <2632015.1778845625@warthog.procyon.org.uk>
In-Reply-To: <2632015.1778845625@warthog.procyon.org.uk>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Fri, 15 May 2026 08:05:33 -0400
X-Gm-Features: AVHnY4I29IMk4pfB2O_u4c2IAaqwMg7WHsEKDsh2DM4cK4qrbnRcwgxc05ExzdQ
Message-ID: <CAJJ9bXy2Kor7mn=KYGvN0UnAwN2=oibsyrqLZ9Aq9rTRV-fukg@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: krb5 - filter out async aead implementations
 at alloc
To: David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>, 
	Marc Dionne <marc.dionne@auristor.com>, linux-afs@lists.infradead.org, 
	Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org, 
	stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2026 at 7:47=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> Michael Bommarito <michael.bommarito@gmail.com> wrote:
>
> > -     ci =3D crypto_alloc_aead(krb5->encrypt_name, 0, 0);
> > +     ci =3D crypto_alloc_aead(krb5->encrypt_name, 0, CRYPTO_ALG_ASYNC)=
;
>
> Apologies, but doesn't that do the opposite of what we want?
>
> Documentation/crypto/architecture.rst says:
>
>         The mask flag restricts the type of cipher. The only allowed flag=
 is
>         CRYPTO_ALG_ASYNC to restrict the cipher lookup function to
>         asynchronous ciphers. Usually, a caller provides a 0 for the mask
>         flag.
>
> Don't we want only synchronous ciphers?

This suggestion originally came from Herbert, but when I checked it, I
missed that note and just looked at the code at crypto/api.c:71:

71         if ((q->cra_flags ^ type) & mask)
  1             continue;

crypto_alloc_sync_aead does the same thing at L212 in aead.c.

So the bit mask should filter the way we want, despite the
documentation's implication.  Perhaps we should separately update that
line in the docs to be more clear about filter and how to properly use
it.

Thanks,
Mike
