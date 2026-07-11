Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9ABC225417
	for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 16:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783785675; cv=none; b=FEWFKAhPDa+Hg+VtUVuheaqIPUL3hMDQKPVIkl1nuWffo6E9uHIwJbONPBZ6S+xkm2CtekuqFGU6Pi4SjPGmZItkAjFdonNRl6ZyrZnGuxLV6orvk2+dHXmzffUE3+xVKx7uW/gzJmJmY4/qCYNbTJoZ2eOf4Nl0yk8rNBOz22c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783785675; c=relaxed/simple;
	bh=N7RC+uZRrlKgQQELyWXcXycrqlZe8qncc17h5i528c4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qGhkt4le38UlhZvUDmMHDMT9TmkqLR4yggeuClg+z3D8tI4Nfo2env530RvsIuQ4eFhL0uyPY+mIdOYAeg/QVFtqhvHUDPRoBwqAkDo2JFh1t2FalJt4glmVglrGR7S6k7VobZJZlluOt020bjG36EtEV3DdWIZ8p4V8o10qeko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h1sn6KvL; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h1sn6KvL"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3810c5d691bso1561242a91.1
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 09:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783785673; x=1784390473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JayLLvpAgBylhvulp5IdQiUHgZ6NsRSyedzXc8seza8=;
        b=h1sn6KvLpn5hppyIM0tn+DMR6xwsCKmcQlqpWfWpIrnmj1ZoT02vejWpDz22WVCOgM
         xecWQn80Jpuqqdvd/0UmtgFx1fDnub+Swf7i9Vmp9OquronEK3D61xZC/4hYtWbBPO1J
         zdoILp+W+eqEt4TQ5Q8Cdw/p2DtSY/gQbeujFfbq86dYBbrvmR1+p0lSlDCdBT15uYXm
         lOauePim5VCd4EouaPCasFzZnkVNHfUlUTUnPiwoUpNt7u177W9ObjulC3xZhdRSyQ2y
         84NHn3JKFIvElaZDAnolY/reDNPHCpyVPajsYVTEwJE4pLxlkOAMGOvvnV3z4ighe2+K
         aMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783785673; x=1784390473;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JayLLvpAgBylhvulp5IdQiUHgZ6NsRSyedzXc8seza8=;
        b=KPZxrsFnJBbe/C32Xa2l9Rr14sqITDRqlDAD3XFjrodcylGuQ8tAPLh8b0+uuh8nte
         m28bWBFSvjT7HfbFYDSjjlRCyoESPt1Qpnd3rkKu4RQ7FsE+1lAgQR6VJLVQJjG34vdR
         hRBZ47dYX+snDXtdfkTByCOtvI1kJvJkM++7kHAsXlZ6G4o8QpXlqS+xGkH0ib9mGFv4
         t8BvyeFGWGYVjzoHLQQuSLJ9cb9kMtk1Ws1gt0qpt9xkfthuKfNEJ2a/xH0n1iJ3D7Xu
         JIXo/R3qXXw2CvADPNAoCRIWlXF1LdiIdFLCzB/CBdlwpxN4uagt6ljAK8Zeu6MOHA9C
         7pbQ==
X-Forwarded-Encrypted: i=1; AHgh+RoCBsAEJC8YVsqn0toSpAu2Gsi/YFGHjkzgVEkq7VYB37/fofo1MzuEdyQo2Dwpml3FRmQy1/nX2TdM3dU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzfbX7cuiqHV9UjaPw6LyzVSG8hN7/ybSmWSqXL4EBskOUQ3yT
	ALxKGxR45g+O7tnInVtyw9NMNGpGU9bQk4WdQRFCCcwUFfrsBnNQLMrR
X-Gm-Gg: AfdE7cntYnt2z47Bz51NOGLGY9w3+kGt3vIyQsVigdPKnx8ic7G6WAaQRVD7vbZbQf9
	EUELzmjrJyXfIwWPFbQTnMjFsjrUUXFg8Pyf8jcYT6DUZEdb0E+C0ruwM4Ae1zWF2G/8Dp99bQx
	19XYZivAmpvaTAnKDh10O/WDHVpHGiYrz9orbY8Oi56J9BCXbUKrlDUjWRqDGojrB+ayElF7Imb
	GN06uurNpHVHzc3AsF8tvYmjDeuCgTOZO05b8BMmLylfbvgROkTOGceknnJ3qm2lSyaAa5cYsvr
	CiCe5nglewf53QW7g4Zlr6sN1qo4q6E9WYn31vjhrvnu0cLMILz8UF768uYcAiNeo32055yK8L4
	U0ufA5FOimXdghQW3/4I2ZOUTQlDZd05L52n8XflOtXBFeKB9tDWsY4n0TijMoesQtvAW4C7DAY
	aZoEfXzixdk+puk0wQv5Vw
X-Received: by 2002:a17:90b:4c49:b0:381:270c:4dd1 with SMTP id 98e67ed59e1d1-38dc774d270mr3079721a91.20.1783785673221;
        Sat, 11 Jul 2026 09:01:13 -0700 (PDT)
Received: from titan.lan ([2603:8000:df01:38f7:255c:dd03:30a6:e57b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3120c8e41fcsm20951952eec.15.2026.07.11.09.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 09:01:12 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-efi@vger.kernel.org
Cc: ross.philipson@gmail.com,
	dpsmith@apertussolutions.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	dave.hansen@linux.intel.com,
	ardb@kernel.org,
	mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com,
	peterhuewe@gmx.de,
	jarkko@kernel.org,
	luto@amacapital.net,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v2 00/10] tpm: Reorganize public headers and extract tpm-buf for standalone reuse
Date: Sat, 11 Jul 2026 09:01:00 -0700
Message-ID: <20260711160110.267780-1-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series reorganizes the TPM subsystem's public headers for better
modularity and maintainability while extracting the `tpm_buf`
abstraction into a new standalone header (`include/linux/tpm_buf.h`).
The goal is to allow other kernel components to construct, parse, and
manipulate TPM commands, responses, and TPM2B-sized buffers without
pulling in the full set of TPM driver headers and implementation details
from `<linux/tpm.h>`.

Key elements of the series:
- Split version-specific (TPM1/TPM2), common, and platform-specific
  (PTP) definitions out of the main headers into dedicated files
  (tpm_command.h updates and the new include/linux/tpm_ptp.h).
- Clean up include dependencies (e.g., remove the main TPM header from
  the TPM event log header).
- Refine the tpm_buf implementation for improved memory safety and a
  cleaner API suitable for standalone use.
- Introduce include/linux/tpm_buf.h (with helpers for
  init/reset/append/read operations) so the buffer logic can be reused
  more broadly (e.g., by security subsystems, measurement architectures,
  or early-boot components).

This work originated in the TrenchBoot/Secure Launch development tree
but provides general benefits to the upstream kernel by reducing header
coupling and enabling safer, more reusable TPM buffer handling. It
builds on prior refactoring efforts and incorporates improvements for
robustness.

Note on this version: This is a breakout of the TPM driver related
changes from the Secure Launch v16 series. As it includes Sashiko review
changes, it is being considered v2. Another noteworthy change is the
replacement of patch #9, "tpm-buf: Implement managed allocations", with
the recently posted variation titled "tpm-buf: Memory-safe allocations".
Additional API cleanups were made to the tpm-buf code to better support
standalone reuse.

Version note: This series extracts the TPM driver-related changes from
the Secure Launch v16 series as a standalone patchset. Because it
incorporates the Sashiko review changes, it is now designated v2. A
notable update is the replacement of patch #9 ("tpm-buf: Implement
managed allocations") with the recently posted variant titled "tpm-buf:
Memory-safe allocations." Additional API cleanups were also made to the
tpm-buf code to improve its suitability for standalone reuse.

Series based off: torvalds/master
dc59e4fea9d83f03bad6bddf3fa2e52491777482

Thanks,
Ross Philipson and Daniel P. Smith

Changelog:

- Replaced "tpm-buf: Implement managed allocations" with "tpm-buf:
  Memory-safe allocations": New implementation uses fixed-size
  kzalloc(TPM_BUFSIZE) (or stack-backed) buffers with explicit capacity
  tracking, strict __tpm_buf_size_invariant checks, improved TPM2B
  handling, and validation during init/reset/append to prevent overflows,
  size mismatches, and potential memory corruption issues associated with
  the prior __get_free_page based approach.

- Updated "tpm-buf: Merge TPM_BUF_BOUNDARY_ERROR and TPM_BUF_OVERFLOW":
  Simplifies the error flag handling in the buffer abstraction by
  combining related overflow/boundary conditions into a single, clearer
  error state.

- Updated "tpm-buf: Remove chip parameter from tpm_buf_append_handle()":
  Makes the handle-append helper more generic and independent of struct
  tpm_chip, improving its suitability for standalone reuse outside the
  core TPM driver.

- Updated "tpm-buf: Add TPM buffer support header for standalone reuse":
  Refreshed to build on top of the new memory-safe implementation, the
  merged error codes, and the chip-parameter removal for a cleaner, more
  reusable public API and header.

- Header reorganization patches ("tpm: Initial step to reorganize TPM
  public headers", moves of TPM1/TPM2/common/platform definitions to
  command/ptp headers, and removal of main TPM header from event log
  header) are retained with the same overall structure and intent; they
  benefit from the refined tpm-buf code and minor consistency adjustments.

Alec Brown (1):
  tpm: Remove main TPM header from TPM event log header

Jarkko Sakkinen (3):
  tpm-buf: Merge TPM_BUF_BOUNDARY_ERROR and TPM_BUF_OVERFLOW
  tpm-buf: Remove chip parameter from tpm_buf_append_handle()
  tpm-buf: Memory-safe allocations

Ross Philipson (6):
  tpm: Initial step to reorganize TPM public headers
  tpm: Move TPM1 specific definitions to the command header
  tpm: Move TPM2 specific definitions to the command header
  tpm: Move TPM common base definitions to the command header
  tpm: Move platform specific definitions to the new PTP header
  tpm-buf: Add TPM buffer support header for standalone reuse

 drivers/char/tpm/tpm-buf.c                | 145 +++---
 drivers/char/tpm/tpm-sysfs.c              |  26 +-
 drivers/char/tpm/tpm.h                    | 180 --------
 drivers/char/tpm/tpm1-cmd.c               | 180 ++++----
 drivers/char/tpm/tpm2-cmd.c               | 321 ++++++--------
 drivers/char/tpm/tpm2-sessions.c          | 164 ++++---
 drivers/char/tpm/tpm2-space.c             |  57 +--
 drivers/char/tpm/tpm_tis_core.h           |  64 +--
 drivers/char/tpm/tpm_vtpm_proxy.c         |  30 +-
 include/keys/trusted_tpm.h                |   1 -
 include/linux/tpm.h                       | 230 +---------
 include/linux/tpm_buf.h                   |  60 +++
 include/linux/tpm_command.h               | 518 +++++++++++++++++++++-
 include/linux/tpm_eventlog.h              |   2 +-
 include/linux/tpm_ptp.h                   | 133 ++++++
 security/keys/trusted-keys/trusted_tpm1.c |  45 +-
 security/keys/trusted-keys/trusted_tpm2.c | 166 +++----
 17 files changed, 1237 insertions(+), 1085 deletions(-)
 create mode 100644 include/linux/tpm_buf.h
 create mode 100644 include/linux/tpm_ptp.h

--
2.54.0

