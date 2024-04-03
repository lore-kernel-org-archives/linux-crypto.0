Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8740860266
	for <linux-crypto@vger.kernel.org>; Wed,  3 Apr 2024 07:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712128913; cv=none; b=FiklQrk9k/2UAx2jdDDGm/9g2aO3dSAmooqcSphjiPQkdl+cBeFvz270UZ3PiwZyNM8XKA2ciJmmmBwnFqKt176MfHpF8NvynX9yUBp/WPCeIybGOB6sDLkDeRfyaPURH9jBh3QS+bg/3hR7he/SgYHYbD7l2gu00uPjdfKruvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712128913; c=relaxed/simple;
	bh=Khyeg1/xj46k+x5xR7s8vWgC8Y2GcoM7MOqDayZ6owQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2IIY0t9Jnj9TNZ+e7NLuLjrNDptAjYSHOECd5vcmPViGlBtFQjf+TXo+ILDZBTUVdNKbzV3yOZIuXyR0BMfdp0ujdsg9EAy43FJwJMekpNY/5dEGftBVEjBRxXtjCOLjswMk2cSTvHDUc6N6hTAQaXm26H7proSXW968ZsTx5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=JdueFn8D; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="JdueFn8D"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-41624c40c4bso688405e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 03 Apr 2024 00:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1712128908; x=1712733708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D9xm7Qk02wEciH96RlDxlZxQKfuGKusC1XnJuVX2I7s=;
        b=JdueFn8DOrllCF00jh7MZOpnWQ1lhXI07HeDguULMBqeUVFmYd0LdOLUnTcaFzDa9A
         fazroUBnovKNuscyPO4FCLe0JeX3UGKiiFODXPRNspid68bsgjq4/Lbbb6AFzYk6ywQ4
         SBm4k2Gn32Ge60qG9f0JhMyyag9WvGrF5f08YivMgWXoXtMD+vohf+2i6bOhkJyf4bG0
         hL3R6ZJp5c8R3WAkDuasakh8HZJPWC5n6iRvPheE6W2A/pkwAyJj2+wb3Dg22p+fIr9k
         ++8mkLDiq/kTE4jgEWSkkLk3rMbYUuwcbg9BSsKvZGZP6/sy7RT7K+It3kfoOurfgTJ/
         ZWYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712128908; x=1712733708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D9xm7Qk02wEciH96RlDxlZxQKfuGKusC1XnJuVX2I7s=;
        b=q325ivaHJj32BL/6MLIM4VUZ2usu7lOmyraoVSC4V25Bsya1koFCk82+pxDEqT8iLP
         73JghoDhzp658WUuC+Vr3dBkfZfZCnIsoefwX8P6Niv7rtisx1tA5/KpRjYCMzwzTxVV
         +u48jg3qD7gDCgLXazJCXRGdZpgwpqJlYbs1bmZMdhOBdEaOYUserCmFVddh9vhffhFl
         g5nL8fzwywzaJVoC0AAQ3G1JPVsD1Hw7gTPAcjrTzRoXHFhBXacG/un5Nt+oPoqR/PFe
         3FxHykE+fplgXhBozxnjtn8fR8yFy/7OpHawgW3vyBBZZxofNFOBgFTy2ZgkXVb6qetO
         jfHg==
X-Forwarded-Encrypted: i=1; AJvYcCUcDhowrW9Fk5zEWEP4QjCL8FG0pT6wK0uq9OHm624AS3DVPh+E1+4B8s2HHHVd89gBZNgQ9rwoo2B0WH0YZXcjru367CAMEu7hq5R2
X-Gm-Message-State: AOJu0YwHoUwOFA3F4n1SNmXaO5o0mi1VZioRM6O+Tv3TGti7PWpKDX9Z
	b6+sPsipFhCACiO6N4aysGw7QnOAHg2PLmceghzsOvY3wodCoqHfrTJ1ysOUYrc=
X-Google-Smtp-Source: AGHT+IFwfWGPzmjOkZpQ5g13bjj6w//ru+uAqGOIDa7Sctmy6coY4cw7BXdzp+Ags4F/9A/eZ2BqQQ==
X-Received: by 2002:a05:600c:3c92:b0:416:2181:bcaf with SMTP id bg18-20020a05600c3c9200b004162181bcafmr930669wmb.1.1712128908083;
        Wed, 03 Apr 2024 00:21:48 -0700 (PDT)
Received: from localhost ([82.150.214.1])
        by smtp.gmail.com with UTF8SMTPSA id n30-20020a05600c501e00b0041621b3cfa8sm1724904wmr.6.2024.04.03.00.21.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Apr 2024 00:21:47 -0700 (PDT)
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
Subject: [PATCH v8 4/6] MAINTAINERS: add entry for DCP-based trusted keys
Date: Wed,  3 Apr 2024 09:21:20 +0200
Message-ID: <20240403072131.54935-5-david@sigma-star.at>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403072131.54935-1-david@sigma-star.at>
References: <20240403072131.54935-1-david@sigma-star.at>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This covers trusted keys backed by NXP's DCP (Data Co-Processor) chip
found in smaller i.MX SoCs.

Signed-off-by: David Gstir <david@sigma-star.at>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 976a5cea1577..ca7f42ca9338 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12019,6 +12019,15 @@ S:	Maintained
 F:	include/keys/trusted_caam.h
 F:	security/keys/trusted-keys/trusted_caam.c
 
+KEYS-TRUSTED-DCP
+M:	David Gstir <david@sigma-star.at>
+R:	sigma star Kernel Team <upstream+dcp@sigma-star.at>
+L:	linux-integrity@vger.kernel.org
+L:	keyrings@vger.kernel.org
+S:	Supported
+F:	include/keys/trusted_dcp.h
+F:	security/keys/trusted-keys/trusted_dcp.c
+
 KEYS-TRUSTED-TEE
 M:	Sumit Garg <sumit.garg@linaro.org>
 L:	linux-integrity@vger.kernel.org
-- 
2.35.3

