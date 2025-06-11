Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A94125B2
	for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 00:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749601394; cv=none; b=H1UH3Ye37X11eQbZi+IP17Njdicz/+X8C6mwcV57+sEarN3Oi9rDt6PdrY5hm9JGKUEhJG/c6I3hjhbRKZ1gl9ICV4C7+tFDQ+7UqBDjG/wUDL7VVbHwXSVF75ZyDvYycXP36y1ze7ySy91wFPe+PlvLwQomrYsmVqXdEZd/L7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749601394; c=relaxed/simple;
	bh=V3aNCDfEzfxl/wtuWs/n53MDcr+guvxs8lJ6Ns350/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F6iKAn/KNU9b3yzza8HtDXQ+m7No4vUZEPCSduDS+0Gs11YEbTKjd1VRktgRIt8Y2vRaJ+xe8hI2tY83jn5qwHxY3trsH9NP1CigvQhpYkALl1ZvnirqKfvUN7QHINJKDQOakeRD3FdzITesv++4ays256Nra2064nbAdApSI84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=QQdEpC8t; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="QQdEpC8t"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-70e767ce72eso56387437b3.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jun 2025 17:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1749601390; x=1750206190; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mqyjEVOkyXwfMaGU1TDVpK5OMwZjvM7JjuGuGfqQfiw=;
        b=QQdEpC8tvO2NYpn3COPmL+/PVmayKd1y/tEzRp0zD6fbiE8eEN/tMpdbmPxgl4EMO0
         ScWtF+n9c/bZM6shIOECHLIXiu4uMksVUw4N2IjniUwitDomLVXsMEs0p9mBN/UZqxQg
         9PHX0ZJhAdHoHjQL73gzqD5WWL/Dj3Ts/ki+xHpY6Ad+AY0jMdoH4HJLmlxtAuzFOPv9
         90GBTd4WFbQMWM4bCKBKQ1RXY7p3jLNOcCJNxI1iT+If9x4AZuVqy4MJr6wuQXT4puvA
         dZV7tUaAYEAQoe6iGv542LJH5RyAAWpsiUtdZikRLcn9Uf5NarsFa89Ah5Waf3KQDSUR
         2JyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749601390; x=1750206190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mqyjEVOkyXwfMaGU1TDVpK5OMwZjvM7JjuGuGfqQfiw=;
        b=oWljvwKCfi9FY8iawcRgcE8/U+nJbR67af1S76xxEY8OpEKjzF8LCPOOXpbrk/irSw
         BQru4nsWVI3qr/sqi0tZnnFUhuvel6iUKojHGUvAAeV0CCrUCgWRfnvKgZdWhFrYyxex
         SqP4CEuNhUKg7sSshIj03eI4CwFPPTkXUmuH/UTKM4YRLvC7L1iRhsKpO8RcirZ/4jjf
         qrvmMjC9bbHDpKc2Ns50xlE+8bjj2Lj7DZ6AhbUORH8c9V8++K09ouEnIkjod5KxsLPK
         6HERMLYLUdytz8hlYyxBvLWjcL5RjCyD4ywys0/IbSlZpa/lWh8fU9o0j6v6sz2cz+s4
         6rHw==
X-Forwarded-Encrypted: i=1; AJvYcCXxpRmgpKhaZNKhiHK7kxaxPcneMQ6TQQ3kSm3jXQLy0WHIufNACoz4j2sEm2rdQ7ffu0GoehVaRxHGtaA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZDaZfdj9buSnpG754eiC2nA5t1c2Btka3E0vM1Dl112WZMU1L
	xGkLp8jBZWrEO8AMjydrS0ha9JSnBSXW8K6AeZJTVwp4IufXYCCIbw1sq98prNpaBKVGti0p8Bz
	IwUBpAdD6hBhBUN0Ws7B33PLbDvnKMB83uofgIdnR
X-Gm-Gg: ASbGncuThGfnao0OHqSvJqtUMa+50s07gx9THGolyFHNy7v8tTxJ9p33fFc1NTV1RPJ
	uF6y7KTBkm37kWjTsjyNUhqEV8LVE+VhFh+HOFZyTFr0OctnOVAcFA56BKhQJUHRYkdvIiIva0v
	oFHJE4LeUjiQ/qEDpog2lpU8NnEu/snCEsL/XtiQnZiD0=
X-Google-Smtp-Source: AGHT+IE8M3LJ60ObL9WxE/FHdUjay5d0gjuX+l5wso77lgWCLyR1qO4waNRelGVeYQBTPS1XTsACv75zMxCstcB/c64=
X-Received: by 2002:a05:690c:c92:b0:710:ead5:8a95 with SMTP id
 00721157ae682-71142415677mr13830317b3.14.1749601390477; Tue, 10 Jun 2025
 17:23:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <301015.1748434697@warthog.procyon.org.uk>
In-Reply-To: <301015.1748434697@warthog.procyon.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 10 Jun 2025 20:22:59 -0400
X-Gm-Features: AX0GCFuzTbBPakT7-fabDOVnCNVNEVKiLmeRI0FjA7IWgXlosDeLqvnendebUgs
Message-ID: <CAHC9VhRn=EGu4+0fYup1bGdgkzWvZYpMPXKoARJf2N+4sy9g2w@mail.gmail.com>
Subject: Re: [PATCH] KEYS: Invert FINAL_PUT bit
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 8:19=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> Hi Linus,
>
> Could you apply this, please?  There shouldn't be any functional change,
> rather it's a switch to using combined bit-barrier ops and lesser barrier=
s.
> A better way to do this might be to provide set_bit_release(), but the en=
d
> result would be much the same.
>
> Thanks,
> David
> ---
> From: Herbert Xu <herbert@gondor.apana.org.au>
>
> KEYS: Invert FINAL_PUT bit
>
> Invert the FINAL_PUT bit so that test_bit_acquire and clear_bit_unlock
> can be used instead of smp_mb.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> cc: keyrings@vger.kernel.org
> cc: linux-security-module@vger.kernel.org
> cc: linux-crypto@vger.kernel.org
> cc: linux-integrity@vger.kernel.org
> ---
>  include/linux/key.h |    2 +-
>  security/keys/gc.c  |    4 ++--
>  security/keys/key.c |    5 +++--
>  3 files changed, 6 insertions(+), 5 deletions(-)

It doesn't look like this has made its way to Linus.  David or Jarkko,
do one of you want to pick this up into a tree and send this to Linus
properly?

> diff --git a/include/linux/key.h b/include/linux/key.h
> index ba05de8579ec..81b8f05c6898 100644
> --- a/include/linux/key.h
> +++ b/include/linux/key.h
> @@ -236,7 +236,7 @@ struct key {
>  #define KEY_FLAG_ROOT_CAN_INVAL        7       /* set if key can be inva=
lidated by root without permission */
>  #define KEY_FLAG_KEEP          8       /* set if key should not be remov=
ed */
>  #define KEY_FLAG_UID_KEYRING   9       /* set if key is a user or user s=
ession keyring */
> -#define KEY_FLAG_FINAL_PUT     10      /* set if final put has happened =
on key */
> +#define KEY_FLAG_USER_ALIVE    10      /* set if final put has not happe=
ned on key yet */
>
>         /* the key type and key description string
>          * - the desc is used to match a key against search criteria
> diff --git a/security/keys/gc.c b/security/keys/gc.c
> index f27223ea4578..748e83818a76 100644
> --- a/security/keys/gc.c
> +++ b/security/keys/gc.c
> @@ -218,8 +218,8 @@ static void key_garbage_collector(struct work_struct =
*work)
>                 key =3D rb_entry(cursor, struct key, serial_node);
>                 cursor =3D rb_next(cursor);
>
> -               if (test_bit(KEY_FLAG_FINAL_PUT, &key->flags)) {
> -                       smp_mb(); /* Clobber key->user after FINAL_PUT se=
en. */
> +               if (!test_bit_acquire(KEY_FLAG_USER_ALIVE, &key->flags)) =
{
> +                       /* Clobber key->user after final put seen. */
>                         goto found_unreferenced_key;
>                 }
>
> diff --git a/security/keys/key.c b/security/keys/key.c
> index 7198cd2ac3a3..3bbdde778631 100644
> --- a/security/keys/key.c
> +++ b/security/keys/key.c
> @@ -298,6 +298,7 @@ struct key *key_alloc(struct key_type *type, const ch=
ar *desc,
>         key->restrict_link =3D restrict_link;
>         key->last_used_at =3D ktime_get_real_seconds();
>
> +       key->flags |=3D 1 << KEY_FLAG_USER_ALIVE;
>         if (!(flags & KEY_ALLOC_NOT_IN_QUOTA))
>                 key->flags |=3D 1 << KEY_FLAG_IN_QUOTA;
>         if (flags & KEY_ALLOC_BUILT_IN)
> @@ -658,8 +659,8 @@ void key_put(struct key *key)
>                                 key->user->qnbytes -=3D key->quotalen;
>                                 spin_unlock_irqrestore(&key->user->lock, =
flags);
>                         }
> -                       smp_mb(); /* key->user before FINAL_PUT set. */
> -                       set_bit(KEY_FLAG_FINAL_PUT, &key->flags);
> +                       /* Mark key as safe for GC after key->user done. =
*/
> +                       clear_bit_unlock(KEY_FLAG_USER_ALIVE, &key->flags=
);
>                         schedule_work(&key_gc_work);
>                 }
>         }
>
>

--=20
paul-moore.com
