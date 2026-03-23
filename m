Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FCB3AF64B
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774285965; cv=none; b=EXsDWPq8WPevA+kQvLgPVa9MUd1KeJHN4SMWNUC/62UyuARDD8NwTJfhjfK2aPb1cIbHkJIf41+qWC9baPpZaocthiFvAqgBMhvfhnZPz7Qm64KwbjFVJFtjSZfrTshvkeQ0+XXkzuO2tauVCmX8Ef6MyE9gDYKNZZYQGncWHsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774285965; c=relaxed/simple;
	bh=VIH5oseomoaz2aNTCXssIM5XnulyweBpmgXeIPoAh6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDodB1GO+LGL4fe9jGuiiZumj5Vhzev/c6l3UjC892R3azzaFSXowxL1bGzRcyjBRCAOS2lXCtSm3xY8ZFF9y4AyBumqJ9NNm67fjMS5SmH+LggSAk/4EgZ7If7SuudywKsz13xnBWsybypAMXzXasJTFNOJf+JOfwGo5U+7Xv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=a/tYsbjr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MKMB4OVS; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="a/tYsbjr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MKMB4OVS"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62NFGRdu2336657
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 17:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	D3ROQRlFPBoLrDcR2n19Hmz53ktfTwjjW0C8cQSfgLo=; b=a/tYsbjrm7lFDkNj
	/fPpmhymZ4JWDkFqdE0Sl47BjKgdYqllgV1l1y0uM7msbJ0SzBhjj0ffeccpf7J0
	PqjDLAkiLs7jwO0534ZLrWWwuuEthvdhLmu9BsdPuEz9y31OrO3coGaeu+/hqMg+
	xbCuJTnLG0PBkh/7lPvJ+gh0LnFT2ylS7w5B1RSxI2SUHNNRH8ile402ItcdA/UR
	QPMKBcA8+ct0ngO3b19DNdfL9MH81Ejv8r87ArGPWD7XDJL+2KNRW9OcVyRAXaQd
	Bdk4dEzy2GXnvc8dltBZRtPba+Mr9tmyfr7xybZ+Ze3bcL2ZwxP/as5mKnlc8P5S
	1mhH6Q==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d31p79y70-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 17:12:43 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3568090851aso8145454a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 10:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774285963; x=1774890763; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=D3ROQRlFPBoLrDcR2n19Hmz53ktfTwjjW0C8cQSfgLo=;
        b=MKMB4OVSV+4ZnUR1plNz+r407xIKqGfSvajgmxXncU0iXltzLLGu4Xxgh4BkeT4i85
         R/TtfD80wQIiClsvGukcOwWXP3g8iteQ9ociGiXVvOtqpXEj2iNg4gYDkfd0Skza8pS7
         YmtbB6n7Emr8dE3pCWKHFE0vVtWMo0A4m6bK39frqoHcah7UbM8o7VD2dfzBphYuIbQP
         VB+1Vkt2SAD4skZr+VDmYn4gvk/4KFdG/8dZcIMUPd4MdnVifOCasUCMvQ3YdYSQKShO
         LSy58Bgho6rcM03fM/rbT6nGwfeuXqRnulcaj4DaIk0HEBMhnl+wtHrN7y5+udh4nocO
         nYsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774285963; x=1774890763;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D3ROQRlFPBoLrDcR2n19Hmz53ktfTwjjW0C8cQSfgLo=;
        b=ajg6XLFnXMRHh4irCqOkPIqEZZqTwXZQOmCi9N1d8lCpZkqD5fUsSaSQuhODYSkIWs
         C1BgOAGxCbQOuMYpYjKVMmEgGYIOXufJJtFQovQMgMTb70ZAcjNGPc1EP9ViLD/WA2Ya
         GCVRDfHY/j9sF1mCWE0tK191HnfFyx4D95SUw6XJQSyirYQNFiM0l8VhV77Bu1QDTVXm
         0gCIQOR6/wbXwF0JqDZCTNARxxoNYOVOeZOl/Z37qX4LT3jRQ3OXLJOVm57rvFhQ4ITa
         YPK6FAkX6gZIP7XyMmmOSZdTMPxnjBFfXbASU7jd6kbkAfkP66ScBVzFgKV1iVkKhvxf
         8hXw==
X-Forwarded-Encrypted: i=1; AJvYcCVFfzFVQ4zFDhmRQt32EkqZAKSLmEpVZfdDb7zVpa5Lc3nsQVdXXOlzEhDgcXSYl5eaZjnOOanvGKv933c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAgfRIpB4Tc2unjQDOxWreKcDDUy4HVTIfJxuR5CmTrNr/6csZ
	BICui9vl96ui3nS8WbLlW2+R0fUnjwIzCf1EaXhBz7XGo/ohUP3DO7EO63OllAdJGKBynLGy2M9
	kSl/ajuQN/p+ZJNCLn+Oa5rcaaTPWmbJTRx+OxhhcxLnVyjrw90sGd1DMFG9UBKqwLH0=
X-Gm-Gg: ATEYQzymQV+ZRLN5wbh49NBf6tLFs7iK0gwVD/mRSJVyP7ufycP65ySE94Q/XbJG6IT
	79vet0JkENMCEKhKRlBXJmg7l3Jm3ko8E0Iea7XlYR8pByQ+JE1AuL2Q/ga4g9NErpIe4wAUums
	foCKUL0GGkBnYEh/d6X31eSaNYGVMaIw1RlATWV/pEIe8Bwr1skUpgZMGK8uP5nKOLodf7cZGji
	5PwPZLP3iVUZdEHk2Xk57+UMvJYpYWczWi+qC0qFdz/jpr6y+82s5hGuOcxklUoUjNc7rm+s0WZ
	bF+NntxOnQmH1U6RzVWhyf9PbVuwbWZc6OmFR/lxXWvMYzT4vbTFI5GsgnEdc/ChpfZz0A2zfeg
	uFXZcerGgsRJy+Gfsm7V7bYU/btm4XgHWy9N7u873M4eAVRd5i1kN04rWDmY=
X-Received: by 2002:a17:90b:1a91:b0:35b:929f:7e95 with SMTP id 98e67ed59e1d1-35bd2c20675mr10918229a91.4.1774285962481;
        Mon, 23 Mar 2026 10:12:42 -0700 (PDT)
X-Received: by 2002:a17:90b:1a91:b0:35b:929f:7e95 with SMTP id 98e67ed59e1d1-35bd2c20675mr10918187a91.4.1774285961848;
        Mon, 23 Mar 2026 10:12:41 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd3d8c462sm10077241a91.0.2026.03.23.10.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 10:12:41 -0700 (PDT)
Date: Mon, 23 Mar 2026 22:42:34 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v7 3/3] soc: qcom: ice: Set ICE clk to TURBO on probe
Message-ID: <acF0ggIIJFb7mUUR@hu-arakshit-hyd.qualcomm.com>
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
 <20260302-enable-ufs-ice-clock-scaling-v7-3-669b96ecadd8@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260302-enable-ufs-ice-clock-scaling-v7-3-669b96ecadd8@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=RMC+3oi+ c=1 sm=1 tr=0 ts=69c1748b cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=i-sMpDq2_rzAXM5hadQA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: 2kRT2M2y2ZmhpgZwwEK0IKuHtgKEyBqT
X-Proofpoint-GUID: 2kRT2M2y2ZmhpgZwwEK0IKuHtgKEyBqT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDEyNyBTYWx0ZWRfX7g3luHh4S7U3
 gciuwmElloqlN5we9di+RuXKMPLISTUVdPSl3UYF+JyvmJZ/c1MT8QSKQHnuMU0xu9d7tCJgc9X
 FWicSSDdP8IwRP6MXVxJXRdxsYg4H4HJTGTQ5uBNhqrDP0ZixwJ0EeHklQWaa5kKhAX+dGkAdni
 vNI6qTMjYfY3/vlD7OCebJAYz2lVMkFye79x+nkxv3h8XmNQhRyw7Oex1nycBOPdnrfB73P3QwX
 dRRC0bxjFDoTI3wnNqp/B0sp87ZOANanijc7VhBQrTZKMKwFarUiZK/D6M6UeX9j1Wv9klwguhB
 2yLyp4IBlUsoQK/EIBK46JfASUBkgSdU9tzRF7rFIr+dc1VAOwgHnLbWQ3kZDGcxSFhKAMs1Nlj
 00NMvr4Iyq/eYFfjpV+Y/xQ5N3S+zNl/b+xKynDeAXO6B/iBGPBZvm8De82HbfF3+grYVM7hbbd
 vBBpCO0hViGV23wRGCQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_04,2026-03-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230127

On Mon, Mar 02, 2026 at 04:19:15PM +0530, Abhinaba Rakshit wrote:
> MMC controller lacks a clock scaling mechanism, unlike the UFS
> controller. By default, the MMC controller is set to TURBO mode
> during probe, but the ICE clock remains at XO frequency,
> leading to read/write performance degradation on eMMC.
> 
> To address this, set the ICE clock to TURBO during probe to
> align it with the controller clock. This ensures consistent
> performance and avoids mismatches between the controller
> and ICE clock frequencies.
> 
> For platforms where ICE is represented as a separate device,
> use the OPP framework to vote for TURBO mode, maintaining
> proper voltage and power domain constraints.
> 
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  drivers/soc/qcom/ice.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index 7976a18d9a4cda1ad6b62b66ce011e244d0f6856..e8ee02a709574afa4ebb8e4395a8d899bf1d4976 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -659,6 +659,13 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>  			dev_info(dev, "ICE OPP table is not registered, please update your DT\n");
>  	}
>  
> +	if (engine->has_opp) {
> +		/* Vote for maximum clock rate for maximum performance */
> +		err = dev_pm_opp_set_rate(dev, INT_MAX);
> +		if (err)
> +			dev_warn(dev, "Failed boosting the ICE clk to TURBO\n");
> +	}
> +
>  	engine->core_clk_freq = clk_get_rate(engine->core_clk);
>  	if (!qcom_ice_check_supported(engine))
>  		return ERR_PTR(-EOPNOTSUPP);

Hi Konrad

Since you previously reviewed this change, I wanted to share an improved approach
that I recently realized for handling ICE clock scaling in the MMC use‑case.

So far, we have been voting for the maximum frequency during the ICE device probe
to align with MMC requirements.
But because the ICE probe is common across different storage clients, applying
the MAX vote at probe time may unintentionally impact other storage paths.

Now that we have a generic scaling API exposed, we can make this logic
MMC‑specific instead. In particular, within sdhci_msm_ice_init().
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/drivers/mmc/host/sdhci-msm.c#n1966,
we can invoke: qcom_ice_scale_clk(ice, INT_MAX, false);

This ensures the MAX clock vote is applied only in the MMC context,
without altering behavior for other storage clients relying on the ICE driver.

I believe this results in a cleaner and correctly scoped design.
Let me know your thoughts.

Abhinaba Rakshit
