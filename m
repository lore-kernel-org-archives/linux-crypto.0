Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795203325;
	b=WGXcuBHNo3AA6B/dZHp5zKq9xD2fBk0KqY7XHwwKTXkQtpYF3jtLK3TlAz+8b0mffMBV
	 ChobFxqS/ZlnyFNj+jg/kaSk25fA5mYfPsTWrHLldg7OJz8kreAxzKxmi9EoesDI1Js1+
	 QGRjQzUxXS1L3WfTDqRxqEEWAhY76zKpSfZ4HYdd8bbHiJZ0gOdYIk9FEHWG3/VmwKI0+
	 LhukUscm75MAh+U+moeD863GhEf5ZPEv6OL6ijvqG/9LQYqPXyt8sWPHjWIJfW5h5RLiO
	 oCewXresTz0EnqnrpHbAWnwFEhWMf0bngXy6PR7JBRe+XhFlGdQpgd0ZKIM1ajTdNHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795203325;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=41CfvWilGEXnA95p4GfArJCQxJtfnNTP1owROe/U+kg=;
	b=pMwdUOTKCq/VQxktkrYwpQo1PkqaJOFeixMdAZt3nRUrVL8JrMmLjreoL2NsoOCd4PUr
	 C5fmW6mdSIESesz6XFhhAKXeW0Fk+FcETla+2oj+E3gpJAi6Pp2y83VuBKKcx2cSLvnu+
	 T8KqjbEEgDgs7cGE+zESP+lXKro6uGO4QFAB/ENy2UgNvedXgGaOp/LsEHjyzuiAvQR3i
	 QeaeFjQd3qbc/XJV9YNNjf3E636ald8nLuwJSIjlw6IOOLVLb8enOrbPM6XV9m0oY8CHO
	 nMbk/KSVg2jT9oVu1ms+9Oqtw7r0Q8C5pgKlaDoLwcPKoY4rUvihAwizPP9qo+IBzXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ZGCQrKt4;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JGiyszoh;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1DA60A261D
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:35:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA1DA60A261D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ZGCQrKt4;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=JGiyszoh
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKI1lCg1507286
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:35:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	41CfvWilGEXnA95p4GfArJCQxJtfnNTP1owROe/U+kg=; b=ZGCQrKt4/uDsOq/M
	Vh5HlJGRDrVRvRCUjnew32SQ+6unuKLVLWVCbzNU2vQPxZL9Wm5rppBZcTYj4kAw
	pWEA55PcMtn4a/YXSD795fEqNHeA7an3iPnHOnMRKn6bkGrHZZ84HKRc8Ym2Pgyi
	wzgdka2FkqmXSFmUghHJTdnSxWFHiFO/AnOiQUUAg0gZYASxiqcrAyZS11hr5UgQ
	J4uOMEPopbBPeobs+5kJU36PC8r11QztOI7yoQqgOQ0DE2O4fbLLBTeADN5frTl+
	uLMJGN/JenDwGsuAqLqynsvJgXKNnmq6lZDBNkmsrrAHWT1lD2z7qcBtB0sciOST
	hIH2VA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j2u4frd75-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:35:14 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-949b0d322fbso191578185a.3
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795203313; x=1795808113; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=41CfvWilGEXnA95p4GfArJCQxJtfnNTP1owROe/U+kg=;
        b=JGiyszohZM1xaaC4b1ExSiKsSsXAFefRwSSth91DSBCZQTSS1EnR2AUyLQNYgs+CbB
         CfaUO9baTSVA7nBn/CocWR+IxujukyoqkRGQ8e64yI52l1LSsFYrYwzFRGd7CU85llsX
         JGu1UfSj+NvxfJLiihIkszI8CzfopMKSJV/NVb4mOzfC4DUUrfjlY9kTDDkVUnUsLLG8
         XPDPYH8GW51I3Fi2FSelCH405KSVUSOQdc/eX89lN7/uwqjtZvxJI3lJlfNT/0DVHI6h
         YkLHETC1sWqCd2EsZytVdofDr2wy6O8OlPCxdvA63PHbcdCTLmxjToXdZ3sO5gBKx9n9
         yBMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795203313; x=1795808113;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=41CfvWilGEXnA95p4GfArJCQxJtfnNTP1owROe/U+kg=;
        b=P1nKCjbd0p7GPs4NujRBLT07gE+LtPma8mfSqyGZchrnxgng6bIiL0KB0Prar9M1uJ
         Y3gpO138sH4ZLPe8bE/ay6KuvF9sThZ/BfsqznHEHwtpgzdZOKVgY26UHOWFioX2G6yp
         iyvFhCaD+mCYgnlHdT8mmJ1B7zyCX5ygAS+b/QzwP0OLW9SKjiXUjNTGvu9wiwX7jcbK
         sZzkA453lTH0vJoRNqf4mlkpg5S0tBvqhSuXHyspuenTwD/aQNQQ3UtSchBQR3B+aaRi
         LsmteLtebNeqGzlnHZWiDlMILKhrwry7HznbjnJhyxaSyXoLk6Oh0T/3HTMMHTjMVmud
         lFtw==
X-Gm-Message-State: APuU4Z+SH4X8PzRgxTouS1eMtZ+zPUviHHrSG+rKymro0MHhfTm0jScJ
	1jq3d+U91kTBvYXwDN3OcLx09YuA7MQ5OWe4nPKYyhyD1Q3rrkGhTBM9lTDImgvW7ed4dNRkxU3
	xNSFaZkvSt8OPCDvcLggCoL3rJrsbf2h/0Rw8y8y+EQiZgpuW/TnuHfbO8d6ZEMjkcOs=
X-Gm-Gg: AYBFou2tjJMfynqypfk/9HtpZMv4ZzeEO0P6ux5+NGJ9mX/XWCbeEVYIWWzFgIiQO/n
	nCa+ostG5At8ytPHfS4sDuHomesnC8nKQKxDQbGWf14rITE0RRWUHVBcYVV/mmdUe3nWTMGNpD4
	cHBjz/bnX/K5tPq63xPeQI6HdYABDQwDwb4tpPqPcOIgtmzO+5/4w1KJM9Yly3f4EPrpEcpE/G8
	2IUVG+GlpdL+bEdEYy+v16P5L2kAQSrgQii8gGaOZHvRH43+BifZ0U/iHwlVjwoLkZYd+57yatz
	IiQy5muI+2gc01EvqSuBa7N+zxkkY9Mt+AXNfuIRp+ZE0f18gWCqde6FocyUj4w9kXyr9bbknIL
	M9kuA/wnyId+BcB9n33LniC1HSURwLn88x5xJr0z8aGsr+pSVBzd+WXIv3NHkDGk3t2dkus16jw
	e8
X-Received: by 2002:a05:620a:1d0b:b0:949:75f1:e5fe with SMTP id af79cd13be357-949bab1719cmr629546685a.73.1795203313023;
        Fri, 20 Nov 2026 11:35:13 -0800 (PST)
X-Received: by 2002:a05:620a:1d0b:b0:949:75f1:e5fe with SMTP id af79cd13be357-949bab1719cmr629542985a.73.1795203312591;
        Fri, 20 Nov 2026 11:35:12 -0800 (PST)
Received: from brgl-qcom.local ([62.245.128.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf685asm6806343f8f.20.2026.11.20.11.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 11:35:11 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 20 Nov 2026 20:34:57 +0100
Subject: [PATCH v12 4/4] arm: multi_v7_defconfig: update the Qualcomm
 Crypto Engine entry
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
Message-Id: <20261120-qce-fix-self-tests-v12-4-b5a2a44bc5ae@oss.qualcomm.com>
References: <20261120-qce-fix-self-tests-v12-0-b5a2a44bc5ae@oss.qualcomm.com>
In-Reply-To: <20261120-qce-fix-self-tests-v12-0-b5a2a44bc5ae@oss.qualcomm.com>
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
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1408;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=n/kwYOMR7eAiWhZVvnFhVSRXRzZNHQxPDtK0VW9Na1w=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBrAKDl+exRoCxSgXKkfWo1bCLJugtHPQ5RgKsBU
 Be0CPNs2EaJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCawCg5QAKCRAFnS7L/zaE
 w5pjD/9xLwdHyFbKZWUgw/HnEyN/cyMIR6cnngISMQfyrYIhTxHVhyu7G3jbdFCXrvo6Xbo4fJU
 YNbpr5A0on48pvyNXpDWo9JtW8kUcLJWvksQlkKST+7effTOzMF0Ui6ZyLqRTtZQYHxa4R9RIAp
 8zkWigacXyIU8baZeQ9EWfWg/tCaPNuHAmM38ZDZPY0fLijH76Ea+ZzhUqH4JjEe+zSEnTwgmhw
 fhzUYzldccvlzzuDTDFikgoISQOivBNtqYxILxuSYoQGjZk+UNXaP55LqULEetHuEtziC5vpeAg
 Nl3LT+qNGq/Efm7F26E3x9LU6nxDZ+0tivj8NHlmJvLYArtSJmT8XauIt0w3EJGGV5zjgyKJF8A
 VwpPA0A/6CP8F9FZEqj6UVst3wRQzpupfJvH+I5FgRKbUNmDaqTVnkkBp7sgOewZdpJZmh5PKHr
 pD/BsJPYbK9ApWc02RcyBQxcscjs79IBp7dlCDkTxMYWvpUj7x4CjC2FE2LQ27bcZmDzQ2qkvFg
 zuGNW0fmCQpgXmQRslszqJqX8niFlPG+FKVYkr5Iio5Am/XA/cDBsBUUt0gixdI5y1ypgKZy7FA
 ugk6NAxVBKf9ifvl9Jb49tvQnxae6et7ze74GaKPUwpfsgrqHEPVjDi6hMaDdefQ4b8eJ1k3gNx
 tSOU5E6c4KWxi+Q==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=VJBIDNPX c=1 sm=1 tr=0 ts=6b00a0f2 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=y0NJeVxnVzJs6a3GlOz7RQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=5AW58fNYxLuDjIPvRSgA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: Se_wj6khxGu7LfU7Ca96yq-z7CW29Ag-
X-Proofpoint-ORIG-GUID: Se_wj6khxGu7LfU7Ca96yq-z7CW29Ag-
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA3NyBTYWx0ZWRfX764Avy+ZLZAf
 5AZu3O6mzUHUaiWUQu8/e3mGsLOCisl56+VwAL5/1kYRQ2Zo7YNT0avcuU/0WbmSWsiheiJbNPj
 GKZR4/uPAKxOq7lnFYswDzqxu6SCeNY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA3NyBTYWx0ZWRfXw01caH4/4lI4
 WeSKIIuzpxCqkZXD+qtnmuJgwe4Yx3ledVf33xSVWp1MT0qVM+JjE9t2S+vJqaZDr0bmDCtQYw2
 lIIxfZkE4avKSoGdvXsTLWHDKESLzVwPPzLpcfUXHzotX4/26RHxryvwdSNdqJv7qdZfm9xPgFP
 EhzHYQBaAzPuMAPkNzNn4Bcep4hor0QGVBOo6y0tJ5igKaPO2zGItqTaiZhvvAt/BFKWpFXcfUD
 7G3/myFLdnl5VJHgoP4y1cWztMsTj9HtX4nGN1V28UFrYdPa7PlHaZyDyqcC0EVRAYIuruiJzdp
 zyFhzNOs0+XVN3yNrzgkNUH+0+7d3v/73JnYpD+Ql9oTw48jNET64AKHRWmgLRSalooyxGuAbu7
 ZhgFvXe/nnPrZZES5TYU8R0BLKfjB9dsC7WtczhcIdge3FrURf4lIkNjboPVKy+9WQflrqXW41G
 5eg/DaLtquwLTtvZQ7w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_05,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200077

Most Qualcomm SoCs contain the QCE hardware offloader. The crypto driver
for this IP is being split into a smaller core stub that doesn't register
the crypto algorithms on its own AND an auxiliary driver than handles
the crypto part. Update the arm v7 defconfig to only build the core part
by default and leave the choice of building the crypto part to the user.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 arch/arm/configs/multi_v7_defconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index c54bd79c30701ebe59c0e6ef3b43309926154bb3..2413ad6f4d4b02163ad880bd8ae0ca30b1aa7cbb 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -1135,6 +1135,7 @@ CONFIG_ASPEED_LPC_CTRL=m
 CONFIG_ASPEED_LPC_SNOOP=m
 CONFIG_ASPEED_P2A_CTRL=m
 CONFIG_QCOM_COMMAND_DB=m
+CONFIG_QCOM_CRYPTO_CORE=m
 CONFIG_ROCKCHIP_IODOMAIN=y
 CONFIG_SOC_TI=y
 CONFIG_KEYSTONE_NAVIGATOR_QMSS=y
@@ -1306,7 +1307,6 @@ CONFIG_CRYPTO_DEV_ATMEL_AES=m
 CONFIG_CRYPTO_DEV_ATMEL_TDES=m
 CONFIG_CRYPTO_DEV_ATMEL_SHA=m
 CONFIG_CRYPTO_DEV_MARVELL_CESA=m
-CONFIG_CRYPTO_DEV_QCE=m
 CONFIG_CRYPTO_DEV_ROCKCHIP=m
 CONFIG_CRYPTO_DEV_STM32_HASH=m
 CONFIG_CRYPTO_DEV_STM32_CRYP=m

-- 
2.47.3

