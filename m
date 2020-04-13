Return-Path: <SRS0=MzAP=55=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07152C2BA19
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Apr 2020 16:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB03C2072D
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Apr 2020 16:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731190AbgDMQAI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Apr 2020 12:00:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65120 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731187AbgDMQAE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Apr 2020 12:00:04 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03DFYCpg025857;
        Mon, 13 Apr 2020 11:59:49 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30b96t2cd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Apr 2020 11:59:49 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03DFuUSB025323;
        Mon, 13 Apr 2020 15:59:48 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 30b5h61ems-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Apr 2020 15:59:48 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03DFxlxd49545650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 15:59:47 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A89BC6059;
        Mon, 13 Apr 2020 15:59:47 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6EA4C6055;
        Mon, 13 Apr 2020 15:59:46 +0000 (GMT)
Received: from localhost (unknown [9.85.151.130])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 13 Apr 2020 15:59:46 +0000 (GMT)
From:   Raphael Moreira Zinsly <rzinsly@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        dja@axtens.net
Cc:     rzinsly@linux.ibm.com, herbert@gondor.apana.org.au,
        mpe@ellerman.id.au, haren@linux.ibm.com, abali@us.ibm.com
Subject: [PATCH V3 5/5] selftests/powerpc: Add README for GZIP engine tests
Date:   Mon, 13 Apr 2020 12:59:16 -0300
Message-Id: <20200413155916.16900-6-rzinsly@linux.ibm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200413155916.16900-1-rzinsly@linux.ibm.com>
References: <20200413155916.16900-1-rzinsly@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-13_07:2020-04-13,2020-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 adultscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130118
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
 .../testing/selftests/powerpc/nx-gzip/README  | 46 +++++++++++++++++++
 2 files changed, 47 insertions(+)
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
index 000000000000..9a491daaef4d
--- /dev/null
+++ b/tools/testing/selftests/powerpc/nx-gzip/README
@@ -0,0 +1,46 @@
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
+file gzip_vas.c read, 6418 bytes
+compressed 6418 to 3131 bytes total, crc32 checksum = 96b9717d
+
+
+Uncompress the previous output. Output will have a .nx.gunzip suffix:
+./gunz_test gzip_vas.c.nx.gz
+gzHeader FLG 0
+00 00 00 00 04 03
+gzHeader MTIME, XFL, OS ignored
+computed checksum 96b9717d isize 00001912
+stored   checksum 96b9717d isize 00001912
+decomp is complete: fclose
+
+
+Compare two files:
+$ sha1sum gzip_vas.c.nx.gz.nx.gunzip gzip_vas.c
+4c0b494f657c0c89a7d9f87dd3da8597be9a887a  gzip_vas.c.nx.gz.nx.gunzip
+4c0b494f657c0c89a7d9f87dd3da8597be9a887a  gzip_vas.c
+
+
+Note that the code here are intended for testing the nx-gzip hardware function.
+They are not intended for demonstrating performance or compression ratio.
+By being simplistic these selftests expect to allocate the entire set of source
+and target pages in the memory so it needs enough memory to work.
+For more information and source code consider using:
+https://github.com/libnxz/power-gzip
-- 
2.21.0

