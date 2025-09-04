Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29427286426;
	Thu,  4 Sep 2025 16:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001715; cv=none; b=bpNIRJy2FOwQww8mcBpxCAkMfG70PDSmdikJhO5pNcMS+QoHRLZsjQpaYk/MowC9jBmdWQiaBz++WNE0+SRDSbxkNZovFRYQQkotMYzv1nPZVPNkU7+sP61QjpbhWqgKyY1+HviIn/SYAofGFKkCXjuaOMgU8bz21r1nVf21Nl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001715; c=relaxed/simple;
	bh=gk1+7DP4RJWxX401FWos70WPx+wwoqyOppKWrGsQp6k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E+qI8obqbLPRVcRS++/sfmH+xosm9UGRrDSXaz/5UxXvB9ZmkngmsjStzGwx8XeVnv1ZF8EfnYXtGvCBM5E83UKscfWxImSP/fJCh0Pp/13+ZN6YktglaTImDTyQVkGttTrkuIJnnOJWBr/FeDqhlWOS6JQOtMI9f+LrU4oEZEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S/nGSTS3; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S/nGSTS3"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtjXh009095;
	Thu, 4 Sep 2025 16:01:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pTaSS4AGiiAe6sJK+MLwncDCGDWjRTXD7gjIfaagAVU=; b=
	S/nGSTS3bAvRuHN0BIs2+P9KzVH+GHEKN7XTUldV3rFeVV7wnuEI/aZ/S8z6NhFN
	Knyr5belA5I7wUoZ6t2OFY3FhbsdJ5ue/2SBpANpbcYGapzQV2W6wpuQXXQ8NK6Z
	we647DjbzDAvzHLyYX7Be0KR0ga6xM4j5WjzjfTUBOqx+0FDpNOrc06+SYz72vwM
	6XO2p7YHI0eN2dOm6AGvHJSMLtfbpvCE3JrojYuijdx9iPsw/0tF+5MyDBmn4D5F
	1tmxo3sHZMi+cIaObpLU62z9NvKNUm24774RpmBUgOnA7639v7AkmAc0laxhM28m
	32BHYGDRQMnnSR1lCGS9fA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydtt00h5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FPlYP040063;
	Thu, 4 Sep 2025 16:01:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtu8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:41 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx8C000707;
	Thu, 4 Sep 2025 16:01:41 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-103;
	Thu, 04 Sep 2025 16:01:40 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH RFC 102/104] scripts/extract-fips140: new script
Date: Thu,  4 Sep 2025 17:52:14 +0200
Message-Id: <20250904155216.460962-103-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040157
X-Proofpoint-ORIG-GUID: 5Q0Po5rUrZ6SmaNikPvC_BoWH0wgTjV4
X-Authority-Analysis: v=2.4 cv=NeDm13D4 c=1 sm=1 tr=0 ts=68b9b7e6 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=73jrQIzkXWH-B8LFBj8A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX8zyih8rHqMOc
 cbAzNIz0uCOUlMYyWmNNnsF5NCOxHvKdEw1ybm2bY/IA8cavnhkEHi39wMU5S0j+XsLP6bTEmPI
 hqlaECXXiXPPxwfaKhumqLldpFOLhLoHkJNwHlco1TH1QBDu6ZM8X69HuOpjMG8nalYEXfV7DGL
 EhnVr83T+v3OIGPijjA4tHi8t3X+KyXI4GxpeK9ZkyAUL9KUCM9V9t9ETeyGeD4O1gBcFBgDV0w
 ZFAM9GItgf9ADmH0HvIkowavFZePG8fe4BJphOYv84OVXqaWIcfxUqg3wzQr5DP1bnqcCnrz7x7
 vHxcdBpecN+PKy3/OqcEtE/LeuMUf4uEGSqKgulqSpDgF8WTNCpANqINo2+J3LfL3NJ1vWfPFzz
 olu3/6iudNrruBzbuhEKiIz5yHqcIg==
X-Proofpoint-GUID: 5Q0Po5rUrZ6SmaNikPvC_BoWH0wgTjV4

Add a new script to extract a precompiled FIPS 140 module (.ko), its
authenticated digest (.hmac), and optionally also the .a of modules, from
a vmlinuz file.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 scripts/extract-fips140 | 53 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100755 scripts/extract-fips140

diff --git a/scripts/extract-fips140 b/scripts/extract-fips140
new file mode 100755
index 000000000000..00ec7631fa3c
--- /dev/null
+++ b/scripts/extract-fips140
@@ -0,0 +1,53 @@
+#! /usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Extract FIPS 140 cryptographic module (and hmac) from vmlinuz.
+#
+# Copyright © 2025, Oracle and/or its affiliates.
+#
+
+import argparse
+import os
+import shutil
+import subprocess
+import sys
+import tempfile
+
+extract_vmlinux = os.path.join(os.path.dirname(__file__), 'extract-vmlinux')
+
+parser = argparse.ArgumentParser()
+parser.add_argument('vmlinux')
+
+args = parser.parse_args()
+
+warnings = False
+
+with tempfile.TemporaryDirectory() as tmp_dir:
+    vmlinux_path = os.path.join(tmp_dir, 'vmlinux')
+    with open(vmlinux_path, 'w') as f:
+        subprocess.check_call([extract_vmlinux, args.vmlinux], stdout=f)
+
+    def extract_section(input_path, output_path, section):
+        tmp_output_path = os.path.join(tmp_dir, output_path)
+
+        subprocess.check_call([
+            'objcopy',
+            '--only-section', section,
+            '--output-target', 'binary',
+            input_path,
+            tmp_output_path,
+        ])
+
+        if os.path.getsize(tmp_output_path) == 0:
+            print(f"warning: failed to extract {output_path}; empty section {section}?", file=sys.stderr)
+            global warnings
+            warnings = True
+        else:
+            shutil.move(tmp_output_path, output_path)
+            print(f"extracted {output_path}")
+
+    extract_section(vmlinux_path, 'fips140.ko', '__fips140_module')
+    extract_section(vmlinux_path, 'fips140.hmac', '__fips140_digest')
+
+if warnings:
+    sys.exit(1)
-- 
2.39.3

