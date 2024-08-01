Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD011A4879
	for <linux-crypto@vger.kernel.org>; Thu,  1 Aug 2024 17:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722534014; cv=none; b=EgDGZuExQX1tVVYD/7CjZn5H86aXZiq0trA0x4wVTcuDPphQA6Pdp5aPTEx9UoPJrG2XBlt3n2TnBY+DHVTnXi2tMoZNrykyWAfdGlpBj2SvuIr1hh1oG1nb5vUAD7Ek2V5kN9jIPReUtXWbe6DyXOTpY+gIYwsMwnLZgfHJn2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722534014; c=relaxed/simple;
	bh=gFGo8dOk0VJiQQUAK+INl3O/L32blZxmPO2Im/Zhcug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mREKQNfeDJasD1SrIAfuiDO1umv+BOTzrTC/FP3SaDX9ZL0h6T/mhMZQFzyeHSZZBZ9FmZad8GNdY+qPdzBzSKcb7tow9azzvtOR5Vgq0eir7e3ljbncS7R5BRPpIU0kcLDuSVuCAh6R9CmCAqFPpm6/V2QysrZR8qVoTQdGSpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OZi04dbC; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OZi04dbC"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-70ac9630e3aso6215645a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 01 Aug 2024 10:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722534011; x=1723138811; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L9VNzcyRkgABAvNu7jY6d4RP7mTe7rlkrOwsOOfnmQw=;
        b=OZi04dbC4YohYTyZFyrDikJQv7t8knE0is19AJqU7c4cCehqJfnQUXQc9IGQ9Ws7/3
         kdFVv3D1YuUdvz8yYM2V/zearerAwrslg/9IT3+UGZLBEF2TJmTKTWX9QccShrVb3Jv2
         UTRbeUDHW8zmFbbmqmWpvG7xywxbZxPx0i64CxpnYN2FFoilw3TFcZ0etNFW38FDRjhj
         DhVjTz/5fKcXkZCM5Uh7QQy2qeLefQR4SqflmfCi25HqASIbMmfuae99GUPRlJZE+h2f
         HrkZYWHymCzzkBiuHl6qENNgriQk+9QvE74DmLMsKAIhjAOXA9kMOOWbQHzQ3PBmPpTU
         YR5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722534011; x=1723138811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L9VNzcyRkgABAvNu7jY6d4RP7mTe7rlkrOwsOOfnmQw=;
        b=h1PjMr8yEq8oKSH/lW4waJipyHPf5yUyhYdcMxMPxMeOI5/Yf2mByCXDsEWbs+4mNL
         mRznHD4cjZl8XyzhJOMGU5gyM8iIAS4y/GHU8cqGJqnNhZCqlnU/pu1HsNGPuQZpjyBp
         NMyjCmdOF8Ppq5Ed/NHgfT2MYpwWnFX6YkxZbeITHWbBf2U6N4VCoqGtuAo1DuK52XQS
         6XJA9G3aek3RH+5lztruZlOjbVjJOo9/7qVqQBBAu/lDu1u8G+eenHsTOd0DhUu3NhtF
         jcsvWkajkS6/fCE+N2tNi3Exk6xazD4wKXzJH6seVyIAiQaXy6VDldsm4ezB51ZAEmx0
         LqdA==
X-Forwarded-Encrypted: i=1; AJvYcCXD8YVZN2t5F7hj4uGdbqY38OjZlnCUEMriHSw+WfWKYbdRLNHxouwmy3vrdCwvTlfjJ+Z8mMRdiSyZcNRmn4hYWx7HaDHGr4zIn/P5
X-Gm-Message-State: AOJu0YzZqX/UDJVe5O4vuHzOupuk+qSewBTASeF2p91aVu9IWuEp5x4v
	3pxF41YygGDiZbruXFJwo+Z6UcWUGmVlTxC6oGIsPZvRPxR05w0UidCMoxIh5wPmMi6+HPjJl+F
	pXQrjhwnp53ZnflQywOqk9A==
X-Google-Smtp-Source: AGHT+IGhpTZuKcEDE5QRQXsOfcY0PWgiRoUFns4CRvhbi/uTvBIXM/nvEmpt5cbQN5GWFoFa60I9eNfSq5lwKOiQpw==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a17:90b:e8a:b0:2cf:deef:4261 with SMTP
 id 98e67ed59e1d1-2cff954f844mr31201a91.7.1722534011252; Thu, 01 Aug 2024
 10:40:11 -0700 (PDT)
Date: Thu,  1 Aug 2024 17:39:55 +0000
In-Reply-To: <20240501085210.2213060-3-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240501085210.2213060-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240801173955.1975034-1-ackerleytng@google.com>
Subject: [PATCH] Fixes: f32fb32820b1 ("KVM: x86: Add hook for determining max
 NPT mapping level")
From: Ackerley Tng <ackerleytng@google.com>
To: michael.roth@amd.com
Cc: ak@linux.intel.com, alpergun@google.com, ardb@kernel.org, 
	ashish.kalra@amd.com, bp@alien8.de, dave.hansen@linux.intel.com, 
	dovmurik@linux.ibm.com, hpa@zytor.com, jarkko@kernel.org, jmattson@google.com, 
	vannapurve@google.com, erdemaktas@google.com, jroedel@suse.de, 
	kirill@shutemov.name, kvm@vger.kernel.org, liam.merwick@oracle.com, 
	linux-coco@lists.linux.dev, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org, 
	mingo@redhat.com, nikunj.dadhania@amd.com, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, peterz@infradead.org, pgonda@google.com, 
	rientjes@google.com, sathyanarayanan.kuppuswamy@linux.intel.com, 
	seanjc@google.com, slp@redhat.com, srinivas.pandruvada@linux.intel.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, tobin@ibm.com, 
	tony.luck@intel.com, vbabka@suse.cz, vkuznets@redhat.com, x86@kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

The `if (req_max_level)` test was meant ignore req_max_level if
PG_LEVEL_NONE was returned. Hence, this function should return
max_level instead of the ignored req_max_level.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Change-Id: I403898aacc379ed98ba5caa41c9f1c52f277adc2
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..e6b73774645d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4335,7 +4335,7 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
 	if (req_max_level)
 		max_level = min(max_level, req_max_level);
 
-	return req_max_level;
+	return max_level;
 }
 
 static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
-- 
2.46.0.rc2.264.g509ed76dc8-goog

