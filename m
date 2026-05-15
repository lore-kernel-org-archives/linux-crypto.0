Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAB43EDE5B
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879700; cv=none; b=QN2SnwDaMhRjSb+46IkJxXElLDQqOghWYseBJkUwYNVErCCj3ugH/oX9xDK5pvEew67a3rqrK187CgiMKK2KA99gDoTnE8a9rn0Hzd9MEI8fW1+dFOD1hhzarfaPe8oKESO3PRUXAB0dXcrg9/OA6l5yjzThu5Aioz4z7IEXuBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879700; c=relaxed/simple;
	bh=/w4xIQd+FodWBf21xbEabPQcoqxxR+rnVAOAKm/PKP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTWQylY8aZ+sVlGQJvAEquF6rMdIML+mnoWeJQq+hnfmoRIvfRJFB923Z0dlgsr16N8tSGPQwgOFkfn0onQBonCLS5Xgbd/f5YkbEvSCMvVQVHUe7XdWo/GJn30u1+oupez0cfJVGoUj9jaLbc5VmUEzG1PoSQZ/UezPLdQd+lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NAUkQYe1; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NAUkQYe1"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2f3c623322bso1043636eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879698; x=1779484498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFOHDGCsOHbtZzrbMRrMDpLy4uq6fKhTRLiSKMVovBw=;
        b=NAUkQYe17YCwOkozqdU8CpMHWdUFgHS6zfI0Ca2ILTLzMf2tiipFVvSkcGZcm/Vgv9
         f8KEgse7WVm8d40kJddfU5qHJ7TbmtZZ9ZkaGR+rzkMct56vQpK5+h3Fsjqf42Di81AP
         zXblzjiLSj9yR7kZYhaSZlfFC+m78FgXqQNMD2x7IUyePyMWN5Ejv6UozaIP747+A4Af
         olt8sJ2zM8qz67HNBxVo8J3K33CGhOndM/yfhuS40Pm3WRAfEiYHCe+zPCzvX2U0wWSz
         ZRjNUNmR1iPXSD1f82xgt6JlXOYaYMNiuh0+zcrN7zOI6ZQzCGbFqcQipX9Qf8piThzb
         ybFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879698; x=1779484498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aFOHDGCsOHbtZzrbMRrMDpLy4uq6fKhTRLiSKMVovBw=;
        b=YzO3Z8Eom8ZCUYGoe3N4VmetqwW4iDG2D/7SWWT0tP0FFnBdpxY6gmA05Ak+FShex5
         UppkcFbxT1+q163wQZTwOi1D1DhpiYE9XbdwpviopWwMhFVusOgT+vs3P+wq3shfJlv+
         hQb0qDfh8bNfYyifv/WBRoo4BOtR5iafkUBU1p4V959eZkAupKYEw46nEGJuTRJrDRWU
         wCyw+hvD8XUE6AiqyoP1eWQC6uhJwtZ8gGw4oNIsLI8sij8WBaWpos18V7tnaH7Os6Ii
         Mpa2mTp0DuZKKpABbciJblaBPOLIrihYHLn1orRZxjAvYpCYYyG7ESDvSBm8DXTB0gX2
         Pm1Q==
X-Forwarded-Encrypted: i=1; AFNElJ/BUBdp1Z28zJnAD274irWOIHpbKxSgLm/U7VJ6g7es0U7RtwivURlf4ucllgk8xuv2asQPqE425kWdU8k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTsMZ9sPPH3lmrFCpyBKuFyEB9WikfZYa+UcKD5FJbdr1I/NWg
	i0Mtvf0YEois2L60XssA6uK8lL6ZrRfcPXONQ+SsHykyjf8U26myJ1Fi
X-Gm-Gg: Acq92OHxwlbCLO4UTYdsVKW5Q7s8C4xb7Moj54JnUNZ9CHxLN5erjJy57mCaEVwfq41
	a6cdBb7MkP/ZqD2xyhUF5J2wnKBdM2sCDTs2Rrb3kCG1U9bq7M5cQGv8CtLQNDd8vycu1swLGPS
	rdZWU+BC/PM5zNkL1YNj+WEqq1QP301fYIURZxe9zOW4G0d8TLNzL28rj/S7V7YiH044RaMBm8m
	Z+Jrb6k6TQUoHUFOCViaGgRYDxVNJvGFeW4f9Oa6eLRsLjZsjwlxXKVPC/i20wBTivStMIqexFE
	2V9W0DwBES6AgO8EcN0NdQj2U3Zebzh1DgJVUwaO0DGwJ8nxJ8+nHwq2XRn5LooUXsXXdw7Nv59
	+qyOLen3CCPH4mo2/CFhfdgNv03/CaaK9n/zOjaMh0Lvx0v7rAkhJskFPMzYYJ0CXi5b58a/f38
	VXbAyo/acJ49ZihqI3Cuo6TMqC8p9GhLVNZEhr0XmENg==
X-Received: by 2002:a05:693c:8386:20b0:2df:919f:ce59 with SMTP id 5a478bee46e88-30398678a48mr2108609eec.19.1778879698427;
        Fri, 15 May 2026 14:14:58 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302973bbd50sm7961724eec.20.2026.05.15.14.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:58 -0700 (PDT)
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
Subject: [PATCH v16 16/38] x86: Secure Launch Kconfig
Date: Fri, 15 May 2026 14:13:48 -0700
Message-ID: <20260515211410.31440-17-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515211410.31440-1-ross.philipson@gmail.com>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an x86 Kconfig option for compiling in/out the Secure Launch feature.
Secure Launch is controlled by a single on/off boolean.

Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 arch/x86/Kconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e2df1b147184..fd9edb0651d9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1989,6 +1989,21 @@ config EFI_RUNTIME_MAP
 
 	  See also Documentation/ABI/testing/sysfs-firmware-efi-runtime-map.
 
+config SECURE_LAUNCH
+	bool "Secure Launch DRTM support"
+	depends on X86_64 && X86_X2APIC && TCG_TIS && TCG_CRB
+	select CRYPTO_LIB_SHA1
+	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_SHA512
+	help
+	  The Secure Launch feature allows a kernel to be launched directly
+	  through a vendor neutral DRTM (Dynamic Root of Trust for Measurement)
+	  solution, with Intel TXT being one example. The DRTM establishes an
+	  environment where the CPU measures the kernel image, employing the TPM,
+	  before starting it. Secure Launch then continues the measurement chain
+	  over kernel configuration information and other launch artifacts (e.g.
+	  any initramfs image).
+
 source "kernel/Kconfig.hz"
 
 config ARCH_SUPPORTS_KEXEC
-- 
2.47.3

