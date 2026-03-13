Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513C723BD05
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 12:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773404519; cv=none; b=h3ZjlaIbQ6aMt2NfQnTRwoemG3w/k5NDHKIcT/gyrD70m+X/dblFXVlDilGDGFkqcC0gC3bzRHMu0T9xLDH6gIupEG09567WAZxfDWSOo9xKPxZTbjONw872eJEKjWyC7OqsYQ2C8acm/nj6zzQAkntU5o+KDnzjyNKIpAzyGBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773404519; c=relaxed/simple;
	bh=AJGpXmDrUPBdtvW9aSuAbhP6GwiLGVccEpCoB2Y4N/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XoZ47f2jBihmgADQn/cgyz4hSirdBacPaSlk3rsNow3P4j0MOtmQj2ArlNRE5OYU+Gqo2Kw/8KCbo5Yd31ZbcR6gMjVjHie1EWQhJk1HgoF10E1v8uTTPKXWtrT+OqvI7LSKNP4WZF4PbgUBo8SLpl/qMKUMyv62mYhG19GuOc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=orqwxLlr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XgTTd/5S; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="orqwxLlr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XgTTd/5S"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62D7JmRR241596
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 12:21:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ncKVZp6XtiWfN25Y+BVjRXsXzdPkB+4zTH8BJYoYgGQ=; b=orqwxLlrS/9Ywxqj
	Bvz92jzH+oYMtGt20OCM3gr3SDKkoVANZRarBlonAz05FhS2a7MJncV6x5Hxe4ks
	C6lKsi2wIg1BJLZ90pFDJx1YSXkPECOAkRptqdNcZzdE+3KjVWbyLoPeN5PDR4J/
	TbLSH8LXLDbqsJIdjJNW68MLNLbe/6y+7Qnfzpxr6NV06To2J1Cvw1VVXxMx61Mx
	fFUq/WoaoOUGzcuac8Ce+NV3m//8i3NQ3QraRjG03nrwetVQC9B0cCjQFbERToK2
	T8+GetsECcFtIOqW6YdqJksmJyVkchsw5g97epYEBhi0YeCU768D9OrGq2Crd650
	ujnVRw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cve3d929y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 12:21:57 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ae57228f64so21581555ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 05:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773404516; x=1774009316; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ncKVZp6XtiWfN25Y+BVjRXsXzdPkB+4zTH8BJYoYgGQ=;
        b=XgTTd/5StA46X8FfLJzZShfVIJ5PS7327rChveMxhOG8rq8+z49wBrSpbybNG9MWXl
         NsWSCOsapm7YkI93aKeN0Ft+ZZ+2HLdDf/fonKIYp3H0M0IH/i46/ZADa4zON/Acrf51
         wOOfz8QHVmQgwLPM7pcdZ+6sm90rLpMVgRwWluoKrYBw2IMe1sTh2hB8oCGRQtbzwQTi
         KsZ3vP4fbM9YhRY88wQWQfQrlZUvoD6YhcyaB09jLtAR+G6vTBNBYg15AED//IZC9C2g
         GnIDR8FNyUhcDX5olcwVq7eUODEBPNWc9Ohv9vBnzvg7HOa5U5AgkqJBc3hnRp6NJrv6
         qYFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773404516; x=1774009316;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ncKVZp6XtiWfN25Y+BVjRXsXzdPkB+4zTH8BJYoYgGQ=;
        b=IaGxthwEeU2wdCHtBtIoL5fgssKBSdckT7E6cx7GGoNXUCsYNm4w47bkz3Cb0pUXbk
         2XBHc2OtVIvT5fNh+icTkQXUf/TdJ00/t6pRoAd7sbvgqfOx6ASMr5PKVzqfuB9hgQ1I
         Z3To65vu9+HjF/6GDULIjMFiU2ZgB3miKsTAIt9w9YFJrQJFLUWBFe9KT+HN76Lz/LmC
         x7sinAdpsivRGZG+3KXi4Foe4PLL4thXyyC8TtLG+fj+IvaNsQhWyV2tDnamyJQWB2vR
         +SVdkEtUJ4kTBmE+BYjYiKwLydZezWWn+rKXjJMEsl8LgeUmgJEPXA1712rfw9exGf7N
         +nJQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4ZyLMwYl39tbDB1naZJ+DOXQ0w0UyzQXN7x1EiI0JKGa9k5qjabwiZX16Naq/ml9g2APhbcr1wvWOf7c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTlTRsq97Af8HsfsqZTIjBf6s7vZl5GZ0FcNpI16ZaBs6egbaf
	juI7pwHeBjinP45cClw3kl0Wia6ejpuR89GMboQYUXrqDrbN+Tsr4hKSHzwG70+HoXRXT81tPxR
	xklWjvXWXbSJ4MHPiYv4yxJstHK3P3ahA6lfaY8EYxiveVTYYNKyxnX2M69sObM3gpUw=
X-Gm-Gg: ATEYQzwKR3hc0hKBbN6zXuj/By1YaKuMSQIAWG1ErLv+n/BbwaCG3v8898q3ny+Y6JY
	MD2FuquLwSGGeOW3rOM6DcLxAfw0PcVHpC95Tf+BSRPtjE/CwTDHYnPVMQKL5HMcuFdviCGa/Zw
	4kwtcqEyrgrau2IN62IVdIfoqsGROdnAcnxvDvMKSImDFXtfQrOaNmZU/giHIRMc6B73vitp7RV
	OXh0rXN+eG3oD2WrZnBW5VDW/HWHz7nY1tVd7IUQ6uqmmd7F7mayoif3HVBmOTA/3SEGq9BZUds
	V02VVmsOZ7D4kxfdn8FY6ZJ9moM4tT5a/SFwrL7TQpjmDWpKzwv5Z21g854F50KbJv3xtCHobqs
	mF/Xw9HvRLCT0YtO7EDnJgbC/OGdIUslaODF0EBzYq5V/Ht7NrrLOu78qivs=
X-Received: by 2002:a17:903:1503:b0:2af:c7c:afbc with SMTP id d9443c01a7336-2af0c7cb19amr7817105ad.31.1773404516357;
        Fri, 13 Mar 2026 05:21:56 -0700 (PDT)
X-Received: by 2002:a17:903:1503:b0:2af:c7c:afbc with SMTP id d9443c01a7336-2af0c7cb19amr7816555ad.31.1773404515583;
        Fri, 13 Mar 2026 05:21:55 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7ed9cdsm22318995ad.60.2026.03.13.05.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 05:21:55 -0700 (PDT)
Date: Fri, 13 Mar 2026 17:51:48 +0530
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
Subject: Re: [PATCH v7 0/3] Enable ICE clock scaling
Message-ID: <abQBXBNcrwgBpQYH@hu-arakshit-hyd.qualcomm.com>
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: hmlttcZUwGRFGZQSVjcVmsnQek-VRaND
X-Authority-Analysis: v=2.4 cv=FLwWBuos c=1 sm=1 tr=0 ts=69b40165 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=FNyBlpCuAAAA:8 a=EUspDBNiAAAA:8 a=nmp4smzA0mTOGrukFIAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDA5NyBTYWx0ZWRfX944DKxZ6sv4I
 IvKyx9SnUjzSiEqTp9YefbNpDO7btJT4p3Uy8OyXILz3hr61WAFJZ9kZGxqkx3GePIPEAtLtnBe
 s/d4QyJOYkzlr/9bxx732c+PrucsQt6wzdH/XtO31lPMRF31+ZkyVWGdp5rotE02oy+ZxZukrS9
 cheD883K7CFboxidV0liulck500IsykpPFeEGCfV1VI+EFonFHwr0N3IQhtW2RTepux4OTmYWQ7
 p3zmF7LrIy0D2NMbeUISS1hfp8X44Hc1rLvGPyATcTT8nwUKgtY+VikraC3FINJThik8GNRW5F/
 U+cRp3QhvrKQoVOxHTucPyyO6UHbR3hcU6OLpuDt1iGwtzxEoWLZqrgQTza0iK8hQOhZHNfOaxL
 qp1KzmRrhtMLpLwME8tzz9uwecjHgOVvjWLW8eCMo9wQAX7IE7ScVgD46aMEgguXYJW5/0ee898
 IR1L3bBRlQsujAm5WiQ==
X-Proofpoint-GUID: hmlttcZUwGRFGZQSVjcVmsnQek-VRaND
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 bulkscore=0 malwarescore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603130097

On Mon, Mar 02, 2026 at 04:19:12PM +0530, Abhinaba Rakshit wrote:
> Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
> using the OPP framework. During ICE device probe, the driver now attempts to
> parse an optional OPP table from the ICE-specific device tree node for
> DVFS-aware operations. API qcom_ice_scale_clk is exposed by ICE driver
> and is invoked by UFS host controller driver in response to clock scaling
> requests, ensuring coordination between ICE and host controller.
> 
> For MMC controllers that do not support clock scaling, the ICE clock frequency
> is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
> consistent operation.
> 
> Dynamic clock scaling based on OPP tables enables better power-performance
> trade-offs. By adjusting ICE clock frequencies according to workload and power
> constraints, the system can achieve higher throughput when needed and
> reduce power consumption during idle or low-load conditions.
> 
> The OPP table remains optional, absence of the table will not cause
> probe failure. However, in the absence of an OPP table, ICE clocks will
> remain at their default rates, which may limit performance under
> high-load scenarios or prevent performance optimizations during idle periods.
> 
> Merge Order and Dependencies
> ============================
> 
> Patch 1/4 (dt-bindings) from the previous series
> (https://lore.kernel.org/all/aaKt9PET6lVkBcif@gondor.apana.org.au/) has already
> been applied. This v7 series therefore includes only the ICE driver and
> UFS driver changes (previously patches 2–4).
> 
> Patch 1 is the change which should be merged first.
> 
> Patch 2 is dependent on patch 1 for the qcom_ice_scale_clk API to be available.
> Patch 3 is dependent on patch 1 for opp-table parsing to be enabled in the
> ICE driver.
> 
> Patch 2 and patch 3 are *not* dependent on each other. Once patch 1 is
> merged, patch (2,3) can be applied independently by their respective
> maintainers.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
> Changes in v7:
> - Replace the custom rounding flags with 'bool round_ceil' as suggested.
> - Update the dev_info log-line.
> - Dropped dt-bindings patch (already applied by in previous patchseries).
> - Add merge order and dependencies as suggested.
> - Link to v6: https://lore.kernel.org/r/20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com
> 
> Changes in v6:
> - Remove scale_up parameter from qcom_ice_scale_clk API.
> - Remove having max_freq and min_freq as the checks for overclocking and underclocking is no-longer needed.
> - UFS driver passes rounding flags depending on scale_up value.
> - Ensure UFS driver does not fail devfreq requests if ICE OPP is not supported.
> - Link to v5: https://lore.kernel.org/r/3ecb8d08-64cb-4fe1-bebd-1532dc5a86af@oss.qualcomm.com
> 
> Changes in v5:
> - Update operating-points-v2 property in dtbindings as suggested.
> - Fix comment styles.
> - Add argument in qcom_ice_create to distinguish between legacy bindings and newer bindings.
> - Ensure to drop votes in suspend and enable the last vote in resume.
> - Link to v4: https://lore.kernel.org/r/20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com
> 
> Changes in v4:
> - Enable multiple frequency scaling based OPP-entries as suggested in v3 patchset.
> - Include bindings change: https://lore.kernel.org/all/20260123-add-operating-points-v2-property-for-qcom-ice-bindings-v1-1-2155f7aacc28@oss.qualcomm.com/.
> - Link to v3: https://lore.kernel.org/r/20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com
> 
> Changes in v3:
> - Avoid clock scaling in case of legacy bindings as suggested.
> - Use of_device_is_compatible to distinguish between legacy and non-legacy bindings.
> - Link to v2: https://lore.kernel.org/r/20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com
> 
> Changes in v2:
> - Use OPP-table instead of freq-table-hz for clock scaling.
> - Enable clock scaling for legacy targets as well, by fetching frequencies from storage opp-table.
> - Introduce has_opp variable in qcom_ice structure to keep track, if ICE instance has dedicated OPP-table registered.
> - Combined the changes for patch-series <20251001-set-ice-clock-to-turbo-v1-1-7b802cf61dda@oss.qualcomm.com> as suggested.
> - Link to v1: https://lore.kernel.org/r/20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com
> 
> ---
> Abhinaba Rakshit (3):
>       soc: qcom: ice: Add OPP-based clock scaling support for ICE
>       ufs: host: Add ICE clock scaling during UFS clock changes
>       soc: qcom: ice: Set ICE clk to TURBO on probe
> 
>  drivers/soc/qcom/ice.c      | 89 +++++++++++++++++++++++++++++++++++++++++++--
>  drivers/ufs/host/ufs-qcom.c | 19 +++++++++-
>  include/soc/qcom/ice.h      |  2 +
>  3 files changed, 106 insertions(+), 4 deletions(-)
> ---
> base-commit: fe4d0dea039f2befb93f27569593ec209843b0f5
> change-id: 20251120-enable-ufs-ice-clock-scaling-b063caf3e6f9
> 
> Best regards,
> -- 
> Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

Just a gentle reminder regarding this patch series.  
Whenever any maintainers got a chance, I’d appreciate a review.
Please let me know, anything pending from myside.

Abhinaba Rakshit
