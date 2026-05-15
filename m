Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5904D3F5BF6
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879726; cv=none; b=lxzlbRwfYtFBw6M2n6mneMLCWMv7j1+OX2IX8oCxTFdNqXTFc5yHHSeZP3BHlSpejgLaLzyJwyUtJ+JPdNF6zR2ZocCPRzO4XOKIZrYugUD8hWeQKEga13INlWSTzjS4ljjB/XWw5nBZ8s8Z8CEF+AYrlNgGdiKhUCfxMPm6Qj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879726; c=relaxed/simple;
	bh=DULLarGA3N2WbmTOoIAH6Z6cAJNNwTwfc+oSbMTDbH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADWLd8wGDrkEFjdQMcA1+/gqXHukfs5qDG9K2el6NshuM6gZAfa32NCVZoMq43VK/EigCuMRhm80trM4TMU6NNtGrXkC8/7g38QEnNHwPuyX7UF0NGoideY3pJI/Hlx2lX+7w1D9EXu52kI1mN0QV+nfXh7R6Wg4mPP3aSNqJN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GfxRkan2; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfxRkan2"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-30246cfd41aso1513785eec.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879723; x=1779484523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ER4IWQsMKw/HNZSo0sHiz6UgahZlpRSMvCUCrr/URAk=;
        b=GfxRkan2jXb/hDtBDF0b2sCZ9HhiKP1Jj/yCjehZ+FkCiZlTYroSSQI6ZCBGNx/FBH
         nB/APZdgfAjcUw2LfZ3ELWjaOwm/EVaIrw6+uWbd46OCgIH2/r/rsmi8lFGVmYlCYmz5
         iihILkrwP8lqd2Dn4bjCqFt+vijLcekhje43yv4KJ8blEx7Jga1xd2AM5HfyT9v3Etfa
         aBW7LDioHVaE1M7oNwRvB5TxwC+2TRLlsekBab0tgxFWaCbgvF+FxIoX0AAFL6kw9CJV
         rm/gWOxfdEdyOeJakpFiJ9XLMAElhxeMRQzo54xa/6YGBaLUk0AH3FHDfgIQiVMNwZMb
         i+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879723; x=1779484523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ER4IWQsMKw/HNZSo0sHiz6UgahZlpRSMvCUCrr/URAk=;
        b=GkIFa1EsWqyneBnnJ7T324EQuVPpXx1CI7Yc9Ty0RqcWub/KG4jC2nbGtPj5H8TeBH
         MT8Tl3FD3cQkejh3YaZej+lJDJC7xW/5zz+zOfN+gVFjNDxTNoSJHhsiRp2MgesziqFg
         7AR7kwWXxJrGR1r2AD9gHeWSLpXb8yV1g7WY5Wsh+G8YjHC6nezf5+84OP14SoYOje1p
         scUV6Hr0zBjgS70H1f/jI89UqUQbOxfvNzHv0vdcdDQbi6mwaW+gwzuaFDPnlR782tJP
         nKkpBy64nLl1PRFGVPKBJ2h7OiW8QbIVUKBiU3n8qEmEhi7nrfSRyRng5U9Qf2m9cJRL
         1K+A==
X-Forwarded-Encrypted: i=1; AFNElJ+q8SQsm8UIDMTLNmHgIO6CnjEezJTO3hNt7+MQBY1OUICGnAGzvo1C7JPaN7ADSyuDbgTtirFXragIPcs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7vAvMMo4kuBnw11t4ICl9IEBIQukxhiugYAMGJ9m9TgFnJUYb
	L8ldwSK0qoJmurmz/fB6IRjwhiKFLvrcIpTxmJBaLOStueWSNdzoLtyC
X-Gm-Gg: Acq92OFNTySmQ6pVOPyTxOasnur8zNE+Sl1fW5KL6/NTKrozXg8jkPKXIK1STOvWDFr
	FNOHkVWMduA4RqDRYHAnAiJBV3K7na0Ro076LUoehdNIXuDLo5ULQKbf5j9b3m1bFeXhUt+gmWY
	h5XiX6UE/XSa8mAV6SNUDndaLyVm77Ng1QkPFayibo2osiK/Tz1MFcJGwFrTl511OW/08VYm5oe
	1BSgBljJVjQgJywCwXZ3Ut+f19ml7l9eAjyvvdXHAnD7VKQ+rrjqMRcxhQUS1Bzj2/HDm9cx+dq
	M79r+XHSr4rjdgedqfLaamUCBgSkixDLoOs4uJqLV52MQ1Vxiyx+twOIxpr+wZfOJChzjC9XO3Y
	VdHtr8zp7wTPdcAC7pekUOThjsIpDGbzKPK9bknXe2C3fU1OxM5gEATQY76AdyGcWNHfzCJmxhL
	AiNR+J+NDTECWKzbLN5l1FVFys+/0UlAVKN4LIx4AxxA==
X-Received: by 2002:a05:7301:4184:b0:2f4:3a9c:818c with SMTP id 5a478bee46e88-303986b1521mr2959973eec.29.1778879723496;
        Fri, 15 May 2026 14:15:23 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cbcb9ef5sm10736508c88.2.2026.05.15.14.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:15:23 -0700 (PDT)
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
Subject: [PATCH v16 25/38] x86/boot: Slight refactor of the 5 level paging logic
Date: Fri, 15 May 2026 14:13:57 -0700
Message-ID: <20260515211410.31440-26-ross.philipson@gmail.com>
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

From: Ard Biesheuvel <ardb@kernel.org>

In preparation for adding Secure Launch support, which will require that
the number of paging levels remains untouched, tweak the logic slightly
so that the slaunch check can be inserted easily.

No functional change intended.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 arch/x86/boot/compressed/pgtable_64.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/pgtable_64.c b/arch/x86/boot/compressed/pgtable_64.c
index 0e89e197e112..3e9d651da73e 100644
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -102,6 +102,7 @@ static unsigned long find_trampoline_placement(void)
 
 asmlinkage void configure_5level_paging(struct boot_params *bp, void *pgtable)
 {
+	bool l5_enabled = native_read_cr4() & X86_CR4_LA57;
 	void (*toggle_la57)(void *cr3);
 	bool l5_required = false;
 
@@ -118,10 +119,12 @@ asmlinkage void configure_5level_paging(struct boot_params *bp, void *pgtable)
 	 *     + CPUID leaf 7 is supported
 	 *     + the leaf has the feature bit set
 	 */
-	if (!cmdline_find_option_bool("no5lvl") &&
-	    native_cpuid_eax(0) >= 7 && (native_cpuid_ecx(7) & BIT(16))) {
-		l5_required = true;
+	if (native_cpuid_eax(0) < 7 || !(native_cpuid_ecx(7) & BIT(16)))
+		return;
+
+	l5_required = !cmdline_find_option_bool("no5lvl");
 
+	if (l5_required) {
 		/* Initialize variables for 5-level paging */
 		__pgtable_l5_enabled = 1;
 		pgdir_shift = 48;
@@ -132,7 +135,7 @@ asmlinkage void configure_5level_paging(struct boot_params *bp, void *pgtable)
 	 * The trampoline will not be used if the paging mode is already set to
 	 * the desired one.
 	 */
-	if (l5_required == !!(native_read_cr4() & X86_CR4_LA57))
+	if (l5_required == l5_enabled)
 		return;
 
 	trampoline_32bit = (unsigned long *)find_trampoline_placement();
-- 
2.47.3

