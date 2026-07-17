Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B55F42A166
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784303644; cv=none; b=NdD9XXDTK+gEte4VlTWsqrdws/iQcdD2w9VgpFB/oUH3gXthdVMGBlhdl7MtgC8KksbhnRnoTyShasEfqHJyiId9cOCK8eEXoMoIFKrq5zXZ8NkUJihoJplq9NlJvjERK+/fyPwDH25AQj4tkvQGJ7L9N9+H8FwE6MMwdy7Zl8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784303644; c=relaxed/simple;
	bh=ibXDE7QfYBh/Y3uVHmqj0Doeaz6ovE/rm9hnql1AQTc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KH6GCTk+/ROIYsRix83XHi7SzEWORM5OQbF7GDgjd98XPNRA3CNU47lx83D48zEZy/QXlRR+39tl8HLiXFhv7MzF212mKmXX3O6JesefLePBAKYteth7SGxIXwuL55cMiwFSUzxBQXKWJlgP3Z5rlsUaYx+wQ7tFKDC1mm67lwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cAG+3HTd; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=h44dsrLp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cAG+3HTd";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="h44dsrLp"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7ful3123201
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:54:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QYeFtj5+lSRAHCG4iElDvXo9CD9HgurpDRFCb9pO2Kw=; b=cAG+3HTde39xHBO6
	HCG6LoFcOydtjWSFSFHjLFtZ9sMBUmX55Loig1XKymrf05iso5UEVQTO8eHP+LoS
	fRfM7tB/6+wpkvPw6zM+4pyzew3P//aS5Xq4N0UitoeocK0Yj559NnkOeSwm3pTX
	j7EKeAxOS7iM8/+IH343KlpvrkYyn+L0/9wT6m5ZdLKPiZjn6/7SIp3uUbhSMD+V
	RFQgH24BSO89blYrfTO7wa7TqVxbTl33pa3v7cm1rJBLV3cxMZUzUKq7lCUmv0l0
	ubtyO3bvHembL3a7V4Jw/upHolryy+V/K5hVCVT20zYGPNPp5HIfJKFPvboYJLhC
	QFhv/g==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ff3u6mh15-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:54:01 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c2af04aeeso49777341cf.0
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784303641; x=1784908441; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QYeFtj5+lSRAHCG4iElDvXo9CD9HgurpDRFCb9pO2Kw=;
        b=h44dsrLp+ONA53vmxvttVBjtpx1iv0poJE/D+aEt2SfeMsyhSCjkz74ePT5NvNmvcF
         5vAgHir2ZPlKItT9m30BKHWIPZWkzoDQTzee9Ln/iSoubIRt0/JWRqKGjduBkAttVnAm
         DULz8aktv+yh1D+8O5aMPKVwJhXYHpXJ582IB2SOpLoeiIkMRaKRo6RdRukNBEt+fPLY
         B0T0kugDeODszMy2d8nuL4f/NCknMIevxpO1OIpq9pG1cs1G4rP8y8bbN6vhy23Y32NS
         val7WcbXfbhr/EZuPnf9WhtMSwpS1oKocaR38UvRjKTVkCXqx3z6pQMrCOlyaGygX0H5
         AnsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784303641; x=1784908441;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QYeFtj5+lSRAHCG4iElDvXo9CD9HgurpDRFCb9pO2Kw=;
        b=bH8dVI9mKqtNkyCdeRYWKho9EJQe4gh2MOO0Hxpq8aMBTMXlQKAfnhH9J6ogQdo27d
         veYzcl03lwUxw4muJXbT4S1SY9fFojmQVPniTze43F4O1wK2pgCR8XR2Go/azmhJ8q0H
         Eo+Gylmyeys9crNBnnPinHJMWLO2t/AHvj8zDZwK80D6SdT54+xUHIRj1Stxrqqgr0s1
         arfCB0PJ5mxeVoWB7ToCbYacaezsOdkKbY0FO7vAp7Zuld3+vZQ7nC2aNQ3HY8yCHpwW
         Ad5ENwSUwPOfc0pZKfyO/yICcG0Puggs6xMpiOswGucsXvwIos1+cMkk9gaYb88+L6Td
         9hYw==
X-Gm-Message-State: AOJu0YxrTVqe3uYlbNBKWlcgAQat7fXjRqanVxjd+liIVDvvAuERRC1j
	mK56CBRAva4SWhbYCjF7NKxAtwkYGdxeFulfoz1vth2l5hnlaN91kCaeAMZFGIwzsaE10/WhBTj
	xpylNQmwT07xcbMjQ+2ZV7ZDwwMoxvLZfRvPgiiPT3tzsWaRwHydkpRU5ireGrJa4LpP4yv/qei
	Y=
X-Gm-Gg: AfdE7ckYUKzC4zcBtdwpdNmaYyY6wxvj4Mndi4drSqchw59jruC/sb8RdDZU4DmxfDG
	W0sg1sr6D79E5vdNyNK5lZ1TVFbKwPtjoi99qlrOtZqmtNx8333QWHjYnYznJQKnZ+G7+QCB9rO
	IL5Kj9+hMuJm/rvPr5dhwbTXCrytnU2/H0ENwWl3KX4r3FHjIFyniPzxd0b4BVr9ee2raqeuplC
	I6qWkIbb++eAJGNwDssN1QkKcxKS27vwo3+KJU41pwpwFu5lrwA5aL1W+Q/08uw39P5S9pErHrw
	MKZrygWN2wnet8CM6mFXoYIfz/3eTvs5LW9d2JW64/FJIrEDdzf7W2ZkD6DpSNbdsqj4K510p/U
	yfbT6dHNU7/OsC1WwDMuCEIxmXi7ndA==
X-Received: by 2002:ac8:5993:0:b0:517:63df:91a5 with SMTP id d75a77b69052e-51fbfaad90amr75648641cf.19.1784303640635;
        Fri, 17 Jul 2026 08:54:00 -0700 (PDT)
X-Received: by 2002:ac8:5993:0:b0:517:63df:91a5 with SMTP id d75a77b69052e-51fbfaad90amr75648351cf.19.1784303640115;
        Fri, 17 Jul 2026 08:54:00 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dc44:5b1b:5396:79d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2a2511sm47057095e9.1.2026.07.17.08.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:53:59 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 17:53:32 +0200
Subject: [PATCH v6 3/8] crypto: qce - Fix CTR-AES for partial block
 requests
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-qce-fix-self-tests-v6-3-455775fe5f6c@oss.qualcomm.com>
References: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>
In-Reply-To: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3299;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=0wfULYDcviuc8Q42MEg50uyXBEFkn0s1U0Ju00N6IK8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqWlAKW2UNv3U6nFiQE9kWWZwPOg5OFCqB9H1H4
 cBzMP9CI7SJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalpQCgAKCRAFnS7L/zaE
 w+sREACcjpz5KVQ8zguYq9FygEPKgP9grRojVsv224aOD2JCnjYLqrHSuwud7NnoRKPDTZMfeoQ
 cKk22j+o8dCtLgMy1qq3CWCac+iOzM87yYyHVO1Lf9NSToohTC38lX3vPzJ6oCEBLCMXFa7/EhQ
 7qf6oIaqbu2hELSsijr5qj1rIMefDPN7xbnUNBkBn9kccfmEX17eKbR4Yv+Y0Y0vpQB1Ssh4wW3
 K6OpBotd4jZjAi2Sq/nogkPJohCgFeqe6vhJ2uf9gL6Fb1Xio5VQK2vof0//teRhxnYDSV3KWhC
 /3TLW7IIZbkKGlAyDzsmqtFhKfPie6jjBsQkQp0t4qKblQISsbBnxgOah0bgZmsUUF4N5iDolxJ
 yccUaf/b4WsUDytJLjgU8UdXbPKx8msAuB1L6sT49orf1E3qsX5A5lqAl5qhex8yjAf8JA5BRUk
 pNpjdkDOYRvOqCyvuWBsyxSVQJy1p6Sb/DcZm7NNOD8fWNtkJayB1ARMb8O2MwKVhddxbvT8gxL
 ffBs7wZMvkt3HabS6U3DXfHS/OWNwSNZfl4VSVklzS6aEJYwLbTyFb+HC5lHYMp/5bAN8aIbZws
 G3Nz5o3u16yQFxaALoXhGSW4Eqb40/UW3uR3baHBk0r8E22gO5x0uaPxjm0/9pT37p7WdurggxX
 pAdgi7OlDS4ugOg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE2MiBTYWx0ZWRfX3cgxgxBSt/2t
 6pJXTldoSYcljpNVhosW36tGM5/67qjKAkOH1P6m5LOoj9cUSBWI4zLrR9AWgalg3adPYeontDt
 nzxzN3ElInEL0pwzcgRenuZb0KNhJxb8GSu7aas7LyKLhNwqSDUL3WXiFDOkaxPozg8vAebQQMz
 CLcnt6C+HEzBywl+BU8zyoPSXb1sG0UVoJBQs03+sRHqPk3LdjoYLmcYUsjQ0dgFexbF9/g6leg
 h6eJvM8o3ty+PrLqilKk5TTfMTgmbRralcUwmg+3cLgpxfNaA0N9cGfz8lV82MUvQtWhxymRyrn
 QKZqnI0VfF2yyI/cnTGHbLniovsoTOtb93jYQGl044Pge9aIlw8oxm4gFdNUmPB9fDwUuXI8rS8
 sv8ymt74stzCjhprXwYzdWSzX2mFdc+l0ZU8at8cJI7L/aFUcgxQTlQJkV51fcUFp9Q06DGbEme
 NBZHeVgtpHfB9uK6eUw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE2MiBTYWx0ZWRfX2CZecvtIsCoD
 +4M+o0Hg8zHcMZkPCNysaaVvtRvBdn1BbEnxvkv0z0OdO8M1dPBXufyaMIISyjohRjudKGxmcEK
 q5KDLAvxwqoJsmiwPr3AZZvpM3FMsiA=
X-Authority-Analysis: v=2.4 cv=DYMnbPtW c=1 sm=1 tr=0 ts=6a5a5019 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=Y2NcAOke46LZopEJyX0A:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: -G4EOVtRtmdfPoTcAgGGkmXompn-uokR
X-Proofpoint-ORIG-GUID: -G4EOVtRtmdfPoTcAgGGkmXompn-uokR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170162

From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

In CTR mode, the IV acts as the initial counter block.
APer NIST SP 800-38A, after a CTR mode operation the next unused counter
value is:

IV_next = IV_in + ceil(cryptlen / AES_BLOCK_SIZE)

The skcipher requires req->iv to hold this updated counter on
completion, ensuring chained requests produce correct results.

Referring to Crypto6.0 documentation, Section 2.2.5 says:
"The count value increments automatically once per block of data (in
AES, a block is 16 bytes) based on the value in the
CRYPTO_ENCR_CNTR_MASK registers."

QCE increments internal counter register once per full 16-byte block(for
ctr-aes) is processed. In case of partial request length, the hardware
uses the current counter to generate keystreams but does not increment
the counter register afterwards. So the counter value written in
CRYPTO_ENCR_CNTRn_IVn later once read by software is one less than the
expected value.

Crypto selftest framework capture this scenario with test vector
4 comprising of a 499-byte payload (31 full blocks + 3 partial bytes).
Error:
[    5.606169] alg: skcipher: ctr-aes-qce encryption test failed (wrong output IV) on test vector 4, cfg="in-place (one sglist)"
[    5.606176] 00000000: e7 82 1d b8 53 11 ac 47 e2 7d 18 d6 71 0c a7 61
[    5.606192] alg: self-tests for ctr(aes) using ctr-aes-qce failed (rc=-22)
Expected iv_out: 0x62 (iv_in + 32)
Obtained iv_out: 0x61 (iv_in + 31, partial block not counted)

To fix this, just increase the counter value for partial block requests
by 1 and for the full block size requests, don't take any action as
expected value is already returned by the hardware.

Cc: stable@vger.kernel.org
Fixes: 3e806a12d10a ("crypto: qce - update the skcipher IV")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index e1f69057607fac36e8b4bdb5dd9e62a2aabe5f50..35ddbe03cfcd75db7599a5754e4ff978f3528105 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -33,6 +33,7 @@ static void qce_skcipher_done(void *data)
 	struct qce_device *qce = tmpl->qce;
 	struct qce_result_dump *result_buf = qce->dma.result_buf;
 	enum dma_data_direction dir_src, dir_dst;
+	unsigned int blocks;
 	u32 status;
 	int error;
 	bool diff_dst;
@@ -56,7 +57,21 @@ static void qce_skcipher_done(void *data)
 	if (error < 0)
 		dev_dbg(qce->dev, "skcipher operation error (%x)\n", status);
 
-	memcpy(rctx->iv, result_buf->encr_cntr_iv, rctx->ivsize);
+	if (IS_CTR(rctx->flags)) {
+		/*
+		 * QCE hardware does not increment the counter for a partial
+		 * final block. Increment it in software so that iv_out
+		 * reflects the correct next counter value expected by the CTR
+		 * mode.
+		 */
+		blocks = DIV_ROUND_UP(rctx->cryptlen, AES_BLOCK_SIZE);
+
+		while (blocks--)
+			crypto_inc(rctx->iv, rctx->ivsize);
+	} else {
+		memcpy(rctx->iv, result_buf->encr_cntr_iv, rctx->ivsize);
+	}
+
 	qce->async_req_done(tmpl->qce, error);
 }
 

-- 
2.47.3

