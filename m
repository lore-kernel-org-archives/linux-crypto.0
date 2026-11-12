Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794489619;
	b=y7SPu3LqTspQSBC01VPOT9tEbPj1IyGwbYZJAWZa3oNo0f/CTLvXZp60vzwoSO0AY+sB
	 YrXo3TESu498KRvSv42Kyh7ECdvGjVn8rGNVYRTP5wms5mTtbyimEUAQRXwzP9gBfKPBd
	 s1Ci2N3akVFqKi9f6fPCN04ULQjq2FoZsVCBgEtNJud+0fbKDdL0BeXl4l/IvFeQl/Ycx
	 Yhn/cJ3T+q8BaZLrJWSM0AcCyIMZcbD1e4SNtFTAey2UUpFp/s39iAvyPzJiArW8tnVfc
	 y5PLfpGu/uKgzFo/BjDdAttc9JUg0hWLaDrGoTxJVLfDC73QAXUFUPIY8M9mF324ppA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794489619;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=Ud1KwhBJxzUmwkiA/rZSRNzFDb2bfZAFAs5A7HMP8WM=;
	b=gCtuqaRSYR/3YdfnTsv3vpRfJcsPjEZKazzOsbJbViJqGSUE3dWm0g6c2640nBEB5SLY
	 DoO1h0HgGX/WjxGWtkerX7h2/WgBmWqoghsoY8hJeLz6uoKGswxRIjDxoFxfTy5jbKKt5
	 3Y4VwRPD2LRXY5RgSZMYyF0G5GEs0viCEy5Ak7nG5Ao6K7zItPBKojT8lFvWdCvOFBfMS
	 /kz1xnqJcYF3SJlVkpmz23quE5uSpoEdqlo8VYi2nCZOI6nRVaRzWHluDQL2OPQATsxdY
	 h3h/sWK6atyYy3qcyPez+1RJjfVul+D/DKimv9Ph1IOKDHkG4jZ3QxTwkLoLsP/3I6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Um4cZyH+;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XxV0bB1a;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24CD606A32D
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 13:20:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C24CD606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Um4cZyH+;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XxV0bB1a
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC93xEp2514179
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 13:20:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Ud1KwhBJxzUmwkiA/rZSRN
	zFDb2bfZAFAs5A7HMP8WM=; b=Um4cZyH+RcAapiMx6tk9QyN4VzQ3CLV9uH1s5e
	q6OoZhun2/r+Nzu42OuwmUyH3sRAsD0siB6rlUhBJ+OKZ+sFqgGVuwZsOHYi5hDt
	X13+Yj1O1RShqE9NWE2mEKEwBDvB0ObUp3pBgMoSJDpO2pxIEUU5dymWvxHSWKky
	q4iXejZj2SkCbJWRXXDzCFuPriPgS+H8QIKcy0+95NauLnDr82Eu8VzDxqxJphQk
	2UXC2BOBCGPdoyOy6MXKbXyg99t71MdEAkGUeV8g8Ef1eWFu1+dHw1E6zlruGQTk
	DUMgT+JVVw2B+dVXXYiDhoqyDdJr3vd50j6C03BHyFnaKHlA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvwm1uqa9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 13:20:17 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-944101e6367so161581085a.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 05:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794489617; x=1795094417; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ud1KwhBJxzUmwkiA/rZSRNzFDb2bfZAFAs5A7HMP8WM=;
        b=XxV0bB1aEKrEx6Zxs4rrU3VaIIv3TYtFRBbCPLy4LtAebNlTxWTW/XO+OvePu8y76L
         JifCYtG5MpQgwQ13uIE7nIfuYRiwf+QZsyYSb2DNqOJ2kksXs2HS0KoHqaGhvDxlzkVt
         nWvOxc7GNRiDclmekbUh9Fr7Qe4FO39smOGiC7nsabU+2H5YhlZs6JWyFAsGDSpQhFRA
         JTwoZdp7iXDJIFgC01j4pGK5mha4NH7TQt+R5yknAqlqaXjgH3waxUUTw+845KQdobbp
         Px9wmJMonrYx/NiMa5dQeCj7xVpCuHV60sagA1wS5ZtmihESvjqBtGDIHP2oOzgrAbpQ
         p/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794489617; x=1795094417;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ud1KwhBJxzUmwkiA/rZSRNzFDb2bfZAFAs5A7HMP8WM=;
        b=JGXS9vxWCvdYP+QENSV0ZfQibLUSj4BH19tqJgrXs22cy5nQfTxx2C+xigvRpFSSZB
         yQHFX0gZxwV+LonmASyFJIuSnhGtj6MGi2FWH3Twxv7TaKPki457QjfQI9Xf9VNTqtx9
         Ji/E5hY42z+IcjoKQjCWQ+wFjwq4EJ6bZXx7iBDNkC4896e8+yDPva95+NbCfE+H7mmO
         cR8xBIyrfb2h5fJGB+G4iV2PeKqJcP5KKqNo87GgMxqH5GUGugxDdJGiv/ypfL32ap8A
         NMNQA7vUpMUH6CPHAVMQhs2VD8LPCVaqtqhW1I0WBnRCI2DmBdYB/Rfl2wPHuoixjDEJ
         htdg==
X-Gm-Message-State: APuU4Z8LffN+PGWm6VNwBB51MlrsL1oPE4JAyTGzSRZZoygCiG6eDvvC
	K39Hz9Tqh5Dwd76KD9b1nBhsIiSWZHZXXtIFBylQEm6kZZfrdv/LKs+9UX1AcOmsklAhULuXKq0
	h3cvV+uKBwRWmEsbaZEcCFPBQ6vnXEGcPeV7MyqJXV8vlAgyTGJVNWW/nwsiuFFIo2vk=
X-Gm-Gg: AYBFou2dhkMikDfGjXfyyx+M96+sBPXlXY7UlvbzjYdG+Piy2K341QwNNy/p/r5pf/g
	xSWGqCIcZt3ry1JSs5jT/TYEADDru5h+ug90jsdIFY0rFYdQpc+ZiDiI6wVNNCtcxm0tPV3NED8
	pJvmhrp5GM5/W6Ath7//gXLnnam6yO6Kni/ILi2wmRm+/rUOK2RoV3Hc8Z+apXdKICvLRHVj0us
	iFAMzbtoUBXSt4P0igKhvkr5g05F7OhUGNq86mSBB1ysxlP4LtRpRAq0nwlILUcBvop2pKjtb/p
	N4xn9bi8x3k/pLs2UDpn4WLMMk/ZUXrN7EKL5+dATeoUTm9XTmMqln7p7JSPwiVXFzf0aj7ff/h
	pFGXfr0mjTtSdNCEGfcntGGYBB1EqX4mCDsSXDJ1mr5KIBgNf82fvFHbMBnMV9UX4RPeBmxt2g8
	+LJAERjBGAMR1DdA5d2jSztsJPBzmYz/NRMoC9MTozVOJk7F7ugzGZXCA0K/As+KA=
X-Received: by 2002:a05:620a:bca:b0:93a:1196:ce5 with SMTP id af79cd13be357-9493310729dmr464012285a.33.1794489616868;
        Thu, 12 Nov 2026 05:20:16 -0800 (PST)
X-Received: by 2002:a05:620a:bca:b0:93a:1196:ce5 with SMTP id af79cd13be357-9493310729dmr464006685a.33.1794489616340;
        Thu, 12 Nov 2026 05:20:16 -0800 (PST)
Received: from brgl-qcom.local (2a01cb1d00dc7e0089167b9b97a26c96.ipv6.abo.wanadoo.fr. [2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498369a495csm16744366f8f.55.2026.11.12.05.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 05:20:11 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH v12 0/2] crypto - qce: make algos optional and remove the
 BROKEN label
Date: Thu, 12 Nov 2026 14:20:07 +0100
Message-Id: <20261112-qce-fixes-broken-label-v12-0-7b5b9c7083ed@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIAAe99WoC/4WNzQqDMBCEX0Vy7kp+RLCnvkfxEOOmhqqpWZUW8
 d27tYceexmYjxm+TRCmgCTO2SYSroFCHLkofcqE6+x4QwgtA6GlLpXUGiaH4MMTCZoU7zhCbxv
 sAUtrfVXqwmMl+PxIeKz4e62/PeG0sGD+wS7QHNPrsK9KffBfEe9AgmyNcabwrXTmEonyabG9i
 8OQc4h63/c3Ic5wodsAAAA=
X-Change-ID: 20261022-qce-fixes-broken-label-e6aaf9624fe9
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
        Birk Skyum <birk.skyum@pm.me>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4173;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=EwDtYv9Buv4+7yibwtqLU5DD3WUd5mC4sm0SNiT2HWg=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq9b0JnqM5wAUYNu2WkHJPkueCqCZKKegCm4TiV
 W6zS6UcNbyJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCavW9CQAKCRAFnS7L/zaE
 w3ZuD/4ht7rcv0iLK0QTLYcxmUGqmxhJXY9EYDH/fNilZxyaRCgNFYHRFVxO4K4IsEDJZqgioei
 R+qc4Bbd0Yq4IKEeFWpKgtTQfxwQKgJM5wXB/RqXUgEkyo8RBZgdDIxOroehAxEcLySlsE5qedf
 CL0XUdu1AYg9eF1VUMXcdRrV2GMG2mrOvSPUD2K7bw/YvJQUodnQMd5nKwZHUF5hPljq86nzGNu
 +exO0BExbOkKWij1351zihPY1licNMnBVOnVD1iSmQsvbHCA2qoBVtAz9q+sgoXwxnwFTLQxK0R
 ATNOvG/adpkO7ToRNCHTCVzjMoTRR/DLpXTqP2IHwiETIiGeLGbHWAtAqUHh0sYG+2Coz7DZNQ6
 zntWc7Y0Bl3RiqKuVAbIm5UD7kd9+PP1AcYHveTiZiYu9ENRDq/7QkpQt0xrSncPODtTJ/bwFSI
 B4n0jaJGeL4dzFf7DbHYcLdJQXaK1nHkr2ayPInBfGpGqpm3GDKy8iKcLTWfu8lJFbNdJm0LwM7
 v1MHkXe9gZFz7rMzXAPt10/GCSTd5n4ZUijLlINCpQBLWpBtnIE+6rHBLCMm61exxG9eve5ON62
 N2Thobas0cdhj5gvQzfgLEJJqPct9kudBc2Y95siP6AJDioB4brD2lBO+3tI0obTNNpiqpx8G9t
 QREFz4PwpyNXc1A==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=KsnYSmWN c=1 sm=1 tr=0 ts=6af5bd11 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=RPm8042193-LcWM-IooA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: JFY9sU_1G2_VnmvCqx0AFuZrEc-TiPxF
X-Proofpoint-ORIG-GUID: JFY9sU_1G2_VnmvCqx0AFuZrEc-TiPxF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA1MyBTYWx0ZWRfX334SOU+6f+GC
 i+XcChfNXBnIG6M8osv24UwpRgo198cklzQiFOI1nL/+7IOZIV1zoHA6cwvwh/kRfiYXQt5+uiA
 83Dd9CZ/hNj2pEb7ELz0MTUw0U0L6Icwws4+y3cWBS4LfZ6nHAaLGVk9FSCNLsqvdO8g1xhGxg9
 NRsE+iSBJkQ5uVt37Gx6ggBTjsE70K/KqEBrJFiMh8tyHoXG/AsW6k3Uviyib6j1ol7fhYFFMEW
 3/w9CYetskc85hJPRsctgxXr9uzpPMb2H7GZFf3X8/5f5cpnOkLKqd9svVVhFdF+KUR1dJPa137
 9dsiNVdhL8VJhNPJaxBZ7Sq8ZRcmZ6ATubii1e4Js5x0Js1sHvUfhKxx3lwjJbk3gxpdsdH3EQs
 /cKKhNAtj9U3hlzSh12xJVPn+uhWDOgQDAeSIKUQrkn/pO1ytPqyRR1Wx6z4R2fIMogJdn3UUxF
 12DV3PUJQ7CQ5KLkZWA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA1MyBTYWx0ZWRfXwY00wPW2Qnfu
 2hSIPuGa1zzSIpPYBmMiOdJn1onkH8cG7FoYrTaBPYdOhGMEJLWOmZug6hWjeyVYtxiWh1AWk/B
 vvHIulHpvRCKfLjUifPw8Akg3qps3yo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611120053

This is the follow-up to the three smaller series fixing crypto
self-tests in the QCE driver. It makes the crypto algorithms opt-in via
a module parameter and removes the BROKEN label so that the driver is
built by default.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
Changes in v12:
- Add module description in patch 1/2
- Drop dependencies from the series as they're all in linux-next now
- Link to v11: https://patch.msgid.link/20261022-qce-fixes-broken-label-v11-0-0d33c34fd0c3@oss.qualcomm.com

Changes in v11:
- Split out the patches making algorithms optional and removing the
  BROKEN Kconfig label into their own series
- Link to v10: https://patch.msgid.link/20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com

Changes in v10:
- don't pass a NULL buffer to sg_init_one()
- fix byte order of the imported hash state on empty finalization
- don't recompute the CTR counter in software for every request
- reject skcipher requests with a too short scatterlist
- check fragmentation for empty CCM decryption requests too
- don't use a static loop iterator (duh...)
- initialize the return value in qce_handle_queue()
- Link to v9: https://patch.msgid.link/20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com

Changes in v9:
- Rebase on top of cryptodev/master
- Rephrase Kconfig help text changes
- Link to v8: https://patch.msgid.link/20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com

Changes in v8:
- Add a patch making the crypto driver *not* register algos by default
  but only if the user explicitly requests it with the provided module
  parameter
- Use the "offloader" name for the crypto IP instead of "accelerator"
- Fix device module table issues
- Make the core driver use a list (despite it only having a single
  member now) of child auxiliary devices to register to make it clear we
  have the intention of extending this once we start the work on secure
  media playback
- Link to v7: https://patch.msgid.link/20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com

Changes in v7:
- Add follow-up changes converting the QCE crypto driver to auxiliary
  bus, adding the core QCE driver under drivers/soc/ registering the
  auxiliary device and removing the BROKEN Kconfig label
- Link to v6: https://patch.msgid.link/20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com

Changes in v6:
- Handle all zero-length HMAC finalizations (like imported state with
  data already hashed), not only the genuinely empty message case
- Add an additional patch addressing the fragmented skcipher payload
  issue
- Link to v5: https://patch.msgid.link/20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com

Changes in v5:
- Dropped patch 1/8 that's already queued
- Use the pre-allocated fallback ahash for HMAC transforms (Herbert)
- Link to v4: https://patch.msgid.link/20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com

Changes in v4:
- Remove remaining ECB and DES3 bits
- Pick up tags
- Link to v3: https://patch.msgid.link/20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com

Changes in v3:
- Remove even more algorithms and dead code in patch 1/8
- Link to v2: https://patch.msgid.link/20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com

Changes in v2:
- Add fixes for the full suite of crypto self-tests
- Add Fixes and Cc tags
- Link to v1: https://patch.msgid.link/20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com/

---
Bartosz Golaszewski (2):
      crypto: qce - Only register algos if the user really wants it
      Revert "crypto: qce - Mark QCE as BROKEN"

 arch/arm/configs/multi_v7_defconfig |  1 +
 arch/arm64/configs/defconfig        |  1 +
 drivers/crypto/Kconfig              | 22 +++++++++++++---------
 drivers/crypto/qce/core.c           | 13 ++++++++++---
 4 files changed, 25 insertions(+), 12 deletions(-)
---
base-commit: aaa2f954c21b205a0bcd0961e5b2be4e82e58455
change-id: 20261022-qce-fixes-broken-label-e6aaf9624fe9

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

