Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A54C3F2CE
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 18:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FE9420719
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 18:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732270AbgCPSIR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 14:08:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29592 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732338AbgCPSIR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 14:08:17 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02GHpVTo018618;
        Mon, 16 Mar 2020 14:08:07 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yrtk6x59f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Mar 2020 14:08:07 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02GI6Us7005327;
        Mon, 16 Mar 2020 18:08:06 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 2yrpw66cwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Mar 2020 18:08:06 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02GI832U52036074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 18:08:03 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2024BBE051;
        Mon, 16 Mar 2020 18:08:03 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A69D7BE04F;
        Mon, 16 Mar 2020 18:08:02 +0000 (GMT)
Received: from localhost (unknown [9.85.153.64])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 16 Mar 2020 18:08:02 +0000 (GMT)
From:   Raphael Moreira Zinsly <rzinsly@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, mpe@ellerman.id.au,
        haren@linux.ibm.com, abali@us.ibm.com,
        Raphael Moreira Zinsly <rzinsly@linux.ibm.com>
Subject: [PATCH 5/5] selftests/powerpc: Add README for GZIP engine tests
Date:   Mon, 16 Mar 2020 15:07:14 -0300
Message-Id: <20200316180714.18631-6-rzinsly@linux.ibm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200316180714.18631-1-rzinsly@linux.ibm.com>
References: <20200316180714.18631-1-rzinsly@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-16_08:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 clxscore=1015 suspectscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160078
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Include a README file with the instructions to use the
testcases at selftests/powerpc/nx-gzip.

Signed-off-by: Bulent Abali <abali@us.ibm.com>
Signed-off-by: Raphael Moreira Zinsly <rzinsly@linux.ibm.com>
---
 .../powerpc/nx-gzip/99-nx-gzip.rules          |  1 +
 .../testing/selftests/powerpc/nx-gzip/README  | 44 +++++++++++++++++++
 2 files changed, 45 insertions(+)
 create mode 100644 tools/testing/selftests/powerpc/nx-gzip/99-nx-gzip.rules
 create mode 100644 tools/testing/selftests/powerpc/nx-gzip/README

diff --git a/tools/testing/selftests/powerpc/nx-gzip/99-nx-gzip.rules b/tools/testing/selftests/powerpc/nx-gzip/99-nx-gzip.rules
new file mode 100644
index 000000000000..5a7118495cb3
--- /dev/null
+++ b/tools/testing/selftests/powerpc/nx-gzip/99-nx-gzip.rules
@@ -0,0 +1 @@
+SUBSYSTEM=="nxgzip", KERNEL=="nx-gzip", MODE="0666"
diff --git a/tools/testing/selftests/powerpc/nx-gzip/README b/tools/testing/selftests/powerpc/nx-gzip/README
new file mode 100644
index 000000000000..ff0c817a65c5
--- /dev/null
+++ b/tools/testing/selftests/powerpc/nx-gzip/README
@@ -0,0 +1,44 @@
+Test the nx-gzip function:
+=========================
+
+Verify that following device exists:
+  /dev/crypto/nx-gzip
+If you get a permission error run as sudo or set the device permissions:
+   sudo chmod go+rw /dev/crypto/nx-gzip
+However, chmod may not survive across boots. You may create a udev file such
+as:
+   /etc/udev/rules.d/99-nx-gzip.rules
+
+
+Then make and run:
+$ make
+gcc -O3 -I./inc -o gzfht_test gzfht_test.c gzip_vas.c
+gcc -O3 -I./inc -o gunz_test gunz_test.c gzip_vas.c
+
+
+Compress any file using Fixed Huffman mode. Output will have a .nx.gz suffix:
+$ ./gzfht_test gzip_vas.c
+file gzip_vas.c read, 5276 bytes
+compressed 5276 to 2564 bytes total, crc32 checksum = b937a37d
+
+
+Uncompress the previous output. Output will have a .nx.gunzip suffix:
+$ ./gunz_test gzip_vas.c.nx.gz
+gzHeader FLG 0
+00 00 00 00 04 03
+gzHeader MTIME, XFL, OS ignored
+computed checksum b937a37d isize 0000149c
+stored   checksum b937a37d isize 0000149c
+decomp is complete: fclose
+
+
+Compare two files:
+$ sha1sum gzip_vas.c.nx.gz.nx.gunzip gzip_vas.c
+f041cd8581e8d920f79f6ce7f65411be5d026c2a  gzip_vas.c.nx.gz.nx.gunzip
+f041cd8581e8d920f79f6ce7f65411be5d026c2a  gzip_vas.c
+
+
+Note that the code here are intended for testing the nx-gzip hardware function.
+They are not intended for demonstrating performance or compression ratio.
+For more information and source code consider using:
+https://github.com/libnxz/power-gzip
-- 
2.21.0

