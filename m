Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E504848D897
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 16:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846918; cv=none; b=SFirFzCz0MMUqfto1Y5YgyCcVP6QKptoWI90oxHUCaE6MFanldpQ2f7gyIVZtd2yyN8tc9LT8hGmm4W8pjLfOReLKrefCY+XExtZluC7LF05Wr2cFVb0/bTvUNd20eLrnn0BviVvHbzBR+rTCMVKn0efS3aDNKUPlip5mJIXK7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846918; c=relaxed/simple;
	bh=Ro1Tw7bimijLX+zSbVZzcIcnTuF4NWioN9yBfIv7fvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrhZKDxwkMLTryxbDPdnPe7mnaNHCAAej5FXJdPT8Jzg9Zdd/R1vqBe9HhmS+GX3dMH964z7QFXiPyVj+BYO/kINwwiVzRZ+Dj7Qr+lRdaELSdh64BeowmG5hm62SuynYO6O5KAro9RXKHdBpDm7BPRgp52OLnJx1liBkkovBMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=c2BXcxZ5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LjCATQHE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="c2BXcxZ5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LjCATQHE"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RFc3Yb3921931
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 16:08:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=szEkNwgY771
	Xv6m8T3J/mh1f/ayBeeTB35yTWk5lZdE=; b=c2BXcxZ5dH6V7p/j2Ymmx/kbwuk
	5ypm5J+Gy/Xe/Rzmh16ripn5C4xaaNvcWhKVxilUrwSyL8ZaX1EONIWOJxKjHI6C
	9r8+zMkdIft7vyYF67XPAqAb/fze38RxCGxangfO7+n4KFZc/us+ZyuwC1j8Pr3q
	nXuWhE9t3ykQ9oKvWijc/LsP+z+xEZF0jnxEn6d6IoUsbP/bqvHFOuCzr7iOGEzf
	VCs/kF+aS58KXOsQVJPfBiAwXVM6ag2XRg296GLNCNw+hk8XAYYcFSzNfjV+8JVZ
	KwOz7DPYZ1w7iq4y7PTnCS311Urm9TKF4Q9jj4hYpivdxTMopVBqWIF3hQQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gaphw0h8h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 16:08:34 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-395543dc382so138926a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 09:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787846913; x=1788451713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=szEkNwgY771Xv6m8T3J/mh1f/ayBeeTB35yTWk5lZdE=;
        b=LjCATQHEOE+D9QJUdFlpEOXKfhBoJHGw2oxoncRikxPXQX5KMNhe2tRqrit69EjHUS
         7Ln2vAer69wf97WczDgOBln0pQTq1hSsGiZOr3cbFk6cL3err7Gz3bp4EoBRGYv0jeXT
         zuYHBM20pVxG0De/1ypb+4fCIYWuORjXARWYo8t/4gTmQ1JMhH8LPSyNdVrE4a3I5i8u
         ex8HV+XFuFX6R1H/PNieyeYJA7eqHgNE9oOngkffSDkLvNYcq3Ryv2GQgpT9WILtC/sR
         MxliyURkpY+PUKebUKGSYzTP3ksClIGgqNbkx05y9m4AXSu4/6UdW5o+VAUySQPhPrIo
         ZYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787846913; x=1788451713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=szEkNwgY771Xv6m8T3J/mh1f/ayBeeTB35yTWk5lZdE=;
        b=TaqIUE71xcMtIhDfbGpdZ+TiSqBVbLMMo5awi0PBsGOgRT9omFc/k0rvllB40QKliB
         Fv6/sYa1YssCdT3a+wYM/T+1jCWrxfGI8PliTVF6zh6ZZbny75TjWDbT+SUJIVziIgl0
         mR7tz3euLpHeoUnTpXIDsogWFLVN4LTu0juDQHqI17E29hGifJBdA+t13fCTO2J+mah+
         H3OpUn8nKmzDWA2w3vweuhmiHVZ82j4ZpXVS0QMwHbPK4yHSIsXgeHBYZqV2tmbZYL/s
         TMUGSBQbbyGG3STSIxmPfDsNzXRAfz4iGrZ6pdhBdrrSlj8ahSGJ9MY++MpOrpXj1TGg
         5wmQ==
X-Forwarded-Encrypted: i=1; AHgh+RqFURzEoZrIDdRrWdXndBDqyiXElo2fHbe2MDKgiv+irIGD5EkOoNvL88zzxV467pylR84ORthcMPzeJSI=@vger.kernel.org
X-Gm-Message-State: AFuF++lFf39SAhM/X/HZBZhgg1z29WwouX02VZisFUmJt9U95EKXEAJA
	N6BMSzRP75jVX2XDghUc0lp0VpAwSHpXLOVTOXBR18aJzkwdgkmHEzqiRico2l3yGdScuHH8rqh
	+uiIaavejunynkpbMyHUH1AYcYoWjeTjQo4yakTFPet14WjxR6q29IpqblHAhfCpq/rc=
X-Gm-Gg: AR+sD11pVhA73aVgB+jBkqvzmGKJ6klESjy7uwYCIOFAZgC9P+IZyXlaW9kShADEAdG
	OvzHoI6RKKzlN9PIoqKdgh/xztl427vLCDJDB6yCKCmxOKkhC+3VGlIzR58m30ZjsLkdJoCsCMx
	1RTUnqfFE58zd78mPuz1Y1T8qJNVxRskxv1BI4VbjjyEPezO3dBNzcmSlEXLUK6AFyY8Mc2bDPx
	v2E3nib1cIZNbc47QYJ0FcjJSFJpB8fVKe4GLfkWrpc+3/1Tr92FawJZtyNs0XFqoZb3OoLAHQ+
	vLrewVJhuQLSkPgEt8AHW6QKVk8RyFRxxXDSAQSeWmoV76O0iwq1uxdW6T16M+VV6FpdHnCbU69
	9jpKH8avG64yHVbgNSEf3V2LT+YZO84fKZGyriPV2pa8inf5SOAO6wPTrKz4=
X-Received: by 2002:a17:90b:3c47:b0:38d:f5bb:e0f4 with SMTP id 98e67ed59e1d1-396d0e27e11mr634841a91.1.1787846910192;
        Thu, 27 Aug 2026 09:08:30 -0700 (PDT)
X-Received: by 2002:a17:90b:3c47:b0:38d:f5bb:e0f4 with SMTP id 98e67ed59e1d1-396d0e27e11mr634645a91.1.1787846909524;
        Thu, 27 Aug 2026 09:08:29 -0700 (PDT)
Received: from u24-san1p10108.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0fd9085sm3245892a91.12.2026.08.27.09.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 09:08:29 -0700 (PDT)
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
Subject: [PATCH v1 04/11] dt-bindings: soc: qcom: add binding for qcom,crypto-virt
Date: Thu, 27 Aug 2026 09:07:13 -0700
Message-ID: <20260827160806.1295313-5-linlin.zhang@oss.qualcomm.com>
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
X-Proofpoint-GUID: a0YJMCff0Pb92z4nN01bTREyTizthivA
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfX5fgYCR4DK1QE
 99zChkxZS9280mjvOvBL4KtwamMCIlddzvtayzh0rLKfHSP45cMLPKNZFEabKUlAF3TUxP8IbB5
 zJN8Oa8+a6fH8tnFsjZ9gP0QkbSJa24=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDEzNiBTYWx0ZWRfX9+t7jM1WNwhK
 RINYVynoQ+aCk5P5JY0FKLpZtWoJqGuzLca0xKnZCMU4WzY501ECV+ix2Sq1uV1tdKRVidhu7EQ
 JUCz7I8wmJey+ioj7N0TDJ5nUlV4uHYwGD3ZxvM9HksPMO7phkagc7jT56LZAkfFzwX0/yOqmz/
 9DegZdZC9M374LmFdgjICRscG+02XxvWs13png8L9Ih3u9omIq5EzX/z9u4kgouzDHWT7fXDQoY
 ma7T7h+EtbSjGE1a8tRS5WsCOTdMEgbf67qt165woZdVdF+azUPBBLcBaC79TP1IqzCMxwSgf0t
 dtTrmDsWFGeTCc6GTntCFJnUyoEFVTNXDL8lQGs+WUEFIyus+lBSghlf9NXGx8rhfoMTPzbbOkQ
 JihncchIRpij+FgHEbXu8tCoCe25YFA5bJtamwb2LtuwUVy9q5KDN3bTZvsAw3fbHf1HqCLeBj2
 FIPDXxto6LxzIDGnVvw==
X-Proofpoint-ORIG-GUID: a0YJMCff0Pb92z4nN01bTREyTizthivA
X-Authority-Analysis: v=2.4 cv=E8b9Y6dl c=1 sm=1 tr=0 ts=6a906102 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=gEfo2CItAAAA:8
 a=EUspDBNiAAAA:8 a=S71HXAmslS2k5ljwlz8A:9 a=iS9zxrgQBfv6-_F4QbHw:22
 a=sptkURWiP4Gy88Gu7hUp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_07,2026-08-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270136

From: linlzhan <linlin.zhang@oss.qualcomm.com>

Document the device tree binding for the Qualcomm GVM crypto-virt node,
which provides the wrapped-key buffer size needed by the QCOM_CRYPTO_VIRT
driver to perform hardware-wrapped-key SCM operations backing virtio_blk's
inline crypto layer.

The host does not report this size over virtio, so it is supplied via DT
through the optional qcom,wrapped-key-size property.

Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
---
 .../bindings/soc/qcom/qcom,crypto-virt.yaml   | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,crypto-virt.yaml

diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,crypto-virt.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,crypto-virt.yaml
new file mode 100644
index 000000000000..5eb204f29762
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,crypto-virt.yaml
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/soc/qcom/qcom,crypto-virt.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: QCOM GVM Crypto Virt driver
+
+description: |
+  GVM-side hardware-wrapped-key SCM operations backing virtio_blk's inline
+  crypto layer. The host does not report a wrapped key size over virtio, so
+  it is provided here instead.
+
+maintainers:
+  - Linlin Zhang <linlin.zhang@oss.qualcomm.com>
+
+properties:
+  compatible:
+    const: qcom,crypto-virt
+
+  qcom,wrapped-key-size:
+    description: |
+      Size, in bytes, of the hardware-wrapped key generated/prepared/imported
+      via SCM calls.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    minimum: 64
+    maximum: 128
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    crypto_virt {
+        compatible = "qcom,crypto-virt";
+        qcom,wrapped-key-size = <100>;
+    };
-- 
2.34.1

