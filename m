Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783CE4B827E
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885502; cv=none; b=d3ZKmrCJWeZHole9E6sCDrLKV47jGy/PZxzLDAceRka+xhIr6RGgPQqnD26tENwQ/8cUnaIeE/iGey/CO1FfLaZRrB16MWm6VFQnQoDgSFC5pshvYtp5aKOOJK7Rpqie6zLArpYbsUeQNHolYemZmhqBL8VwmCgePzd9Od1010E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885502; c=relaxed/simple;
	bh=EKtM1ReDBXz0qFhsomvF2hYpsKSPwG7AL+SgEjlwr4o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lT5YXRsKHP0r3EdO+DuJsWh3kXofQCgGSN6lA6p2iemp1/DjxibgBEEMho1JJ0+RGo97qY2FJ2FN9bmoIDbFz4blbyNg4mMHPmI/dTs+Atr0hpR0s//aGWTm8JheJfmc5iJN1r9YcBhSRSAF9DQwZpP0tpkxV6fQHdxb44+6kCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ScbbaKlY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=US8MqQt9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ScbbaKlY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="US8MqQt9"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D9cm2X3475941
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	j2+raViPP3oUUTbnRuWemU8HTLd1odDXtpq6Z53azs4=; b=ScbbaKlY/WJbg9al
	3HGeZHZNGMsO75eoEsVbaN+zvHRLiSaQcgtV+pKSxStmt4C5pHr0SECbPYotpKsi
	siB1jS+zIiJJ71n4y39ArZpKbyahZuebdM158o1aAfeuXq4P+idtxawnvNBuNm7Z
	QUF2JLVKYrlIsYcs0MhQNzACOm54x6LhZlDj7qPfSO+w5F3BgRwJhV8gTMw2Trbu
	KhujpEmZ4HGe3BemZnm666YYKsN6NettgjdsAJkpgwsEF7tfN2DtC9OxQS4IcCYj
	qirpl+xW469/FVrhN+b2yS1K06D2VuKzHIyyh9kaIxNmurzN3yrbeErYZLHyoSvJ
	L/ZigA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9d7j9d58-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:19 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93ae8e7e546so583424585a.1
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 02:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791885499; x=1792490299; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j2+raViPP3oUUTbnRuWemU8HTLd1odDXtpq6Z53azs4=;
        b=US8MqQt95RottaZhzaXjkt1s7nJAZ3HnXdyABxHqmgel7dj71HKxUopo9ojtiOf+2G
         A65lSjrsp3Hm8b0C2doO7n3BrI6mOrl/0JO7hfMgP6gqstLw0mSztlnh9CDnYP7/wM7v
         ch32wYgbZxmBzTgK99+3esJaqb+KGigWpgwcyFl/zCZA4623ZXiKXm/pxGyLDylI3FQQ
         CtQq6BTS/xp4MMye5L+nJinYv0QVvzarrb2f0RwUTmmfOP3KqxegQ5McnlCfaK4zB+TP
         n9UtAM1Huv3u6qBzig9eNWyrWU3pJzgD5WKlicnG284As2nvcUlMfvFMV8mCvx0Z+MjM
         qdrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791885499; x=1792490299;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j2+raViPP3oUUTbnRuWemU8HTLd1odDXtpq6Z53azs4=;
        b=078jr2gGhy+rE/lf3hCYkV9fPc/weoV1hEKunFO5TQgOnJ2oxGU7gnSQxVy9XqZGij
         l7tnGCDlrsCcHcFC2gJ+i5OKPlsG5rO+GBo1maZFWpmaHJkcUv+rLqumgQmb34jPuVT7
         4wmKXCLJLemyTn4J/juCvKy5yzoxYCp7ReXkBxxRMDbo06KTGknvCEu755ah65QMxoRH
         MTB4r5ZGmhfpb67QZkKFd661jOxu5n9kNQgMHfvXeA1plsYH4Gz9KLp3C73Ky6dlISvN
         Fw+OO+DAkkjGgfyTBhZx17wuXuQ6LhgPS3pm9KIHtqLjBqrnR2VCxXrNrzunAGIEKRg4
         59Pg==
X-Gm-Message-State: AFq9FYK5nWy3FhqTev7dfmUp2zxndfa943eCoWx6W1XOpZvkaKzvlMPM
	1Aoh7o6aPEeWsnprfabQl8KNadYrOqQD6AZewi6BJ8jjo+fNGhfvs/KB6PsvpeAtwrR87m8JVXs
	VQcatDzXV07AuDHTXhMc+J3LGeRnPs07It+wEUE8Jc6i6495U5BLSq3izu7d3SdviDr0=
X-Gm-Gg: AYBFou2yG2SuC2cx2tprO2i2npuXreFA5xQDM0c0sTw3rU9g1krUgHagBsN2Rr7zyqv
	Rp581UWXhr2tPBbruQai5ksuFkJAOPuyd92RsAs4ymCfJU8NgmTr3C1gQv8C5lNA24Lv0X+V1bl
	X6qM0w7rdbfgQDTPVoJ2KOILCZga6YBY69QoIQ4t54thu7OeLKhI6TiHXrGc+cM72fyMY6hZcKc
	qmL4gdGMhKdKbS0Xb7BTUtlJCDUzjwO7hzj7BtECpLkhdCXuP0PYjWtthEp9w7gVQXRR+jV1WUO
	ku38JhI/GlROrRwYRda3peD8zkoFBVfHvxCXySzX+LKAi2dAOKuGvictLhNiaEOjr9a8DmymC0l
	0rI6upkr+Z77I4ZfkssjbklxAN0o2
X-Received: by 2002:a05:620a:890d:b0:93e:9627:533c with SMTP id af79cd13be357-93ebd265157mr1839630085a.50.1791885498619;
        Tue, 13 Oct 2026 02:58:18 -0700 (PDT)
X-Received: by 2002:a05:620a:890d:b0:93e:9627:533c with SMTP id af79cd13be357-93ebd265157mr1839627285a.50.1791885498138;
        Tue, 13 Oct 2026 02:58:18 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bb6beaesm209412025e9.0.2026.10.13.02.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:58:17 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 13 Oct 2026 11:57:36 +0200
Subject: [PATCH v10 07/14] crypto: qce - Use a fallback for CCM with a
 partial final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-qce-fix-self-tests-v10-7-57162a38a554@oss.qualcomm.com>
References: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
In-Reply-To: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
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
        stable@vger.kernel.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1679;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=EKtM1ReDBXz0qFhsomvF2hYpsKSPwG7AL+SgEjlwr4o=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqzgChmTz5vlTcgTqMWYmz8l/ZOHfRBfagEfhK8
 5WgIF/kvZiJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCas4AoQAKCRAFnS7L/zaE
 wxLrEACJEdhFtig+pc/1kwrh2cYoM+tGC4xjnIIVhtJ1BRUIgolI1fmJUrI3jPQlA1j+KaK5C9h
 +CRsDSDIwVCAHNHIp9nh7SeJpHAVQJ8c9AQhwUZzT12/csduaZe2/z2UDiuHkjMe31VYQFwXGjv
 tqUZQ5cqpK2WKeVK7xukJ/k41c1rUXHYYWeLxxDjyP7pDHzhZl5OUmsGR+cP7VvK3ITpS4STf2y
 dwXGGng7VyEiifRwkI1N1uVeThcNBa+YMy/KmZ0XLc0XuQ0L69BVtgttaqw3+BLGHEJzFGC82fn
 B71Kn38fefC4NItCG1YVHLLPrfiSxNV8QdZACN18blHjc1j0hEP1Xs3dwhl+SkSsLXvGtvozp6c
 PID1UYyK1wofzaWY16Taw4EIHtrxowLCXL7s+kqfYixx57iSwa9c+a1pLZGD0KBC3nsWuBA0a0X
 IwS+A2DmKIwS0IqFQs+0KzIFyv08sW3jPMXtwxTVUDpa9HwfiJvrxkxbPyxdBKD6HstbySHaPlm
 8NyD+esHywIFTNn7JN3z0eXTNY4i+N/B/ZRJ07BjQYXd5Xigk9ZlA+fMo3akY9W7GMkGox4Btsf
 NkKt5OTOaCkvNhbklgTytloYHk7QtNfAKJSn2vbskvT8G8aggK9HtWwhcDja0P+u5e5jKQJB8p1
 UVLiDmVBvOaxDeA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: NRizq3aEbAkWVGMIpz4DhzebDgobBuFX
X-Proofpoint-ORIG-GUID: NRizq3aEbAkWVGMIpz4DhzebDgobBuFX
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX/0C9J4Di+OOZ
 ZXXiakbCJkaU9rjoWAUD5nzWIK59wf/SnSmEAUXuYPaH29rYz8kb4XEfgYZQ/RAjzm6JgXTvVYz
 8pGG6gwKoVrP/6pS9Atf5iCVpjuKCk8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfXwKwjG3vnRMzo
 jh1OwL4o4nKtRz29vhMcouWLryX+Qv7L/TeCM9VnMG/bqldOkyfNCA6oHMGrWEyt5QbSqf9nh7I
 shfa8Wm9LdRCNnWbcPbdGrKqy/R1KVL3rfy7KoxFH7swD6lEbt4UpkC4ciSAvigzKbRieHpaTBE
 +/fICoMT6jkanR7BPXsVMShBgAwIJfTCxB+wtffXBikaPQrzBfgstdGkTvZdYcopPoUqV2F9RnG
 7Y03YYbmoQ4UhoVNJXdfATk7WoWdaP+JurKpunRfUi4FkQ0+CZkD3NUj6zPzy3XwB/7VTmDDsIA
 873iYuPerrxbgG4/WJ71euLaoUg3tEkC0KuIkxD48LHl61m/WBvo3TiarJJUUO658fIlg/G+aoY
 FbDOqJJuqWOykeVPjPbDhQB5BE/N8e9PGTNEB5c4tt7PYH44OD8EaW+ZdrBACYnLnSd0XpxB+TK
 auUe1uiAU+jHoNgS+hA==
X-Authority-Analysis: v=2.4 cv=PMGaavqC c=1 sm=1 tr=0 ts=6ace00bb cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=dx2SfONCXZg6tt9xEGkA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610130039

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
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
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

