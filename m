Return-Path: <SRS0=BVES=6E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847E5C55181
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 20:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68DB4207FC
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 20:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgDTU4d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Apr 2020 16:56:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62930 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbgDTU4c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Apr 2020 16:56:32 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03KKXFA6110886;
        Mon, 20 Apr 2020 16:56:21 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmu9s531-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 16:56:18 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03KKtDGw012262;
        Mon, 20 Apr 2020 20:56:10 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 30fs66gt8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 20:56:10 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03KKu9UE49480158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 20:56:09 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4A1AAC059;
        Mon, 20 Apr 2020 20:56:09 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CE47AC05B;
        Mon, 20 Apr 2020 20:56:09 +0000 (GMT)
Received: from localhost (unknown [9.85.196.70])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 20:56:09 +0000 (GMT)
From:   Raphael Moreira Zinsly <rzinsly@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        dja@axtens.net
Cc:     rzinsly@linux.ibm.com, herbert@gondor.apana.org.au,
        mpe@ellerman.id.au, haren@linux.ibm.com, abali@us.ibm.com
Subject: [PATCH V4 5/5] selftests/powerpc: Add README for GZIP engine tests
Date:   Mon, 20 Apr 2020 17:55:38 -0300
Message-Id: <20200420205538.25181-6-rzinsly@linux.ibm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200420205538.25181-1-rzinsly@linux.ibm.com>
References: <20200420205538.25181-1-rzinsly@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_08:2020-04-20,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200162
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
 .../testing/selftests/powerpc/nx-gzip/README  | 45 +++++++++++++++++++
 2 files changed, 46 insertions(+)
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
index 000000000000..9809dbaa1905
--- /dev/null
+++ b/tools/testing/selftests/powerpc/nx-gzip/README
@@ -0,0 +1,45 @@
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
+To manually build and run:
+$ gcc -O3 -I./include -o gzfht_test gzfht_test.c gzip_vas.c
+$ gcc -O3 -I./include -o gunz_test gunz_test.c gzip_vas.c
+
+
+Compress any file using Fixed Huffman mode. Output will have a .nx.gz suffix:
+$ ./gzfht_test gzip_vas.c
+file gzip_vas.c read, 6413 bytes
+compressed 6413 to 3124 bytes total, crc32 checksum = abd15e8a
+
+
+Uncompress the previous output. Output will have a .nx.gunzip suffix:
+./gunz_test gzip_vas.c.nx.gz
+gzHeader FLG 0
+00 00 00 00 04 03
+gzHeader MTIME, XFL, OS ignored
+computed checksum abd15e8a isize 0000190d
+stored   checksum abd15e8a isize 0000190d
+decomp is complete: fclose
+
+
+Compare two files:
+$ sha1sum gzip_vas.c.nx.gz.nx.gunzip gzip_vas.c
+bf43e3c0c3651f5f22b6f9784cd9b1eeab4120b6  gzip_vas.c.nx.gz.nx.gunzip
+bf43e3c0c3651f5f22b6f9784cd9b1eeab4120b6  gzip_vas.c
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

