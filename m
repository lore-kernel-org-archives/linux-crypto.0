Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D41415F15;
	Thu, 13 Aug 2026 15:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786636460; cv=none; b=SONLDx6CHzQROMyewc8u5OmRyUpl1b7VrIBXNzh1NRYyxP5wy0yqvDey2ROOx9v0+BjSTSpiq/Lg6wc29P5ApzFdg5bUL/1sExmrxZmxjV78MyKnHcxpYxUZr4b4r5uQEf1M/0XZ5hRXpUs5H+6sVDcGUyPixJ7wCTYmLmvy0Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786636460; c=relaxed/simple;
	bh=qQ+Lzzvypeie6MvnjgBfWBJB/J2cnfjOj6FHp9dNM1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKVFzStTlksnGIwmeuHeKBVbFZHDc+tPQztrQNcq0Z/2MdhvRAxZCzQev3SVn8glaLOhl6SwnW3B7wi//Wsu1rRE+EY9bRlhkGJyRLuMSBD5h6Xsal8uXiBpwCeL4HSu4LZySqDaalLFkAsNnkkhHGxcq9DodrhtXQMBAs2ujAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sFlUt0RF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sFlUt0RF"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67DFWhp01629158;
	Thu, 13 Aug 2026 15:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=0NTPPY0wr8DKmFGZP
	tE2gr5czPYEKr19Mul3nIjD4Iw=; b=sFlUt0RFjtj0gPT3QPLO1J05UPSy5ceaj
	UIosSRkLs7pN1VAzWmkY8Sfzjins4UnkoqEWXJmyZygbRNxQzr2nerFWZ40nVX1E
	gorq5dKGAxKlMLk/08Bkcj2jPCnXoToRWVp9fFVTsd4G4tJCiIyi2V7c9b9sbfZ0
	23ZqpLJyBwxDELKhcHeYHoV2Si1c+gbxodZUDc4yoFijBpqfPpeI3PdhGG7Lowkk
	28uz8Vyz7BN2LuLUgJiZgTK9mQxyXePuHcLCq/7YCcGJKlRmQ0JiogqetevCox3y
	l2eQWXO1tqqaBmDWUjblImi1mRQbeuWrl+j0gAI7WcBUuEmDAGdnw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fyb2411hf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 15:54:11 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67DFrcoU001215;
	Thu, 13 Aug 2026 15:54:11 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxh0gkfm5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Aug 2026 15:54:10 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67DFs7Fx29164024
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Aug 2026 15:54:07 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 53B6520043;
	Thu, 13 Aug 2026 15:54:07 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EB3D2004D;
	Thu, 13 Aug 2026 15:54:07 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.193.32])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Aug 2026 15:54:07 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 2/3] s390/crypto: Fix missing scrub of temp buffers with AES ctr and gcm algorithm
Date: Thu, 13 Aug 2026 17:54:05 +0200
Message-ID: <20260813155406.50051-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813155406.50051-1-freude@linux.ibm.com>
References: <20260813155406.50051-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XqfK/1F9 c=1 sm=1 tr=0 ts=6a7de8a3 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=GcIFfetOeEmlFWxA1S4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEzMDExMSBTYWx0ZWRfX5sqVBsfdOiJ2
 xqLxwmfNvORK5DYcSPaZ4pP/8GRP/BhI+F9YVIpHDBn2smtMD2tnL5MHJDO8jtAaAxDpt7OnyFS
 KJvdHZNkErGBUdl6L0UkGdO0UKDlhUyShDV1balpFref43AMbqLl1jkTPPKpRmpqdPrXXRwGT/C
 qJzlvAOg2ccKJurdj8EXUv9j5FlDsoffnuDLDR/txo2D0VeIw9AJajPX7EZBpckzEUFah78JpHd
 EDgF8cQmyHTANOcdrRDgKvZDMfJppSeAUkFDPDZro3liR1WJcUrUYrqJ1aNQfht17Vtv83Rlsbh
 DkT5IYbaynBU60oenWHd3rXaKEQM9LmaLEFgifwqXTSmluc2dXu4FLuWaqxtkugRtDtnHVedMOr
 tKGGVMwlif+eg+uptWXEibVvwilFQ9ZEXT9WPzvYWzi565JwrSD8u++Kaec9tjY9pUZqdbMSNjF
 oa4aNqr9pxc1tUdXJKA==
X-Proofpoint-ORIG-GUID: SklabRvAejoZ4-pxsf11xdIWwpXFUG4B
X-Proofpoint-GUID: SklabRvAejoZ4-pxsf11xdIWwpXFUG4B
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEzMDExMSBTYWx0ZWRfX2wvPCrm5nRo2
 907WdJHnwoLhsLlnDx3iZP6TRVelHU0rC3EM22IMBifHgixhyMZ30OdUzrEjMZzN1IfSBQmFb25
 mTU4OoBOvzV8WFnYxyxOX8kUhf+H37Q=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-13_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608130111

In function ctr_aes_crypt() there is a buffer used to process
remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
thus could lead to expose of unwanted data. When the buffer is used
explicitly scrub it at the end of the code block to avoid exposure of
maybe sensitive data.

In a similar way the function gcm_aes_crypt() hat an error path where
the CPACF param block was not scrubbed. Instead of return early now
these error paths go to end of function where explicit scrubbing is
done. Similar with the buffers which are part of the gcm_sg_walk
structs from the variables gw_in and gw_out.

Fixes: d07f951903fa ("crypto: s390/aes - Fix buffer overread in CTR mode")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.8+
---
 arch/s390/crypto/aes_s390.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 366ce22d3623..10561aa687c7 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -604,6 +604,7 @@ static int ctr_aes_crypt(struct skcipher_request *req)
 		memcpy(walk.dst.virt.addr, buf, nbytes);
 		crypto_inc(walk.iv, AES_BLOCK_SIZE);
 		ret = skcipher_walk_done(&walk, 0);
+		memzero_explicit(buf, sizeof(buf));
 	}
 
 	return ret;
@@ -895,10 +896,14 @@ static int gcm_aes_crypt(struct aead_request *req, unsigned int flags)
 			  gw_in.ptr, aad_bytes);
 
 		n = aad_bytes + pc_bytes;
-		if (gcm_in_walk_done(&gw_in, n) != n)
-			return -ENOMEM;
-		if (gcm_out_walk_done(&gw_out, n) != n)
-			return -ENOMEM;
+		if (gcm_in_walk_done(&gw_in, n) != n) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		if (gcm_out_walk_done(&gw_out, n) != n) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		aadlen -= aad_bytes;
 		pclen -= pc_bytes;
 	} while (aadlen + pclen > 0);
@@ -910,7 +915,10 @@ static int gcm_aes_crypt(struct aead_request *req, unsigned int flags)
 	} else
 		scatterwalk_map_and_copy(param.t, req->dst, len, taglen, 1);
 
+out:
 	memzero_explicit(&param, sizeof(param));
+	memzero_explicit(gw_in.buf, sizeof(gw_in.buf));
+	memzero_explicit(gw_out.buf, sizeof(gw_out.buf));
 	return ret;
 }
 
-- 
2.43.0

