Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC61F3557EE
	for <linux-crypto@vger.kernel.org>; Mon,  2 Feb 2026 10:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770026560; cv=none; b=JsxNCk1L85xFftzLLKoUAeJYBilLEhjIu81kvYKHI/NQbg7I0mMlG0ss3MK9h43OGXIcJXxeGHuW7BPXteLPsTsBkOaDrpSgS5w2CH10QpsV+20qZORuoxxevMWsTDkbVv67eHbEhSJ4NgTc4TTO/0frNDoigV5aCesSSQXZ1i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770026560; c=relaxed/simple;
	bh=qIB2Lpv7TxKGpGiudH5ik8lNzRLl39d+O4FnkJ1I/Rc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mWhXpR9Vj2cEZQihdLvW6QrFOrM3Bx+tHNXtaXS01wC9QJkJWEyGSQZZ9dXAqazzPn81YYCjE0JEdawqZE9T34x42ip5ACEyg4qu2LrgiBs7rcXtgsrBpE2Ph/jax7wVpM1KgAJAPr/RlJKTne73ylOvzGSkFDHCFT1EjfJSgSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bC3AVQki; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Gu0+c0Ok; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bC3AVQki";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Gu0+c0Ok"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6127pe591838953
	for <linux-crypto@vger.kernel.org>; Mon, 2 Feb 2026 10:02:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=3tkA7AYDqhBa/hYNHbDMd5f2
	xgn5W1OlVmL2DSrMQrI=; b=bC3AVQkiG1E6+VmbGlbkWeu4aNe1MpCPBBggMkNK
	xr+KFaazaqBZVd98V4/hyEOZEcthr0bawlLJCg7x84D1ECMg9iC3xLdG3msG51N/
	WmqBeXSbkqCFj2Ez9tqUuUOfdFMNIoe4HlNDCIqM70g0YmRfzRNVjJPHb/nX3hLK
	0W8nGv3QGWFNxYEt2K8toEOChsErdAWNaTCkJjg/iLrjOpHoJjC6ddxckLKIg+yL
	/SWgi+ZIbNg0bREe+d0LAcALEo45kKDdx3HmVGuw5b1c9MBhNpFUo8bIqAeERFHj
	+Y/nVuVNLwfznpunQV6sf6YlL+iJKDDrRmVN2IFxtQkKjA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c23h1jp5n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Feb 2026 10:02:38 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c6a5bc8c43so1335904785a.2
        for <linux-crypto@vger.kernel.org>; Mon, 02 Feb 2026 02:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770026557; x=1770631357; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3tkA7AYDqhBa/hYNHbDMd5f2xgn5W1OlVmL2DSrMQrI=;
        b=Gu0+c0Ok07gU8g5d3nzonGonhtjLWDoaOCw3gv0eBMPnM6znH7tsdvuh6PFx8UEH1o
         4HlXg+m77N4M0Db2jA1YQf9Z9lNtgOF3DH46vqk2C3mLQndxskhfuPha4W/veA5aF9uo
         bvA+uOchITa2t5+uWDWkWKpQqH7AyJbdAEsmq/dtzTITxZILTtifDjl9mF6dvwUFxmoT
         eIt0SzRTa9H/1BsE9nhANY6B1x9h3+tc5pzh0MjbwjiWakGcEu1nnZSOPxZOD9j5Hwb4
         OsPGxz29L1oNgBMIJ5h2vNSznrISmLfWWeu7EQuXpZCh2FHUSNrltOBYnpygJNX/EF3E
         T+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770026557; x=1770631357;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3tkA7AYDqhBa/hYNHbDMd5f2xgn5W1OlVmL2DSrMQrI=;
        b=KBXgQBFc04mcGC761K1b+/uSaBAHJA5N4QQoFd0sloKdh7MqOe5pZbQX9nroeO19R/
         PIHHqKAKqy2iGdFZllKNrkYSkvNkxXHtcp6ZV4jqjuj8L+dfurzqVdmQKO9iPKC7cJJQ
         pIWEQc/6yGj6SXebd0Fm8wUvCS3wZcN7C0vAGnDOoWZozIzEi9RtqQJpDOQ8Te9WIQeF
         ukCYkddq6ShioZr6bkUkeZyRu+BVtIcm54fK4u4ej8g2W4tiTbvwpFjUL57LPbUCd7Zf
         NavBkPzWot/+irIPIgLkCLUFol9qIUqPyVetE52pIm4+VHp6KLc+Ac2ZeIBbBwmPki0/
         fsfA==
X-Forwarded-Encrypted: i=1; AJvYcCXQG/mgk4LYhbRzE1i8UyzjSDk7Wjej1+gYoCiE8cNfRxSqzYkapaHg2OIqgir6HFINADXS8F3e2u27q8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEs5cZOq6QxrOMRlfiZ95A2n86tEB7wc+opnvMmarMeFYR0Q0f
	QzVP1zyk1EyyU+7tjX8BOkku/xDQ7VSD+FFM/rc9b4dcM7upy1Cp4q7WoBl6VVsKHc36LhhJer5
	Cd3P/6BEx7IA3mBQKdIbJPlTcJv+5xUBzJbAaJSiNxD2h4iWKhAhZRD30egamy3heV5c=
X-Gm-Gg: AZuq6aJKwM6x5ISmfGE36gwOnoab7m3IJVPsb5GT2J9mqNZSwycaPd7qE7osuBCKng8
	YCg14AnD8Nx8TJ1i7mXFuiJydhXdzFYvVVuLap15LEBeYwBBUL9bHpYk3E5aDaGZTTaQgl55OFu
	DnskFjEbmqYGHWwEYpyFdO30nOIXfVSiAUftG1HXWCmBFYwEgJmwMgpJrVmZNYAl4U5Oekuvd//
	HYq51V5Ex9g6kRD/2m3nDiOZwlFFLxwBPdByWcQvnAnmKsEVAhsMVLCoolAf7B08JJIKQHb12BR
	vjyAaLKK7ti4IQCxhlMWZX1OOCJ5OhjBglLD5xRsD3hW+eYdiYOVPVD3XJiiAVpU+qbxIYVnOsj
	0XW0VduX/iT4mN1/bKytkvD8/
X-Received: by 2002:a05:620a:408d:b0:8c9:ea1c:f21e with SMTP id af79cd13be357-8c9eb21a77amr1378166385a.10.1770026556910;
        Mon, 02 Feb 2026 02:02:36 -0800 (PST)
X-Received: by 2002:a05:620a:408d:b0:8c9:ea1c:f21e with SMTP id af79cd13be357-8c9eb21a77amr1378161485a.10.1770026556388;
        Mon, 02 Feb 2026 02:02:36 -0800 (PST)
Received: from oss.qualcomm.com ([86.121.162.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-482e2e3bf18sm91797275e9.19.2026.02.02.02.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 02:02:35 -0800 (PST)
Date: Mon, 2 Feb 2026 12:02:33 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: Re: [PATCH v2 6/6] arm64: dts: qcom: milos-fairphone-fp6: Enable UFS
Message-ID: <eorqoqkpz5veb4qgq5o6ll6zhocn7tedfxji3le2ex257v5n33@pou5m7evdl5n>
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
 <20260112-milos-ufs-v2-6-d3ce4f61f030@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112-milos-ufs-v2-6-d3ce4f61f030@fairphone.com>
X-Proofpoint-GUID: uAlFbtbDM23BsFsn5pi0I0ESvEzAix9f
X-Proofpoint-ORIG-GUID: uAlFbtbDM23BsFsn5pi0I0ESvEzAix9f
X-Authority-Analysis: v=2.4 cv=Fu8IPmrq c=1 sm=1 tr=0 ts=6980763e cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=oauzzCmhM186DRC0Y2yWPg==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=6H0WHjuAAAAA:8
 a=STFXn1ACf7ZPQ-DneOQA:9 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDA4NSBTYWx0ZWRfX/+ut1SmlKhFL
 dTcmQ7CIwy130YbJWe98wEIitIl46+tcwAABYBeKFbAAnuYDU9750Tn6TtDyABI9XdY45XPwHfH
 8rXCCCAuOURyh5xejG3gt90CZhxOGMdjL7EgLHN6eMhxGwz9JuDFIag0FdCbyfce7G6XNTCKQjF
 LTz4HPVjRorETHet6lrzC6ev8pJOYgzr/USJ44pOJL0qHBQjiHIUsAuKpyyzU82vm3PJwoIhEGp
 jQ7ysaEyAK4G96ItX/xZNm255BKnnlVuYWI62MeLtuEZ5R/phdyJ50ZOEyyBFgBJpHQ+WI6tDRf
 H6gPQz6o5nJ83UH2PGFxDNlZtJ6JuNVrOT5HsAy/W3Ihb+QmkQDArslOSW9m+qswta1JZC9jtNH
 kcQtl9PUyfSRHhy3jpXpUmLaxHP9MN3iJQHBkudDgTfPUCwof5RKjn+KEHeC75zRe3uCC4vW+YY
 Uxl4xTxpv+Ggl9ApWlw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602020085

On 26-01-12 14:53:19, Luca Weiss wrote:
> Configure and enable the nodes for UFS, so that we can access the
> internal storage.
> 
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
