Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043CF301486
	for <linux-crypto@vger.kernel.org>; Wed,  6 May 2026 06:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778050399; cv=none; b=ZEUUE9CujBTaT95WiHNkSZjtHsLlpVDvGb5sNtedxvG+F8fQZgqHSNJkR9tpZioRa6FPfG9tOB1MeORf0A8yn3kufHFMkVg/JgPP+fLSLJWB3fQaIezqVcPM367MJ5CeWMMbhM1mhhwoOC1Yy5uASSuWfaLEauGRIygHfRWTxGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778050399; c=relaxed/simple;
	bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
	h=Message-ID:Date:MIME-Version:To:From:Content-Type; b=JnYRqdLjL4VbNYCSEdUjtDMv3oWaPabSOQlC6eAtLjrtgik/WCoMOWw4P/stoDw5SKaU8mRHGtHHC9hi3DKqHAAf6/oX9HW3vt8YCvyw6NZwXiz0sA48HRu4wf0kme6QZa98WA6OtVqZmRdlDR+UlNrHhuxvNObEaEuqPHy/gYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DifNAlXy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=grb7Czvz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DifNAlXy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="grb7Czvz"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6465hemK3475814
	for <linux-crypto@vger.kernel.org>; Wed, 6 May 2026 06:53:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:to; s=qcppdkim1; bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++L
	fAOrCAj6OvBfk=; b=DifNAlXy8+3SDe81N2g/k9vns4mF5uz6vUyplQHkiUo561
	JeCKNx+PbdL2T4YZsD0I/yWxYUvcNGQySr6ILvmTOmzn1PBCTx3VfUHRtOYzGdK4
	C9+w4mB+DUX7iKIbJSJU1uMVgmGi84rTTvAuyEuzNw0WRsxjYwLWf7zKZOjpTi9W
	R86OFuv0yCCxdj6VAeagwIPI2FgiQp9MH1EudURlyr0/R9Cwe9sLUXlT9jnX/Xr/
	X8YVztzdSLVcBiUOOnWt15iTSJk2Gx+v2KpJIezxznJKIekA5O0F8NiA5iWKYgRJ
	gfwjwvGWrJ7pei4Hb2L+CLAT6frDw0OvXWpz1rbA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dyhsguh1f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 06 May 2026 06:53:17 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35fbaada0caso5463106a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 05 May 2026 23:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778050396; x=1778655196; darn=vger.kernel.org;
        h=content-transfer-encoding:from:to:content-language:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
        b=grb7Czvzu9qBgI9as+z9Fq0IiDly2ZlVowz0jZGSjkCkULOgq/8u7pX/Rk0+IHNUw8
         tELRf/Jtrn5qm9vUwaIThFm28dL4YJb4evzGZFXlFDcE6wlizFmWbVd0C5NjgLufWv7A
         lnUIuB/NhCUOJh97pRx90GsXaEZ9CKJpJMkZ2hSYxRY8+T0vd67zMwE57zL3iASlF1lL
         GFXpj1jxN/7cU0mS61xOjA82U7Im9DA6TMuVwFEPJI6w1cI0bTBQpid46vSPi9hAHt75
         +bGtq0P6yH4hMWvzuNdrNzLS7clae0I6fwDxHozXZm1H2kEFi6Nu8Nue1LccK2lj35Ix
         Iqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778050396; x=1778655196;
        h=content-transfer-encoding:from:to:content-language:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
        b=iqEbUyNNnrbnheq++EzhY7aZXDyHk6IbAIH+bL3EIho3UfNlUZtE0fkunwJMidQySL
         jQFNNllCAP2Ryfsf78HjMyiWC7rd47PkZIhnVHO6de2RZqe0AO7972msEPz59FBh/p8o
         QGEehr73ML5NynPcxssJtyrGcmmZsFkxtM+G4tSXT09jYVz+uS9oPbAYYSdf9220sIq6
         znKf1RjFItfUbu7GN2edIcY6Z8PdICIyMu0QJsqAZfx7UddjddgY6yjtfIffS7RVSBR8
         LOWQW51avJ665Rr8K24HNqaDES2e+zfnFfnH39X929r3wr79l3o4x2sNDZlzA+IbUZOT
         KpaQ==
X-Gm-Message-State: AOJu0YxAyDEf/cwXExGzT9GDuEonCwWG96iVqVd5AaiM357jnT/tKoyc
	cAGi6MlJv9RSUxLFDAdMjIxCTuY5pmTyee5+vP3hx33FQPSbUfboL1FyGc2YTDKvYZlfl8Y7QMz
	NNbLIy4J5Yy1hJvtSLfc87HbWQD76fdYoxdz02moamDZ1Ec4PDHgkZViB1lLj7J+nwXQaTgeSvA
	lWT3Af
X-Gm-Gg: AeBDiesCtM5HYSqBq5RTjPdQQNoK9MM+fG/OiG1tPZIEhInY5l9/pINa6q4uug10nb0
	Fmp2/dyTzqzPFAEy7k9y1ZI2ErfyWjxRpI+EzM+DAQktSbhvB+GlrpYX0sKl1Amu8y0ikLNpA5b
	3POXKK5+1x0fNRzMfiq2q1nsfnbWTbT+WOynPxeeEGgOYJa8R3HdBSle2J69bBHGDZ8E65fOqKD
	GEKa3XQ54s+T6bZFcUAyVcHuaOolSTu6ZlH3Yv4HqRCyfQuRMDeWQhj1t/iYdAcZt4PASuokw0e
	ceppX6lt5DSrA/4uLLnX1BWl2vMLDXcTuot+oszqFxOFoIeYsuL7vaWsDInYuBkvXgLrOEhuTil
	aYjekNTf8Fxs7Kj7MhXRnEyse9HZ7WthRFGpsZMU=
X-Received: by 2002:a17:90b:4c87:b0:35f:c796:ca5f with SMTP id 98e67ed59e1d1-365ac4717a8mr1962285a91.19.1778050396133;
        Tue, 05 May 2026 23:53:16 -0700 (PDT)
X-Received: by 2002:a17:90b:4c87:b0:35f:c796:ca5f with SMTP id 98e67ed59e1d1-365ac4717a8mr1962270a91.19.1778050395619;
        Tue, 05 May 2026 23:53:15 -0700 (PDT)
Received: from [10.151.36.91] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ba7ca2563dsm13283615ad.76.2026.05.05.23.53.14
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 23:53:15 -0700 (PDT)
Message-ID: <f2feb4fa-bad5-4c1e-87c5-be3dcaf4c6e4@oss.qualcomm.com>
Date: Wed, 6 May 2026 12:23:13 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-crypto@vger.kernel.org
From: Md Sadre Alam <md.alam@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: RMZRNFIRBWHRUdc4yYmbM0YYRdbrnzGP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA2MDA2NCBTYWx0ZWRfX7TZhDLAGYahT
 7FfFf2uroDYN8r14NCCGKL/QqC12W8yAG9NEp0F9shwJaL6y921gS/4YeoPw86PFL7fvpa+DiHS
 x1Lh0oBuKwCwVJ1tWR1VrrvldQdPVA+ByIFpG42s2b9CUka7GNh0bvc6v35U1b2iTUTadIIXTV/
 cvq/LcOnZMxt3vVdeAcyFCuTdgz3Puftbflk/AoUm/vqFHIMcMuW6v8dPpf7jkfk3+XRLHpiRUv
 gW26cAVAyXrzJRHDFiMo/NiS2XPIeDAWdOdnbNgy/y/VN4rao719W1JQDY5Mn5KtJNsrB+OAu5U
 fTfkKuyVN2Pp5twCTtB0QM6VhG7tuCTS7Sm/eKm1ma3/x4uOXqJJ+fBpF16iMgk6+3eGJcNBHPX
 HltyqKYaVwQShZIn6d/Yf3OnNzWRUePZF5fwrcC3sgV0eS6fuyOw0q/GkuDWybvOnd9SYOauvXc
 QGmwFMUwAgHTtybeKvA==
X-Authority-Analysis: v=2.4 cv=EPU2FVZC c=1 sm=1 tr=0 ts=69fae55d cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=s5jvgZ67dGcA:10 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=JV2eVSZHMSyV4Tj97bsA:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: RMZRNFIRBWHRUdc4yYmbM0YYRdbrnzGP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 impostorscore=0 clxscore=1011 bulkscore=0
 phishscore=0 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605060064

subscribe
