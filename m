Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417923EB11E
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885485; cv=none; b=p4kMEbLzjULaOUZxPwBS6AlQjnDl6KOj12D2hKQca/n8tHNfqMCJOEtjocFlraxJ2DpmmlLe2mygmQXOjVJyvKKX4WV8KV+sg0iPNXAKf3KZ+01l7xrWhy78DQ3pGZ3cmQTn5DFPTt3zvNz/+LAAShsUAXaFYFqLM4EOXt/G5t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885485; c=relaxed/simple;
	bh=b78OH44dk3W7bznJ8EXqzn2H7m89nwXtdkJrfQuGZq8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=oXTmcRGD8kMefzXm9ebNk7b00gp/745ZUzzNg3rZwFUmKtv1O+ezmjhu1geXo/gHs/p3WG7SwbrQuj7oFOvzowoa/yjkqb9Q7r8imuKZXdXsUkfuD6UVbNCiIuUoK2Wa/5oxjL0SctykFru+eOGTFGWfJs1+7QAl/0bQ/tQrESQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kBd09fqX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BD6R/b0P; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kBd09fqX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BD6R/b0P"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D6Z3k13209360
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=XQ5iQnNPR8pVf/sjy9fV4D
	Tar/X6Zhmuz/nTn3PkjgY=; b=kBd09fqXlbCyANCX5OGy8EHKW1W9sI21EAkaST
	WokDjcM5G/g4MVhPkRQk8OenoT45lCXZEN9XEQ/wFq3TyaVaDtWk98H8OyPoEfqU
	IzGgRt8YBOWz/3LBl2t/LfDZy3Avea/ayxINEFhOAv1enN4EiBIvIE06MbNVGqCb
	JkjKBYgDocG6maqMEYKyIIjzdAS4GlMvDDk6uVmZYtDbPPzjzaxMF3ClGGN/MGgk
	Ks72G9wHbOeWDpNLo6YDQODNcpJxu0V7eDl1V/7DwwI7s0wjRh4HjKEgisUf2GeF
	PDYkJFbdY3PiLNeGLrtYWdgOy4yXbUXJgTor0wOoMhokwwVA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9fgjgtvx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:03 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-934963b2bc0so544900785a.3
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 02:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791885482; x=1792490282; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XQ5iQnNPR8pVf/sjy9fV4DTar/X6Zhmuz/nTn3PkjgY=;
        b=BD6R/b0P6aciBrtVg1/Bv5l5DwgpEsFjfgO/LtJMyTaH+5aw78P5sPBPGw2bBvZG2d
         +pSS5/mU1N+cIbglqMBb4AWeSpkaqFoTD4FVsB0IxrOuRBIPYbWFwTkMoAAXdt1LVfw9
         MOkOiEerxuaaJ23Aav9uPXkN2a+qt6SvM/sZC+yK4Vq9MydPdhcX47yuWOh+XFe9ECOO
         yJ2T5Nqh322Zl6Nr5sq3eiU1OnOp2kWGlFydYgd8pn5hoe0p4/DyStSKDab/ftH2gcu+
         XD5sCFbXhf3BvqENWOddo4ferc1HXGV1RKaMF9BLnlj5YGzx8ZcXf+IjYRFkTYbnfAu/
         Hw1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791885482; x=1792490282;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XQ5iQnNPR8pVf/sjy9fV4DTar/X6Zhmuz/nTn3PkjgY=;
        b=XeZ4Ka3DnCwVQdo0dA4Jys9G0SZ0sa+Nf3u5fOwAg8LMWQ+J0vkJxQaxaX8lm7VNqh
         rF2KVbC1GYNZ+CA7Y+S78+jr8NRvslic8cXj0gAv6j5ATuDhPpXkPuU38smw6OcFdTDU
         zldCffygbXDoncFQiLAYTG8W0PYrHtMAuWOqgauy5TQ9K4+ZcI3V1KvIwggnUrAkGf1a
         UMnyo/9oVRMKWEwtc40VMh0+d2CYEKCqS/sMarpa6Ikhr1/iJf22xj5ZbkotCXe4Ju9q
         yhNllbjEukFPuZglmFuSl4VOeoHRnt0vzob/kr7lx+WC9HbZAjST1burCyVBqYm/bdo2
         CUMg==
X-Gm-Message-State: AFq9FYIeYXInK20qOljrJqFhY0Lhz8+dMQw1xE7iufF0QJdyl18ClZDK
	zha+H39sQFU9s8v4edaaB6IJvLbZlbnVBQmoKfUdB1PVo4cAIada5dnIMh69ccj2wqmtkvGlx+Y
	4mGj8+M6fAzNzXfE/smiR0UQHVn9loTzQpIXsobXnfLLq5fHsu5Wo6p1TJcJFzFfS1m4=
X-Gm-Gg: AYBFou34xbngyZ3xgud8OGPmArK+ux0kkFNcWXJpGuYii0OH3gA8LzzPxs3uELUA8wJ
	ObAx0xoR/R7kPSuRN4xHCAbLFI+7W4Tl7PzIvHQgxBqjncIiv81irD/8tbeRY47oXGLCRVCN/Tg
	GZ6D7Wp70Pfd17Ni5Ua9vQT7TafSGXexYd2FYpviZW3N6bZ/cpTafkudKjByL5K3cOUBkAdxGpy
	To2opg9aA8iFXNJbIoqOeS7mQP1AI/bGz+p/OyAsTJrhPDiqPWvWpvCTwFndOaYnJPZDj5RlPnJ
	ApuMxDBfPlzW/ZCnTx6sQhSZTN03eZEDgLpBlHr0wevqF6SQJ6e5TLRew1EkWKd2Kak7mwffdvA
	UySZji8GM1Qd6b/BFPPpvq9WK7hMV
X-Received: by 2002:a05:620a:19a8:b0:93e:74e5:2b1a with SMTP id af79cd13be357-93ebd0e4407mr1897089085a.10.1791885482327;
        Tue, 13 Oct 2026 02:58:02 -0700 (PDT)
X-Received: by 2002:a05:620a:19a8:b0:93e:74e5:2b1a with SMTP id af79cd13be357-93ebd0e4407mr1897086085a.10.1791885481808;
        Tue, 13 Oct 2026 02:58:01 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bb6beaesm209412025e9.0.2026.10.13.02.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:57:59 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH v10 00/14] crypto: qce - Fix crypto self-test failures
Date: Tue, 13 Oct 2026 11:57:29 +0200
Message-Id: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIoAzmoC/3XSwW7DIAwA0F+pOI8KXMCw0/5j2oECXiO1zRqya
 FPVf59baWoOcEGyBQ8bcxW1TEOp4nVzFVNZhjqMZw60etmIdIjnzyKHzAkBCpxyWslLKpKGH1n
 LkeRc6lylCUCUoVCwVvDBr6nwjof6/sHxYajzOP0+Llngnv3nbItbQCqZU9CadIzZwNtY6/byH
 Y9pPJ22vIi7uuzWEjalHUslJdibXHKi3JHMSgJoSoYlQ54bjahdch3JPiVUrilZlrwj4zSR9hA
 6kltJne7cvSZrES0VSy51JHxKoT3ABVlKeZ8BtY+kTUfyKwl0U/IsaYV2h96FiL3ZhbXUfvHA0
 p4/ABooGCI1pNvt9gc/39s7wgIAAA==
X-Change-ID: 20260610-qce-fix-self-tests-492ffd2ef955
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
        stable@vger.kernel.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6324;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=b78OH44dk3W7bznJ8EXqzn2H7m89nwXtdkJrfQuGZq8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqzgCVQL4s5gavr3UglkZwz3d4nnyTokNOrqimg
 Ty1GvfrxXyJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCas4AlQAKCRAFnS7L/zaE
 w19VD/9ILs7+O4FP+h4MhIk6OCgKWqh65AiCLsfW0/xLm4Npaz4rQw/S3YCAuLJu0fIR9M/a8nt
 IX3W2nG+U2yfqmXchdAGzKaDkaHh6/vZqL9qXAcwtdr5yEI4iBIA4/H6y7L8fC3t48pvu0eqM48
 meDh/IARIfMfJvGUVlCs7t1TsHdVoFKmOxP6svaRmMszY4iNguw6WX7MRNJ2cGX+g7CmT7t4ADH
 8AGwQHm5w2wkD+O3+lTYqXkrMHbhFsec0UkVDE2tss6nradLRtp/CVG91Vie/oDOvZhjJQyWSP6
 v5VbkAKMfui8DZH3uch6JUTZe0SAIDCmQwkJnv0CjO+Ae020jUbPMz7pPs7Wur2MZuIyZgtxGsu
 87i41GHa4zqpq+eoXsuUKq+K3PELqxJ+pixZWkek1SO1O3+m4di5Vrj9VJk943hZQMAsjNzKfgD
 PmCmLz6MrBV28RtB76Sq0fW0MC12lZEcUFA1JK7GImA6YTygABY/xdvujp//niyOtoTPQEvzHle
 BH+x1Uv/4wPlla2csvvd4QCmVpGUscGowamHaxbRogK9QuAoMALFQMWvP0ga6HQ0rc3H8wv3aIm
 r1heNgox6bPwDzJS5mC3wuqJSmdsRsVkapVJV3NNdmwPfl7WO35Wo7LkR1Zp58F6uXYEbXbCe1v
 pZmVt4rxpdGFa5w==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: qsluHc_CONWYxoFaL_puqeBjL6MI-Psb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX8qlN8B3VlRXi
 Yq2jkdX7DzeGgqPqSsUzX5HQxBybtV6mTRjrkLJYfbd0pG7vv65YJcp3CLRZ/Mdaof2vPDnYd07
 WVJJE773mkDbQCikY1Tb+IlmtxCZazn9jMyBkkRuE/SZT4vXOTRhXpbJYV/DdDvLiEESwXqptnM
 qfU+CLNfveQS5FV67r3MAp5j+anCNMX+GbqLHedBTn4JXsCIprJY4MVjO91VONTnL56VfSa9X3d
 MBl5TYwCemqZBjg57hA+2zxl50g7YsKYiJ9QQ7A/9JG1naQSas5oI0vCE1Fy90y1vlwOcTXyaI+
 9rGKXK3cwRjrE+d29SdXqLahe0yFxNyBWm34uOBEoO0F0WoSjAcjl0iqCNqloKl7ztNOK/Bz221
 U85WrSpSqsbdyGP/X2jYtpXmQGIxWg923XhrLVKx8TJQs8t/TEHUUT3BQGjwPqcek28LXnkiKw0
 GmVshEETEvg+kzzq1NA==
X-Proofpoint-ORIG-GUID: qsluHc_CONWYxoFaL_puqeBjL6MI-Psb
X-Authority-Analysis: v=2.4 cv=PedqFShd c=1 sm=1 tr=0 ts=6ace00ab cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=WbXel1EKDWabkshC50YA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX8d2E8n1gCC2L
 6G5t6L0FyCd/Hegih5jOBfgnsdIbMQ+cV7Ws3LvANebSGTw9UB2uSE5OOhq6vsrXmu3RTKdhj0w
 +v5b1shqCqyAAcFOeRQ8NPD2ocxqJpU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610130039

This iteration addresses issues raised by sashiko.

The QCE hardware crypto engine has several limitations that cause it to
produce incorrect results or stall on certain inputs. This series fixes
several bugs and adds workaround allowing the deiver to pass crypto
self-tests.

The failures addressed are:

- HMAC self-test failures for empty messages
- AES-XTS returning success on zero-length input (should be -EINVAL)
- AES-CTR: partial final block causes the engine to stall, output IV
  derivation was incorrect
- AES-XTS with key1 == key2 is not supported by the CE
- AES-CCM: partial final block and fragmented payload both stall the
  engine

All fixes were tested on an SM8650 QRD board with
CONFIG_CRYPTO_SELFTESTS=y and CONFIG_CRYPTO_SELFTESTS_FULL=y.

Split the QCE driver into a core part necessary to bind to the QCE DT
node and enable runtime power management in order to allow to drop the
interconnect votes, and the crypto part registering the crypto
algorithms. The core module is then enabled in arm64 defconfig while the
crypto part stays disabled by default. In addition: the actual
registration of crypto algos is gated with a module parameter that
default to false.

Note that remaining reported bugs will still be fixed in follow-up
series. This series addresses self-tests and disables the algos by
default.

Merging strategy: patches 1-10 should go through the cryptodev tree and
be backported to stable branches. Patches 11-14 are v7.4 material and
I'll resend them separately.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
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
Bartosz Golaszewski (12):
      crypto: qce - Fix HMAC self-test failures for empty messages
      crypto: qce - Reject empty messages for AES-XTS
      crypto: qce - Use a fallback for AES-CTR with a partial final block
      crypto: qce - Use fallback for fragmented skcipher payloads
      crypto: qce - Use a fallback for CCM with a partial final block
      crypto: qce - Use fallback for CCM with a fragmented payload
      crypto: qce - Only register algos if the user really wants it
      Revert "crypto: qce - Mark QCE as BROKEN"
      crypto: qce - convert to auxiliary bus
      soc: qcom: add core driver for the Qualcomm Crypto Engine
      arm64: defconfig: enable the Qualcomm Crypto Engine core driver
      arm: multi_v7_defconfig: enable the Qualcomm Crypto Engine core driver

Kuldeep Singh (2):
      crypto: qce - Fix CTR-AES for partial block requests
      crypto: qce - Fix xts-aes-qce for weak keys

 arch/arm/configs/multi_v7_defconfig |   1 +
 arch/arm64/configs/defconfig        |   1 +
 drivers/crypto/Kconfig              |  26 +++++----
 drivers/crypto/qce/aead.c           |  44 ++++++++++++---
 drivers/crypto/qce/cipher.h         |   1 +
 drivers/crypto/qce/common.h         |   1 -
 drivers/crypto/qce/core.c           | 107 ++++++++++++++++++------------------
 drivers/crypto/qce/core.h           |   5 +-
 drivers/crypto/qce/sha.c            |  74 ++++++++++++++++++-------
 drivers/crypto/qce/skcipher.c       |  59 +++++++++++++++-----
 drivers/soc/qcom/Kconfig            |  11 ++++
 drivers/soc/qcom/Makefile           |   1 +
 drivers/soc/qcom/qce-core.c         |  92 +++++++++++++++++++++++++++++++
 13 files changed, 313 insertions(+), 110 deletions(-)
---
base-commit: 666d66df25253070cb297cb920b0bcfcfe5eb871
change-id: 20260610-qce-fix-self-tests-492ffd2ef955

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

