Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794523167;
	b=hQXrLZw+Z/xfb6B7cMQpGVceD47v2QufF8fU26kMn5oxLDOh1icWvsqE/E6EXSougWed
	 9YtDW9qyRul37WS5Ue8oj2J+eEHrWiqeibSx7bYRt/VV+Q9BT/6XSS2n0pn9u1xWtwgSF
	 6gxjIcbmsgCmOMeyYvsUxAEV5xxKazZlPbvrWhbE/82U6Rphvqb3IodjYhoTbyQRVkozV
	 DofTbvUUxv58h2g2+o/oZ2/GkEvOedEft5CZAdZW6o3zI8mHNNxnC+/yNA2IpSsybZItd
	 LobFox5YCcq4lifzg21aA6g0sYttMo+qhHAsw5n8lQ6sUbIpKk/pG7z8djH5pNSWDNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794523167;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=wRKS0AEcnZLyk4SJMKgDIkHcfHABAQfWhr9XBghPIvQ=;
	b=0SCcGBjGxdN1E5fEDW062eTvgcnXu2m1qCEVTPr+pNxR6QugljLjKeA0GhNfSLherDwJ
	 ZC4u8C1XfYC6o3/Vqw7Z4eeANu3hJLmSZb48fa/axUDe7GxThjnTgZyTVZKtLXM6EGNR4
	 CjjvyJT47HhRMiecTZX2ukR3tRV622knw7gAXv/TgGWc3VWiygZl9apr3uq0sDa0kX9v/
	 Omjx1VfrdwJsuc0MjO5uVV4APFY2Fp4FalaMx9FCDqKqWYO/9mSxZBN6TYUNCXo8Cbj6O
	 SSx1/R9IJMAa154k6G9sf0yPDqYWcIrilODUGfQQ3lylO8obUjaJiWOP1GWRfXkYgRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="Pxs/y/CX";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=iuIg0Dgi;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D8A606A333
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43D8A606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Pxs/y/CX;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=iuIg0Dgi
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACJZkrs537303
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wRKS0AEcnZLyk4SJMKgDIkHcfHABAQfWhr9XBghPIvQ=; b=Pxs/y/CXNp6+f9iv
	yr33sDj6/7RZBTaCKEoLUOAcWh9uhONZ9Y0gNZi08Kyv8Atv79wiDnSJG/IUum/n
	KAWJupbgZXKlS+FLVuMy2wboLb2UJ5mi1YEEE49HPhjBlF0fLeITTcpI0WhrZe8q
	5U0++R4l0oGWhe83uOKOemaPB08pA3FsQ3gSR0hsM+Wi4+M0KIhBGt9O1Lz6oNdZ
	sGML8xNhDz1OWsbvITst8LJ84Z9xWfSOgkVsYJBljQTvSYA+6jkW6KHPhteY6bKE
	8449Qj18kNkEgvfTAKt8uWcrbqKmYgZLv5q2RYHhcFQ+CzayC3OfV1E36qZuoinp
	w0FXdQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hwg1b9gxk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:25 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30bcb065bfdso478688eec.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794523165; x=1795127965; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wRKS0AEcnZLyk4SJMKgDIkHcfHABAQfWhr9XBghPIvQ=;
        b=iuIg0DgiuGxVKvAYMGluPCQp4myO0Ia3G4mF0lZgkRoIMuEKyweJ3KdEYsgTZ7uVhm
         5BmD2L2kRNIv1GqtR6UcFiby6N3JZ6MzXktS9ZteGrM4AdZINDUsnG73Q/uyU3Dy44Sp
         XBKcctiDmGV3pq9ouBmuR7HCq/bH5Vsv2d9l0B9oMct+agBTw9yhhH+TlayQrmPAYxap
         QNPAv7gHdKIIJYR/n3zG+a1GbBXrAPB9L5mWfaEq6er/QvhPvqEU+ZQ9Y6US2bxFwXqb
         Ogpfd4OXZPWuq6nWQgxy+4k+9qD/7T1LjtrtV118IvUurbX2kw43BXIXu9AE2h1QD236
         txXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794523165; x=1795127965;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wRKS0AEcnZLyk4SJMKgDIkHcfHABAQfWhr9XBghPIvQ=;
        b=Ru7PL+rG2XMCFfTpjIEua6GYHffdyPIj9fbQgvON/4I3hXSEOT5rNgrtZbKcjwikyQ
         WttrNvoS4NLW8yk+hWgNghPcxC7PGDYaIDg9ABXq8MopZrx3GVai90p2jbf/az5bjqXe
         3IZ1wnAIc2yo2pVeNZ0qJiXggS+0Whx/RG+TjtiwDfQ1jry1pfV0h0oA8L1tctqxDE7w
         C7iJ2nYZ3FzXIUj6aWoSTJPzD+1NoD6XCaTb27O7lUHyMttS9J1gQg7rBttie4I0ThkH
         Xo3CCaRRYVnT0K+fizMNasNlcs92D6TZf1ODLye4Le364RPwiPZKDYcWk3bL1wCY4zOc
         tyvA==
X-Forwarded-Encrypted: i=1; AL+hErHS9gMcrFWEm3A4ATd3qd3THuKsoO0SAQfmRvBwiEwSJqkhHQ8UiDZCXWRaIfcvb4wiX5iXyBx7Dgk2C8U=@vger.kernel.org
X-Gm-Message-State: APuU4Z8dHD2K42wsy+yiZRZ5FDiPA/RdIF/dtya3iy0jPETv5R8ORivt
	yXv3/cqC0PGrtE5HB0Oz4ogaNZ+lOdCD3oEbs17f4cFHoNgzdalebuBGXOlY7H/rkRcRp1XsqRb
	7XLdgzlhuQYLURb1++RQi364SDR3tt9Usq8hhVs8/2OEzwnVfeBp2TQWsbApE3KGmllc=
X-Gm-Gg: AYBFou3fDEeRBa2h8wMdKRlAyWZ5Q9SaF7AHr3jIXBcVKTIAQR3Fz+zHfyuCdFZFowi
	ARtozIhGplHuDMRbH6FNe7uKubsMdhmR98UCOP+ZkktMvZ9Yl0pkCDVTktTXbXr9fOEwafeRbxp
	M6d38LU6qcXaP1H6nLfZT3UH81yL+vRF1FBYkOPhBmZzrKu7O9SZxSOX5Ww2Tl51JUJyv4VrSld
	RKxEAJ2NI25LsN6AwzUNRrLtqGSlLYJSlkVneVhdnxjJ+16H3LSzs372X/RHApkCzXWsdGMkIYj
	NiIrw4IfAYlVPz1ds8y6CAPbySNicMGf55ZCs4rGqTfp2wCXLsMHDEFLNTwtsg6GugyWEYvGaKk
	oe9Fbk+rQYipqbhQr8JcGDjt0PUv7uLyy6Vha8AW0A3yhJ9ZX24HOiC/DCO5wh623yjfxgICfZg
	0f/IjfQ01X5w==
X-Received: by 2002:a05:7022:c89:b0:1b5:227:7d1f with SMTP id a92af1059eb24-1b5030d765dmr705365c88.11.1794523164820;
        Thu, 12 Nov 2026 14:39:24 -0800 (PST)
X-Received: by 2002:a05:7022:c89:b0:1b5:227:7d1f with SMTP id a92af1059eb24-1b5030d765dmr705348c88.11.1794523164263;
        Thu, 12 Nov 2026 14:39:24 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm2333496c88.5.2026.11.12.14.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 14:39:23 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 13 Nov 2026 04:08:28 +0530
Subject: [PATCH v13 2/6] ufs: host: Add ICE clock scaling during UFS clock
 changes
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-enable-ice-clock-scaling-v13-2-258dc817bd63@oss.qualcomm.com>
References: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
In-Reply-To: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        "Martin K. Petersen" <mkp@kernel.org>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=c6Q+0h9l c=1 sm=1 tr=0 ts=6af6401d cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=yPCof4ZbAAAA:8 a=4vEl8bdWBwuQafGpEzkA:9
 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: mBUPmsPT-3tx48gneR_rsB2QhU-9Y6aO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX2yoFIpPSKqJS
 51pegzs5BXmSxdBd8L+8M6d0lmBTb4NINLQVoV6BqpksE5l777hzhI0RBoXDi2kUkszF1la6cKH
 qVwZ+tgRrBlF5mnv2uVm6WE2HHw0RROqICkKH9qImvO2nR0CzRxFukUo2XhxDuGUd+D0Kxlta22
 Tf4wg70NhN7+i6mEr6CDHd+iFpaPE5/rP0mesn95PteNXAShL099CIFePFTNYgIwGspN25Bmy2O
 rvfw3TgorMY10q2ROHqX5zv/AU+JPBY1RuleREukiI53lYUjmawi/NYR8N1gS8s3XkVALg5TsBr
 CJS8AQwLuBeDzd8FvOL8/tLuWvNF5WPhofLszYIrOlFYEdwsvWBK1w/G5o8tuaBxNvkeJRB7sp8
 Cguy5k1aJD2WClAch0lL3BTUzEcrGW81uoOzTNas1+D/MH4PvtpQPkiRZpdLIz4XyU7m+qWvMFX
 V7DUlyC9nRrQM7coSTA==
X-Proofpoint-ORIG-GUID: mBUPmsPT-3tx48gneR_rsB2QhU-9Y6aO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX9J1LXAIyXFWk
 TuI+TAIIFqgbzV8m6CrkeqCaFY4zyvFvoGLa024vN0b0aeJzvUJCGu2G8vdlWWu5oSoe6YzQQXr
 n9aDwC03XY5HH4CWBjWP7i4SP9Ajjp0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_03,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120090

Implement ICE (Inline Crypto Engine) clock scaling in sync with
UFS controller clock scaling. This ensures that the ICE operates at
an appropriate frequency when the UFS clocks are scaled up or down,
improving performance and maintaining stability for crypto operations.

For scale_up operation ensure to pass ~round_ceil (round_floor)
and vice-versa for scale_down operations.

In case of OPP scaling is not supported by ICE, ensure to not prevent
devfreq for UFS, as ICE OPP-table is optional.

Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 6afb8498b8c267d0bbbdb1e14f37fd305c71fddc..5019803a6aba4f649972e2ecdafda1e9e38fe2ba 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -307,6 +307,15 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
 	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  bool round_ceil)
+{
+	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
+		return qcom_ice_scale_clk(host->ice, target_freq, round_ceil);
+
+	return 0;
+}
+
 static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
 	.keyslot_program	= ufs_qcom_ice_keyslot_program,
 	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
@@ -341,6 +350,12 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
 {
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  bool round_ceil)
+{
+	return 0;
+}
+
 #endif
 
 static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
@@ -1987,6 +2002,12 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
 			return err;
 		}
 
+		err = ufs_qcom_ice_scale_clk(host, target_freq, !scale_up);
+		if (err && err != -EOPNOTSUPP) {
+			ufshcd_uic_hibern8_exit(hba);
+			return err;
+		}
+
 		ufs_qcom_icc_update_bw(host);
 		ufshcd_uic_hibern8_exit(hba);
 	}

-- 
2.34.1

