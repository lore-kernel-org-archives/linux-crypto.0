Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A45209F43
	for <linux-crypto@vger.kernel.org>; Sat,  2 May 2026 08:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777711238; cv=none; b=IV+F1Jthb++faTEMLiuFhVVvaL0pzGnsAWjaJ1eV5M5JncithGAFeY2xNkIC3XckHetReb+cd98gFQurGUOPozoB64VnJvlihW9pTrMKvC/Aqc/qorTiR9YZuGhvg5W44144n3favoaj3ePK3qM/1lnECuSHZqtOw42j/7LrEis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777711238; c=relaxed/simple;
	bh=DNaJGk3nEfqkQ+ZfWCSHOlQwU+F4Bs4+WSTF6/fMIcM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=olYiDsi2N+IsbfUuSvZsMuu26E8t5YfwSc8EOKkAGqx5xMFNuSyHcHXbNxaP62+EVr6j1xMdkpvMKT3LGNjS9sLZKFvhi2/bVZBU1XU81KjBG15bqVkuSvtchLToivhhrUeHeQCciAvKuWS1of+Us+F0fhkugXwKXa/b1cskSEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-670ab084a39so4609319a12.3
        for <linux-crypto@vger.kernel.org>; Sat, 02 May 2026 01:40:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777711235; x=1778316035;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cJ6hjVJnVMdiF3idaO6wQZ9WKWpqRIj7dzC4FjRmPgg=;
        b=pKXfaKU1JBPQhg9GlbFBJLjw92VxnelHnXEskF9+vz132Poee6ns4aVNjeeskbcuH3
         TtnhONrGqr/QGzps7l2dwfAd66c6cERA0lsqrk70juTaybREIFPU4k5eGQCh7/5G5U0g
         PXxL2VntesSndmClu/rmrdPP6BZ0qEVmK1jDXtANf2ApHtAkYbL9U69rJ7O1Ah1maSdH
         Ozzokz9MdoXV4RQMSGuLTKOJvEcsg0iIM21VxWSig7PWcvnF2Vwnt4QU/NXwJflgRl28
         MgJB3vaMrQUmnUaP3ZSrFqrkgxNpC5ytqkAZc57dAiISuQvkjCCMH7t/6MMG3CoqUuPm
         x7UA==
X-Forwarded-Encrypted: i=1; AFNElJ/pbOenPpZJprOzXe7ObtSsGUglryYxhXgxONIFoSd4IH3K+m+0tNuc+PZGbPfbqafqCR4k1tgcM6e7H0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj/bSBCi098iNJ7pLYLr7EjWW3nbPMFDACcJTezireOTlpAzC6
	KPxZFaBEp5//mKFUulua6SHosvs4vPJtQ02zs3vIW81L0hT6RBSZh59B7cTFBT5SXZw=
X-Gm-Gg: AeBDievMmss+8UXGQ/S9s3cO+vmiMIvG0Yjra7tPvMQUzMKbsazdTfSIJE/FerzfxNz
	q3QVJlHmYBufmSNZnZXoa0tja8zx9pqbFix8qLIAVDEMWOM+MP3MXLpDaOi58oak3CNjpTnJyR/
	ozo7pJ8kGyy0RfmC3E+wDGo5Iw5A8mEo/GuUPS8KnUVg7WJ8HmcA6Haw8+QtjtQqXAh9yja4n63
	jAaq168KhGZLwM9Xl78Ke5lVMjaFyEAWQnTEYRx87SF5706G5GwpLxtTIRQytxQjxl/2ekMfWPi
	mAh3u5FRaeOVrQw5hRQHyN1vP6vkzafLr9I41zmywPhoFrmgkiCN/et6y6lNwxOCy6SQO9ykubY
	LKLybCIPTon+5XVOhzh9z4fqsun5J8UWiBV6QU8/7Hvn8Njyg0hNY5Z2mgBQDBCqGoKFs+RIklA
	XnLE2fFLIoBAYDfNYmS2mbhe3bB54nrJahG+nIHS4tz6+hvkXwsW+V5rdI7uLXtgSm9fQFckWfl
	7k=
X-Received: by 2002:a05:6402:448f:b0:670:8d21:dcb with SMTP id 4fb4d7f45d1cf-67c1abac537mr739975a12.19.1777711235299;
        Sat, 02 May 2026 01:40:35 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67b85e28ef8sm1547216a12.2.2026.05.02.01.40.33
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2026 01:40:34 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ba7a1cc0380so427685666b.2
        for <linux-crypto@vger.kernel.org>; Sat, 02 May 2026 01:40:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9QjFThsrQoWoptFaIlBKUZs/H2PR7TFMYSL1V6wTA01ZfHHjNxm5N1ugjUDPF9r0t74bZb39vpjKRYVGM=@vger.kernel.org
X-Received: by 2002:a17:907:3d8e:b0:b94:a1d4:ceff with SMTP id
 a640c23a62f3a-bbffc47ead7mr110221566b.35.1777711233486; Sat, 02 May 2026
 01:40:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260429181629.110802-2-bestswngs@gmail.com> <CAOs+rJUiup_B1ve7UztJH4crzE+98ZObRc3jLRsqkhLekpDmxA@mail.gmail.com>
 <afRa0lc2A4kHk9at@Air.local>
In-Reply-To: <afRa0lc2A4kHk9at@Air.local>
From: Ignat Korchagin <ignat@linux.win>
Date: Sat, 2 May 2026 09:40:21 +0100
X-Gmail-Original-Message-ID: <CAOs+rJVbZ2dNiiUSzaeNsYRwxRS=VupDE+VW3zZgwSqcRwaUkA@mail.gmail.com>
X-Gm-Features: AVHnY4LpgjUs8tmJ0FJ_9C1M8-3xq1XIXM16afDZyqPbnkONeOWebbWGGG3f4Ng
Message-ID: <CAOs+rJVbZ2dNiiUSzaeNsYRwxRS=VupDE+VW3zZgwSqcRwaUkA@mail.gmail.com>
Subject: Re: [PATCH] asymmetric_keys: check asymmetric_key_ids() for NULL
 before dereference
To: Weiming Shi <bestswngs@gmail.com>
Cc: g@air.local, David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Andrew Zaborowski <andrew.zaborowski@intel.com>, 
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Xiang Mei <xmei5@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 1, 2026 at 8:48=E2=80=AFAM Weiming Shi <bestswngs@gmail.com> wr=
ote:
>
> On 26-05-01 06:37, Ignat Korchagin wrote:
> > Hi,
> >
> > Thanks for the report.
> >
> > On Wed, Apr 29, 2026 at 7:17=E2=80=AFPM Weiming Shi <bestswngs@gmail.co=
m> wrote:
> > >
> > > asymmetric_key_ids() returns key->payload.data[asym_key_ids], which c=
an
> > > be NULL for keys parsed by the PKCS#8 parser (pkcs8_parser.c explicit=
ly
> > > stores NULL in prep->payload.data[asym_key_ids]).
> > >
> > > key_or_keyring_common() in restrict.c and find_asymmetric_key() in
> > > asymmetric_type.c both dereference this return value without checking
> > > for NULL. An unprivileged user can trigger a NULL pointer dereference
> > > in key_or_keyring_common() by creating a PKCS#8 key, restricting a
> > > keyring with key_or_keyring:<pkcs8_serial>, and adding an X.509 cert
> > > to the restricted keyring. CONFIG_PKCS8_PRIVATE_KEY_PARSER=3Dy is
> >
> > Could you add a simple bash script for this to the commit message?
> >
>
> Hi Ignat,
>
> Sure, here is a bash reproducer:
>
> ```
> #!/bin/bash
> modprobe pkcs8_key_parser 2>/dev/null
> openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:1024 \
>     -out /tmp/poc.pem 2>/dev/null
> openssl pkcs8 -topk8 -nocrypt -in /tmp/poc.pem \
>     -outform DER -out /tmp/poc.p8
> openssl req -new -x509 -key /tmp/poc.pem -outform DER \
>     -out /tmp/poc.der -days 365 -subj "/CN=3DTest" \
>     -addext "subjectKeyIdentifier=3Dhash" \
>     -addext "authorityKeyIdentifier=3Dkeyid:always" 2>/dev/null
> PKCS8_ID=3D$(keyctl padd asymmetric pkcs8key @s < /tmp/poc.p8)
> KR=3D$(keyctl newring test_kr @s)
> keyctl restrict_keyring $KR asymmetric "key_or_keyring:$PKCS8_ID"
> keyctl padd asymmetric trigger $KR < /tmp/poc.der
> rm -f /tmp/poc.pem /tmp/poc.p8 /tmp/poc.der
> ```
> If you'd prefer it in the commit message I can send a v2.

Yes, please. So if anyone tries to "optimise" it later they would have
a clear test case

> Thanks,
> Weiming Shi

Ignat

>
> > > required.
> > >
> > >  Oops: general protection fault, probably for non-canonical address 0=
xdffffc0000000000
> > >  KASAN: null-ptr-deref in range [0x0000000000000000-0x000000000000000=
7]
> > >  RIP: 0010:key_or_keyring_common (crypto/asymmetric_keys/restrict.c:2=
05 crypto/asymmetric_keys/restrict.c:279)
> > >  Call Trace:
> > >   <TASK>
> > >   __key_create_or_update (security/keys/key.c:884)
> > >   key_create_or_update (security/keys/key.c:1021)
> > >   __do_sys_add_key (security/keys/keyctl.c:134)
> > >   do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:8=
3)
> > >   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> > >   </TASK>
> > >  Kernel panic - not syncing: Fatal exception
> > >
> > > Add a NULL check in find_asymmetric_key(), mirroring the existing
> > > pattern in asymmetric_match_key_ids() and asymmetric_key_describe().
> > > In key_or_keyring_common(), skip the trusted key matching when it
> > > has no key IDs and fall through to the check_dest path.
> > >
> > > Fixes: 7d30198ee24f ("keys: X.509 public key issuer lookup without AK=
ID")
> > > Reported-by: Xiang Mei <xmei5@asu.edu>
> > > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > > ---
> > >  crypto/asymmetric_keys/asymmetric_type.c | 2 ++
> > >  crypto/asymmetric_keys/restrict.c        | 9 ++++++---
> > >  2 files changed, 8 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymme=
tric_keys/asymmetric_type.c
> > > --- a/crypto/asymmetric_keys/asymmetric_type.c
> > > +++ b/crypto/asymmetric_keys/asymmetric_type.c
> > > @@ -109,6 +109,8 @@ struct key *find_asymmetric_key(struct key *keyri=
ng,
> > >         if (id_0 && id_1) {
> > >                 const struct asymmetric_key_ids *kids =3D asymmetric_=
key_ids(key);
> > >
> > > +               if (!kids)
> > > +                       goto reject;
> > >                 if (!kids->id[1]) {
> > >                         pr_debug("First ID matches, but second is mis=
sing\n");
> > >                         goto reject;
> > > diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_ke=
ys/restrict.c
> > > --- a/crypto/asymmetric_keys/restrict.c
> > > +++ b/crypto/asymmetric_keys/restrict.c
> > > @@ -243,10 +243,14 @@ static int key_or_keyring_common(struct key *de=
st_keyring,
> > >                         if (IS_ERR(key))
> > >                                 key =3D NULL;
> > >                 } else if (trusted->type =3D=3D &key_type_asymmetric)=
 {
> > > +                       const struct asymmetric_key_ids *kids;
> > >                         const struct asymmetric_key_id **signer_ids;
> > >
> > > -                       signer_ids =3D (const struct asymmetric_key_i=
d **)
> > > -                               asymmetric_key_ids(trusted)->id;
> > > +                       kids =3D asymmetric_key_ids(trusted);
> > > +                       if (!kids)
> > > +                               goto skip_trusted;
> > > +
> > > +                       signer_ids =3D (const struct asymmetric_key_i=
d **)kids->id;
> > >
> > >                         /*
> > >                          * The auth_ids come from the candidate key (=
the
> > > @@ -290,6 +294,7 @@ static int key_or_keyring_common(struct key *dest=
_keyring,
> > >                 }
> > >         }
> > >
> > > +skip_trusted:
> > >         if (check_dest && !key) {
> > >                 /* See if the destination has a key that signed this =
one. */
> > >                 key =3D find_asymmetric_key(dest_keyring, sig->auth_i=
ds[0],
> > > --
> > > 2.39.0
> > >
> >
> > Ignat
>
