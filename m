Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38D014D719;
	Wed, 18 Mar 2026 20:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=131.246.120.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773865037; cv=none; b=awxEp5MK8Pv2G6PIPGAPsH0Yewor8VPKUi4R6FbV6WNmzzJlLh9gxG1DPQ0zW4F2oJBD0kbTKE1Nz1dl/gsTSwuo7FnEUsr2JyzvvGQzZvLCrxCp3/3tjCAcAP7Qjx2Yl3CR9xORlBG8v5Do905OIcPr5zJm3SKZoV7Q8YYieMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773865037; c=relaxed/simple;
	bh=OOvaqkoWgMwW/DtOxPXAjFjVHwZYzAZ6X3fYu1spxbU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=aC1l4tATwP6Fn1U5jYr+lfedZRoDMfF/hM0I8+QXr5Eckoe7ELClEUNKmXm5mK/23KsqcERzm06OUfXApfGVvyZwZn7P208wxVySi2u0a6Ll9VUwOzYTAqhniAIOe0RFZU6hrRvhE62gysmPmZvRZeyH7Naqnj3vCxUJ2hln/dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rptu.de; spf=pass smtp.mailfrom=rptu.de; arc=none smtp.client-ip=131.246.120.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rptu.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rptu.de
Received: from smtpclient.apple (ip5f58e5b0.dynamic.kabel-deutschland.de [95.88.229.176])
	(authenticated bits=0)
	by mailgw1.uni-kl.de (8.17.1.9/8.17.1.9/Debian-2+deb12u2) with ESMTPSA id 62IKGNGt2277528
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Mar 2026 21:16:31 +0100
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
In-Reply-To: <D5B3C493-BADA-4906-BB34-E5D60182F611@rptu.de>
Date: Wed, 18 Mar 2026 21:16:13 +0100
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
Message-Id: <A5C6AB74-7E6B-4E4E-9836-45DF18F671DD@rptu.de>
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
 <33E64985-BE38-49D6-AB1C-CD7CFC1D08F1@rptu.de>
 <7dfb5fe7-295f-4a29-a633-c2907a1fdb60@intel.com>
 <D5B3C493-BADA-4906-BB34-E5D60182F611@rptu.de>
To: Dave Hansen <dave.hansen@intel.com>
X-Mailer: Apple Mail (2.3864.500.181)
X-Spam-Score:  (-2.9)
X-Spam-Flag: NO

(CC, sorry for resending, my client converted the e-mail to rich text by =
accident)

> On 18. Mar 2026, at 16:44, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> I'd summarize it like this: lots of meetings, no updates.
>=20
> IMNHO (and not speaking for my employer) DOITM itself is dead. There's
> almost no chance of Linux ever doing anything with the existing, =
public
> DOITM architecture.

Thanks for the quick update!

Well, I am not sure this changes much. So, DOITM has always been more or =
less
an alias for (DDPD_U | PSFD) (surprisingly, I don=E2=80=99t think the =
documentation
mentions FSFP is disabled in DOITM?) and will likely remain exactly =
that.

It might still make sense for the kernel to have some general DIT =
control.
Not only does ARM have DIT with a definition analogous to DOITM. The =
only
real-world implementation of ARM DIT I know of, Apple silicon, also =
toggles
their DDP alongside the core DIT semantics (starting with Apple M3) [1]. =
This
makes it roughly equivalent to Intel DOITM. Apple, for their =
implementation,
recommends toggling DIT for crypto code rather than per-process =
protection [2].
Of course, ARM=E2=80=99s doesn=E2=80=99t need a syscall.

So, to my understanding, DDP (and FSFP?) would still need to become =
=E2=80=9Cbugs=E2=80=9D in
the kernel to be independent of SSBD (unsure there is a strong benefit, =
but
the documentation says there are alternative mitigations to SSB). The =
same is
true for MCDT, which appears to be an actual bug (userspace can apply
mitigations, so the kernel should just report whether the CPU is =
affected; or
is that not desired?). As Intel DOITM and Apple DIT have done, it still =
makes
sense to classify DDP under the DIT umbrella, because it=E2=80=99s the =
only =E2=80=9Cbug=E2=80=9D
that leaks your secrets by design. So a general kernel DIT control =
should
toggle it, regardless of DOITM=E2=80=99s future. This would also allow =
adding DDP-like
optimizations with separate kill switches in the future, if necessary =
(though
that=E2=80=99s exactly the problem DOITM would solve).

OT: I think applications may benefit from an opt-out speculation =
mitigation
control. By that I don=E2=80=99t mean that every process has all =
mitigations applied
by default and has to proactively disable them, but that a process makes =
an
=E2=80=9Capply sensible mitigations=E2=80=9D syscall, agnostic to what =
these particular
mitigations are. If an application has manual hardening, it can then opt =
out
of a specific heavyweight kernel mitigation (e.g., it may be happy with =
lfence
over SSBD, or it may not be affected by a particular =E2=80=9Cbug=E2=80=9D=
 by design).
Of course, this can be implemented in userspace by having a shared =
library that
keeps up with in-kernel mitigations and applies them considering the
application-provided opt-out list. Otherwise, code remains vulnerable to =
novel
=E2=80=9Cbugs=E2=80=9D until updated. I=E2=80=99m not sure whether an =
in-kernel mechanism or a shared
library would be the way to go. For mitigations that are low-risk but =
high-cost,
there could still be a separate opt-in. I just feel like the OS is the =
best
suited entity to make that decision when a new =E2=80=9Cbug=E2=80=9D =
drops.

Best regards,
Marvin

[1] https://gofetch.fail/files/gofetch.pdf

[2] =
https://developer.apple.com/documentation/xcode/writing-arm64-code-for-app=
le-platforms=
