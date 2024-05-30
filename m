Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A84C3DAC0A;
	Thu, 30 May 2024 12:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717071914; cv=none; b=mIwT80g8KhmFPPhvbj86yV8hgkSLbeUnNDkAzBhx9v545cUGvqHrh2zc1VpXvgK8UoEHyzxWdu3jmJhk3cFTfgatorgVuVt5YYGAgeFZQhXaiVFSvrt9+WgrwewpJinXIf8OxmyRTq83p6njwXsU0V13AHgokbEZ5S4LhFs1zrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717071914; c=relaxed/simple;
	bh=9tPSic6hw+WTgG3/VYBiNDE1D7tn9WTQ2aYblkqRazg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z95zaWmMllsF69jjlPRmWNJ6I2iLhuxKE8JDnErerPm1AWIkIMycn5Ykym2EqJz7wfsEFQRRaIjJlfAhcNedV34ftiwwuSiP5MIl/2Sves6yG7ZXffhvsnOpuE0FML/iziw1m+RgR5UoZk8R21CrKQyRfcnieU09xXjNGVz9U+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=pfW6M+RB; arc=none smtp.client-ip=198.47.19.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="pfW6M+RB"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 44UCOevS073964;
	Thu, 30 May 2024 07:24:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1717071880;
	bh=9L+vI9mpqteE4RtnIqd2nlMIeDRwSOPZbKRlca9fqSA=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=pfW6M+RBWStqYgJ5SD2UfQ+DTbMzLAA8AmrXndPkklpbxsocfB0yUCo6jmHLJX2j3
	 xnvE+EwHCujw98/kRPgp3OWNBJUF8SYz5bp6G+vt4yOsbOOZxqr3tmqB3NEyvqHUG0
	 gsd0E+S1IGc8uj50E+X6jzjRSuRqN7sKokFe0rHc=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 44UCOe2i094840
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 30 May 2024 07:24:40 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 30
 May 2024 07:24:40 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 30 May 2024 07:24:40 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 44UCOdFE070486;
	Thu, 30 May 2024 07:24:40 -0500
From: <kamlesh@ti.com>
To: <herbert@gondor.apana.org.au>, <kristo@kernel.org>, <will@kernel.org>
CC: <akpm@linux-foundation.org>, <davem@davemloft.net>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
        <robh@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <conor+dt@kernel.org>, <vigneshr@ti.com>, <catalin.marinas@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Kamlesh
 Gurudasani <kamlesh@ti.com>
Subject: [PATCH v3 1/6] lib: add ISO 3309 model crc64
Date: Thu, 30 May 2024 17:54:23 +0530
Message-ID: <20240524-mcrc64-upstream-v3-1-24b94d8e8578@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240524-mcrc64-upstream-v3-0-24b94d8e8578@ti.com>
References: <20240524-mcrc64-upstream-v3-0-24b94d8e8578@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180

From: Kamlesh Gurudasani <kamlesh@ti.com>

Add the polynomial to the crc64 table generation, and provide a
generic library routine implementing the algorithm.

64-bit cyclic redundancy checks (CRC) according to the ISO 3309:1991
standard.

The ISO 3309:1991 64-bit CRC model parameters are as follows:
    Generator Polynomial: x^64 + x^4 + x^3 + x + 1
    Polynomial Value: 0x000000000000001B
    Initial value: 0x0000000000000000
    Reflected Input: False
    Reflected Output: False
    Xor Final: 0x0000000000000000

Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
---
 include/linux/crc64.h |  1 +
 lib/crc64.c           | 27 +++++++++++++++++++++++++++
 lib/gen_crc64table.c  |  6 ++++++
 3 files changed, 34 insertions(+)

diff --git a/include/linux/crc64.h b/include/linux/crc64.h
index e044c60d1e61..b791316f251c 100644
--- a/include/linux/crc64.h
+++ b/include/linux/crc64.h
@@ -10,6 +10,7 @@
 #define CRC64_ROCKSOFT_STRING "crc64-rocksoft"
 
 u64 __pure crc64_be(u64 crc, const void *p, size_t len);
+u64 __pure crc64_iso3309_generic(u64 crc, const void *p, size_t len);
 u64 __pure crc64_rocksoft_generic(u64 crc, const void *p, size_t len);
 
 u64 crc64_rocksoft(const unsigned char *buffer, size_t len);
diff --git a/lib/crc64.c b/lib/crc64.c
index 61ae8dfb6a1c..40369dd26812 100644
--- a/lib/crc64.c
+++ b/lib/crc64.c
@@ -22,6 +22,11 @@
  * x^24 + x^23 + x^22 + x^21 + x^19 + x^17 + x^13 + x^12 + x^10 + x^9 +
  * x^7 + x^4 + x + 1
  *
+ * crc64iso3309table[256] table is from the ISO-3309:1991 specification
+ * polynomial defined as,
+ *
+ * x^64 + x^4 + x^3 + x + 1
+ *
  * crc64rocksoft[256] table is from the Rocksoft specification polynomial
  * defined as,
  *
@@ -63,6 +68,28 @@ u64 __pure crc64_be(u64 crc, const void *p, size_t len)
 }
 EXPORT_SYMBOL_GPL(crc64_be);
 
+/**
+ * crc64_iso3309_generic - Calculate bitwise ISO3309 CRC64
+ * @crc: seed value for computation. 0 for a new CRC calculation, or the
+ *	 previous crc64 value if computing incrementally.
+ * @p: pointer to buffer over which CRC64 is run
+ * @len: length of buffer @p
+ */
+u64 __pure crc64_iso3309_generic(u64 crc, const void *p, size_t len)
+{
+	size_t i, t;
+
+	const unsigned char *_p = p;
+
+	for (i = 0; i < len; i++) {
+		t = ((crc >> 56) ^ (*_p++)) & 0xFF;
+		crc = crc64iso3309table[t] ^ (crc << 8);
+	}
+
+	return crc;
+}
+EXPORT_SYMBOL_GPL(crc64_iso3309_generic);
+
 /**
  * crc64_rocksoft_generic - Calculate bitwise Rocksoft CRC64
  * @crc: seed value for computation. 0 for a new CRC calculation, or the
diff --git a/lib/gen_crc64table.c b/lib/gen_crc64table.c
index 55e222acd0b8..abc860487463 100644
--- a/lib/gen_crc64table.c
+++ b/lib/gen_crc64table.c
@@ -17,9 +17,11 @@
 #include <stdio.h>
 
 #define CRC64_ECMA182_POLY 0x42F0E1EBA9EA3693ULL
+#define CRC64_ISO3309_POLY 0x000000000000001BULL
 #define CRC64_ROCKSOFT_POLY 0x9A6C9329AC4BC9B5ULL
 
 static uint64_t crc64_table[256] = {0};
+static uint64_t crc64_iso3309_table[256] = {0};
 static uint64_t crc64_rocksoft_table[256] = {0};
 
 static void generate_reflected_crc64_table(uint64_t table[256], uint64_t poly)
@@ -82,6 +84,9 @@ static void print_crc64_tables(void)
 	printf("static const u64 ____cacheline_aligned crc64table[256] = {\n");
 	output_table(crc64_table);
 
+	printf("\nstatic const u64 ____cacheline_aligned crc64iso3309table[256] = {\n");
+	output_table(crc64_iso3309_table);
+
 	printf("\nstatic const u64 ____cacheline_aligned crc64rocksofttable[256] = {\n");
 	output_table(crc64_rocksoft_table);
 }
@@ -89,6 +94,7 @@ static void print_crc64_tables(void)
 int main(int argc, char *argv[])
 {
 	generate_crc64_table(crc64_table, CRC64_ECMA182_POLY);
+	generate_crc64_table(crc64_iso3309_table, CRC64_ISO3309_POLY);
 	generate_reflected_crc64_table(crc64_rocksoft_table, CRC64_ROCKSOFT_POLY);
 	print_crc64_tables();
 	return 0;

-- 
2.34.1
