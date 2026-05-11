Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA02361FFE
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2026 14:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778510514; cv=none; b=eWRxdXVTOnxDC8vbab5sj1Wep0SqclWzImEFHHtW0g62cpQ0P3U+tQUZQZ46jrr4itrAwDZeO0xoVjFSKBbgNKjtl9FkBbU5ydNhhmrssRQjkdkAQD2hlMr/utsUpa9/T8B6wzteP7urp1mk43pMSbylHObeOSZEE/Yuvc7T7XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778510514; c=relaxed/simple;
	bh=Uj71YxMd7CP0/+rQajvUXPXNAzpKdvAdtZ6sztvIkfc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNfrdU1RCmaOnvWynnnNwT7oxKPQwQe6i/1yYUJKs+MvoQVjJb6p7C3RDtYzBZwS6kvFVzBFQC5e3//3MGc5wG1X0cQrzrZr5aI5McK2hjPU4gWtFdapqwi3QuBk9+DSvVERdT4Kbv2FPFg++tBZ/m0aKnT1QZgAa1UXt8QTrko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WiFbVF/d; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WiFbVF/d"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c70fb6aa323so1879774a12.3
        for <linux-crypto@vger.kernel.org>; Mon, 11 May 2026 07:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778510513; x=1779115313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0S90v3cSnC5Da6GOQpoJCPTnbSf2YszUbZPGAtd7qaM=;
        b=WiFbVF/dLAo/F/CbBG3os0SHYlswQVJNCbl2BaLKx2lkscvK2j5gJlHuUQqAVWBx3z
         vXwGGARMR0X2oqfRY8uEnmFHY8mmEQjJKg9C5UQnLXTRV6T0+E12kc5vB5GUE5goxHUz
         nXF26ydrOa1jKXN6BqotyvbrKODd3/kK2FO/9Swb74QZl40dcg91Rl6ODfjM23j8YIBc
         Pp6fRVHVCtp4W/Q09UB5WCucvVKCq8NeXv0IfJRcdoleXL/LeVnzsRTV8u7ndQoosWj9
         LI90AQ+hT46Ao9MOp6JjcGtYK8Kezjk1JGpA9+TybArwbKcFo7oLodyW2hLbnacdh2Aq
         vcjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778510513; x=1779115313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0S90v3cSnC5Da6GOQpoJCPTnbSf2YszUbZPGAtd7qaM=;
        b=Ll30XD4r+vtOr4U87U36Lm/xAeGf93+hUM1sGdVyC7/JHfW5Kje4fMHAur0LKgY35f
         Y+X53YEIHtDbUPwjKv2tMK9JHEgjDry4JGC0IsZVlJDkU+DT4mlAaDHmF3iUptdq5nd+
         IdoPsp/iCCQaJ0ik7mGcTWLEwhzXroRN7GmTUt6IAYwu69CJZCJyHlBKJ0FY3jQA9bD3
         NIrzHYPMfQ1kiDs2v4wqblT06WyzdKVaKPE2FkDW7+BOLjntUOIdv8MicZpgya2CgQ4L
         cGVdps+vnlTBTpUuehtyDQg5oIGbXenqpNZPyPgVqlv1xlbFd9qYWCYZLhqu8D5A+xIE
         xGbg==
X-Forwarded-Encrypted: i=1; AFNElJ+Cjqq0dd1aAmYL4oEti6RDkcjxdy4QIUcV/avO1b+od+WGo2vvvDb/7hXsC9G6D9UsD24nt32gX20bWio=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaaEPAZ9zsCEBRfn4r5T69rwrrXW4QgHULG0TKkoYrVfoLKfq9
	qgb76yOWBpYIOFmx0HF40IqFr/yz5di/MlJfWRV/rMbVb1IjXKhZMPRE
X-Gm-Gg: Acq92OGA314se0K6lCNK5KQfsh+esKT7a6U60sO76dof6Bkge3dFbXsnL1qmGgOKJjX
	wWVnT/9LD6uKbuXENSQEw1X5gMoBlCcDki9nU6wRRqhpMD//AucTcPXFaSsXBXRdvZZq2rJhtLO
	cl6apZB1iMux0dpv7KABKsKhcFkHAElYlxP/BcUZfo60uOq7wkxXWmOoKktN1FjtMAbnJytvlRq
	ZplpZZTIHjAYbq6YXRx/DfIdrqW/F2r7mkJ2cDJZx24OP+bimBT+FCCJBfRVt8AI+SbIKkH9JC6
	5YVvuok51lerxXO9vrHmsHF54zQOA1ylYwTntnXRMgbKoCCdlULc6v2GprqkpfzOF2gf5y9ObSK
	dLxyTox3alex9js7VAkMa2I7RbW6vewVk0sXl6yCX4eHalnPdmEY1+0odlTBfKKxSxC/SL9KBQ2
	I74qSJdEWR2zIxGgxqyQi4uVQ6IWf4fnCaOmwaGC/FBgj3ggxo0irYbsrbEf5NbKi9Jw0xjOV97
	P9HdKdstEzWJg==
X-Received: by 2002:a05:6a20:3d1d:b0:3a8:1364:2d28 with SMTP id adf61e73a8af0-3aa5a709ee6mr27247296637.16.1778510513082;
        Mon, 11 May 2026 07:41:53 -0700 (PDT)
Received: from harrison-Surface-Pro-12in-1st-Ed-with-Snapdragon.lan ([58.164.4.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8396563f11csm26012405b3a.3.2026.05.11.07.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 07:41:52 -0700 (PDT)
From: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
To: linux-arm-msm@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/8] dt-bindings: crypto: Add x1e80100 inline crypto
Date: Tue, 12 May 2026 00:40:51 +1000
Message-ID: <7630457220c3e10eaedaea6d53e1c9c9adf43739.1778498477.git.harrison.vanderbyl@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778498477.git.harrison.vanderbyl@gmail.com>
References: <cover.1778498477.git.harrison.vanderbyl@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add compatibility string for the x1e80100/x1p42100
inline crypto engine.

Signed-off-by: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
---
 .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml    | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 876bf90ed96e..a338c4a33e98 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -24,6 +24,7 @@ properties:
           - qcom,sm8550-inline-crypto-engine
           - qcom,sm8650-inline-crypto-engine
           - qcom,sm8750-inline-crypto-engine
+          - qcom,x1e80100-inline-crypto-engine
       - const: qcom,inline-crypto-engine
 
   reg:
-- 
2.53.0

