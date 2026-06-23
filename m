Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFA83C141F
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 22:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782252411; cv=pass; b=sQyH0J2LOhePtCgUFWindEHnBuAXir0P9A0Vz+RvqZw2hyoH8X/0N+xDrzDkDo/oR8ZQEhIM45UprYkRSNG07pa6l1eCG0He7Ia66+3gI0tZPTkghSwcS5wv36M8Krh3lcETZM0EEwC9wAb7G+5y/S8ra8FxWj4b3NwGsoUY9wY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782252411; c=relaxed/simple;
	bh=P4Bjcc2g90rCZwpLUPfcYDqywWWZ3CPJdaKkyPaUlPQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jkrk33mxIfk+dbmigGjpDfQUrOxtdhx2hNJwuTjhsF9ZbEJHmvLExv8zvQpHchEIe2r1jhA40JDDbtEMi8K0/f1lZNAEQgWgLgAtGdU+9L+YLnTTtni5cJrcIH02qIfDddzQMmu5RMhOQ9yyZZdO0LwOObKyMaJlqFrPBZ78ZIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nn0nxI0L; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nn0nxI0L"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6978f1eeb87so535259a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 15:06:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782252408; cv=none;
        d=google.com; s=arc-20240605;
        b=jju7NOxkVXmCTEVCYoP4IlGgAxEGT2BNz7rJ/YjXc8nvU1Fc+ecJOfr2tSmZ0WEjrN
         BctpOmoeZ7BntbkHKdRRRjEW3kdxhN9l082krcTpJGfBD2UAh6cHcuorJfg7EOtbYrRx
         3695y6LoaHK4xlCMYv7Q7zQsIO7PAEviAEKvp9v0nue0+Rd6BEODOXY8w7uBYp1I8C8+
         mqQeUaBSdzXQlOlKMXL8GQMHI2MioSYU1DmOcGbwMtQ2/B0Wq5bpYOuUvzVajLRPBnb2
         O5xEBk2pHgXTfjii7PqfkyWU6AHlj9asuRsoNFmntgUoawpH7XrMKfdN/zDwLgz7ABju
         hZTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XoJED+TBqNpCfXx2/2rhI9BnHRUNSOFVPTrIiEf4/tE=;
        fh=oQPyVsOfiflImFtc3HupBs+Qdh4bh24JxOAgZ5D/+F0=;
        b=N67LwXtLRmo0SQ7WIcOrWqpaQiqZYWbhn0nfu6mtAH8xJjixgXwX/8Kb9+b5E9Mlof
         GdDEkVi0MPd5HzXak9vGzWLsfqyNzzNAMkq/HQIqOUqiMb8dkX+4AB6/XIjS5oNMP6TJ
         teRucZXCQenrhCfZRv3/jL5hQjJO9Dmbp+DviNAA1xvqYc+ATxM8YBy5ngOGoNH0w0Cs
         a3a8Us/Li45RCnozZ4z6SPhvrlVrl9bs3z46sw26JSb8pPV3+8uyuiishcYOIciK75lk
         B1ssOM4kflcF7/Fxknt1BTCWQwgD/R4tUMdGRVLvLyhSplHxznW2BFNd5LI4NMfba3Ek
         sGbg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782252408; x=1782857208; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XoJED+TBqNpCfXx2/2rhI9BnHRUNSOFVPTrIiEf4/tE=;
        b=nn0nxI0LL0ujyTcRYudT83wXs5YAnXQXPEvbSakGfIUPr7OauhwhUAVByUfyjQsE4G
         3VsbLDTuZfm9pKV/RMoJiNnQOQzLQc9H/0AewOryQVRgcxSvH5ztRM7Kj83wf25Mwcj9
         tT23LPx8w1vNREnckrRCKp4844JqBv3D9kF2pbiKV1kxe6KD637tqtGmMFlMlxqj9igW
         g+/eLdjtEpl2+oM1TQfM6LU04V51mvvZ2U3aGgGrbAb5sJtR/X0gnWQz+nvIMxXvQYgI
         6bF65nHrwFEpZvHRk89RCsMlJYYmm6sSo098xDc1b2Cd+3xphLPphdQhMceBP0zCVIU7
         uIDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782252408; x=1782857208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XoJED+TBqNpCfXx2/2rhI9BnHRUNSOFVPTrIiEf4/tE=;
        b=dl6q3sg5lArtK5cnJX1/33Akb7TYRo1IeZp8K5M/TJPOT+giv8J+znnc2Zy3Kec4ju
         eDiRP0rKFnxdop6M3+l+F0i102DS2DOrODMgnbDDWFiiJxa1ZTo3MftkzqR+OcA3FTey
         r5LxHW5RiMVoSOgoPft5cf4793dchEXm2BD/PSnbDKSbWTKhZ+Tt6be0eumWhBfw3hpH
         Xe+eXBu3UR2utnf51z4aCM51RYeR6Nrs0f8BBaaPzGb5EMAmCWiBsQ20dKkshEBurVsn
         t0aI2JvDNKLdy8p/oNbpBpdVTn9VPI1/e3SSUOnK7PTu/6Nh5k1oYRp5QGra6I9FvyzY
         xgZw==
X-Gm-Message-State: AOJu0Yye+TB1LenAlPR6zgQ4NoC8RNmEm3ai7ZHt6DgWvl+plR1cPXuH
	CyeNA80OLNzqiUm3OobtZAp7XUo1qHrDuxpOG5whFdI45+NptTCvyElEbFcd2RXgRiSCDl2MuIF
	7zPcSnG5Rhvhul4xcBiMZ+X0MIsINDo0=
X-Gm-Gg: AfdE7cmrxtJbVzh+FhdINxFRgxLDcKx5TT5g8M8VtE7Kj+bzhj9Exf8mNOrLPW+5lJh
	L1N8ralP2OPewyR4iJQ3CWUjaEqArg5j0DjNwRbz1tn4A/T7PKebGwfoWqAOy0QXjowzRNiqUa+
	knyfVq0D2yl74bWi8afMXxN/1J2slmasBRjzObMPPjcceqvtET+ALkgL4aC0B74zj42m7wDUhkP
	gRtUnt/CKwT8aAhKWgONBbXcaRbY/7iFhKJwHhNacrQVdOCAoTT39GUDLIBq2shfXwWjFXNdDZw
	7LKW+KuyzcCLA02j5P6WRDKpckTTmFS8jE7t2ZmddUf+QSGOecu/8B9B9FRxHngxHnbhl+FsGt1
	laRyFOwFpgLBJrf+m0pB8s5wgxRuABMPsRcSlDRQKWElDsA==
X-Received: by 2002:a05:6402:146e:b0:68d:235a:cdaf with SMTP id
 4fb4d7f45d1cf-697f377116bmr189804a12.5.1782252407504; Tue, 23 Jun 2026
 15:06:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260622234803.6982-1-ebiggers@kernel.org> <CAKxU2N_EGTWkvtPOxQXBroxGVXDf1atPoFVyRRu0wHOtEXVWaA@mail.gmail.com>
 <20260623214730.GA3281861@google.com>
In-Reply-To: <20260623214730.GA3281861@google.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 23 Jun 2026 15:06:36 -0700
X-Gm-Features: AVVi8CeboaDakYuMckubiPixxEKhNCjPeUq6olU2uxCUHJDj2YuT_JoocSvKBZ8
Message-ID: <CAKxU2N_yu1LZeNxEUkhahx_5VYML7PZ0-EZfP94p7SmpWbO6qg@mail.gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev, 
	linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>, 
	Demi Marie Obenour <demiobenour@gmail.com>, Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 2:47=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Tue, Jun 23, 2026 at 02:28:17PM -0700, Rosen Penev wrote:
> > > +static const struct af_alg_allowlist_entry hash_allowlist[] =3D {
> > > +       { "cmac(aes)", true }, /* iwd, bluez */
> > > +       { "hmac(md5)", true }, /* iwd */
> > > +       { "hmac(sha1)", true }, /* iwd */
> > > +       { "hmac(sha224)", true }, /* iwd */
> > > +       { "hmac(sha256)", true }, /* iwd */
> > > +       { "hmac(sha384)", true }, /* iwd */
> > > +       { "hmac(sha512)", true }, /* iwd, sha512hmac */
> > > +       { "md4", true }, /* iwd */
> > > +       { "md5", true }, /* iwd */
> > > +       { "sha1", false }, /* iwd, iproute2 < 7.0 */
> > > +       { "sha224", true }, /* iwd */
> > > +       { "sha256", true }, /* iwd */
> > > +       { "sha384", true }, /* iwd */
> > > +       { "sha512", true }, /* iwd */
> > > +       {},
> > In OpenWrt, https://gitlab.com/linux-afs/kafs-client and strongswan
> > seem to be the other users of the user API. I haven't looked into what
> > they need.
>
> [Please trim your replies, thanks!]
Not sure what you mean.
>
> https://gitlab.com/linux-afs/kafs-client uses AF_ALG only for
> "hmac(md5)", which I already put on the privileged allowlist due to iwd
> also using it.  So it would still work by default with the current
> patch, unless it needs to use it unprivileged.
>
> (FWIW, a use of a single obsolete algorithm like this is also a good
> candidate for just replacing with local code...)
>
> https://github.com/strongswan/strongswan already supports userspace
> crypto libraries.
Oh lovely. Looks like this needs fixing in OpenWrt.
>
> - Eric
