Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAC53BB689
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 06:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791528873; cv=none; b=k+iLY8OcsfqPZtOeEhsITB4PVwlhVDfVDBPvEbyGIET4o+pJFSEvUPKRdb3u6Di14BeFiw+7Bh/jjfCOXHlEN2wDF3y7ssVo5r71H6797BR9Du97BUV05vM9rQQDz1NnvmB4G+DisnmHwZFM4+Hd77zZg00WGz7O5hbCR2toPLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791528873; c=relaxed/simple;
	bh=n7TuFPqgtRxjCRGFyy+0Rdz7rjIvV+ajIcqXa5LF3yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kO6RFlb5LgCZ0FKRnoQ2drQum7jqUxz7+NbTZmIUXyocMAuXe1IkFtivKvIiCkiMP8IRRt6+nX9xwEVk51JRCG5X+rF9TeorV+hL3EtE7SCtaGFjDrQNOiE+tBCEGt49RdESsjXvQRR/XqFGaYX0FWLwP1sFb888BPpy7KYpOFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Naw2yRK2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Naw2yRK2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791528870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vcePdjvF8DWO+rsrHllskedZqHh+JrGfqqP/14EOl+o=;
	b=Naw2yRK2SpNlWVaonkvLAIJZDLGOs+2vRUapHUH6jTOYpLW1K4Lw8vw64Wz4IfaytRNLZm
	zcw5F7ETV5cUKS6Q862DBhKA1jPXAsyR+J7/HlKx0bx2cM7q/I49trWP0UeFW1E3m3sNks
	hY72wpDDbIWp54S8OCp20RwcesHC0aY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-599-CgNFcyNiNbGWNS8jzJ5UJA-1; Fri,
 09 Oct 2026 02:54:27 -0400
X-MC-Unique: CgNFcyNiNbGWNS8jzJ5UJA-1
X-Mimecast-MFC-AGG-ID: CgNFcyNiNbGWNS8jzJ5UJA_1791528866
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C90E41802173;
	Fri,  9 Oct 2026 06:54:25 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0D9C11956095;
	Fri,  9 Oct 2026 06:54:22 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	johannes@sipsolutions.net,
	miriam.rachel.korenblit@intel.com
Cc: ilan.peer@intel.com,
	emmanuel.grumbach@intel.com,
	linux-crypto@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v3 1/4] crypto: fips: add fips_exception kernel boot parameter and fips_allows_exception() helper
Date: Fri,  9 Oct 2026 08:54:10 +0200
Message-ID: <20261009065413.53403-2-jtornosm@redhat.com>
In-Reply-To: <20261009065413.53403-1-jtornosm@redhat.com>
References: <20261009065413.53403-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Add a new kernel boot parameter fips_exception=<bitmap> to allow
documented exceptions to strict FIPS compliance when full compliance
is not achievable due to hardware/firmware limitations but
functionality is required.

The parameter is stored in a static variable and accessed through the
exported fips_allows_exception() helper function, which returns true
when FIPS is enabled and the requested exception bit is set. This
makes fips_allows_exception() an explicit "is this FIPS exception
active?" check, only meaningful when FIPS mode is on.

For !CONFIG_CRYPTO_FIPS, fips_allows_exception() is a trivial static
inline returning false (no FIPS means no FIPS exceptions).

The parameter is exposed as a read-only sysctl at
/proc/sys/crypto/fips_exception for runtime inspection. As with
fips_enabled, it is intentionally not writable at runtime so that
enabling exceptions requires a deliberate boot-time decision,
visible in /proc/cmdline.

The bitmap design allows individual subsystem exceptions to be
defined independently. Currently defined bits:
  - Bit 0 (FIPS_EXCEPTION_WIFI_MFP): Allow WiFi MFP (802.11w)
    in FIPS mode despite firmware sending some unprotected
    management frames on TX

Without this parameter (or with fips_exception=0), all existing
FIPS restrictions remain in effect.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v3: rename fips_allows() to fips_allows_exception(), change semantics
    to fips_enabled && exception (was !fips_enabled || exception)
v2: https://lore.kernel.org/all/20260930120829.383408-2-jtornosm@redhat.com/

 crypto/fips.c        | 27 +++++++++++++++++++++++++++
 include/linux/fips.h | 14 ++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/crypto/fips.c b/crypto/fips.c
index c59711248d95..0f075e61a657 100644
--- a/crypto/fips.c
+++ b/crypto/fips.c
@@ -21,6 +21,15 @@ EXPORT_SYMBOL_GPL(fips_enabled);
 ATOMIC_NOTIFIER_HEAD(fips_fail_notif_chain);
 EXPORT_SYMBOL_GPL(fips_fail_notif_chain);
 
+static unsigned long fips_exception;
+
+int fips_allows_exception(unsigned long feature)
+{
+	return fips_enabled &&
+	       (fips_exception & feature);
+}
+EXPORT_SYMBOL_GPL(fips_allows_exception);
+
 /* Process kernel command-line parameter at boot time. fips=0 or fips=1 */
 static int __init fips_enable(char *str)
 {
@@ -34,6 +43,17 @@ static int __init fips_enable(char *str)
 
 __setup("fips=", fips_enable);
 
+static int __init fips_exception_setup(char *str)
+{
+	if (kstrtoul(str, 0, &fips_exception))
+		return 0;
+
+	pr_info("fips exceptions: 0x%lx\n", fips_exception);
+	return 1;
+}
+
+__setup("fips_exception=", fips_exception_setup);
+
 #define FIPS_MODULE_NAME CONFIG_CRYPTO_FIPS_NAME
 #ifdef CONFIG_CRYPTO_FIPS_CUSTOM_VERSION
 #define FIPS_MODULE_VERSION CONFIG_CRYPTO_FIPS_VERSION
@@ -52,6 +72,13 @@ static const struct ctl_table crypto_sysctl_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec
 	},
+	{
+		.procname	= "fips_exception",
+		.data		= &fips_exception,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0444,
+		.proc_handler	= proc_doulongvec_minmax
+	},
 	{
 		.procname	= "fips_name",
 		.data		= &fips_name,
diff --git a/include/linux/fips.h b/include/linux/fips.h
index c6961e932fef..61fe58b0762c 100644
--- a/include/linux/fips.h
+++ b/include/linux/fips.h
@@ -2,17 +2,31 @@
 #ifndef _FIPS_H
 #define _FIPS_H
 
+#include <linux/bits.h>
+
 #ifdef CONFIG_CRYPTO_FIPS
 extern int fips_enabled;
 extern struct atomic_notifier_head fips_fail_notif_chain;
 
 void fips_fail_notify(void);
+/*
+ * fips_allows_exception - check if a FIPS exception is active
+ * Returns true when FIPS is enabled and the requested exception
+ * bit is set via the fips_exception= boot parameter.
+ */
+int fips_allows_exception(unsigned long feature);
 
 #else
 #define fips_enabled 0
 
 static inline void fips_fail_notify(void) {}
+static inline int fips_allows_exception(unsigned long feature)
+{
+	return 0;
+}
 
 #endif
 
+#define FIPS_EXCEPTION_WIFI_MFP	BIT(0)
+
 #endif
-- 
2.55.0

