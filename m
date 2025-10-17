Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9292765E3
	for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 16:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760717593; cv=none; b=OhXgiYfh6Fdivb279nup8vHS6WsnQMuYvDp6OfFl3yhNgeM1i3RWNdHPffPYTxSudfd/DDGFI3B9cBAh9QMzNG0EgBdkVOKhr8xFuf855GnWzUzcn8MVpADTvDypAfNOGuRwEAHMKpRQPbnIvrqYwGgcfI/spYeCu4QgXeco0Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760717593; c=relaxed/simple;
	bh=CnVPB18gPnV0y9ydniAaFgQyj2ZP563th4cx24bDyPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CuICODfgFrekX6YQhddFR2GLVshWlLZd10KHQRotMP6KhJAx5vOkymHcE24CEwrReHtAKzRY0DKWw4q/QqTkaIRMnuMUIXQlFAgKDnJY9RVqLUMz43A4DwKUhr6T+oNCQ3oGmtZx+W7gmRu27wZO48uAOZLKMi2abqI27/Er4+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MzHGJsGj; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MzHGJsGj"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-87bf3d1e7faso43349676d6.3
        for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 09:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760717591; x=1761322391; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OjQetjKtP2N8ZnKgF+/VCDLQar2SjrRhN3JEU0v7jTQ=;
        b=MzHGJsGjNV1JV3wGAKcsS2PxBVcwkQusFZfcAiOHZ5DpzSSzA3nS04Y87o0PPcZTzg
         lDP720A4Yv3n/OChsM09aQ349V2cZ9VHe4qKU+r7Xn3w6MxIMj5bIucjk8SyHeqJ84o2
         WX5YJYBhR7Ku5rwC9WmPTp2JkBc5Hb/DGepUOayk2j93vDewXbF7fRscUkYs890yuBhY
         AI/TBsgp94vqXcAbEELAPxUC/ezH0q1eugyjzjDKJEqnsq3C9q5EZW4x07Oeokq+8Yoa
         DLDrnGVZwntOoTeYGP+nd64VGdV1rx4Os5qy793ZBVqr/QYNJoxgFOeF5+j8ieKKrKAX
         88yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760717591; x=1761322391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OjQetjKtP2N8ZnKgF+/VCDLQar2SjrRhN3JEU0v7jTQ=;
        b=LbEYJV0S/m5xR6EoqbvAfhHcdlhbgT6Uwqjno2kGS0Ud5C6+Siy+64LD9zoPpaqUio
         hTP9EbNGkvL5prkBSESkDCg8IlCVNheaIQaDeHbt4wwUI5W7n+3lSm+wQwiYGUDGDSw2
         y+Z0Cdw+LQioDfLg8pBJfC3Htko1Wb3wLgvFtKQH3WYSuGGq2sOD0rka5lIvC84vDCsl
         5OL54MjrFIdSq3A0rI5HcNReYQRnDORwb2iEyvnSShfpopbWYLpljbcaDm0qsH+2yVSR
         IR5MsxrgZBwgDrnP17IA5pLda2iDFHs1ELCGqPn03wYUi3ngcCCoadG6tD1gos5+jDWJ
         OPFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgMLwA/9F5Pmkjf4iZd0keJzy5MAtsa6LoNG1PvX2LgQn1T0T4PxT5Y68MVagS+pTl3lIkmh7N7d6fKGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yztfv5VG94LPK2Bvhnq0vBTnFzuGn9Vp5t58MHTnA8AEe0HTtCJ
	coDqLsQtxvTGYvQ3f6wJvm4yImU6UD6nZlLxd8JxqSvXrMSMT9wrT74ctlPxZzh/XZSiBbl+2Os
	d6CSP7GtnaoJeylbIZZyGCTANRR3wssQ=
X-Gm-Gg: ASbGnct8nWaCVNn+BLA8jvCynJZvb6bXlhXoelkX9rdqumQE+0qObTqS4eRhDoZ0E+0
	eeguayGEv8Z5vG9P3LmvpxE4IPcHdZgMCSKceOVmfHgt7celgr2Vwt/tNdEJgRC2grzmJSLK85a
	epeHfpIlIcc/yCxw6abfrDXEjEqa/ovBjxtd4W2bqSFHuj/IeXMiNZ71ETAZ7FaeIUsFDIKjkIK
	fBztzbyAkQ19I+fRYlzk/kddGcrlpg2QEEjYE/Qw11Mw2qmIx67/sg9nH4k8q158HE1LRhjcj51
	WLvpfxY+z6ru32eSVlaQAoPK/cDudhU2EAvr3tP32gspFx8hW8pKinyxegK7Q5OtzFNujd3CySN
	kr8SZcWa44GucDIvKsumOmteYQd7dDuKrSQ7UWKML3xfphH/8ZbSr1AGYMRpk612Jg7sYP6Z0qa
	W/+pUWmCT3AA==
X-Google-Smtp-Source: AGHT+IFPgj/3I5wJOFrTttsDELhaFe1s9tLyKiAelB1Q4yJlww5/YuKcX8nISL32dOO4767+pyotyXgt7BP+A21mluA=
X-Received: by 2002:a05:6214:27e7:b0:87c:1f80:7609 with SMTP id
 6a1803df08f44-87c2063722cmr64935006d6.34.1760717590567; Fri, 17 Oct 2025
 09:13:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251012015738.244315-1-ebiggers@kernel.org> <20251014034230.GC2763@sol>
In-Reply-To: <20251014034230.GC2763@sol>
From: Steve French <smfrench@gmail.com>
Date: Fri, 17 Oct 2025 11:12:58 -0500
X-Gm-Features: AS18NWAXgy1nFdCK093JcuNsEH8SVWOSU1ZaVUWkdPUWnKyCsTrh62MZCh2lBYs
Message-ID: <CAH2r5mtPp6yGFHipzQ6A+6Yi0FZjWZa=T=CrtALc4o6TGqF8EA@mail.gmail.com>
Subject: Re: [PATCH 0/8] smb: client: More crypto library conversions
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, 
	samba-technical@lists.samba.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> with SMB 1.0 I get "CIFS: VFS: SMB signature verification
> returned error =3D -13",

If testing SMB1 to Samba the server disabled signing unless I set
  "server signing =3D mandatory"
in smb.conf.  But with that, signing with your patches worked fine even to =
SMB1

Were you testing to Samba with SMB1?

On Mon, Oct 13, 2025 at 10:44=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> On Sat, Oct 11, 2025 at 06:57:30PM -0700, Eric Biggers wrote:
> > This series converts fs/smb/client/ to access SHA-512, HMAC-SHA256, MD5=
,
> > and HMAC-MD5 using the library APIs instead of crypto_shash.
> >
> > This simplifies the code significantly.  It also slightly improves
> > performance, as it eliminates unnecessary overhead.
> >
> > Tested with Samba with all SMB versions, with mfsymlinks in the mount
> > options, 'server min protocol =3D NT1' and 'server signing =3D required=
' in
> > smb.conf, and doing a simple file data and symlink verification test.
> > That seems to cover all the modified code paths.
> >
> > However, with SMB 1.0 I get "CIFS: VFS: SMB signature verification
> > returned error =3D -13", regardless of whether this series is applied o=
r
> > not.  Presumably, testing that case requires some other setting I
> > couldn't find.
> >
> > Regardless, these are straightforward conversions and all the actual
> > crypto is exactly the same as before, as far as I can tell.
> >
> > Eric Biggers (8):
> >   smb: client: Use SHA-512 library for SMB3.1.1 preauth hash
> >   smb: client: Use HMAC-SHA256 library for key generation
> >   smb: client: Use HMAC-SHA256 library for SMB2 signature calculation
> >   smb: client: Use MD5 library for M-F symlink hashing
> >   smb: client: Use MD5 library for SMB1 signature calculation
> >   smb: client: Use HMAC-MD5 library for NTLMv2
> >   smb: client: Remove obsolete crypto_shash allocations
> >   smb: client: Consolidate cmac(aes) shash allocation
>
> As requested off-list, here are some (micro)benchmark results for this
> series.  The CPU was AMD Ryzen 9 9950X.  The server was Samba running on
> localhost.  Message signing was enabled.  A valid username and password
> were given in the mount options.  The "Improvement" column is the
> percent change in throughput (reciprocal cycles):
>
>            Microbenchmark               Before      After   Improvement
>            =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D               =3D=
=3D=3D=3D=3D=3D      =3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>     1. Total cycles spent in             44548      20081      122%
>     smb311_update_preauth_hash()
>     during SMB 3.1.1 mount
>     (4 calls total)
>
>     2. setup_ntlmv2_rsp() cycles         31777      22231       43%
>
>     3. Total cycles spent in             17802      22876      -22%
>     generate_key()
>     during SMB 3.1.1 mount
>     (3 calls total)
>
>     4. Total cycles spent in            205110      87204      135%
>     smb2_calc_signature()
>     during SMB 2.0 mount
>     (26 calls & 3316 bytes total)
>
>     5. Total cycles spent in          22689767   21043125        8%
>     smb2_calc_signature()
>     reading 10MB file using SMB 2.0
>     (316 calls & 10031077 bytes total)
>
>     6. Total cycles spent in             56803      37840       50%
>     cifs_calc_signature()
>     during SMB 1.0 mount
>     (18 calls & 1551 bytes total)
>
>     7. Total cycles spent in          52669066   51974573        1%
>     cifs_calc_signature()
>     reading 10MB file using SMB 1.0
>     (336 calls & 10021426 bytes total)
>
>     8. parse_mf_symlink() cycles          7654       4902       56%
>
> Note: case 3 regressed because the "cmac(aes)" allocation moved from
> smb311_update_preauth_hash (case 1) to generate_key (case 3).  Excluding
> that allocation, generate_key got faster.  Likewise, the sum of cases 1,
> 2, and 3 (which all occurred at mount time) got faster.
>
> There was a greater speedup in signature calculation than I expected.
> It's probably because many SMB messages are short (especially the ones
> exchanged at mount time), and also because the old code allocated new
> crypto_shash objects more frequently than I had thought.  The SMB 2.0
> code allocated a new "hmac(sha256)" crypto_shash for every other message
> signed.  That overhead is all gone after switching to the library.
>
> TLDR: all SMB crypto calculations (SHA-512, HMAC-SHA256, MD5, HMAC-MD5)
> affected by this series are faster now.  The library APIs fix the
> unnecessary overhead that the traditional crypto API has.  Of course,
> it's also a lot easier to use as well.
>
> - Eric
>


--=20
Thanks,

Steve
