Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964C73AB5CA
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 08:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784622314; cv=none; b=ri0e1wkuIbplU0ej23DWAiuzwgVHndPbr/nkkWfmSuOed3wohgeRXQYWajsYw7ic0FMgL8KKtlh3B4wPIPkwuZzs0OnGa6+XoccGt2trrQX+YzuYk8ChuwMbmmfo6r+77pclewK6RlH4Hn5EVSMIt+Sf9TfaeapuoqtJoiWHx+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784622314; c=relaxed/simple;
	bh=zfTn2Kc9WqhfDc14tF4xKypbGNJXvuqTxtRlcOWMzUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbWKsljvpunY9JPmd+jc8JIWlRoWuVHIa46pNbtNbvmZzHAumYR2CLNhKBIj6dMzcJoaKmxk0kQaeiXK52rosXlmrjuDJ6l/sdsQkx7EiAoJ+oCH5rE3saR9FwpCtZ/26t/lLO+MrnuS3K+RuyUhisuS8I+/xvHfbwCJXXbNZ8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gCrU7rNE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IFqoIrcw; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gCrU7rNE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IFqoIrcw"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66L6aG7l4150258
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 08:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=ZOpXARkKmNj
	6Eb4RGQZtpa8uRlFLKJu52rmjCAOrvGE=; b=gCrU7rNESdBaziZfASg/j/KEnMQ
	sdlPBSIT5NYy8W/vsKm1PIHRQOoaN1kZx+0mOp3sFJgxqa9gnVQ0+LjRX/x8uzcN
	C4ZwgcgIDNI1+mIUyfLz+6J/yhejv6Elal4j7p/vmpumcaIPWtLNfXMI+Vm7QjOd
	4DeNvwp5dVK98Axqbt91dTcWJcT3r/slntjW+4llujsAcm4OQphLHGyvD7/T13Gp
	EDs4bp8O4wcyswzyNF7j7ifD03hESYOfCokjbvfLYXdz4w9+sD7iVhu4HBkqmVOW
	vXI6NoEScJ2l4LZPJBUggIzVUavw7yWejaIGwva49mQJ6bKPhHA455WGdRQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fhqff3c4b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 08:25:12 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8f08560ea44so164510236d6.1
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 01:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784622311; x=1785227111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZOpXARkKmNj6Eb4RGQZtpa8uRlFLKJu52rmjCAOrvGE=;
        b=IFqoIrcwCDKUK4quSyUVG7fXv68QU/N/gS17Z7NZvcgoMIU9HxAqiIAlPIWXqvbbTg
         kUe1ouGsuJ5WJjfZr5NwpEc4iW3v8s/974UDlhQwM2qDYhxe+XyoVuHpz+CUWT71RK8J
         OQ8yKxHaeCp0fTP+haFDgiPsHRSuiaDL7QM0Q/9YeR0l1PwsrKZJ9SyEM+rmBhwBwXyI
         EzYPYVCLMokagAjuk6r929ruCOW5zOjqi4MwmjR9nX9ZdUyQBHI0JAtWgxhpbJ0PfYyB
         JbjiF7coe1tQN2t907iwHs7KFXI1Wy6D3NOPzhjeG3kq1qeqtF7pDnlLBC9IBHvdq4Og
         aF7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784622311; x=1785227111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZOpXARkKmNj6Eb4RGQZtpa8uRlFLKJu52rmjCAOrvGE=;
        b=KIUhXhvu8LdC48qehZSRLurmtKiAWk7ge3RpFUZFC56N1q3GzUN4cf/Cgh5tbHDEob
         P6QOWara2hzgNi/xOyYMBviytsbBE9o8F3+E7tny+JDYFGgGMVzIC8CVeZ0dO7IMYNtX
         rtveVqkSe0UsA8BbRVA9nXf6yziugM0b++NJs4atggrdxmG9P5Kgi7ZOfQlFqJNTIN4A
         4ZseEE/Rtt1DRauflO1kckjaEFUJNU0QOFBpknFO336y+lPFRgbAR2all34tg1D0ro7Z
         8tzxqe9NxnIFc+Q2vC9PWLIDtpDHTJJGhjUHKylcf92R3BajYjmHA7K+vQg/0JEjIb4L
         SNbg==
X-Forwarded-Encrypted: i=1; AHgh+Rq8nrJK7AfM+pcwSNXtu2VAYST3BOUi23KSzp6cFBEYUC29KyKUioyLHDbYw0nnWpsUQL65GKk815dP7x4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOkg4E5qXlE8FtTgYXa5SlfAlpftWusq3Y9FbSAGj9jwCss1e8
	t74scjcWpn3WfZ8tvc+VpkxphqvogJ5b0kooJzeAkeZaSZnOs1knLU8TV2BIJsZbb7BtRL9sm9M
	4ODNDiwX5c+uFpeit02bVBrkJWz5Lc+PP3M5Fja+mUCSArnzRsA+mjvrL5JJv42Xua1Q=
X-Gm-Gg: AfdE7cmskZCSUDQ+BZ4McSPpybcq9RFdHkuzD331icaJiK/dSFFhS1PdSZJjGL54izK
	tY5bD72cdag697NtyCMi+rb3LFqJ25AIo+nPpRU+e0CpSSBHNL5Ez120x9gYYjI9P9jQfuv+Ujg
	jp+EeHCcHcpfGfwMobSJlq9Ss1OpiGtXWivi4imOKoPetD9G2OBgP2WKYGw7CfcB8iSVrtpC/ad
	yEmhS3EkJqTzU44aZvXPsUwq1HhfIDGZM+s6mTxYMtd6bBdlf3UUj20bX9i12PtjSJMuh6PDUfB
	YS+cqFAL6fkKsG0cXgrvk/p7eGp4ybET6A4JM76djXPNdZAHGBJkayVJaykizEjZ1g/1dotexrP
	PdIBVmNbydgniczmnLfn63a1DFahs
X-Received: by 2002:ac8:5d13:0:b0:51c:bb79:a52d with SMTP id d75a77b69052e-5213aa6d813mr166970791cf.14.1784622311459;
        Tue, 21 Jul 2026 01:25:11 -0700 (PDT)
X-Received: by 2002:ac8:5d13:0:b0:51c:bb79:a52d with SMTP id d75a77b69052e-5213aa6d813mr166970631cf.14.1784622310894;
        Tue, 21 Jul 2026 01:25:10 -0700 (PDT)
Received: from brgl-qcom.home ([2a01:cb1d:dc:7e00:9dcf:9ab8:bffb:ec35])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f67466e09sm39901054f8f.21.2026.07.21.01.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 01:25:09 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        demiobenour@gmail.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org, brgl@kernel.org
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
Date: Tue, 21 Jul 2026 10:24:58 +0200
Message-ID: <20260721082501.6128-1-bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <alnlaCXmoLRAlr96@gondor.apana.org.au>
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com> <alnlaCXmoLRAlr96@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDA4NiBTYWx0ZWRfX2nTjlbiEZ51x
 TVp4iSGGT4THS+LBqgfGhrOgsHGcO0fvp0rCtRqhrZ67OLh+guKrlujdLyaQaiKBZQvKFk/YsEg
 VOPQweZh34jugQ9Sc1v1bAb/gR0HHC4=
X-Proofpoint-GUID: qstLvCy0uVENiVKyRJdZp-FQIamcIJKY
X-Authority-Analysis: v=2.4 cv=FJErAeos c=1 sm=1 tr=0 ts=6a5f2ce8 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_glEPmIy2e8OvE2BGh3C:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=pGLkceISAAAA:8
 a=SHEdVmtcqMJQtNp9YQoA:9 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDA4NiBTYWx0ZWRfX/mPBDQtQ7Rpl
 vTEp3SKDDbGheEuEHhNjHRJJl/2e/O9rYbj/W4RmnCGgru1ge4hanEycxhzRqcRVITTM/ifnlMm
 zKbaIG7C2ITkm15loKIE4bK+BbU8lKG6ebVltMqGELjpMMoDhjO/6uHgxBMFthwpMiuV3RBJNst
 8vrmeAYVwEH9BXd9qLLTnzH2NN2xZrjULtEY5hBqtQu7oPGUCFdB/6OQAYwtSbwKFWfMwcHHLo/
 RPxo6eXF0uN6Lw/ZMmpWjgF7xF+i+yhbQ+BKU5wFDXig/DGVD5+qe6dAbqAnz1eTM0mkzQbQjeH
 FkcK0TBlgDg3u+LCLsmoD8OB/bMvon1B7TOzkWUC49+HpVmB7m3jL3aRRb0i765/iPegQI03kq6
 7cuHFORO31zJ0HAU2sV72gTh5PL5bGHBIqQCm1/VU/XYtoDItAAcyJlbXYjFgalzNtE2rNkR8dw
 nn91i2uSE8Hn+Yt6oHQ==
X-Proofpoint-ORIG-GUID: qstLvCy0uVENiVKyRJdZp-FQIamcIJKY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_06,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210086

On Fri, Jul 17, 2026 at 06:18:48PM +1000, Herbert Xu wrote:
> On Sun, Jul 12, 2026 at 05:31:31PM -0400, Demi Marie Obenour via B4 Relay wrote:
> > From: Demi Marie Obenour <demiobenour@gmail.com>
> >
> > This driver is harmful:
> >
> > - It is much slower than the CPU [1] [2].
> > - It Has a history of bugs [2] [3].
> > - It does not have exclusive access to the hardware [4], causing races
> >   with the secure world.
> > - It register its implementations with too low a cra_priority for them
> >   to be actually used [5].
> >
> > Therefore, disable it to ensure that nobody builds it into kernels they
> > intend to ship.
> >
> > In the future, the driver will be used for processing restricted media
> > content.  However, the kernel does not currently support this.  Since
> > the driver will have future uses, allow building it if COMPILE_TEST is
> > enabled.
> >
> > [1]: https://lore.kernel.org/r/20250704070322.20692-1-ebiggers@kernel.org/
> > [2]: https://lore.kernel.org/r/20250615031807.GA81869@sol/
> > [3]: https://lore.kernel.org/r/20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com/
> > [4]: https://lore.kernel.org/r/20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com/
> > [5]: https://lore.kernel.org/r/20260524204537.GB110177@quark/
> >
> > Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
> > Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
> > ---
> > Changes in v2:
> > - Add Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
> > - Add Cc: stable@vger.kernel.org
> > - Link to v1: https://lore.kernel.org/r/20260712-qce-broken-v1-1-85e2bff17871@gmail.com
> > ---
> >  arch/arm/configs/multi_v7_defconfig | 1 -
> >  arch/arm64/configs/defconfig        | 1 -
> >  drivers/crypto/Kconfig              | 6 +++++-
> >  3 files changed, 5 insertions(+), 3 deletions(-)
>
> Patch applied.  Thanks.

Hi Herbert,

I'd like to ask you to back this patch out. Admittedly I should have NAKed this
under the v1 thread but I thought the discussion we had under the Shikra series
and the subsequent patch making myself the maintainer of this driver (note: Demi
did not Cc me on this nor the Qcom mailing list at linux-arm-msm) as well as the
pending series[1] fixing the QCE issues was enough to imply we should not mark
it as broken. Please consider applying [1] if the fixes in v6 are correct.

Bartosz

[1] https://lore.kernel.org/all/20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com/
