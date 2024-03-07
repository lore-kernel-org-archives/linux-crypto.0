Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCDA12FB2A
	for <linux-crypto@vger.kernel.org>; Thu,  7 Mar 2024 15:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709825948; cv=none; b=qu4v7gkJuRp+j2xJlYEyK/XbLSrkwqIGSNCMYMKV1ktTPi+P5ElLE5JHTNT56FhzwVtLDh/xFCoaHv+PxeijYOIIikllBCOa9QTUj+hWasmQaj/3pOXObXvxJrLPmAgVxlP0boIrlGHmHwwb5Xq/TWXljlrYbauhfbUwE3TEvoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709825948; c=relaxed/simple;
	bh=A0O6/w7bbUy1TrcLSjuH9e83BoPYKup6oiJvr7VavE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4nuu0PEJ/u/AVgQk7WN1WAYV6hi69KMboI7PA8yQUyfy9UMbMQiULwRzzN03aMMarjdMBfnfCTPLSpWPWZHHrYKP9iPSlgrF7G9jTG7DnkBIiqeHKnOy3RxQkDC5IEmVfyOt2AFbEhGicyCrktEaZD0eOVAjt+BIgJLoi96jzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=JAvWO9KN; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="JAvWO9KN"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d29aad15a5so12055951fa.3
        for <linux-crypto@vger.kernel.org>; Thu, 07 Mar 2024 07:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1709825944; x=1710430744; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s5byLpxSkDHpWtFqk+o0iXmSYvszrS7+YdXxWavlXQY=;
        b=JAvWO9KNPCWPeNiKas3mCKiB18zgWaGnFoppsCH7DfyWJx7CHooFSfJDD90LGuKjew
         wrS4oJIJtLpO+rFHNsBjHa2wlo22w4+4+UTYWgm1Q34YiGe7fnh6BmLu3mWEQkRSKbeC
         EQUGztP2DxfJjxVPDMgPxDQyhF/ivSacxEgIlygjozM1SIe5AyK4ubpdcfslNlNmh/Lf
         VUuM45cRJL0o1Twq05Ai/NDpZFPTy/ls16uRBcNzeuCpl9Qi+Y/8FeMM4ivJ40NXZaLs
         udq4jjOVQQlro9TwSR7BYmZIVlNvsNeadmj8R6Trk0kI8HhdppjqkTC+nIgYJ8WXmcUL
         cMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709825944; x=1710430744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s5byLpxSkDHpWtFqk+o0iXmSYvszrS7+YdXxWavlXQY=;
        b=Mx5y+oMUNnAV5An3eoWWdWJDPqEi4ACi7i2HNdC+dAzKkOQYJrmRY9FubRj8OTiinM
         sMT83e1De2Wnbu3Xj0O4DLrcd/osCpxO9o/eW/KqfG4aCOGzc5e3AsUzLoRawE5p5tkK
         4FdfKl1qZCYJKmNKQyWcAVV0x6lQf9PxLnNwOVBiyWp2q+F096rJR2BnC3+XS2hkzzso
         Byh6bhhQ91g6qKonyPZlCm+fvDQg5gwZjvMtkH2lncoB5DWwZn9RUvlNOrg26RnNpDqf
         pD2Mk4zM7ffV8zm5YgxXsJRe+rmE9dMAPe561QS0DLdyR8hdQ4yt+R/Q4OMd70D0s5O2
         HMUg==
X-Forwarded-Encrypted: i=1; AJvYcCXjZoNx6ymZgEHXFy5HGI1T4XaD8l/we5mKlAh1YFggd9mElO01nyEe+SqX5ZInW41fKNOyV1p3zPbZsTPQQd1sv7n/biwW8pQZQnGJ
X-Gm-Message-State: AOJu0YzEupnvJbhq5Bcwr5Hu2/DN3YrZSetVp2BnTeafE6y9Lp8grg7c
	WC6n3Cc/+kb1tkAUcfpL5YUy0rdy+VjWCiTfAAcsBrYMaoRROESd9ujNAcoP4Z0=
X-Google-Smtp-Source: AGHT+IH+LPdv4uI8ZtpLAROMjGCY94DX6j2AvsclNLplVSroc4bHXuz/v1iWuKlTq88uAf/Bob4Hwg==
X-Received: by 2002:a2e:a99f:0:b0:2d3:2a95:6f0b with SMTP id x31-20020a2ea99f000000b002d32a956f0bmr1921680ljq.12.1709825944291;
        Thu, 07 Mar 2024 07:39:04 -0800 (PST)
Received: from localhost ([82.150.214.1])
        by smtp.gmail.com with UTF8SMTPSA id n24-20020a05640204d800b00566f92f1facsm6501964edw.36.2024.03.07.07.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Mar 2024 07:39:04 -0800 (PST)
From: David Gstir <david@sigma-star.at>
To: Mimi Zohar <zohar@linux.ibm.com>,
	James Bottomley <jejb@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: David Gstir <david@sigma-star.at>,
	Shawn Guo <shawnguo@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	sigma star Kernel Team <upstream+dcp@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	Li Yang <leoyang.li@nxp.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Tejun Heo <tj@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v6 2/6] KEYS: trusted: improve scalability of trust source config
Date: Thu,  7 Mar 2024 16:38:29 +0100
Message-ID: <20240307153842.80033-3-david@sigma-star.at>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240307153842.80033-1-david@sigma-star.at>
References: <20240307153842.80033-1-david@sigma-star.at>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enabling trusted keys requires at least one trust source implementation
(currently TPM, TEE or CAAM) to be enabled. Currently, this is
done by checking each trust source's config option individually.
This does not scale when more trust sources like the one for DCP
are added.

Add config HAVE_TRUSTED_KEYS which is set to true by each trust source
once its enabled and adapt the check for having at least one active trust
source to use this option. Whenever a new trust source is added, it now
needs to select HAVE_TRUSTED_KEYS.

Signed-off-by: David Gstir <david@sigma-star.at>
---
 security/keys/trusted-keys/Kconfig | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/security/keys/trusted-keys/Kconfig b/security/keys/trusted-keys/Kconfig
index dbfdd8536468..553dc117f385 100644
--- a/security/keys/trusted-keys/Kconfig
+++ b/security/keys/trusted-keys/Kconfig
@@ -1,3 +1,6 @@
+config HAVE_TRUSTED_KEYS
+	bool
+
 config TRUSTED_KEYS_TPM
 	bool "TPM-based trusted keys"
 	depends on TCG_TPM >= TRUSTED_KEYS
@@ -9,6 +12,7 @@ config TRUSTED_KEYS_TPM
 	select ASN1_ENCODER
 	select OID_REGISTRY
 	select ASN1
+	select HAVE_TRUSTED_KEYS
 	help
 	  Enable use of the Trusted Platform Module (TPM) as trusted key
 	  backend. Trusted keys are random number symmetric keys,
@@ -20,6 +24,7 @@ config TRUSTED_KEYS_TEE
 	bool "TEE-based trusted keys"
 	depends on TEE >= TRUSTED_KEYS
 	default y
+	select HAVE_TRUSTED_KEYS
 	help
 	  Enable use of the Trusted Execution Environment (TEE) as trusted
 	  key backend.
@@ -29,10 +34,11 @@ config TRUSTED_KEYS_CAAM
 	depends on CRYPTO_DEV_FSL_CAAM_JR >= TRUSTED_KEYS
 	select CRYPTO_DEV_FSL_CAAM_BLOB_GEN
 	default y
+	select HAVE_TRUSTED_KEYS
 	help
 	  Enable use of NXP's Cryptographic Accelerator and Assurance Module
 	  (CAAM) as trusted key backend.
 
-if !TRUSTED_KEYS_TPM && !TRUSTED_KEYS_TEE && !TRUSTED_KEYS_CAAM
-comment "No trust source selected!"
+if !HAVE_TRUSTED_KEYS
+	comment "No trust source selected!"
 endif
-- 
2.35.3

