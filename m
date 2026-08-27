Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A58486B8A
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 16:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846917; cv=none; b=A2OGQqs85kShe95FD2UxsFV5QE7oR5fLdFEvWjY3bT+zGwhZQ7kkc5sBiAC7ScGIlbtM17aQHWHIcG7E8qvYlIPeDrtirGhF3QdZrLaoVuQB3qZUZvdQ+okfgh7FUdyut7WZF+fAVBXmAyYz4bsvTorDYJgaawQfJ2w6XfDgNVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846917; c=relaxed/simple;
	bh=oSgJwGLxnmoFdZg1kjVbiBRTTxyJZh2fbQVmNPq59Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qF+My8PDlsA93ECZtwF71jMDpiwXIwU0RqITMRmtC0rsMJnT7QY/nDcxm2pDXDGilI32gfX4rYD7iMozLcbl6ktR3a1j6XZ1DfQsxWt1I15uqpa+kgnaCdiZIA5H/lk8l/y5LOxLyqjeEyuW7DhwIxiXBMZIhHCaf++nCoo455I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AK9S4frc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LTMfGyY/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AK9S4frc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LTMfGyY/"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RFcmxK359178
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 16:08:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=jGZdyNVRoPn
	uELHhGohR0kdLBQlQJfa6SSwFJk/s1LQ=; b=AK9S4frci4VDxG5fjZmeGLlcArg
	21kvuLV7nGYyMKq2nOsG1bclVR3sNLOSNIEQoH0liMGj1xNKjBIg91nFoPQqrsNH
	KSp/ldhVpnxCIZKoY+0njofJOZeeyTOqkuLa6mn28tUkr1HvzMXI23XbLYRLQfjz
	caEJ1wsxuhTTMP7Ycxf14SibStJWAa/FvFp2M2Nar4Dii40yWq5A6+3zcK6e4zC6
	AGeUEPvemGNe+EaQO5RixKWWdz9MFahfjgDnjYrkUq6YNB2wg5w35k8tGBs9X0SG
	JAFl7zAbMBRYCqncKCK1tQ6dKItBof2hAGj5wVLKfP2jnTaJq3yD6EI60Gg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ganr68r23-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 16:08:33 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39512608fb1so149627a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 09:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787846912; x=1788451712; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jGZdyNVRoPnuELHhGohR0kdLBQlQJfa6SSwFJk/s1LQ=;
        b=LTMfGyY/yicjQ79NOzaXtxqHg9qybxyxXqkFqK9c16CDguYZPzB5uun9b1b0tXTqig
         aNLH+5C1Ni9u5ZrLd5qzgfKekniyEkobYCLTIfAfX6vdeF2ON/YVtwZtlHrYBR0iT0FG
         JDO/eEy/uez2O9Pr4yQOPyrvJa8Zv+SgQPVgDMXzLy/S0iqviYkzlS8tJ9Zse2EVQGzd
         Nu74T1exIGGE2xAT6F3WgbDT0ZYcmzcfZrVRzeYe1UkpsSU5dlT0GPzhZoU11zZJl4GJ
         7TJhJJRyuSkKcUoA0Eitmt+Xxq0mpS5Ytn2lJytPqKoSstN09lAzWtOAFyr7V+6oNA1G
         2b6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787846912; x=1788451712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jGZdyNVRoPnuELHhGohR0kdLBQlQJfa6SSwFJk/s1LQ=;
        b=Mq4MXX3SiF7qyHKJedOtwPFnO88UJCx6H4RMN7bZmg9i3sPP7odJzbOaGnSJDFnWXK
         Rar9toID73wLQmIpdPa6WAVZXbDpmvccSWENLh5Wfu4m/+q7F0zcP697ss2d1mg96S1B
         /RhkyVvwTSSQmbsL467V6ZoG/QIJ9NFDF+TFtQI2aBajIKkEDZYbJ2fCYmSEkBwYcHMz
         4bhcfc52B6RtZwmUlrHR0k+DMeLR39xQM95kZlCFF50+7BKGmLM8ErmdZ9bWyh0QFgyv
         hfz0wlpynO5oT0UZqD5zzvI4EOcOD4w/VYpxZv1ZM+wKGBFScIuGnAEBSXDqqcQiQPHu
         7VWA==
X-Forwarded-Encrypted: i=1; AHgh+RpUIzyTG8gCC53gAPQtS/fkfCgMpYyJOAGUjHX351Ug9WFegrCxp0tjOgvVA7q2Ogat1WZvOOaFwt4og8Q=@vger.kernel.org
X-Gm-Message-State: AFuF++kRHvLKn/Typ0kPHSRCFuLlloKof42r234UbnnGqEP5ntgzA8eQ
	KGrmoWrU+iTbKAe4niZnzACMpUNY75x9Ae62QsV1OlSmvbUMfYU7/ZICKvqiMCe58tTXMrJ7QO2
	C2D7Lf3U6R/UHWox5srY3GJjfCGlk+AcAId6oYq6UwVHRd0a0tMOGvG2wp1lwwDlgo9I=
X-Gm-Gg: AR+sD10gE7MRwf4bNytVaBMEAINTNPpwIrA9KimzSSVXQNg+VWts1po2Fdg7dvUAkwW
	ZSYvVsCVffGqwhVet5GKvMP7nLP7PrPeScHoHnuz6OrCzN9n44JoNPmLySmDfdoE/uHfyPvvw7n
	ArOrvDJq8ufaLoStYltZrw0DYUbLvnvhZQls7hlG/MrmvoaQM3R+ZCcXACzFaE8IXexCrGgsjbF
	Y4eVVm6FJLEWpZNbpZriVB+0RIYAQOPpWRZcjHXGgbmwMF9oiqzaVsX5mx3u7Ry+Mibcj2TAb1s
	ik2DT6BBEnan5oSzbxQ+of/DHrbVtR4plVzyb9ZN88NaBtBZIyKwwS/VywasowVt7F/GZd7ndp4
	9bvWVgZ8uCtDNecHc0PryNDbNL/ASCSd/sjzpt5P8FJ4Gqn8ukcw/jFNlmXk=
X-Received: by 2002:a17:90b:264c:b0:396:61f1:da5c with SMTP id 98e67ed59e1d1-396d0e86577mr565927a91.4.1787846912404;
        Thu, 27 Aug 2026 09:08:32 -0700 (PDT)
X-Received: by 2002:a17:90b:264c:b0:396:61f1:da5c with SMTP id 98e67ed59e1d1-396d0e86577mr565806a91.4.1787846911952;
        Thu, 27 Aug 2026 09:08:31 -0700 (PDT)
Received: from u24-san1p10108.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0fd9085sm3245892a91.12.2026.08.27.09.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 09:08:31 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: ebiggers@kernel.org, axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
        stefanha@redhat.com, pbonzini@redhat.com, eperezma@redhat.com,
        xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
Subject: [PATCH v1 05/11] blk-crypto: add slot-based inline encryption path
Date: Thu, 27 Aug 2026 09:07:14 -0700
Message-ID: <20260827160806.1295313-6-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfX332dhtaQ/Cd+
 fKOloClo07hrgw0s4ppbAdH8Kr2da/HX1vMyJv/DbxsSiwpjjQQvr01uTfq68OY9OPXb5fEimko
 Hu66D8MzuqmaV/FoAQLuDIJNn9c76wNi/WPS64V1ezlqVts8HV6wePjUmQ1+7UuumDyeV981RyZ
 OtbzPtuc6wxs/cZFB3VloswjePQ3G8VZdYLUWslao9dg9SmgoK4zCYPulleQizv1QcKlbICOF5j
 /kP5QWNLMIDA7vQsI6/Y5Anvflj7UwMiP3u6ScHcdJSAtN3Nm05v2jk1QwIvwRBB9y7ft6HQzX3
 72xIpjnVm81d3pRM1AWsYFg7kuIOcG84UZm8OtrVbe2Da7aNkMk4Rfckb2im6i0AhIUz/RFKfiI
 JOm4cXdPSuC9pEj1frYgZQFE20j3w/MdIkYKP7TxAwsbjj7F6+nvYdyUWjeRRuN4g1f8GWKqmU6
 6zfdT+4/QCKd2dYEA+w==
X-Authority-Analysis: v=2.4 cv=d5DFDxjE c=1 sm=1 tr=0 ts=6a906101 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=0coNgh9vqHAzk87cOx8A:9 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: aFSW5Dps4S2zrBPO3798N_mTaI0X80tJ
X-Proofpoint-ORIG-GUID: aFSW5Dps4S2zrBPO3798N_mTaI0X80tJ
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfX1VD/OkkujaJZ
 5KDQQla+z+fZpvFGjd8KnyzfVBtDD3YOd/HIDwhy8U6gR7X9nxdBPMj5Vgj+B5P1rYEtsNBZXJG
 emgJgZ3bNWxGQrsn2GJJvcNTFwa7lTk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_07,2026-08-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 adultscore=0 suspectscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270136

From: linlzhan <linlin.zhang@oss.qualcomm.com>

For the virtio-blk inline encryption use case, the guest kernel goes
through the normal blk_crypto_key programming flow via SMC call in a
virtual slot format before I/O starts.  It then requests the host to
handle that I/O with the key programmed into the corresponding physical
keyslot.

Introduce a "slot path" that lets a bio carry a pre-programmed physical
ICE keyslot index rather than a blk_crypto_key pointer.  Add struct
blk_crypto_slot, containing the physical slot index (phy_slot) and
data_unit_size_bits, and embed it in struct bio_crypt_ctx alongside the
existing bc_key pointer.  A NULL bc_key indicates the slot path.

Provide bio_crypt_set_ctx_by_slot() as the caller-facing API for this
path.  Update the internal consumers of bio_crypt_ctx to handle both
paths:

  - __bio_crypt_advance() and bio_crypt_dun_is_contiguous() use
    bc_slot.data_unit_size_bits to update the DUN when bc_key is NULL.
  - bio_crypt_ctx_compatible() compares phy_slot and data_unit_size_bits
    when bc_key is NULL, preserving request-merging for slot-based bios.
  - __blk_crypto_submit_bio() short-circuits for the slot path: if the
    device exposes a crypto_profile the bio is passed through as-is;
    otherwise it fails with BLK_STS_NOTSUPP.  The software fallback is
    not attempted since the guest has no key material.
  - blk_crypto_rq_get_keyslot() skips kernel-side keyslot allocation
    when bc_key is NULL.

There is no functional change to the existing key-based path.

Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
---
 block/blk-crypto-internal.h |  2 +-
 block/blk-crypto.c          | 57 ++++++++++++++++++++++++++++++++++---
 include/linux/blk-crypto.h  | 25 ++++++++++++++++
 3 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index 2c7a0446572a..04035d237f03 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -176,7 +176,7 @@ static inline void bio_crypt_do_front_merge(struct request *rq,
 blk_status_t __blk_crypto_rq_get_keyslot(struct request *rq);
 static inline blk_status_t blk_crypto_rq_get_keyslot(struct request *rq)
 {
-	if (blk_crypto_rq_is_encrypted(rq))
+	if (blk_crypto_rq_is_encrypted(rq) && rq->crypt_ctx->bc_key)
 		return __blk_crypto_rq_get_keyslot(rq);
 	return BLK_STS_OK;
 }
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index bc3a9f59574b..2212d06d3c11 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -113,11 +113,31 @@ void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
 
 	bc->bc_key = key;
 	memcpy(bc->bc_dun, dun, sizeof(bc->bc_dun));
+	memset(&bc->bc_slot, 0, sizeof(bc->bc_slot));
 
 	bio->bi_crypt_context = bc;
 }
 EXPORT_SYMBOL_GPL(bio_crypt_set_ctx);
 
+void bio_crypt_set_ctx_by_slot(struct bio *bio,
+			       const struct blk_crypto_slot *slot,
+			       const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
+			       gfp_t gfp_mask)
+{
+	struct bio_crypt_ctx *bc;
+
+	WARN_ON_ONCE(!(gfp_mask & __GFP_DIRECT_RECLAIM));
+
+	bc = mempool_alloc(bio_crypt_ctx_pool, gfp_mask);
+
+	bc->bc_key = NULL;
+	bc->bc_slot = *slot;
+	memcpy(bc->bc_dun, dun, sizeof(bc->bc_dun));
+
+	bio->bi_crypt_context = bc;
+}
+EXPORT_SYMBOL_GPL(bio_crypt_set_ctx_by_slot);
+
 void __bio_crypt_free_ctx(struct bio *bio)
 {
 	mempool_free(bio->bi_crypt_context, bio_crypt_ctx_pool);
@@ -156,8 +176,12 @@ void __bio_crypt_advance(struct bio *bio, unsigned int bytes)
 {
 	struct bio_crypt_ctx *bc = bio->bi_crypt_context;
 
-	bio_crypt_dun_increment(bc->bc_dun,
-				bytes >> bc->bc_key->data_unit_size_bits);
+	if (bc->bc_key)
+		bio_crypt_dun_increment(bc->bc_dun,
+					bytes >> bc->bc_key->data_unit_size_bits);
+	else if (bc->bc_slot.data_unit_size_bits)
+		bio_crypt_dun_increment(bc->bc_dun,
+					bytes >> bc->bc_slot.data_unit_size_bits);
 }
 
 /*
@@ -169,7 +193,14 @@ bool bio_crypt_dun_is_contiguous(const struct bio_crypt_ctx *bc,
 				 const u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE])
 {
 	int i;
-	unsigned int carry = bytes >> bc->bc_key->data_unit_size_bits;
+	unsigned int carry;
+
+	if (bc->bc_key)
+		carry = bytes >> bc->bc_key->data_unit_size_bits;
+	else if (bc->bc_slot.data_unit_size_bits) {
+		carry = bytes >> bc->bc_slot.data_unit_size_bits;
+	} else
+		return false;
 
 	for (i = 0; i < BLK_CRYPTO_DUN_ARRAY_SIZE; i++) {
 		if (bc->bc_dun[i] + carry != next_dun[i])
@@ -198,7 +229,12 @@ static bool bio_crypt_ctx_compatible(struct bio_crypt_ctx *bc1,
 	if (!bc1)
 		return !bc2;
 
-	return bc2 && bc1->bc_key == bc2->bc_key;
+	if (bc1->bc_key)
+		return bc2 && bc1->bc_key == bc2->bc_key;
+	else
+		return bc2 && !bc2->bc_key &&
+		       bc1->bc_slot.phy_slot == bc2->bc_slot.phy_slot &&
+		       bc1->bc_slot.data_unit_size_bits == bc2->bc_slot.data_unit_size_bits;
 }
 
 bool bio_crypt_rq_ctx_compatible(struct request *rq, struct bio *bio)
@@ -260,6 +296,19 @@ bool __blk_crypto_submit_bio(struct bio *bio)
 		return false;
 	}
 
+	if (!bc_key) {
+		/*
+		* Slot path: the ICE keyslot was pre-programmed by the
+		* hypervisor. The target device must natively support inline
+		* encryption; there is no fallback for slot-based crypto.
+		*/
+		if (!bdev_get_queue(bdev)->crypto_profile) {
+			bio_endio_status(bio, BLK_STS_NOTSUPP);
+			return false;
+		}
+		return true;
+	}
+
 	/*
 	 * If the device does not natively support the encryption context, try to use
 	 * the fallback if available.
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index 938ff536838c..33ae52b77522 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -119,9 +119,28 @@ struct blk_crypto_key {
 #define BLK_CRYPTO_MAX_IV_SIZE		32
 #define BLK_CRYPTO_DUN_ARRAY_SIZE	(BLK_CRYPTO_MAX_IV_SIZE / sizeof(u64))
 
+/**
+ * struct blk_crypto_slot - physical slot context for slot-based inline crypto
+ * @phy_slot:           Physical ICE keyslot index (already resolved from virt).
+ * @data_unit_size_bits: log2 of the encryption data unit size; used by
+ *                       __bio_crypt_advance() to increment the DUN correctly
+ *                       when a bio is split.  0 means unknown/unset.
+ *
+ * Used when a bio carries inline crypto context by physical slot index rather
+ * than by a blk_crypto_key pointer (i.e. bc_key == NULL in bio_crypt_ctx).
+ * Set by crypto_vblk when building the bio for a GVM VIRTIO_BLK_T_CRYPTO_IN/OUT
+ * request; left zeroed for all other bio types.
+ */
+struct blk_crypto_slot {
+	unsigned int phy_slot;
+	unsigned int data_unit_size_bits;
+};
+
 /**
  * struct bio_crypt_ctx - an inline encryption context
  * @bc_key: the key, algorithm, and data unit size to use
+ * @bc_slot: physical slot + data_unit_size_bits for slot-based crypto
+ *           (used when bc_key == NULL)
  * @bc_dun: the data unit number (starting IV) to use
  *
  * A bio_crypt_ctx specifies that the contents of the bio will be encrypted (for
@@ -130,6 +149,7 @@ struct blk_crypto_key {
  */
 struct bio_crypt_ctx {
 	const struct blk_crypto_key	*bc_key;
+	struct blk_crypto_slot		 bc_slot;
 	u64				bc_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
 };
 
@@ -152,6 +172,11 @@ void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
 		       const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
 		       gfp_t gfp_mask);
 
+void bio_crypt_set_ctx_by_slot(struct bio *bio,
+			       const struct blk_crypto_slot *slot,
+			       const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
+			       gfp_t gfp_mask);
+
 bool bio_crypt_dun_is_contiguous(const struct bio_crypt_ctx *bc,
 				 unsigned int bytes,
 				 const u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE]);
-- 
2.34.1

