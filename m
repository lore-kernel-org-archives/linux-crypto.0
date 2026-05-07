Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1338F397E6D
	for <linux-crypto@vger.kernel.org>; Thu,  7 May 2026 22:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778192570; cv=pass; b=oP9JIGPiuJyplBg8xmNQPs4HF2wUiePxEO9fy6cOfrJNGhgwgHZ1TKUkknj1HtsG5i4kYhDpZ5Ud+7piWdsZEf7xJ6TVbdbOhuAEbkfQmXco9KeoLWdkMEdXxLAKKP3A88aiB7qUSqqLvbCtvxjPvugIFk7cninZEks1E6NvCcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778192570; c=relaxed/simple;
	bh=mAKX6wgNc2PRZmvreP1S7A50kU6sTzf4a0dWxGovQ00=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E68sz+vrFYxBEfGFd6IsoVnQDvvEvhSyr8CuccKq0D9N/AB9z2VaBNYfLto6iT6Q61asBPHCrS88xsJAdHWFEQjWzyKk8d58mfqmCKQVS4RIubFVkxdBqmQzy7FYPj3RsF+ZDHKi7BMeHA3qZNvtnf52hsUh5mwVzlc/wBOaTeI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=E0rPI6GC; arc=pass smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="E0rPI6GC"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3660ab73adbso738353a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 07 May 2026 15:22:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778192565; cv=none;
        d=google.com; s=arc-20240605;
        b=ZwYcYg1n05ogSwVTfaDPUaZbaTnunle8boQD+I33hT3csoqeBF+upd4iQzItyO1rCq
         LGK9RTH5vvpmUeehjNx+qe3wZUrm5tjHTasG6IbzvJUYgwV/1vERnf25Q4MZF6KaR6cf
         lO45wXKRz0MzP5yPAJIcsdYvA+DFFrgaEHKB7GaXy6b0z8rBH9y0FDpOHXqN9VXx++d7
         yfeVbl5F/TGr0TZlCaog7UghBr2Kz1Rnt0XdwE+wqyX8Bd9vZpJEo9NKkXDeklMg6N/t
         kmJwNLs8Z4zuBBekdWp1P8hIuF0GWqrXSak2Muz8Fkk4225aCjEIXNM9HcQ7WSDI/I+z
         7tlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uO97KWC4YWUVtqvc1Au2FSmHX81LBVhHYAFjjOVk3zc=;
        fh=XGa/HLDKF2JTmwTZKsAntg/6SLjdwQU7A7XyHLN/qGc=;
        b=aPfrvjEwI17bfWslZbpgEVODMAX1yurnTa3dZjy24omnex53g6KbSg5arOXBOJiDHl
         xHyQKlDLdvCrSvT5KTwRY3i1mOC2aw9rhmoiow1To98gNtw+D/IUbBHh7p7RISFD+X74
         Hw86DtTNxswfc8WwsAu49nRdtT7fII2aMLOlSjR/BkI7PO1W4wjGnorI7xXKxcRGWT8k
         Z3NTO2DAWvlT6EWpl0Pxb94ZtJk59lAVLkdLMEp2n7o9Zr/UhJovNFIwAXGri9du3eqk
         sYA1oO8ZpOoq7z8B9cW318aW18q0KToHWHFGpHcjwoUFwJXvployxSf1yVmj1S7hlejF
         7reg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1778192565; x=1778797365; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uO97KWC4YWUVtqvc1Au2FSmHX81LBVhHYAFjjOVk3zc=;
        b=E0rPI6GCtKuK2gChXLQDDFFUWKgZPyQ2n6nVGbMzBsHikjGSTJezUdfAoJr8Dkbgi2
         CoKNzFqwy4HZ+0ZgFe2syVC3YO4+VwAiLEIhuy0eg13gLcM6F4QV7ZpXp6rF8U75Ymmu
         kauE2t+R5dWZ1Xv3jBETjylqxx9S0oJO4wP22YS9JyBJ/qV9EELr21KhtFVxOPmpXoQ9
         acXbiv6kbc4LdVI6WZP5QA0gGwUZ8o6JNub4JhJjox3nebUvzSv6x8r1VOFt3IdZWwdE
         8UWy03ONexNodu7a6D2nmTmDE7OJ4RV/T6XQ03HQJfZkQRAruBQcTz/rx8XjF1JgE+V5
         4uYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192565; x=1778797365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uO97KWC4YWUVtqvc1Au2FSmHX81LBVhHYAFjjOVk3zc=;
        b=BAlPMGgY2wL6FHfqm+gyyw7VJCq5KB7RFIKJK1yFvAwPYYlQs0iNte9rwPXNwQtpkB
         6l3Fx3H4KULDH/25KFIOCvUVtNZpX28rnnyHTHx4qibKRUL8Ql5sQ53nK8GLO3o0QcCi
         WgMM1vK03/pfRNfhIUTTRVzZJcA0mipK2ebve5nbEkdIqH/xLiQlCD335e043zX8tRbI
         GLElY+VGboSlVr6xzW1GNn5J9AfLmHaKW/szhT6EJrai4uvxMgajgjJBHrnd3gVWqmA9
         owmBbZ1mU7Trvnb0P1BznCzcz/WCdulwYny/BQQPtA0O/K5SN7A9qSGJj40kBfWQyA2N
         KZ/Q==
X-Forwarded-Encrypted: i=1; AFNElJ+MSyLAhGWUX8/YriQqWie8B7WD/07XFEmvRgdV/WBejHsQ6rfcErLepvn1O2p2ZT4TmYI7yAnYTBX40Kc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX0w+AzuEMRk8CI4q1v4tNokfAWcfWLzX5N3IKl0YSsRMHLTrR
	M2CM4Jzg7TCGSu5x0W5Qd6Q53QPKHdiCFhtwe+/BVxFNQgTcFOEUSYNk7ar8CGCnXaMEgrDgNBS
	2I0SSfibgvvvmEk78Ekh4///g1ChHdPrVKnW62pct
X-Gm-Gg: Acq92OF3c7oPIs6kkoOgofsYvo4ku24n/HH4eqnDCV7OUg51ZPdDeN6OA2LP0Lvl8HW
	/Y4rgm4BwF6svrpXq+jG92AW3DejWivxma8u/5BYkXf+LY1bKmsrujbxPfN4WgtI2uAntpZg3W3
	UFBTwQVORh+SJXRzCaPYlg6bklcrfOvd69wZWcdJ0AbXspDSwANE71gZ7JdNv1f7q5t6D0Z1MRu
	S4MgEyZoh6/J8gAVjJIcVDKcr/w0vYs3bb0w3S389PHBCDZCrn5I/djSA89bL0RPSHr+A5JYfIi
	FIO02jk=
X-Received: by 2002:a17:90b:37ce:b0:35e:579a:7e9a with SMTP id
 98e67ed59e1d1-366053f7f37mr3755818a91.7.1778192565145; Thu, 07 May 2026
 15:22:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260507191416.2984054-1-bboscaccy@linux.microsoft.com>
 <CAHC9VhR0Abikk+2=DWtVu1cEkcwkudKFRJH51BFOh0Qt01wLJw@mail.gmail.com> <20260507215841.GA440717@google.com>
In-Reply-To: <20260507215841.GA440717@google.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 7 May 2026 18:22:32 -0400
X-Gm-Features: AVHnY4LYfZmrMHgu1g-URpUjWolSTtBhtR0X4jOEvZIj1FG1Uv1L4IXt3-342NI
Message-ID: <CAHC9VhQiSV37HXqyE0J_3f6p2DxGAx0MtuwjmKvziHTOcxVdCQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/10] Reintroduce Hornet LSM
To: Eric Biggers <ebiggers@kernel.org>
Cc: Blaise Boscaccy <bboscaccy@linux.microsoft.com>, linux-crypto@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
	"Dr. David Alan Gilbert" <linux@treblig.org>, Andrew Morton <akpm@linux-foundation.org>, 
	James.Bottomley@hansenpartnership.com, dhowells@redhat.com, 
	Fan Wu <wufan@kernel.org>, Ryan Foster <foster.ryan.r@gmail.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-security-module@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 7, 2026 at 5:58=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
> On Thu, May 07, 2026 at 04:57:35PM -0400, Paul Moore wrote:
> > On Thu, May 7, 2026 at 3:14=E2=80=AFPM Blaise Boscaccy
> > <bboscaccy@linux.microsoft.com> wrote:
> > >
> > > This patch series introduces the next iteration of the Hornet LSM.
> > > Hornet=E2=80=99s goal is to provide a secure and extensible in-kernel
> > > signature verification mechanism for eBPF programs.
> > >
> > > Hornet addresses concerns from users who require strict audit trails =
and
> > > verification guarantees for eBPF programs, especially in
> > > security-sensitive environments. Many production systems need assuran=
ce
> > > that only authorized, unmodified eBPF programs are loaded into the
> > > kernel. Hornet provides this assurance through cryptographic signatur=
e
> > > verification.
> > >
> > > The currently accepted loader-plus-map signature verification scheme,
> > > mandated by Alexei and KP, is simple to implement and generally
> > > acceptable if users and administrators are satisfied with it. However=
,
> > > verifying both the loader and the maps offers additional benefits
> > > beyond verifying the loader alone:
> > >
> > > 1. Security and Audit Integrity
> > >
> > > A key advantage is that the LSM hook for authorizing BPF program load=
s
> > > can operate after signature verification. This ensures:
> > >
> > > * Access control decisions are based on verified signature status.
> > > * Accurate system state measurement and logging.
> > > * Log entries claiming a verified signature are truthful, avoiding
> > >   misleading records where only the loader was verified while the act=
ual
> > >   BPF program verification occurs later without logging.
> > >
> > > 2. TOCTOU Attack Prevention
> > >
> > > The current map hash implementation may be vulnerable to a TOCTOU
> > > attack because it allows unfrozen maps to cache a previously
> > > calculated hash. The accepted =E2=80=9Ctrusted loader=E2=80=9D scheme=
 cannot detect
> > > this and may permit loading altered maps.
> > >
> > > 3. Supply Chain Integrity
> > >
> > > Verify that eBPF programs and their associated map data have not been
> > > modified since they were built and signed, in the kernel proper, may
> > > aid in protecting against supply chain attacks.
> > >
> > > This approach addresses concerns from users who require strict audit
> > > trails and verification guarantees, especially in security-sensitive
> > > environments. Map hashes for extended verification are passed via the
> > > existing PKCS#7 UAPI and verified by the crypto subsystem. Hornet the=
n
> > > calculates the program=E2=80=99s verification state.  Hornet itself d=
oes not
> > > enforce a policy on whether unsigned or partially signed programs
> > > should be rejected. It delegates that decision to downstream LSMs
> > > hook, making it a composable building block in a larger security
> > > architecture.
> >
> > [NOTE: trimmed changelog for brevity]
> >
> > > Blaise Boscaccy (6):
> > >   lsm: security: Add additional enum values for bpf integrity checks
> > >   security: Hornet LSM
> > >   hornet: Introduce gen_sig
> > >   hornet: Add a light skeleton data extractor scripts
> > >   selftests/hornet: Add a selftest for the Hornet LSM
> > >   ipe: Add BPF program load policy enforcement via Hornet integration
> > >
> > > James Bottomley (3):
> > >   crypto: pkcs7: add flag for validated trust on a signed info block
> > >   crypto: pkcs7: add ability to extract signed attributes by OID
> > >   crypto: pkcs7: add tests for pkcs7_get_authattr
> > >
> > > Paul Moore (1):
> > >   lsm: framework for BPF integrity verification
> > >
> > >  Documentation/admin-guide/LSM/Hornet.rst     | 323 +++++++++++++++
> > >  Documentation/admin-guide/LSM/index.rst      |   1 +
> > >  Documentation/admin-guide/LSM/ipe.rst        | 162 +++++++-
> > >  Documentation/security/ipe.rst               |  68 ++++
> > >  MAINTAINERS                                  |   9 +
> > >  certs/system_keyring.c                       |   1 +
> > >  crypto/asymmetric_keys/Makefile              |   4 +-
> > >  crypto/asymmetric_keys/pkcs7_aa.asn1         |  18 +
> > >  crypto/asymmetric_keys/pkcs7_key_type.c      |  44 +-
> > >  crypto/asymmetric_keys/pkcs7_parser.c        |  81 ++++
> > >  crypto/asymmetric_keys/pkcs7_parser.h        |   1 +
> > >  crypto/asymmetric_keys/pkcs7_trust.c         |   1 +
> > >  include/crypto/pkcs7.h                       |   4 +
> > >  include/linux/lsm_hook_defs.h                |   5 +
> > >  include/linux/oid_registry.h                 |   3 +
> > >  include/linux/security.h                     |  28 ++
> > >  include/uapi/linux/lsm.h                     |   1 +
> > >  scripts/Makefile                             |   1 +
> > >  scripts/hornet/Makefile                      |   5 +
> > >  scripts/hornet/extract-insn.sh               |  27 ++
> > >  scripts/hornet/extract-map.sh                |  27 ++
> > >  scripts/hornet/extract-skel.sh               |  27 ++
> > >  scripts/hornet/gen_sig.c                     | 401 +++++++++++++++++=
++
> > >  scripts/hornet/write-sig.sh                  |  27 ++
> > >  security/Kconfig                             |   3 +-
> > >  security/Makefile                            |   1 +
> > >  security/hornet/Kconfig                      |  13 +
> > >  security/hornet/Makefile                     |   7 +
> > >  security/hornet/hornet.asn1                  |  12 +
> > >  security/hornet/hornet_lsm.c                 | 352 ++++++++++++++++
> > >  security/ipe/Kconfig                         |  15 +
> > >  security/ipe/audit.c                         |  15 +
> > >  security/ipe/eval.c                          |  93 ++++-
> > >  security/ipe/eval.h                          |  11 +
> > >  security/ipe/hooks.c                         |  63 +++
> > >  security/ipe/hooks.h                         |  15 +
> > >  security/ipe/ipe.c                           |  14 +
> > >  security/ipe/ipe.h                           |   3 +
> > >  security/ipe/policy.h                        |  14 +
> > >  security/ipe/policy_parser.c                 |  27 ++
> > >  security/security.c                          |  75 +++-
> > >  tools/testing/selftests/Makefile             |   1 +
> > >  tools/testing/selftests/hornet/Makefile      |  63 +++
> > >  tools/testing/selftests/hornet/loader.c      |  21 +
> > >  tools/testing/selftests/hornet/trivial.bpf.c |  33 ++
> > >  45 files changed, 2112 insertions(+), 8 deletions(-)
> > >  create mode 100644 Documentation/admin-guide/LSM/Hornet.rst
> > >  create mode 100644 crypto/asymmetric_keys/pkcs7_aa.asn1
> > >  create mode 100644 scripts/hornet/Makefile
> > >  create mode 100755 scripts/hornet/extract-insn.sh
> > >  create mode 100755 scripts/hornet/extract-map.sh
> > >  create mode 100755 scripts/hornet/extract-skel.sh
> > >  create mode 100644 scripts/hornet/gen_sig.c
> > >  create mode 100755 scripts/hornet/write-sig.sh
> > >  create mode 100644 security/hornet/Kconfig
> > >  create mode 100644 security/hornet/Makefile
> > >  create mode 100644 security/hornet/hornet.asn1
> > >  create mode 100644 security/hornet/hornet_lsm.c
> > >  create mode 100644 tools/testing/selftests/hornet/Makefile
> > >  create mode 100644 tools/testing/selftests/hornet/loader.c
> > >  create mode 100644 tools/testing/selftests/hornet/trivial.bpf.c
> >
> > [NOTE: added the linux-crypto list to the To/CC lines]
> >
> > Hi crypto folks,
> >
> > You'll notice there are three patches from James Bottomley in this
> > patchset that touch crypto code and I'd appreciate it if you could
> > take a look and either ACK the patches or let James and Blaise know
> > what you would like changed.  James did send these patches to you for
> > review some time ago, so they aren't necessarily new, but I wanted to
> > make sure you saw them again.
> >
> > Unfortunately, it doesn't look like the crypto list was CC'd on this
> > patchset, so here is a lore link to the patchset as a whole:
> >
> > https://lore.kernel.org/linux-security-module/20260507191416.2984054-1-=
bboscaccy@linux.microsoft.com
> >
> > ... and here are lore links to the three crypto patches:
>
> We discussed before how the actual signature check seemed to have been
> overlooked in some cases, due to the complexities of PKCS#7
> (https://lore.kernel.org/r/20260305185016.GC2796@quark/).  Looks like
> that was fixed.  It is really hard to do any meaningful review of a
> PKCS#7 based system, though.  And it sounds like this one is proceeding
> anyway due to some requirement to be compatible with an existing PKCS#7
> based system.  So I'm not sure what you're looking for.

Ideally an ACK that you approve of merging those three crypto patches
via the LSM tree, or a quick comment if you happen to see anything
that needs changing.

--=20
paul-moore.com
