Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E971E340407
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jun 2026 12:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780404452; cv=none; b=Ne9gNwpur4xwocLneHmWUFFj2Zu2tLDbkOP1MR3LI6QJmniLvuhHBrpltRy5cO/F7Lt38BvkZykMqStOA8FY/jWYbjbyZZ4EVMcnxJozIBlQq6f075i8XobPUR+b/yQy7LAreR8b6+08DsPD6E5IyzWU2OTJ+tI0E4VvFPratmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780404452; c=relaxed/simple;
	bh=/qUTl9sMI/vRjckOGlZTctOQLXKzKDXzB0maZwnAs6c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=sRmwoDqGkTULLdfRGQf/pQdbSNYhrluXIgPut/tnetryH87GemEYuQoqHnkF8inmv7mkYz8yUaKizbFRiUkEQDfKcGSTfTZRk58bhsS2aHePlYWgrIwzqUWgsWorCntsrbJ3oAHSZvwqobPFbScArsSwzp+ukwfhLI9/UtunCa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=L1d8z0QB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hTC6nK4p; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="L1d8z0QB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hTC6nK4p"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6526KuOV2884626
	for <linux-crypto@vger.kernel.org>; Tue, 2 Jun 2026 12:47:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=uep78eAe1qTPBeUI/iM+S5
	YJTJaXYnSn83qnfGYSLws=; b=L1d8z0QB7CLPYJzAmY4JV7PSjGmdwBa/BJZMvE
	c8vLIwDC8uKVZrDjj16Yd/x9S31JnH3gxjgS2QVM35AM0/qt+btGO+7+PwtIf5ju
	Ofrkspi/9wdWUWhTR5pPMZFf1+Z1E9tkc3K5X9/GNa+G4mH9ET2qVEjCAU7D1OKy
	k73H9KfEQM62Iury+9bt7qVMf5Qw1Iz978Go7DAXeUcUc5k0MaCk8vXtMfBRyAAJ
	8JxNOcHA3q3jjYDZxjjqBjdFLrFhsrxhAaUw5qe1jXAiZGygoz3Wr33j9oIWOHE5
	GjglW7KdD2srfapn21yaULPWDZucJg3Dl3KI8licq/rRqG4g==
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ehsu11cte-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 02 Jun 2026 12:47:29 +0000 (GMT)
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-6cf37fe12faso1017311137.0
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jun 2026 05:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780404449; x=1781009249; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uep78eAe1qTPBeUI/iM+S5YJTJaXYnSn83qnfGYSLws=;
        b=hTC6nK4p8jKS7+D981+N2uWI7dcIwW3fAmU+M+v0j4vJVib/O+hc5uBcBLBzdsvchA
         6SPEBGvQKpbK9MNMFioRhxRLKo8fhwxZKZ9nE0MNSatSqCj9/9tUW48d7AF6RouxMg5o
         Qv3DeknOwWahlyXTZrQb7YoUX9oixpt/Q32+EdRdac8t5WZAYcX1TgFfn+KH4SB0qyNu
         Ury0lIXh2KP/QRoKSPsysU8cURAcjDlwJdxpK1q/xE4qLR0dLLRNSxh6mRdoySwKfhIz
         70xKt3eNqqpAkPlrCJFe8KPIRwibhl7UrFwClgt2DpWXYcblOu2sw2UudHTKOUH1RNd8
         s8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780404449; x=1781009249;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uep78eAe1qTPBeUI/iM+S5YJTJaXYnSn83qnfGYSLws=;
        b=lOh1uic+SDilVqJMocWnCsiP8c21fFJorFRdMz5HJeNQagAQUNTjWPXVACqGJ9GQe6
         w7ySGVnUiFTDGbtH6Skruqm4KLOp7IEzgvPHnghCH0c8ZPGBnV/cXny+8+ZZEELdX16A
         h1u9/Du/gD7sPl+6GXa7EPxUsNJkC8Oujqpl9QpeP8t2epNpXX4UT5ocqgjy5CkwZB/y
         a86EjrP62VwJKodPuluy6LOqhx+XLYtVG9bEkSuZvmtXroOQnsBlungA9tClmzx7q5Ss
         jNFbLSsExHDFKSFQHEhKjvUO6ow0b7gmNZrjcnIDCSscIuImqjcKRj2xIfn3xd5SJydk
         rqog==
X-Gm-Message-State: AOJu0YwjhlDblRxjHHm4tDuVqml67OYxcWLY8957TSwOb8LyM4SFGkg/
	U5SrfSeiHbF8eh/+eVgDw4Hxkhj4uFz1sIkdyhGTivg7gErhsNmgMOxdf+eoBXGjIMVSbgy9m1c
	xuLU3WHTecVokf4m5a6tfoe9lgccpIrIZCUrpIUcRMal7dra/I0jYQcLpHTRkv+S/Sws=
X-Gm-Gg: Acq92OFx5a6jLTRLTDjWelH+poZXvqb7KSNmK95DzThsHMINo4XlKf2kOx2LKoLjEWd
	byDm15cdV4yrcKWmQl6bEF+GJE57tPYW4Vg0opg4Lx7W627HeV8uma0MFXINLMFarmJ/YFcCysM
	1hbDBO7hxWsa8OT1CWrJ5ZNACsaOKx0fhBC9MWUMZiXgR2jmpgLTLOvYC+xIbhD22yCDA44kZr0
	GWKwxmiHUNMQ3hRPx6CgQCrD5D1iYT3+j2umS9DkqmsxK0UDNwmk1Yf1zXbq2R9yGjQulVDRNMY
	4CR0Wsq+f3xy+4UzC7zY81le29KUhrCfjqYn/AOzDrYP9QQ3G0Bar/GsuixVdtXvQ0sGN8B3Crf
	SEwiMS3n+qUUY+YpMahBWeRzen/Qgh5a8ll30OBnvGY6zHSG2BR50y6Md6T/BwX4oHylZzY7LmB
	dM0csU2ZlSUO0/BA==
X-Received: by 2002:a05:6102:4b18:b0:631:28c1:154c with SMTP id ada2fe7eead31-6c68d62b471mr6145914137.9.1780404449077;
        Tue, 02 Jun 2026 05:47:29 -0700 (PDT)
X-Received: by 2002:a05:6102:4b18:b0:631:28c1:154c with SMTP id ada2fe7eead31-6c68d62b471mr6145903137.9.1780404448597;
        Tue, 02 Jun 2026 05:47:28 -0700 (PDT)
Received: from brgl-qcom.local (2-228-54-83.ip190.fastwebnet.it. [2.228.54.83])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34b834esm33096872f8f.11.2026.06.02.05.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 05:47:27 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 02 Jun 2026 14:46:56 +0200
Subject: [PATCH] MAINTAINERS: make myself the maintainer of the Qualcomm
 QCE driver
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-qcom-qce-broken-v1-1-a4ef756089e0@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAL/QHmoC/x2MQQqAIBAAvyJ7TlAhhb4SHVLXWiIthQjEvyddB
 uYwU6FgJiwwsQoZHyqUYhc5MHD7Gjfk5LuDEkoLLRS/XTo7kNucDoxcajUa64wwwUOvroyB3v8
 4L619d8KT6GEAAAA=
X-Change-ID: 20260602-qcom-qce-broken-16257bc707fd
To: Demi Marie Obenour <devnull+demiobenour.gmail.com@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1686;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=/qUTl9sMI/vRjckOGlZTctOQLXKzKDXzB0maZwnAs6c=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqHtDanTXFZGHY9kJ77ITtK7fxbu6RiPtBOokIj
 d4rnYVANIaJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCah7Q2gAKCRAFnS7L/zaE
 wzt4D/sFk/6NUsGH8RkpfU464qPnuizgY1weScCKsAxa+0ORO+CHE6L3kexi+42Fverqm5Imofg
 3iqtVbL9vEBV4poV+FPMocad8FHNwkVd9kvRk+oEvh8JfemCh7E6w1DRh7Hj1ogAt3JKIlZBWjV
 YvpPRWPxqhXkv4OIKpQnpiJsDHH10cu/R23MwGeVX2WxT7Oqvz3GGt6oh+oMwpNY2kxxGHorYEY
 SOd0v7Kkyvhi4JEumK2SSmywb7IgrcKslM3PLeu8jvYNnG6Tm0O47NeoRBZrOkQ9xKVV/AiutTn
 0jpvQ8DTsxZGwDB5ouqngOEJ/NZp5u3slpP9kCxs4JM9SyFH34mzFW/xJcGwbtsrgDh99RYpErC
 4s+P5WuNKcD9gXf6Sq9cRdA7WgAaLbL3EL5ACwC/0tsS/DZwTWvEb95FdYFYAqIR0Pwf4llF8Rp
 UGd3+iO/3vXsGxkmwH2KFC4wDKnBqLQrtPMUQddR8EZ1bcRkCgQhMYqa3eEpzs8lkxUPNmpAFgE
 Hs/o74ipSFMdhh3+YvRAX0ELuffW385PSZz6YHAgzmhfzY7L0yI9Y1jQZ5Tdi9BWU9xa175JXtr
 KAr7zNSTITdonuAwrwTppfbuHNWBYFUutsYDk3EAERFFxqACbgNZqSjq13VVr6ZdEDNbI2kTV+3
 sfBKRXYJoRAB2Ag==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: 7qNrfrj61gNiRI2XW0aGlcfmJHj0rm2V
X-Proofpoint-GUID: 7qNrfrj61gNiRI2XW0aGlcfmJHj0rm2V
X-Authority-Analysis: v=2.4 cv=MKFQXsZl c=1 sm=1 tr=0 ts=6a1ed0e1 cx=c_pps
 a=N1BjEkVkxJi3uNfLdpvX3g==:117 a=F4J0OHcPalsv3C1teIDEwQ==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=69LWc1rl86c1DZQ69rIA:9
 a=QEXdDO2ut3YA:10 a=crWF4MFLhNY0qMRaF8an:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDEyMiBTYWx0ZWRfX6RTCYHcQTZP5
 jm81CJSaQk4nZzvUUALGVrg40Mq8NIKkjNkaf3yI1cifmnZo5a2poH292w4vyciJouymJd7vuQm
 latKwTfJDeBRnFij9dSN/3Tg6HigyXdW+fLQEgvV32KIvP7HmaRcb/TYY57yoE6YReXZBOOI4w5
 IAtzilnFIFY0tTZf9nWvIheJUL0am0d4/DbAA+RHHtqqYbRo24HQGYnsc7wyDcpxaEETWFZoo4b
 Hg5s2e+lXV3znv528R6iVdt5VVMRfutvdNSlR6ktptpUucLyWsIvFl7q0C6/6SrMj7t+OUlCeLd
 7m8oGOHVnBaXPTczIr4xPHh6TiXbASSpOAxis8hkIWqa2+uz5IhQohocLCkTB296VfNRRF9SdDg
 WHrAr2gIud0XDfTXleCqH3f0321uf4Vt42B0lSQ0pOVxm9q7/vqg503qEnTHXNJU2c1zmfHV2iB
 jDQBawUDSKQhWnFv/Yg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-02_01,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=1015 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606020122

Qualcomm wants to keep supporting and extending the crypto engine driver.
Thara has not been active for many months, so change the maintainer to
myself and upgrade the driver to Supported.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
I've considered also marking the driver as BROKEN but decided not to.
Next week I plan to address the failing self tests as well as go through
all the ciphers it provides and remove ones that are known to be weak or
deprecated.

Regarding the series that proposed to remove this[1], let this be the
official objection. Qualcomm's clients use this IP, we have support for
new features planned and intend to refactor it significantly.

[1] https://lore.kernel.org/all/20260523-delete-qce-v1-0-86105cd7f406@gmail.com/
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0ae45fed10fbe2983c37889bf075c058bc09816a..538373148cb1782651f8b47efc8ba3ed9313fe38 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22087,10 +22087,10 @@ F:	Documentation/devicetree/bindings/opp/opp-v2-kryo-cpu.yaml
 F:	drivers/cpufreq/qcom-cpufreq-nvmem.c
 
 QUALCOMM CRYPTO DRIVERS
-M:	Thara Gopinath <thara.gopinath@gmail.com>
+M:	Bartosz Golaszewski <brgl@kernel.org>
 L:	linux-crypto@vger.kernel.org
 L:	linux-arm-msm@vger.kernel.org
-S:	Maintained
+S:	Supported
 F:	Documentation/devicetree/bindings/crypto/qcom-qce.yaml
 F:	drivers/crypto/qce/
 

---
base-commit: 08484c504b55a98bd100527fbe10a3caf55ff3ff
change-id: 20260602-qcom-qce-broken-16257bc707fd

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

