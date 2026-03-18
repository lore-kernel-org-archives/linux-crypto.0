Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87DD3B4E8C;
	Wed, 18 Mar 2026 15:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=131.246.120.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773848378; cv=none; b=k1p6NXh7hRsPjNTasSiNxaxUXFpeO94bWBjk98jaVYO9wEGRqMQLwO8Uq5K8KKRRuSwQnRBEWeExFtI03P4JO9p82sfAJ2iffdVEvCQM0m2kQHSzihDXPuvfmRA//b2YT/ia/5cxFRwfR6fxlvNz3Up7aMsv85RStcHNyjcjcUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773848378; c=relaxed/simple;
	bh=9biZ7RHXjgNdFYYFQWCNAHvjg2IqE29+EF9hdALNpTc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=OUKCEVz2VZDRNQkpxNkc5FS+NAymCHwlFTANO8zWVZux8oRaXqFh04a//1UY9phpcdB+NRfJKyTWix7UQsan4l4z5mCxRPNv0qLDUxdXf5fAjtYaBtQnFI+hnh2prdG2O6mhG5boVKz+llt9d0O6ipNBssSqgV13d7/1hcpxalc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rptu.de; spf=pass smtp.mailfrom=rptu.de; arc=none smtp.client-ip=131.246.120.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rptu.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rptu.de
Received: from smtpclient.apple (ip5f58e5b0.dynamic.kabel-deutschland.de [95.88.229.176])
	(authenticated bits=0)
	by mailgw1.uni-kl.de (8.17.1.9/8.17.1.9/Debian-2+deb12u2) with ESMTPSA id 62IFXD1K1820072
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Mar 2026 16:33:21 +0100
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] x86: enable Data Operand Independent Timing Mode
From: =?utf-8?Q?Marvin_H=C3=A4user?= <haeuser@rptu.de>
In-Reply-To: <851920c5-31c9-ddd9-3e2d-57d379aa0671@intel.com>
Date: Wed, 18 Mar 2026 16:33:02 +0100
Cc: Eric Biggers <ebiggers@kernel.org>, Jann Horn <jannh@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Roxana Bradescu <roxabee@chromium.org>, Adam Langley <agl@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <33E64985-BE38-49D6-AB1C-CD7CFC1D08F1@rptu.de>
References: <20230125012801.362496-1-ebiggers@kernel.org>
 <14506678-918f-81e1-2c26-2b347ff50701@intel.com>
 <CAG48ez1NaWarARJj5SBdKKTYFO2MbX7xO75Rk0Q2iK8LX4BwFA@mail.gmail.com>
 <394c92e2-a9aa-37e1-7a34-d7569ac844fd@intel.com>
 <CAG48ez0ZK3pMqkto4DTZPNyddYcv8jPHQDNhYoFEPvSRLf80fQ@mail.gmail.com>
 <e37a17c4-8611-6d1d-85ad-fcd04ff285e1@intel.com> <Y9MAvhQYlOe4l2BM@gmail.com>
 <8b2771ce-9cfa-54cc-de6b-e80ce7af0a93@intel.com>
 <16e3217b-1561-51ea-7514-014e27240402@intel.com>
 <Y9oMmYWzy7mlk3D9@sol.localdomain>
 <c5809098-9066-d90d-1bcc-108a11525cac@intel.com>
 <851920c5-31c9-ddd9-3e2d-57d379aa0671@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
X-Mailer: Apple Mail (2.3864.500.181)
X-Spam-Score:  (-2.9)
X-Spam-Flag: NO

Hi all,

As I haven=E2=80=99t found any news on the list or the tree, I'd like to =
inquire whether
there=E2=80=99s been any updates on the situation.

> On 3. Feb 2023, at 17:25, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> There are some other crazier choices like adding ABI to toggle DOITM =
for
> userspace, but I'm not sure they're even worth discussing.

Sorry if I misunderstood something, but isn=E2=80=99t that basically the =
only effective
way to use DOITM? DDP is not active in kernel mode regardless of DOITM =
and the
FSFP documentation says that existing mitigations for SSB and such =
=E2=80=9Cusually=E2=80=9D
will also be sufficient for FSFP. I assume in absence of KERNEL_SSBD, =
the other
existing mitigations would simply be augmented as necessary, rather than
enabling something alike KERNEL_FSFPD. But I may be totally mistaken =
here.
I further assume variable-latency instruction semantics still do not =
apply, so
to my understanding, FSFP is the only potential concern to the kernel, =
and it=E2=80=99s
not that bad.

Meanwhile, DDP is active in userspace and potentially violates the =E2=80=9C=
no
secret-dependent memory accesses=E2=80=9D constant-time programming rule =
at the
microarchitectural level. While real-world risk is up for debate, for =
truly
constant-time execution it must never trigger on memory that contains =
secrets.
To my knowledge, the only way to achieve this right now is to turn it =
off. The
Intel documentation also recommends against turning it off generally. =
So, either
there must be an opt-out per-process (and the processes should be mostly
isolated regarding computation on secrets, otherwise all other =
operations face
the performance penalty as well), or there must be a dynamic toggle like =
there
is for prctl() speculation control. As ARM has basically the same thing, =
I=E2=80=99m not
sure there=E2=80=99s much benefit in relaxing the semantics (but there =
might be in
making it accessible in userspace).

OT/Motivation: DDP has a rarely talked about implication from the =
prefetching
window. Namely, when accessing non-secret memory adjacent to secret =
memory, it
can activate on secret memory even when it is never accessed while DDP =
is
enabled. There are multiple solutions to this, e.g., to place guard =
pages around
secret memory and trust DDPs will fault and back off. Another way is to =
make
sure secret memory is never mapped while DDPs are active. I=E2=80=99m =
playing around
with this at the moment because unmapping secret memory also would mean =
that
mitigations like SLH only need to be applied to code that can execute =
while
secret memory is mapped. This can be achieved with pkeys, but it =
requires some
extra work to ensure no process=E2=80=99s secret memory pkey allows =
reads while DDPs are
on, even during context switches. Maybe more on that to come, maybe not, =
but I
wanted to provide my motivation in this. :)

> My inclination is to wait a couple of weeks to see which way DOITM is
> headed and if the definition is likely to get changed.

The Intel documentation seems to be fairly stable, so I assume not much =
happened
on the hardware/ISA side?

Thank you!

Best regards,
Marvin=
