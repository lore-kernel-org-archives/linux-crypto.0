Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6077D2BDC32;
	Mon, 23 Mar 2026 05:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.133.4.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774245541; cv=none; b=mC2iEWLShVW/b2mqNnf0glxNlpFE8tqZJME3Bt2LhL9Al3ONR1sXMg3rONqWMBZv8afv+E0o67WC1zYZimEkKLNDkoq+/598Qh1kJw4IyVx8jWJxWUCciumqWnjFhLWKgWqyTrIIQTCpazkuJidlBYmE/KAlrjr9ZGqoLpmsk04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774245541; c=relaxed/simple;
	bh=Vg/xBF3NXYGQ+zrAZqIBO337o96acGFvhStDZAgTD28=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zm13IONp7W5EGAz7uhqo2/7drE9ppdPS9OCVzkWkHUCEauXqk3dSXcp5aebuQty8fLd5yyvbEH6yf0/5uoYBv3vDNhR9wx9GRpAzltIBN/clGQgGvosavRiMyrnE+9WQtIeItYegbtzVPB+H3NwpDzDcur+NCbM65vXUvlZ9MUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de; spf=pass smtp.mailfrom=zedat.fu-berlin.de; dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b=R559Z5WY; arc=none smtp.client-ip=130.133.4.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zedat.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b="R559Z5WY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=ID/+fzubTHmX9ksTAeRtaR4gUCuxD/4KgWX680S959s=; t=1774245538;
	x=1774850338; b=R559Z5WYQuug+JyiF3Vj6NoPXBzpxf+8pXBq+RBXXuEvjhjM37kEE5qFgG+CS
	MP8GpdEcBFD+nzJndHhYRk8JwoSqy06jwPsA5eH9lrJCrb5zyLK6d63ArR/5RbZ1LmUUab871lkHi
	rQbqefBPehG3i/hCh2Gfon+tZuxvT3oUke/yl+X2FlRHG4dbYrMfxyIVPHzFt1j2P17cKEJO/uXMP
	HLMNJ+VC+v3/hSNGe5SuNgLLg8WGGi69/S348zI2csiuTtuPw327q6tqHFHje4lB/e+6FfGNnkkAt
	rIyAJ5qQIfdsMgNoljIlGm+RT2uJFM3FVQj056X21rSViPaUNA==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.99)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1w4YJJ-000000019kX-2MEI; Mon, 23 Mar 2026 06:58:45 +0100
Received: from p5dc55f29.dip0.t-ipconnect.de ([93.197.95.41] helo=[192.168.178.61])
          by inpost2.zedat.fu-berlin.de (Exim 4.99)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1w4YJJ-000000007dU-1PSn; Mon, 23 Mar 2026 06:58:45 +0100
Message-ID: <5e284a6fa72c2fed6690f91e5f4079b6d339efb3.camel@physik.fu-berlin.de>
Subject: Re: Does the SPARC optimized crypto and CRC code actually work?
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, Nathaniel Roach <nroach44@nroach44.id.au>,
  Andreas Larsson <andreas@gaisler.com>, "David S. Miller"
 <davem@davemloft.net>, sparclinux@vger.kernel.org, 
	linux-crypto@vger.kernel.org
Date: Mon, 23 Mar 2026 06:58:44 +0100
In-Reply-To: <20260322145942.GC2183@quark>
References: <20260316204211.GA2661@quark>
	 <ca9ba2ec-849c-4f86-8ac9-274ac4b5f885@nroach44.id.au>
	 <20260317034539.GA2705965@google.com>
	 <76ed4ac4c86341c5c9168aeee8cd53566e018001.camel@physik.fu-berlin.de>
	 <20260317140646.GC53921@macsyma-wired.lan>
	 <079d287944ffe94903286ea73fc1df167206321a.camel@physik.fu-berlin.de>
	 <20260322145942.GC2183@quark>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-ZEDAT-Hint: PO

Hi Eric,

On Sun, 2026-03-22 at 07:59 -0700, Eric Biggers wrote:
> On Tue, Mar 17, 2026 at 03:14:50PM +0100, John Paul Adrian Glaubitz wrote=
:
> > Hi Ted,
> >=20
> > On Tue, 2026-03-17 at 10:06 -0400, Theodore Tso wrote:
> > > How hard would it be to add support for the Sparc crypto accleration
> > > opcodes to QEMU?  Is that something that could be, say, an GSOC or
> > > Outreachy project?
> >=20
> > Good idea. I'll ask someone who has been mentoring QEMU enhancements in=
 the past.
> >=20
> > Adrian
>=20
> FYI, I filed https://github.com/sparclinux/issues/issues/77

That's a very well crafted bug report! I appreciate the effort and will try=
 to reach
out to the QEMU people and see if we can get something done within GSoC.

@Nathanial: Can you run the crypto tests and report back?

Thanks,
Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
