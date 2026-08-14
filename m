Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7742646D0AB;
	Fri, 14 Aug 2026 12:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786711050; cv=none; b=QfqVi/72yK8SFkRJc3qPm8Kub1geV8RkN3QXpCLWq1yLQcxIhybCtlHHdmy+U+7/TvRRbQCc7TAq/P6L/jAJlC12xAj4fNhQbM9T3efz0H/yZgp+N2WAP17JxEvdPuARtm/7CG3m1T8+vRZijQsTmOtWhZqcD4vW8kUw65Ilmtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786711050; c=relaxed/simple;
	bh=qQ+Lzzvypeie6MvnjgBfWBJB/J2cnfjOj6FHp9dNM1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bybIrb/JlZ+5SJOi0l7ewEv1Cfge9qXGE7BujBkIO2NAcAEeWzOrChOKwSpBrd8yonC8tM1Qb5pYesyiOIrBPXFJYYuTlaeOn4YW+KMDdaeN01iD+qILQlrD2AlZnGx+4/7I/o+nZPpryivwgEc4+BbzCLc76s+uAXzm6OWbZwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IYzcOfkZ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IYzcOfkZ"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EB1d7Z903600;
	Fri, 14 Aug 2026 12:37:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=0NTPPY0wr8DKmFGZP
	tE2gr5czPYEKr19Mul3nIjD4Iw=; b=IYzcOfkZ9oKPKRkC4CXmkO9m2HvAfcLd9
	tdbCvxykctN2hEgWzeS1KrEQB0t9ijYrL8N+QzURO4j4b1qtpc14Bf9ugEPWEgGH
	ry/aNO6yPc+1KwMWed5RAZAQF16cDiBf0DxVw6gQ6OdQTjg0CLNQMlwuvNDJYFzu
	2p/Gz4rTpz4KvprZYnn2+0SB7OemuozAMo+OUmVxkXGKXy5Gz6l8M5vYRm0Xk3yN
	7d2pgrS8pd7Qv+ZBmZi93LsLqAre6yVD6dswt2OwfaTlS1RBGPJ8lWIy/1PEJhZQ
	2y686AMkgOyPg9ObYWna5WjOo6JoigldM3pYeNi8WxxTNZpPEEIkw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvq9vqpj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 12:37:16 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67ECQOAw003705;
	Fri, 14 Aug 2026 12:37:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g1rpva0pa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 12:37:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67ECbCvR44499372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 12:37:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 53DE62004B;
	Fri, 14 Aug 2026 12:37:12 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3290C20049;
	Fri, 14 Aug 2026 12:37:12 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.129.52])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 12:37:12 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v4 2/3] s390/crypto: Fix missing scrub of temp buffers with AES ctr and gcm algorithm
Date: Fri, 14 Aug 2026 14:37:10 +0200
Message-ID: <20260814123711.61145-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814123711.61145-1-freude@linux.ibm.com>
References: <20260814123711.61145-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n7fWKcbLkUifvKrS5FPSFaDkqehKfDbr
X-Authority-Analysis: v=2.4 cv=PbDPQChd c=1 sm=1 tr=0 ts=6a7f0bfd cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=GcIFfetOeEmlFWxA1S4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDA5NSBTYWx0ZWRfX96T2HnOip40z
 Cw8iEV0VnjhCTNujR/1umwfXuj57o724KlDVEM1WPRV6QYGz6UDZlsOwX2NiP6klUTYMrsFFKRV
 QWdv3xFq8QEthr6O7Xpi/KMpwHMO9u4cG8Yp+oFhgBFHbqJK2c4nILRHwXq7U6LBvFG3pE1lt79
 W7IfT1gD1gkog21130c8BdZeKwR9ow+ShiI1qB8V9k66joYGxMoxtGKCXc77N26fNHbA2M/bKS/
 DkQp6+Dwbu0TrXOsGQwhOnpEDifVN8dmki1jAresTHyvYRUIITPboneNBjSBIz38gU/K33PuE6l
 2pGzv1TI0EH/36stLyexiiavoNIjKueQ6rJQ59S4SPr7TaNb1XRYb7k7grMxAwaEZgq8XKa/uEp
 VM/HUnsFrEn2wWXZG0M5lpFyiJOpWihQEnrJPmNd3nrt78Kx/FueE7u5MQlII4gcrATGEWv8SZu
 ikQQ9inUmbHGLKla6vw==
X-Proofpoint-ORIG-GUID: n7fWKcbLkUifvKrS5FPSFaDkqehKfDbr
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDA5NSBTYWx0ZWRfX/3zfD84jfH9o
 ShDQ33GQRY2fSYUQZKBEllckkAJcGxO6romH/0EeZ6Yy00hPcRW7nPrx5bSpr6I9KXux3qpRUFQ
 RH5ZNJWIS/SCbzC4D9zca1ylsnxFMkQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0 adultscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608140095

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

