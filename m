Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3254F2F8EBE;
	Thu,  7 May 2026 21:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778191124; cv=none; b=R3vhe1FCPJCGRADTezlM/x2JwpkLUpACde4Dg0YyTKHdzd0Phis/AUt6aPA4h9ttntveSy8imA1MtxuQW6coeTkiNV9IaUaWShFOhWbhwv3G98ovsjKQqey9Z1JgbGLcb+e3cD1jOikoWCHzpCrsq4k/3xfW3pMwuhjhxVM3pOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778191124; c=relaxed/simple;
	bh=C2h75DAEriP1SjOL1VnaMQkqbHXp77CRB+xsgGMaL+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CIa9vB29sM7Iqy9WKfKKPwnyEpHz7CRMAjlctrJXWPwEfNf6142lmUyb3ayNwdGirkCxhvdjF23A0GZ3uBCbkjTpMMg9mVXzcAtrUhErbZfXrkG+KjP+kcMlIVS4fGcqkF9DtvHwgeztGphP+hTQ2PyHPugDxJclbEKJt4C6KzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HMppCoZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMppCoZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A5DC2BCB2;
	Thu,  7 May 2026 21:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778191123;
	bh=C2h75DAEriP1SjOL1VnaMQkqbHXp77CRB+xsgGMaL+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HMppCoZ1Dd0znumyrfOlCyIMzU/fw+bmat56iMblvpC7bIULpWNZz6dUInih0303O
	 btr7u5sLWsRNuy83WFv3SZPeb6uHIGTTZBT1zHhw+y23QMuM2QUWp3FJgIt7IBt/Nw
	 p/dPfrRjc22PJZsg8CB36roKOQ+CPu/g6SYzzT3HRxBlvlV2DPpjhsIzFWXh6MB3jB
	 AbulegrOj5jsHMs9sC3hRtvcofXH+33tUGu8xSsTLBSNkeKJYpEHNXjUbNDjDH5NwK
	 4Qlzvv0Re4IWJbwpgrNwT/+Y+U7Rf6P+pLl5e3X1vOoZNnHHGPWGOe6YLrgySoK2Xx
	 0TsuuHRkaOR4g==
Date: Thu, 7 May 2026 21:58:41 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Blaise Boscaccy <bboscaccy@linux.microsoft.com>,
	linux-crypto@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	=?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	James.Bottomley@hansenpartnership.com, dhowells@redhat.com,
	Fan Wu <wufan@kernel.org>, Ryan Foster <foster.ryan.r@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	Song Liu <song@kernel.org>
Subject: Re: [PATCH v7 00/10] Reintroduce Hornet LSM
Message-ID: <20260507215841.GA440717@google.com>
References: <20260507191416.2984054-1-bboscaccy@linux.microsoft.com>
 <CAHC9VhR0Abikk+2=DWtVu1cEkcwkudKFRJH51BFOh0Qt01wLJw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhR0Abikk+2=DWtVu1cEkcwkudKFRJH51BFOh0Qt01wLJw@mail.gmail.com>

On Thu, May 07, 2026 at 04:57:35PM -0400, Paul Moore wrote:
> On Thu, May 7, 2026 at 3:14 PM Blaise Boscaccy
> <bboscaccy@linux.microsoft.com> wrote:
> >
> > This patch series introduces the next iteration of the Hornet LSM.
> > Hornet’s goal is to provide a secure and extensible in-kernel
> > signature verification mechanism for eBPF programs.
> >
> > Hornet addresses concerns from users who require strict audit trails and
> > verification guarantees for eBPF programs, especially in
> > security-sensitive environments. Many production systems need assurance
> > that only authorized, unmodified eBPF programs are loaded into the
> > kernel. Hornet provides this assurance through cryptographic signature
> > verification.
> >
> > The currently accepted loader-plus-map signature verification scheme,
> > mandated by Alexei and KP, is simple to implement and generally
> > acceptable if users and administrators are satisfied with it. However,
> > verifying both the loader and the maps offers additional benefits
> > beyond verifying the loader alone:
> >
> > 1. Security and Audit Integrity
> >
> > A key advantage is that the LSM hook for authorizing BPF program loads
> > can operate after signature verification. This ensures:
> >
> > * Access control decisions are based on verified signature status.
> > * Accurate system state measurement and logging.
> > * Log entries claiming a verified signature are truthful, avoiding
> >   misleading records where only the loader was verified while the actual
> >   BPF program verification occurs later without logging.
> >
> > 2. TOCTOU Attack Prevention
> >
> > The current map hash implementation may be vulnerable to a TOCTOU
> > attack because it allows unfrozen maps to cache a previously
> > calculated hash. The accepted “trusted loader” scheme cannot detect
> > this and may permit loading altered maps.
> >
> > 3. Supply Chain Integrity
> >
> > Verify that eBPF programs and their associated map data have not been
> > modified since they were built and signed, in the kernel proper, may
> > aid in protecting against supply chain attacks.
> >
> > This approach addresses concerns from users who require strict audit
> > trails and verification guarantees, especially in security-sensitive
> > environments. Map hashes for extended verification are passed via the
> > existing PKCS#7 UAPI and verified by the crypto subsystem. Hornet then
> > calculates the program’s verification state.  Hornet itself does not
> > enforce a policy on whether unsigned or partially signed programs
> > should be rejected. It delegates that decision to downstream LSMs
> > hook, making it a composable building block in a larger security
> > architecture.
> 
> [NOTE: trimmed changelog for brevity]
> 
> > Blaise Boscaccy (6):
> >   lsm: security: Add additional enum values for bpf integrity checks
> >   security: Hornet LSM
> >   hornet: Introduce gen_sig
> >   hornet: Add a light skeleton data extractor scripts
> >   selftests/hornet: Add a selftest for the Hornet LSM
> >   ipe: Add BPF program load policy enforcement via Hornet integration
> >
> > James Bottomley (3):
> >   crypto: pkcs7: add flag for validated trust on a signed info block
> >   crypto: pkcs7: add ability to extract signed attributes by OID
> >   crypto: pkcs7: add tests for pkcs7_get_authattr
> >
> > Paul Moore (1):
> >   lsm: framework for BPF integrity verification
> >
> >  Documentation/admin-guide/LSM/Hornet.rst     | 323 +++++++++++++++
> >  Documentation/admin-guide/LSM/index.rst      |   1 +
> >  Documentation/admin-guide/LSM/ipe.rst        | 162 +++++++-
> >  Documentation/security/ipe.rst               |  68 ++++
> >  MAINTAINERS                                  |   9 +
> >  certs/system_keyring.c                       |   1 +
> >  crypto/asymmetric_keys/Makefile              |   4 +-
> >  crypto/asymmetric_keys/pkcs7_aa.asn1         |  18 +
> >  crypto/asymmetric_keys/pkcs7_key_type.c      |  44 +-
> >  crypto/asymmetric_keys/pkcs7_parser.c        |  81 ++++
> >  crypto/asymmetric_keys/pkcs7_parser.h        |   1 +
> >  crypto/asymmetric_keys/pkcs7_trust.c         |   1 +
> >  include/crypto/pkcs7.h                       |   4 +
> >  include/linux/lsm_hook_defs.h                |   5 +
> >  include/linux/oid_registry.h                 |   3 +
> >  include/linux/security.h                     |  28 ++
> >  include/uapi/linux/lsm.h                     |   1 +
> >  scripts/Makefile                             |   1 +
> >  scripts/hornet/Makefile                      |   5 +
> >  scripts/hornet/extract-insn.sh               |  27 ++
> >  scripts/hornet/extract-map.sh                |  27 ++
> >  scripts/hornet/extract-skel.sh               |  27 ++
> >  scripts/hornet/gen_sig.c                     | 401 +++++++++++++++++++
> >  scripts/hornet/write-sig.sh                  |  27 ++
> >  security/Kconfig                             |   3 +-
> >  security/Makefile                            |   1 +
> >  security/hornet/Kconfig                      |  13 +
> >  security/hornet/Makefile                     |   7 +
> >  security/hornet/hornet.asn1                  |  12 +
> >  security/hornet/hornet_lsm.c                 | 352 ++++++++++++++++
> >  security/ipe/Kconfig                         |  15 +
> >  security/ipe/audit.c                         |  15 +
> >  security/ipe/eval.c                          |  93 ++++-
> >  security/ipe/eval.h                          |  11 +
> >  security/ipe/hooks.c                         |  63 +++
> >  security/ipe/hooks.h                         |  15 +
> >  security/ipe/ipe.c                           |  14 +
> >  security/ipe/ipe.h                           |   3 +
> >  security/ipe/policy.h                        |  14 +
> >  security/ipe/policy_parser.c                 |  27 ++
> >  security/security.c                          |  75 +++-
> >  tools/testing/selftests/Makefile             |   1 +
> >  tools/testing/selftests/hornet/Makefile      |  63 +++
> >  tools/testing/selftests/hornet/loader.c      |  21 +
> >  tools/testing/selftests/hornet/trivial.bpf.c |  33 ++
> >  45 files changed, 2112 insertions(+), 8 deletions(-)
> >  create mode 100644 Documentation/admin-guide/LSM/Hornet.rst
> >  create mode 100644 crypto/asymmetric_keys/pkcs7_aa.asn1
> >  create mode 100644 scripts/hornet/Makefile
> >  create mode 100755 scripts/hornet/extract-insn.sh
> >  create mode 100755 scripts/hornet/extract-map.sh
> >  create mode 100755 scripts/hornet/extract-skel.sh
> >  create mode 100644 scripts/hornet/gen_sig.c
> >  create mode 100755 scripts/hornet/write-sig.sh
> >  create mode 100644 security/hornet/Kconfig
> >  create mode 100644 security/hornet/Makefile
> >  create mode 100644 security/hornet/hornet.asn1
> >  create mode 100644 security/hornet/hornet_lsm.c
> >  create mode 100644 tools/testing/selftests/hornet/Makefile
> >  create mode 100644 tools/testing/selftests/hornet/loader.c
> >  create mode 100644 tools/testing/selftests/hornet/trivial.bpf.c
> 
> [NOTE: added the linux-crypto list to the To/CC lines]
> 
> Hi crypto folks,
> 
> You'll notice there are three patches from James Bottomley in this
> patchset that touch crypto code and I'd appreciate it if you could
> take a look and either ACK the patches or let James and Blaise know
> what you would like changed.  James did send these patches to you for
> review some time ago, so they aren't necessarily new, but I wanted to
> make sure you saw them again.
> 
> Unfortunately, it doesn't look like the crypto list was CC'd on this
> patchset, so here is a lore link to the patchset as a whole:
> 
> https://lore.kernel.org/linux-security-module/20260507191416.2984054-1-bboscaccy@linux.microsoft.com
> 
> ... and here are lore links to the three crypto patches:

We discussed before how the actual signature check seemed to have been
overlooked in some cases, due to the complexities of PKCS#7
(https://lore.kernel.org/r/20260305185016.GC2796@quark/).  Looks like
that was fixed.  It is really hard to do any meaningful review of a
PKCS#7 based system, though.  And it sounds like this one is proceeding
anyway due to some requirement to be compatible with an existing PKCS#7
based system.  So I'm not sure what you're looking for.

- Eric
