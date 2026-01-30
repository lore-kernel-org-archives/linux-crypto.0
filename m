Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605422C0F72
	for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 16:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769790801; cv=none; b=SCg2Pko3MsGx8AGkn3B5a2vFXmjCvVRG1P0M2upxn5Q6OJ1mo6DlquvdiomZOozkDFFeDRGIGOZJNtlcJZ3OMX0t0/epApAknqOT8izkCA5CpfosNV+9DTC4mrnVQNLYa3VP329fueXFqKDIv8nZSRNj29Bt+AqrZukAAhMmRjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769790801; c=relaxed/simple;
	bh=Nz0IQMj9gpqoNpwgfkSaMZrBqdMpWsXigzJrbzuVi0A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tlJVD+tZj5SYzHcC0UcIlF7YXeWnTHW2IQbHM2W4OOEzLYrOf7u+MpLpgDAB/SV9rEJLITDsQLQp+RzSRdfyffBRPF/NN5EeHwe7g5Lhw62x+CVpGFCiP8j+7KKYqnIOab5ulfjo5F0mP2M4+dKvptFry+hvZaVbN7IDQ6FZcyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WmS+Z8no; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WmS+Z8no"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-4042905015cso1463736fac.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 08:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769790799; x=1770395599; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Nz0IQMj9gpqoNpwgfkSaMZrBqdMpWsXigzJrbzuVi0A=;
        b=WmS+Z8noPYo6Lx/PNgOvWW4SElDfDGf/aIkbLySJKfbXYSANgBNuFoSDjnNZpQS3LC
         1+N7UfwPYvreZH7JvQQ9sLc/5ICvjg4Oa+bYbva0f/Sm0Zgp9bn2cjIKs0ofq59VzC9q
         abCj+x0U/6BEjPRXEHStgu9wtsm/7qzeVkfVXfvsere1eMXPpcew+NdWUmiHVAbvcTiA
         XQgLacwS4v1lgltyzpRVTvVraHrL0MOS0ldZPpVjcXCnC4kcjm1A+QKOR59wg83gnjlL
         jXldP/e+C6MRO5wSBEMmBVN//njJRRS1aoEdY/HZh0CO7SZFWr+Yd4QKy/Vuo/LL9l8+
         CdDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769790799; x=1770395599;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nz0IQMj9gpqoNpwgfkSaMZrBqdMpWsXigzJrbzuVi0A=;
        b=mgk6CO1xErxR1R5sakp85ak+xnYmQOel3WvCF8SU69E8pDYbhYwGSpYcCEuSJUr/2x
         kYpY8nhrMIcB4Ijwfvjspg1AyWsHLUWHBs8q4xdlSruzcOIfegYxef8LWbPgjXk2pix7
         UhxB/FN/tr3azj3tL0BPqhB3pn8n8P5+mmh/aAIA9j71NO77fqrVCjWVy4Gfj+GgEnFS
         ik15dgmRmUBa/UKwyn2Wvbh91Uo86vrwwKVQPTCLy/HWBtsWldNgjOina31JOc0h9ZvG
         Ozj+R+q6N8+Gkb8ZYx2x+qyKyBd1BwEodHVNAdSXbf6m/GQI9SNjPQ+NEf/lnEp6m5vO
         Rxaw==
X-Forwarded-Encrypted: i=1; AJvYcCXcANgz1rsfejruyqRiTlqcYy9mtBy/tmofs4SHUkq3ftibJwoEcypUdqASmtisvV8gDIGNoMsHjlMiC1M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx69A2lMe2sWhQIQD8DKu9Vc/bzZgBUcRD3XsireGFVthB07BHz
	ihqhnDWnPiquRzQ3kSlrMXyCB5sp6ARqP5NUdZddVYKCCVsdiFrJ5zxptzjN
X-Gm-Gg: AZuq6aI3l2JZ9iUaOG+A7H9rgHZvMyUwiFze345ioXAy6tiqxSs5ZsZei2m1gnofWrx
	5865E/4g21a5eDzRG+18KH/YeVl1IP2QLH+YeXTN7ltMusNgWWCKfDXdjaPvVQSSV0ItBpib9i8
	ZptQUKtkjIIc07zBvQQPlkfbVnvq6b14ix9kl8BN7hljpY49LWknq0D+T8oxYOWobWUCb9OqO1T
	MkwHhZu0Sk4EePp2aAaLIf/jltkBPDNzD45cmyBF29YVdTNdmEmdDrOb3odPNY9KZ91oPSqef2Z
	rxso847lG9EI1XnGNT8qrvN+4MUSf+3LwzJ7ia/7DCE5xV6ZWSYUlgfRDcNqSUkc4ZFobh9TlbS
	He8YvBycQZClu31g8GYcFDhgTaEHWDXl6mg14pKi04/KdGDwIkjho5v2DKjhggcyqU/NQp+ohFx
	iLEYeulPSdMpQomZCES57wEZ3RSvpIN4a1mhCU8Zovntfl405Q0GoXlvIqNymqaMi5vGVB2Nxc3
	bnGGYaHmf97hSVRhFxqTdHIrMjSuRpAFLlhtm6YXswBITGwHlaMymGo/6DGSPQGXzJVjQvr28OZ
	sw==
X-Received: by 2002:a05:6820:81c8:b0:662:bf0e:16a1 with SMTP id 006d021491bc7-6630f3cac58mr1638959eaf.83.1769790799063;
        Fri, 30 Jan 2026 08:33:19 -0800 (PST)
Received: from leira.trondhjem.org (162-232-235-235.lightspeed.livnmi.sbcglobal.net. [162.232.235.235])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4095753b347sm5469812fac.17.2026.01.30.08.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 08:33:18 -0800 (PST)
Message-ID: <f0c1d246022214e41ece2b42424be079b182c246.camel@gmail.com>
Subject: Re: [PATCH v2 3/3] NFSD: Sign filehandles
From: Trond Myklebust <trondmy@gmail.com>
To: Benjamin Coddington <bcodding@hammerspace.com>, Lionel Cons
	 <lionelcons1972@gmail.com>
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Date: Fri, 30 Jan 2026 11:33:17 -0500
In-Reply-To: <97207D44-31EC-474F-8D68-CBA50CA324AE@hammerspace.com>
References: <cover.1769026777.git.bcodding@hammerspace.com>
	 <0aaa9ca4fd3edc7e0d25433ad472cb873560bf7d.1769026777.git.bcodding@hammerspace.com>
	 <CAPJSo4XhEOGncxBRZcOL6KmyBRY+pERiCLUkWzN7Zw+8oUmXGg@mail.gmail.com>
	 <97207D44-31EC-474F-8D68-CBA50CA324AE@hammerspace.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-01-30 at 08:25 -0500, Benjamin Coddington wrote:
> On 30 Jan 2026, at 7:58, Lionel Cons wrote:
>=20
> > [You don't often get email from lionelcons1972@gmail.com. Learn why
> > this is important at
> > https://aka.ms/LearnAboutSenderIdentification=C2=A0]
> >=20
> > On Wed, 21 Jan 2026 at 22:03, Benjamin Coddington
> > <bcodding@hammerspace.com> wrote:
> > >=20
> > > NFS clients may bypass restrictive directory permissions by using
> > > open_by_handle() (or other available OS system call) to guess the
> > > filehandles for files below that directory.
> > >=20
> > > In order to harden knfsd servers against this attack, create a
> > > method to
> > > sign and verify filehandles using siphash as a MAC (Message
> > > Authentication
> > > Code).=C2=A0 Filehandles that have been signed cannot be tampered
> > > with, nor can
> > > clients reasonably guess correct filehandles and hashes that may
> > > exist in
> > > parts of the filesystem they cannot access due to directory
> > > permissions.
> > >=20
> > > Append the 8 byte siphash to encoded filehandles for exports that
> > > have set
> > > the "sign_fh" export option.=C2=A0 The filehandle's fh_auth_type is
> > > set to
> > > FH_AT_MAC(1) to indicate the filehandle is signed.=C2=A0 Filehandles
> > > received from
> > > clients are verified by comparing the appended hash to the
> > > expected hash.
> > > If the MAC does not match the server responds with NFS error
> > > _BADHANDLE.
> > > If unsigned filehandles are received for an export with "sign_fh"
> > > they are
> > > rejected with NFS error _BADHANDLE.
> >=20
>=20
> Hi Lionel,
>=20
> > Random questions:
> > 1. CPU load: Linux NFSv4 servers consume LOTS of CPU time, which
> > has
> > become a HUGE problem for hosting them on embedded hardware (so no
> > realistic NFSv4 server performance on an i.mx6 or RISC/V machine).
> > And
> > this has become much worse in the last two years. Did anyone
> > measure
> > the impact of this patch series?
>=20
> We're essentially adding a siphash operation for every encode and
> decode of
> a filehandle.=C2=A0 Siphash is lauded as "faster than sha255, slower than
> xxhash".=C2=A0 Measuring the performance impact might look like crafting
> huge
> compounds of GETATTR, but I honestly don't think (after network
> latency) the
> performance impact will be measurable.
>=20
> I attempted to measure a time difference between runs of fstests
> suite --
> there were no significant measurable effects in my crude total time
> calculations.
>=20
> I could, if it pleases everyone, do a function profile for
> fh_append_mac and
> fh_verify_mac - but the users of this option do not care about gating
> it
> behind strict performance optimizations because we're fixing a
> security
> problem that matters much more to those users.
>=20
> > 2. Do NFS clients require any changes for this?
>=20
> No - the filehandle is opaque.
>=20
> Ben

The other thing to note is that this is an opt-in feature. If you don't
want to use it for fear of CPU load, you are free not to change your
/etc/exports config file.

--=20
Trond Myklebust
Linux NFS client maintainer, Hammerspace
trondmy@kernel.org, trond.myklebust@hammerspace.com
