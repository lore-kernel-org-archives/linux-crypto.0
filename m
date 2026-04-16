Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59503A0E8E
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 23:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776381836; cv=none; b=OWKWdpVqna6tNg6ouyO2+Ckhhfqzc5+yAYQAnwo5rwC46q7EYqkKJ7o/GEEGHYx+m9PHFytC7kfEwxkTR8tQJE/yBis3q16tBXpGPZy9+dCu106pj5evTjheJne0onqN1qd8YOG45NUjG7zhJJXy7Jz5sTAsQ8JmEWoScRahas4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776381836; c=relaxed/simple;
	bh=5y9MQzmnNdA8fG73zq4cTMXDW78U5CKZAEWBePI7SwQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gXkwmLW28FUw2HvnUUHgnatogka0o2lV2E7DwVtHh1PG1XWnEyJLdMUKeoZtDMYsf3gSoGVJS/zee9iYwXxF/IO/k3Cuacpxx/wpgUzrfXLgdtkuaeyQWRUAIE3+Xp2jX8sDAQQ6AUkXEQNatOQlzyvYNsaQtbJdPITS28aRZEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PzwauzUp; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PzwauzUp"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82cf8dcd079so66590b3a.1
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 16:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776381829; x=1776986629; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=I8i9cxkTxORgkUnwzKhG1n+FrAvtgU2d9BkG0Hg1zPQ=;
        b=PzwauzUpASwgA6Rj6RSH/q/ggEzXA3HKTbyVkWG1uAoF3sCfi5COqAqDYQLeCpn8GT
         NLwfGNqeffYtBy0zYjeWImLvN9NxX54tQNlmwiO/OTfwi3SDKtCaQnc6a8UlQqS+wTsS
         NVuxPsev8iFHCre7Z3bnpSpLY2Ch+GfV616PsqcIVojJPkI9dVlQpIJBgSJz91GOvwIs
         67AZbA+PcbdOZ1q0E0mGZL27mjX/AioEbWFK0zOrYJAoSBrck4SK8F5pljwHnlitY1LZ
         S81Mu3d3ToOI+eiXviqP8b6v9LLYUyWwWJqzrpiqDiDpPVES+JMxJ0iuG7hG1aImBmwi
         ZNrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776381829; x=1776986629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I8i9cxkTxORgkUnwzKhG1n+FrAvtgU2d9BkG0Hg1zPQ=;
        b=HNFn5TXxmTt1xIlR0gBZeA/5uRfHA8GzvWuYaP3Iq8PcOqTYYMRrY83kurJr815Hh6
         oO/jd4rdXpo+0DBRxqfMJVC0L5qgqHQae9iCz4ySrsTZOlDkPs6chyaErebmCKEhPGC4
         D1B85t03gWRIDwxh1qLrFunJM+Bx8UIEwHRwsEmSK91hCUEV2rpMjcFSwiUK1sVFXpFR
         H4nL60IUbMiwvaT3TOKfqAuelEuNK+/0HDMN0+jbAwYxepQNNrHzWPcaZzLO0AMT8llO
         Lt3ePw/9kolbWHnlbp00z9c12qfv4PaGIktkpspijE4Cz9IgYDDn0C8Ja9Nmpd2MbJhr
         kfKg==
X-Forwarded-Encrypted: i=1; AFNElJ+f6MMdZGu9Vwwz7l0VuZwJCwDEOyfYnXwVBI++BZX+w8QefbaYvshucaw5/9htyoUl3SI1ItcmL3/cqBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUX2xWYrgKFEfFAGD4bVdId8SwhxNDIKIoGekahLHWIJH+yEOk
	bk3icCspMi+0F0xg2SpgOgItyHLgU6id9odV3fc/EoE8syBFx35kWRxVnnIFPAJarYMriLPijGA
	OD2cSWQ==
X-Received: from pfbdo20.prod.google.com ([2002:a05:6a00:4a14:b0:82f:120:fd71])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:928b:b0:82c:212a:a9b5
 with SMTP id d2e1a72fcca58-82f8c8df69fmr245291b3a.36.1776381829092; Thu, 16
 Apr 2026 16:23:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Apr 2026 16:23:28 -0700
In-Reply-To: <20260416232329.3408497-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260416232329.3408497-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.513.gad8abe7a5a-goog
Message-ID: <20260416232329.3408497-7-seanjc@google.com>
Subject: [PATCH v3 6/7] KVM: SEV: Don't advertise VM types that are disabled
 by firmware
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	Tycho Andersen <tycho@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Tycho Andersen <tycho@kernel.org>

As called out in a footnote for a recent SNP vulnerability[1], it is
possible for a specific flavor of SEV+ to be disabled by the firmware even
when the flavor is fully supported by the CPU and platform:

  Applying mitigation CVE-2025-48514 will result in disabling SEV-ES when
  SEV-SNP is enabled.

Restrict KVM's set of supported VM types based on the VM types that are
fully supported by firmware to avoid over-reporting what KVM can actually
support.  Like KVM's handling of ASID space exhaustion, don't modify KVM's
CPUID capabilities, as the CPU/platform still supports the underlying
technology and clearing e.g. SEV_ES while advertising SEV_SNP would confuse
KVM and userspace.

Link: https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3023.html [1]
Link: https://lore.kernel.org/all/aZyLIWtffvEnmtYh@google.com
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
[sean: rewrite changelog to provide details on why/how this can happen]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0971cf652b0b..ab386aa0c284 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3202,6 +3202,7 @@ void __init sev_hardware_setup(void)
 		vm_types |= BIT(KVM_X86_SEV_ES_VM);
 	if (sev_snp_supported)
 		vm_types |= BIT(KVM_X86_SNP_VM);
+	vm_types &= sev_firmware_supported_vm_types();
 
 	kvm_caps.supported_vm_types |= vm_types;
 
-- 
2.54.0.rc1.513.gad8abe7a5a-goog

