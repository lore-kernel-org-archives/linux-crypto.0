Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7287E544D57
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081885; cv=none; b=GLCFBbz1KK0r/NOMcMLdiBCkdoATDcE5IhOonxfHrdaExf4enIM/30/UHLqL15YF62CDjpzM0JfhCi3N3dbobXWDoRdZvG2xCoPJGK6lDuj+ReB25mHPWb27ud8G+gYciRZhp9vs8wVraCS+MLG0v0NY8O4BszSnhkGmYkR8nLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081885; c=relaxed/simple;
	bh=bj9lX9c4+OC8dVs8JmPGc4UfJVDkKWl/nVNsAYzA+XU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Oe40UrV4ZeJ8Iwr8LuQYR0EiXYglLgzJu2XZ4zFhl3sV/pDhmu/KqClXTxdXExoUhtiuE3oqD/nqHAt8G4aYXb+Kste0847QN1Fgnhb2/8jjJnF9W6Rx2FUK2FlMOlqcLvWDnViQxO/UylWcF3a+YBx5tqtbRnghyKta5NJ11aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=chTdvJa5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=d90eRVTw; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="chTdvJa5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="d90eRVTw"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBPSiW3516014
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:58:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/MIEadUHz6VYfh8CAPIjr93K/GWIq3ryVLs8Yl2c6YI=; b=chTdvJa59d54BeGt
	WHVvdpJKKeOWEpI0Q+WQWmZzNDsl8Gjb3cBrl9MNlyCyVPc7cQKO2IbUfHywsIi8
	4Nnr3u5+g9eLLhtLJ25mwP9u2OxQWTyk4ZdMcpJ2QHFqBeO7yHbgIfzwOqoz6roK
	Lm5zft4YYZ053/wwUYV1Wv2Q0aXDdyKj8FMjtrMXGH0gc/gO6NBLkw67T0AUjiO7
	th4/W7KPPZZWLS3Kc8/DVpiO5WjZqRYC72mnVKGkFGxviM+3GLy6mSrPNrPnEVnw
	cFZquudFgZO5VtZ/CL4Fa+FvUTc6EAdpAp5O3FZupFa33tmXuD7ufORCq1DqCPXH
	JilFDw==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gufsqaguc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:58:02 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5c82b120e93so814093e0c.3
        for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 05:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790081881; x=1790686681; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/MIEadUHz6VYfh8CAPIjr93K/GWIq3ryVLs8Yl2c6YI=;
        b=d90eRVTwP5tGoDe3GU/jso68cg/VhHVy6+5t8S35areR/toAyB02jRSyk/t1Qk80mX
         0h/FK9HL5hXaaW+GjTiuyU2jzZIzSYg7eRkqG3HxsekP/buRHX5oXx/nrdJSzpTaAVwC
         0HqfQd0LFQDhIkX6gzG1vNO1NZPaGlC+YpxL8KwAynFWNiM+Vxa/wV0QPpeKcghne4Bh
         nT2E5vyAv39PxHGDY77RtDrwM/HJo6G/FNv0vEfd3no3gkn26vfm+jWULWmzDUVdDeh2
         EDJ7Ld42sUhcTj1J0X2Cg7Y1wvyXRZQoKrHBriCRq5+zZLDNxVvIY+an+Q8vDYEWYPcy
         czMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081881; x=1790686681;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/MIEadUHz6VYfh8CAPIjr93K/GWIq3ryVLs8Yl2c6YI=;
        b=nxb/cxChS6SAwjAxf15GADQSUySQ5gJ0WWtW7cSUZe40Ir1BBzFNf0SzxuOzN/VUWg
         pimZCiVUSLs1LLdKrvtI27f9Ayj8InmojElVQpanqbt8NzguxrTchJqsHINZ27t0VYY3
         lntrEd9+j/i1N3CYZTzHwocJAs02afEdUfpPCgW84wQ8p+GMyok6Dlghqzq1X60Anx6n
         dYBb5EU1BXuZIRliSKlbcRTLVjahKaUDowfFlA9/la4NP0/HaOwXUQ/SHcoV/oCkQcLe
         MJSLCNmzsrLZps/IqXyrtrIcXn7FuDbaY/avtXWSxOJfFBLGPrt0isvmbL8a4q9MnaO8
         +uFQ==
X-Gm-Message-State: AFuF++nBwwSMJ2BdQ+/VF5UZsNRam7WGYmc5zwJ1Z19nEZd3bzlvi+4E
	L0JYhPxTB8uvHWCD47GDe1aQHoCr01FqdvHNvcqAn/sjJHdsZ84cav6x+rFIgxtFVzcg+JvKKeO
	rIJAw6Y+gHvrXTqarV5550XiLb5Q83Os9Kd1Vspgo76BH+2PjNHnUgv+o4W4pJ9p7fIU=
X-Gm-Gg: AYBFou1m1jcmhBm+ZjdzhjpGhA+gwNJxJGTQ9cN2swF/M2jiamTYWZ8WGjSHekNjSVc
	c4IOEsxdrF8xRrxbFCIh3Ipuz3GmBYGRU6Tch4D+nESoC0sH3beT2cpE5u+3N5QpBc3tS/tPoOj
	dyHdArpzmUQmRnVVul0kcfbCnipmpDXbMzZpa6lIwQd+nKMZtmB+ymoZs2/ksJ5emayoUB/ftpV
	1gfLsWLcS6CmmMG3GgOkh4YW4PnY4s9f0v00pIDiDbpSPuGJtj4LL2r2hms90TfwA53Vl1XQ9jv
	7hWevZ6VBZuP54axJygTmLtHL0KxHLeEJNWzpXoI7WgNcuv4SO1SqrVGAbvD5cTMWekfAwsR9Q3
	APImwhGX4Vu9/h2GlWEbg3d9r+CU=
X-Received: by 2002:a05:6122:17a2:b0:5c7:a814:b987 with SMTP id 71dfb90a1353d-5c9b8a6c1e0mr7412260e0c.2.1790081881569;
        Tue, 22 Sep 2026 05:58:01 -0700 (PDT)
X-Received: by 2002:a05:6122:17a2:b0:5c7:a814:b987 with SMTP id 71dfb90a1353d-5c9b8a6c1e0mr7412232e0c.2.1790081881084;
        Tue, 22 Sep 2026 05:58:01 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:5105:ff9:e148:c440])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aaa4537b5dsm1097669a12.30.2026.09.22.05.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:57:59 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 14:57:22 +0200
Subject: [PATCH v9 07/14] crypto: qce - Use a fallback for CCM with a
 partial final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-qce-fix-self-tests-v9-7-b1aa742e79af@oss.qualcomm.com>
References: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
In-Reply-To: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
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
        stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1622;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=bj9lX9c4+OC8dVs8JmPGc4UfJVDkKWl/nVNsAYzA+XU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqsns8hv63zSBtiXYbUTGccvk1xP2mkvo1BVVCt
 yxLjs7/kjqJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCarJ7PAAKCRAFnS7L/zaE
 w7bFD/9Kth36eGZBIVEX800vPqzyl9ccVlbjzHLpgw9p41gcpsdUO/y1PCbrtzgGxVe3nXy8b39
 K6lvPIGz1pP7NJR5uugWdMeFouuhSHIgQnBEiTEANpTSuR2xdAbZA/sCQhv2Ol1IJmpXQnjQXqD
 pDiTSHTVOEPLFF/59RnGbTmP2u5sjVLns0ABiT7NwyWBlATOo2n5dTaZt+mlmcSV4YuLazFqfym
 RE7XWqXTxZl9rYW8amIehXm53GDlftRqYvXeQTxayswNQvJB6+qJyuvyh3GlpmLCu3HBM+la5RE
 eiyq6XyeE8mS9L7nEqZBd8YhLHEpC+AzNQ2tEd82lm1quGeKbVci3NBDbC7lsa2q++JMQwp8Yka
 LVaIRfAylSlZJ+ivGZ0RVXBESyHK+okQf5CD9FDcof7hY6cTNiC7rlIX5rpMPeUUbzQH27EBa+K
 TYdN4lrpVAscBnNFdlFEG0xnZoR6nAoh03VufvdvhVdos4W6MORxU0u+HWIJnhpVVq6Ih6cPdWC
 GI5eAyD5BydUVjmGK55CZubxwNkbSejZCH9ygAbJ8j2h1rAPW6/rbiblywD7iub4lnltMTnT7Pl
 OuI7dg4J1TvQ0LUkQCzS5qRwmcnFeyBXpyeEwB8rFkuNFCy2PbRAK6QstkH344ndMpTPfJRqAWl
 h/2sTB+scr4lNrQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: -68spuFAPmYBVMI-UXPOk7NzuZKPK7JM
X-Proofpoint-GUID: -68spuFAPmYBVMI-UXPOk7NzuZKPK7JM
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfX53NcV84N39YF
 f8CFPL3loD3/ifP1i7+HAgvc2Ysu2SARqCgGIbHWmN08g7sL8Az2XNZzvsJ109JrdhXK+KwVBuX
 LmMASBlcVDaJo3sLG/4qTYokpEvwEpU=
X-Authority-Analysis: v=2.4 cv=NKBAaE6g c=1 sm=1 tr=0 ts=6ab27b5a cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=dx2SfONCXZg6tt9xEGkA:9 a=QEXdDO2ut3YA:10
 a=vmgOmaN-Xu0dpDh8OwbV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfX1NeBJu3WMbbL
 68Q8+pcFxBrudcG8olEpLu/3/NMvtkYNQ/kYPFGF6UEstbos3z0t6n1x38u7FHp/+bDSXLBJdBG
 E4v//StRmMs8f5F2cxiGzjToioQDbrIU/BliMM+WR9CGWnACpOqNKrhP960rDpiE3SI4zl08DMB
 JZAFdce8ocp5oQfmKuDp74LCIeqb37ecmye9mp4X2WPL6bbeAut9lC0N8XxrHSR4v2P0+3DeV4K
 ZPebMGDXwNg0BPuhIiLWLb/NsW5dDtFjPSvB+bednTdhmIs8iYAqd6eFdwzzJ7bhCeTRIG3SG1F
 AJbxrHNmWoyPKNM6V2cZjPhx4qOgRkkqtd3LqBA+9Vl0ygES6cNhBrP2CMVoLaLy6OvUCMsePSp
 JuiNXcDZpwaAcT2UCQlPp9aiOjjX74sa8kxvNVefIDItnzm79402pgJNcmpLvqva7jUbPES0AJs
 zIj32a5QOwLvydHoTcA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0
 clxscore=1015 phishscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220187

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
index e0061bfab216861444e36700d6530e7a3cd347e7..02e1a7684a7e51ea7ccba0660eea97a17589c3f2 100644
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

