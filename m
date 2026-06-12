Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA8D26E6F2
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2026 00:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781224856; cv=none; b=ZfD/NmFXddlZ2OWfJJMBhrl0gPMgOTKHJRi2XEqI3/X0gMnVm3EZRyQFkSsnCyjMEeuzEo+awmHPkuoIH1UlDNLlOin/Rx9Ugz2bRihabzDYNk6ZdskDmRPWmyzVluoZaF6Ab7+iv5EOybKEPWpBA4AYSf6Rbqib4+haBE4uIVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781224856; c=relaxed/simple;
	bh=pSEyu1os1/ieohWcWy0u9zFBNSIwzLF8niWiWSbguJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YO/UQVbaLZkE9f0zUx9kwfq1kC9ppn/Wk+HvTEL093MaNgco3tQnN4Tm/PHUFxOKv97YcKd8icaRnhtrKfFfDjpQoQ07uUjv51gAymmE67GfZSq0yLbdE30EyGiWd46zvaWJJdbh6sNodY3kxmXoo2oxttPpSAPHqJSsmaMYsys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=R3d9RZaQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dim34O2k; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="R3d9RZaQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dim34O2k"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65BMUdZa1864546
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2026 00:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=Oy7gQId7O6GkV4H/lWC4yqwP
	VMYWsWW15qBFZKPvcLg=; b=R3d9RZaQW+yTDjxAanyZRTz1G7drs4fVWoHCWBFy
	5DgUqK3b3PzzG4Bl2Zjks2KBrG4ht9a72tz7vkPnXMXhzkf7mYKCDO/2MXv/P0KT
	wCc2shdt3sHBR5JRnc3iJU+eYW8AqfSGshjEp4SAKghF11Jbnmf5+VkzIb3EwM6j
	gr+7AJnVku5bzxFQKNSWd9D9yfKw6LFTw7ut7jPOn2vjqpB19dWLcU36qOFu1beN
	hSMrRsuV5Ag0hxMtlf6Zo4i5YshvYRuH4M1xfVG5UhCP1ll95yJDGZbI5vTknMEV
	XVYapk5HExjk9f5Yx1/UeItG2qzKG25lt/x22mVwEFWuhQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4er1xchbh1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2026 00:40:54 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5175b7946d5so3159961cf.0
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 17:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781224854; x=1781829654; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Oy7gQId7O6GkV4H/lWC4yqwPVMYWsWW15qBFZKPvcLg=;
        b=dim34O2kfBzqwhYbckj9zZDhvKOim7i/WNu3KdZ5qeSK+M8J6WxZHbBZTzmbO4fUfh
         H6z+h2pEQQQzyXzRc/G3DPzl3rmXvRfJelxcAni12+Rejphzbc5U7jLKoEkaij3Agg97
         /Lr+C7BOhdzrnvXv4BmPr6ai4r1SmFEmzLh9qSAxtFzCToTUFQqw7SfNgddpRapKBMqu
         UK4W0Q83TWQidqw93v1LcQefgL2kSQ7DDi5WomALesata1MuH4dezUO6xIQNdo80dZBD
         8K2/RgpjdLlMTYuYOyw3jQ/ipCKnfsIe6zJ5eS2ovwCiR1SevfkyHmpHyUevqqIi/M8v
         vfJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781224854; x=1781829654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oy7gQId7O6GkV4H/lWC4yqwPVMYWsWW15qBFZKPvcLg=;
        b=Rn249dM57OSrJo/M1afLPytREEKF1qOh09WSpm0Jsoo5zt6mcPEq4bgwQBquGPqCzL
         CNteTPjCvqR/w+9Dal0SUxwmazkabz5KIXAoDVYQASbT2C3ILKtnZc4KgYm7PeRxbBUw
         YzAtHtvXje+FGzxA6Ted2VAdbG2k+V9oi3sMu36AXbdWxoNlc3sJKrHMLK0IINNvLzsV
         aoWpD6kUR0Hus3KP3rw/esTnRvuFDT8nMy5xT8bfewyuhu7A6EVOMAaoksi+QqbNDT9e
         mnmqGVdUfUi1llm+ps1AubGDn5hGuebzGOFBvNX3dz6S1CbWKl4JBy8NkIhU8hZkP+9H
         xGcA==
X-Forwarded-Encrypted: i=1; AFNElJ9OiOuJbrckhU2upl8ynLSbyQp1tOoagsXdPJTwbv390QLuwtBOBJ1U6P+xTL9RYZx/H/Jt5AQWaxcAANs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0S5ku4cZiBemH8NyjvdEd3F2lrYX3L5dBVJ4iwGdmlXEjkcoO
	Hfpr8yYxJk8V2fkpmOTs8970tiLx6/1ZOscalptfdqAGYlw9nSm9tRmYi7aUzfEHTNc4iC1IWBv
	jB828hmdlqeIG+XOFcyj/wsTb65E2Uuy9alkUhMZbo6JF4umhQRUrTwOIOSpFW5S5RXM=
X-Gm-Gg: Acq92OF3OOHL86NGM3IPL92QgGypjTp91LALUz4odwZ1m/EvUsll+l5QoKUlmsMnCJ0
	BjbI1n9vZp/63hj+kgl4XujjPywZAHYNwAT9gkCFxg3baZfI7XlrM+SNubr+H1GTAIppDViU4U7
	fgwDM4LQVueJimuXOaIR7hYquy4aZSoXf0py5xadKjfbPpSOFX94u+UQ74xW7x+PEfqfp+0YuFJ
	y/A14FplWmYrMiU4fZJubfcDA/59DwDA7HCQ/Rc6Jkjq8YcNuuzTfVoFWn58RExAonsdNYev4x4
	gYXD2KPU6ZGfMuaJks5gFih7oy/o6pe9ZQyum1nmHpeqZUYfWTKaLpTbi+EbPDfP4mFdf+RUyqi
	PTWqL0x4lL7dqvl/YjMeT+U5ye+Txfz5dtcTCzmZTnFLdBuxmNh+5kkOKartx/r1I8QW9zq07vC
	1t9j6rR5+cgHvXXpApJ64bhsTqGT2FANyw1vg=
X-Received: by 2002:a05:622a:7e4e:b0:517:6435:c4ce with SMTP id d75a77b69052e-517fe6031e2mr5681761cf.49.1781224853913;
        Thu, 11 Jun 2026 17:40:53 -0700 (PDT)
X-Received: by 2002:a05:622a:7e4e:b0:517:6435:c4ce with SMTP id d75a77b69052e-517fe6031e2mr5681521cf.49.1781224853414;
        Thu, 11 Jun 2026 17:40:53 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5ad2e1a729fsm58925e87.54.2026.06.11.17.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 17:40:51 -0700 (PDT)
Date: Fri, 12 Jun 2026 03:40:49 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: qce: Fix xts-aes-qce for weak keys
Message-ID: <533motquixnbence674lawbnlnxevcrcnysymwncjis46j5uoq@wcemraangg63>
References: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>
 <20260610-qce_selftest_fix-v1-1-1b0504783a46@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-qce_selftest_fix-v1-1-1b0504783a46@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDAwMyBTYWx0ZWRfXxacCRu7zdnUI
 y7Im0UCocaE5Rqim1C3ofVY7UveJyDtXvBE3Cs9paIxTN75eSQ/EoORfzJXe12AC7wRQfFCl2qu
 3C2YLUE8QOuOfrawhI6QWi4APwBLGLFVXQKgXKBnFfymsA3pjKMLItcgLDM6gi7vboRkAWnfCZH
 G2s+6Whq6UpzSpynad5nlYeJZBDA+i3TcbCOs8j4o/33d+CsU8b5330gxgHf2yLcviPl0uUtihX
 C0+fLm+rIGkqUhu4AUmkVymE7HtPh4zAQ7bFucH/On0VTDIRUpm/zINHTQ5VHcPUFSzcQUiwQFQ
 2O5usQX/J94veRMt2Yqk8gHmQywHO73qkUXf+7f0+aLyPzRBSG8Twsv7enWJ7w2LmIwnzk+Y+oz
 iMup5l5DDdFSJtG7nJ4G6AHA9EQL4aHxNCb9GLJdWtxcC/mvnsixfNiiJYDIcGqrzarbjCrtC/H
 Zk7/4do1o/YtpjN5t1g==
X-Proofpoint-GUID: 82WvdDMeZI4-YrfHFKvH0xiwQlG4Tyt_
X-Proofpoint-ORIG-GUID: 82WvdDMeZI4-YrfHFKvH0xiwQlG4Tyt_
X-Authority-Analysis: v=2.4 cv=NZPWEWD4 c=1 sm=1 tr=0 ts=6a2b5596 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=gYdrlWxjMMiVXSwV_rIA:9 a=CjuIK1q_8ugA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDAwMyBTYWx0ZWRfX2VYhXR0G3UyS
 9q+4FzYgp8qFZcgd0vJ3hgjjfzzQ8j0axB7p9jyeEOCAM28QC2jRHeUScBU96jNJzmti4T/O5aV
 zVUylx42+iHBO+yPWC0L2l1eKi+tMkI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_05,2026-06-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606120003

On Wed, Jun 10, 2026 at 11:24:04AM +0530, Kuldeep Singh wrote:
> The QCE hardware does not support AES XTS mode when key1 and key2 are
> equal. The driver was handling this by unconditionally rejecting the
> keys with -ENOKEY(-126), regardless of whether FIPS mode is active or
> the FORBID_WEAK_KEYS flag is set.
> [    5.599170] alg: skcipher: xts-aes-qce setkey failed on test vector 0; expected_error=0, actual_error=-126, flags=0x1
> [    5.599184] alg: self-tests for xts(aes) using xts-aes-qce failed (rc=-126)
> 
> In general for weak keys,
> - If FIPS mode is active or FORBID_WEAK_KEYS is set: return -EINVAL.
> - In non-FIPS mode, Accept the key and encrypt successfully.
> 
> Since QCE was returning -ENOKEY for non-FIPS mode whereas the
> expectation is to encrypt content and return success, the selftest saw a
> mismatch and failed.
> 
> There are two problems in QCE behavior:
>   * -ENOKEY is returned instead of -EINVAL for the FIPS/weak-key
>     rejection case.
>   * key1 == key2 is rejected even in non-FIPS mode

Rewrite this commit message to English text rather than multiple kinds
of the bullet lists. For example:

QCE hardware can't support the insecure setup of the AES XTS cipher
mode, where key1 and key2 are equal. Currently driver unconditionally
returns -ENOKEY, while the rest of the system expects to get -EINVAL in
FIPS mode or if FORBID_WEAK_KEYS is true. Correct the driver to return
-EINVAL instead of -ENOKEY.

Then another commit to crypto testmgr to let crypto drivers fail for
AES-XTS (and also another commit with docs update).

> 
> Fix xts-aes-qce behavior by using generic helper xts_verify_key() to
> reject keys early with -EINVAL for FIPS mode active(or FORBID_WEAK_KEYS
> set). For non-FIPS mode, since QCE hardware cannot accept the keys, use
> software fallback mechanism to encrypt the data.

No, if it is a hardware driver, there should be no software fallback.

> 
> Fixes: f0d078dd6c49 ("crypto: qce - Return unsupported if key1 and key 2 are same for AES XTS algorithm")
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
>  drivers/crypto/qce/cipher.h   |  1 +
>  drivers/crypto/qce/skcipher.c | 20 +++++++++++++-------
>  2 files changed, 14 insertions(+), 7 deletions(-)
> 

-- 
With best wishes
Dmitry
