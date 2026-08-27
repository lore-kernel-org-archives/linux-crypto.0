Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A375A488224
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 16:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846923; cv=none; b=PKWHe6itrPMW5NpuPUMchvE3bP4yAsWz0NM5jTf6F+ojqoWrMZhk9y7OMat06BFB3LxyMQeE2eGkibaiTaV/aul6c3+lHc0Mx6jKaLj0imiXWHLiJBlfQsSy+prn2y7X9butcnAcChsJjk46YhKsrI5cCQHHdDXNmLa79Bi2dkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846923; c=relaxed/simple;
	bh=XzVRSJskkXzsRQMCF0q2XHzItKnQaDkIqK2bV/uMi6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9AwKHqPOUVI5XI6Ni9jI3bU7ibBpbjBWfgFXsXuJIakRJmEdfjqo1/bHG+FN8+GX/78sBXVsVa0WO3q4kbcttw/5j2DZBhMvNKNCBsBntEI/lEfR5cZ+kAfUsinY+ShUEe5p6WEPqGs0sHttx/GqFWojJqVuzuO7S5Xur2GbAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oFwTjd6O; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=E+sW5XYh; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oFwTjd6O";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="E+sW5XYh"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RFbrtg618146
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 16:08:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=GQuf/V68eCT
	XXH2b/XlQO3XYqlyP/kTHk7utlZNkRig=; b=oFwTjd6O46+rn3wQuhLnjLfejRI
	JzlkxQSt3yFeu41vHuEDRwREWQb/MqlkNuVm1K7rXRrb1LnCdn7kasEpR73XcA4I
	0RUsK5WYrYHBR+ekT3kOuxUJTj9DvpOV7EJQJZ7kZTPydi9vTE5SM5FJFJaM4swO
	6cx951RiLv1XwxTtlcUdL7qyWC83c9a0lrDN9Ro7St3H1fkKn1PDPGNdgkyYf+n4
	0I05RdmD/c3T6KmB5Jo2tG6ZNq9g0uOiMJHwGomEX1zaxpZNwDz3WJFIzCPUKQC5
	VUHQzo0KHoD6lNydXTaSoa7h/p4k7EROq3txUc2+bYHsHO/xDvwP/N2vM7Q==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ga4egmkwc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 16:08:39 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c85798977dcso72748a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 09:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787846919; x=1788451719; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GQuf/V68eCTXXH2b/XlQO3XYqlyP/kTHk7utlZNkRig=;
        b=E+sW5XYha0f/190dTjWfE++Q4RGQ4P5RCi0t0HrHTWlmQkel+mnKM/WGJbVSRe3S3a
         SAlSetbYt/y671R0oIt1wFMhuOO8p72bjg20Oq62O8bWXaalBcGbcf8IKsWXSz2pZrTe
         KocnoKIHiupbY7PCUpCwEqpVoxXicAiayN5cgYl7qkE+atCdDPNJa5CMDdLOzkHu49XJ
         ZRW85T3c0pLmp4pJ3PEcIJ0fSBEAdrFQbZqlPVLZ2wX72uNkDvVBqDOgfQKOWEUz103b
         mjFXlEQyHqBogHkqop5AyExu3sl9+Cue8xfxjS59gVAcEQQCnpT87+CNhebATr7B63/u
         Fwpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787846919; x=1788451719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GQuf/V68eCTXXH2b/XlQO3XYqlyP/kTHk7utlZNkRig=;
        b=DMqV5OE4lbfBzmAkHddFX4iDzm7vFypP2JNiu323DbkwXDxWBisBIGemVVY+WagYcn
         eReNXL5HE11QJV4kRpljYsYxitMtx8dsjvuLDQ8Z71CJWwOAeDY82VMtpsacBh+49s9z
         81attmdl/QNdPgozsLqEfLBiiulFYUDtKAFZlMK/qS5AIkveNCuMFTje6rlnX4BB5EwX
         h/Cuar7lS8/Td+OywSblytyHoqAplqLhk3ntjc+9oix8lgtM2nvqloi8lO5fPYoeS2Jn
         hMZ7kp9+9fIbazIQa7yMPozYoc5hpuLRCVguCvYLSGKHkz+PZOsVlYpHXmKS4Sp4XboO
         EyrA==
X-Forwarded-Encrypted: i=1; AHgh+RoOfX9JXzaqsaSEdsthxEjiyqK02Xo5iRf8i6eHgfJlyGLeIANHMuS2Rq7LpvylZolhXf5kY1dNkIPMquk=@vger.kernel.org
X-Gm-Message-State: AFuF++kCEdMhNQwwhtC6W7Xy0swJjlqTkH9Ky9SMgmT/5bRYcIwByaFF
	d9wZ1PDGAUxC/f6d4BXuMO64gkt2kMdujDgPk5svEdmF1uHQ3NasftIMWFrumvVK4+SyEAMa77B
	d8IeD0fkKM0xlQT29bkY4yFRbaZq92mjsVN+oow7iCyyi0h3ysvsPUSMCnGtMmYiibps=
X-Gm-Gg: AR+sD13k1h+MwCJv5lIVBmS+ZrOYGDu7IIJIy6jncoIAtoTXkvbZJCxOehmyB8RvosI
	xCbvrV5a6JsFzAjmb6KMy1evIHDhm0T1skeeM9lK1jpeeNIBc9WrKl4vM0uGbZNzuUI+9vrbT18
	zNsggaKtnjFhlFcqKcg8xyv4eAs6KlQtg/eKkRRolh6tVFgnjqXzqPLSRSyVwPVPcX2VoHOdHRS
	lRiLfasltymLA26SqzseHy5yg1/3M+wJWlvfV5RG6DI0tBFs6qnoc4nUHlpXbTvbYUIckWMBK0F
	PId9GFGKI6aUf/f4BsAni1yBQ5PnBLgLzfRDYPvi3QjIgjQrijYiVbZfSo86RoEaTI/r/IDUqSV
	jAHcRD6wYLoS4V53DhKIN8dFZCc0vLxz5JRC4iwsQHWf6li/YwydGWSCkMho=
X-Received: by 2002:a17:90b:51c7:b0:38f:5801:dc0e with SMTP id 98e67ed59e1d1-396d0f52b2amr503449a91.15.1787846917352;
        Thu, 27 Aug 2026 09:08:37 -0700 (PDT)
X-Received: by 2002:a17:90b:51c7:b0:38f:5801:dc0e with SMTP id 98e67ed59e1d1-396d0f52b2amr503276a91.15.1787846916655;
        Thu, 27 Aug 2026 09:08:36 -0700 (PDT)
Received: from u24-san1p10108.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0fd9085sm3245892a91.12.2026.08.27.09.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 09:08:36 -0700 (PDT)
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
Subject: [PATCH v1 07/11] blk-crypto: move bio_crypt_dun_increment() to the public header
Date: Thu, 27 Aug 2026 09:07:16 -0700
Message-ID: <20260827160806.1295313-8-linlin.zhang@oss.qualcomm.com>
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
X-Proofpoint-GUID: 7QufcJAUSXQv2Xx4msdBmEqaNW-2XliW
X-Proofpoint-ORIG-GUID: 7QufcJAUSXQv2Xx4msdBmEqaNW-2XliW
X-Authority-Analysis: v=2.4 cv=DsRmPm/+ c=1 sm=1 tr=0 ts=6a906107 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=Dog9NmGJ06mbJvtOeFoA:9 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfX/aZFbvs+FLel
 bNBRF9W43LLVhDyyhwPjoASsSVYMsM/ZQXMVv1rAx43Ukk+SRW2Vc1LyJkRtr8KDskBgHuGKuxS
 h+d4riUI+ORi50zzNSjsM71u1n0B7zcF99gBvVGrirTK17k6Tc2LpUlxfhCuzcF+E2mZmCuljwc
 t9vQzpZvL3C/0RnI86Uhx4Vg2xQSraX9vLbEBz73a7RQdqf7ybXpegBIImsDrFqYyq8PeGQXoKi
 u8f5Ad2wiw3AhBikV7wCWTO1kvrFwyXLmbIJRmskTyId9D0G4A8O4DSWCw6QOlqZaBYRqNHXlUj
 BcRT6c4C465kgmjSrQLme3TlSsIm75GnHaQFfDsfFDd+vSITAjiwULuvOLOcxEDOgN+FPPobW34
 ivMS6YT0VyyMcAfmfpyxv0xbJ/HuPz3zNjKRRAprc7g/GiY75qXmCOpFmrumLhFBBtSuAqLB0CK
 hxR7gZd+lXqH7qEB9+w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfX2dOZspEwIQlh
 RWBvNDcaord2wTQcFqSoowMLnAkpE8DEpvI/tMJ7Xy0WHgRdZUkaEJE/EJ+T8UZdIWtJUOIwms/
 dgJcS6rKCgJabkGb784UQQRswOhJRis=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_07,2026-08-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270136

From: linlzhan <linlin.zhang@oss.qualcomm.com>

bio_crypt_dun_increment() is currently declared only in
block/blk-crypto-internal.h, which is not accessible to code
outside of block/.  Drivers that manage inline-encrypted I/O
directly need to advance the DUN across bio_vecs within a bio,
or across multiple bios in a request, and have no other way
to call this function.

Move the declaration from block/blk-crypto-internal.h to
include/linux/blk-crypto.h alongside the existing
bio_crypt_dun_is_contiguous() and blk_crypto_init_key()
declarations. The implementation in block/blk-crypto.c is
unchanged.

Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
---
 block/blk-crypto-internal.h | 3 ---
 include/linux/blk-crypto.h  | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index 04035d237f03..32c720aabba7 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -26,9 +26,6 @@ int blk_crypto_sysfs_register(struct gendisk *disk);
 
 void blk_crypto_sysfs_unregister(struct gendisk *disk);
 
-void bio_crypt_dun_increment(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
-			     unsigned int inc);
-
 bool bio_crypt_rq_ctx_compatible(struct request *rq, struct bio *bio);
 
 bool bio_crypt_ctx_mergeable(struct bio_crypt_ctx *bc1, unsigned int bc1_bytes,
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index 33ae52b77522..c9f436b6b2ef 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -181,6 +181,9 @@ bool bio_crypt_dun_is_contiguous(const struct bio_crypt_ctx *bc,
 				 unsigned int bytes,
 				 const u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE]);
 
+void bio_crypt_dun_increment(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
+			     unsigned int inc);
+
 int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 			const u8 *key_bytes, size_t key_size,
 			enum blk_crypto_key_type key_type,
-- 
2.34.1

