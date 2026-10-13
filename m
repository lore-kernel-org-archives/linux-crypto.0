Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC12F4D4889
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885522; cv=none; b=jgyWyGuoafvq0cEYhELUMQssYU5UV/ndhkGL5T9YXxFInBvtfpVCtGTTKZ80e40DNX2/21EJK1YyGbg8r7+SxCzWxDqxQeUlaecA/D41hDhNextrbakcZ1HmknV/qkekiplA0q202M3u7Gv0SJleoOE4iYAXjRIPeJIrJrv7lb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885522; c=relaxed/simple;
	bh=FAikOuYHitZp6ddVzGLa/+G6KPECbwnoEeE+84cT8FI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WvB7YaP/aCGt59XXuqRxRSEygJPwZgjh9/Jijxmg8cHFjHcCQwsn0H+p8gPaD6+N0FpkHmFgVpRM/Cj/iRC7tOhuIQ2BGfK/QBVG7NTvHePrgmnEfPc7KNKzDTteBP0dH9znFEC/pPSCKSg6pCqsGA0KFI1QKoAlOkz3G+4AAV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fwWoJpbE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AfDiLCuB; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fwWoJpbE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AfDiLCuB"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D944jR483080
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7l5zIcx1UL+ezYmtByDdHSMtk7pozUTglABDARGqPqI=; b=fwWoJpbELLjhH+E5
	rVLT8bKRY3TvoLrTgh1SXBAUlnJXNC2FOb4UHkdNuiF6M85CkbNix/v99ywW68m7
	v7PtmH7nQV9xVukglJerRqbsTJpZCYspAdlRecn49uqlgp9p7mJ07hyyHGLQlKv+
	T7Nclhyf4fOdZJLvbhowSs3vwis394fFVY5/Z31b/YjnWHv+Db9kHoqll7hpXO8p
	4jV/51PqnJ9MCDSFtRXOPcUSOPw529U5apc7TLJqgSBw8CfMl1i5TmYk26JhCkk5
	ioqmJQL20nqEqQl7EWEZRTgdFKRrZA9ZKvc3b1caK+biLvcSmiX3roITbxZY2jjr
	HQOn5A==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9hpg87kp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:39 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93ea9ea9d13so463751185a.0
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 02:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791885519; x=1792490319; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7l5zIcx1UL+ezYmtByDdHSMtk7pozUTglABDARGqPqI=;
        b=AfDiLCuBqEJNsKpWruXhAJvqk5fVcz9phNI8FI1jL/q4SCg7N8e0WbpzEyWveKX3bW
         ksX6DkT/kTGSAly8vghZcU1C6Cmildc2Zid/yyWSR3LudRZ9jolzaWr/8r0rD9RCfFT2
         2kecPXbZp0WBBMLQjNebxkdnYdPTE23x9fU0EJraUkhTbYrYS3Kspj22s3Hu6QHwAOCq
         8KF/ZZ2i5M2CIM+HHboNLiK3X9I1c6/c9Byi47crtXtT+g3EuHgFCr+WNBcKtk1GEqpo
         houQ4/tYkCQUW7VWDDWZvX6xv9rEjEs87DhIgQLJI5E3v6t286nUGeocZy18JSyVun+G
         +UUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791885519; x=1792490319;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7l5zIcx1UL+ezYmtByDdHSMtk7pozUTglABDARGqPqI=;
        b=zsdWl6mcjx+BngeK+Yuh9Je6woF/rGiffI2KXpY76DQOqN9FwwKDvfbk5+N3dFO83C
         zOILVaRtFh4qDuYl+YaPPy7MRQjXPTf6qCpCaZq4zEfBnGRfvtgvDvtKe84DYCwme0m3
         sVaNVg00vMr4bgXPLmQRhjNZi5ocdXytnPkHco49Fr/LdZpjy3ZqM7O/KDpa8j2HbJBs
         SITchW8qndbGSTpU2j+6lERonhUxqHcu/j+9DCOdCW2N2mnVXKRgCfHYEDby8TXiTSKZ
         ZvTcemnnrqSQ2cHewXk0zT/0PvadyBCwMZXb3vSBOJYkuUtvH+6Thgp1HRtAYljZew0p
         k8hw==
X-Gm-Message-State: AFq9FYJM6HrwX4g3ZObukcAHzDK6Qjuz6hcIu8yStZ477FUhreuca3YT
	LgCwWmJ+JkglCpLzMKfmeoO/Zee/0oWnzT3BvFdhcvlBxZ3QvbjN0knvFJtLEsLygzdLh7HjOOM
	BSUOqQJEkyitWVpwXukjYbYtr7e31WsKwVoqsujwiqBSxcM+gp/ft2Mcw5KekRpsVp+Y=
X-Gm-Gg: AYBFou1Cwdbx7r2SP0zDzRl+fNvVH0oqIEaE59Z3eJTZnB9txC6UDnaH0V8GKpu3YZv
	ArLOPlOuOOFwmOqp8L1whNaLBhyEbqzAMtG3xhJQp1JSYwOQ74QEDOHBuJCwh0Pz1cEdQX9WZOg
	fPAW5BcaaAV2hdi+MQKYsW1MJ3pPnkRmYYHxwFAClupgm58bkGx6ICQ0ESoIEKhqd7jR0O5AvEK
	Hq/VYKqbFwQQI1BZ1Z3U8SZ1s3bi6OK01LiCC9lWRIa2spuh56QlEv8E+UR2lFY+aUZbu6bSUTl
	m84UBscrO6mYRiYT9FLe1YdWJ0hgyG5m+ikrt4wzP8XfdODQLOBDJ82A8E2Z2ig6tLIO1NdH1iR
	zOlSK6Gg7z5u/5aW9z/1dbtRMUDlE
X-Received: by 2002:a05:620a:a416:20b0:93e:c12c:9b76 with SMTP id af79cd13be357-93ec12c9f3cmr1306893985a.81.1791885518968;
        Tue, 13 Oct 2026 02:58:38 -0700 (PDT)
X-Received: by 2002:a05:620a:a416:20b0:93e:c12c:9b76 with SMTP id af79cd13be357-93ec12c9f3cmr1306892185a.81.1791885518508;
        Tue, 13 Oct 2026 02:58:38 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bb6beaesm209412025e9.0.2026.10.13.02.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:58:37 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 13 Oct 2026 11:57:43 +0200
Subject: [PATCH v10 14/14] arm: multi_v7_defconfig: enable the Qualcomm
 Crypto Engine core driver
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-qce-fix-self-tests-v10-14-57162a38a554@oss.qualcomm.com>
References: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
In-Reply-To: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Pankaj Patil <pankaj.patil@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1386;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=FAikOuYHitZp6ddVzGLa/+G6KPECbwnoEeE+84cT8FI=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqzgCmLFOSLDnOzisgehD4plX6X6ibyG32KeR9V
 0FH01CKIfaJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCas4ApgAKCRAFnS7L/zaE
 w3xpD/9OZVnqav4CittjDEhTEYHIZ3M45w0MMZUJ9CX30r57sfLqXPF0U9r+OTdlYsSKku6yDNT
 miL26KRahsmIvZEm9IrTzcD2NyjICa+mWOcPOx4oNH+ygzjM2K6nTLgIHnS4QV+aGRwyLmB5K08
 jiz2B1bLioO9kSxrRkRGhuxrc2h+s3t0mR7pfrP7COm8TceDp8WovkW9tbgC3PaoMzVImntbJq6
 uKR/OuH1gtxv77nf7bXY5fLuD/UVfJheE9uvdK5ffovjs7sbTQg3r0J3cCn4vsdum2RPB5yVw4X
 YqkTQxBeTDr3a1V0I4w6nXto/2R4if1l1rfA65vzx9Y85AEWF8GUMDwE8jD7PbhSaFjyA5HskaJ
 SbYTjdVC4wE57IYSx3gsyukClHmGirYORlSVrWc73ejV3xq3iVN1fkN4++G67GTU5S+MpNcpRaF
 CrF7jGzpcvl/45w2frtrHKEVFLFOLT8usKWiMEzemY4kzaswWMoGtWHuOphpeAB5H2QLjBSL6ZU
 f3a9ysM9MW/BdxM7JbQXd2/zVYC3gCW7s22TbXxIiQdFmlymFtRWAD8h8oAcdZLgsvjl19JgTdN
 SCjeNJHW9vuofcUYuCjg4XjTo7WHWlYQ8AQcKawKR9NNXjh/jrDPUs34eCEcenlrmAw4ov79OcL
 wJ+3X8T/1Fjm8XQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: drFFzD11vHWfRqjztYLvI5UdXK9FjFTR
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX9In/2DpDkdqe
 mnBkS0Y6LH0052CGg6M9s21WBYygh2C55Tfmbn9xQoe6+joC+srhG/E6N3T6W1SmnT9x5an9o3t
 jf5/FV0bk2/mUPZ4phxSJdKna0t3XyU=
X-Proofpoint-ORIG-GUID: drFFzD11vHWfRqjztYLvI5UdXK9FjFTR
X-Authority-Analysis: v=2.4 cv=Z4Z5j3RA c=1 sm=1 tr=0 ts=6ace00cf cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=QftN5WpXeUmWSfsFEiEA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX5CY4qk9N6rip
 uLUNLbdY2Zh4WLoNwtkWJ948zJ8M/E5HtOmULlwGzweTurSiXQEkRkbTtpkD34Benp32OGutetF
 9yXmDI1r17AGlFaslxKRkV7j2EiMDQ/T7MCZM2DVB0i3IWMCa9JAvkTsm3rf8j9+bINqZU8ZtQH
 caU+iV8zxQXleyxtvOQFguwA3xAs94Wxau4gWaTir2DarfBnzXivCZI2NEvCem5ZvijWumNRLu7
 95xArduXLZQlx4AhBNTbtlhdFnAJvWVwqc4MOAo8Vlxv6lDUcBxRhiicePkbBszfBxVSbIVvQei
 2/P896rkxIXYte0XNhMrs+/laVdd+Y84Oh0srlIu8BpGAc/uu2YrjuRDe1xHPSYQceZ6y7nzX8S
 DB9Pyqlp7KmP4DBVtqWNJUI5t4uHq2VWBldLnF2TciqMbE+D9e5mqzr5+1DYaHJ61aRMJ/9E55/
 rUS6+qp/mVjy4Gc5yIg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610130039

The QCE core driver should be enabled by default as it binds to the qce
device node and scales down the interconnects if no child auxiliary
driver is using the IP. Add it to the multi_v7_defconfig. Disable the
crypto part of the driver by default.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 arch/arm/configs/multi_v7_defconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 2d6292f8cab39596b540084fbd8b30f4c25cd4ff..7750b11f80312bf6a6f0fb276315f32f8714b4dd 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -1150,6 +1150,7 @@ CONFIG_QCOM_SMD_RPM=y
 CONFIG_QCOM_SMP2P=y
 CONFIG_QCOM_SMSM=y
 CONFIG_QCOM_SOCINFO=m
+CONFIG_QCOM_CRYPTO_CORE=m
 CONFIG_QCOM_STATS=m
 CONFIG_QCOM_WCNSS_CTRL=m
 CONFIG_ROCKCHIP_IODOMAIN=y
@@ -1323,7 +1324,6 @@ CONFIG_CRYPTO_DEV_ATMEL_AES=m
 CONFIG_CRYPTO_DEV_ATMEL_TDES=m
 CONFIG_CRYPTO_DEV_ATMEL_SHA=m
 CONFIG_CRYPTO_DEV_MARVELL_CESA=m
-CONFIG_CRYPTO_DEV_QCE=m
 CONFIG_CRYPTO_DEV_ROCKCHIP=m
 CONFIG_CRYPTO_DEV_STM32_HASH=m
 CONFIG_CRYPTO_DEV_STM32_CRYP=m

-- 
2.47.3

