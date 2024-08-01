Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCF813E04C
	for <linux-crypto@vger.kernel.org>; Thu,  1 Aug 2024 21:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722546130; cv=none; b=SbDwr88QzNly2yEzVmpeH+SAJxKbw9yi9lrM377ZJCyIjRrHeC56331J6NmcrSJ1KZNT8NvYLRux1wmgs7fq2rt5308XKVsriNtVdudjBp9V4sYThOrYZNIwrSW7LUK1BDVaVBnCDkYPVo8JCDAEzxs+StkLs06lTXuoQi2U+Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722546130; c=relaxed/simple;
	bh=ouaxn2NcW67BXplYvI5175YWP+upBfvE611Qk+dIGbc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ADSpZyOagb9T9xA64h0p7W7Jlx9mOYTua7ggkvc+fs9MR5EmjQFj5GjNBRFPZ854ilAOylKPuYdUCWXuRKhDkO18t+YHhW9fkylch6kj0ViFx4kfa4XnM2OOoen+SeGM+PfRfXu0c5SmRbY7nDtKtVTGu86MCPZxu9aWpvpBUlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kev009.com; spf=pass smtp.mailfrom=kev009.com; dkim=fail (0-bit key) header.d=kev009.com header.i=@kev009.com header.b=GeiNHcFe reason="key not found in DNS"; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kev009.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kev009.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=kev009.com header.i=@kev009.com header.b="GeiNHcFe"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2cdadce1a57so5085249a91.2
        for <linux-crypto@vger.kernel.org>; Thu, 01 Aug 2024 14:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kev009.com; s=google; t=1722546127; x=1723150927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NZBa5hQNDCUK8nFbEn3l9dAtyANR0fie1mHylb7O+/8=;
        b=GeiNHcFeROPukD5j3SjcMXRvMufh0nBm7JmJUWL16/lr2akegQz5qWdlHuAkW+gh+7
         wElgwcbOw0JA3tcp7qXSxo/77lu6kFDHyBttbXg1BVarcUpOTKzeLIGVwnitTKhh8fhZ
         k0qQHb0pGzP7JFqzySW3FUFrPIzsNpzKafsro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722546127; x=1723150927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NZBa5hQNDCUK8nFbEn3l9dAtyANR0fie1mHylb7O+/8=;
        b=Y1DpztVrvSqMi2WxtgnVJbuS9JBlw7bdAoHQfyHhwvB/okh0TBimxdQP4vPOO2aXG2
         WMBDzu+g/SMhrgvR7IabpSJ84YYZV6wA9h3KfrBDOYI7uGj8uccInShzaKyWZYY7NT0E
         XiIMsUnRex0H32ZF0GB3U56F1saEEm5yzWX+ALtCtpq86FjxTW/QgIcWhnO80s3CE1QF
         0zScRGhKRxqk/3tFqSIq5cWmcrnK/+WROUcgfjSekXNpneMDGveZbOGzyWqDTvHuippj
         aAceB1+1eK0lb6c4yK5ZjMV65/bgxz7pEMvoCAkFLCNHaSyVyt5V1mknyDDK9M9zLF0w
         Vgfw==
X-Gm-Message-State: AOJu0Ywjk+KWdhOT/l5GPZ2Sr5qPx35L3DyLUKYW1pgdNujWFc3/fpgd
	xEN7SZKcUJFEjxuxLg9FbLjVWgqJ3h6pqfBhY7/KclK1TLBmLEFA54zeqWDfbODApgkmxeFWLiu
	hFIIn
X-Google-Smtp-Source: AGHT+IFTkoLsxIFBjWusXPyAlMPN2id+iqTdsbfgYbH/nzk9F1qJtDu3RaYTbE6JaEP5B5bJ7nGZjA==
X-Received: by 2002:a17:90b:1a87:b0:2cd:2f63:a447 with SMTP id 98e67ed59e1d1-2cff95696cbmr1704521a91.36.1722546127047;
        Thu, 01 Aug 2024 14:02:07 -0700 (PDT)
Received: from kev-ws-aurora.cv0.bbox.io ([38.196.160.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cfdc45c3afsm3837085a91.33.2024.08.01.14.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 14:02:06 -0700 (PDT)
From: Kevin Bowling <kevin.bowling@kev009.com>
To: dhowells@redhat.com,
	keyrings@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kevin Bowling <kevin.bowling@kev009.com>,
	stable@vger.kernel.org
Subject: [PATCH] KEYS: Print digitalSignature and CA link errors
Date: Thu,  1 Aug 2024 14:01:55 -0700
Message-ID: <20240801210155.89097-1-kevin.bowling@kev009.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ENOKEY is overloaded for several different failure types in these link
functions.  In addition, by the time we are consuming the return several
other methods can return ENOKEY.  Add some error prints to help diagnose
fundamental certificate issues.

Cc: stable@vger.kernel.org
Signed-off-by: Kevin Bowling <kevin.bowling@kev009.com>
---
 crypto/asymmetric_keys/restrict.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_keys/restrict.c
index afcd4d101ac5..472561e451b3 100644
--- a/crypto/asymmetric_keys/restrict.c
+++ b/crypto/asymmetric_keys/restrict.c
@@ -140,14 +140,20 @@ int restrict_link_by_ca(struct key *dest_keyring,
 	pkey = payload->data[asym_crypto];
 	if (!pkey)
 		return -ENOPKG;
-	if (!test_bit(KEY_EFLAG_CA, &pkey->key_eflags))
+	if (!test_bit(KEY_EFLAG_CA, &pkey->key_eflags)) {
+		pr_err("Missing CA usage bit\n");
 		return -ENOKEY;
-	if (!test_bit(KEY_EFLAG_KEYCERTSIGN, &pkey->key_eflags))
+	}
+	if (!test_bit(KEY_EFLAG_KEYCERTSIGN, &pkey->key_eflags)) {
+		pr_err("Missing keyCertSign usage bit\n");
 		return -ENOKEY;
+	}
 	if (!IS_ENABLED(CONFIG_INTEGRITY_CA_MACHINE_KEYRING_MAX))
 		return 0;
-	if (test_bit(KEY_EFLAG_DIGITALSIG, &pkey->key_eflags))
+	if (test_bit(KEY_EFLAG_DIGITALSIG, &pkey->key_eflags)) {
+		pr_err("Unexpected digitalSignature usage bit\n");
 		return -ENOKEY;
+	}
 
 	return 0;
 }
@@ -183,14 +189,20 @@ int restrict_link_by_digsig(struct key *dest_keyring,
 	if (!pkey)
 		return -ENOPKG;
 
-	if (!test_bit(KEY_EFLAG_DIGITALSIG, &pkey->key_eflags))
+	if (!test_bit(KEY_EFLAG_DIGITALSIG, &pkey->key_eflags)) {
+		pr_err("Missing digitalSignature usage bit\n");
 		return -ENOKEY;
+	}
 
-	if (test_bit(KEY_EFLAG_CA, &pkey->key_eflags))
+	if (test_bit(KEY_EFLAG_CA, &pkey->key_eflags)) {
+		pr_err("Unexpected CA usage bit\n");
 		return -ENOKEY;
+	}
 
-	if (test_bit(KEY_EFLAG_KEYCERTSIGN, &pkey->key_eflags))
+	if (test_bit(KEY_EFLAG_KEYCERTSIGN, &pkey->key_eflags)) {
+		pr_err("Unexpected keyCertSign usage bit\n");
 		return -ENOKEY;
+	}
 
 	return restrict_link_by_signature(dest_keyring, type, payload,
 					  trust_keyring);
-- 
2.46.0

