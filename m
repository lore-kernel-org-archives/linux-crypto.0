Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3364F93A3
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 13:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417711; cv=none; b=l/ZEYOL2RdC/e1f3dtUzX35HM3tU1gokK858Y1LrLPpgbOWgHrl6RaLcA1sWNmwh94eu7ALbwoZgQPyJTJlldOjgq7WmpnEWlBIUfL0k2ZfqfQl56fw/2YTXO2tzp86lI2xUyGdRnHaK1HDODnFzYSv1uC52ZgZCnnAwhymX9XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417711; c=relaxed/simple;
	bh=tLRfmvsQxuz+ZnT4lHMKw9IOC40CPpnagJ0AjgLCpr8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=GqG5G4Pi6TAL2ed1e4i+tXJzfdMd0tLMkRTvSfs18FLsAvQy/69LdP0iv2iVlTgvfH4zfO061yHVPN70YKAZNqFS4cmN61t+56wQ1Apg0Y2O3TyidevgQKZwIRgvrvEaqwmrQQqsb72G3ErUhKFOopffZDmGHWdHinbkyvSeOvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jlw4cnzK; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kO87Y2OY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jlw4cnzK";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kO87Y2OY"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69J8Ox6M1168075
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 13:48:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Zpych/XnIuCmoabW/bSIyQ
	n1vDjzC48Sem0ex5wfaVQ=; b=jlw4cnzK16VuAX+DAAsEW501QJpzVfoRd+djnh
	IoWcZmIkFafSwoqlLHagJ6eIk7nHJo/+PIhTpf6bq5fRwddPhpMHFx2Y+1ObMj76
	93SO+5i52c8gwkUISpgCYhh49fwTiAF0XvEUZBNyZ9hpUzEzKE48RABNuhYS19OV
	RiWgr9Y5QMNJbg0HbxuQ6zFnSqvSKOKxDdaJlrxmKP5SFQX4lf1KWEjndSjxolv6
	MVTCnYHAOL98qLbHa73vX9luqJmxgieE/SclPPXTYm/V8ONtyLWleDfsQvQKCIt4
	JeGGFHOy8N1hEapuq+s0GSnxDOxbyed2OHMnTqfHoUO4e1DQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdf5c9bxx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 13:48:21 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93e49a1d3b1so531891285a.2
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 06:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792417701; x=1793022501; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Zpych/XnIuCmoabW/bSIyQn1vDjzC48Sem0ex5wfaVQ=;
        b=kO87Y2OYcVtCnECsL31wuk9ozB48yw1QNxhftC565saVC8iX/UwrGBl3o+jX6yazvg
         6xBoRDR6CZmDxVwfRnvgdwxrAI7K/c+1sURhfSdvrVTlYrxygbsWIpsVCnAakIxv2rxF
         UfoKvXbBWBU1AOp9wRl08iZvcRMgEQFYg/5LmxiuLWWqj99/JF85PkeD6K3gnu29F8xI
         +i0ThG+yMi+CPHp6WnODTtC3/vZBeavYFPh6NlO2IDWjddAZDmMzzvC4PtROb+zgILdN
         RETqWxLyt27Ixye7A52nSKU8WKJXQuH7+bHo3lX3xbZrBMUa6B5tzB5EqpvC7DLEYMgd
         tHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792417701; x=1793022501;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Zpych/XnIuCmoabW/bSIyQn1vDjzC48Sem0ex5wfaVQ=;
        b=ZUFFNqXduN8FiuyguLqET0TX2XQQsXk7eIKNGfMaYrKM08EFPc6xL5glhQy/1Xu+wQ
         cUCjzlvrLbW56U+rByyfDbMBa+ludcTNmkJPEt7JxdOC51OeoPr3BfDONm1AFDkiY13T
         7YHxjtcFQKkD6pdIXXqcg0+6PitQF3L15zea6Lgm4iLCaRmbk8qt4Cn65dGI8EM6ghLq
         ZKbB66AP6suJsqf19C9Awfi9EXpKTUZWObph5R82lye355/gw/sC29DyF9wIWYLXZb72
         My50kzgzeU2hw7kYqWJlQpyERqkQLjRJMj56z1hwwQ8c7pH/eD3fcPvOK7a/B/26Rf9A
         fsxg==
X-Gm-Message-State: AFq9FYIaXjK3XuPxfpSxQXebgVA9UFSHFHPp2JPuV+nKY0koPz7OmKSQ
	9W0owZwiOZ8ruZlxdqCfenznRpYXkGHTLdexoXtYnKwbb1uzCjS0wNpMmldtKXUumVdZNpMOVho
	5NQLSt7fkgu+HTdfq1HnvHv9Z690PrLRPVuTD/O8nmQ1AWUo2GSgX2eCmX5VCGC+gM1frCEzXYR
	8=
X-Gm-Gg: AYBFou20vVZsOhUaHq0R15qfzwuH3kc1IYCPQWMbqCG0IWndRd0eLCbR3WZfMk9ULRj
	Yd1Zq2dNTaFDud+pplsutJqvcJw2eHN5ru4X85qSUC9uiGmvEWLOz+bH0W5viFXEKta7EIEFfJV
	JHqqO+iYZY7Z50vH8GEkW2fAhxsBRxerKVb+NFaO6eGDPFee+JoWEHiyGLhzZ9bzJ75pBDMsL2e
	peZ4Ale63BEWPIqXWD+3dz6mhucL2YwAq8N3PeJK6DbB32Gro40MjekFTE53o2+k8wGkWlENVbb
	9uUWF+TyfdUV5BZa25nB2IeXwJEhBrptkyQcxuU6ItfrxZXDoLTpFbt1SXKT+qvt1APJQBj3q5e
	Cne4pGFz9kJIj0f1gNE80kXB+Bpur
X-Received: by 2002:a05:620a:2989:b0:93c:80d8:57ec with SMTP id af79cd13be357-93f29dbeab1mr1377074085a.64.1792417700543;
        Mon, 19 Oct 2026 06:48:20 -0700 (PDT)
X-Received: by 2002:a05:620a:2989:b0:93c:80d8:57ec with SMTP id af79cd13be357-93f29dbeab1mr1377070285a.64.1792417700050;
        Mon, 19 Oct 2026 06:48:20 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4c4fc4sm20595574f8f.15.2026.10.19.06.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 06:48:19 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH v11 0/3] crypto - qce: fix self-test issues in aead
Date: Mon, 19 Oct 2026 15:48:07 +0200
Message-Id: <20261019-qce-fixes-aead-v11-0-11c55cc7a695@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJcf1moC/x2LSwqAMAwFryJZG2giCvUq4qLUp2bjpwURxLtbX
 M4M81BGMmTqq4cSLsu2bwVE6oriGrYFbFMRpE47ceL5jODZbmQOCBND1c9BnbRoqExHwl/LM4z
 v+wGOalMzYQAAAA==
X-Change-ID: 20261019-qce-fixes-aead-e229fa2015e3
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3817;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=tLRfmvsQxuz+ZnT4lHMKw9IOC40CPpnagJ0AjgLCpr8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq1h+dXyU//X8RcKw2W3vd43VcfpMInoM/EcTX7
 rkTFzc6DceJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCatYfnQAKCRAFnS7L/zaE
 w1yTEACWX/WQGWgvL4uFWGc6oEczG5quppTjYc7NwYMv+fKC0ZT4KOUn2ElfaJUl1Pxi4gWcXwi
 rfAFqlk3UkF/aBAe93QKYkdlG7jxjIp4T2VcMhcWElwYTzJc56OsFJVWW7H8u+AWGLk6Sbh7CJl
 oC0FOaMiZBrDp5o2oVBrgA+QiG/JEMJAEMofvgXUurUEHY4b/LNDQ9eIb6VYooUxOwN5h4qQOz8
 q4yAI0waGnEH+YqscMYq8Pm2+1ep/7WF7JZU9tMSl14UYyW/a0yr8KE/vcb/MRtAdL/42i5dnOF
 mehLGZ29QvkP3y3Wtu5GSdU3nPVwo1rWP/EzuXZf3TPeTqw3bkrNWcNcGqhMm8pZ20TjHoyihIO
 hFa7vzqdOeM5PnB5OMor2iiqALBC2tKVNO0JqLro8sFwNlcvrW2dwnYuDPS6+2o6c8X3wvs6Vja
 SY3LtEPikgdKN4bab2NJN4b2VWsAcwhWyS223P6JsHIT9xeQOXoedsk0b+mTm218SV46x8eDsZd
 J4xaJEFZDGX3qQL+P18r9U1ivybbzZLHw6z6UJpj4hiwBFbSpptDQqgMqZ9MSg3y31VFMCWjjO3
 5OywGLwfUSuYwwTGS1KuKFfZrF1FNRTcgFDPfncfacYWmcG0gLCzVg5pXbRc+Q/ZpSdPPl5VQ6X
 u54pSyT8EHlk3LA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDA1NCBTYWx0ZWRfXzvtMwjqGOpcU
 rLDDi9Igw5Ejxp0wQT2VTAmOaFhteUy86PopGHbBvaZkFQZwnwC/XBjNwnQ5eJ7LBNQEXW4oaRK
 vBPWbeO6RIef+VNV9s+NAqlPNQw6u8U=
X-Proofpoint-ORIG-GUID: oMo6UxKpDyWC9H-RLquZoruWb0XM8k5Q
X-Proofpoint-GUID: oMo6UxKpDyWC9H-RLquZoruWb0XM8k5Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDA1NCBTYWx0ZWRfXwMcXOhpX5ihb
 9zBG/jt4p7NzwqXRCL4aJ3JHRlgIKMuOAKS3rgm7FAKsXwTFATCi8ZKYneXVNb463g4lD7nagX8
 R5EMaGwrqpnJ8cN+21L2dlodSAh/mIrlGqn7jBcM+QC6g45WLEPLHusrW3UgCQCHPT7RbhhIqg4
 BGMWGuwIPaRQBgoqXJjAATIquddLOUyA3NwrPZtgPvxgCdHYcvImOPy2HTEhMF0FWB0Naqg0MLI
 snymapCsijzL3XFzD/pvePNU8h0SYEKTeIAaeX/rt1TtTBRjw5fETdSTCF3+YnH3jfkuxfDLHPF
 1OEq0zug+XVl5CrBedtnj8bcr23NrOP1korMb7PeUhz32gOLMl9H1mzbXXKxbxH7MW+0j6s1xU+
 IvjQTlvOvkt4lwl40pyZmg913gCpA8Mc5xhvUknMR5bPe39wc1skVwI67jpYh7pPo1tAZk1M0xE
 OSW7i/6jTExyBardf+w==
X-Authority-Analysis: v=2.4 cv=K6O3jCWI c=1 sm=1 tr=0 ts=6ad61fa5 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=iK5QPMNa_E_FA8V_BHUA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_03,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 adultscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610190054

As requested by Herbert: this is the aead part of the QCE fixes sent
separately for easier review.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
Changes in v11:
- Split out the aead patches into a smaller series for easier review
- add a patch fixing a race condition resulting from sharing
  ctx->eed_fallback by concurrent requests
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
Bartosz Golaszewski (3):
      crypto: qce - Don't modify the TFM context for per-request fallback
      crypto: qce - Use a fallback for CCM with a partial final block
      crypto: qce - Use fallback for CCM with a fragmented payload

 drivers/crypto/qce/aead.c | 40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)
---
base-commit: 0aac16003b01b9282491ea3d454697c2dc7e8c78
change-id: 20261019-qce-fixes-aead-e229fa2015e3

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

