Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E778436377
	for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 06:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791787538; cv=none; b=Sx4WZ8UVlnq4ovwOtpzT+F8fqN4Ed3caif3zTwKhl+92h1jdV+gQWJRA9x46NhRApeDxOzP2WHGWKmUJLuy4PaTLWZ/vhyDXOXv9AKWP5ljWVPgWH5hOU+fpYICjiT8XBVDimqHyj3wYTmiQ47ZI5Ja8S093sK6zivGZRVUh6+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791787538; c=relaxed/simple;
	bh=9MBzy/fT3/PY2882egwYAvvLh/qkN8P0o7kWIQPbE+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YJfUDAmzjE0Lmm2OzEf2J+OU2c5tMuPF91+5UtUyTWJcMy7POunKbCM6j0k10yMkHpPHgASiJbrsRJ8Wa3GSM4ludrWI/dJK+dRud9AJVbiNT12T1cGHV7ZDM2NBWaXVYFUQcgoxH1favGXHJdB1axeHIanjESzBYFgNya8TZI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNUqZJMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNUqZJMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCA41F00A31
	for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 06:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791787536;
	bh=c3DBHfv3LqK/91RwT2dMSYSZicBl2tHtlLK8QCPVvWY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZNUqZJMXXVYW2yyo8J7bzJwVupjw/wh2QM3vIj+bZ7C9CCxHVOMUQSJtB64gRlsvJ
	 47yey9LfEZEAu3PP0hL6OtEGBPfRS6trqdua2NeFj7Hkws0SH+8cJtoCKyKT/uBs3/
	 M0ArGm1ZjtRSZ/4NGBRD/ROTGmb/1mS1DsHutsE4Wl7XEMSne4U6Dt4sXh7xzMKGDB
	 NqhHLN40xaogVX0rOA0WRsjS94ag/f9IJ1mvqnHXKlH0BP3bq10qjlhY9B8F7X5/s2
	 Xt/cVWidI6dv16jBzetPQa8deA1M240ivDpJ26/Z5NwLoXkrT8hQLwpxCiaWRVn4cG
	 w4UFEjFCf4dhw==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a601ba6870so2297653a12.0
        for <linux-crypto@vger.kernel.org>; Sun, 11 Oct 2026 23:45:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByONHIUXW3LWJfRytcsVkARD58iSaWTgzNW7H/IpIHw1u3lFLdpHRc0YWRb+kkhZxsUobhBOdrCc4bNu0M=@vger.kernel.org
X-Gm-Message-State: AFq9FYLw0R9rzOQCDLUenotjfXoUmfd+4ikFRZ7nZdZHib9zZkRPCFAc
	AVlKnS8XUtzGYyqSVqhUmlzJ0lkYrdSJHkCGMh3kdvCJc/QwBhMFhRVGIW1Ht5HN3K6eAP4bVLO
	owAnZqwAL2vFzj9BtP3PL+F4b+u8weOM=
X-Received: by 2002:a05:6402:21c3:b0:6aa:4c8b:6213 with SMTP id
 4fb4d7f45d1cf-6b17c26ce2dmr6316528a12.18.1791787534855; Sun, 11 Oct 2026
 23:45:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261011142930.492999-1-chenhuacai@loongson.cn>
 <20261011142930.492999-2-chenhuacai@loongson.cn> <20261011151243.GB168780@quark>
In-Reply-To: <20261011151243.GB168780@quark>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 12 Oct 2026 14:45:24 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4YwMFMQP1razrWDG=XKvBVyN64Hv0rKsA+TNN-4bt20g@mail.gmail.com>
X-Gm-Features: AclHuK83BGXN9i6Iiyy3rUK7fXekFO-B-XI5TgtsZDDp-fRD06uDSPzWqIETF8w
Message-ID: <CAAhV-H4YwMFMQP1razrWDG=XKvBVyN64Hv0rKsA+TNN-4bt20g@mail.gmail.com>
Subject: Re: [PATCH 2/2] lib/crc: loongarch: Add 3-way parallel CRC32(C) for
 large buffers
To: Eric Biggers <ebiggers@kernel.org>
Cc: Huacai Chen <chenhuacai@loongson.cn>, Ard Biesheuvel <ardb@kernel.org>, 
	linux-crypto@vger.kernel.org, WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Tianyang Zhang <zhangtianyang@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Eric,

On Sun, Oct 11, 2026 at 11:12=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> On Sun, Oct 11, 2026 at 10:29:30PM +0800, Huacai Chen wrote:
> > The crc* loop is a single serial dependency chain: every instruction
> > consumes the previous one's result. CRC is linear over GF(2), so a
> > buffer can be split into 3 contiguous lanes processed by independent
> > chains and combined afterwards:
> >
> >     crc(A|B|C) =3D shift(crc(A), |B|+|C|) ^ shift(crc(B), |C|) ^ crc(C)
> >
> > with lanes B and C seeded with 0. The shift (multiplication by x^(8n)
> > mod P) is linear, so its multiplier is tabulated at module init as 4x25=
6
> > tables built from crc32_le_base()/crc32c_base(); each combine then cost=
s
> > 4 lookups instead of a log-time GF(2) square loop.
> >
> > Lanes use a fixed 2 KiB stride (6 KiB superblock); smaller buffers fall
> > through to the serial path. The 3-way parallel loop CRC32 is measured o=
n
> > a Loongson-3C6000 machine (single core, cache-hot, with UAL):
> >
> >     8 KiB:   8.4 -> 12.0 GB/s
> >     64 KiB:  8.4 -> 12.4 GB/s   (+45% over the serial hw loop,
> >                                  ~12x over the generic table)
> >
> > Correctness was verified bit-exact against crc32c() over all lengths
> > 0..6168 with 3 seeds, plus 3000 random offset/length/seed combinations.
> >
> > Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
>
> So is this new code testable in QEMU?  That's a prerequisite for adding
> new optimized CRC or crypto code.
Yes, it is testable in QEMU (for correctness). But the improvement
comes from super-scalar hardware, so the performance may be the same
for QEMU.

>
> Please also note that you should just run crc_kunit instead of writing
> custom in-kernel CRC test code.
Yes, crc_kunit is passed. Tianyang wrote his custom code but I have
run crc_kunit, I will update the commit message.

Huacai

>
> - Eric
