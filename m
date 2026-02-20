Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E52366554
	for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2026 18:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771612167; cv=pass; b=WkQEiyI3e0SiCrfxp4/dDa9wXhr46l6ZqJN4luZLoSN056ot1ODuwCnl0q7zERF5ma5Fj+seNE8qOqBWk/LR4Y681iCHr596xwC6vm0YelojFU0gV1q8uNyIxA1B7HTVPTDUm3IsL1jw9jlXR0TiSTOpXNvxBKK/ddXHbxl6pnM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771612167; c=relaxed/simple;
	bh=7663svshQXQyUT7QeGek4AYFsb1CBanhtFh47Ej5L80=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OAdP59744S+dorm09eiJHo19IpjLygchKJ8HBv7aAO9OHiyA+OVAZYfJsD8xa4OJ8RkRQ5uZ6jcnwRXgsYy2cdV4qyR3qapEoNeRhr48dM9fbVAQVN30a9S/TbAvp1PZlSSRfOQQ43MYWQvR58ux2fMW0FCwleIi7XQ7l0ESSEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sb1vUai/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=E/R05jP6; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sb1vUai/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="E/R05jP6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771612165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CQybDPeMyxkOm/RrLjMjdoNHAXotIv3iNlfmQV1omME=;
	b=Sb1vUai/x74PEQ36U70wvy7TQd5tfHR9+aTgkZWSShdd1Sqr0D+36d12Z2xZ7v++a15COY
	pmPd9mEz+gBDo3zWGkuU87Bz0+0urDowWdK2P22pPh1Z4OkmtPZJy/T1JgKhR5fowOAaao
	F8miJeadwbkHaZyATD01OPU/watFfXo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-OwNYB8txM2OopdIigtGjMw-1; Fri, 20 Feb 2026 13:29:24 -0500
X-MC-Unique: OwNYB8txM2OopdIigtGjMw-1
X-Mimecast-MFC-AGG-ID: OwNYB8txM2OopdIigtGjMw_1771612163
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-65c1c72ecffso2645120a12.3
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2026 10:29:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771612163; cv=none;
        d=google.com; s=arc-20240605;
        b=SCbDXewEcqxw/inOEan+SPXsPV7q0lX9ASCEUFOgBPyBKlSoFfWrA8vlpiH1eiNqcW
         OtetP+JKwsVqZuEruIlb+f1s5Zfnd6+KffLL0YYpqscUrOwMZZcFiblHW4PgpFc1RVgh
         rGzczSseDZNy/5YBWtnsXpHjHxEGWbf4acev8MFOdJS1vRt9nGTjKRf7eBlpg5EniZvK
         WZw3UIXrI0qoj3VhiE8ZLhgrded9anaGmzZUxH2VQm+PiqscT75lXXfoG1fTIy331bt4
         4PP6AuotZ3gfEHCmlZ0cL3t6OflG4RfYYy1cVoK1ItwMugah9rHMAcdErEyzhT1B/0QP
         3HHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CQybDPeMyxkOm/RrLjMjdoNHAXotIv3iNlfmQV1omME=;
        fh=1ZkFonZMHcZB2ls29eh7gH7LKJ5rYikpHsXIgewXJpc=;
        b=U00A4YWhOeH5wGW5PUSgjg918UYXfG5Qpwf9bPEQktpaAgUh3/10Y6I5yGUyEz5ukk
         /k4PCRbEupLk3v8TNNXoMpSdVu+rb6iWXyzoyxfrbDjkjnmvVHoiQz9ldqy0w5GW6foY
         8Tuv3bMeehMOzOdcjS0/4eY9WPspeeAMxyUUePk9IIeCrJHYskavCZzKKHwBgz72rC88
         UN7jkwteS/pY3IhwQQBD24aDrusHSV9LiT0XsBT7jBaPXULunhMiz6eFj05kWT9f4yr/
         I0K8lUtHX+s6688PGwP4bVJ9/H8STwPL1dkbyHwdFqX0WsaXsTiBFjyS5WJV8l38hMlD
         sg2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771612163; x=1772216963; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQybDPeMyxkOm/RrLjMjdoNHAXotIv3iNlfmQV1omME=;
        b=E/R05jP6pKlFMj2st1xaqW31HW2c6BgmU3jEAr5AeL6gWQbSwTLhsJ3q3cNFgB+oX7
         DdQyxL/uCcZYhr2e9SPry65tuJVvCPZ55PtiHmA1F9fMAkCnN7eOu4YsvE4pnyAX7GgT
         4SSKHk1YxUwToWdqAbTO2FpIU6wiCUiTHbtUnwOcXoaLa2Ek/Nr3ok9Bp4xZOIjD6PyK
         fqZ+pRHDSjaKowZ+QICvvHdL5U2QcpyBDtIHfl1t/0SV2Hcab7UrBRlCCG83yTtvdzFG
         +MMC/WSuNogQB/bmUalAuooSz7LxgCDhnIZKYUAfvygpqAAKbpJoJgOhE6I7BTnu21ap
         f9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771612163; x=1772216963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CQybDPeMyxkOm/RrLjMjdoNHAXotIv3iNlfmQV1omME=;
        b=nAnKeYnx///Itoe1gGA+lxAed92kja8bX8BKt6fX15k6JVhuHrGzfZhkARi50A7qq1
         MuOhs2jfMhQRZ3p7qAwgU27EFICS6bM9FLJTv4t6qrudTNdHxB+G7GDiK5TpZYfA1xCY
         gzvpStPbi7aR/Qy/+2K0QWcVPEso1uRCdBt6pd9/AeBMXN4u/9SA9ShRAX9OotWFYxHz
         1rLHInkUg3JIB9UKRStqnxVPOEO5qZNONROFqu5NwzKE5fxxRlCz2dKjCDMaz6VU7yh5
         6hlaXtK7zet9k5dcgdao6att3nNxYIXQ/oaevGaJfAuBVQwZ4pdVUPyfaOAz/GPDutHf
         jChQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCbtZ839offieu3GQ8gl/WrKGYSY6ZSpnclguw3UvVp8Ho93BscOc3I94v6CnWh4ECb+hKRvKlkaISX0M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdNap1NQH8rx8EEEG3UIg51UXTuiOWaUbDhUk3Vo7MeJ0UK7HB
	PGknBknS26eJ6vWwkLf3AA62VmP8/d3WNLJCyuaiwVqqMvpvHpDMAPJWFsu0roTTSLCjettKCMF
	gdLqzKA05j+IklP+GKIbOxE+4ArmldRnV/HUqToAzkPJ5RCFjuAkYxAeI6/BbMuW82uqj1hf3JS
	3MhPWLFh+D62otFw0/NjdoQVTArah8dEsYOHTwbYw+
X-Gm-Gg: AZuq6aLZAGOmzyeQ9USGuR3g/xBfzMl2wGCZaBvkT+6+Y21DfB/1CSoggudllxAJLn7
	YzV9GRynV9GrxKAg9OutjBm4m4u3tFa8njOlz6PuRQlBdYyKgRgcZ4p4kSpIIAbzAGIld4++fFi
	Pwt3wxXBXUgCz2oVIBT3NwQBwKeoCVWgcHc7f53XJ1j4VTQbaaWX/IP0OBbPw0i0qBb+mcuASRf
	ZfAreqnIvHu2K+6pkZ0G1lDRhMFNLwhE4oOLC40
X-Received: by 2002:a05:6402:2684:b0:659:36de:6d20 with SMTP id 4fb4d7f45d1cf-65ea4ed5a32mr338133a12.14.1771612162551;
        Fri, 20 Feb 2026 10:29:22 -0800 (PST)
X-Received: by 2002:a05:6402:2684:b0:659:36de:6d20 with SMTP id
 4fb4d7f45d1cf-65ea4ed5a32mr338110a12.14.1771612161989; Fri, 20 Feb 2026
 10:29:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260219000939.276256-1-tim.bird@sony.com> <CAC1cPGy07RtOQifhova1+6ezTiKHzK8ZjBKQrWY9UW1t4hAG1Q@mail.gmail.com>
 <MW5PR13MB56321384E8C28E3320ACCD96FD68A@MW5PR13MB5632.namprd13.prod.outlook.com>
In-Reply-To: <MW5PR13MB56321384E8C28E3320ACCD96FD68A@MW5PR13MB5632.namprd13.prod.outlook.com>
From: Richard Fontana <rfontana@redhat.com>
Date: Fri, 20 Feb 2026 13:29:10 -0500
X-Gm-Features: AaiRm52Pql-iw_SuzkFBsWaZkFkOIcxv6PAnHaTq9HCPP12_2AZybiaH18OgExE
Message-ID: <CAC1cPGwgPbS51uiUmLwHzi7g3iydA8-796WivwAHFJrh7ZPm+A@mail.gmail.com>
Subject: Re: [PATCH] crypto: Add SPDX ids to some files
To: "Bird, Tim" <Tim.Bird@sony.com>
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, 
	"davem@davemloft.net" <davem@davemloft.net>, "lukas@wunner.de" <lukas@wunner.de>, 
	"ignat@cloudflare.com" <ignat@cloudflare.com>, "stefanb@linux.ibm.com" <stefanb@linux.ibm.com>, 
	"smueller@chronox.de" <smueller@chronox.de>, "ajgrothe@yahoo.com" <ajgrothe@yahoo.com>, 
	"salvatore.benedetto@intel.com" <salvatore.benedetto@intel.com>, "dhowells@redhat.com" <dhowells@redhat.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"linux-spdx@vger.kernel.org" <linux-spdx@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 19, 2026 at 7:02=E2=80=AFPM Bird, Tim <Tim.Bird@sony.com> wrote=
:
>
>
>
> > -----Original Message-----
> > From: Richard Fontana <rfontana@redhat.com>
> > On Wed, Feb 18, 2026 at 7:10=E2=80=AFPM Tim Bird <tim.bird@sony.com> wr=
ote:
> > >
> >
> > > +// SPDX-License-Identifier: GPL-2.0-or-later OR BSD-3-Clause
> > >  /* FCrypt encryption algorithm
> > >   *
> > >   * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
> > >   * Written by David Howells (dhowells@redhat.com)
> > >   *
> > > - * This program is free software; you can redistribute it and/or
> > > - * modify it under the terms of the GNU General Public License
> > > - * as published by the Free Software Foundation; either version
> > > - * 2 of the License, or (at your option) any later version.
> > > - *
> > >   * Based on code:
> > >   *
> > >   * Copyright (c) 1995 - 2000 Kungliga Tekniska H=C3=B6gskolan
> > >   * (Royal Institute of Technology, Stockholm, Sweden).
> > >   * All rights reserved.
> > > - *
> > > - * Redistribution and use in source and binary forms, with or withou=
t
> > > - * modification, are permitted provided that the following condition=
s
> > > - * are met:
> > > - *
> > > - * 1. Redistributions of source code must retain the above copyright
> > > - *    notice, this list of conditions and the following disclaimer.
> > > - *
> > > - * 2. Redistributions in binary form must reproduce the above copyri=
ght
> > > - *    notice, this list of conditions and the following disclaimer i=
n the
> > > - *    documentation and/or other materials provided with the distrib=
ution.
> > > - *
> > > - * 3. Neither the name of the Institute nor the names of its contrib=
utors
> > > - *    may be used to endorse or promote products derived from this s=
oftware
> > > - *    without specific prior written permission.
> > > - *
> > > - * THIS SOFTWARE IS PROVIDED BY THE INSTITUTE AND CONTRIBUTORS ``AS =
IS'' AND
> > > - * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,=
 THE
> > > - * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULA=
R PURPOSE
> > > - * ARE DISCLAIMED.  IN NO EVENT SHALL THE INSTITUTE OR CONTRIBUTORS =
BE LIABLE
> > > - * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONS=
EQUENTIAL
> > > - * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE=
 GOODS
> > > - * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPT=
ION)
> > > - * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRAC=
T, STRICT
> > > - * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN=
 ANY WAY
> > > - * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILI=
TY OF
> > > - * SUCH DAMAGE.
> >
> > This is not `GPL-2.0-or-later OR BSD-3-Clause`. It appears to be
> > something like "GPLv2-or-later code based partly on some BSD-3-Clause
> > code" which would be `GPL-2.0-or-later AND BSD-3-Clause` (with some
> > significant loss of information in the conversion to SPDX notation,
> > but I've complained about that before in other forums).
>
> Well, this particular combination is indeed problematic.  The 'Based on' =
notice
> does indeed not necessarily mean that either license could be used, if th=
is code
> were extracted from the kernel.
> It would take some deep research to determine what was added that was NOT
> BSD-3-Clause before and after the code entered the kernel source tree.  A=
fter the
> code enters the kernel source tree, the usual assumption is that code con=
tributions
> are under GPL-2.0-only unless the specific file license says otherwise. H=
owever, with both licenses mentioned
> in the header, I suspect a large number of contributors interpreted the s=
ituation
> as an OR.

That would surprise me, but, in the words of the Big Lebowski, perhaps
you're right.

> The end result of this is that normally most of the contributions are ass=
umed
> to be GPL-2.0-only, and it would not be appropriate to release the whole =
file under BSD-3-Clause.
>
> I don't think it can be 'GPL-2.0-or-later AND BSD-3-Clause', because the =
3rd clause
> in BSD-3-Clause is incompatible with GPL-2.0 (although some people disagr=
ee with that,
> that's how I read it).

That's a legitimate reading but I would contend it's out of step with
settled expectations going back multiple decades about the ability to
combine BSD-3-Clause (and licenses with similar clauses to clause 3).
Even if you're right, though, that doesn't mean "AND" is incorrect, it
would just mean that there's a license incompatibility for people who
care about that sort of thing.

> There are likely a number of cases in the kernel where developers took BS=
D-3-Clause code
> and re-licensed it as GPL-2.0 (or GPL-2.0-or-later), which is not strictl=
y kosher based solely
> on the 3rd condition issue.  However, I think the 3rd condition (the no-e=
ndorsement clause)
> is a goofy one, that has never been acted on in any legal capacity, and f=
or which the risk of
> a bad outcome is very low, if it were completely ignored.  I could expand=
 my thinking on this,
> but this post is already too long. Overall, I'm inclined to just mark thi=
s one as 'GPL-2.0 -or-later'
> (not using an OR at all), but leave the 'based on' text, and call it good=
. I might add some text
> saying to look at the original code as submitted to the kernel if someone=
 wants a version of
> the code under the BSD license.

> By the way, Richard, I appreciate the review of the patches and your thou=
ghts.

Thank you!

Richard

