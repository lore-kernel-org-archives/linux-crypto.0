Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BFF319867
	for <linux-crypto@vger.kernel.org>; Fri,  2 Jan 2026 12:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767358225; cv=none; b=mmkV0KpmBIjuCDzXOpUSM4Fiu9YF5Ej1rdxMK80/PhWTcOkZrhxcXlaC8zrTnBhnJtwosfk6FSuKeEjT9d+eopPti2i/CZQToed2Uo7KGnMhn/FivygWWz6fx2MXkWDfxMCvkOFKtQyhdnMBZnWi/UOXLF5zV1L1KxPX1yXUaBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767358225; c=relaxed/simple;
	bh=32AVBjNIZSbnQ1lMFE+q5NxKqJrF1QCwSRIjqXPnWLs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lVQwXl0WIgNkhes47iHx8W+kUqcHgGi39YLRWNcL5WHGuHWhD/mkg+mCYoXsA+53CoBGG26Di9QN/xLFkAsIB5Kqr7R1+RX2wqoJKvPV6gPdTcNS2Xywn9nmJCJML6chiJIZ1Sh2LSQGCOwienfmU3bG4+YJWeFq9UTihoHicaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Yvbx/ZAG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=C5Lz4Fc1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Yvbx/ZAG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="C5Lz4Fc1"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6029VxrZ504513
	for <linux-crypto@vger.kernel.org>; Fri, 2 Jan 2026 12:50:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=0NidQapPj0vF7khahdXKPN5XD/zytpGimrr
	QFhYOGsc=; b=Yvbx/ZAGCsTFRfNO39rnPjI2HgmNPKqr+4XtS1jBBMS01VYrEST
	pSLNy4ZcROJk2DsFz6CIArveheoiWqU8MgjWGyiqRw10DYuMZHDWYGa6jo6u6PW3
	sGKAVPGBPRZdo2GI6pRFKrQMT4JlG52SGH3H9DGzZ3KH7wgRYvwbG3yE+63b2rIV
	9IugnDoG8dR5jyU9XcdSNvd3qZuHAjKGS89R0DZn8yIhrWr7kJq3atEfJsAcY4f4
	HjKSY5WoJZIumC+KBA1MBn3EyuZ1HVvS0C5gSepn2aokelKeOK26TZO7v0hmrJ5+
	ZyLCjZT1FSI7uah3bbBi7rJAqzTElOsBwmw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4be8bk8qkh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 02 Jan 2026 12:50:17 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4f1dea13d34so298236101cf.1
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jan 2026 04:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767358216; x=1767963016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0NidQapPj0vF7khahdXKPN5XD/zytpGimrrQFhYOGsc=;
        b=C5Lz4Fc132xq4BaSW5hJDwUUAY/+owXnKxpqabev2PGexeTXbatT9voWWUkxw2bXnx
         V6N65XEmgw0vhKWsFRj8xuOcaDaRfSYrJYLXCWWEEchBGXs/qQWOQ+qOHNq7vTJ3dScG
         A54bzHtkmtgIg7+Fz0v2GPL6MjjkwcSvYJouXzHZCRqbjYdx0cy9QjgEN3TLn80BryhM
         tPuVZrmlZgGk0c7EJJF0boPwJlXxCVsFxGILHA9Sjrlj0NU9HZR0mMh9ntyXs1lt91H3
         amYxZQQS6jC0UyugfD3puo38qvR2Uit8Y6XTT+T/hWwwdZUeaBF557jI4a+LJMF9yAXA
         LH/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767358216; x=1767963016;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0NidQapPj0vF7khahdXKPN5XD/zytpGimrrQFhYOGsc=;
        b=dJozCp3qArkQlOrvSLweTlhrjWXzxj7UIl4pTp4fERLSvPlGJsPF1jCl8rzDxOnz61
         ji9y8B0v/9qtPLG9Nu18Oi22tf7Niz8PPWWxv/YGko56Xu4XwTruWm0jxgkXwT5hm+/U
         Wdc7VsfW91O53qXEkkiQY/YhneLiBWI24h0XHIEobAs4rOo/N5JlKAhXymEID5zmDA6C
         fY/Y+f7EvvjeyxeFUevIjerzhBai7kujGQmScYD3CXmMnoLeG59kg+vqy/ctppXEHpJI
         st0iRDQFUBFEjgJyJlxvWidphEExxsfzlvUrgtk6AK44P9h9NMqMh7V1hbR9MN0crhk7
         Tquw==
X-Forwarded-Encrypted: i=1; AJvYcCVdeIy1joyyS/fBbw9d/JLeug+D4+5YQ650ipdFxF4MKiBIbUtF5JmDlq+SxLaD/I7WPxGbgdOY58ytuXY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yze6RAsAS6zJDeUwiJtdPrnvRk9DK9U4aT+/LLHFSUnYzaLMT9E
	oS5PCblr1lP9wBIe2KcYv3P3wGSGZYhW+mKcb1lf5W6rY2XbWMfkAWuq9KrR3Tze13ByNStfqcu
	sub0YDuheScPiIJd/fSZZ/wpyjgGuppAUWELlc1SSGf2KgF0aY8BbAfloZf84bkh4GPE=
X-Gm-Gg: AY/fxX5iq/bwXMdtT8wer7sc7NqI3/2IbE6HxZnrQhxugPoiRbQSd3tcLPlKiQLTwzp
	zAXEgRVJW82jVxnguLgv5QHIndDRQjo0J4adLAJVdp/R9oEXxYQIVJvhcVUteGRfDKxUqaGAWX4
	oSFyySMWwGvSzJ28Y2iQcu2kvk3+0JWeovJk1+jkABYOY4xt440b2J/cLSPb2312IBSto9bFoo5
	Vwvu1aPqAC/rOD2tabUwUuTdlMZMHQuvckMgEfZ2ZphTt0OnH/KxTpDkVbjsp+jt1vsVakeAJbz
	HoP8AvjLtDgFzxtlAzHQRlgpomImUEsnxFm4YExpYJBre873ZB6KsQvINmY2XyVPXo9hSS90HGO
	GStM7BkaAAOrLIZNQPBUpxk+26g==
X-Received: by 2002:a05:622a:244e:b0:4ec:ee04:8831 with SMTP id d75a77b69052e-4f4abd9704bmr622880171cf.57.1767358216154;
        Fri, 02 Jan 2026 04:50:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZroyk4dZoidsvWCtxksXf5hWfSZlyALC3sJcR3OLOMElYO4++Ki0GmKuBczZXqaZzMxf7sQ==
X-Received: by 2002:a05:622a:244e:b0:4ec:ee04:8831 with SMTP id d75a77b69052e-4f4abd9704bmr622879791cf.57.1767358215751;
        Fri, 02 Jan 2026 04:50:15 -0800 (PST)
Received: from quoll ([178.197.218.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be279c637sm761217975e9.11.2026.01.02.04.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 04:50:15 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH] crypto: nx - Simplify with scoped for each OF child loop
Date: Fri,  2 Jan 2026 13:50:12 +0100
Message-ID: <20260102125011.65046-2-krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1337; i=krzysztof.kozlowski@oss.qualcomm.com;
 h=from:subject; bh=32AVBjNIZSbnQ1lMFE+q5NxKqJrF1QCwSRIjqXPnWLs=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBpV78DvvtQD6o7HIdIvtmHcHAjqMVAIWSqPv3i3
 Hale8/Kxq+JAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCaVe/AwAKCRDBN2bmhouD
 13J3D/9UoZMNSE/VYBdydsfJ43pM4wLITOjzKZ5oTeVGEkzTdsY7AN2cjDZua8CboOHHiqIiLsa
 0ZF8UF+5jvY2s5zLLjNyiPB6Cu5RmpuLN5QFhAMeMc/09sQRWXuQoI5Vosg+M0yYPf9PWdVT4ZY
 fzIGgLS1+jwtNz5DxzSvO+WyyakRAzgMx5uD9pE/ONue3OuX80ZAqJ8+p9tccFfCXjSGl73YShj
 RptcMAwJ2XQ5DEMk0chQMNEOINakJwzzN8LL+eQCrJMc+4FGrzbO0RQVi/5/WhDFtQSBg8W+szL
 odaxqa1ha9hDBvjInvUxGsbnEaDPZLGBFWzMfUw7RYW5aVfciMFcPS+kOMGCqbOxufItDesuDCn
 WXuozb4uy2NSYLBFHccyDYzWqfmaHz75vmsVK7XIKoDLNb5xq99plUveK4Fvui/856r2nw14hPq
 XNitQ9fT4JyCuNWqdCZiM4XO+xyut54DRjYW/ZHGjLKF557xR3RzPQbcRvcIZBOOkLWRYXaal/E
 Eqno500XaozXzvAiC0WJ/3NxKj1lQUR3zNxWIW0xq3HETiIq8haORMK0K3ZDiwNA5SLNR7IGI1Y
 cG6oJBjBOQTifbe83+KI3rKU8ky0nTooJDYnZPWcqQZz4/9WdpBiC4FGmLW3rcLSYuxRrR7spd4 pLBCah8g5lRE7Jw==
X-Developer-Key: i=krzysztof.kozlowski@oss.qualcomm.com; a=openpgp; fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDExNCBTYWx0ZWRfX6c4VBv8RJDq8
 aYes7u16+cvoqeiCGLXOjld/UlSdODZRlXwy3AueFJ6Le/C1XFZkljOUN4TIPKOmBV7MNCqxFih
 jNEeHkXuzvwf/Yg3mkoweM77zYSLZp3WmGPJF+Vm66Dsdgn7hyJ/KqjUJCseusu+mB18aqJOXjB
 qkhEDq8aeRBTuh8+pi1NI3U8i9nLXv0tDkCAdoPtrHn8RRpI/lb/YfeHrs3zigdM2Dt4uoQgEPI
 ZjRKAMNaSnDqAhpvJNRlXO4vDBKD9v3YV93HHnvl0v6HIf1/erv7Avj+Eq6UCYkg7Dv36PEy6X6
 5r5SvDrMJSmxFU98t2O7KQH5KN/Tru8WVUFc/AzbqB/5ziv5oQcCmYdefMJEquUHUb2YCpMx8Dh
 3ZReXISbwTQQ0bVAYkIYj6z321L4Bam6HARt1365ABpmu2VEBcqpJBVMI/XrNeiJumVVv7kvIe7
 VjrWpPxjYbRTQeRaeAA==
X-Proofpoint-ORIG-GUID: bTQgqK_hp7Fwp_zfYA7Ls3Wy30-xkY0I
X-Authority-Analysis: v=2.4 cv=d5/4CBjE c=1 sm=1 tr=0 ts=6957bf09 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=Eb9f15NH/cHKzfGOmZSO4Q==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=uaOs0JZUKPQsPhfDglYA:9 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: bTQgqK_hp7Fwp_zfYA7Ls3Wy30-xkY0I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-02_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601020114

Use scoped for-each loop when iterating over device nodes to make code a
bit simpler.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
---
 drivers/crypto/nx/nx-common-powernv.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index 0493041ea088..56aa1c29d782 100644
--- a/drivers/crypto/nx/nx-common-powernv.c
+++ b/drivers/crypto/nx/nx-common-powernv.c
@@ -908,7 +908,6 @@ static int __init nx_powernv_probe_vas(struct device_node *pn)
 {
 	int chip_id, vasid, ret = 0;
 	int ct_842 = 0, ct_gzip = 0;
-	struct device_node *dn;
 
 	chip_id = of_get_ibm_chip_id(pn);
 	if (chip_id < 0) {
@@ -922,7 +921,7 @@ static int __init nx_powernv_probe_vas(struct device_node *pn)
 		return -EINVAL;
 	}
 
-	for_each_child_of_node(pn, dn) {
+	for_each_child_of_node_scoped(pn, dn) {
 		ret = find_nx_device_tree(dn, chip_id, vasid, NX_CT_842,
 					"ibm,p9-nx-842", &ct_842);
 
@@ -930,10 +929,8 @@ static int __init nx_powernv_probe_vas(struct device_node *pn)
 			ret = find_nx_device_tree(dn, chip_id, vasid,
 				NX_CT_GZIP, "ibm,p9-nx-gzip", &ct_gzip);
 
-		if (ret) {
-			of_node_put(dn);
+		if (ret)
 			return ret;
-		}
 	}
 
 	if (!ct_842 || !ct_gzip) {
-- 
2.51.0

