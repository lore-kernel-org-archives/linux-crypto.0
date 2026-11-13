Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794600357;
	b=jW1euqbxvpC0WoSTq+nWus9SM/RSsVlexqigBDxYTbRV/DobzQzQ4I+Bs06FqQNu0ove
	 JWKbw4tuR5nxnBSz1cvQXEnigw2wN55T74lw9VoCQ1nrD7Zs3ZEdCMgaHkF+qm/7QvMDl
	 WLIbT1UcCyLcS25x/NJ7QzDHcjDCiHBMsTJ8MvKjm/J5wcvnilSmER4qliJF2FC0PpmKg
	 VyWOWuAEu93rUB6F5ZgVxBc7vlT0F6TMjvjViSfVYouy7u+tUAIZIDBAIcgCRcDRE7Ifz
	 LaqsUVNyqFOI0FxKjlrIo6Jn8ElIBPoEKbBtwPxGG8wgtQyMfiHwN/B5P+TqACFUTDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794600357;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=VvQJyhwgQ+YhbM+FtddDOciD0h7PQaqhxjTy41nTAJE=;
	b=kmVszlFcQDmR0MwhqNzyV5dNl5CiSNGqfgOj3s8PbcjlX+KUaQgZkVE2CrmJ9UcEtbml
	 15/h/egmJ3wz7JGgWep0dz3nN/+N5GIFbVY4VOqe7+WKO+rS8RUL+8MKHh/iU8LsLqWov
	 uTtOTxE6+Bg5cFbSWxlwW76EYED4f9ZL4UB2xurQoaQ1czu95STfk0Nf3pBu+cf30VksZ
	 BAKy+LWyYJ9nGm8qqeJGzdhEivpKw8+MND7779Fi2L6d0CI8M6bsMLup6i/ASUoDVI0Cg
	 uvqBiSlcFlvzDlaXa+mGBASPpcMRd2xsRDR9TrnkMMTSp6yrt3RH9YufSl+L4zcmsrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AqHo836m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8AD606A337
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 20:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AqHo836m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C521F000C7;
	Fri, 13 Nov 2026 20:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794600357;
	bh=VvQJyhwgQ+YhbM+FtddDOciD0h7PQaqhxjTy41nTAJE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=AqHo836mxfkCHsx9CdZoTG3M66PmGwuMD6kk2cYs4gZQ4EdDQfyT4DYzJyMzQzLtD
	 wVi62IN+nPbMbG2aviIWa5Na6J30LQLbNQCePvLDDIZQzXjNBP29mHaoyVvAU7sTN5
	 OQhgcGVNdJaVsLCnjcmgCPgcsiLa9hamMcvuD4PEklnu9C8F0G1bBAvWtvumzfdchc
	 r2cAeNsCD8Mnhyv8KP4jDWwsiAX1XZxaCWrd/5ihG+UF9aPsv4eBVTNt1dX4CaJ67P
	 RmXrcVAOqHunGcec5wPIRvOsZ79P2xExmv2kI9zfcurOHy1bD6tFOcFE10mHyJGn0I
	 lLom6cKyKpHSg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8B4E8198003A;
	Fri, 13 Nov 2026 15:05:54 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 13 Nov 2026 15:05:54 -0500
X-ME-Sender: <xms:oG33ala2Qs4dNCz_pgKY9qRFkQNTC8Md8bjb0LxB46k3LYEbFL24aw>
    <xme:oG33anO6D0ny--CeA8YHwhOR2Bnxkws17cmN25HV8MXK2cJ7kSMiFxQLvCKELokaa
    _P9FBJN182cikAmS_EWuQU6f2s5w5re3_lzq_YaU2r3zedxLFq2yi9M>
X-ME-Proxy-Cause: dmFkZTFrh2j1YerPcsdYSEJl2fuNPZBBkrWfKhKGJpB+r05OZ52nQHlNbhYFKI0raic5S0
    5bMlCyChL49t3w8ZhhOR0NlNe3z9Lg7QBBiJ59KgCh1sycLWSK809y0RE5D/RanX5bwkrc
    EudQ9Fb7dAjmpZGKgucomUumnKpy8W0Ifj2G/RKLfrE67vIpEVZmZLp2GFgvO65vFSLxcv
    +k7OYpW55f5SLyKg+v3yrBkk34QdbPV0RCfi+OvplFq/xqwI0LylgEtFVmCLGUyZvzK/lB
    joRJw+3eq+P+s9M3NmX+1p1vZU043sdwYPKegHO9x2WqAdMAwNOhQR3RorxmNswidt5zkv
    hJVDuN6TQrb50u5stQadctkO+AFYznGeqlthIJiuhnH9e6cQFD+7x4XCSZ60HbgKOaTYxF
    tIl4yKFaQ4aLE3fwHNRQ99xcInMXWkrZDGLOJMIa1+jBcePoyMS5liR4ibrgMaOEWY2mih
    4IVSRU7Xb3Mqn1LqYgWN8SGE2Bz7yTt6B3sKJ3//eXRiqQdfXcWUZ0n0CcQMy3kI/eHVs6
    mfBsgf3cLFx9Pe5vb+hYqKSSuLVMgavmAWee3WBa4WNK7/kegauBOUj4lOghBSwIaWgxWy
    yQ5mOeLhSTkY5m4sG8j6E8abAfc9Rqgy7aT9SUPpBGfe041MC/DINB2qovsw
X-ME-Proxy: <xmx:om33av8JIDuF_Ma5r_he8EYFJwpuPdP3VGQh-jAlBjKuqbSUBCatiw>
    <xmx:om33at9fgU3GD5mjgAg1Ga21D6YsgKrJ_wdZicKzXvTcqeRoj0KDng>
    <xmx:om33avQHEOsTYqaVrKaWbbE4tRwGGfUvyQ1AeBEA3AgIlwpf6sUL0A>
    <xmx:om33ahcJmPgNrYZJ-_PouhKo7piju3djExvLGCz_NLgX4u1PmOp2JQ>
    <xmx:om33ajBdzwsFsd6xdno2q81dxNKuZUS8sa3B9bO6gXyXwln_S5LnVrFj>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id D33FBF8008E; Fri, 13 Nov 2026 15:05:52 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Fri, 13 Nov 2026 21:05:32 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Nathan Chancellor" <nathan@kernel.org>
Cc: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-crypto@vger.kernel.org, "Christoph Hellwig" <hch@lst.de>,
 "Eric Biggers" <ebiggers@kernel.org>
Message-Id: <b7f72b97-6e8e-4b07-a2a1-6ac8c6e596e4@app.fastmail.com>
In-Reply-To: <20261113190150.GA2857474@ax162>
References: <20261029135020.272082-6-ardb+git@google.com>
 <20261112222720.GA188816@ax162>
 <bc58b973-3d54-4480-aaaa-f5d5269418ea@app.fastmail.com>
 <20261113190150.GA2857474@ax162>
Subject: Re: [PATCH 0/4] Get rid of all NEON intrinsics stdint.h type hacks
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

(cc Catalin)

Full thread:
https://lore.kernel.org/all/20261029135020.272082-6-ardb+git@google.com/

On Fri, 13 Nov 2026, at 20:01, Nathan Chancellor wrote:
> On Fri, Nov 13, 2026 at 09:23:03AM +0100, Ard Biesheuvel wrote:
>> On Thu, 12 Nov 2026, at 23:27, Nathan Chancellor wrote:
>> > Who do you think should take this series? It would be nice if it could
>> > start making its way to mainline sooner rather than later since tip of
>> > tree clang builds have been broken for over a month at this point.
>> >
>> 
>> Are the first two patches sufficient for that? Perhaps Eric can take them
>> through the CRC or libcrypto trees, and I can send the remaining ones
>> through the respective arch trees the following cycle.
>
> Unfortunately not :/ we need the third patch to resolve the error since
> that is where the conflict is originating.
>

OK in that case, maybe Catalin can take the whole thing via the arm64 tree? 



Diffstat:

Ard Biesheuvel (4):
  lib/crc: Don't include <linux/types.h> in NEON intrinsics code
  xor: arm/arm64: Move NEON xor_gen() dispatch into the glue code
  arm64: Drop stdint.h type overrides from asm/neon-intrinsics.h
  ARM: Drop stdint.h type overrides from asm/neon-intrinsics.h

 Documentation/arch/arm/kernel_mode_neon.rst | 10 +++--
 arch/arm/include/asm/neon-intrinsics.h      | 43 +++-----------------
 arch/arm64/include/asm/neon-intrinsics.h    | 24 +++--------
 lib/crc/crc64-neon.c                        | 10 ++---
 lib/raid/xor/arm/xor-neon-glue.c            |  3 ++
 lib/raid/xor/arm/xor-neon.h                 | 16 +++++++-
 lib/raid/xor/arm64/xor-eor3.c               | 15 ++-----
 lib/raid/xor/arm64/xor-neon-glue.c          |  5 +++
 lib/raid/xor/arm64/xor-neon.h               | 31 ++++++++++++--
 lib/raid/xor/xor-neon.c                     | 16 ++------
 10 files changed, 78 insertions(+), 95 deletions(-)

