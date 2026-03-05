Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A5F344020
	for <linux-crypto@vger.kernel.org>; Thu,  5 Mar 2026 22:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772748728; cv=none; b=iYRzLv8CyiTJwb3dEQ+MwD/8fuVMRujQ1ntdnmVT0u0syRa5eJ/Hma1flrCs8ZQYp9nd7S9PBga9Ak3o3SCQoHxXQ6pvJIZcpMhoUswc4orIxEWAszwrBdvwBXPRZzTw0XD7dTsoW536YrD8fQa2xOIDiptRw6D/G6YpxD/bBCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772748728; c=relaxed/simple;
	bh=a3D8lUKExNlE1ycDySQ3rwo+Tpc/BIuq9fcuNQAtidI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NxsUk3LsjU5/nUaiCOcJ3zbW6uSYs5CQttk/DueYd3UKHw7YzzVUU07S7PfpH377BItR2FWDgwgy08RWl7IUzyMUkeearuFuhzv319geT71atdBYkpXT4NFi5JXIny9SHwU/imgc5r3JIetfhwovNjyRF2uYhl83fvODPXlHNck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=hTCmAwIC; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="hTCmAwIC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1772748726;
	bh=a3D8lUKExNlE1ycDySQ3rwo+Tpc/BIuq9fcuNQAtidI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=hTCmAwIC+Bw99b4zyaPql7Mqf3gNcelsIJtf+XejmyesS+xFBgW1lrBPfPCCvzheh
	 5D+reCYDnF2H5eHWJ1KNO3lRchkSdj81zQQI8C2lBmp/fX2n06zWyXsO/Yj8T+v7Z6
	 MKk9dbw3iMHn0yRcUKP2VvsbMla9+VtPu3kSsgY8=
Received: from [172.19.0.240] (unknown [75.104.94.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id E81E51C005E;
	Thu, 05 Mar 2026 17:11:57 -0500 (EST)
Message-ID: <02c4b329ecee56979631e832906ff77948aa3176.camel@HansenPartnership.com>
Subject: Re: [PATCH v3 0/5] pkcs7: better handling of signed attributes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Date: Thu, 05 Mar 2026 17:11:47 -0500
In-Reply-To: <20260305214014.GB64054@quark>
References: <20260225211907.7368-1-James.Bottomley@HansenPartnership.com>
	 <20260226021331.GA55502@quark>
	 <3900433c727c1e7ab6e131003de7ca53bb0d23d1.camel@HansenPartnership.com>
	 <20260305075511.GA155793@sol>
	 <ba545f3db317ba3410b8fb9f5bab9e72be1854b6.camel@HansenPartnership.com>
	 <20260305185156.GD2796@quark>
	 <124016e6aa10434b73391cdccd95c69242f8e4de.camel@HansenPartnership.com>
	 <20260305214014.GB64054@quark>
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-03-05 at 13:40 -0800, Eric Biggers wrote:
> On Thu, Mar 05, 2026 at 03:18:09PM -0500, James Bottomley wrote:
> > On Thu, 2026-03-05 at 10:51 -0800, Eric Biggers wrote:
> > > On Thu, Mar 05, 2026 at 09:46:42AM -0500, James Bottomley wrote:
> > > > On Wed, 2026-03-04 at 23:55 -0800, Eric Biggers wrote:
> > > > > On Thu, Feb 26, 2026 at 07:43:54AM -0500, James Bottomley
> > > > > wrote:
> > > > > > > If this is for some out-of-tree module, we don't do that.
> > > > > > >=20
> > > > > > > I'll also note that we should generally be aiming to
> > > > > > > simplify the PKCS#7 signature verification code, not
> > > > > > > making it even more complex.
> > > > > >=20
> > > > > > I'm fine with the general goal, but since the current code
> > > > > > verifies the signature, pulls out the message hash and
> > > > > > other attributes, compares the message against the
> > > > > > MessageDigest one and then frees the whole structure it's a
> > > > > > bit hard to see how the current goal can be achieved
> > > > > > without extracting at least the first part of that
> > > > > > ... but if you have=C2=A0=C2=A0 suggestion, I'm happy to implem=
ent.
> > > > >=20
> > > > > Sure, just incorporate your auxiliary data into the actual
> > > > > message being signed and verified.=C2=A0 Something like:
> > > > > =C2=A0=C2=A0=C2=A0=20
> > > > > =C2=A0=C2=A0=C2=A0 program_len || program || hash*
> > > >=20
> > > > We can't do that because the second hash is for the LSM.=C2=A0 If
> > > > there's no LSM then we need the signature to pass the current
> > > > eBPF signature check because the second hash will be verified
> > > > by the loader, which means the program hash and nothing else
> > > > must be in the messageDigest attr.
> > > >=20
> > >=20
> > > Why does the loader need to verify the signature if the kernel
> > > has to do it anyway, and why does the loader need to skip
> > > verifying the maps?
> >=20
> > Well, I didn't say kernel, I said LSM.=C2=A0 The problem is that the
> > last hook in the LSM chain for eBPF loading occurs before the
> > loader has actually run.=C2=A0 This means that either the LSM needs to
> > be assured verification will complete (by running it itself), which
> > is what the patch set I pointed to does; or that we need an
> > additional verification hook in eBPF somewhere in the verifier
> > after the loader has run, which the eBPF people are looking at but
> > haven't actually found anything
> > yet.
> >=20
> > The OID helps the LSM do the additional verification without
> > changing any of the eBPF loading flow.
>=20
> LSMs are part of the kernel.

They are, but they're policy driven.  The policy could be anything
including don't bother calling the LSM.

> Not sure I follow.=C2=A0 How can the kernel verify something before it's
> been loaded into the kernel?

There's a disconnect somewhere but I'm not sure where. The eBPF code is
loaded into the kernel and eBPF will have verified the signature over
the loader component of the light skeleton before the hook is called,
but the loader won't verify the actual program until it runs, which
will happen after the hook is called.

Regards,

James

