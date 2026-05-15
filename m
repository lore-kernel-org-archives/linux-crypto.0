Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7771A3F5BC7
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879722; cv=none; b=gKM0mMSTJgiTMg12xSzSfXM/vMC+xOv0PzvjMsxyKxp+yt5vzlhptLwYyfeWpyfwvjequM/LhnwuiFCOk85hC7SHrSC49JuCubxt5E9BIQQ4kdOYyh0O1ENv6g23EiQuL+3IZe9yphXO5ZZj8z5ghnahElmkQNAn8m9sxOMarAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879722; c=relaxed/simple;
	bh=EYoiytDPHAwrp//ZCSS8x2mbpMMq39lmGS1yWEcEk0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4ZteSkf4XrWP+zGTS0wLWYs5vs/ZKi2RhN6PkD9WFJ5mYvCSKtCfInULxWhMRBdk5O0x5AreH5/1p7i2mnIljvO/2VDlt0rPzRR6NDbiQ4RtmsNuhidzfVobdPwrgoCGSQARfmx7RGKdrX/OUei2C7mPRsRycKlXcxBqIJD1pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F1qUkByA; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1qUkByA"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2ee1054627bso1072017eec.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879721; x=1779484521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bjgxy9jrMUn+tA5MZsUkk9qLfIPrTHgv6m9jj+0YWR4=;
        b=F1qUkByArkNhkX8Vb784ExX/rl6QJS4DBW18WWjmqir3frGenB8qERsSXnGvklGLAv
         P95lUGWZ/GjM5Y8NDhtwk+h7BAZdVVuhvyz3q5hRMQNdOwOddJhcvGUoFa/vXVClvFKe
         wqjcw/pK5nDmkWn+eoT576g/DS1UOQF6lw1/oFI5+Mv5RZ6s3bdSJPul7HgcuiSoNehY
         aqCyhEYdbq1d7DY9fGbSDrwyFgxPSFLNb2nXjUjBvJQ/+WY7nO+CLHiKS8na6SFKYbbN
         kICn8lsE/ST/LYMxnVpC+KaX+OIkFBQXRIJmARETvIikWBupy+rK2Nc8yIpJ4zTTneK/
         i97Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879721; x=1779484521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bjgxy9jrMUn+tA5MZsUkk9qLfIPrTHgv6m9jj+0YWR4=;
        b=VdgV1ltO52Mr3E5mQe2Y3mJz8pRrtywfCcesHHeTLRbpmUqq4HR4lWUvxgOIpVV/0j
         nPnhioKVQbIFJL/y/mJqBa5/m5U8LUxTDacgYlzzjYq53RykRwo5Bk9QfvR8II9jysDi
         /Ny06ClYxrZxdQ/AXzM3B86C3EhoQFM1iVll1J5vcQhEb8TeTnnP+T9rqh2CilES0xUF
         1T39mRbGbbILlsT4EfcY72Tf9psP17U9t7HCnBAEEXK53A56VkDNp4KdpR3ASCe93l6+
         BY2mEJ0Itgc0/16tnj7yIRRGlSmTh2A+/2b3ZZK6XenmLbrrBxDHOi50qTJpY7VH1Oju
         83XA==
X-Forwarded-Encrypted: i=1; AFNElJ9yq2Um8a6JJmRn3DCDCYO3dkWMZOPgt/joDQy6j2v3WWLh77M8ofx9mqCGUFDPiP5hxy0NlhwzvaL+I/c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKz51e47K1dSrKbj716nqW853XeAS1/wAluFqb+9+gF0FFRUCx
	zJ2l87cd0vKdi343Bys3diz7E/Hj3gyvgxY8T/JUX0gofBnfMPERAwgU
X-Gm-Gg: Acq92OHdiWHCfACv7iwhwILLMrN808J5aAVZmM9NFo+LramUbmlSpYQG5qnM05wLSx3
	EGrRahBZjted0P03lna8V3RvVxrgqJObzd6h+a09U5IB9oBMDxTVXVqg16JXgR8kjb2fxkuLXkk
	JsqjKfV4Gl70zEnPjJjkM7ibQ4DdxnJ78/YBvUSgXJpj05MLHgt+sl+rpP2LdUdaKvoLVFshoAX
	Xm2nAKA9NwtEmn+S1XGe9tt76AlBW86EpnopHWJALBaocglS0jB7wFy+3Ieh0Omo9lyxcNn7nMy
	oaduYLTc8S9n+zCLEHiXfid38Bg3ugcCFTuaYVxPOPCTcgcmgL4gYSupsZ6XYJBNgSNpQFxOdjM
	aL4n1FKJu7Y7jXyU5L1GvawB6l0AIkL8kSCimhVoWksIDFJDBxUeWRLBcuriD+Sy+JZ7o2t7UPq
	8omfDG0rVYE31Ns/gmJy/e7pOBroV9eio=
X-Received: by 2002:a05:7300:2316:b0:2f3:5d44:eeba with SMTP id 5a478bee46e88-3025fa54325mr4525827eec.6.1778879720563;
        Fri, 15 May 2026 14:15:20 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30293e2e3c0sm9975127eec.3.2026.05.15.14.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:15:20 -0700 (PDT)
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
Subject: [PATCH v16 24/38] x86/msr: Add variable MTRR base/mask and x2apic ID registers
Date: Fri, 15 May 2026 14:13:56 -0700
Message-ID: <20260515211410.31440-25-ross.philipson@gmail.com>
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

Add the MSR values required by Secure Launch to locate particular CPU cores
during application processor (AP) startup, and restore the MTRR state after
an Intel TXT launch.

Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 arch/x86/include/asm/msr-index.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 6673601246b3..2a95e3389622 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -408,6 +408,9 @@
 #define MSR_IA32_RTIT_OUTPUT_BASE	0x00000560
 #define MSR_IA32_RTIT_OUTPUT_MASK	0x00000561
 
+#define MSR_MTRRphysBase0		0x00000200
+#define MSR_MTRRphysMask0		0x00000201
+
 #define MSR_MTRRfix64K_00000		0x00000250
 #define MSR_MTRRfix16K_80000		0x00000258
 #define MSR_MTRRfix16K_A0000		0x00000259
@@ -960,6 +963,8 @@
 #define MSR_IA32_APICBASE_ENABLE	(1<<11)
 #define MSR_IA32_APICBASE_BASE		(0xfffff<<12)
 
+#define MSR_IA32_X2APIC_APICID		0x00000802
+
 #define MSR_IA32_UCODE_WRITE		0x00000079
 
 #define MSR_IA32_MCU_ENUMERATION	0x0000007b
-- 
2.47.3

