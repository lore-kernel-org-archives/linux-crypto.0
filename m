Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506503AAF5F
	for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2026 01:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789780094; cv=none; b=MoA3Xe1MP0saPyYSPZQOJ5Uq+OYRl3pAvY6haVkVlR5zvsFU97L6PR7Q5o54qM4ArR43U7vvpG6CNUNE/Z7XA8T/0Iqwl1fxl3AkeoBBHyb0MnFW6gP3lQxgzm8vQSI6mg3U1iDAI8bsEjtO1HCKmPmISWA5thXu2vaOxyrdrZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789780094; c=relaxed/simple;
	bh=EQFrQWiJlGagT7w4+GhBtSvH31/scfS3RFyv8b+wXzA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QFz/x/gcQKtcy4rvDEACaIH358MF6VbprW/nv0njX0UU023p3r0fUgTBpaW3/+HVauzsH1unRP63vdsFBVkQLPGup4Tw1dmG4f9l4Qn6LdALNQAU7aK1xVO8YitNlVIxgS+fLj1QhPy1wa6B7pycc4Wkcb1LbUZtkq5QWGEInYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GSn6W/M2; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GSn6W/M2"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39dbdfaef3cso1256399a91.1
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 18:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789780083; x=1790384883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=D3Zb0gAgIAZPALGu7730yya+hZVxWCGnJ23L/bCuQ7k=;
        b=GSn6W/M2wO/XtXODftKeL6Q1pM6bfnO9W0/VB8Xum2z4o2GPs2fu/jEr9D8FipUpEu
         kP5kUG1cgXurRHUZjKvHjSZI28sH4gBvQJi6+zydyvYCcW1200D1G8gaBvZUWwDlBV+N
         kcFqATHROUJSZ31yXMqFnqMTyxmafGqD95IWF1wPrczyhpcThDRETshNMYa9+iKmtH4s
         4sCDde5W2ax2iXSJIW9g4i8+SokTOY7QMY2w0nNIQhj3umG+iQEsnG2tObqM7/ZodEyP
         nP44EKc3Q8H27QEEdLHR4zMSkRJ9NYgt/sGqu3ufbBHvzA5JHHs5/aeWNXx+h4bnm7uO
         lnCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789780083; x=1790384883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D3Zb0gAgIAZPALGu7730yya+hZVxWCGnJ23L/bCuQ7k=;
        b=2r+xhFwGsyPKyU+OUSMpv23PhpxOPbO7G+qK4rg8cvGJOpveibpbrfR4t4WkFsmZQg
         W2R4AtWNF53Pwwv5Jgmxh0AmUZUqwyroSm5Wy6iemVex2mO5FrbAQmbdSpVp4As4Nfht
         jwbJXpCxyNjXvhns4CkJHrA/UIRNeZ+gs7M7rNDQ0LpDUm5SSS0Ddk3iPqjVj0w+32Ux
         D/duMyGJfUA57JOqMhcThoSRaH1UC/pwV6vlS+dxQxlHdkpP4/bRsoa4koWmpq1hDxh2
         tHAbUblI6HF2YxC8k7rtI6mh3DpdQRJkNGVOqkO9NG6bjQr6dm8ZtvasWw280+KunR17
         KpSQ==
X-Gm-Message-State: AFuF++mOM2bdYandpQtAbVC1Swm/ZOe2TlJwN+0sR2+K7EUl0nI3Y0hD
	dzytZeGcWsQbRPskANE9lxZ4Q9Z05R+KA2FrLzxqSc8UMQlUSYUQpfABsDCQ9w==
X-Gm-Gg: AYBFou2Hv+hwWkQH1kwO4bmatc/NJ7MdLYldasLK3wDCWwsAMfvI7kkPNVTeYO0bzf2
	n6+IoItnP3FfCh4+2H92nij0C4pIkm1d/cStsygdMvcKS2CiDv5Fd64xSDoRiOBzOPxn/INOBi5
	Wn9Qu5JYa14aGJf/4tCFGrwlDfrgbfQKZ1sLjWTMNanf8RpO3fhveeh5zpQqbEmzh24ro91pATR
	tkrt4zoE45DzAr+HgHpdREXbG8ksTw2yDUZ0g/wNH8mfM1W1B4zVz/3L+aUNdI+fy48bXzlvu0V
	FqcSzz6v0YOdSBjD6qvgiWVMYPS2tsKBzfcD0W75pQ21EX2NvUdzE1uzILIbAAFpigzcmmDhV0g
	s1OcT3rs/mQJaKIsQ0qm/+sRgCfi6Yd+6q5oyqcw/R/8BTxiFwl9mewy9CSDRj9YLZigYyGEHy0
	NEV3LSwzkF96PVeFGjuAP1r532OcomFCUDhRp5zlIfcPL/CTT0NOWCsysn1k3WjxHcttPmzabP7
	PE4gOIJPWBEjJdwlVTDMFIE0qyF9ZiIDb5PhojYHshXs80THiITpZEO/ysSGuPK4Lz4/n1+Pi7q
	tpFUa4h728u2AOlwWMqNHBE+jRGsgKxWGTLaskThEZpODwop
X-Received: by 2002:a17:90b:498c:b0:39e:6c69:776e with SMTP id 98e67ed59e1d1-39e6c69790bmr3148763a91.23.1789780083241;
        Fri, 18 Sep 2026 18:08:03 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c615f05sm1742115a91.15.2026.09.18.18.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 18:08:01 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: eip93 - bound the wait for PE completion
Date: Fri, 18 Sep 2026 18:08:00 -0700
Message-ID: <20260919010800.754521-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tasklet drains result descriptors by polling the descriptor's ready
bits in an unbounded loop. If the DMA engine stalls or reports an error
state instead of PE_READY, the loop busy-waits in softirq context and
locks up the CPU (soft lockup).

Replace the open-coded loop with read_poll_timeout_atomic(), giving the
hardware a 1 ms window to write the result before the tasklet gives up
and re-enables the RDR interrupt.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 .../crypto/inside-secure/eip93/eip93-main.c   | 31 ++++++++++++++-----
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index e62785952b0d..11e20ce33dce 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
+#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -183,6 +184,22 @@ static int eip93_register_algs(struct eip93_device *eip93, u32 supported_algo_fl
 	return ret;
 }
 
+#define EIP93_PE_READY_POLL_TIMEOUT_US	1000
+
+static inline u32 eip93_ctrl_status(const struct eip93_descriptor *rdesc)
+{
+	return READ_ONCE(rdesc->pe_ctrl_stat_word);
+}
+
+static inline bool eip93_desc_is_ready(const struct eip93_descriptor *rdesc,
+				       u32 pe_ctrl_stat)
+{
+	return FIELD_GET(EIP93_PE_CTRL_PE_READY_DES_TRING_OWN,
+			 pe_ctrl_stat) == EIP93_PE_CTRL_PE_READY &&
+	       FIELD_GET(EIP93_PE_LENGTH_HOST_PE_READY,
+			 READ_ONCE(rdesc->pe_length_word)) == EIP93_PE_LENGTH_PE_READY;
+}
+
 static void eip93_handle_result_descriptor(struct eip93_device *eip93)
 {
 	struct crypto_async_request *async;
@@ -191,7 +208,6 @@ static void eip93_handle_result_descriptor(struct eip93_device *eip93)
 	bool last_entry;
 	int handled, left, err;
 	u32 pe_ctrl_stat;
-	u32 pe_length;
 
 get_more:
 	handled = 0;
@@ -216,13 +232,12 @@ static void eip93_handle_result_descriptor(struct eip93_device *eip93)
 			break;
 		}
 		/* make sure DMA is finished writing */
-		do {
-			pe_ctrl_stat = READ_ONCE(rdesc->pe_ctrl_stat_word);
-			pe_length = READ_ONCE(rdesc->pe_length_word);
-		} while (FIELD_GET(EIP93_PE_CTRL_PE_READY_DES_TRING_OWN, pe_ctrl_stat) !=
-			 EIP93_PE_CTRL_PE_READY ||
-			 FIELD_GET(EIP93_PE_LENGTH_HOST_PE_READY, pe_length) !=
-			 EIP93_PE_LENGTH_PE_READY);
+		err = read_poll_timeout_atomic(eip93_ctrl_status, pe_ctrl_stat,
+					       eip93_desc_is_ready(rdesc, pe_ctrl_stat),
+					       1, EIP93_PE_READY_POLL_TIMEOUT_US,
+					       false, rdesc);
+		if (err)
+			return;
 
 		err = rdesc->pe_ctrl_stat_word & (EIP93_PE_CTRL_PE_EXT_ERR_CODE |
 						  EIP93_PE_CTRL_PE_EXT_ERR |
-- 
2.55.0

