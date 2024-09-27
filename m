Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92C2171E76;
	Fri, 27 Sep 2024 18:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462814; cv=none; b=Dxo4rT4rEKRNr0Y2YagR4C4CdKGtIm8WFl/a21VhaK9MaDwutEIZmJ5wboGyrbCXQqIzes0B3bnwAAO2vepXTQ0z8Tg3iQfAvYw0hMBQXTjXWx8bI2dKCSv+/BAJ0Okn5HgChljHM66WUXcMjYPmdv/Ms/oU/an+aCON6atKKrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462814; c=relaxed/simple;
	bh=IhHEjvPxQf+RDdoLilNZ8Cw+tcPLXWdx9ZxWbieFqVk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=I/1oucWJbU8r8lyHIQ26GZdcO/6YEXeItWuNz/pZ96aGbGqQOZeZZrqMebW4BacnHwOxS4ibYKm2SSRkVSg38DLrIJCEJzRrJg4RG74Bz/80tiYpxgDPn+xc93uTNTFxMvvzoQIivpyNnGKQAX7/NTlnfwOXen66A8AiYopF3Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nqshLzfE; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nqshLzfE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727462814; x=1758998814;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=IhHEjvPxQf+RDdoLilNZ8Cw+tcPLXWdx9ZxWbieFqVk=;
  b=nqshLzfET3C4N46etxJWFjMp6xcf+OnofdeKIFFM7HpsypMjo5ISyspK
   QH0L5gBtxRcLYUhlTDthkZpBE8B6z4U3KVL/RgujwqQt5clknlyGevCyA
   yY4Fv+WHXT+rlysKSehV+sJdznZhC4DdaRvz1ANjT4MC/VYh/+Lue64E8
   19BwBIzo5RlxMMQw+ebZb75viAIZHecfLHI4MDA/HBbSj59SNYAjBoOBy
   1shFBcuaG3djngpp+OLEEsZp6WJ7do6WbkiXn/Rx/XCZTf+42qPsWVoPJ
   wu40H79GEyzpqvGINvxawiIRrWutpjPNKUYgDGTNkRgHTiDziPMhQDa1o
   A==;
X-CSE-ConnectionGUID: f89ML4c6SESfmbRN0M2fVg==
X-CSE-MsgGUID: CwFZQ657TY2yuPC6/bMIaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11208"; a="26421548"
X-IronPort-AV: E=Sophos;i="6.11,159,1725346800"; 
   d="scan'208";a="26421548"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2024 11:46:53 -0700
X-CSE-ConnectionGUID: L2qlIXE1SXGpMWrouFPlAA==
X-CSE-MsgGUID: rnDkqNmqSH+VAtus7/xSFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,159,1725346800"; 
   d="scan'208";a="103396006"
Received: from tzanussi-mobl4.amr.corp.intel.com (HELO [10.246.129.181]) ([10.246.129.181])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2024 11:46:51 -0700
Message-ID: <91e2a30c-d00b-4648-8b48-24467dca17dc@linux.intel.com>
Date: Fri, 27 Sep 2024 13:46:49 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 1/2] crypto: iaa - Remove potential infinite loop in
 check_completion()
Content-Language: en-GB
From: "Zanussi, Tom" <tom.zanussi@linux.intel.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
 linux-kernel <linux-kernel@vger.kernel.org>,
 "Accardi, Kristen C" <kristen.c.accardi@intel.com>, zanussi@kernel.org
References: <733a19ce-16f2-4d06-bce9-85d7473c9a4d@linux.intel.com>
In-Reply-To: <733a19ce-16f2-4d06-bce9-85d7473c9a4d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For iaa_crypto operations, it's assumed that if an operation doesn't
make progress, the IAA watchdog timer will kick in and set the
completion status bit to failure and the reason to completion timeout.

Some systems may have broken hardware that doesn't even do that, which
can result in an infinite status-checking loop. Add a check for that
in the loop, and disable the driver if it occurs.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 237f87000070..8fced88d3d06 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -945,12 +945,22 @@ static inline int check_completion(struct device *dev,
 				   bool only_once)
 {
 	char *op_str = compress ? "compress" : "decompress";
+	int status_checks = 0;
 	int ret = 0;
 
 	while (!comp->status) {
 		if (only_once)
 			return -EAGAIN;
 		cpu_relax();
+		if (status_checks++ >= IAA_COMPLETION_TIMEOUT) {
+			/* Something is wrong with the hw, disable it. */
+			dev_err(dev, "%s completion timed out - "
+				"assuming broken hw, iaa_crypto now DISABLED\n",
+				op_str);
+			iaa_crypto_enabled = false;
+			ret = -ETIMEDOUT;
+			goto out;
+		}
 	}
 
 	if (comp->status != IAX_COMP_SUCCESS) {
-- 
2.38.1


