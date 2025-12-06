Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6BF153598
	for <linux-crypto@vger.kernel.org>; Sat,  6 Dec 2025 11:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765021551; cv=none; b=X6RTSpb7VF0L50zdydPHTB/vguKluvQvgjFqmqOyEaRbkFj3aIYSnTXZFuCOGGHA5tMNpHECfBQs4xqFN/eHubBL2rMdF0rm3kDP325P44boOiMKru2FnDni+NV/k4QQuO9BmcrUVpJxPyVnOW+Nh6UDIycFqt5Xd8WYtCtRMzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765021551; c=relaxed/simple;
	bh=yfJjYI1TKTl+dZ7vuy+EKk5k/Wwc7PCUSaLTtm6n/TY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RoCgNKW12xkQWITG2vp75DP/C1v80KZOkZ2paByeTIoLxMmA9s+kUdINR+v1vPjvRcb9OS/o45fgZl7otNcexAatxcR97HycXQVuFDoC9OgHA/bbpErKiQgcLOHgN2TE5pyWzfnfa5zfFscLS6a+tdW1z/nFDOH9SSjHh15MS5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZyOzA7pe; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HaLm6bdZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZyOzA7pe";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HaLm6bdZ"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B64dlZO1620974
	for <linux-crypto@vger.kernel.org>; Sat, 6 Dec 2025 11:45:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=Qd3aBq0UymBii6ZFMhW0qvHm
	kEhMp8LfhgbHB7N8EfQ=; b=ZyOzA7peZHV4/z2NAtE5wgB8cBXN9TpCFGUdoahZ
	1MhxL98urs58pWFrqkOP3Av/NXo/N2NOFNrvUJajZS911nC9OsuQ391rYqLhSXqu
	4VYdIxXEiTvCcCIXyW+ap5dd+TsquG4n1x5/HTBRRCK1b3JTLmVKO6e4ct5wF1xI
	b2noMPAuSwKT49IYhUVhJ3xzwRehNwKoz5T35XEoSTsqzPQ4K0XAnEetQijpwkPq
	GfrFA1obaGec582kqqyqQIUsw4rLD/V8j7wPsEUUU1rDO9stkb32CHXRrCYMrt6V
	ylYRnP9FmUbZUhWY+54oSEmDUAnEwXpCaXg9cORy9fbgSA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4avdnjrj3m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sat, 06 Dec 2025 11:45:48 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b5c811d951so91421885a.2
        for <linux-crypto@vger.kernel.org>; Sat, 06 Dec 2025 03:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765021548; x=1765626348; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qd3aBq0UymBii6ZFMhW0qvHmkEhMp8LfhgbHB7N8EfQ=;
        b=HaLm6bdZP2VYR77HcOq7ui2e4kK0EBKXPAJZEqGiM/dC/kp9f0qAKJcLcL3BUR8rj1
         LT1ty5EMm1K9sNfoEfYbsaRij9KmMGbekpIZRm6K+RbhEd/fwdwWKylZ7cjmTATGdle9
         MPzvSkqMrK7n/XH/xjnqioQ8+VJzJTno+w9s/FOEFw7LPJ0kv9lkLvJU5k7BcTKe7JHy
         GrHw+l6Y0LT9yaqF3u5VYMWr62Z3p8wigBWh8jHPkaoaNmO+x4c2/DoT36/bNDQEbNmA
         a5n8umnTxs4cZih21srC9KWfaznpWlMST0jqS8r8JXZMeK8/9fJvZYoALYTidKLDlzyD
         vovg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765021548; x=1765626348;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qd3aBq0UymBii6ZFMhW0qvHmkEhMp8LfhgbHB7N8EfQ=;
        b=ju3tgPyYfQhEJ76uyPmtaT7gMtRu0dF3TkM0IKweSfVj7Uq6QyeZJV+1FCWyECfkG4
         gtfvRTMt+hU7HHbzeZ84VEaI/PY1rXrNkTDPF4Ef9ALql6ro2k/UoXy9NAfrjFVewJZf
         RUmb+DezEWc2V26J11Xc0cXJ6QN4VslLz7OwuxOURCZCkdUUyICy26DqfaY3cXO4CuRy
         MeuOZckpxXKjBZ6tGKlXuHTU0b5dutMkjN4ALSXzRauyHJ1SswOYxpP9884Ha6MfISew
         czETVhuGIFZSeXvgnU1ryug5Td0mcGuEwSwNxczYQ6J4jVIUhcgec7c+wdnbSYKxzWYp
         KC4g==
X-Forwarded-Encrypted: i=1; AJvYcCVE+szvHhyqTMYiFWsJX4Jg98OvuU+C3kCTEPyaHFjl9LjyZJHv6Ple9RYq+NVWOJEN9RWLK80HnDnG/zU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+ELSpCdul4DI8is/ot9VLDCMvSjRZq0F7/xyXa21vWi2Ufc0u
	cF5ecMGgdT/OoC0xlg3fFkp2rplgahziY36VqQg7/auvQr3JjE3jCvGAWUrrIJuJCP+E5o2s61h
	I+VDvODoRf/KqqdSGFqQDpBW85NZzerZt65n62ckvogrc7VjV9EzqfpmRjQrqklUbkVI=
X-Gm-Gg: ASbGncvYZ5jSEQ/K3gyvLUkZMQQAXs6CYfFXONbsBFmVqHogOEkaqGr+7VJzIaxhohL
	JaeTJljZjn9ISMaS2f6P9LhEY1ZVa9AwfWbyQkhn0SEoww7GuIyG4xNW7fW4HzrwZdVB7RgnG+K
	ossZicm6ej6/fRQLKCHCdOkQHTsF2J13Pd6QwOPxqL13KtTynYRi6Sg+GgxQtHAYrkBtXoVgrJM
	psHtBB+yUT6go0MXlFv7Pv0doDemLFO8ZYzb0+kep7NCuzUNuIbgjlsgNaaAeyRPYzAJ7uhtaWb
	iRLaYQwXP9xDI4+D8JzY8N80A7rNonagp7WX0/a6NSauXFJoiytnBRlXgkRpQeevCk9tF4pSpff
	7vsei5swK/jvg3qasUooRlLodbeRgrzyFcomYnAAK9Mb7wy/5Bmqm9oEfOH00g243okpryWeaY3
	9ltAom6xP6vsim1Orl5bOiQas=
X-Received: by 2002:a05:620a:5cc1:b0:8b2:f228:ed73 with SMTP id af79cd13be357-8b6a2348d63mr208849485a.7.1765021547762;
        Sat, 06 Dec 2025 03:45:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF7lhRj80fCQhRwzG8Sy9MVABWIaWuDqVkUzPeyO/wCFqFIdnng6bpykxGDH3HN12wdPzhmBQ==
X-Received: by 2002:a05:620a:5cc1:b0:8b2:f228:ed73 with SMTP id af79cd13be357-8b6a2348d63mr208847785a.7.1765021547290;
        Sat, 06 Dec 2025 03:45:47 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37e70660c43sm21834671fa.47.2025.12.06.03.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Dec 2025 03:45:46 -0800 (PST)
Date: Sat, 6 Dec 2025 13:45:44 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>, dmaengine@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH v9 11/11] crypto: qce - Switch to using BAM DMA for
 crypto I/O
Message-ID: <2rua7crcsdwikakbchbsmzbcwkofzwwbujskknub42hpkxjlsu@owqmdyl2gyuv>
References: <20251128-qcom-qce-cmd-descr-v9-0-9a5f72b89722@linaro.org>
 <20251128-qcom-qce-cmd-descr-v9-11-9a5f72b89722@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128-qcom-qce-cmd-descr-v9-11-9a5f72b89722@linaro.org>
X-Proofpoint-GUID: 0S6LTXhK0HwaLW3pSuYf6MKl5AgvSDss
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA2MDA5NSBTYWx0ZWRfXyo4wDneMOUcg
 DAxP7PtUXuYqtWAYK0fq+zvFKEs41eIuXbLNWZGyjrbprxtWbG98lKG4WTu+WKL7ktXyWh/mUJL
 a3BpZarTPSGodqOIYNoVjlUlw4YIKl45VuRzXqbz1xUaKuCP4Ixu4R6OwIQTJIDCl6V1Zg+mGz1
 wyf5U7oYgKBFhhz/r7Z8VDU0UJEImsTK7D0UGkOn+M1GN47ZKyRFsUIdofgMIxh/8Q1Y/F/iV9W
 6sGC36cuoIjU3BkDdpK/JFRpnYgB1FxitvLZQifj1aFefusqwD4v+px1BXyzyKNjubGjjiIiz7Q
 n6V+g074J3rSmZsvg9blEhbWbAEvOwkZbp//1PHttzizWK9KdRQi096CACRFeE3nwDmyQqCbort
 l2/Z/isxaNjdmd+JKLyYhmvemsq5nA==
X-Authority-Analysis: v=2.4 cv=RvbI7SmK c=1 sm=1 tr=0 ts=6934176d cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=RpWgtCqNgKFi5XhArUUA:9 a=CjuIK1q_8ugA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: 0S6LTXhK0HwaLW3pSuYf6MKl5AgvSDss
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 adultscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512060095

On Fri, Nov 28, 2025 at 12:44:09PM +0100, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> With everything else in place, we can now switch to actually using the
> BAM DMA for register I/O with DMA engine locking.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  drivers/crypto/qce/aead.c     | 10 ++++++++++
>  drivers/crypto/qce/common.c   | 21 ++++++++++-----------
>  drivers/crypto/qce/sha.c      |  8 ++++++++
>  drivers/crypto/qce/skcipher.c |  7 +++++++
>  4 files changed, 35 insertions(+), 11 deletions(-)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
