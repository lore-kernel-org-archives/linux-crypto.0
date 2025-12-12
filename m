Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F5530AAD8
	for <linux-crypto@vger.kernel.org>; Fri, 12 Dec 2025 18:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765565269; cv=none; b=OxF9nHLrL+wii0Cwyo8ZubyzJxFtp2h5rLWHNEE8h2ja8fn1OPNBlpgeXIDDH8A4aVJI86E3afDlaJLkC84WIjOAtyuoAosNklxnm9mHP+o1Z4+Wp+lWQM1+/5XAjTchZ9buIZWPz/QoFxbiyOwiqc8ZrfEliNLI3YAIgY55p64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765565269; c=relaxed/simple;
	bh=fCVISyy9R8nm7bxKdnz6dwXF33iLDUmCz/UAxVVYSqY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RMKp+kbEEFSeS84SuFQCA851+Zzwt90It8ehubuU/ei3LSSXDzfEnlSUSZn8w5N4+S36xQPdS1kx606TVSZ0gJaw2KBGiKfUrVfzP3k32frIH/5wHk0SgGKbTAH4/t60js8T8JgmGuJLSh5N1UuF0J4F/FU3w4p0UFXnicgzo+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PsHyY7Or; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PsHyY7Or"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765565265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0sp0c7ijMfmNIDKHaHKpRzr1j+6h+exLVgKMjotQmgM=;
	b=PsHyY7OryOsv72Zq6gmYQCpg9JXrdqN34LD0/lsMyKs2+uVKvTxXPZGvFgTt4DVSddIXlZ
	AUzGoOmsB0um5xjmJtbSUHxiuJ4fyn1+3BI+kfxq/6oXpbirthLRXr4iq96sOg1Mki1AGA
	MjQ+XcCqGsrS5bN54TkoS0ypSaYqaVI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-lP-MYbFaME-oWaxlvJ1hLQ-1; Fri,
 12 Dec 2025 13:47:40 -0500
X-MC-Unique: lP-MYbFaME-oWaxlvJ1hLQ-1
X-Mimecast-MFC-AGG-ID: lP-MYbFaME-oWaxlvJ1hLQ_1765565259
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 69CEA1800657;
	Fri, 12 Dec 2025 18:47:37 +0000 (UTC)
Received: from cmirabil.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C01001953984;
	Fri, 12 Dec 2025 18:47:34 +0000 (UTC)
From: Charles Mirabile <cmirabil@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	ebiggers@kernel.org,
	Jason@zx2c4.com,
	ardb@kernel.org,
	zhihang.shao.iscas@gmail.com,
	zhangchunyan@iscas.ac.cn,
	Charles Mirabile <cmirabil@redhat.com>
Subject: [PATCH] crypto: riscv: add poly1305-core.S to .gitignore
Date: Fri, 12 Dec 2025 13:47:17 -0500
Message-ID: <20251212184717.133701-1-cmirabil@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

poly1305-core.S is an auto-generated file, so it should be ignored.

Fixes: bef9c7559869 ("lib/crypto: riscv/poly1305: Import OpenSSL/CRYPTOGAMS implementation")
Signed-off-by: Charles Mirabile <cmirabil@redhat.com>
---
 lib/crypto/riscv/.gitignore | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 lib/crypto/riscv/.gitignore

diff --git a/lib/crypto/riscv/.gitignore b/lib/crypto/riscv/.gitignore
new file mode 100644
index 000000000000..0d47d4f21c6d
--- /dev/null
+++ b/lib/crypto/riscv/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+poly1305-core.S
-- 
2.43.0

