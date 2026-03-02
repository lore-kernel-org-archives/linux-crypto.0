Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74CE423156
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 15:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467070; cv=none; b=Piv0Mvwbl/NsQKPSJg3j2r9nYQIinraLqHTWPc7Bzfas7SIB6R49lwZ2XEH2d0R5F30tmHJvl7GDuUnCsmPtXDrKtuQqovXXb83Z+i+kRXkUPAdl+fXmv7LWP1JLIvGFpGiSRrTujymta8FQi3aw7ELzfQqoku+4pJYZRKEaQ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467070; c=relaxed/simple;
	bh=FnVBtOe0OnnBy34d5WsqwWSUvkeiYQ93/vJc1qwp/2M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QGXTBknw7zCzW9oqnWQAiAh+yZNuFniUoyVspHTeglL0kXHMAK1HudSzddmyjciLS0Hg86YOSfOr/VxzCp3vEicyo1rtzdhJtuFRBM+Cx8/iZsIJlAUonRxm2sOpdH7Lsz3ZAR6dTjHV9TlFhmNb9RGcxCrCLJ20s//2McN8Au8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jAarcipw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BEGguL+T; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jAarcipw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BEGguL+T"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6229ErRi3630818
	for <linux-crypto@vger.kernel.org>; Mon, 2 Mar 2026 15:57:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MnBQFcKPOgFHzTGJJB4DToRykxT+JvIdZWyKHEJZL1c=; b=jAarcipwtmxwc09a
	HrPau+DA9YlTx41/Z+j1BH6lVFcepgZR10u6NW3BakceYuc6gQxPYuTPbeD43jmz
	3KkVB9o+aS5Dfw5ulD8f5idazwkcbWFQ+bptal6szPs2SPbdL9M0uuSloY94eZ8z
	tQOkkrXZsZOpmVRhojfQlRgDifleneM+5qvda22LIk3LvLVAzEK8h2b71jo342m8
	dhRIpQmFPSl/Pau0bTYri0OsqPLjpLzjc2Tqt9gPoKjVVPJ1NF/4KbbwGZMzldcG
	gMa4rlEtMGrEMeU7wtUxmM/VPuKXRztMQHPhJbKHv8TumIpWTCMhgptbBc+Gm44F
	UT9aTw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn7rhsc8x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 15:57:47 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8c70b6a5821so2905129385a.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 07:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772467067; x=1773071867; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MnBQFcKPOgFHzTGJJB4DToRykxT+JvIdZWyKHEJZL1c=;
        b=BEGguL+TSCKnbacPD+njdAYu2Fs+Li+X4Qh66cJWdMATE8NzLAMwDdxm5PyuVlX7Vl
         ILZnXPQWA3Z78C7CSN+IpZroufSG2+Ps7WLwfqiH/X90pJMVd0VR2XbVB2DxrZyClZtx
         455iPPHZAIBJIk6L+/MQb9grUF7+dSx+fXjei8DuDEgCfw9RQlK2GHjn9aSjpCMlEZS8
         BhjBoadJKmVXsc0XdL5kXw0MVhcHJ0jatoMHpv6wT4kkGrnHVVDTHmIgdML/Q3hrwJ/k
         MuJNP07rgjaRt1vt3d5jYCPISwCrReNTvrNPeFcSqyfH9WY9qb969cahXP+ye782/kAT
         /7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772467067; x=1773071867;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MnBQFcKPOgFHzTGJJB4DToRykxT+JvIdZWyKHEJZL1c=;
        b=JN5cOMKO8N/iAvCaibybQVVslZsn8nHnCt36hhJiRfibsjgCb6Tk4VsBQrfDWBVr+r
         hnUBCAJaNoEfw3tH3jEYlo8TB58TjLuMEhflnutyxpOSjHTK++kB+iiEUmyVpMue0Sjn
         UkUtPTMFo33fcmVmjEr2yFzRSiIwPtsMl0Ohc2PMmwEm26H3obYNWgjpCPuY9GGvs8ny
         Ey27Sx++EOLIH6A4yy6IQm7h13YqdINuUD065gFS3LuT7iH2yVGC9IrXu6HYO9lGXnMb
         smo1/NRQQoe7aeK5q0/aKdb1wdObSlgjJOn2cbENGZJ7FyvVyhqKTY+9U5F7OFmgvygW
         FZig==
X-Forwarded-Encrypted: i=1; AJvYcCUPAEI3UtxClPSbAWY9XsZtaPrCZiSM5ON/jyipbqWHO3/c85JR6BsUdMGyPjCA5RX8sdjR7aSlkwvgYL0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbsMHPSBjhMyeLRnMpA2L8nkJP+pr+IrhvEPlIBtDw//lIRP/F
	5qPU3ZTvpGMaYg/cdtPkJOUKwUDqAYYctGsuxsCqwUQgTxr8y8mqn2h6SAzgym7fMotvh+ueYe2
	k2p/ZtD6Kx98qAMUSIQbue3w0T4do8JOnT0t5UZAA6ngSnK/N2bDcgQRiYZaj6wrsh9s=
X-Gm-Gg: ATEYQzyDTGEYVkJcpgKpVY48qgpVlvBiO2d9xNFUG4tmO6eDw8DTXgYXHf/tnMrMzNd
	TticUYLX/GK1Ctg3Y5Ida+h/GYN9jW9WywSAF6BcBnWj+C46sw9/xt8Vbxd88sUw3MGXnT8M9TZ
	mlkPhNlTtG285aVQH8rKlH//0rKCzq3KJfKcb4YhfxJpDaKlSZnDyfv/GoWiMqsdLap6wOEqRgV
	S3m8O3oz9yWRf5Ao+taaMpOkyS7P7MBqS2AKCNCLNEsV9va70MYmvlLxgItsN/mnY6jRWmSt7E3
	/x7rbcQDgEX2ac6NLY8d0ZHd5aP03fvOTGdhLDbmPfdfpHoYYNOVBEduh/atEZEyhawZtdXvd7r
	bmZILHAW91PVnTrMEmA1OW94+1xmoPqlBaDjNV6esWnWQMTEaCse2
X-Received: by 2002:a05:620a:1a28:b0:8ca:123e:8196 with SMTP id af79cd13be357-8cbc8de8546mr1626712185a.53.1772467066912;
        Mon, 02 Mar 2026 07:57:46 -0800 (PST)
X-Received: by 2002:a05:620a:1a28:b0:8ca:123e:8196 with SMTP id af79cd13be357-8cbc8de8546mr1626708485a.53.1772467066472;
        Mon, 02 Mar 2026 07:57:46 -0800 (PST)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:87af:7e67:1864:389d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b41831easm11282438f8f.12.2026.03.02.07.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 07:57:46 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 02 Mar 2026 16:57:18 +0100
Subject: [PATCH RFC v11 05/12] crypto: qce - Map crypto memory for DMA
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-qcom-qce-cmd-descr-v11-5-4bf1f5db4802@oss.qualcomm.com>
References: <20260302-qcom-qce-cmd-descr-v11-0-4bf1f5db4802@oss.qualcomm.com>
In-Reply-To: <20260302-qcom-qce-cmd-descr-v11-0-4bf1f5db4802@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3159;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=gRGqUxioVpJcY9zBfeIZn1vIilzfanwkfyseaIOaQFk=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBppbNoDslcDGElaIAuZqmx28V75+Ght512gj9uO
 9BTyLYxQoGJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaaWzaAAKCRAFnS7L/zaE
 w7KfD/9BNxHL3nf9PbluMpylf2ev68g/KfEFzZeeTiPet/o+UvV5i0+4a0Qfj/vCdJTSNJREmRP
 REp30vj4p6T6SLQzbZwAUS0SVyjTlWlcHvqv/R1lANqL8DUysFR+1f9+wJskMhwpUoFRuZHCtEi
 iftJpRpd667KdkazXCISt13fJ/32FARqxK1iTWUQcs4OJah6ReHGal34HphX+Oj0AZZIvI/jKRx
 WD5rk0pfsfSxUnNPxzwTZWQL+UmiJg0ipnOFGsh2pO8mSkiR3CEcHqPUbOqACMRrQvT39J0jlYG
 rnXGeAHnCyRY33edRQN6k7nY5C/zdN6IlAavw5egTuYHZ97LOqPT1D2l9tlhiBC+fF26f4A6pOl
 +p8WUhe9ZNKYMQ9GTOUEzP2Lu7pXC/sXi9n/YtKeXDauC1gzAjBHm2W7WhgaKzNfXDprJS6cWGq
 IRrNpy1l6nJ8GB3DrNzQCVSrxjnEE9dgpNWiO4NVzdW3lDDVBG5W7FRoA9brtGvu1xNrU/Pq+Tk
 uXvURGBIyMEmRKMw4awIsY77OWlpiWqY50TUTlxK8E+lOlK6Vp119wKAokr6yaQSJhWhthuC+Uw
 FYXFrDXaoPkLTvhcZFf27Wp+8oA8zsEY48Ejpi2ihflYE4QJZwQ7HVNxGubyakYL6oVmVXMM1tb
 v/CY6qcEoGSwXoQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: gK-1iPNvPby8jAgYAWGoF8vGqsc0P3qa
X-Proofpoint-GUID: gK-1iPNvPby8jAgYAWGoF8vGqsc0P3qa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEzMyBTYWx0ZWRfXx8QoOmZp79b5
 INAPQIbgRpAnoB/jzzH07wQZvQcRTG7DaW4ibIwsKrJ42JOb6X7hh0KGDscRC+EwSlRDXXlSqf2
 lb54jHqEbVXJ3fZncnXCX52YHCM5XXWwWbcT1cIqXCmwkaRNxbA+Hvwkthpt/varCq8JA9NNFVO
 wyjDcpxzULk6u8v8qdZ5ylp++QI6EOPruSJHi1c2kkIslR0JLi9shl4EGaMwQar7RPBex9M09b0
 Uia4IVY5GYPUsbaaCxtjI9tHEOQKIIvdf6J6VE9ZwZGHwkFIeIO54/C5sDftyEnHXQV13pzXzNc
 tUKD26+TAMaE7iQFuQy8K1tQimogA5yIW65iX79h4C9Tvl3JqMl5XnaS/5Evs6WlTJGd134N2xT
 iNJeRAau5jrYCIJYoiY2CHLFSTwkNesDqrewUJk15+2OwZNd7KN3v3dZw4Ds5LBq7QiBueEd6zG
 eZVbQu2JIjTEo2EVwjw==
X-Authority-Analysis: v=2.4 cv=cLntc1eN c=1 sm=1 tr=0 ts=69a5b37b cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=76fuQ0JqpD8MvifAs1cA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 phishscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020133

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

As the first step in converting the driver to using DMA for register
I/O, let's map the crypto memory range.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 25 +++++++++++++++++++++++--
 drivers/crypto/qce/core.h |  6 ++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 8b7bcd0c420c45caf8b29e5455e0f384fd5c5616..2667fcd67fee826a44080da8f88a3e2abbb9b2cf 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -185,10 +185,19 @@ static int qce_check_version(struct qce_device *qce)
 	return 0;
 }
 
+static void qce_crypto_unmap_dma(void *data)
+{
+	struct qce_device *qce = data;
+
+	dma_unmap_resource(qce->dev, qce->base_dma, qce->dma_size,
+			   DMA_BIDIRECTIONAL, 0);
+}
+
 static int qce_crypto_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct qce_device *qce;
+	struct resource *res;
 	int ret;
 
 	qce = devm_kzalloc(dev, sizeof(*qce), GFP_KERNEL);
@@ -198,7 +207,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	qce->dev = dev;
 	platform_set_drvdata(pdev, qce);
 
-	qce->base = devm_platform_ioremap_resource(pdev, 0);
+	qce->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(qce->base))
 		return PTR_ERR(qce->base);
 
@@ -244,7 +253,19 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	qce->async_req_enqueue = qce_async_request_enqueue;
 	qce->async_req_done = qce_async_request_done;
 
-	return devm_qce_register_algs(qce);
+	ret = devm_qce_register_algs(qce);
+	if (ret)
+		return ret;
+
+	qce->dma_size = resource_size(res);
+	qce->base_dma = dma_map_resource(dev, res->start, qce->dma_size,
+					 DMA_BIDIRECTIONAL, 0);
+	qce->base_phys = res->start;
+	ret = dma_mapping_error(dev, qce->base_dma);
+	if (ret)
+		return ret;
+
+	return devm_add_action_or_reset(qce->dev, qce_crypto_unmap_dma, qce);
 }
 
 static const struct of_device_id qce_crypto_of_match[] = {
diff --git a/drivers/crypto/qce/core.h b/drivers/crypto/qce/core.h
index f092ce2d3b04a936a37805c20ac5ba78d8fdd2df..a80e12eac6c87e5321cce16c56a4bf5003474ef0 100644
--- a/drivers/crypto/qce/core.h
+++ b/drivers/crypto/qce/core.h
@@ -27,6 +27,9 @@
  * @dma: pointer to dma data
  * @burst_size: the crypto burst size
  * @pipe_pair_id: which pipe pair id the device using
+ * @base_dma: base DMA address
+ * @base_phys: base physical address
+ * @dma_size: size of memory mapped for DMA
  * @async_req_enqueue: invoked by every algorithm to enqueue a request
  * @async_req_done: invoked by every algorithm to finish its request
  */
@@ -43,6 +46,9 @@ struct qce_device {
 	struct qce_dma_data dma;
 	int burst_size;
 	unsigned int pipe_pair_id;
+	dma_addr_t base_dma;
+	phys_addr_t base_phys;
+	size_t dma_size;
 	int (*async_req_enqueue)(struct qce_device *qce,
 				 struct crypto_async_request *req);
 	void (*async_req_done)(struct qce_device *qce, int ret);

-- 
2.47.3

