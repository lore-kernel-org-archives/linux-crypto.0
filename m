Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616A040C5A9
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879755; cv=none; b=RDLTZXzjvvM5BkvQgLkQjgk1dtte+4qE61xqT341fGKHK9Sf4/f9/Xml9Y7eoaHChXdBRemOFKsJrwPRO2uLqWJ8zIjj1woiQasAWihLc5qUIUZbDgFsST8SlImRIeoxyPjhyPfW38Ak12r4zianBONMH/XRxIcXKhMdq8Xjlx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879755; c=relaxed/simple;
	bh=k11liqjn7SKCyf9jqrs9rTU6kFg+eJg4IVC5ddHmpkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIjc6D/GPfXJWuwACytF/km+7ts/5vPIIffXzua6Rad8ZkD136rNu2UBIsMkL+hqmLmK+IKxSKmX73X2S3Nv4GPrhZNej3eoxyLLN7POTr6G5D7Z6Xpyx869KeMhNkeHnxQQ+tq0NCVNigdcXTyRrvRkDJUcisNcr91++6XzY10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MW3f6p1L; arc=none smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MW3f6p1L"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2f3c623322bso1046906eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879753; x=1779484553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0sYZnhQeLyzvjO7vpNeSMDXaPgGF/81BOZ3a8GGZZ8=;
        b=MW3f6p1L5kudegGCItpuYAXS0RaiDi4aNt4p22EfgX11pgRsZn0lkRN/b11rRXCWh4
         Timw43kcCzZdNRr8jfGYUIrLHf+Zq71fP9atGwGnaPZPEuqF3JRXOybBWGN4Bcj7+wZV
         pJXY/7KvNXuCNw2IDafGifFgt/qPqSJgSY4Fyjg3I1GtfYy446IuqHKyhO1W93TZhUv0
         I3XOK9esj/N/vrNMe11n9gSuwnxhphCC0RvnmwruX4gebJ+nWhpgGJcvAQ9cDtmshGJX
         SYNUKSX8YPQrZ/gxyiK/aMBuXXZaVh9FhVgzgM56noTmG9GcF6/S4kcU1vGe9grQL/2I
         yu8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879753; x=1779484553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d0sYZnhQeLyzvjO7vpNeSMDXaPgGF/81BOZ3a8GGZZ8=;
        b=NEQJvBUQIcI/mNC5zzEflofgf6z0qJQM6O6x303PleSQkNlfZrAko5eNPReYs0idaF
         pG/cymGyTxb4CfB56xajIngco/+TZXAnBJBsdsB0hnqzVd5fQBJBiLJoSiLGhZ0/GPWJ
         TYUknUBbK1zYwMa+JNo7unuN/cG2AOk7Sk4m6ljJPeLoZlJStI3VFwwNJcY7ouyrzorP
         ha7LtmbVpckxUiEGsPCA/P8QFy5eoKXLoUeKjYymJsrGMyp1ZoJDdPWphTyqQ0aIkpi4
         S6WPanq35tadOScqjnmQ2aUkzvheWAweMEGDz0ytqGjgjDKX4iUkrvVMY/VwKHUpNc/y
         +UcQ==
X-Forwarded-Encrypted: i=1; AFNElJ/7URcdTWkNNnDTHjczy/5IOWmUdZDakLCg0Q9uDbKfEjerQ9F1llZl0JoYtNyXLNa6ONuDrNvKptre3sU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPQ6zrTO8FyEpxdTQE6DfYyiH8Fb7JXAy7PxgpSKr4GReGrjsc
	9nRA90VOiDWaDr8235qbASwCummjjHWLDEX5wRzd9ZIFWoJTiDl/Md9/
X-Gm-Gg: Acq92OEe5Yj4jeiSmi67m+CYKdXWXXTyQBP8QfGLXxaNAeLqbJGeNFRIOLjY59glM0W
	VRG0awIzqK6s+IVCTZffPZ1M3LdyWXEvZW+7oFIpJMjIWT+q76hhi3wgWRZ6+/DG/KjurJT3cGH
	7qNoz1YhhFPu0VKi8NvoYJzB/tqR92J2CZgZRHsYuUcYGk2jfyV+nG8XPLAf8N2KpmYEMqRScSa
	T0QoTn7HCb0ktrEQ4CtoSJGnDenEaTOyLnSgoP6xD825S9ccsxlSh8iSBG19ERK5KBlkdOGBze8
	CvN08aY0Y8XFey8UMKSt18MsCCsQ3Z4LLeSERRPpaFzNpMICxe9gfdEmMO/kxmw2HI0SaUCt5kP
	pD8KKzHIl2keL/qscEEw+J457CwUxM2A9LQqbdskwkZM84Uk12vbjK7cACbJsWRYj9unHcmomLG
	lfUT3LcxyeUVlsFW0tVOo7hF+v4AqYrAfiogZj1ib7jQ==
X-Received: by 2002:a05:7301:290f:b0:2da:7e33:9261 with SMTP id 5a478bee46e88-3039869b7b3mr2853046eec.27.1778879752504;
        Fri, 15 May 2026 14:15:52 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30297bbc9a3sm8132550eec.31.2026.05.15.14.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:15:52 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-efi@vger.kernel.org,
	iommu@lists.linux.dev
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
	jgg@ziepe.ca,
	luto@amacapital.net,
	nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	ebiederm@xmission.com,
	dwmw2@infradead.org,
	baolu.lu@linux.intel.com,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v16 35/38] reboot/slaunch: Secure Launch SEXIT support on reboot paths
Date: Fri, 15 May 2026 14:14:07 -0700
Message-ID: <20260515211410.31440-36-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515211410.31440-1-ross.philipson@gmail.com>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the MLE kernel is being powered off, rebooted or halted,
then SEXIT must be called. Note that the GETSEC[SEXIT] leaf
can only be called after a machine_shutdown() has been done on
these paths. The machine_shutdown() is not called on a few paths
like when poweroff action does not have a poweroff callback (into
ACPI code) or when an emergency reset is done. In these cases,
just the TXT registers are finalized but SEXIT is skipped.

Co-developed-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Signed-off-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 arch/x86/kernel/reboot.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 6032fa9ec753..87835706bb4f 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -14,6 +14,7 @@
 #include <linux/pgtable.h>
 #include <linux/kexec.h>
 #include <linux/kvm_types.h>
+#include <linux/slaunch.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
@@ -779,6 +780,12 @@ static void native_machine_restart(char *__unused)
 
 	if (!reboot_force)
 		machine_shutdown();
+	/*
+	 * The comments for slaunch_finalize() provides the explanation for the
+	 * conditions required to do the SEXIT op reflected in the conditional
+	 * parameter do_sexit.
+	 */
+	slaunch_finalize(!reboot_force);
 	__machine_emergency_restart(0);
 }
 
@@ -789,6 +796,8 @@ static void native_machine_halt(void)
 
 	tboot_shutdown(TB_SHUTDOWN_HALT);
 
+	slaunch_finalize(1);
+
 	stop_this_cpu(NULL);
 }
 
@@ -797,8 +806,12 @@ static void native_machine_power_off(void)
 	if (kernel_can_power_off()) {
 		if (!reboot_force)
 			machine_shutdown();
+		slaunch_finalize(!reboot_force);
 		do_kernel_power_off();
+	} else {
+		slaunch_finalize(0);
 	}
+
 	/* A fallback in case there is no PM info available */
 	tboot_shutdown(TB_SHUTDOWN_HALT);
 }
@@ -826,6 +839,7 @@ void machine_shutdown(void)
 
 void machine_emergency_restart(void)
 {
+	slaunch_finalize(0);
 	__machine_emergency_restart(1);
 }
 
-- 
2.47.3

