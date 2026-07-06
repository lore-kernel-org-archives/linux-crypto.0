Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB792370AE9
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 13:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783346070; cv=none; b=JZtXJ4GyBL0bnTAsAYFZUkqD3I3sSgAouFjyjyC+sqKsFQmaoWLyvuaNVKz9dhGi4u9n5PhV898178CvYNbGmcz4odaai80xp7ehdHXkZClKZLQREVoH5Sox3TL5JWtcMaMSSN9KyI7gtByqjQSH7pdGACWnyptBN2kIJq9o3ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783346070; c=relaxed/simple;
	bh=Ejq3GCF3ALDtojefcexMkYFTMI2wVEXKIrBlhj81Swc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OUlcJVfpeMjgLHkmz8jSuDOQAxS3mfxS22oZfkxN531CWN7CxIZDbz3jAhzUdFhQgsCoP1ufN8l5ndLCNQ+MfBGtxE92GHHC44Ldb/lYkH/UPdGP5+rQIl3Fa4VAB2FXcLyQURYtc7JhQ1AT95AgG+AiMF/3plII3xJMCG68BK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lFI0PthK; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WiwlPZER; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lFI0PthK";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WiwlPZER"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666AxF1F387079
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2026 13:54:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EagaE396zMSCowVPFT/Lv2P0BLvUgaUxoxYWM76TMv4=; b=lFI0PthKJCdQx+wp
	AhZosW4s1BveSYqqVtQgfHJTKGU16xzv0Apyg4xr3zlBIehRtDOJOJ66Qq4kUSJH
	b4u9gzoSHy8JXrx0cASxlGvS2gaGWqE07SYF3nLrXXxYeUz0XtRYWJQgXJmsOi1e
	2yIJp9KW21JwNOpgKD+5dD9HNULbmy+9gTzTwDiXNgjQZUPVvThCYccwIrinoLiu
	fl26r72/BWHY4OL5K8OS0DhselwV+FVvkdfQ246zPl+oBYgYqwxUSGhkQvRVQpGW
	QuzlRGlTYAdm3mZM3+oj8xB/QTNu3WRnNqGWl2CUV5mO5nACBLknDhICDMQ94GY3
	eLra/g==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f8a3r0wyf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 13:54:26 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e63df032bso336007685a.0
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 06:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783346065; x=1783950865; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EagaE396zMSCowVPFT/Lv2P0BLvUgaUxoxYWM76TMv4=;
        b=WiwlPZERPL2NkMG6ZVqxmw0Cf07+yDsx9nE0rlV0RZGAMXIXr+8ZjEukJeg9Ya10KO
         jNetl7aX1IjtGfUJn11UJS23+m6cXph+eNR+taJkDbcuJRHPgT2DQnLYnLOhqNzqNpfU
         K0SHZn1nORV0VnUfkS2wPOvB3N5PKwmE4EIWQ3mQU7Pr5dEPSIToFRs/thK5UREISTyD
         8meCg8pb1kUy4ZG+DEMCU2sZZfjeITKEGAmDFgL3KMxRnlgjY5XDIh/QhMuh2+IgFeN3
         RfCOIeSDOfNfzdE8aTVBMzNBboXc4DolGSGoQSDg/iwqr0/jvSzZZ+/Lnt6UlgCu6Rwk
         nVLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783346065; x=1783950865;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EagaE396zMSCowVPFT/Lv2P0BLvUgaUxoxYWM76TMv4=;
        b=XFc4u72dabqZ6fOQy6k24oszyb4cUU6MgDXJcTmashKFXBY+5zHKQWVlT636LJw3bV
         Ul3r/RqHLWLmNxwziJMrb5QNcA2WiJ8HVNYf3TkJN23Duko+ODhidjJVjJBVInn66gpR
         WqZGBFnMRarlBg9uSyBywm1JOE7FdXqZS4D1DMt2ZYlhPkv3+GSzLcj7s9gSAgNyzSde
         9dX9hvQCiiwzySuJPzuKhun/X6bawv/il1KwCSE3+BidWae3XxNa4uniU+WbRt/M4fed
         mqF2Dun656u6HC/j9xNUrHbBwNBK4TZJlhaeCV1q3T1kmoxHVpFDwa5l5SfLcR5qwwgU
         mQDw==
X-Gm-Message-State: AOJu0YwTMoeznZ7cXnZPMPaMmgcgu02TP5m6ETosPIXfnw6HDtmuErfN
	icVsaLuRcDga3oVUv9tacETVrW69TJBCp+47o4xoY/s+BDtNrE8xkyl2RO/y/SFSk18YroBPHKS
	fkhgYAIiok2Sv9bdlcPEB9INvNbgupBIZzgCqES5DCjNp4iuv63wAw9lr2idK2CrgJKxxTVijzh
	k=
X-Gm-Gg: AfdE7clau0eGtE0ne38MIpaQktV5xGqkDzvp6U3LTAtYLzXPlSVObyrwe0tsA/1S7P5
	I9HGBXNz4ZJlvfcJCN7VmIPsnPtc80SKDMB4EKAn9+qR3wSN2KjxoyYHvfF0EiGyycnqxHK9vYd
	TFaYflp0Yy0sDbmiQvhYE5Cu15QNJrhLULwifrF8dQTo9/Pj83ai03f2t/bggBHLGSM6X8SlNfP
	h5hnC6iOL59MJ27JX0kjINM72l3nw0ghjLeCG1tFspvFclE/tVfzwcePA4CiA9mrBuMFN4fuoVs
	vPFjej5W++fYvnWQrK1LOdnE5ZhbpARubDhb+P2OdAzJDkzPtaajnYaEtkfCfKaMHAm0/Tb2Czy
	f+FLFiB3Gfi9wlgzDMKaVI+MQ0Z5Ve8xodPLMQo/u
X-Received: by 2002:a05:620a:3944:b0:929:7356:2e51 with SMTP id af79cd13be357-92e8b29ea49mr1954700585a.11.1783346065265;
        Mon, 06 Jul 2026 06:54:25 -0700 (PDT)
X-Received: by 2002:a05:620a:3944:b0:929:7356:2e51 with SMTP id af79cd13be357-92e8b29ea49mr1954694085a.11.1783346064642;
        Mon, 06 Jul 2026 06:54:24 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:86f0:c42b:ef4c:d3bb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493c63ba971sm619805145e9.13.2026.07.06.06.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 06:54:23 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 06 Jul 2026 15:53:57 +0200
Subject: [PATCH v5 6/7] crypto: qce - Use a fallback for CCM with a partial
 final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-qce-fix-self-tests-v5-6-86f461ff1829@oss.qualcomm.com>
References: <20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com>
In-Reply-To: <20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1622;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=Ejq3GCF3ALDtojefcexMkYFTMI2wVEXKIrBlhj81Swc=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqS7N/XzOiCW37/37DC2kSjBUfMS02JFc9UyEga
 1YdY63C3IuJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCakuzfwAKCRAFnS7L/zaE
 w8PUD/9XFKMV4iDp/XCMdL18GM2Or8cchFLaa8I1fB2w7R+CP3nCLVdyY226OlZvUcl/5bVAcoR
 fGn8jnOwQo5nhqd4Vmul9Zk8dtQ2I7NNhscI8kGnOHe3X+qsrKGbzncqt/SiRWFrrJ2fo6EChld
 fqI2LGqEP1rkQXQaDSYs5o94bt/bB1P9MT4ULjCXJryp8VT76nzKM2lJQ4cP7xQgPFOAjypWni3
 uexKknJq10GUeYkuG/nlQP4yTmIgyKm+OFP/SSn/cbSsndwIy2kWOrT70wbd4rbpN6iGhZgUMUh
 gZAQ3giu2XiL58/YAfwtayqLOwgdfbRj0Pl/huL/E6fDBgiZdEObSu7EWsDFUBAh8Cm/3/Z7PJH
 +QneJuwsPU8OkpAG1+0LAdyQN7O3ocXQUQrnQnCKsIY9z8Vh0mnI8j3MsTQKCZhHaB37h8ePpE2
 PU8I0notdC7qZHTYIZPKjD+c87ZX9ZoJ3/gXiQyeDDI73fgWYYn/WZ0/6VI1rpJRLT54gJ7XFjl
 JJy7Rn7NqehpkoVOirXNPw92kP1KLRvEyvja2CUdF9rsCKRqjTaaFsbJ5iiascp80CDmDRa29A9
 RDQsxOV4xHpnYdijOvzaX1mcVVb7rz2GvOvwGN7RDs8al9114uejioQCkiATy/SmJCPNI3A4FYg
 0uONVkpEnxYna5w==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE0MSBTYWx0ZWRfX3z0sIt3vzxZ2
 SyF4dt5OQsOKvBtvORfgAevC3aHyeWW3LsCd3aJQiox+6XLOkOwCEp/Dfz0LhDxXipxaabZi/Za
 IJuaUo1lhlMgyGO6Rox8EGSuhUDmE8V8aDQfW2DUXPq/TF7iv0GUlvDK/PMAr/N/bujX+ZP/93P
 sfLQkfd0+6JzDjlldHOtgDeezI2biShnTC0NWnrdhXaqDfph6yatTfBG3hPwtJDdB9v5f7Q/Trl
 ilq7x/qy2AFn16sAg7PK2BXwfq+buDjvO0l6PJNfMKF7wHlG3yn/fpl0SYopVFMKSP8ae22RfFq
 5W+zKvKPJRWj+Xj8bCpSWMP758e/KSn0I3nXx484j864EKaYAmGeY4nCCtyJ1qWKXD0yRapO8/U
 mvlZdflOxFQ8pYvQ0FxqhDU8QPDTXhr2aNIHS3JcvokGUQUW7nAXZxXRcBXcV175SBhROsjiG3P
 V1DcGY+FQpbfJpAkEww==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE0MSBTYWx0ZWRfX5WsE4bHYJuXQ
 CcgaFwCGfm0c3g5eg9hBAKwEN1ieJSrOkb3VBX8ymxicsAEq5zqkda0WRuru1Mu62QfFrpI+hwL
 vBzRSrNAbm+C4ixvWI+EnAVv8tATOFs=
X-Proofpoint-GUID: oHhhrHkKXJVik3wAeX4cvNi25Y4rwyAL
X-Proofpoint-ORIG-GUID: oHhhrHkKXJVik3wAeX4cvNi25Y4rwyAL
X-Authority-Analysis: v=2.4 cv=OKcXGyaB c=1 sm=1 tr=0 ts=6a4bb392 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=dx2SfONCXZg6tt9xEGkA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 spamscore=0 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607060141

CCM builds on AES-CTR for encryption, and the crypto engine stalls on a
partial final block just as it does for plain ctr(aes): a payload whose
length is not a multiple of the AES block size leaves the operation
incomplete and fails with a hardware operation error. This was caught by
the ccm(aes) crypto self-tests.

Force the software fallback for CCM requests whose message length is not
block aligned, reusing the driver's existing need_fallback mechanism.

Cc: stable@vger.kernel.org
Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/aead.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 336614a11377e0be246817da584296124f4de5d8..4fa018204cb628c112f64c45ff6c7407df73b945 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -514,6 +514,14 @@ static int qce_aead_crypt(struct aead_request *req, int encrypt)
 			ctx->need_fallback = true;
 	}
 
+	/*
+	 * CCM uses AES-CTR internally and the CE stalls on a partial final
+	 * block, so a payload that is not a multiple of the block size has to
+	 * be handled by the fallback.
+	 */
+	if (IS_CCM(rctx->flags) && !IS_ALIGNED(rctx->cryptlen, AES_BLOCK_SIZE))
+		ctx->need_fallback = true;
+
 	/* If fallback is needed, schedule and exit */
 	if (ctx->need_fallback) {
 		/* Reset need_fallback in case the same ctx is used for another transaction */

-- 
2.47.3

