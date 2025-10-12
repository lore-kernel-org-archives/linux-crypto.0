Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B53F2ED15F
	for <linux-crypto@vger.kernel.org>; Sun, 12 Oct 2025 17:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760291878; cv=none; b=CByb9kRrnKhPZoIoh6U1xcb1qS67jd3YzWKCWTFGvipcPNHqFWPy8SQ+1D2IzD1PMRYICAzqHKV0C4wXMGvIvQP+23C2SrxkzyHHXWM5bxZsuXM2faUfc8MKyEt88SOacHfiCuYowWJFbL/H/uLwvepgCr3zYpqcM+539u2AoBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760291878; c=relaxed/simple;
	bh=dIa6LC613mYhl2CLAXvXtPZk55MGU9mnOnR558GXunM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BfaBDBHf3swwHL5CF9OZT5ScS7akEOADFomaDxLxtqJzWQ0XHrfkoZvYq2yrRCH8y5W9btX2zKbNIbWgVFdvlWn1nYPGP4tyaEqfOi7Xf5xtwcKlACUAS/zUEEFwZV3w0dkXtqwD+GPijg6a/1V9HgT/HFZYhnk7sj2XAo10ki0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cfoq1KG0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cfoq1KG0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760291875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Utpv+62PaLVyv5NKnoU/rVjv/h2E+smFCvLAYqjlmoA=;
	b=Cfoq1KG0npNtVUDxcodl8JuXzbe3KL0VxsRJrC6l1PJSuxfkqYXIB32P9F3eEp3Vw+ioey
	shT49b7GS71hUzgs4a0wQivU51GWNs6H/2i+pnrFYtdgdaO8BE2ilXRHwQ1UFBI9uzn8RJ
	rW5i25y8Sdbm3WtdLTGVhpKKqaEVaLY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-ve8NIYJBN22xqjtQjS9lhw-1; Sun, 12 Oct 2025 13:57:54 -0400
X-MC-Unique: ve8NIYJBN22xqjtQjS9lhw-1
X-Mimecast-MFC-AGG-ID: ve8NIYJBN22xqjtQjS9lhw_1760291874
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-78f28554393so201935766d6.0
        for <linux-crypto@vger.kernel.org>; Sun, 12 Oct 2025 10:57:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760291874; x=1760896674;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Utpv+62PaLVyv5NKnoU/rVjv/h2E+smFCvLAYqjlmoA=;
        b=NECsIu0BYk+DcSa0HOwJQ1kq7jAJgiV0BUB7VdlixQyrVV+uyWVzQaRrjc5+0LNiGj
         ZjzgHBR7CuK3f/M3NgiKoxayWHshpls44sQYfcjsrGJp4jZkcgALJoTmVXhEofxo/ld4
         Nk9Y8UO3VEXFCNjY0Ibenecy979rRK843du7fxhp7NOYYanLSEE8ycD6FYXQCXH3tMZg
         sN22TtYm2COKCPAHp81wR2Wj3wcw9kEDAb9H++Ft9mQmUU4Nl4MK12SgT0f6CgBAs+aC
         pFjtHMcZOa9juacHQH8RG9oKjTu0aWUaRLHVYeCYDoHo9RBgsXgCNLq1I46iqa3XyN/q
         uvQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfp8zz3RMRI7mTEyyaldM8oOFdSzeTIbj4N1/AuuDo125qAgVsVu/Q/MneIdAKU2UvbCWI8NiWsfewAzA=@vger.kernel.org
X-Gm-Message-State: AOJu0YykyWe26DhmRLp6x1lzS9l6s5fIzd2Eq6A13d5OA40pQrxNFgTJ
	agzOXJx2gUoAhkrzatjmrJHanqg/6KJuDPU815CXdT7VHc8AOU2Fxnj6KHIh3PEJasSL9QQvg00
	NZF8p2W9Z0Wui8P6kmzbXDK3bSVOj5drG/wM5nlndDk5LFLAsoQpo93ZqXpYjDm6ofg==
X-Gm-Gg: ASbGnctLgLDfLjD2xL6UM1TbkGYHc1dRdGeZAYckUmto0cT4MuPkHRueZKspy7ua/2C
	wCFEUcb+extL6Nd3s/Nmj6rglcsWVy/ORgz6FwuXHre3NvCel2sBwtJg/gpTxufAyDnMwrOCcer
	J42pSSY3qY2lX3YQc/Ta6mPEeCdXWnkoo6zFj3RyadgOZYI7PBFRg/gXuzt/NE5JyL7XJBz5mDs
	XhspWTqd9/uhmLhAqyLizDTiPdfuUmylV3nZJALTnF1HMOLLndR/J8icH6cZiwhYooSoDaNy0GE
	sBCydWpD7UwJBmSwyZTDHtkPh7D1mteELgU=
X-Received: by 2002:a05:6214:2509:b0:784:d90f:b6d4 with SMTP id 6a1803df08f44-87b210a04b5mr248144396d6.15.1760291873710;
        Sun, 12 Oct 2025 10:57:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRH5ZhWRFmVNjnioHiad4+NWcgoaERxVtoowq/txkAMolsUyOSG8hqkZjMVwLcygfdVRORpQ==
X-Received: by 2002:a05:6214:2509:b0:784:d90f:b6d4 with SMTP id 6a1803df08f44-87b210a04b5mr248144146d6.15.1760291873265;
        Sun, 12 Oct 2025 10:57:53 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([2603:7000:9400:fe80::318])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87bc347991dsm56107306d6.22.2025.10.12.10.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Oct 2025 10:57:51 -0700 (PDT)
Message-ID: <dae495a93cbcc482f4ca23c3a0d9360a1fd8c3a8.camel@redhat.com>
Subject: Re: [PATCH] nfsd: Use MD5 library instead of crypto_shash
From: Simo Sorce <simo@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>, Jeff Layton <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
 NeilBrown	 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai
 Ngo	 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
 linux-crypto@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Sun, 12 Oct 2025 13:57:50 -0400
In-Reply-To: <20251012170018.GA1609@sol>
References: <20251011185225.155625-1-ebiggers@kernel.org>
	 <582606e8b6699aeacae8ae4dcf9f990b4c0b5210.camel@kernel.org>
	 <20251012170018.GA1609@sol>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2025-10-12 at 10:00 -0700, Eric Biggers wrote:
> On Sun, Oct 12, 2025 at 07:12:26AM -0400, Jeff Layton wrote:
> > On Sat, 2025-10-11 at 11:52 -0700, Eric Biggers wrote:
> > > Update NFSD's support for "legacy client tracking" (which uses MD5) t=
o
> > > use the MD5 library instead of crypto_shash.  This has several benefi=
ts:
> > >=20
> > > - Simpler code.  Notably, much of the error-handling code is no longe=
r
> > >   needed, since the library functions can't fail.
> > >=20
> > > - Improved performance due to reduced overhead.  A microbenchmark of
> > >   nfs4_make_rec_clidname() shows a speedup from 1455 cycles to 425.
> > >=20
> > > - The MD5 code can now safely be built as a loadable module when nfsd=
 is
> > >   built as a loadable module.  (Previously, nfsd forced the MD5 code =
to
> > >   built-in, presumably to work around the unreliablity of the name-ba=
sed
> > >   loading.)  Thus, select MD5 from the tristate option NFSD if
> > >   NFSD_LEGACY_CLIENT_TRACKING, instead of from the bool option NFSD_V=
4.
> > >=20
> > > To preserve the existing behavior of legacy client tracking support
> > > being disabled when the kernel is booted with "fips=3D1", make
> > > nfsd4_legacy_tracking_init() return an error if fips_enabled.  I don'=
t
> > > know if this is truly needed, but it preserves the existing behavior.
> > >=20
> >=20
> > FIPS is pretty draconian about algorithms, AIUI. We're not using MD5 in
> > a cryptographically significant way here, but the FIPS gods won't bless
> > a kernel that uses MD5 at all, so I think it is needed.
>=20
> If it's not being used for a security purpose, then I think you can just
> drop the fips_enabled check.  People are used to the old API where MD5
> was always forbidden when fips_enabled, but it doesn't actually need to
> be that strict.  For this patch I wasn't certain about the use case
> though, so I just opted to preserve the existing behavior for now.  A
> follow-on patch to remove the check could make sense.

It would be nice to move MD5 (and reasonably soon after SHA-1 too) out
of lib/crypto and in some generic hashing utility place because they
are not cryptographic algorithms anymore and nobody should use them as
such.

That said MD5 appears to be used for cryptographic purposes (key/IV
derivation) in ecryptfs (which is pretty bad) and therefore ecryptfs
should be disabled in fips mode regardless (at least until they change
this aspect of the fs).

Specifically for this patch though I do not think you should keep
disabling nfsd4_legacy_tracking_init() in fips mode, as md5 here is not
used in a cryptographic capacity, it is just an identifier that is
easier to index.

Simo.

--=20
Simo Sorce
Distinguished Engineer
RHEL Crypto Team
Red Hat, Inc

