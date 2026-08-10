Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996A53C4540
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 11:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362782; cv=none; b=ooWfo4xCrQon9XA0qMwSJIfzbohwsfEKBicxVfTeOp5mJQsbiRetqVYLfdM557l98ACER+XHSAki6qQIRxoQq8yJpO7wSLM9JvAInM77ApWgF5UppmlILQQAodP/8nL5HfQ1y3rakdw0DQshI7s7YvCPPpNDzXPsoDfgtkO1EdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362782; c=relaxed/simple;
	bh=z5A7qNBKmK97pO7UrB4UHWA53FzsUZYINMOzb7aSxXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JBogcAgyVZbNqYdG8CNDKEOD+rrvCJjoEifUHML19QQALKY7XybmSIFkulbrKrxTSDOhtKWivvgkbawLothHWafsrrOWHNdct1YgvU1IBtlymYrQdh3m2Oc5Jg2rlIFuISm3H33RhfNbICeKyOqu1LaUo949sxGLU0PFIizSNyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eUT+Fy5H; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=U8yCj3qm; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eUT+Fy5H";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="U8yCj3qm"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67A9SAKx1166957
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 11:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=ssg+iL8SDOereWInaWw6CzWc
	el7jw2pHpojIedXFuv8=; b=eUT+Fy5HrLeJq2ZwypZXYuNf+sc9CQOQPMJ844rC
	umS9n10T80bn60/06y/atBU6mWqArhreC47WRJUhwVZRtr1zR1aZLwbwixZv7EYL
	xVO7RLPabBr6yfTgflNcyu5eR6oxp1GH1hSHX3TKhxmRTt6Df4q5e7HsoTJ3Gwxg
	xyhf3ei1rRdbuUS+pRlutDvcU+j7mDgUQPgZDsksebWj33Gno8tjMzxZWr6f37HG
	Bh6balEPOoMnkReWyh33W8QFFjjwtY2gl0YqJ0LJCbD7ymH/K8UPOcWsK5kSFgG7
	UEN7A1NftdSFwVg/p53htRDF6fjGTmZPFpM9LXOjkYJKdg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fy8vhhc8u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 11:52:58 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5174a236220so15368951cf.3
        for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 04:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786362778; x=1786967578; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ssg+iL8SDOereWInaWw6CzWcel7jw2pHpojIedXFuv8=;
        b=U8yCj3qmZ/AwlLl9LE8DxSTTvWquL0f0JsYxNYjb6gM5JvjketWajBOicKEbCK37xD
         yGxVBCzxFDJBva4q3hGNbDmE+tr8M5ZfMxuTZv2GFio+GhcueaIYl+9pTgUxdxQ0qYOQ
         nHMEVYw8hlh59FZbeCXwzmhhd1Tl8rRUfw4ssgtf34f+npgNDbKxCw3/mKQwa5DVno7g
         +30f/j2HnivxhGweAH1Vh9BgBLFriU+4w2Y+Q8+XskXhmhyU/APHtqF9rj1fE7Mynrk1
         FXxKOqZBPY0gU8nIzMJfVjHXatQMRGTAAjtg1MrEC6AgnNVvuJfR7TjODmDhODhjdCFJ
         jTnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786362778; x=1786967578;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ssg+iL8SDOereWInaWw6CzWcel7jw2pHpojIedXFuv8=;
        b=h6dDRAyIQ/hEIDf5oTBT60VxX2Ikhi0rD9HNV1g/jpVvs1O/JJktym0Lp+P3r8UfA5
         Gg/rmRINsnXrK0OftuaghZYpsOqydJ5OTIBMWZIiBMexYhTICcr7cIsc8VItQFEO1sGR
         joHLWm7VSesBHrwty45LlIAGBhuZlx1CEYHbWHKy5ok+9NJVH+7LKnGVBc2GELHxLODv
         QlmNOCJCjSXDtMelHfXIrwZnh5mCp+jAKmuP5dhbVAN+FSKAMeKEZg5sKQUsza6aml2M
         GoNbTGdDIB9L5tayq+2/wtjgLVuXzLcr8e55lyVfbTfzn8z0od5Ywm53HRuDHkF+2zYj
         SnAw==
X-Forwarded-Encrypted: i=1; AHgh+Rr1v4bizX7RF2LTyFVsAPo5XEr2dYS6EHXduEmcIO2W7CTvhRBzAK70g7UGpsMRy1jojH/xqhmrdOS1a4E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY6WpF+DbylDeagYj1Eo9dkQQ8rIR18qtVQUEB5/2IaTIlAYHu
	mkIGADphwuCFutaa+wAW8EEGvHBfDOAOJAla0EjlbVGVerQOA2RnTbR21ueWP3ZupJLKiTKDFLh
	AQRlpaizlkbHaHOD+nFaEzCfS8AiqL74Sy0GYcGJug/j6VN4Sce1AhA+zZhR8g7lRKmc=
X-Gm-Gg: AR+sD13qIDG01roLE0w68GC+bk6sC3ETJH7Ocq9jFmM4QncM8OM2bSlUyD4tpI8HC0N
	2n2ekAR3ZsXLoR0TWRhmW24u9AG+4CLwlEYGqD2vNHENgrNdqfvV0A7W2oM8hXeyhXIsSBzNt5u
	vf0jW5mFawGPhDB+RZjRAA4aReqABRDimv8GbcF3lrSI26IQvS5aIdybf+iKxmIGmCL37i6A69x
	QXV8kcapi8C0XZnTmcyiMGAeWW1BjOZEELWwdBsfwg+FJ8nfFIHwbEomzmLVTeppjxJqfViF5OZ
	VprK5BI85IoBA7gPZItrMSukEM0egejmTglo9gQlTCJlLelAmDZnC4q7sOxtFtQOn6BP6/yyIZN
	nLv9RwWjUb1M=
X-Received: by 2002:a05:622a:4c14:b0:51c:2633:9ddd with SMTP id d75a77b69052e-52ce61eabd5mr473507971cf.41.1786362777781;
        Mon, 10 Aug 2026 04:52:57 -0700 (PDT)
X-Received: by 2002:a05:622a:4c14:b0:51c:2633:9ddd with SMTP id d75a77b69052e-52ce61eabd5mr473507401cf.41.1786362777165;
        Mon, 10 Aug 2026 04:52:57 -0700 (PDT)
Received: from oss.qualcomm.com ([82.77.85.40])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4800220ab04sm31425905f8f.37.2026.08.10.04.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 04:52:56 -0700 (PDT)
Date: Mon, 10 Aug 2026 14:52:54 +0300
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] arm64: dts: qcom: hamoa: Add ICE node for UFS
 inline encryption
Message-ID: <3msd7echul4af2txjfserdbnedh6ukvzxqwiismjapk3odgkby@uoxai4e7wmhu>
References: <20260728-hamoa_ufs_ice_change-v3-0-293c7c6c2ae5@oss.qualcomm.com>
 <20260728-hamoa_ufs_ice_change-v3-2-293c7c6c2ae5@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728-hamoa_ufs_ice_change-v3-2-293c7c6c2ae5@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=MMtQXsZl c=1 sm=1 tr=0 ts=6a79bb9a cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=GMu+mMXmPKlJm/I3Pt7gOg==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=SooqmcQUKh5i17ny3PUA:9 a=CjuIK1q_8ugA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: YVnEpoJaffFz7JPQTF9EGG0FJYae86Rq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEwMyBTYWx0ZWRfXz7PUGcGESJW7
 3vPhEDx/3ayriKxLeASUk6fkrq1i7u7SAbvhhNm/m8L0bT2YDJ6+09/Sh5GUFftKJwaXLjN2Z/U
 8j8uFuVH4L0Afw8q+PY5n3B/8TnPo5rAl5zJL7Mi05kfH+/wGYvbGONltdWM1IE9mAT7epEYxPe
 ryo7VIGN+okUCmK48BpmYJqUepcuj29fIRzZByCPSdlY/tH6VqVpQsLD25MYM93ci4xB9FdAiPh
 h8jDVVVUI02hEQAtylBwWOgB7PKftw2hXR99L6stT4c5YzpH52sN93oPY0EEUgRSehQrhFVyKq1
 7fxSyDxoiSYped/7o8cshPgT1ZUBe3yL2Lf4DNjmvz3dVldnOMrAZemYQCOrfxNWvyN2ib2LxNc
 QBBfpVjeN6Dy8qH5QcSa8wWmfJ6KVGaY+4Xx6oSIdMzsC/MbYoKtariUQDeW13joyvT+JlFq4E6
 lRz4WgeyZo2RqLeN8eg==
X-Proofpoint-GUID: YVnEpoJaffFz7JPQTF9EGG0FJYae86Rq
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEwMyBTYWx0ZWRfX8Lw5shwNfpsn
 vidUwo3NT6bOpsJ9osLSUqnTLykeTPhtTWkpvfIi7BvXYWZ//BveekmjqKlYyT7tHWrVso3lXG4
 wMbVST89i7yWABuDQ4fKa0VNUC/9Jzo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_02,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100103

On 26-07-28 17:53:56, Wenjia Zhang wrote:
> Add the Inline Crypto Engine (ICE) device node to describe the
> hardware-accelerated inline encryption for UFS storage on the
> Hamoa IoT EVK board (Qualcomm X1E80100 SoC).
> 
> Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
