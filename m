Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5DF3CAE74
	for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 16:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783785695; cv=none; b=tY6xpcoAG2+bT3WHK5OheXoAA/56XZD8PUJC5S8SRfUUV6I34HKjzlakSQgpi2Z9SRfiB06Im+ZjtmxrfChj8eh9ZdexoZyprRioPwqBPPFrpxWQs3q759ClqVpCevl3QziWF469kplRlRH5/Ov/TK/hXNsaYawzt61JtJL0P2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783785695; c=relaxed/simple;
	bh=SWTmQxbm+O3CiuFQm/Zj3X9aRzkg0EYTJlhP8g+50ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcVaRm4OilFRaUNpW163GbRit61oOXflH7DfXTCfT16AFs4c3BySXRsSTjVOZseyu0oVXN1+QnNL+hE0OrF4Wht3HpIFXLY5TT/EOlSKyU3WIljW33MEhYHBqFDaFGgt9HAAakbHSA4FgWOHJ1ocGqZuIhdOdS7UkYXLW9CWN08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g8t864WG; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8t864WG"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2c7cfa17fedso26790445ad.3
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 09:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783785694; x=1784390494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h8PdlfVA45gq99DCqpKxVhIV4ifAok/KN5VEGME0LcA=;
        b=g8t864WGg/9SeihPvThSlxO6aPm1JKP+lZV5uqf4SxOGm5cSaLmszjo+qTr6W6Mk4i
         i14kRKNOH832Rpk8M5BB5PtKC7VLJXcSEJRneJywRQLIH7R+XR6FXOCnazpwyzxwdZ/T
         gnRXjR2omx7pImL8ZekUjMxErBXvDvNakGBHgedgE8h3Z7I6OZjO083vHKk4ULtAcUt5
         kCG5ZtX94y7CNTHg+Rdj6YLPfn0RFSmlQ7bbXidPQJxboDwLUtlaijiOD12HagX4tLKe
         njOr4SDL/GGhi9XkSB3VneKsmO+ngrX2jI9elAcoD6bzhp4TAGfNTFDyTAjci6Myf+dn
         byUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783785694; x=1784390494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=h8PdlfVA45gq99DCqpKxVhIV4ifAok/KN5VEGME0LcA=;
        b=b2zyvW1ufYvoArrgJRhR1SQR330bgwhznvK5Hq1JqPj2YxRbVyyNbB5OoO+40ThVXt
         hSuaTE8ODEsyEVu3/wkgFcG2ImgsByuR6wwo4c7jsokLNn0aSCQTKUerWRWxpAmdVXn6
         8TqwS7om5IVLVoycIp5nkAJCb/NA0qK9oBthvM7kCO30n9o+SwEqKVhAkHZSlz8U67ET
         VWYtRrPiX4yDcr+0fmDt1mfnZzvAGL72gd8qEjiLY1ULXmg8nKmJgwrjm/+K/l2UqkzE
         fwAQLUsgMeghr8qRz4lm5uBbHJ8zZ1Y0dBrVtgI2277Fxnin03cz6l+hoKUmxXGmZ7VH
         gMFA==
X-Forwarded-Encrypted: i=1; AHgh+RoH94yqbTMcw66vRNkHMeKQdT6HT3cjE+KAp83Tlj9o1U11/FRh46RHjiZjwVXLcYzupDHbicql/gGjGJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqHCqYU5B5SzRL9acr+9S1d9TjkI0LjuH9rY1WQeVr2GIcvL9b
	eECtZzXJvTVhaP8Gc2GlAhoM0kA6Xc5h99IPOuzx1lf31PF43A4fmzye
X-Gm-Gg: AfdE7cnXZaL+ibI7D936Z6pGyEVEoZVngSO9mqVCe0KS5jXBpq3P798Ue1NNe7iX4G0
	YmRwpyKmWCqxp5eVyXCcRO80I1sfng2QfUAHvuyf9tlZubFrslP+PMkxVHkgwxsC5/tLVtoPpT+
	JxpEh0yYW2XaixDy8/4M+xNTCJYWrMCxAbEb4d2HcZsy7+Fgr7BdNIYdRKwAhmWi8UZP0sQPFOG
	+7CHdQ7OQVQ3b60bCZISBEceOhN/RbTGQl10TYhq/rQ7gctBQqIcBDfPsb9dTpTfbfCPnrPpAXC
	CS1vNSmLBcP4xTIdGAvF5UPIK1zaD9bNjHvqxqkP6l74gLcX1y6meYlnmB8bkBJlKqG501Z847P
	F4hAF2yaBxraLZ53bS6gKgUa/Op3GKRyPDiPE4oe/1MoP/TrKBL1Jbx0SvjkMQ4L3yRVQqMXeMA
	zxx6CnoaEabst0qdN1T1+z
X-Received: by 2002:a17:90a:da83:b0:384:d509:7274 with SMTP id 98e67ed59e1d1-38dc75f63bemr3176054a91.15.1783785694020;
        Sat, 11 Jul 2026 09:01:34 -0700 (PDT)
Received: from titan.lan ([2603:8000:df01:38f7:255c:dd03:30a6:e57b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3118ee6091dsm54498068eec.14.2026.07.11.09.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 09:01:32 -0700 (PDT)
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
Subject: [PATCH v2 06/10] tpm: Remove main TPM header from TPM event log header
Date: Sat, 11 Jul 2026 09:01:06 -0700
Message-ID: <20260711160110.267780-7-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260711160110.267780-1-ross.philipson@gmail.com>
References: <20260711160110.267780-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alec Brown <alec.r.brown@oracle.com>

Allow the TPM event log functionality to be used without including
the main TPM driver definitions.

Signed-off-by: Alec Brown <alec.r.brown@oracle.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 include/linux/tpm_eventlog.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
index aff8ea2fa98e..40fe92eb7deb 100644
--- a/include/linux/tpm_eventlog.h
+++ b/include/linux/tpm_eventlog.h
@@ -3,7 +3,7 @@
 #ifndef __LINUX_TPM_EVENTLOG_H__
 #define __LINUX_TPM_EVENTLOG_H__
 
-#include <linux/tpm.h>
+#include <linux/tpm_command.h>
 
 #define TCG_EVENT_NAME_LEN_MAX	255
 #define MAX_TEXT_EVENT		1000	/* Max event string length */
-- 
2.55.0

