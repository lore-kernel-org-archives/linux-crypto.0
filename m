Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579033EBF3B
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879655; cv=none; b=YHQe1FgNnftUBLjkP+aji7UPLT2ix6FXBBxzIiQfh/huzbAznoq7Fg0SQ2uUetSqGLk5sa6adWdFyoJ/NR3TjrruC2JbA1WG1IQvD8zdSTSIDcITn395Jo/J/pH/16BF/Ia8F2aCBFdsHEqC53qqMl5KLNY7rt37G70FbYrrt1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879655; c=relaxed/simple;
	bh=rFYaUaAT16Cmq71pIwaII1M5sgICxN3WJjU+oZD6zvs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W8DbAmKXiTQDPSkzI1Q9UCOW6lt32KvLPpi9LJYwx+H5H9fN4hOlNQxW090DQ/RIhSWAQKMez54K1lC05HAFSpE2wkaBQTu/+uZsh6MbOHhZ7Q1y8Okc/bqXsaAjR7GNfVzHiYvebYUQ6aw4Zss6zzN4b9gyRiIizcxP1iNvrMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eh7qIjCV; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eh7qIjCV"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1332772f6b3so283158c88.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879652; x=1779484452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mZWDYSQL0KY9ESsVCDJnFdENr1SKqKscOsf4LFzsjVs=;
        b=Eh7qIjCVEsaKhcH/uTf8ZTh1yNmAdX4amJcXFgk5WpPvfyincAYECewqjQHDXk47Yj
         DtMzo7AP3wKhjTRcQ62aSFvaRoBNJKlfQV21wO6lNJQ0/5sU9M4DpaSC5grOo7TEHxQ6
         fEMLYX+Ea6Juv+TO7vzSTW95oTuDmFumWkqjH8QyISYaJTz5mOwRDh3xx6SwVQEh0suH
         fvdHqrNnkYdfs3Y9YTOtrTj6U+FO+rudKMghwdwhmznPK3MFQvVRSMMSzYO/SNkIpqCL
         0iiPnMIqxLQaDUpm7g8X8gd3uZCEzF4xSHzOZjVsQSFPE1s8pr6Df5Gs5ntr9ytUbCqq
         XGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879652; x=1779484452;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZWDYSQL0KY9ESsVCDJnFdENr1SKqKscOsf4LFzsjVs=;
        b=hj4hSZ6L29ggasKiqFdZt2JR9zpWHxLdiF+nuCK/vK98O0s6v/UT9gTU315oTGJu3E
         LgSwsCVFY1cERezJVz7TweKD2z9DJKqy9TiZDE817YnCV6JeQ7tsnHRrVS50/8InYzAR
         ncYj9vZai96NMIOZ8tNMht29+fLoBAqrqxwEKSxu923lpAkOD8/pe0Yn3qfV+nQ3IPX7
         m9t1hl4MQP7BikogLeobDady/v65XPVA2xaZ0exzMRdeYu8rIQH4RknoFA8f525lYECN
         nmm5JbCRNRDoI4xnDgnDgcHaZLcx1FmKRk2F5ZMYxBRAt8X392UVkqDfh0USRcKb+9ru
         NwCg==
X-Forwarded-Encrypted: i=1; AFNElJ8SOUjGrkm+ThDLpa+58o71OBjTa7bNNiAL/0VGDOcclj9oFNmms6VArkxYftvhrsiccVJef897bolgTIg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8nxDRZe25SQlxG0qezaWn/t/6YJFF7oSOPd/iHLB0DXtWtnUK
	87BE27YfZah341zCYvvKxtWhCgvinLaBZENh1/OU2IqcEgUD6jEjdBgi
X-Gm-Gg: Acq92OFkYMgwCO8fjPEdrdTUezewU3aq6H0NyD16K5ocpck3oK/GCvsqTt9nZxpe1gg
	m5LJyLeyHc+1uO8WMvGJyarm+KTPl31+hqHCoRY9jBAwaph/0d/dlCkqgElbPRtPK9rRDU/wEgd
	CrLYdjrap0zdjtO5Lkc1uv8ovz+IA9nqDt+4sV2cagRXKq2MpCAQ/CwVKjmQRkLVln1GYx+VQJM
	qdAt2MstyM6Z3z8AAge3ctfSv9sIqRrDkK8bgadVRiNhs+ms1E9Y9AtjxLkY/zvr/WpFh6bsL3I
	P3jWEZ0Z7RtA0qapgAEXMpZNirL71KvK/k4pSjNBgQKe5w2QeI5T91LeuXWkpfz7HCzcZncgXYm
	BLw8sunzZEs1lTQdUhFknsj5wKZOlPBompS92mAM5pZPVOrKunsvYeZDDrjCIV8qEHdeSPnPxyr
	X57uEFaB0KQw4d+KEXpssPtFVIh86VGIQ=
X-Received: by 2002:a05:7022:b8f:b0:130:6978:c96 with SMTP id a92af1059eb24-13504738d6cmr2812237c88.19.1778879652253;
        Fri, 15 May 2026 14:14:12 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cbdcf140sm11362043c88.5.2026.05.15.14.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:11 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-efi@vger.kernel.org,
	iommu@lists.linux.dev
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
	jgg@ziepe.ca,
	luto@amacapital.net,
	nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	ebiederm@xmission.com,
	dwmw2@infradead.org,
	baolu.lu@linux.intel.com,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v16 00/38] x86: Secure Launch support for Intel TXT
Date: Fri, 15 May 2026 14:13:32 -0700
Message-ID: <20260515211410.31440-1-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Secure Launch is a vendor-neutral approach to implementing TGC Dynamic
Root of Trust (DRTM) support in the kernel. This is complementary to
better known Static Root of Trust (SRTM) schemes such as UEFI
SecureBoot.

This series provides the common infrastructure along with Intel TXT
support, without needing the tboot exokernel. Support for AMD SKINIT is
pending the common infrastructure getting nailed down, and ARM are
looking to build on it too.

Originally, tboot were approached to see if they'd take support for
other vendors, but they elected not to. Hence this approach instead.

Work is being coordinated by the Trenchboot project,
https://trenchboot.org/, organising Secure Launch support for upstream
open source projects including Grub, iPXE and Xen. The goal of the
Trenchboot project is to make DTRM easy to use, e.g. GRUB adds "slaunch"
as a command in the boot stanza. See
https://trenchboot.org/user-docs/QUICKSTART/#linux-quick-start-guide for
more details

Patch set based on commit:
torvalds/master/028ef9c96e96197026887c0f092424679298aae8
(tag: v7.0) Linux 7.0

Finally we would like to thank everyone for their input and
assistance. It has all been very helpful in improving the quality of
our solution and in reviewing/strengthening our security posture.

Thanks
Ross Philipson and Daniel P. Smith

Changes in v16:

 - Moved Secure Launch entry point out of the x86 setup kernel into the
   mainline kernel.
 - Add EFI protocol support for DL stub callback.
 - Add SHA 384/512 PCR extend support.
 - Rewrote Secure Launch kernel documentation.
 - Updated the reorganization of TPM header and buffer related files.
 - TXT early heap parsing support.
 - Corrected commit messages and tag lists per review feedback.
 - Fix code formatting and typos.

Changes in v15:

 - Rewriting and reformatting of the cover letter, commit message and
   code comments per requests from maintainers.
 - Introduction of a early TPM driver in the x86 setup kernel to allow
   TPM extend command very early in the boot.
 - Remove previous TPM extending architecture that attempted to update
   the TPM PCRs later in the boot process.
 - Include set of split up TPM header files to allow TPM driver reuse
   in other environments (e.g. early kernel, x86).
 - Split slaunch.h into 2 files, with a new txt.h. The former contains
   platform agnostic definitions for the SL feature. The new txt.h file
   contains Intel TXT definitions from the public specs.
 - Split TPM headers up following the specifications where the
   technologies are defined.
 - Fix code formatting and typos.

Alec Brown (1):
  tpm: Remove main TPM header from TPM event log header

Ard Biesheuvel (3):
  x86/boot: Slight refactor of the 5 level paging logic
  x86/efistub: EFI stub DRTM support for Secure Launch
  x86/boot: Legacy boot DRTM support for Secure Launch

Daniel P. Smith (9):
  tpm/tpm_tis: Close all localities
  tpm/tpm_tis: Address positive localities in tpm_tis_request_locality()
  tpm/tpm_tis: Allow locality to be set to a different value
  tpm/sysfs: Show locality used by kernel
  Documentation/security: Secure Launch kernel documentation
  x86: Add early SHA-1 support for Secure Launch early measurements
  x86: Add early SHA-256 support for Secure Launch early measurements
  x86: Add early SHA-384/512 support for Secure Launch early
    measurements
  x86/slaunch: Secure Launch late initcall platform module

Jarkko Sakkinen (3):
  tpm-buf: Merge TPM_BUF_BOUNDARY_ERROR and TPM_BUF_OVERFLOW
  tpm-buf: Remove chip parameter from tpm_buf_append_handle()
  tpm-buf: Implement managed allocations

Ross Philipson (22):
  tpm: Initial step to reorganize TPM public headers
  tpm: Move TPM1 specific definitions to the command header
  tpm: Move TPM2 specific definitions to the command header
  tpm: Move TPM common base definitions to the command header
  tpm: Move platform specific definitions to the new PTP header
  tpm-buf: Add TPM buffer support header for standalone reuse
  x86: Secure Launch Kconfig
  x86: Secure Launch Resource Table header file
  x86/efi: Secure Launch Resource Table EFI definitions header file
  x86: Secure Launch main header file
  x86/txt: Intel Trusted eXecution Technology (TXT) definitions
  lib/crypto: Add SHA1 support for pre-boot environments
  lib/crypto: Add SHA512 support for pre-boot environments
  x86: Allow WARN_trap() macro to be included in pre-boot environments
  x86/msr: Add variable MTRR base/mask and x2apic ID registers
  x86/tpm: Early startup TPM PCR extending driver
  x86/slaunch: Add MLE header and Secure Launch entrypoint to the core
    kernel
  x86/slaunch: Secure Launch kernel early boot initialization
  x86/slaunch: Secure Launch kernel late boot initialization
  x86/slaunch: Secure Launch SMP bringup support
  kexec/slaunch: Secure Launch kexec SEXIT support
  reboot/slaunch: Secure Launch SEXIT support on reboot paths

 Documentation/arch/x86/boot.rst               |   8 +
 Documentation/arch/x86/zero-page.rst          |   1 +
 Documentation/security/index.rst              |   1 +
 .../security/launch-integrity/index.rst       |   9 +
 .../launch-integrity/secure_launch.rst        | 681 ++++++++++++++
 arch/x86/Kconfig                              |  15 +
 arch/x86/boot/compressed/Makefile             |   2 +-
 arch/x86/boot/compressed/misc.c               |  55 +-
 arch/x86/boot/compressed/pgtable_64.c         |  18 +-
 arch/x86/boot/startup/Makefile                |   8 +
 arch/x86/boot/startup/exports.h               |   7 +
 arch/x86/boot/startup/lib-sha1.c              |   6 +
 arch/x86/boot/startup/lib-sha256.c            |   6 +
 arch/x86/boot/startup/lib-sha512.c            |   6 +
 arch/x86/boot/startup/sl_main.c               | 638 +++++++++++++
 arch/x86/boot/startup/tpm.h                   |  47 +
 arch/x86/boot/startup/tpm_drv.c               | 567 ++++++++++++
 arch/x86/include/asm/boot.h                   |   4 +
 arch/x86/include/asm/bug.h                    |   8 +-
 arch/x86/include/asm/msr-index.h              |   5 +
 arch/x86/include/asm/realmode.h               |   3 +
 arch/x86/include/asm/txt.h                    | 281 ++++++
 arch/x86/include/uapi/asm/bootparam.h         |   3 +-
 arch/x86/kernel/Makefile                      |   3 +
 arch/x86/kernel/asm-offsets.c                 |  22 +
 arch/x86/kernel/reboot.c                      |  14 +
 arch/x86/kernel/setup.c                       |   3 +
 arch/x86/kernel/sl_stub.S                     | 847 ++++++++++++++++++
 arch/x86/kernel/slaunch.c                     | 619 +++++++++++++
 arch/x86/kernel/slmodule.c                    | 353 ++++++++
 arch/x86/kernel/smpboot.c                     |  47 +-
 arch/x86/kernel/vmlinux.lds.S                 |   5 +
 arch/x86/realmode/init.c                      |   8 +
 arch/x86/realmode/rm/header.S                 |   3 +
 arch/x86/realmode/rm/trampoline_64.S          |  32 +
 arch/x86/tools/relocs.c                       |   1 +
 drivers/char/tpm/tpm-buf.c                    | 148 +--
 drivers/char/tpm/tpm-chip.c                   |  35 +-
 drivers/char/tpm/tpm-sysfs.c                  |  31 +-
 drivers/char/tpm/tpm.h                        | 180 ----
 drivers/char/tpm/tpm1-cmd.c                   | 193 ++--
 drivers/char/tpm/tpm2-cmd.c                   | 338 +++----
 drivers/char/tpm/tpm2-sessions.c              | 144 ++-
 drivers/char/tpm/tpm2-space.c                 |  57 +-
 drivers/char/tpm/tpm_tis_core.c               |  24 +-
 drivers/char/tpm/tpm_tis_core.h               |  64 +-
 drivers/char/tpm/tpm_vtpm_proxy.c             |  30 +-
 drivers/firmware/efi/libstub/Makefile         |   1 +
 drivers/firmware/efi/libstub/efistub.h        |  24 +
 drivers/firmware/efi/libstub/x86-slaunch.c    |  38 +
 drivers/firmware/efi/libstub/x86-stub.c       |  27 +-
 drivers/iommu/intel/dmar.c                    |   4 +
 include/keys/trusted_tpm.h                    |   1 -
 include/linux/slaunch.h                       | 262 ++++++
 include/linux/slr_efi.h                       |  40 +
 include/linux/slr_table.h                     | 339 +++++++
 include/linux/tpm.h                           | 234 +----
 include/linux/tpm_buf.h                       |  57 ++
 include/linux/tpm_command.h                   | 516 ++++++++++-
 include/linux/tpm_eventlog.h                  |   4 +-
 include/linux/tpm_ptp.h                       | 151 ++++
 kernel/kexec_core.c                           |   8 +
 lib/crypto/sha1.c                             |  10 +-
 lib/crypto/sha512.c                           |  10 +-
 security/keys/trusted-keys/trusted_tpm1.c     |  37 +-
 security/keys/trusted-keys/trusted_tpm2.c     | 171 ++--
 66 files changed, 6385 insertions(+), 1129 deletions(-)
 create mode 100644 Documentation/security/launch-integrity/index.rst
 create mode 100644 Documentation/security/launch-integrity/secure_launch.rst
 create mode 100644 arch/x86/boot/startup/lib-sha1.c
 create mode 100644 arch/x86/boot/startup/lib-sha256.c
 create mode 100644 arch/x86/boot/startup/lib-sha512.c
 create mode 100644 arch/x86/boot/startup/sl_main.c
 create mode 100644 arch/x86/boot/startup/tpm.h
 create mode 100644 arch/x86/boot/startup/tpm_drv.c
 create mode 100644 arch/x86/include/asm/txt.h
 create mode 100644 arch/x86/kernel/sl_stub.S
 create mode 100644 arch/x86/kernel/slaunch.c
 create mode 100644 arch/x86/kernel/slmodule.c
 create mode 100644 drivers/firmware/efi/libstub/x86-slaunch.c
 create mode 100644 include/linux/slaunch.h
 create mode 100644 include/linux/slr_efi.h
 create mode 100644 include/linux/slr_table.h
 create mode 100644 include/linux/tpm_buf.h
 create mode 100644 include/linux/tpm_ptp.h

-- 
2.47.3

