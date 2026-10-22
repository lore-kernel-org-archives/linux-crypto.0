Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792659494;
	b=MX8HvTTTWxG6onRy65PYfmWl+XI13ZKboYggYaZJTVwgY/8qNpurohLQ1MVlnasGGWwL
	 DUYRzeBqYRiyYaO3FmDJg13F5ni3QIqeVPJCRbXCBecb1IIEX1C7jQnZNAeQWX7LZv2ik
	 2QrzPgLLP2pw4OcO+IUw16FGeeCplioS2BIUkZWungjXRA+oyWpQbTgCtFxQej53+l8Sa
	 hwfYtekugREA7IuKZZi5n1OwEOzVuORPWsPJCKiv++lRHnfjmGfjp9ondy/ofi6yeNLjc
	 uQB3PgPwt3aZxcJO7JmD12DfJD6na6Zj6gYL/25AkrAEK1dDmX75/dfh4fxAv98BE7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792659494;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=QO527nYtTVDs90AOOrllvHVE3JmeqiYYasfYAtNl0pA=;
	b=EzaBOQym58FrRB2XWVxaNY8aCYmOHpq9k/JZT5tHS08mCYRmasbktKcBwc3vpCOogIvt
	 EHHvSbLB1wMk9ofgvC1WyAzRlhWjXa0Z3oAuWmrL98cuPHIeMc6koWwOn/O7Qau0Xurgw
	 llf520Zb/nT2csr5Yx+3gqNidC4pg2pOSuAICV+kqShfSzpW08muNIUd44Pu01duaIIs6
	 ihbAmJ3CTRi/CFmYc5BK6GI00vDvUha4geNS2oTG+x92NJWyvFFdYiClWexiUjkU9EF7l
	 vUyuSTJdvgbfdxe/8CFohBFfOwoHuV457to+gOJNkrT4JCeGg+kTkO2+xlOltE7G8Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OU2u0yMc;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XZJtDvPz;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CDD606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 08:58:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14CDD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OU2u0yMc;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=XZJtDvPz
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M7088m3517480
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 08:58:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=QO527nYtTVDs90AOOrllvH
	VE3JmeqiYYasfYAtNl0pA=; b=OU2u0yMcCjXeVr2aEGKLhp0GG9aqjJVIIykiyB
	268zsJMc4AOwDkgLypGfRIeLJsgBKna5yk6GwDPHTj4IHY0pTBmeUqMaV/8ykn1E
	nnhvj7+mhfb2cd1QqYZ6iVYfytN26RwqfhreReiK8u8+daj9nGWem3BMF/4hKVKC
	o9xm3wUsM3qh4BCICNkWEpaffCLturelqpHKNefmyNi1bJ9QOSrqFdkKvJHWlIpL
	CvyV9qY0VLiSTuMIWt2byRg9XrXcYddEX00OPop72W6DiKQJ+mEnb+k+KCrMNxSa
	AWxABMpl8xFfjkFM+Bz1d18L01aTxt24K4vIhD4jeyb6G8gg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93bhhka-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 08:58:12 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93cb93c874bso131950285a.0
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 01:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792659492; x=1793264292; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QO527nYtTVDs90AOOrllvHVE3JmeqiYYasfYAtNl0pA=;
        b=XZJtDvPzYzdVoujf/4Q0UREwX2RComHAt056FtoDn3zSy4YvcWeDps4HixvQyLN8uT
         q+ZhtaMhuHpCpyKaiEaY5GvNWPsG1ST9O1BKHFMhSk1I2aLpVReryXFtXBzfPCbBJag/
         ++GxV8gipNmBBeNArqkvU6FaeccVqzkyXJAr8JJrSq8Bd5vH+oUAzPbh+58DQJZRGOnU
         44V7Xo4K8ZyP7601r44iqzA0xLxCi/ABI+KQiU5wy9msd/XfBRdw6cxdvzD0QDzFCbwg
         u62RN3eK8IwJZYJRDLP8jqz0UNUmekztvNLLmXNqhtivjHplaGRbC87l2txkixvitN9k
         S9Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792659492; x=1793264292;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QO527nYtTVDs90AOOrllvHVE3JmeqiYYasfYAtNl0pA=;
        b=wao0/1M1lD1ACx7PsUoN8eBxkmxlSFaBzOtnaodL4HevXPDDFEfNW+lNJDb9eaeCXP
         +AmtGZkZjD7WCRBxcTqcktLC0ObWZIS5+k8l3lMQeDGFy0CDe4349eMl6UEHADLldmu9
         0KJkKBu5Lauzofm7SiRty2AMl2LJJ2i+53HGGzxoNZ522q2vZ+CqhKIpHzr8Nl6+EWxk
         bsaIif2GAHRP2P5Qmw6qEjyx2NEWHKuIJFx+dgZnhkQtG9gaVI2bnyacQ6dYiFiH6tdN
         SfcQ+3BtGCvWdquMK69ODkjyXndn1uSkRy/j8IVPAIUg5H4piHIEu0RLKjZkmI0OZ8IT
         dAgQ==
X-Gm-Message-State: AFq9FYLMLCN1nObiOkpp7kXmCcnijD0mJaHlJHsvY7H5Yzb2Z/V7AZtR
	QBn6sZDLNCwd1OGhhrCn7Tz31WVF4CUQGiMrGLc7ZOS6/tSi9nn1ZCFmaXNB6kZ6WNW+ToP4/Og
	hXuEUOedIUpD2c3ZqTSCmNOqAX825alHOkDOiD9gCFIEB8VBjPyQiR4OoHiDMxNfFuBE=
X-Gm-Gg: AYBFou0MElxHgp7BFWkSzJ4EQcjDQ+wUYgyeqdXVT9nBjYdasPUAGQ06St6awMZBXu0
	erjXoeRFcTDHJge7SN/TRtFJ8m+5MtsEShcFamYymdHzrde7ClziW39iHWNJi6ySoZ4QS4KJeM0
	6lP4mjst67nxSumTrVI6M4IDoULfcVru9x6c6uVupOsRwgSCH3P49jC2yHNmOwURuVj32IJUWo6
	X2EvYCEy7qhdFkyzfYDC/PUnVN8P0oHTkSCWzI8MJS3xTEFzc6Oe0Evp7ptu76SPJvGwrnsXrWy
	69D5t8WWusjNOMIH9nwtjrwzKDevwJGFI4UVcLjPu2ZYipTQxas77g7YhPFu0OiFanX4hinhiUX
	ur8ECi6xRKgL7UPezuygiZN7u28nv
X-Received: by 2002:a05:620a:1a26:b0:93c:6e1d:96b0 with SMTP id af79cd13be357-93f62720fabmr279112485a.17.1792659492352;
        Thu, 22 Oct 2026 01:58:12 -0700 (PDT)
X-Received: by 2002:a05:620a:1a26:b0:93c:6e1d:96b0 with SMTP id af79cd13be357-93f62720fabmr279110985a.17.1792659491909;
        Thu, 22 Oct 2026 01:58:11 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a203b28f70sm61625525e9.4.2026.10.22.01.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 01:58:10 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH v11 0/2] crypto - qce: make algos optional and remove the
 BROKEN label
Date: Thu, 22 Oct 2026 10:57:58 +0200
Message-Id: <20261022-qce-fixes-broken-label-v11-0-0d33c34fd0c3@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIABbQ2WoC/42OzWrDMBCEX8Xo3A2SLMt2KKXvUXJYybu1iH9iK
 QmFkHevEvfgQwu9LMyw883cRKIYKIl9cRORriGFecpCqZdC+B6nT4LQZUNoqa2SWsPiCTh8UQI
 X5yNNMKCjAcgicmu1YWpFDp8iPb9y9uOw6kjLJRecV1M4TAR+HsdwzoV1g8zGs9GVK9lXilm2v
 qoVo3LsvCLXEJoHeqSU8DlsX7yuu5Td7Eo9wlWBgpKowlJ2jeHyfU5pt1xweDTu8nn7C9VuUUc
 fTj3FzNMgQRpL1lHruub/QC03QCTsfmB1jZpki66T/hfY4X7/BuLcpP+eAQAA
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
        stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5024;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=SNlakgImLlcbw4lKkLUFxbVJiRFZnmaVXphjRpLOsbI=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq2dAe2pJqVxkEm4b2mWoDo1IKaJf9K1BrMJhNQ
 1kyGvBGXtOJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCatnQHgAKCRAFnS7L/zaE
 w6+wD/9Nd2W47YsN2c1SSQoz/R+eOj3lGaQahRTEn8V1hk7nF2HMnLHMD68je3vNQ+M1rNvH3ty
 YWBpygNlaxtuDszgYjWEIq3qi30pARHQJYWlssCa0gV62LlXyIx4zeELh+z3yAVee0P2sdxmWvh
 yckABv43A0Y0XV7JzhHjJGCXrTVbpE0/LAJ4gOXk/XpAqH9IQw95Bv1YVSWwD9h9P5J13RaaP/x
 0vIo1FKnPxIkYQKappjJwzldZcAuW4KbDYum1CQ16lux09p/dWfZXQMNB/KmTusv9iejdSb8T9n
 Fo6nE6gkDWxDHcaCVWyzLS3ZZESgkcdSxF3tkfilVAADaICYWHwUqgeS97/MeXy1PcJN1y7cfnr
 fjsye0kok0iKIHSHaHjSAlQAPHiwk4HJinm9gKHGjLCDSsiCwIfuJn3GwXPxKjmU38tJEzOR7IV
 zoiWke8blR7SpUp9D3C3iHrRUtNGTvgChaC/x+Bp6AmDp19uuzb1mLa59Sm0GySXw3TFuFXhECi
 IT/t6JG3sO2za+cAN8mJOQPBligwHuKPkDudwTa+RVMtLf0IAmf8XKmqrO7RTLyGh9FHJw/KtAR
 p0FwukgUlgqkpEr6XWRXj95twhM2CTZ4h0eNCJBHv2943UzvwX6Go9ZFWG9kU1DBzR+y82TTiPV
 hlkvdt0QngffRdQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAzNSBTYWx0ZWRfX2Jwyf4RZ73yb
 smuZl1Sd6vGjXPIikcUqxjtg50Bytsa4PkZrVo7odvhrdnWogMQ8zH1VVk/UcwffcpuwCw3sLhi
 fmBG1STlvgaMOouHU60IhawxFmM/rCI0yE68535C48MOoHqxZWLSgG8b9IYNh2sewn4+z2H1Oc1
 UHmzu6TMI6H/QJ4TXIz1e+Cud8asO9XalD3k9YyRiSju+QIsOpCKpR9xStwxFlMqsclYU+MrOXg
 2XPQN/sft/gJdKCoBDGXXruHPx4KyHXLNP6MnWjTX7koUNiwWo9s5+pb1zEidfgpVkqqaTjxmKt
 rspdKuG88S6PXEozhgRkLIzzMRnWMayIMQufQPNXKhmaeWfXslwSbm9r/nbEsM3O+16kT/ZRRDC
 u/9m1nPOy7oCIM+WsQm2GtlgL9UBPgxQoCuoBeUXp451+DCMZlmhj95bQNs/E8Gd1AZg7EyHyay
 FnprlxQRGwcPRpiP9DQ==
X-Proofpoint-GUID: LMybL_-rMzLOJDxpt4zPUMDBEvNygUXE
X-Proofpoint-ORIG-GUID: LMybL_-rMzLOJDxpt4zPUMDBEvNygUXE
X-Authority-Analysis: v=2.4 cv=CMy/zhrD c=1 sm=1 tr=0 ts=6ad9d025 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=bC-a23v3AAAA:8 a=9V_34UpJrwX9EJPKeM4A:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAzNSBTYWx0ZWRfXz/KsoklLEX3m
 Fc7Ta+swJGYhCR24PDi3r/dY5HzsIgCCv0BMqn958ft0Re9/IfH5LuyRoyYN5znQSgNng9fzaFO
 qlIAlAaZrFWUkEs8nxvdrVY2QuF4mts=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220035

This is the follow-up to the three smaller series fixing crypto
self-tests in the QCE driver. It makes the crypto algorithms opt-in via
a module parameter and removes the BROKEN label so that the driver is
built by default.

The dependencies are:
- https://lore.kernel.org/all/20261016-qce-fixes-sha-v1-1-3ee5a30d84f3@oss.qualcomm.com/
- https://lore.kernel.org/all/20261019-qce-fixes-skcipher-v12-0-046e6be9bd83@oss.qualcomm.com/
- https://lore.kernel.org/all/20261020-qce-fixes-aead-v12-0-77a2e09abd0c@oss.qualcomm.com/

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
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
 drivers/crypto/qce/core.c           | 12 +++++++++---
 4 files changed, 24 insertions(+), 12 deletions(-)
---
base-commit: 178aff4cf425b3fc51ff09c571fa1bfbc1eb8ea4
change-id: 20261022-qce-fixes-broken-label-e6aaf9624fe9
prerequisite-message-id: <20261016-qce-fixes-sha-v1-1-3ee5a30d84f3@oss.qualcomm.com>
prerequisite-patch-id: 7c93b8489dbf6d4edf932389c4c931d897f38ec2
prerequisite-message-id: <20261019-qce-fixes-skcipher-v12-0-046e6be9bd83@oss.qualcomm.com>
prerequisite-patch-id: d3f97f2fcbc99093e51f4b749eda4c2d0cff4e92
prerequisite-patch-id: 7c4695a73eaad5db182edb09a608c6bc51883c82
prerequisite-patch-id: f3743392de54aa4ce3da76d11637dfeedb922b3a
prerequisite-patch-id: 02e9caf718743f7860aa19031e6809bdd718878e
prerequisite-message-id: <20261020-qce-fixes-aead-v12-0-77a2e09abd0c@oss.qualcomm.com>
prerequisite-patch-id: 4764101927c437b38d71379f95b98c82a20a48ca
prerequisite-patch-id: e918a7b007c3a1b88b526fdf7865b811155deceb
prerequisite-patch-id: 8aba9f114cc43e24c8568caf5ca4e7bb82e54b67

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

