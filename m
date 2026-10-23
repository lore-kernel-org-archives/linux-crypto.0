Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792740075;
	b=0NAGmY0eIT/r64j/6HnBu+CEEEjL3iggCctJLXj9662DF7rM+xejPXhHCZ7z8d2oeXop
	 3bR/2IOoVSrM8q1h50SZlrjZDIf8zw5T4CAtaU5443txr6RCK99wba1zyYq/y5BsR8rTx
	 ZCzf+3a8aBXTvnEFQOYHAR4bg6HttE3juJrqPLY2USmT9UVxuEqgEhHzydKuoCQBV2c9y
	 8Nud42szNRMuhwBLJEDQP94zFFnB3H+RTmb+HOj+HrIbYn6Ht6OQ3bjv236bTD1676bt7
	 ltLma+QVWyHQdqTA8budH/jrl4y1KBmSv6uT6Wusns5sILsg1ybCrwyWNJCYHzkIGQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792740075;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=3Stj3y7d2zjQ9nTgF2QbTYbeZnbVnfXOQ9Q7r1YW3jI=;
	b=VacPwT8S+4h+B4YoY7BkxwvbzzJeqOzscYqgmv7zIqIwJ16Fu4kpaLKdW9qLJohpKA8E
	 8bgPZMdDtnpl68l87LllWytEDp+bzkQjjIYvE8SVoEzp33KzHkY4+ueanwSFAKvmup4LY
	 /SrUjoFLIYesCKraGrmgm0ncLVIKw/xs6vR35mQPtppburHizfoeWkP14W+CNYOR60yAp
	 NdQZV58RbUtdOZF2TeW9B3WTxxfJ3heoATFEsel3VEdbNa78jMx/sZUQFXnWsCfF8mRlr
	 CZcQ+2M/y6xz8ilqN/BpEnNAeh89Ryy61qwiF6lbbutwfSK+CxC0licqnAsb0t/5XRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=IEltu5Wj;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cfyBHH5C;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD988606A31A
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 07:21:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD988606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=IEltu5Wj;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cfyBHH5C
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N7F8x81200806
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 07:21:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=3Stj3y7d2zjQ9nTgF2QbTYbe
	ZnbVnfXOQ9Q7r1YW3jI=; b=IEltu5Wj2EOEoYuMbU7Rp+yEdb5yEQO+oGDu7yLT
	bRNEcKHyufkkzCDVowcbhUqSUFKYTSYqeY9gvdi8IkIgJjoVhuzSqLDwp2lI9br3
	7wqzT4+vAj/YIX5gdZYNAO6z4GMy5kdH00HYKSYIbwt2KpItkAA8Fsl6YHD+xC4V
	erjT2+MHJkF7Kn4vK5fx9VLeqRG1EksYBRxZ+LDPr+T5ZE9OXaIA47mW1++QM4xC
	th8KAXMGyrsd4n0JHcNiYicFPRnKEm5PHYrTyX9Bd6NGMSakVPE/veuTxnvgmRRL
	LidPDb7hElvAW/wToBSUjUCElgTydbP/P8IYmxD3olhAWQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfqms2dyf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 07:21:13 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93e49a1d3b1so137773685a.2
        for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 00:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792740073; x=1793344873; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3Stj3y7d2zjQ9nTgF2QbTYbeZnbVnfXOQ9Q7r1YW3jI=;
        b=cfyBHH5C/u2TJJuBhpThjoMdAVlhknLN1mCb4bNplQaIHHxJSayDILGw0qJVtW8Rop
         GMkFHW0tIlyuBf52D6VoxGf9Xd9BbrUnclL7/HhqaKIfFYHxxWInSkOqQ4UckfRRe3jO
         4HuN3jWOO3p9YP8U0X9HloM87McjWp+0XAJkx2M/Pvl8dyIG729gAjxVghapkJVylmjI
         xqXK75/OkOxzl0mGlAo2m5ZAqYmFkRkEba9ZcFd7YnkMMRmmrOIwOf1EcQdQWb/lbqiI
         W+XlZf331fNwTmrX8fkAprrG2LE1o27a8AUi/IZ6F6XfaFybdnNwxO7FlwqlAFHxSsKQ
         2QRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792740073; x=1793344873;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Stj3y7d2zjQ9nTgF2QbTYbeZnbVnfXOQ9Q7r1YW3jI=;
        b=Gvvedd763o79OuJ4v0QmoQXRiK8/XxNLIYDsaeR9Nn4TkH3bZ4dlLKABIFjO9MkBm/
         ekf1N0Czm8+IDg5DWWLVhJGQnum72d6mTnWBoSDVOrrjRPftmBxOBnqsL439zvDAClDu
         YWpvcnY49wah3IHXXNKJ3o69E7DnjOErJHX7NVv5QYZN7qlXkv2VgpNiyQN+1IVcoqXW
         qwIG5C/ewhoIHeY0NHF4Js5v7E1NNYwNjFaMz8/8pyesLqDIZl77nRBK+y9BLVKShpzJ
         syBdUy4Vf8TKU2jEGnj0frwtGgds6Zc7j0R2xVTqDedfErFZ3lrP2zObDo3yqjb+8zpm
         eNxQ==
X-Forwarded-Encrypted: i=1; AKwUvByCqNvKq8YU20Sr6U1pR1G6YAnH/icMHSPrXrGBGL6WYxaLIYMlEBwZRLSMTGA1BkNYqdoqkja78C8g6rI=@vger.kernel.org
X-Gm-Message-State: AFq9FYL9HKEUJhVhOxUgCrjnwFR9UN7+yTn1GHGheidAWMEQjmy0K9oh
	THlnp611YT1vd6rbUB5+z5l2rK+rA8m76jN5lfVEDmzut47nLtppK6WqQSGlUz1/EhlTd0A5SCL
	UKw9/+72xgxpIk1ms0EymF3h7SgYeB1MH5hRKvgNzeO1Vk6C/x+8AqTyYhG5ql9HjMBM=
X-Gm-Gg: AYBFou0U6YA9rXx9qBwo4DFKBwmQHJ+v7zWhlsj9yXSrfuY6VfxnGCdLjgVYj4ihyyn
	DD4Y/bdb4Tt/EFElY0vZcRu5OToG9sR+NTA8N2N7/SxuwmJYl+sZu/FJvHVY4W5Y9kBRwPWzidg
	TZA5EyBd/v3PWQRuLfjDtA7KpEtO16FXvpP/D0XXCmLXA5f7k35pqfK2rGbxwqsI8Y/wNI/H/r2
	z6+iV6b7aUb6D3YY8okDhxrae75ey+eGMF2GPhr4RhZd9M5O6Yfcdme5wsdZSL+KDPXouCtIacn
	XXDON/evgP6ttAtGBhmGNiVH/J1PkftQ+dhG86dxLtOdqCSzCoTMc445SSTiG0QPT+4JdjWutQT
	K/EVXxnZ/+29mzk6z
X-Received: by 2002:a05:620a:45a7:b0:93c:c4da:f46c with SMTP id af79cd13be357-93f6f824b06mr269985285a.56.1792740072756;
        Fri, 23 Oct 2026 00:21:12 -0700 (PDT)
X-Received: by 2002:a05:620a:45a7:b0:93c:c4da:f46c with SMTP id af79cd13be357-93f6f824b06mr269983085a.56.1792740072198;
        Fri, 23 Oct 2026 00:21:12 -0700 (PDT)
Received: from oss.qualcomm.com ([188.27.161.187])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a21555fcd1sm15676145e9.4.2026.10.23.00.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:21:11 -0700 (PDT)
Date: Fri, 23 Oct 2026 10:21:10 +0300
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>,
        Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/5] firmware: qcom_scm: Transition to the generic ICE
 service
Message-ID: <2bw26iiqyl3zo7s76hbpwotlowmeeecvqk33rhbcrb4as5blsk@q4yn52qpsieo>
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
 <20261021-ice-migrate-tee-svc-v1-2-b035be7aab0a@oss.qualcomm.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021-ice-migrate-tee-svc-v1-2-b035be7aab0a@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyOSBTYWx0ZWRfX4HceHghAJzv9
 pGc/zwTWmP590vllFcPFFxqIm2PfASC/S++oX8RiErPftxnDO5kdUIwKFFU6/Z5tP4hWCZ/K08T
 Za7u1N6AuhqyjyV6u3IQt40Z3peap8oKoQNf3RfuYtcQrvQr4pdzu9ZsYwQZUN49BDhUBXsKLuy
 2bUSTERya3Fv84XNh47UMXjia9aZOJgJSdcTFrvMYBq78vpMPT9Pz8rH+0DPUgH2K0y808E3pty
 V/TNjpZo5ETug4DsSXTa/2c7yoEIYFh2kxLULXmKsTTD2G2ped4P6i+f+QsX/bndHfmkIOdOvwJ
 I9jcL4Uf0TpMBTkPWvuaqD6dgOFupKccnw4rgz+wq50C+Wpy5S9ZgnuKu+5dBE0y2GMEtwwcckA
 hoS8BqIwYfvWAOT5VBgbSf0gMQTnMY47l+D/Y7uwayrLrDO0wMNAw7dT986iTSEDKQldVtCPWIc
 ImeGdflSfVzQzkzYzOA==
X-Proofpoint-GUID: k3aQ2nAdEJX_f0LlaAw4_hL_HGG4U1Pw
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyOSBTYWx0ZWRfX53+1yw86Nd9D
 5jpu/UQW1TdoXOuK40FaTwDTjonHJ8XTjbt3S5qHp/CrtGF+oHggZ9QuESnif6FKAdKkmLschw3
 e8P7rePVAb64oviug19WLGSrWwnYmLg=
X-Authority-Analysis: v=2.4 cv=UdbE26SN c=1 sm=1 tr=0 ts=6adb0ae9 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=Qvngrl3H0rQgGg+94q4QgA==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=i1ch1AlUq8TPK69w1s8A:9 a=CjuIK1q_8ugA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: k3aQ2nAdEJX_f0LlaAw4_hL_HGG4U1Pw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610230029

On 26-10-21 21:13:08, Harshal Dev wrote:
> Transition the ICE related SCM APIs to the generic ICE service by
> registering them with the service's operations and wrapping them in
> exported functions with the same signature.
> 
> This prepares the ICE driver for eventual migration to the ICE
> service from the SCM driver once the TEE bus based back-end becomes
> available.
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
