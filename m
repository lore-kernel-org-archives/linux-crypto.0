Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED752FD1CA
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774881602; cv=none; b=s4B9i+deNS5MHErDz8zs95Tgku871wVrWPj/PZmWe3Qx8VO6TUrVGXQNySdLbUJ6LwtR9MkUuNQbq1g+J7c2m3ik0ozqKbMBuClVHQmDDMUkMzRX7krgKAePgCDQN5YxCzQasyeEWtFFmbyvDlFwQOkqEFEqolGUx6DY+ijorBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774881602; c=relaxed/simple;
	bh=74ntAUr7NapuW8nQdYTPtYuOABRG0syCWtfXjwYJ4So=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E318T2bJrf0iZTxYujUd9bHYQas6EcF22sCNHmwNBpXI3CSajUknydf7V8KFUTK07laOh0CJqJkYxM9+T6LiAwT4M1FK3oURoUJJxDQF6H6k+bwSdI2ing1aKVnsjGQOjno7Mx715goW5kx5kWLfCNygynpbLXZlOfKHdutZxdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E/fjlZaX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bzsPU/Cn; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E/fjlZaX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bzsPU/Cn"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62U9nFjQ3722154
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:39:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6jNd6ZWcETXw9Y9u5C/2GloaCm+w+bAJXQCKktGWQ8s=; b=E/fjlZaXcxfiOVq/
	eeeB4AJzBXC3iF90UDASj8DxRWkSLnz87BrWA4Yj7eDWgc9T6GH0FpwZQPfLNhWf
	3RJCoUUVZZDFW9bpfT8x6ffAqjfEqE57FUzFx+SE7Q3LKuWLDZcjYlC+1YdZsquJ
	D3tIGBiJRxKNu3zV4HlrvsVEYzztt+C1p+gyxD0NFLAZyJz591b6/juTkml9qVFM
	buJCfm2sagR5Dq+UcokZTh2toTjv+VpFHoOXT6TnY4G2VvTWsuDzcYyIMDpTexg1
	KrS4KWrz8qM2RnXSGkYNaiSNPHXiLg61HJq8/rPai/2cdcriDD8riYE9RykH8YnC
	eF+2rw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d7pvms4dx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:39:59 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b0be75dfd4so60382445ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 07:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774881599; x=1775486399; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6jNd6ZWcETXw9Y9u5C/2GloaCm+w+bAJXQCKktGWQ8s=;
        b=bzsPU/CnzIihJN5fa7rlwMvMZL5XobDiUJ56+h+UpPDjCX7yiF2DN1QiDQpR6KU0xp
         V/k51lZ+YaDlW9td9dVkC5hsVlqgozIfIjAAbok12sOHMZ3c29SvJb/xcWgBNnSqaoBh
         fiHrOb8+zZTyXqL2Y45jQpdc81LLdWv/ene9x7FNTVZSayozdvlOLvXvkhGjGl1k6i0A
         8oPusggtrmErXpFcMBc9ValkSZUP3hmc3WwUTXQ0Sw7bYobTbtNEhQTTR9MgrFqn3f6w
         wYNFLejK4OCBBlqUO95jkD0n59pmnol6zRQsa5w3mT8xqKB7Iu5G1BWj7md+cjxr9B9P
         g/cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774881599; x=1775486399;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6jNd6ZWcETXw9Y9u5C/2GloaCm+w+bAJXQCKktGWQ8s=;
        b=AMA0Mnm/Grr8sKXebAcQNWDX/HwhsPVYPG+1j4twAsRCU8mCXd1nVvsFXHoSHIMT+U
         QXSRJg4wMELoPQi7IH97V5ppxVqfrGmmHn0sfIjUX0SgK2JrSGtNuVO94m0k8qnhWA4W
         HScDHSskmjIauvlPZ3+O/zqarO50AcKH0nxmIr1CNj/AfxIf6JMd+WJ9erJv4CllGc49
         FCVVHKbIQbz8OeY5ymtG9PIvW/YMbIoHHVdZ7xmtYht2TJcKULLYlYMmvTqXM8gtaM9n
         SE0ncqxeNxTZF7D8ZPboxBjW3XRIUyig9/e0AYB9yTw2glcTstAi6xCNrHFMykaTeOLP
         BNLA==
X-Forwarded-Encrypted: i=1; AJvYcCWM1ICfaxOg9O95y9S7XhkIMt1R6lBbpeyBjTtv/qdymWjRtnHj9yQ8zfTQfeCZu7qgWjsMAr/UI+3C3tI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt1+RADYsggowSLABwDVSxyEI+RQFTr/xlkuTAxISSYPcrwFBe
	1H6lgFf3L2z9zu+eiuAj4c3rYyjyAK36KEozoGvsL5BQ26JG5rX1OnPM1ufVym5AMvc1z8l6UKu
	WWsCDW0gVCIKJICxaPeGAFdwWJUrE/kKd+4VniFaM5l0ILbmYEUY/r0WplPyNCZP/sWs=
X-Gm-Gg: ATEYQzwF8QVQwWgW24m5ACAr5XY/osgHnLTaDmZLA12arSpQK6U/T9a1dOcDVLFJgS+
	RaQcLoS8JHkuVGcB5B/RH5SxhCAXDBrKz9TTsap8gmPUR3sfCOHXlUyY4q/LGoShJ1SZhYvD14X
	LJUXyjyD5eMNbS5ww5YUA1oeJsFgdWpQfp4HAvZgKXnPODC3So/E0FMenT9wXv3PmetmzFWCn5W
	N1kf0/Y5EPuttxNf8OSI3VLbHzdIUX+NXBhA7IL0S+hY+DCMwxjXMrOvw0vx8wZ2Z2gA91VKWFb
	TC233MzxrWdKdNIC+Bi/sI+jUP7t/qzK0e0uhCbucCP0iDPmu540OCVrAuUHMLVILm15hpF0+4/
	9bizSSo7kCtud71+yWJqXLiDs8S0sFYgWg1ToMslBywzXHGYfBCk=
X-Received: by 2002:a17:902:f542:b0:2aa:d5e5:b136 with SMTP id d9443c01a7336-2b0cdd7bb09mr134148905ad.38.1774881598577;
        Mon, 30 Mar 2026 07:39:58 -0700 (PDT)
X-Received: by 2002:a17:902:f542:b0:2aa:d5e5:b136 with SMTP id d9443c01a7336-2b0cdd7bb09mr134148525ad.38.1774881598074;
        Mon, 30 Mar 2026 07:39:58 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24264292asm86567855ad.4.2026.03.30.07.39.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 07:39:57 -0700 (PDT)
Message-ID: <7fbd9d3f-a313-40dd-9335-799aea5a077a@oss.qualcomm.com>
Date: Mon, 30 Mar 2026 20:09:51 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/3] ufs: host: Add ICE clock scaling during UFS clock
 changes
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
 <20260302-enable-ufs-ice-clock-scaling-v7-2-669b96ecadd8@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <20260302-enable-ufs-ice-clock-scaling-v7-2-669b96ecadd8@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: jI2TMDnPgqkKgoLzJLPmfDcEFSzh0N6h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMwMDExNCBTYWx0ZWRfX7JzvvQD8Ydm6
 Nv3CVukl7Qv8Hxxoe5uf5Png/LdvP1Ku3AeS+XHvsecYEc7rIotqN7/af++ZuTCdlcGNHWYLFve
 z0nj4vX5x+TY6fS3Nh84yoS3d+Op+l3x5TkXtrT1Nh7HPdU4g4STDp4KKgGfw5E3HnoOsTRgZhM
 N1YL3N+dj7bcHWrIm1or7UInwrupfztOrxcQMKQ4i7G8G+5799Q8HCUmGPhKdqJ++JHjnW2vrkV
 LGxcccoiUsE5URKwEzgg0tK3+EnTr+1PyE8hMJiEWWFdzl4kdemYFlM6QWEmPW1re60OYJ96J16
 sb2B630281CPHbSKIu1lZ+CsQPNzNS+WZRw3DJq6MXnmaHJHrlpLKWinfN+YNREv7mxJ6OqqWoh
 A5ufh7c1BTpPQQDS6MHeYh13lV3+rOCQNOlDbzeY7VfrVM/uT5IC1dxZUtQU7o6D6su9kbN475d
 1GyirQkHocGm/sxHUdg==
X-Proofpoint-ORIG-GUID: jI2TMDnPgqkKgoLzJLPmfDcEFSzh0N6h
X-Authority-Analysis: v=2.4 cv=S9rUAYsP c=1 sm=1 tr=0 ts=69ca8b3f cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=vKCOo-aWrrhi_IfDXuIA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-29_05,2026-03-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603300114

Hi Abhinaba,

On 3/2/2026 4:19 PM, Abhinaba Rakshit wrote:
> Implement ICE (Inline Crypto Engine) clock scaling in sync with
> UFS controller clock scaling. This ensures that the ICE operates at
> an appropriate frequency when the UFS clocks are scaled up or down,
> improving performance and maintaining stability for crypto operations.
> 
> For scale_up operation ensure to pass ~round_ceil (round_floor)
> and vice-versa for scale_down operations.
> 
> Incase of OPP scaling is not supported by ICE, ensure to not prevent
> devfreq for UFS, as ICE OPP-table is optional.
> 
> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 8d119b3223cbdaa3297d2beabced0962a1a847d5..776444f46fe5f00f947e4b0b4dfe6d64e2ad2150 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -305,6 +305,15 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
>  	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
>  }
>  
> +static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
> +				  bool round_ceil)
> +{
> +	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
> +		return qcom_ice_scale_clk(host->ice, target_freq, round_ceil);
> +
> +	return 0;
> +}
> +
>  static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
>  	.keyslot_program	= ufs_qcom_ice_keyslot_program,
>  	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
> @@ -339,6 +348,12 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
>  {
>  }
>  
> +static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
> +				  bool round_ceil)
> +{
> +	return 0;
> +}
> +
>  #endif
>  
>  static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
> @@ -1646,8 +1661,10 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
>  		else
>  			err = ufs_qcom_clk_scale_down_post_change(hba, target_freq);
>  
> +		if (!err)
> +			err = ufs_qcom_ice_scale_clk(host, target_freq, !scale_up);
>  
> -		if (err) {
> +		if (err && err != -EOPNOTSUPP) {

Using -EOPNOTSUPP here works fine for now. But anyone touching any of the lower APIs called by
ufs_qcom_clk_scale_up/down_post_change() needs to ensure they don't return -EOPNOTSUPP, otherwise
hibernate exit will be skipped. So this carries a minor risk of breaking.

Since regardless of whether ufs_qcom_clk_scale_up/down_post_change() fails or ufs_qcom_ice_scale_clk()
fails, we exit from hibernate and return from this function, I suggest you handle the error for ice_scale
separately.

>  			ufshcd_uic_hibern8_exit(hba);
>  			return err;
>  		}
> 

Add the call to ufs_qcom_ice_scale_clk() along with error handle here, and let the above error handle
remain untouched.

		err = ufs_qcom_ice_scale_clk(host, target_freq, !scale_up);
		if (err && err != -EOPNOTSUPP) {
			ufshcd_uic_hibern8_exit(hba);
  			return err;
  		}

Regards,
Harshal
