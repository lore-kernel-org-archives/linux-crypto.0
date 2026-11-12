Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794492657;
	b=gsofVvFG9lV0A0igCEeugvWP3mVjA617JNWyBK59+8p4fDS2GqgrL87hWWlba0kMf5b3
	 tDgEUzlNUhwNzWkiWR3B6phWZdnZlWy85q0Nyu2JIJL1ruj2Mj+0TmwK01fA821+hyZGf
	 ZTomryysiKvvpM4M6TAQVJgom11pZLdhtrNpJaH9Zx5qXQM/DwA4cZkZI96A5LP2nXZi0
	 R7XOXjZ8zYaZV2upssjpDF8m1+/2goDnPeaC3UfownVR1C2Kx9rxOxJ8dIh4H+xUIKr8H
	 klqNDJofrARDSvWpBh4+Z7YNr1mvE3d54t0+XfN3qoy7bNV9x7ZqY82mPiDvGMocgRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794492657;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=7KlceQbgnYObNWEcS0jcHmtcmOkNcG0VlHdLvVEaUTM=;
	b=oxnJS15MR8c0zi4ogDw8AvxmBZ4I6rzdg2WRTqJ0uW+JqbVZ9xIi11dAvLO5X5RFVcNr
	 Ts69HuDxIJaHpHkFEhNVCQq8/BO2ulvN+EmROxp+EyvcxkeEfPTKKDrcGpkvjZg21kA2s
	 4KpmTgzqU/sBmD8IAfnLB0d9KVz0tBFq3WI8Rn/Hqe8DP+zQ+IlIh364yHo42gnfDIDf0
	 qqCB/U02Ol61FfuN+lMAs4XLuQ0erFr5/Bwc6kFAkjkdLiF1OceRB81giI/VP9a0bTBlC
	 tmkhy0uvjXy6tfXW/ypxljHXk0Ya3x80NVssQRga8sZoCMt5xJrACPUJLQM8lJ4+7UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Q08zPKvt;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BETrjSf8;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640A7606A32A
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:10:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 640A7606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Q08zPKvt;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BETrjSf8
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC96Nlu2514154
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:10:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7KlceQbgnYObNWEcS0jcHmtcmOkNcG0VlHdLvVEaUTM=; b=Q08zPKvtWQ7/BhRg
	dADUp26Zn50BB1nOQk9IQoo7l4jpWASz8V5Zz3+dBG5oVqNrtIeqX1GUINuDREem
	OCqRCueHPPZpXpjnJULVG0rESSrg28b6cdWsuj+3xNNwFxq3owvsPj37SdwE/c5s
	HYglpttYh8ysA7XMocq8xRO6NpO9oeeue3mOllSJ6pyvcU93gfR7vYC5kocLHXnM
	j4gA7Js4khBI6+6dy+93MGe7fkF6dZJGQ7ijM7h8hJXjECW2ZedL7eeJoK4Y7tPv
	swGedbJsOw1Kfnf5dT9wijHJFzmdDVkXC4PO+RkTgyC6Rc9phdyyEIxdUityaQx7
	Juqe9Q==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvwm1uw86-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:10:56 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5edf86a8c00so1032217e0c.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 06:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794492656; x=1795097456; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7KlceQbgnYObNWEcS0jcHmtcmOkNcG0VlHdLvVEaUTM=;
        b=BETrjSf8pn1j4LdDwf+VTGvbcb6Jau2Ie3sQ1NtOjU1vDA+ugkJ3LYFMQLkeeZ1bSG
         EMFOJj9uBKUYw1mA6f5wIGwhQBEqq7melr/GvzwRDXRAsC/66NbCpFX2hbMf+2W4lIe9
         rpaaIT9bXYHZQ0axqMhzV5tXVe3dVuSdCHgoTMFTwUDT1wRc+2IjpLc4QB33k6QXQNDk
         JlFh6u1fhrH9rj25u9uh7O6s8G9LLXmIzQUvxuTOu4Q6XoRFw4vZSOj8KA/9coItnDwM
         SlBlxBWgqWdOE/L4yUp8Lov76YmU1F59mSI0sR01JFm5TiQ1Bm7mQ6eM3H10HFfAxZp/
         652w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794492656; x=1795097456;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7KlceQbgnYObNWEcS0jcHmtcmOkNcG0VlHdLvVEaUTM=;
        b=pey6VeRp6Jdt4zQM3f0eWlbfPP1rZwQ2wrJTKNtNlojMXcdZl4ivaJ3tj13NnRo22L
         D/34KNj7ART7UqD+wzpULssA8gU9KZCWaPz3mcfJoPhTidFozO/1Oq7plhfGe9Gmczx9
         EPjGxO7P0naNn0nXGl7aFpa+Vbs0n1SxHe+8CACtr4Nf8gdI92mciA961ZCw+W7hOmWu
         b3JCcmAICykyhjrB+SnmwjFGnYa6B0qMz6kjhRnu/hUsuSRw3niXFwCYseu1QB/nlYhX
         o0+WelvP7ReUZXYPSnG+jiZH4q6tKNs+JyXEYnjnJzbFOezcjOnbNg7p9tBWgV9PrVb5
         cRig==
X-Gm-Message-State: APuU4Z/T4pK8GJUcPemI8VZHSZeIBX9/jld3vt4eKuma1JEvBIxlmm3j
	V9BM6w7PUO0VYTOCAPC6yQGQNPHgLJIP3pPvM7rWAkT1a4IkVh/Xh4Z3qdv+rJHA0uRIYhv866X
	3nTlge5hHRXsB6ah0On0C0lWq5F6j2JkffXdDeOgeuJCRj4MsZ336/uc4I0zfMUgbMaA=
X-Gm-Gg: AYBFou3Ydv+sG3eho+0w+LcIMH0fVM6elitKnf4wXkFAc+WP2OVXuJbraTnKsMFemBw
	qyJmYhOVFWDLvfhK/jpPT+VIQ1BAxUG5w2oSMznBKQuOzGyRFl4aJXu7Nhl7QVx8G4Dm+kRSFsn
	ojA1Naqg6ZGLHFn7QhqBrJvwnFFOIjUWx4/pN00GGcNualVK2gjGRBFV1JimFzDoOzuSTWYSiIr
	BI93J0K98witjBdMrxyTcYCzU46sCLnULdCmXDFHolQt/djaFS+pZ63GMqiaRvjA8KElrsrMKIh
	NnwPHKc0ncQzbJyaAhaNt7GyrGHYvaHMfj9pVOH3XAwFkztZy9vSmZggAY7U2uBxzINlxt56w6M
	tLodPvdgTVKnZtD9+Oi88QUAjnCWqKCeiFvFzjIZJgl3uAIVXnyK7XdUEn/xkpK4tgnT1PFYCVG
	Pv7844ohjuSxTJnEg8ENsFc/4PNvBxhXzkRHy93MwBPOHXerTQl7opALwix/6DGSU=
X-Received: by 2002:a05:6122:3286:b0:5c9:a60d:3276 with SMTP id 71dfb90a1353d-5ee1c3fe5eamr2294763e0c.10.1794492655762;
        Thu, 12 Nov 2026 06:10:55 -0800 (PST)
X-Received: by 2002:a05:6122:3286:b0:5c9:a60d:3276 with SMTP id 71dfb90a1353d-5ee1c3fe5eamr2294739e0c.10.1794492655342;
        Thu, 12 Nov 2026 06:10:55 -0800 (PST)
Received: from brgl-qcom.local (2a01cb1d00dc7e0089167b9b97a26c96.ipv6.abo.wanadoo.fr. [2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e271378sm81817775e9.13.2026.11.12.06.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 06:10:54 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 15:10:44 +0100
Subject: [PATCH v11 4/4] arm: multi_v7_defconfig: update the Qualcomm
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
Message-Id: <20261112-qce-fix-self-tests-v11-4-b86a65ee7107@oss.qualcomm.com>
References: <20261112-qce-fix-self-tests-v11-0-b86a65ee7107@oss.qualcomm.com>
In-Reply-To: <20261112-qce-fix-self-tests-v11-0-b86a65ee7107@oss.qualcomm.com>
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
 bh=FctauFHZADEzXXldL+PPLca+nRIKDHu5xhFRwimXZqU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq9cjlCVirX+YzppCZQDD7Q8AvfImymH8ZnTh2S
 ZJ/vwk3hAyJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCavXI5QAKCRAFnS7L/zaE
 w0iSD/9/2ZqsJSw3c5O4JMZk8f3SxL8A0Hln0Zj2cOCj4wFI8HOgqaviwirUZRlWo8qjhjP/9/B
 MzDmcswmU681m7LO9AG7i5ll/306S+G71IBN+owa1tfaCtj1z4nRQ1rTHj/oxEZq5O9s7udaKgk
 sYIumk0AVBanFjk3sdkpPJ2CDV4C0Pub6DSGzIzbnxLy501Q0a9JcuUmaT77OlH6yhi/UvI9hG6
 dSEPhyQPBN8JRRa6v32M/AKxYMQl6WDa4jCyARk8AHO/3qeEBPVwbEO50LI3t91WFtx0jp9ZcCB
 t6wVvD16WX5FhO69Je/2N7MhRI02s+oi2V2DLZLWcp1L+wmeEESgmcKWZzgxllNG9tG6jvnsW2t
 u4bN/1iYJm1ny1hoiGEIo1VxVZqWhUj7aJ0RIhaTrbCQzhNUjApD3QWKPviPx8OfNJAYehNEyu5
 vf8F2/Q38YbRqWEFA1NH3TavFkMssQkvSHYMYfCI1TF6FCiqyMNE6yUafhChQo132zWZR6Kj0xq
 P5R6aXe4GBBLLPRwRrl5UGKPcesqKrmdUnJ9eLFZ2mI+S/UAUfvmqlwSmTH789OUX8L/B9o6UFV
 PUoc40n6t15RSZrQFIoMcen4tz88G908HtwaJB9csvqa/vY4UwwuhQ+2Ob7thoSesAY93GLbqge
 EJ+ziK/bFuvvLTw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=KsnYSmWN c=1 sm=1 tr=0 ts=6af5c8f0 cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=5AW58fNYxLuDjIPvRSgA:9 a=QEXdDO2ut3YA:10 a=vmgOmaN-Xu0dpDh8OwbV:22
X-Proofpoint-GUID: ADA_SQz7iXJyjOvKFQs-e0jByp1Ea6ij
X-Proofpoint-ORIG-GUID: ADA_SQz7iXJyjOvKFQs-e0jByp1Ea6ij
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA1NiBTYWx0ZWRfX6rs/80peflJ4
 wJmSYRGoIrh6bdUVk8HRNKierYp7+yIJuIqtDnCWUjLvhIWt+TL02tJSo1r6fUZeqr/0esLmKMw
 gwkoDqX7vB8FqzBlCtdnnq/5gcMzd4uV8dW1jdbfU9/bQNOUyopvJlzgELI3qATecosknBMv9OZ
 zQU+fzowh0NKs53WNeveb29rP2vGVDsnH/TEVUr3K0Nukepzjbmcl30PCRkrVO8aOqfTtfel6gk
 VB6vhCtFFjpHqn9DVePNoaft7JaUvb32NsB2i36PwOks/l3/fiIe3X2mA89pQ+EgTK4tHRk9C3G
 7Ek29WdUX6S0J9RTnvrAJFV23bYh6OC8bkG6/lD5vCAGSR8hEPMLFV+mlN9UT/5suLqeMFUY95h
 NAJ23yJivvPiUZqweo5DAH80YlBLGxQdsO9+3QqtaSQDw0Vgm1NeF8ZgszZ9JKIyQhhMczPoYMT
 aYRKDl0B9N4uJyvgf6g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA1NiBTYWx0ZWRfX65kaaEUbX5ae
 WoszM8CeE+Tp3kqnzh8TYqWNcI0R9+ipiwh3Cf3LeR0AB4UV96FFPXZlrqS8OGOYxY9JivGJomg
 ALJj89Brrwx6vsl5tqdHgSL9IkcfHHo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611120056

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
index fee64572027ece8a07524db7bcef5a4ccda71339..40b0d2a8ed1eff5404dd6e821433044475043880 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -1134,6 +1134,7 @@ CONFIG_ASPEED_LPC_CTRL=m
 CONFIG_ASPEED_LPC_SNOOP=m
 CONFIG_ASPEED_P2A_CTRL=m
 CONFIG_QCOM_COMMAND_DB=m
+CONFIG_QCOM_CRYPTO_CORE=m
 CONFIG_ROCKCHIP_IODOMAIN=y
 CONFIG_SOC_TI=y
 CONFIG_KEYSTONE_NAVIGATOR_QMSS=y
@@ -1305,7 +1306,6 @@ CONFIG_CRYPTO_DEV_ATMEL_AES=m
 CONFIG_CRYPTO_DEV_ATMEL_TDES=m
 CONFIG_CRYPTO_DEV_ATMEL_SHA=m
 CONFIG_CRYPTO_DEV_MARVELL_CESA=m
-CONFIG_CRYPTO_DEV_QCE=m
 CONFIG_CRYPTO_DEV_ROCKCHIP=m
 CONFIG_CRYPTO_DEV_STM32_HASH=m
 CONFIG_CRYPTO_DEV_STM32_CRYP=m

-- 
2.47.3

