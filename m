Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78FB3BFE4C;
	Wed, 30 Sep 2026 09:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.133.4.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790760454; cv=none; b=kLAueeDR/GpKVrldwZl8VNGPgT3qPj6WEZPyPHPjzzLgiE9VuQgWDXN5a8tVD5mG7RibAP09xSbkWMJyLULUn66QClzirqoMw1Z+kCOKrkj49jUfyNs520v9dADL5KAJWsoLBGzUQAtGoRTs3Tok7glQnZNZqxh24fNARJGyfEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790760454; c=relaxed/simple;
	bh=IUynFr7wZp5avB/alZvLSfG0tvwc0yckvvb2xGTxg/4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Yt+U2EVLHOf3lv4Pc4/vKF4BmMefbgLhvCB3ynuNScq42fO5V9ZXo+MFqZOjwn9bwsAqTCsXHQFpSJMC2EIPNqjWFhguX3ZkmLcHZZ9p7FAQxYsFvHVHXq/TNlPFhCQcCrZOWFOquS8UePMT/aFBXncAc6d/J2AaH1K0dtbfUzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de; spf=pass smtp.mailfrom=zedat.fu-berlin.de; dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b=eidK9XzL; arc=none smtp.client-ip=130.133.4.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zedat.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b="eidK9XzL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=qSVKMmC0VyXgcJFWSutTuF7MsgWbRqaF6wKIawKhf+g=; t=1790760451;
	x=1791365251; b=eidK9XzLvNdgPWjYsfAzDSndhHz5EV6Wuxhv+xfxjEd+7NlsOOlO3b5E4XSW0
	HmJ0Q8U3KC8xeT6utf/cRILyplVKMCYy+JZZ7lm+4qY+5jU4bbtsWN7l9HllB9U0+qczNbpp1m/vp
	Zvdb6A13AdhkL3ikYraqPyklEwv8MOEUGyb1upUjA549+dMaPZCq6w7VvHIqp01BjlKb8lzGAIa7L
	ZHkOOrqG9EMgiUhxsU9+eSipUfYaw3G8AntlOc3fhDO45t1sAtU8fAnrpcnnuFBe70x6yZ6zF9bBj
	gStL/aD7G+ijBFdnHPdjYovyHOGFdWzsvtv9IGwXK9AyrTcjFg==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.100)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1xBqb3-00000002QGV-2B5I; Wed, 30 Sep 2026 11:27:29 +0200
Received: from p5dc55206.dip0.t-ipconnect.de ([93.197.82.6] helo=[192.168.178.61])
          by inpost2.zedat.fu-berlin.de (Exim 4.100)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1xBqb3-00000003ItU-19ck; Wed, 30 Sep 2026 11:27:29 +0200
Message-ID: <3ea57d640ac7409fa37b15ec9e3f49126347e432.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v3] crypto: aes - Fix undesired override of some
 optimized AES modes
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Stian Halseth <stian@itx.no>, Eric Biggers <ebiggers@kernel.org>, 
	linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A
 . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 sparclinux@vger.kernel.org
Date: Wed, 30 Sep 2026 11:27:28 +0200
In-Reply-To: <25c7a7c7bbe3c7f70fca559867e0883b9e4dc48d.camel@itx.no>
References: <20260929222752.36427-1-ebiggers@kernel.org>
		 <322e5255353e3a5f9e3840a496018edd980fb016.camel@itx.no>
		 <1f85bdb9614365fedda81fb649147da48bf7be13.camel@physik.fu-berlin.de>
	 <25c7a7c7bbe3c7f70fca559867e0883b9e4dc48d.camel@itx.no>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-ZEDAT-Hint: PO

Hi Stian,

On Wed, 2026-09-30 at 11:15 +0200, Stian Halseth wrote:
> On Wed, 2026-09-30 at 09:41 +0200, John Paul Adrian Glaubitz wrote:
> >=20
> >=20
> >=20
> > Very nice! Do you know which SPARC CPUs support these instructions?
> >=20
> > Adrian
> >=20
>=20
> SPARC T4 or later.

OK, thanks.

> The T2 and T3 has a separate crypto unit, but not supported here.=20
> Support was removed from the kernel in 6.14. Haven't tested it, as I
> don't have the hardware.

Why was it removed? I'm not happy about such removals as long as the
hardware is supported.

> Also worth noting, it's only used when the firmware lists the machine
> description's hwcap-list and the CFR has its bit set.=20

Is that not the case by default?

> I have no idea about Fujitsu's SPARC64 X family.

I think SPARC64 X is not supported by the Linux kernel at all, is it?

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
