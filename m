Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0950D198E6E
	for <linux-crypto@vger.kernel.org>; Thu,  5 Sep 2024 11:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725535594; cv=none; b=l0goMofZG8vvO3W1uEhhaB5C+8KwDD7f2FBJVVe1NOVNB4ELutCAK2JFBYyeiUAVfbda+O1MXt7MBUQySoGVSbCSmefHClqEkeuuBYU0HVl1K1/K/rm+lr8l83GDya8GtmoePHNlxkV5Rsm+2cR4gboe1INVmSQFo2l3ceTl9fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725535594; c=relaxed/simple;
	bh=WLkEW3TQoHM0CaqvHP+UnEcZrNRj2Yf8ItE7bUlRtS8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oTjNMWBOp8zIU4BGnbKfxhtP3H0TdrreK3cPutx7tfCq6W71PsT5sub+cEF1e2D3kHjoFw006DDtPSN1TR4W7Nx7XYAUre7rNnWSw6G/maBiGzfSYIUWNlYtCN9dqSxb3qoh7PMffJNwaIT/qqQ5gDpbyFb5hyTE6TqFief+B0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=IbzWBDqM; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="IbzWBDqM"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-202508cb8ebso5490745ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 04:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1725535592; x=1726140392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sETn7qpcDB4MO8FELll1einBheR1j7SuMJsqhl5kLhI=;
        b=IbzWBDqMVC+Hp/NzEdJ6U294LRXFqcjOe+/0OBZbBT+u4PRPbPrC13AzA0ohZB47+L
         b/UlbjST5KV8ZrXETyfMJyngg+c76ZCu1RTrZlJWsEFtWYDuTZ4PMFhA/UwTqmiBcwhz
         Z3M7ltLTvQ1m1IpvvCA+mSYIN63h2a70yxc3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725535592; x=1726140392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sETn7qpcDB4MO8FELll1einBheR1j7SuMJsqhl5kLhI=;
        b=HvyVKiQO/ofEimQrXggiPr8c9uRa47U6EGqK1DhbVqP7lDuLhNEGEhMeyJdxRiFg17
         ABPLp/CT5jHUJoh7km56rNi7pGVz3HF+sKVjDW5ypEYbLAyCHgiq9Ew5eyTTa5s8f89p
         CRq0uPtqKBHj0u6fnf+Tg1it7fnKX+518LcSIbFU82ulikcJmku0r6rrFUI6KGZOijf4
         dgqcCenoNyidX+9svn1fG4xAk1XJWo6m9FCtpMzZ0aMR+guD6kfn8WI/vSmRpHnWoEIf
         UkBQs65PovVBK8xIhI0GUcwA4Axll1ihTfgiBvwCjfsYsAdoRtoR7PEQhDk6HCsAx+E3
         AN3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXfGsvNB9woBbS2Hc5bNDeqOZo0T0wodFh3wOXmGFUHJnF8Td1y/r4Um6Vo1aVwdAxI/pqO5p8pHmPIMdA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKI0Lb4DqOybX82ZKqiM+j1GHrSYno3X/i5nPlAdyg5Hb9CVGH
	Y1x0jl5VkYyBDGheOqt7x7B6Stcxmp679KpyOoI7NqajRQ+Blilyoi+l/MCISn4=
X-Google-Smtp-Source: AGHT+IGunYwZhCrW2FU7qzUCYUDtQWGncMBIDUW0JVoWEUsZn5tzewsZALt9L2+ufDVp9wFgMgxvjw==
X-Received: by 2002:a17:903:41cf:b0:206:c911:9d75 with SMTP id d9443c01a7336-206c9119ff2mr45269485ad.20.1725535592269;
        Thu, 05 Sep 2024 04:26:32 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206ae9138c0sm27445395ad.9.2024.09.05.04.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 04:26:31 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	robh@kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH 0/1] dt-bindings: crypto: Document support for SPAcc
Date: Thu,  5 Sep 2024 16:56:21 +0530
Message-Id: <20240905112622.237681-1-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DT bindings related to the SPAcc driver.
DWC Synopsys Security Protocol Accelerator(SPAcc)
Hardware Crypto Engine is a crypto IP designed by
Synopsys.
SPAcc can be configured as virtual SPAcc. The device supports 8 virtual
SPAccs. They have their seperate register banks and context memories.

Pavitrakumar M (1):
  dt-bindings: crypto: Document support for SPAcc

 .../bindings/crypto/snps,dwc-spacc.yaml       | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml


base-commit: b8fc70ab7b5f3afbc4fb0587782633d7fcf1e069
-- 
2.25.1

