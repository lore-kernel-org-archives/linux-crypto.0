Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11A61CA89
	for <linux-crypto@vger.kernel.org>; Mon, 18 Mar 2024 06:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710744279; cv=none; b=PG2k8N1T/9+KiAGOhO7Du8/qTNoOyFOAzcYq8FPSa1UIvI2J6Qb9O5eXC9Mxjq+/3CTmHybFxeLjs1OJnm/S5a1WOKgl3wWE8RR5b/HxPScwyUbZSZ39hJHb4JUikUjQS1mLF85atpWtGW4Z0uCQtLlRRuk7BkEKBihsLGeBEY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710744279; c=relaxed/simple;
	bh=skEsCZKyKJolpTxFMXOKRN6j1kC3rXie0+a+1lIxssk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g0HnPbTCtu6CN+KdHAGl6lhlj1iz1w6TJfm9xQVPUi6jRLbdGw8HVONHT6482J3mBu2KbgUKm0yGdBf/CIGqAnqZyFzkqnXdmbkF76lMcY78a71yb8Hoi5kCpwGdgnYGe/05H8DvIDdJhD3EO2xYHxQw8uquPeBJCgw6RBB7JuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DrhDOnNJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DrhDOnNJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710744276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=osDyJdcJu79eMx8AxQ473FAUCgGzUBaif8zLPvxwRZ0=;
	b=DrhDOnNJ7rSol3jphUDQc4iSHu336aqQBq0NlR2mslJrnyGwxdJyenrqnDqC9bQeHB6u4E
	NaKo0zCqrImE+QfLsqX2AdXsBwzmDL5lL+c06FbIGrmECVCePYPJ70WwZ7bNjHj4UwxfU1
	RvCcoGav9PKYp7cM/b05KN/ZgXFK/gk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-KNM635-VOJiaQzITiPsPyw-1; Mon, 18 Mar 2024 02:44:33 -0400
X-MC-Unique: KNM635-VOJiaQzITiPsPyw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E96268007A3;
	Mon, 18 Mar 2024 06:44:32 +0000 (UTC)
Received: from cantor.redhat.com (unknown [10.2.16.24])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C324C04121;
	Mon, 18 Mar 2024 06:44:32 +0000 (UTC)
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH] crypto: iaa: Fix some errors in IAA documentation
Date: Sun, 17 Mar 2024 23:44:21 -0700
Message-ID: <20240318064421.833348-1-jsnitsel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

This cleans up the following issues I ran into when trying to use the
scripts and commands in the iaa-crypto.rst document.

- Fix incorrect arguments being passed to accel-config
  config-wq.
    - Replace --device_name with --driver-name.
    - Replace --driver_name with --driver-name.
    - Replace --size with --wq-size.
    - Add missing --priority argument.
- Add missing accel-config config-engine command after the
  config-wq commands.
- Fix wq name passed to accel-config config-wq.
- Add rmmod/modprobe of iaa_crypto to script that disables,
  then enables all devices and workqueues to avoid enable-wq
  failing with -EEXIST when trying to register to compression
  algorithm.
- Fix device name in cases where iaa was used instead of iax.

Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
---
 .../driver-api/crypto/iaa/iaa-crypto.rst      | 22 ++++++++++++++-----
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
index de587cf9cbed..330d35df5f16 100644
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
+++ b/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -179,7 +179,9 @@ has the old 'iax' device naming in place) ::
 
   # configure wq1.0
 
-  accel-config config-wq --group-id=0 --mode=dedicated --type=kernel --name="iaa_crypto" --device_name="crypto" iax1/wq1.0
+  accel-config config-wq --group-id=0 --mode=dedicated --type=kernel --priority=10 --name="iaa_crypto" --driver-name="crypto" iax1/wq1.0
+
+  accel-config config-engine iax1/engine1.0 --group-id=0
 
   # enable IAA device iax1
 
@@ -536,12 +538,20 @@ The below script automatically does that::
 
   echo "End Disable IAA"
 
+  echo "Reload iaa_crypto module"
+
+  rmmod iaa_crypto
+  modprobe iaa_crypto
+
+  echo "End Reload iaa_crypto module"
+
   #
   # configure iaa wqs and devices
   #
   echo "Configure IAA"
   for ((i = 1; i < ${num_iaa} * 2; i += 2)); do
-      accel-config config-wq --group-id=0 --mode=dedicated --size=128 --priority=10 --type=kernel --name="iaa_crypto" --driver_name="crypto" iax${i}/wq${i}
+      accel-config config-wq --group-id=0 --mode=dedicated --wq-size=128 --priority=10 --type=kernel --name="iaa_crypto" --driver-name="crypto" iax${i}/wq${i}.0
+      accel-config config-engine iax${i}/engine${i}.0 --group-id=0
   done
 
   echo "End Configure IAA"
@@ -552,10 +562,10 @@ The below script automatically does that::
   echo "Enable IAA"
 
   for ((i = 1; i < ${num_iaa} * 2; i += 2)); do
-      echo enable iaa iaa${i}
-      accel-config enable-device iaa${i}
-      echo enable wq iaa${i}/wq${i}.0
-      accel-config enable-wq iaa${i}/wq${i}.0
+      echo enable iaa iax${i}
+      accel-config enable-device iax${i}
+      echo enable wq iax${i}/wq${i}.0
+      accel-config enable-wq iax${i}/wq${i}.0
   done
 
   echo "End Enable IAA"
-- 
2.41.0

