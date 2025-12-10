Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3532046BA
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 04:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765339232; cv=none; b=OqsjNmuPdfG+yhimbUpGGPqgjsxrdBQ8nI431c/4jCwsDIWmOQvgjWqW+PtUy0wq5aiBFhRHcdLUDCWrQlt1AlFBlSJMyYOPd5SQw3N7ISiJ9bxecfNgkAqXz6//AkxhGuRE+1X+x8DwU8U8Lc/8JEJYHltoC3PpODvM3AUx1qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765339232; c=relaxed/simple;
	bh=k6u1C8Qj3YHkNv034/IKfYniHPKbmkjXD6jqdtosiRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VkGy+l/3zgPGouqM+mHIzOJWGFWjtUv1IhVgfcTE6Sx7My6lCIIy/45ShMJOFix9yvkZq/F5VC21lJ1sqcpXicKxDUmhtlwdj7pTsjbeK5E7RyPq3Bml1HeTj/S8CmrXtS2GKqvpwycM5rRoM8z3mqQhpetIHxg6JXM3D+psutY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fLNkKbDK; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=V8Dl69Ge; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fLNkKbDK";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="V8Dl69Ge"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA3LftA1417468
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 04:00:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=6numdDDWlOF4BEoGQaJktoTO
	bWSx4NQ6AWfsAvI5qTE=; b=fLNkKbDKcPDCwsl547vCG16XT8vWJAx/DHewJIkC
	fF00JaEC4Ywf0H6ksO1/2vxoOr5Dug1biqsM+PPoNFTPI92Vb95/LOuWfF3gLcy8
	x+9XHeHMRNoVFXpTHwnP7S6WFonEUcC3rjvBZfWnx7+xKhwtSEJxiiE4Cmjm8VwQ
	C2WtWns3DmG/ro+UNlPmEDG03CXc4WpoCDqZDrzg5qjHkMJYNryfnGN0lDMQ+ASc
	cfeqI3Ax6c2JXoLEF3ysIsIAQ41EVxdK16YsMCCyk4D14B8gpp8NTxvt75ZRbL37
	gjdOs1QBg4p7xY8ap2/TlVt3aXveE85br/sQK9+XKrjn2Q==
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com [209.85.222.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4axrhm9rcx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 04:00:29 +0000 (GMT)
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-9375f8d5f1cso3397908241.1
        for <linux-crypto@vger.kernel.org>; Tue, 09 Dec 2025 20:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765339229; x=1765944029; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6numdDDWlOF4BEoGQaJktoTObWSx4NQ6AWfsAvI5qTE=;
        b=V8Dl69Ge36TjgCraLitpWxLaRdBQCiRJseHFeoY4kP8qQy864d2IE196Y3TlIZXZW1
         i925MKA7hoxDqEa3E/iEJsG3tqBZc6UrP66pL1hH04zdk9p/i0nWTEh/Ptbs7mEfRBYe
         0thAsJCnzXTrX8EfpKta3FVEqykQdApACiJFYmKXiB4lmhiQg4ir0IPdSO2dXRJAv6ZA
         4mwLtYw9Cq7cvZbPpnOU2hkX2UYXq24JFt8JGIezUCjZdn+rHQQefnRiFHxZ45w1jJ+A
         QM4Nfv3TiOobeYgFuRb/4QN6+if5hkwmclVD7SFJhWXOkWwd/M8nkBHTI+9Yckek3xQz
         5+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765339229; x=1765944029;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6numdDDWlOF4BEoGQaJktoTObWSx4NQ6AWfsAvI5qTE=;
        b=Ehf1QrlX87tWUV0XjR6eA4CRvnnHzOF94cIvoRFM41uD2/swzss5eidmFOplxyd9pc
         3gh0t71zfCpIYnJqCBseaV9L4zmdg6nGOj6c7UFZeKeOsYYNu+J7sbUwd09KY1Mvb/hW
         NLmz1o7t6S08O4lx6amgOQAosXRm2jAj12KdSxyZItQo5vYTk4G/zuqm/TLP1EaUAmqW
         v8NpG7VNddRCNdDgZ3YPAN1flWPOHSJWblKrfQrCuk62LpfTPy1BwfTQrydp6k5hy+eN
         fI8uFJJxk0U8JPAngOxVSqPbg4ws/mU+aIAolODIAPvQQelEyZKP2hzlbcUGtcur2UgF
         z1zg==
X-Forwarded-Encrypted: i=1; AJvYcCXotb+WvkL9aiP4Jm1Lig9k627puLuyuLt+iORI38G+YTSFikBK6e24CeGC/up8LZg8DFVtQcxWu/4764s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJE4CTyYScNUZ8OoUmzg0l6zm0l8wK0HyZCx8n/8U/6v3mAsGo
	dvuE09is81fLHAb5B8ki/lFAUTaIo/oUAfpgrOtsXYlGqdrIi6AJm7RpwS/C6N23j6Po75Eor2x
	iN8yEELERUU87FsTvsBpLJe+5wFGYHcVsYvpkiqZ4NigcSK6IMgiCP7QZCZh422xTe+A=
X-Gm-Gg: AY/fxX5jGIix1BzjPy/Y+vkoWD6jWZGu7LYovOeAMRZoPXawld8mAKIhhjOuK2fvVsK
	g9XLMzbMcfc024T/d7rQX4+Eu4iBzGO8wT4GIUNkC2TpOoPEY4XcxgVkErf8tfu7Bo0AqBN3cdC
	KOPUnneH1AmtUkq/G2bO8NyD7ZHT47EO4UT+w11gBnlx0wOn4RzG0200g1J8DMaV3f1P5ReMwhl
	cq6mEWcwMNx8A0/GYMJoXBZ5Sei/mfFAthkmPI9CFbibqjxxbkfxsIYNLIwSKjsRs1d1c988UbR
	X9jtHRWmsRJY2vcOWpXgvgqRh1n3kAIwyfaKQIht+D2ohEcwPaGCxqZXeY10odogOYTE9TdkSES
	9lRjD5IbPfRBkVr4zwT5CY43nEJD1ZgpQ0sRthGRsaRIoKhQ1HDCLgtnZJfES0T+lQ2rtTFN3VW
	XckOQwJjT2FIZNibMSZ3kjcL4=
X-Received: by 2002:a05:6122:8286:b0:552:2c5a:c057 with SMTP id 71dfb90a1353d-55fcfc1369amr338190e0c.13.1765339228572;
        Tue, 09 Dec 2025 20:00:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEjTjEp1NQ8eIsuOt0q0tQ1yjMV7eA0kBY/m32fSx6Pcjv+vj2YCZ6S/QaxPkjRnXLROkpk6w==
X-Received: by 2002:a05:6122:8286:b0:552:2c5a:c057 with SMTP id 71dfb90a1353d-55fcfc1369amr338178e0c.13.1765339228116;
        Tue, 09 Dec 2025 20:00:28 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37faa888507sm10765051fa.28.2025.12.09.20.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 20:00:27 -0800 (PST)
Date: Wed, 10 Dec 2025 06:00:24 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 8/9] arm64: dts: qcom: Add initial Milos dtsi
Message-ID: <bv2ojys2zgnd7bx4e6yunyjewqtkobxanpzd63bxrus6373vru@r7rsfbeh46cj>
References: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
 <20251210-sm7635-fp6-initial-v4-8-b05fddd8b45c@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210-sm7635-fp6-initial-v4-8-b05fddd8b45c@fairphone.com>
X-Authority-Analysis: v=2.4 cv=d7X4CBjE c=1 sm=1 tr=0 ts=6938f05d cx=c_pps
 a=ULNsgckmlI/WJG3HAyAuOQ==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6H0WHjuAAAAA:8 a=EUspDBNiAAAA:8 a=WSIVeowOIUgBBEAWWbIA:9 a=CjuIK1q_8ugA:10
 a=1WsBpfsz9X-RYQiigVTh:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDAzMiBTYWx0ZWRfX8ouwfWw5yPs2
 tJJs3kPHuu5R8zJTdLs+K1VmSdFy73EHl8Dao9+WKcnjrzCqm6DYq5PHTd1m1GpmfD8U/CURinN
 2a04vMXWu7oie35GnOqnHPqvt4QyPNaYD+urbUKe8db50NjstzzTYtn1hOuAlguJiu8hZ0FNajD
 hoemw4b1+N9pFnwvqYvB/mysa/w7iwx5tlGpmY9blLH5ffWPajqsjhx4FNpO60QlWwbBtb22MKi
 u4wEYmecTYWpVqCDHhbkCbvshyy9rjZfpzE8Sb0ftELeAcd7KKKk6xvCSmsEhYHwTcZeIk3T1gy
 N7TqYDuKiqJKQ1d7+wpWp6zR6Pknb077soOiTsVY5jywshk6BxtnLG6AMVVzFhskwgS0jBJcJtD
 3ewJ3qIAUPsE3b3aMjgSRWg+A2WsGw==
X-Proofpoint-GUID: 8puCbGbLd_la5vAiOo-nCrB5ZLIoCOTS
X-Proofpoint-ORIG-GUID: 8puCbGbLd_la5vAiOo-nCrB5ZLIoCOTS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 bulkscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512100032

On Wed, Dec 10, 2025 at 10:43:32AM +0900, Luca Weiss wrote:
> Add a devicetree description for the Milos SoC, which is for example
> Snapdragon 7s Gen 3 (SM7635).
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  arch/arm64/boot/dts/qcom/milos.dtsi | 2633 +++++++++++++++++++++++++++++++++++
>  1 file changed, 2633 insertions(+)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
