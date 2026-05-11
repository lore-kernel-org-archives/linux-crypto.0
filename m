Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFF01DFF0
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2026 00:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778457756; cv=pass; b=P9E4+G0hu8AtDtImd2jBRBsTRoqsmPdx6Z48m7YzH8HdEP6R8ewfr+uz3+0UoUeFGnJOGUsmQvOFePwLAZHosOqja6aGetT9qokxgHvif0PAuqCesfBpZUi5Nt2GEj7ml7AEWqKBp5ZuQpb3b47S4pdtEsQxvXokX4//YKSVz1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778457756; c=relaxed/simple;
	bh=lCNRQr0NhFXKY/gNVPTEx/eS9wXBEjrxYSbYRfQAtuY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tCeA2pWbNglywtwCJSwKB0F8n9u93U7VwrwXNvC8aAjtrgs5Y1H8FzkynmTHahgajrYqfzvw0nR2V1RoeN59ibcq9nzpF0YaxfSDMZs2nhjh2KauOUHp9WwZagf/i3XmEmlYosIvRFTzh+IjhT3Dcx0ErMkPw6ZQ/XsnbZ1WCVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QPMdA336; arc=pass smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QPMdA336"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-7c23248f3a3so5786957b3.1
        for <linux-crypto@vger.kernel.org>; Sun, 10 May 2026 17:02:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778457754; cv=none;
        d=google.com; s=arc-20240605;
        b=Tt4Lh6j8rvslKsAAb+mF5seDWQVqVz5D7wHFrme75+kidPtjfikDIjWA349zd0/xT0
         GC7raIrdJDdqNsBEEWmAc7otEQNpwLZPTFmJrxmaIX0IuL0lI0ZoFCvfAlJBjC5uMGp8
         TnQgkZP71m+Xa4dOBF5kvIjk3J83izl/l+erXyVdlGfvz8ydYwujUrvUmJ+M8AdqcdmQ
         wzykhIe2eHgrrnFPpS3KfNgRUysdclQLJsPUYoLJqBfsz75HIbB2Pi531n/yDhB26CTt
         tCE9rtsxSne/VnDCzS+qjelLkERhoeu1CCQhx53QmMt/q5HGjifJJmU3GGnt2/diaCk0
         X1AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nG8iesjaX2FxgWRTnqvql7kCVq7juvkfiba8tfPOt+w=;
        fh=mhhqgkaRL19oLp3X/0nG0WDssU7BvoicLCbY0lecK2g=;
        b=V8LDP9iNLXLzRMQ6U/SPgKvLIckZRbwtAZCiBbkgJfG5l0uLS+aJ72S6Pv5Te/TZbQ
         M0sNVmJjZ2OAUD+xsrQa1vq6hR59sLTP/dMGknUhF1H6Q32cSGDbdJdKEX7Hn3d+twks
         c4krtMw44sf3ngw/xZHP1Yr2+RnFKI2ipL9fH3DC/kuLQh44B2MQpnpp+J0j20IeneQ9
         /aJ3pUvBdIyWNaAaRSqXyaapgWjZrbXxiy0ZDaf6K3nEjYfrhAOv/3EaHnsnGuzf0lJF
         +1Wd22KRLSanOk2Sf5+F7vxLb4QWVXt7OgQyqxCXyWqy+481bp+zESs++P/msb3xtO8s
         ttUg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778457754; x=1779062554; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nG8iesjaX2FxgWRTnqvql7kCVq7juvkfiba8tfPOt+w=;
        b=QPMdA336BqBI2cpSyafom+aPAQsNPCwdMCpCudEjCt4Ipoy/iujN7VyATRwAisSbz0
         ow962AA3AquroSb1LZvmF0bkyiJIFSbwoKPJjJVcRifHGY7n3f5k4JXg8UPpebUJw6vj
         +kWi7WSp6EbTEpkyciiiJ9pU3gQEjrI5zMckJrfkIfuplEhPo82+jV+yE/IBXKHAq1S4
         cI046HYx3bzG3+jVmslMwbnPjmhgtoZT6mH+5vs9v6aIOkFCrmHNEwLGDxQCvmliLrbs
         ZahS786bBzyyZUpd+lYmnMJP8Y7sz1Tkx9yuJJ6qGnToMKIyuuotEjhlSCkLGpY42fwb
         iaJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778457754; x=1779062554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nG8iesjaX2FxgWRTnqvql7kCVq7juvkfiba8tfPOt+w=;
        b=Zi5a0sMKrxj6RrvHGqCALPdmFGr7yDoaLAzRxN3OykG0HSYmDpJVwPVFxQihwhRHUH
         KrThdUbyNPJu8jgjuzrM8UF6HzdeZ/H2MjLqxXF90sln74P+9iDyLdV9lHw7EvCgMqPF
         f7mxQNkM3hb50d+C7E7sXoJoV2M7Vzpc4IpYXY4kBs+rDRC9NDSt503Ajgf4G7t0Gz0L
         p2ew0ZA7Y+9ah5oUJB1vOCroAvSTeQBTWfyiHwOyoMFmoM/KUhKXyGIhEXHtqeils/hH
         GdeTASC++jHfJ6lXPdd6s99RHw3GfFb1mlJhuXallQUlFsDBxwsi5mR8huLrUlCiM9/D
         Vr+w==
X-Forwarded-Encrypted: i=1; AFNElJ9bBlzye6I0OU9vTDlTgRBA/DXAAbBqk0YXXcResdWKXNY3rQEMd83AprUW0kQBs5992m2DnjIvASF9oHo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcm61u7c9Nb+vAZrFVAUZg6CLmB50a8m/egxna5ZmyMZ/cpU5o
	voai0Y2LymBki5BaiZagDuco7Q+tCDhFxLRmk9pJyf9nQEtAlaKrVmfmnHzCvqQALVpG3IcBqes
	bXTwewXpkXtSVc1a5Cr5VH8pviTbVzLo=
X-Gm-Gg: Acq92OEZzqjJ9tL2V3odHRziI+WMYIQg4Kb4JqohDnwVaEJmwXGMWbhrJyu4/rkpZ0d
	q+GFbFrotYTdgkacda3QoecrB8nwSbHJK+GhGKzsvdgnaaFwTIoJbv1a7FYQfQL0D2OZVXCtbmT
	ARzWKl2idkutfxRN13J7WGpnBkRbtrzrUy0Y1OEVLMRaAoCtMj2gIs+KgBgByXIK7VVwqFP+BU7
	azQpgk1edhdsYDPIwOK8rFayNzUHHp70Jx8MML388HP/ZG7gj1jCtZER8W7Q5QAui7ehdVNIFpa
	+nAkJG4VMPu5JqfHLXsCoEt/6GBLNP83tXHIOrhs25WcNN0fSndO
X-Received: by 2002:a05:690c:5c0f:b0:7b4:b591:e79a with SMTP id
 00721157ae682-7bdf5dc4fe8mr206135947b3.14.1778457753775; Sun, 10 May 2026
 17:02:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260510230901.1772949-1-knecht.alexandre@gmail.com>
 <20260510233237.GA60510@quark> <20260510234452.GB60510@quark>
In-Reply-To: <20260510234452.GB60510@quark>
From: Alexandre Knecht <knecht.alexandre@gmail.com>
Date: Mon, 11 May 2026 02:02:22 +0200
X-Gm-Features: AVHnY4I30POVnMQFoSEd9M_3dMBo7zsyfwDX1xDUD32wHkKwf8MkuBfyUfKqVaU
Message-ID: <CAHAB8Wy1APeCcm7_OfrNYeZFcMXfZ5rUSeDX7-c7WO_rGg2Zig@mail.gmail.com>
Subject: Re: [PATCH] crypto: ctr - Convert from skcipher to lskcipher
To: Eric Biggers <ebiggers@kernel.org>
Cc: herbert@gondor.apana.org.au, "David S . Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lun. 11 mai 2026 =C3=A0 01:44, Eric Biggers <ebiggers@kernel.org> a =C3=
=A9crit :
> Also note that lskcipher doesn't provide access to the accelerated AES
> mode implementations.  Indeed, almost nothing is supported by lskcipher.
> The fact that you found something to be missing isn't surprising.
>
> I think "lskcipher" is kind of a dead end, to be honest.  It's not clear
> why it got added.  The path forwards is to get the AES encryption modes
> added to lib/crypto/ and to just use that instead.
>
> - Eric

Hi Eric,

Thanks for the review =E2=80=94 you're asking the right questions.

I'm developing a VXLAN/EVPN-based CNI for Kubernetes (releasing in the
coming months), and the goal is to implement datapath encryption for
overlay traffic in a zero-trust datacenter model. The encryption
happens in BPF programs attached via TC on the VXLAN device (encrypt
inner frames on egress, decrypt on ingress).

The algorithm I actually need is AES-GCM (authenticated encryption of
VXLAN inner frames, with the outer headers as AAD). When I looked at
bpf_crypto, I found that:

1. Only lskcipher ("skcipher" type) was implemented
2. ecb(aes) was the only usable algorithm
3. AEAD support was designed for (authsize field exists in
 bpf_crypto_params, setauthsize in bpf_crypto_type) but never
 implemented
4. ctr(aes) wasn't available as lskcipher either

I looked at Herbert's history converting ECB and CBC to lskcipher and
assumed that was the path forward for CTR. But you're right, the
real goal is AEAD, not CTR. CTR alone doesn't give me integrity.

Your point about lib/crypto/ is interesting. If there's a path to
expose AES-GCM (or the building blocks) as direct library calls that
BPF programs in TC/XDP could use (avoiding the template/instance
machinery and getting hardware acceleration) that would be ideal for
this use case.

What would that look like? Is there existing lib/crypto/ work for
AES-GCM that could be wired up to BPF, or would that need to be
built?

Thanks,
Alexandre
