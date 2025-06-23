Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841C9253953;
	Mon, 23 Jun 2025 13:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684732; cv=none; b=nqHZOkgXudpKXyKhUmTDj71d8UT1LEQURvkCjQRo/Plr1wa2dX/1tyifD2QiUSlLaZQF6VUr7hm/N0QSqbLJMIbRPRMVr+Y7Kq1QyUnAX73C+1l+dmkSYDjsaxG+LmWiDyHB0Z3vnd73/px6d6Y39+umXFSmnzje2g+1fYlY9Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684732; c=relaxed/simple;
	bh=xPgijZ2vIvFu3DtcUE9qnOx/hBOQ95kK1ZVkjD36OdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tX9S8h49QEI3KVsG7T1KLaUCpGf89Oi4ujEKIsLCHeXh1sEWzZIxir08HBSIZzfxOlD9L/H5CJWkgfHkppfEGCiwKzzSuZ8Zwv5EYEghs6GbG6ZHwownu8gUSjmyp3BttqOGgsy8snPlntLqJrF9XkymCCTxAYyHix768mPFwJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=F8czoG+i; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="F8czoG+i"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55NAJPqP020202;
	Mon, 23 Jun 2025 13:18:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=LO1BiEiorGlsdWrYz
	6N+WDgNttGozRQgvWENg3NtHC0=; b=F8czoG+iWnybFrjMS26FTKGiLe4vtIYWP
	R4Yf8xJeFsmXEwPpuTmAPRUJoqyUOwzoRTpVlaPVt7GyfVio/n2UYjBg4iEnd3Fh
	NX3datd0h0B0ddqVHH9lqfX/3Ol1Ngs6xx7zUqi259yVGece6VCLjcIRSYz0+AEJ
	wY4yfa+Z4oW2CLzZRdW9Ila/n83EVkQeuob4Trky6D6dUlj+rNoJ+HNylfUTFiOF
	lt5bjunpYBM0IRk677DXem2mdlwx2YUk41SiVLOFVKOHoDdBsAtUIUGzLJ+AVSza
	57zffJ9zXUfmai7uM3mQjKQ6HkUnYlLp17gdnh04p/SdsioOSx1vw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47dk63j3tm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Jun 2025 13:18:44 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55NBkZjd006397;
	Mon, 23 Jun 2025 13:18:43 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 47e82nxtjs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Jun 2025 13:18:43 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55NDIhND25166476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Jun 2025 13:18:43 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EAC4A5805F;
	Mon, 23 Jun 2025 13:18:42 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 779EC58059;
	Mon, 23 Jun 2025 13:18:42 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 23 Jun 2025 13:18:42 +0000 (GMT)
From: Stefan Berger <stefanb@linux.ibm.com>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
        dhowells@redhat.com, simo@redhat.com,
        Stefan Berger <stefanb@linux.ibm.com>
Subject: [RFC PATCH 4/4] crypto: Extend testmgr with tests for shake128/256 XOFs
Date: Mon, 23 Jun 2025 09:18:30 -0400
Message-ID: <20250623131830.2194643-5-stefanb@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623131830.2194643-1-stefanb@linux.ibm.com>
References: <20250623131830.2194643-1-stefanb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIzMDA4MCBTYWx0ZWRfX2VaQYqudlpPt JyY1CSenXreER1kaYg5Yi/RdosS6L312gQFhlNXns6vlR5LqBo+jjZAogibgtVZ4paikxIKBiyS 3iVfUxn27N1xt+/TTGdWY/T96HJW14snnqF+pTpMHxYVPJ7wJ42Ike9X+4HxztHzvmcCQ92FRL4
 lU1fHrisYZjneEkNvcgvE83KgTIQkT7qYkqBPKI8QbEM/5ieg7fJvSTiNrmV4raYGAZW8S5cIQ7 JgalPulYafxVKUdPZNoI/f45AP0SepjonNK4LDn7Pe1ChKBPtY9QMiPnPduI13vbfItq65CMof3 jRfBxRwPf8lUOOvO7vXz+5B9TwUn39v3abBdrpUZ9cD5W3Rp1QIXRJtQJauG1flf8yP1PG3PbH1
 Ri528lhEJHWztzxRXRYz0Iw8wsLxpPqAfax82P1+BCYIOWaRlLXmujLhWIa8Iiq/dq4Nv3Sd
X-Proofpoint-ORIG-GUID: avB1Pc-N2yZ73VLVla7JU-pPVmnZ5MQD
X-Proofpoint-GUID: avB1Pc-N2yZ73VLVla7JU-pPVmnZ5MQD
X-Authority-Analysis: v=2.4 cv=BfvY0qt2 c=1 sm=1 tr=0 ts=68595434 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=RaegE9gVr3S12DfPD4oA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-23_03,2025-06-23_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0
 impostorscore=0 mlxlogscore=547 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506230080

Extend the testmgr to run tests for XOFs where it squeezes a certain number
of bytes in a first step and then a different number in subsequent steps to
test for issues related to alignments and proper copying of bytes and
blocks.

Add test case data for shake128 and shake256 XOFs.

Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
---
 crypto/testmgr.c |  58 +++++++++++++
 crypto/testmgr.h | 212 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 270 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2e4740448e3a..267307bd609d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1647,6 +1647,59 @@ static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 				 driver, cfg);
 }
 
+static int test_shash_xof(const struct hash_testvec *vec,
+			  struct shash_desc *desc)
+{
+	struct shash_alg *alg = crypto_shash_alg(desc->tfm);
+	struct steps {
+		unsigned int first;
+		unsigned int other;
+	} steps[] = {
+		{ .first = 0, .other = alg->base.cra_blocksize, },
+		{ .first = 0, .other = alg->base.cra_blocksize + 1, },
+		{ .first = 1, .other = alg->base.cra_blocksize, },
+		{ .first = 1, .other = 1, },
+		{ .first = 1, .other = 33, },
+	};
+	unsigned char *output = NULL, *tmp;
+	unsigned int off, req;
+	int ret = 0;
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(steps); i++) {
+		if (!vec->xof)
+			continue;
+
+		tmp = krealloc(output, vec->xof_size, GFP_KERNEL);
+		if (IS_ERR(output))
+			return PTR_ERR(output);
+		output = tmp;
+
+		crypto_shash_init(desc);
+		crypto_shash_update(desc, vec->plaintext, vec->psize);
+		crypto_shash_squeeze(desc, output, steps[i].first, false);
+		off = steps[i].first;
+
+		while (off < vec->xof_size) {
+			req = steps[i].other;
+			if (off + req > vec->xof_size)
+				req = vec->xof_size - off;
+			crypto_shash_squeeze(desc, &output[off], req, false);
+			off += req;
+		}
+
+		if (memcmp(output, vec->xof, vec->xof_size) != 0) {
+			pr_err("XOF output of %s is wrong! (steps: %d, %d)\n",
+			       alg->base.cra_name, steps[i].first,
+			       steps[i].other);
+			ret = -EINVAL;
+		}
+	}
+	kfree(output);
+
+	return ret;
+}
+
 static int test_hash_vec_cfg(const struct hash_testvec *vec,
 			     const char *vec_name,
 			     const struct testvec_config *cfg,
@@ -1998,6 +2051,11 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 		err = test_hash_vec(&vecs[i], i, req, desc, tsgl, hashstate);
 		if (err)
 			goto out;
+		if (desc && crypto_shash_alg(desc->tfm)->squeeze) {
+			err = test_shash_xof(&vecs[i], desc);
+			if (err)
+				return err;
+		}
 		cond_resched();
 	}
 	err = test_hash_vs_generic_impl(generic_driver, maxkeysize, req,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index c99dc61353b1..5160e5bb0489 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -30,8 +30,10 @@
  * @key:	Pointer to key (NULL if none)
  * @plaintext:	Pointer to source data
  * @digest:	Pointer to expected digest
+ * @xof:        Pointer to extended output
  * @psize:	Length of source data in bytes
  * @ksize:	Length of @key in bytes (0 if no key)
+ * @xof_size:   Length of extended output
  * @setkey_error: Expected error from setkey()
  * @digest_error: Expected error from digest()
  * @fips_skip:	Skip the test vector in FIPS mode
@@ -40,8 +42,10 @@ struct hash_testvec {
 	const char *key;
 	const char *plaintext;
 	const char *digest;
+	const char *xof;
 	unsigned int psize;
 	unsigned short ksize;
+	unsigned short xof_size;
 	int setkey_error;
 	int digest_error;
 	bool fips_skip;
@@ -5919,17 +5923,95 @@ static const struct hash_testvec shake128_tv_template[] = {
 		.plaintext = "",
 		.digest	= "\x7f\x9c\x2b\xa4\xe8\x8f\x82\x7d"
 				"\x61\x60\x45\x50\x76\x05\x85\x3e",
+		.xof =  "\x7f\x9c\x2b\xa4\xe8\x8f\x82\x7d"
+			"\x61\x60\x45\x50\x76\x05\x85\x3e"
+			"\xd7\x3b\x80\x93\xf6\xef\xbc\x88"
+			"\xeb\x1a\x6e\xac\xfa\x66\xef\x26"
+			"\x3c\xb1\xee\xa9\x88\x00\x4b\x93"
+			"\x10\x3c\xfb\x0a\xee\xfd\x2a\x68"
+			"\x6e\x01\xfa\x4a\x58\xe8\xa3\x63"
+			"\x9c\xa8\xa1\xe3\xf9\xae\x57\xe2"
+			"\x35\xb8\xcc\x87\x3c\x23\xdc\x62"
+			"\xb8\xd2\x60\x16\x9a\xfa\x2f\x75"
+			"\xab\x91\x6a\x58\xd9\x74\x91\x88"
+			"\x35\xd2\x5e\x6a\x43\x50\x85\xb2"
+			"\xba\xdf\xd6\xdf\xaa\xc3\x59\xa5"
+			"\xef\xbb\x7b\xcc\x4b\x59\xd5\x38"
+			"\xdf\x9a\x04\x30\x2e\x10\xc8\xbc"
+			"\x1c\xbf\x1a\x0b\x3a\x51\x20\xea"
+			"\x17\xcd\xa7\xcf\xad\x76\x5f\x56"
+			"\x23\x47\x4d\x36\x8c\xcc\xa8\xaf"
+			"\x00\x07\xcd\x9f\x5e\x4c\x84\x9f"
+			"\x16\x7a\x58\x0b\x14\xaa\xbd\xef"
+			"\xae\xe7\xee\xf4\x7c\xb0\xfc\xa9"
+			"\x76\x7b\xe1\xfd\xa6\x94\x19\xdf"
+			"\xb9\x27\xe9\xdf\x07\x34\x8b\x19"
+			"\x66\x91\xab\xae\xb5\x80\xb3\x2d"
+			"\xef\x58\x53\x8b\x8d\x23\xf8\x77",
+		.xof_size = 200,
 	}, {
 		.plaintext = "a",
 		.psize	= 1,
 		.digest	= "\x85\xc8\xde\x88\xd2\x88\x66\xbf"
 				"\x08\x68\x09\x0b\x39\x61\x16\x2b",
+		.xof =  "\x85\xc8\xde\x88\xd2\x88\x66\xbf"
+			"\x08\x68\x09\x0b\x39\x61\x16\x2b"
+			"\xf8\x23\x92\xf6\x90\xd9\xe4\x73"
+			"\x09\x10\xf4\xaf\x7c\x6a\xb3\xee"
+			"\x43\x54\xb4\x9c\xa7\x29\xeb\x35"
+			"\x6e\xe3\xf5\xb0\xfb\xd2\x9b\x66"
+			"\x76\x93\x83\xe5\xe4\x01\xb1\xf8"
+			"\x5e\x04\x4c\x92\xbb\x52\x31\xaa"
+			"\x4d\xee\x17\x99\xaf\x7a\x7c\xee"
+			"\x21\x3a\x23\xad\xcd\x03\xc4\x80"
+			"\x6c\x9a\x8b\x0d\x8a\x2e\xea\xd8"
+			"\xea\x7a\x61\x34\xc1\x3e\x52\x3c"
+			"\xcf\x93\xad\x39\xd2\x27\xd3\xe7"
+			"\xd0\x22\xd9\x65\x4f\x3b\x49\x41"
+			"\x37\x88\x75\x8a\x64\x17\xe4\x2d"
+			"\x41\x95\x7c\xb3\x0c\xf0\x4d\xa3"
+			"\x7f\x26\x89\x7c\x2c\xf2\xf8\x00"
+			"\x55\x84\x62\x93\xfd\xe0\x23\x31"
+			"\xcf\x4a\x26\x9a\xaf\x2d\x47\xeb"
+			"\x27\xab\xa0\xfa\xba\x4a\x67\x8e"
+			"\xc0\x02\xbc\x0d\x30\x64\xea\xd0"
+			"\xa3\xf2\xe0\xd8\xa7\xfa\x40\x4a"
+			"\xf5\x4e\xbf\x4f\x5b\x18\x35\x62"
+			"\xa8\xda\xd7\x3b\x9a\x55\xbf\x1c"
+			"\x06\x6e\x00\x07\xe7\xab\x8a\x89",
+		.xof_size = 200,
 	}, {
 		.plaintext = "abcdbcdecdefdefgefghfghighijhijkijkl"
 			     "jklmklmnlmnomnopnopq",
 		.psize	= 56,
 		.digest = "\x1a\x96\x18\x2b\x50\xfb\x8c\x7e"
 				"\x74\xe0\xa7\x07\x78\x8f\x55\xe9",
+		.xof =  "\x1a\x96\x18\x2b\x50\xfb\x8c\x7e"
+			"\x74\xe0\xa7\x07\x78\x8f\x55\xe9"
+			"\x82\x09\xb8\xd9\x1f\xad\xe8\xf3"
+			"\x2f\x8d\xd5\xcf\xf7\xbf\x21\xf5"
+			"\x4e\xe5\xf1\x95\x50\x82\x5a\x6e"
+			"\x07\x00\x30\x51\x9e\x94\x42\x63"
+			"\xac\x1c\x67\x65\x28\x70\x65\x62"
+			"\x1f\x9f\xcb\x32\x01\x72\x3e\x32"
+			"\x23\xb6\x3a\x46\xc2\x93\x8a\xa9"
+			"\x53\xba\x84\x01\xd0\xea\x77\xb8"
+			"\xd2\x64\x90\x77\x55\x66\x40\x7b"
+			"\x95\x67\x3c\x0f\x4c\xc1\xce\x9f"
+			"\xd9\x66\x14\x8d\x7e\xfd\xff\x26"
+			"\xbb\xf9\xf4\x8a\x21\xc6\xda\x35"
+			"\xbf\xaa\x54\x56\x54\xf7\x0a\xe5"
+			"\x86\xff\x10\x13\x14\x20\x77\x14"
+			"\x83\xec\x92\xed\xab\x40\x8c\x76"
+			"\x7b\xf4\xc5\xb4\xff\xfa\xa8\x0c"
+			"\x8c\xa2\x14\xd8\x4c\x4d\xc7\x00"
+			"\xd0\xc5\x06\x30\xb2\xff\xc3\x79"
+			"\x3e\xa4\xd8\x72\x58\xb4\xc9\x54"
+			"\x8c\x54\x85\xa5\xca\x66\x6e\xf7"
+			"\x3f\xbd\x81\x6d\x41\x8a\xea\x63"
+			"\x95\xb5\x03\xad\xdd\x9b\x15\x0f"
+			"\x9e\x06\x63\x32\x5f\x01\xe5\x51",
+		.xof_size = 200,
 	}, {
 		.plaintext = "\x08\x9f\x13\xaa\x41\xd8\x4c\xe3"
 			     "\x7a\x11\x85\x1c\xb3\x27\xbe\x55"
@@ -6062,6 +6144,32 @@ static const struct hash_testvec shake128_tv_template[] = {
 		.psize     = 1023,
 		.digest    = "\x13\x0a\x5b\xcb\x83\x9f\x10\x89"
 			     "\xbb\x62\xda\xe4\xf4\xd3\x21\xf8",
+		.xof =	"\x13\x0a\x5b\xcb\x83\x9f\x10\x89"
+			"\xbb\x62\xda\xe4\xf4\xd3\x21\xf8"
+			"\xd1\xa1\x20\xeb\x55\x0a\x93\x04"
+			"\x9b\xe3\x14\x3c\x18\xd1\x7c\xa7"
+			"\xcd\xf3\x11\xe7\xe1\xcf\xaf\xbf"
+			"\x2e\x99\x8b\x4f\x5e\x0a\x13\x81"
+			"\x6e\x12\x36\x9e\x8e\x3a\xf6\x42"
+			"\xa1\x85\x4b\xda\xcf\x5a\x36\x65"
+			"\xe4\xea\x18\x3b\x19\x86\xf0\xd4"
+			"\xeb\x0f\x33\x98\xb5\x2b\xa7\x9b"
+			"\xba\x17\xd1\xd4\xc5\x5f\x0d\x8e"
+			"\x6c\xb0\xba\x4f\x94\x25\x29\x54"
+			"\xf8\x1d\x03\x14\xb7\xe5\x1e\xb2"
+			"\xf0\xe7\x0f\x32\x86\xfa\x13\x9f"
+			"\x60\x8d\x15\x03\x2d\x96\x2a\xa4"
+			"\x76\xf6\x49\x6c\x8a\x75\x7d\x79"
+			"\xa4\xcc\xcb\xe0\xf9\xbb\x7a\x80"
+			"\xc1\x20\x79\x32\x42\xe8\x0e\xd9"
+			"\x0f\x93\x0b\xaf\x56\x6e\x71\xc8"
+			"\x3f\xc3\x52\xe0\x4b\x4b\xbc\xf5"
+			"\x1f\xdf\xed\x88\xb8\x9d\x5a\x75"
+			"\x77\xa1\x59\x9b\x6a\x7c\x43\xe4"
+			"\x5b\x58\xaa\x84\x0a\x18\xb5\x37"
+			"\x3b\xda\xa8\xc9\x35\x76\x1b\x62"
+			"\x4f\x52\xc7\x42\x4e\x00\xb1\x46",
+		.xof_size = 200,
 	},
 };
 
@@ -6072,6 +6180,32 @@ static const struct hash_testvec shake256_tv_template[] = {
 				"\x23\x3b\x3f\xeb\x74\x3e\xeb\x24"
 				"\x3f\xcd\x52\xea\x62\xb8\x1b\x82"
 				"\xb5\x0c\x27\x64\x6e\xd5\x76\x2f",
+		.xof =  "\x46\xb9\xdd\x2b\x0b\xa8\x8d\x13"
+			"\x23\x3b\x3f\xeb\x74\x3e\xeb\x24"
+			"\x3f\xcd\x52\xea\x62\xb8\x1b\x82"
+			"\xb5\x0c\x27\x64\x6e\xd5\x76\x2f"
+			"\xd7\x5d\xc4\xdd\xd8\xc0\xf2\x00"
+			"\xcb\x05\x01\x9d\x67\xb5\x92\xf6"
+			"\xfc\x82\x1c\x49\x47\x9a\xb4\x86"
+			"\x40\x29\x2e\xac\xb3\xb7\xc4\xbe"
+			"\x14\x1e\x96\x61\x6f\xb1\x39\x57"
+			"\x69\x2c\xc7\xed\xd0\xb4\x5a\xe3"
+			"\xdc\x07\x22\x3c\x8e\x92\x93\x7b"
+			"\xef\x84\xbc\x0e\xab\x86\x28\x53"
+			"\x34\x9e\xc7\x55\x46\xf5\x8f\xb7"
+			"\xc2\x77\x5c\x38\x46\x2c\x50\x10"
+			"\xd8\x46\xc1\x85\xc1\x51\x11\xe5"
+			"\x95\x52\x2a\x6b\xcd\x16\xcf\x86"
+			"\xf3\xd1\x22\x10\x9e\x3b\x1f\xdd"
+			"\x94\x3b\x6a\xec\x46\x8a\x2d\x62"
+			"\x1a\x7c\x06\xc6\xa9\x57\xc6\x2b"
+			"\x54\xda\xfc\x3b\xe8\x75\x67\xd6"
+			"\x77\x23\x13\x95\xf6\x14\x72\x93"
+			"\xb6\x8c\xea\xb7\xa9\xe0\xc5\x8d"
+			"\x86\x4e\x8e\xfd\xe4\xe1\xb9\xa4"
+			"\x6c\xbe\x85\x47\x13\x67\x2f\x5c"
+			"\xaa\xae\x31\x4e\xd9\x08\x3d\xab",
+		.xof_size = 200,
 	}, {
 		.plaintext = "a",
 		.psize	= 1,
@@ -6079,6 +6213,32 @@ static const struct hash_testvec shake256_tv_template[] = {
 				"\xbd\x59\x25\x01\xa5\xe8\xfe\x9c"
 				"\xea\xaf\xca\x50\x25\x56\x26\xca"
 				"\x73\x6c\x13\x80\x42\x53\x0b\xa4",
+		.xof =  "\x86\x7e\x2c\xb0\x4f\x5a\x04\xdc"
+			"\xbd\x59\x25\x01\xa5\xe8\xfe\x9c"
+			"\xea\xaf\xca\x50\x25\x56\x26\xca"
+			"\x73\x6c\x13\x80\x42\x53\x0b\xa4"
+			"\x36\xb7\xb1\xec\x0e\x06\xa2\x79"
+			"\xbc\x79\x07\x33\xbb\x0a\xee\x6f"
+			"\xa8\x02\x68\x3c\x7b\x35\x50\x63"
+			"\xc4\x34\xe9\x11\x89\xb0\xc6\x51"
+			"\xd0\x92\xb0\x1e\x55\xce\x4d\x61"
+			"\x0b\x54\xa5\x46\x6d\x02\xf8\x8f"
+			"\xc3\x78\x09\x6f\xb0\xda\xd0\x25"
+			"\x48\x57\xfe\x1e\x63\x81\xab\xc0"
+			"\x4e\x07\xe3\x3d\x91\x69\x35\x93"
+			"\x56\x36\x00\x48\x96\xc5\xb1\x25"
+			"\x34\x64\xf1\xcb\x5e\xa7\x3b\x00"
+			"\x7b\xc5\x02\x8b\xbb\xea\x13\xeb"
+			"\xc2\x86\x68\xdb\xfc\x26\xb1\x24"
+			"\x0c\xe4\x23\x9f\x8d\x50\x62\x7d"
+			"\xda\xa0\x16\x41\xdf\xea\xa9\xd2"
+			"\xfe\xf0\x3d\xd0\x25\xe0\xb8\x2c"
+			"\xf0\x71\xfb\x9c\xa3\x23\x2c\x74"
+			"\x2d\x83\x6b\x3c\xbc\xc8\xc3\xcb"
+			"\xa5\xb0\x58\xb7\x67\x95\xc1\x77"
+			"\x01\x23\x14\x19\x6d\xc8\x22\x76"
+			"\x89\x91\xc0\xf1\x6f\x8a\x65\x5a",
+		.xof_size = 200,
 	}, {
 		.plaintext = "abcdbcdecdefdefgefghfghighijhijkijkl"
 			     "jklmklmnlmnomnopnopq",
@@ -6087,6 +6247,32 @@ static const struct hash_testvec shake256_tv_template[] = {
 				"\xee\xfb\xb8\xc3\x6f\x6f\x87\x13"
 				"\x3a\x79\x11\xe1\x8d\x97\x9e\xe1"
 				"\xae\x6b\xe5\xd4\xfd\x2e\x33\x29",
+		.xof =  "\x4d\x8c\x2d\xd2\x43\x5a\x01\x28"
+			"\xee\xfb\xb8\xc3\x6f\x6f\x87\x13"
+			"\x3a\x79\x11\xe1\x8d\x97\x9e\xe1"
+			"\xae\x6b\xe5\xd4\xfd\x2e\x33\x29"
+			"\x40\xd8\x68\x8a\x4e\x6a\x59\xaa"
+			"\x80\x60\xf1\xf9\xbc\x99\x6c\x05"
+			"\xac\xa3\xc6\x96\xa8\xb6\x62\x79"
+			"\xdc\x67\x2c\x74\x0b\xb2\x24\xec"
+			"\x37\xa9\x2b\x65\xdb\x05\x39\xc0"
+			"\x20\x34\x55\xf5\x1d\x97\xcc\xe4"
+			"\xcf\xc4\x91\x27\xd7\x26\x0a\xfc"
+			"\x67\x3a\xf2\x08\xba\xf1\x9b\xe2"
+			"\x12\x33\xf3\xde\xbe\x78\xd0\x67"
+			"\x60\xcf\xa5\x51\xee\x1e\x07\x91"
+			"\x41\xd4\x9d\xd3\xef\x7e\x18\x2b"
+			"\x15\x24\xdf\x82\xea\x1c\xef\xe1"
+			"\xc6\xc3\x96\x61\x75\xf0\x22\x8d"
+			"\x35\x88\x7c\xd9\xf0\x9b\x05\x45"
+			"\x7f\x6d\x95\x2f\x9b\x3b\x32\x46"
+			"\x4e\x0b\x3c\x54\xdc\xc1\x3e\xfd"
+			"\xb4\xc5\x4e\x29\xcd\xb4\x08\x8f"
+			"\xaf\x48\x2c\xdd\xd0\xa5\xe6\xb8"
+			"\x22\xf5\xa8\x0d\x0c\xc7\x8d\x4c"
+			"\xc9\x01\x31\x90\x6f\xd5\x15\x9e"
+			"\xb5\x14\x2e\x15\x50\x24\xb6\x24",
+		.xof_size = 200,
 	}, {
 		.plaintext = "\x08\x9f\x13\xaa\x41\xd8\x4c\xe3"
 			     "\x7a\x11\x85\x1c\xb3\x27\xbe\x55"
@@ -6221,6 +6407,32 @@ static const struct hash_testvec shake256_tv_template[] = {
 			     "\xce\xdc\xc1\x02\x31\x6c\x0f\x19"
 			     "\x0a\xb2\x77\x24\xe7\x68\x71\x3b"
 			     "\x9b\x6d\x5f\xbc\xcf\x60\x28\x4c",
+		.xof =  "\x24\xab\xec\xa1\x22\x05\x1c\xf3"
+			"\xce\xdc\xc1\x02\x31\x6c\x0f\x19"
+			"\x0a\xb2\x77\x24\xe7\x68\x71\x3b"
+			"\x9b\x6d\x5f\xbc\xcf\x60\x28\x4c"
+			"\x97\x76\xdc\x50\xda\xa5\x14\x5e"
+			"\xe6\xb9\x1e\xbc\x42\x1e\x8d\xd5"
+			"\xb5\xae\xe2\x77\x48\xde\x80\x1f"
+			"\x7a\x74\x30\x79\x86\xc8\x6f\x2e"
+			"\x90\x76\x07\xb3\xed\x74\xdf\x44"
+			"\xcc\x3b\x00\x64\xb4\xb1\xdc\x11"
+			"\xa8\xcf\xbf\x01\xfc\x21\x00\xac"
+			"\x2c\xa1\xea\xbd\x84\x1c\x84\xa2"
+			"\x6b\x02\x7a\x19\xb9\xbf\xbb\xc0"
+			"\x21\x71\x4b\xb2\xc0\x50\xa4\xe9"
+			"\xe1\x48\xd2\xca\x14\xcc\x3f\x65"
+			"\x87\x38\xc5\xfb\xc0\x03\x23\x64"
+			"\x65\x5d\xb8\xd1\x9d\xd6\xd4\x3a"
+			"\xeb\x57\xe7\x3c\x22\x17\xb6\x5a"
+			"\x8e\x4b\x73\xf4\x36\x4a\x36\x17"
+			"\x8c\xbe\x7d\x2b\x37\xaf\xde\xbc"
+			"\xc7\xe8\x52\x00\x90\x90\x0e\x3b"
+			"\x22\x6f\xa7\xec\x2f\x99\x6d\x32"
+			"\x36\x20\x12\x4d\x14\xa8\x7f\xc4"
+			"\x9e\xb5\x7f\x6b\xc6\xe9\xe2\x8e"
+			"\xd5\xc8\x25\xe6\xf1\x97\xbf\x76",
+		.xof_size = 200,
 	},
 };
 
-- 
2.49.0

