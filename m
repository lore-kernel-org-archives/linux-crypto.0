Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795649490;
	b=203J3/rn2Ktytds7Td8Ltw/95pBkiSxOq2O7Ii6sEe/+cRaXh5qxylBaToGL8u7+hNMj
	 g6adNQlCjnrkmUQ5LIedhaGpzfcQ6uesdWd6V6TonJwdzIbBkfQ2I5JpP8EmGHKApC64k
	 ZG/fTU4/PF0VlPrYvNpZ2MrZpGJUMropY/WY2ugUY8G+5rsq2WhDzhyQ2GU97lN3vHpRL
	 papxdyKecY4UP8HgdYoSj6IzTmSU4vR+dlnS7aYmBrEhg/ua+ZUbjBQjKsH+qVntDXFhe
	 4EuN0L8Qu4yPy9GCbfE70JfGf2GDlJt5ecW/bIud9hZOFNjD+CWrrnrQtJHTO5M3piw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795649490;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=M9jt0xTLUvSAurUgZtDu7qTIVwa69OLXA/tldQ3fCNs=;
	b=WI2GE3ji0yK/c0ZFTdK4R0CU4Zgm5UozftwzGBLwaSp0hpcDTLOjLZWBqUAvXf2At8px
	 vzauZrzMRCCCJALUJTmUfjvgWPPpyDcXeRaBsMjWyRRVT/a6iYHVQA2fKUgIVmtkKbEj6
	 Sxrw9uwGgUrLuE6npt09EAi5VjiUAfcYqqoQGkDLZihhfQZU9lp87HxjSeoknvdjh22OP
	 Pkx0fBqj1OB3y1QsPhlMXfl1MQ0NwCykwMZ+HdVuO6nwHJbjqXeBpgkAbNIpcbnKbfBlo
	 nO4SiAHP2PttnQ5SRFr2CFfmgN0/i3HYIv7+ZNQGrg0o2DmM/w7h3r8rM4aS/2JNq6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=rF1YZ84Q;
	arc=none smtp.remote-ip=109.224.244.16
Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BA2606A334;
	Wed, 25 Nov 2026 23:31:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91BA2606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=rF1YZ84Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1795649487; x=1795908687;
	bh=M9jt0xTLUvSAurUgZtDu7qTIVwa69OLXA/tldQ3fCNs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=rF1YZ84QxtSvcYgqwzgjRChz2ITRlqguSUKaSr/v7VyI0yjTBGXxcR8CVmxYCc2kw
	 Z/CxV2ZtaY0d5Yy4k5PupjYDbnYg0PSxddtqulCkWQkjQ8FyOuE6vLyF/xCk06vec+
	 BzhfqR9PjpxWIHrif33jTNGfnY0FaXNqniANcS6pnH41dIgNHtV8ERH02P5mb3VXz2
	 JVizQKAKE2GySP+0XP9TZyN2pzz/MEQNrkVbCYFk5zMLm2/gnpo7gZ8O5ZTiC5QdUi
	 P+25dm3P+T9GxHFXL62/dGeKw4IOpvAhJ1I+x/os2nGZZ4TtlrlHToTxNsw1pE+XcM
	 lacrNDD+MXlpg==
Date: Wed, 25 Nov 2026 23:31:22 +0000
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
From: rc4d5a <rc4d5a@protonmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, qat-linux@intel.com, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: qat - fix missing DH public key validation
Message-ID: <tT7gYh4kIL-ei963TMmmwD3a-gwm-4tv7Nc3eWTXtQLblkGFFYUOhkOWBXsB-t5yckRFpCGbXHzhlYyCJVDMau43TzIQkS_jc1G_MoCtwn0=@protonmail.com>
In-Reply-To: <awcjJ8/jvscOuCLl@gcabiddu-mobl.ger.corp.intel.com>
References: <20261124141238.1743680-1-rc4d5a@protonmail.com> <awcjJ8/jvscOuCLl@gcabiddu-mobl.ger.corp.intel.com>
Feedback-ID: 190731814:user:proton
X-Pm-Message-ID: 19ebbeea2f28ca6b6a58ee4cb4e5cf57138020d1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I agree, fixed and sent as a separate patch, "crypto: dh - add shared DH pu=
blic key range check", exporting crypto_dh_pubkey_in_range() from crypto/dh=
_helper.c and declaring it in dh.h. The QAT fix is now v3 and HPRE's is now=
 v4, both calling that instead of carrying their own copy of the same range=
 check. Each driver still does its own zero-padding and (p - 1) computation=
, since that part depends on how each already has the data; only the actual=
 comparison was duplicated, so that's the part that moved.

The generic software "dh" implementation (crypto/dh.c) had the same
gap: dh_is_pubkey_valid() returned 0 immediately whenever fips_enabled was =
false, so a non-FIPS kernel never checked the peer's value there either. Se=
nt a separate patch for that too, "crypto: dh - fix missing DH public key v=
alidation on non-FIPS kernels": it tightens the existing range check from y=
 < p to y <=3D p - 2 (the y < p shortcut relied on the FIPS-only y^q mod p =
test to reject p - 1) and runs it before the FIPS gate instead of behind it=
, so it's a complete check on its own regardless of mode. The y^q mod p che=
ck stays FIPS-only, unchanged.

Thanks,
Ryan



On Wednesday, November 25th, 2026 at 7:04 PM, Giovanni Cabiddu <giovanni.ca=
biddu@intel.com> wrote:

> On Tue, Nov 24, 2026 at 02:12:54PM +0000, Ryan Prinz wrote:
> > qat_dh_compute_value() passes the peer's DH public value into the
> > hardware queue without checking it. The only checks on req->src are
> > on length (req->src_len > ctx->p_size); never on the value itself.
> >
> > crypto/dh.c's dh_is_pubkey_valid() is the generic software check for
> > this: it rejects a value outside [2, p-2], but only when FIPS mode
> > is enabled, and only for callers using the software implementation.
> > QAT's hardware path has no equivalent check in either mode.
> >
> > QAT registers "dh" at cra_priority 1000, versus the generic software
> > implementation's 100, so any caller requesting "dh" gets this
> > unvalidated path whenever a QAT device is present and the requested
> > modulus size (1536/2048/3072/4096 bits) is one QAT supports;
> > qat_dh_set_secret() only falls back to software for sizes outside
> > that set.
> Would it make sense to have a provider-independent check for the public
> key in crypto/dh_helper.c instead?
>=20
> This way, software DH, QAT and HiSilicon HPRE, which all register "dh",
> could use the same check (regardless of FIPS mode).
>=20
> Thanks,
>=20
> --
> Giovanni
> 
