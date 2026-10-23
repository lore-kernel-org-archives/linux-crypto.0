Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792739792;
	b=QnwO6WL+L3lMVCizyxDlrwfUA4hROuMmS+DvoIGD0Xo6FoV0L6JM/iDrIuQenSaDv80W
	 uPW9pFlZCS4nBfMMVgOIoksAcIiP3wNjWejGElJ9ckiGuic7MaUY2lRGy+UBJrCqBPglU
	 pvk+USJDNumTjzpECoecEvwBomPTogMRwhXrM/MEbz8oJXN5rNmGY4nys4IHF+dIm7sTz
	 IomCME/2dQeEFuSnAMHyeLKAIzQBgCO3vMhkrupKtn4UZ7PmBS4snv3jJFxtORNPUS2LC
	 i6VH0TkN+wzuUktw7Xdbuno9NR1NtXfq8Qo9DQt5JcXWScWWdq/QHhcxV9cev19LiIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792739792;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=fnCHzkMl/tRSoOoOmfGusYJwL1UrHp+aabajQ/sL5Js=;
	b=PRLtH/nY+ADWkY4EEiTgZ6WfkLpjbl4lS0QhWTSN19vVx+ehEiY6xnhpic7z4uyrMKkg
	 LJXjqAhx7FXxjNusSvp5kh831zZLkoKru0dTPyS9EovSGiUWyPRQfjkYu9/g3FyNyrQgJ
	 5WC8/JRgy0cy3vEgaxcpS6arc4PIiTD/tCxdMHOO6BZQlBBYyik22emHQgu7fSI8qIP/w
	 MpNoPCoDjhGFthrQDl1UxslS18Lb6MAu2Y/kT3Toxk6+/Qh+Cmp4DVslKMfINYfvjLgGr
	 8K4vKKuEd+Cb4QsWTFN97y0bjyWEKPR08uGMuPLBrxz/Bl5IDzis+/8FFVyFJ5EotuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dBLk4Ho4;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UvCbbhFz;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8599606A31F
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 07:16:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8599606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dBLk4Ho4;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UvCbbhFz
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N7F72o3154001
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 07:16:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=fnCHzkMl/tRSoOoOmfGusYJw
	L1UrHp+aabajQ/sL5Js=; b=dBLk4Ho4qkQhKjoVeSI5pWWyd5Oabiv1lWIm31KY
	XBcPtBr2vVtev6+fGdo4vrPDrsdXKHkYkE0KHMDJmc/Uijd92O4rCHkLwt6Vl0kG
	JcRP6P31K5zAP8WYNKKLS34Tpf/0XOnZD0Xxke7t+9MnxG/7hhHh48aobgtZsFf3
	xajKoBWDLqT8LxGT+2hAqjNB6hGg8BVoP+M26KVbUzAwfxki0wSf+KPrD0k6XjIj
	NsdJhcdsuuTIxZJSxJRe0+Rz9olSM+HpvP4I+fpDbJVe0RUhtF5PlQfLtgNpNC+0
	zrJtVtaJGpkQ3FnDwKvCBgXwLXUm+LJQ0T2U9LUIzV/j9A==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfqmradwv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 07:16:31 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92e82060977so115514585a.1
        for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 00:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792739790; x=1793344590; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fnCHzkMl/tRSoOoOmfGusYJwL1UrHp+aabajQ/sL5Js=;
        b=UvCbbhFzvXWqDloFrgUx1A3Am0vw5Z0gBizbaxxJZUWaoyZiajHAts/hrRNE/WVo28
         LMhk0YeP5MsUuAWLjxCMnZaEfGplFn1uwSkEiQSZRIl9xGZZyNbxZ9FiDQY2JTLNdZl2
         cgKrL/tzp4oZAfB5ZYlNWSn2mVO2AM5YEg2iN6qBvl9QOOIIdiNc3//A10DBFW135kak
         r+DyOrc7eDZIJ+sDfJFb+ylmVJISuUTMr+3mpEi6//cOpgE01L/9Nn6DOQ3wCff0Ca76
         bEXHvwIKHb8xZwyTCEuZJPB6e3qcrIPWZQa0/VexkmgdXnUmh0+bhB+SNXkgPuzX0wjy
         p6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792739790; x=1793344590;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fnCHzkMl/tRSoOoOmfGusYJwL1UrHp+aabajQ/sL5Js=;
        b=Ql7Ayi7FEdc+ZQHMXTR17bgYSBrpAnXjOCsYpAcBrU5sJ3yiPjC/lYyBGvu5RL+Z3V
         StTSzH1GqQ6GZKzBg36iuLuYY9HnzuXVyTMBmHGdhaC5uKpVKWuguHiGz+aydGB3GccV
         EJHAvNFrNYaUjyRk6jlkk4qeFWlGojYc43G38njgLnRJwrRzUck7GMksj2vN7PKEHQGk
         ddZOVqMLZMJ4AmrebL8K155JLR6rCPwf1LHKCXjLZsQMy8P8o8TSQ1/08E0fZD7yAk4g
         1/JykuVfVdKRTW286/O31JJLFYmPyjTDW283yIyxBLiSZCgylZ6EKDM36X4Gpy1xqFKv
         j8lQ==
X-Forwarded-Encrypted: i=1; AKwUvBxcNEKYy86g6/rdGgnT9l9K253pKO2gPCTIT3xUOsu1WFcn79ucc56QyjbV6d87NBuuVSqeCYRsV3LdN6A=@vger.kernel.org
X-Gm-Message-State: AFq9FYKBagYYj+yB/Gq9rDLB2xd5Zpjp2Nh1b/MzhDDlu5i8Sr3GwZrs
	D/PWhzbVUA5vzRUVEGoYagngONell6KBKFhDkg531iNiTH+LpzyZ5Sfk884Tl61P2d/nz+dUscr
	/64smJyyb9qSe7bH8K/Ly+hNSPVLDqeyjnINd1xuO5n98i7iBawlkZ+X2PJq3dtDbTEE=
X-Gm-Gg: AYBFou3w2NKZHffzuy08MetZGxOtRdplFrd5pBabhGjcpA2uC/ZTBBiiQnV64fEKBRI
	wFBl17+lXdm5Ct5I+fp4wPw34ENa4gJq92yV6YaKXuj43uW2ndzUPaUGqXrxHurwnUBfiV8fRLd
	uUTjfB8veci8l4mQDNVW4Yte065eFrgsbKoG+SgAQ6/x16/SigZiBFMgZg7hOaIKRAymuF3B7+T
	pXSVZHFzCRkqpYzuAbSVoj2OLSBPAiJAkjX2wBPb3ub0r8X72NIMaDSDDjxw16We7Mxtd8EeoZn
	A1YVoJHRSJ695GlATWxoZeaHNr3Xlf+7ZgObvpV5m3RtGfrifiUmMrFRvvxLnKLBM1avzDMZWxs
	SbritawlxXnibrq0P
X-Received: by 2002:a05:620a:270d:b0:939:5d22:d1f0 with SMTP id af79cd13be357-93f624b1fa5mr751725585a.2.1792739790121;
        Fri, 23 Oct 2026 00:16:30 -0700 (PDT)
X-Received: by 2002:a05:620a:270d:b0:939:5d22:d1f0 with SMTP id af79cd13be357-93f624b1fa5mr751723385a.2.1792739789532;
        Fri, 23 Oct 2026 00:16:29 -0700 (PDT)
Received: from oss.qualcomm.com ([188.27.161.187])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e38048ad9sm3287521f8f.35.2026.10.23.00.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:16:28 -0700 (PDT)
Date: Fri, 23 Oct 2026 10:16:27 +0300
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
Subject: Re: [PATCH 5/5] firmware: qcom: scm: Drop exported ICE wrapper
 functions
Message-ID: <hwjwaxabshws26kx7xa5qfdxnj3zomkvetpbp73vnl5ugdmvae@vckrsfkyptbp>
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
 <20261021-ice-migrate-tee-svc-v1-5-b035be7aab0a@oss.qualcomm.com>
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
In-Reply-To: <20261021-ice-migrate-tee-svc-v1-5-b035be7aab0a@oss.qualcomm.com>
X-Proofpoint-GUID: GIHrwFLWa55ZJj_92tXhriY0CBhFrzT4
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyOCBTYWx0ZWRfX4fWPP7iYk8tq
 EEn/DAwTK+qAEZRfTOKep6jLD67wwBX2cg38e1fNqL+cZyN5hArKkBnZqppdpp9+pfgVrnv6/Im
 lFyCZS/Hq6urOu/nTvzc+n41vWRBdnI=
X-Authority-Analysis: v=2.4 cv=VNZIDNPX c=1 sm=1 tr=0 ts=6adb09cf cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=Qvngrl3H0rQgGg+94q4QgA==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=-aaPCLjwiM6LKh8ESrQA:9 a=CjuIK1q_8ugA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyOCBTYWx0ZWRfX0dPU05NG/kKG
 vVPEJ6KMANycCc7v5UNdXH8e5V5FcbTt2wOGoy9Vjofo/Sui/bNAasFaa7hIfC9eo4RcnmHp1Pf
 528vl7crVytrBwNUf83qUtUXytsFBBbXs5RBh41wENvwcO8NTofYaf8UnyV+mhk4CrB+OqDhwhp
 WbcTzViH4gZ3dgYfg8HinetCYqMTMh1iJl0/Yl+s8JevE84MOsOaKs5HDLFQRFvGdetKG3T4nPC
 ufvfes4DdSO1Unpu4ETWwTKraJ1Lvvu7J+pGqgNKpmojcfxS3BS3K/BSyIJQ6Pm2BEqn7pzCxhk
 3sgBRuUbLNBELhRWsHhS9cLhhjA7SrDsBTnCQGLk8PDgMrnuCGkhRsWwnVVD5OUr94sEGoqAsaK
 p9afUp36W+FbIM3muLwNDs7htLefThURgT22yXmbWUHJ9x+Jx7kzvGNCiHsMnHy87HAbrbWDxPK
 rORbhF/kF3jdxGrFBDQ==
X-Proofpoint-ORIG-GUID: GIHrwFLWa55ZJj_92tXhriY0CBhFrzT4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 adultscore=0 phishscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230028

On 26-10-21 21:13:11, Harshal Dev wrote:
> Drop the exported ICE wrapper functions from the SCM driver since the ICE
> driver has now migrated to generic ICE service which allows re-direction of
> of ICE secure service calls to the appropriate TEE (QTEE or OPTEE) at
> runtime.
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
