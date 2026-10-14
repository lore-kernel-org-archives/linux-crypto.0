Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2559149B1E5
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 08:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791966628; cv=none; b=tJkxhDS78JrlIab88GJS5XLGTAA8AFknJ7GXczHaqo19giKJ5wE1f7NaL9sjkYMcxXNLIlYdr9Pr/mEc2SHufZyzrye1SFQ1i4/O6ifnNxvwL4PSlUFi0BNyguPgKNdcfyQKfzQY6NjgYknxXYRHsRx1MPq8ekRmOQb/9HssYA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791966628; c=relaxed/simple;
	bh=ZT6FOcLx5hbreOIsDX43bZgWp7zpTZEdhRy0JiuWAik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DxBIHbdDwJqklm9jvVqTmBh/UOirB4GrqeneS4GpzBLEiI0JIXyq++3rpgKesMtgYo6rAV2N1xJamvs7vs0b33iihlXI/YWYwZznFlLxp9o5ecL7Jbd7VA0hJfywwVbd1mqMJWtjOTEMEW+iFrNxMOd949EasaGVF+pvoF5k9bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CUgXgUME; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Vd4GiHr4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CUgXgUME";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Vd4GiHr4"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69E6Lrmj3104076
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 08:30:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=5dobmJMNsUw57587c4QcKw09
	gC0COHOcPZrtPPfuPUw=; b=CUgXgUMER0ZTIewiEPvYRLEEcjMbTE0PMldELdDc
	vH7FraZ2aaPVdtqMCxPV5AvdUS+OHUI0Gk+oH1eIK/vqlzOnxxYxATJLC3s5Q4tD
	uNeg3gPCCo4OOZn/Zki5eEIEoDCqsZbcx0V/h0HoDhGKJGCEdgpp7qKLB+ICYqfY
	Zwzt6JvJObl3gPQEc/KgX3xEMkYRsfTbVULnCoqwVx7ZwnhzHcLQrb46uob0oB7e
	SGBPibWIu3ibf/yy4TI6cFVYMF4uP9V/k+YCGQk0+SWHx4IqPfIgMDzArZFPLwxM
	XXeAsIU9GJawVc9stPbAEN/33aQafbS4zA23K9c03Z/+YQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9wgt1y76-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 08:30:22 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93cb6391e89so839000085a.1
        for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 01:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791966622; x=1792571422; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5dobmJMNsUw57587c4QcKw09gC0COHOcPZrtPPfuPUw=;
        b=Vd4GiHr4fhvmoTI5VnG92DoG16M/ci8pLPq4dV2VNmDwbTvL8C6NXSqeeniNhjaJ1m
         uPRgVVuRvG6CdOjp6bt4PJIW60lnGZNyfPr7C1ktaFo3Wu3PPQ7dZi4EmVqYYlvzRPyn
         QfFAOJqDIo0cWsWpwGDxZFxMXfJnHePsBaMhuICrVnV57b3dHJdVmvWRmpiL+2ysDSJ0
         +1s01Wvms8u2BbuZJHWLg/O0boMdzOqGGgcbPADMxCM1xfLzgzgOSo5XUxdpUOpJQq8l
         KwCb6pvXuZ9eeDzkxMsTWOVlVbnEbi1Zsg+m5e2wmoN0K38YjrOFHhDg9LFxwwNBjKxt
         b8EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791966622; x=1792571422;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5dobmJMNsUw57587c4QcKw09gC0COHOcPZrtPPfuPUw=;
        b=K4YvGcr4ElCbbPt2TV+jxvPMgsx0FMJe0J2XiQTAmiJz3ZxeLBNGBCAEbENTSvfqG5
         Ol50FInqEixH/SFaEAWano41+APgAlHo810c5+8Keaed2zpchgKOOBCkp0h0VJewpxr+
         oO/FxeC43cmCtqD50bG3n7m7h5Ch52W19Sn5PCh2Xpkx2CDI9anYumkJ9/JVqpSURYDf
         HYXsJhQna6sfwTIgI1bqY0m/i+sYKcLrhJ7NjNe/A/8sqnJ8/QOgWAmx4aE+Hnh5nY9E
         MHp59Keko54tIJ1KIZg4LUSb4LrXj6eF76yWc0/NbSBOF/UNj9m+Ya64EM1bEniMNX0d
         dmzA==
X-Forwarded-Encrypted: i=1; AKwUvByq6//Un0+USUVhjs8FDsfQYW4bLs3/YxiDSiSC7mvJUZCgbRHnhRdSSAt5QakFFgFDd63kDfB7PzgcqcE=@vger.kernel.org
X-Gm-Message-State: AFq9FYLKl30h3qpSdhpA0Wa3zO5gRMyaO2/XCb69wv8vFnd1lWsQijhm
	UJEhG7qxd9HDwwBtvtMiQBsWg4W/apt79BPDgdC0VtZGROSKH/Y58LaINnQxd7OVn+pHdu9PHND
	LdYaL7fDAGFuW5i+wvIZeY1BWrTitUIyHGF2pJJB9C+0W6N+HeZZDbpzo3Kk4RdWeDgo=
X-Gm-Gg: AYBFou3Kqvsdwq8J2tmtECZkh8NsRgGyKn+LuSme9K3wh84qMrlKQi4cYi9jM4YW89u
	00pY/kckn3AZiJ6WsF878QsU8BH8y2HK8usDUr69vHmi9wu3r8Kt4OfWI1uNCe189TPYBpup0Jn
	ZXPbkagbihETiOZqyAr0LPzMV/4ozvpeFlWDNmyOpyGS0EVmCARK9c77BfRYF3F1RXdAyDaCOEq
	UvXCIoSyetlMIRfGP8tnEcGZiSL9Et7JVtaAMJu0SOusH9e2FSpRcARvBMZvdC9n4+vFIKWPlfS
	COCpnZOdJIRhuV6W+C06AarDuMUSiXyuovheu+ZNFlIBC2E9ZH2uszCXyJupBZmcgTaISd7EDmf
	8UiWuPm/pwZKEwOcr
X-Received: by 2002:a05:620a:601b:b0:939:a45b:76ee with SMTP id af79cd13be357-93ebd1dc726mr2524661285a.23.1791966621600;
        Wed, 14 Oct 2026 01:30:21 -0700 (PDT)
X-Received: by 2002:a05:620a:601b:b0:939:a45b:76ee with SMTP id af79cd13be357-93ebd1dc726mr2524658685a.23.1791966621064;
        Wed, 14 Oct 2026 01:30:21 -0700 (PDT)
Received: from oss.qualcomm.com ([86.121.170.215])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1b4b8cc7dsm23559775e9.4.2026.10.14.01.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 01:30:19 -0700 (PDT)
Date: Wed, 14 Oct 2026 11:30:17 +0300
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Subject: Re: [PATCH v10 12/14] soc: qcom: add core driver for the Qualcomm
 Crypto Engine
Message-ID: <2cfacl7qglbbognw6g37qnhslrc5fhstluiol4eqanqn2qg33y@4a5nevgajbgn>
References: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
 <20261013-qce-fix-self-tests-v10-12-57162a38a554@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013-qce-fix-self-tests-v10-12-57162a38a554@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDAzMyBTYWx0ZWRfX0NunsNBVP9Ew
 KjOEenRLKpDqljyIu67NN50/SGd40Z8ud+QdZQ5wZ7hbR2OLn7bM7/couxC6+kteNNIZ/g03pxR
 rWXgglGwj8BENSpQV1XKsGGAULkUM3DTsUVjzTvklxDhO+AF4WjAJ9Sq3JjE5ohNjDZNZp9cPh3
 9RH3n+wtDg5pumxggir5o8Jj02Zz82nbPilTsR3wSwVDdcaI74mhBumpvhiYwk7gLOw+MSCihC1
 GhdUydRQo0WR8SPUeJmyHWibR4UhnU6SqEWqO7y2qmXj5gdMpM7/wAFTMPBpUO6civbnMd5oOdt
 YxCQUiv3C6d8l383MWY+Qa7AnTv+m6TD7GIToJAbapqsVpb2qxkrhZNam/ZPauutH3ynW/h45L2
 PYr8QIZGr3n9lpKNSJvCUuQ56X+GMwqyaHOhANrIMg6iLhfks7HXUwWFVC1/MDAGvQQX2gao+wA
 4so8VuQqC+J9qjFdU5w==
X-Authority-Analysis: v=2.4 cv=Jp1kP84C c=1 sm=1 tr=0 ts=6acf3d9e cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=Rt3kCFFBWhWisHNmluDamg==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=Mf7eSssg9PIvhwxWQfMA:9 a=CjuIK1q_8ugA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: k1dOS5qgDR995L8_zAq5uKX5r1q-RJ4d
X-Proofpoint-ORIG-GUID: k1dOS5qgDR995L8_zAq5uKX5r1q-RJ4d
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDAzMyBTYWx0ZWRfX9Y4i1oAhMP6E
 ACHlSoIxm91vqwYuegGUCnq3b+6185rS9EBd0cge7Ih69Sm4tuFFtCyNuTSclskui/4UMnP9Kwn
 QrfQsTwSKMkPws5Sh65vUKb7EP9+CSY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140033

On 26-10-13 11:57:41, Bartosz Golaszewski wrote:
> Add the core driver for the Qualcomm crypto engine. Its task is to bind
> to the qce DT node, set up runtime PM for interconnect down-scaling and
> register the auxiliary device using the crypto offloader driver.
> 
> Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
