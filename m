Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77595202C56
	for <linux-crypto@vger.kernel.org>; Tue,  1 Apr 2025 12:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743509650; cv=none; b=pQqIavVbmnv5gCY48FDoqZpNMzR8Jz6fWRPNvPk0GDFGm3K5b82hD/hAwC2fJ8BxbmAEGpa2ZuyF2P4IBcJFRbHVCsegWGXn7dw0bWG84whDhyTBN5g/7eXfG83O7CGE5ADLWZQvOH84Hma1WvfQnAcxc0Wsiaj74jVdK6FzWeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743509650; c=relaxed/simple;
	bh=YGXFqr4IfFV6Vu7eYniP5uzR9SdS+C3yWU1Sa7ToHIo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r64Llws1TXcNbwWPv8tBMPva/SxpWEtubvlJL65W66MDJH/3GwL54R8h7cWoAKdmioEXUrOqsUAvbQcM9INF7oYH+MITmjdqtEYSr3fe5IPaNqzS/2sI1jMLsyYNEKRqngRYdX6jsvh0Ot3tEsMijIkoe8jmDAIZcMVBsdDtr8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bml/akY1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bml/akY1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743509647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bobstMjPMV8DhfUNqC1sgNZKJxQFcOqPnhEWn4RzBRc=;
	b=Bml/akY1TQBdMDQzV6+/hPfvYl+r1kRD8guYq5zwqPYkaUS+9JrjdQOn3MhB0Jj7TkSHTJ
	oH28T54hv1xUWssaGrLCflwSkx33TNspRDFoOSLyL8Uymtkym/FJZ1cFlOAU6dtW/OsHcA
	AtR1NrnjLHJR6EONs/ypp5kz7JFjNkk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-hHDEg_lGNS69YmSe8d7GXg-1; Tue, 01 Apr 2025 08:14:06 -0400
X-MC-Unique: hHDEg_lGNS69YmSe8d7GXg-1
X-Mimecast-MFC-AGG-ID: hHDEg_lGNS69YmSe8d7GXg_1743509645
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ac27d8ac365so418251266b.2
        for <linux-crypto@vger.kernel.org>; Tue, 01 Apr 2025 05:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743509645; x=1744114445;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bobstMjPMV8DhfUNqC1sgNZKJxQFcOqPnhEWn4RzBRc=;
        b=mJZX93F6ravsyBvwR8aCNKLFbNt8ZjZjTWexjL98tYpUpQN/yQvY5uAA40F3avOgNs
         DuUQCQkxBJUsAS+6kSL5sobnJNcKsXZn3erK2T6SIEE65rYsT2id8XUd5hM7wfo+nCRx
         kTx2lrpvzaEsQ9FpOoOMjEJlO51p+bIX3pZWXwbM4Yps6NV5z1QsrNKcUAwe/4YVU35w
         cPvfBuog71Ngl78HL7V/yE2QcUltH71aSIMPdPoUD2q/HxVeyTlbqGxpZJjH/FwWlPB7
         aB/9VcShrJZYnWZjba/Cbbo9DYAmKtp2PSasOtUm/bG/UG3pfs3w+BvFKcdf+DdZnRGJ
         Ne8g==
X-Forwarded-Encrypted: i=1; AJvYcCUkNo8HOll+d4qgE5LrOjm+CymDrx3Z9U2XzZFvruZIZVs9clUCYyOXeNanKhTMqNKWOtSn9bVK/OjnWQY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLH4a4kWj8sHsm6X7P8gvfPMBT4n0yehHXJse+gw2CCk3PQkGn
	oSvPLoJ0eTl9mVZBzoYIIP78OQMpHkPfZ0Ax7IkpMyjRXt7R2Ox2pzBcvzrRYxHphTeGuhp/dJQ
	MtBGvpnYh5VYjkSQIg2/SRaU61RWSsWG9tPfrghG7cquLNeZ8kIWN3t2bCfk7qg==
X-Gm-Gg: ASbGncsmKkb1ZU6+YkCnQj+CktioRY73JsfAP0DJKt709MIvLEIJRrSrQOEPC8s6gdT
	zVYmfYgxmG03VAj02fjZSUURggr6lKo5W7oqB4wabfaDBTmGgb2v2COAE5OpjTaGtZk8VG1D1nT
	Lcfv23R4QYKh6VTVSAY0yQzimOJjsHR9qY4NCcMvhFOiY/0Pzw4ynz8eY5rLfhAJHwiFlq5HDdu
	Ap4Ewjs6r1zEer5ZDFXuO6pljoa+qEQugj3f1sF/7A9c9FWC8Cj1nsLhEwbSGkGAtJ0AvGMo1Jt
	UpSf487FHpb1caOD8+i5PZ28Un4nREq7SPJvBGmmdLw0hr3Xt75spuFWOTJ7wFc=
X-Received: by 2002:a17:907:7f0d:b0:ac7:150b:57b2 with SMTP id a640c23a62f3a-ac738b61acfmr1115335366b.41.1743509644918;
        Tue, 01 Apr 2025 05:14:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHAUNzsyCaoMuUKp8KrX5TmH5LqHQTBd4duJrOAEcTk1GtfF5/Q9pgFHfstQ4EV56ENzCLV9A==
X-Received: by 2002:a17:907:7f0d:b0:ac7:150b:57b2 with SMTP id a640c23a62f3a-ac738b61acfmr1115332366b.41.1743509644468;
        Tue, 01 Apr 2025 05:14:04 -0700 (PDT)
Received: from lbulwahn-thinkpadx1carbongen9.rmtde.csb ([2a02:810d:7e01:ef00:bf5b:f273:a506:f71f])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7192ea03esm753963866b.84.2025.04.01.05.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 05:14:03 -0700 (PDT)
From: Lukas Bulwahn <lbulwahn@redhat.com>
X-Google-Original-From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: [PATCH] crypto: Kconfig - correct references in config CRYPTO_HKDF
Date: Tue,  1 Apr 2025 14:13:54 +0200
Message-ID: <20250401121354.20897-1-lukas.bulwahn@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

Commit 3241cd0c6c17 ("crypto,fs: Separate out hkdf_extract() and
hkdf_expand()") adds the new config option CRYPTO_HKDF, which intends to
select further hash algorithms when crypto manager tests are enabled.

However, the select command accidentally refers to
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS with the CONFIG prefix, whereas the
references here in the Kconfig file work without the CONFIG prefix.

Correct the references here to its proper form.

Fixes: 3241cd0c6c17 ("crypto,fs: Separate out hkdf_extract() and hkdf_expand()")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
---
 crypto/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index dbf97c4e7c59..f601a4ec6d1a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -143,8 +143,8 @@ config CRYPTO_ACOMP
 
 config CRYPTO_HKDF
 	tristate
-	select CRYPTO_SHA256 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
-	select CRYPTO_SHA512 if !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+	select CRYPTO_SHA256 if !CRYPTO_MANAGER_DISABLE_TESTS
+	select CRYPTO_SHA512 if !CRYPTO_MANAGER_DISABLE_TESTS
 	select CRYPTO_HASH2
 
 config CRYPTO_MANAGER
-- 
2.49.0

