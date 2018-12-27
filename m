Return-Path: <SRS0=t27p=PE=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41328 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729577AbeL0LIM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Dec 2018 06:08:12 -0500
Received: by mail-pf1-f194.google.com with SMTP id b7so9028635pfi.8
        for <linux-crypto@vger.kernel.org>; Thu, 27 Dec 2018 03:08:11 -0800 (PST)
From: Sumit Garg <sumit.garg@linaro.org>
To: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Cc: mpm@selenic.com, herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        jens.wiklander@linaro.org, daniel.thompson@linaro.org,
        ard.biesheuvel@linaro.org, bhsharma@redhat.com,
        tee-dev@lists.linaro.org, Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH v1 1/2] dt/bindings: add bindings for optional optee rng-uuid property
Date: Thu, 27 Dec 2018 16:37:10 +0530
Message-Id: <1545908831-25910-2-git-send-email-sumit.garg@linaro.org>
In-Reply-To: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
References: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add bindings for OP-TEE based optional hardware random number
generator identifier property. It could be used on ARM based devices
where entropy source is not accessible to normal world (linux in this
case).

Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
index d38834c..e3a4c35 100644
--- a/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
+++ b/Documentation/devicetree/bindings/arm/firmware/linaro,optee-tz.txt
@@ -20,6 +20,9 @@ the reference implementation maintained by Linaro.
                    "hvc" : HVC #0, with the register assignments specified
 		           in drivers/tee/optee/optee_smc.h
 
+- rng-uuid       : Optional OP-TEE based RNG service identifier in case
+                   hardware entropy source is not accesible to normal world
+                   (Linux).
 
 
 Example:
@@ -27,5 +30,6 @@ Example:
 		optee {
 			compatible = "linaro,optee-tz";
 			method = "smc";
+			rng-uuid = "ab7a617c-b8e7-4d8f-8301-d09b61036b64";
 		};
 	};
-- 
2.7.4
