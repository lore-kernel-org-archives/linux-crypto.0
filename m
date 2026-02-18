Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540B530497C
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 11:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771413176; cv=none; b=iy2HO0Y8Y+res27aXXXVyjgDTp32IPgOdEYUvTFYLeaOuECreJKmMGjJybTbEWVomDqpdjwkDNcPh8mxypX2TuRiSYWes7+CpDweDm2lyjelQooviKXFYN3HQfNZR5/ZDwWiHcxmhkUlzQhW6sj2/JWvfXM0Z+G8oDSLS+dNIjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771413176; c=relaxed/simple;
	bh=4YT5brYB0UAoqFBI858XsuI2Vt7FEqOK1Z3AeX/HKPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lhI/193nNF4yMCljnNJbaIdT+aZ+3ZBFsBVdOP/A2Yv9q87OLDb9NlEvOZkgP7ipt2pCALkPYJrr1DCscBqkCHL2sO53EjQ+PHOPPO9EN7UyRP0Drf0dDiQQY0VdacZokZOAORmCJWf6vyxQGso2SaXEC0iDSf5XPa+4jKN1c64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QsTn2jWw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QWwKyspc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QsTn2jWw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QWwKyspc"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61IA8036421734
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 11:12:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/+3N+xY8cLZlUDcYTClcCN8YabWFK8vIUfB/T72lyAg=; b=QsTn2jWwMsn8ZyTF
	ljiDjuAMO9FNP0d50XQlr9r1OQSTyYBQeUs3e9CpAOiu6bFwHr6IfytbzZvpvHzy
	M1L0YRbZCSKZt7gk1HI0KPVbJaCpBjaeopJyVc8EZ8SoyUqeUSwTH40qahFbCkcj
	pnwX80Aq21qBxZNaanHIdrNC2AMJMdgqgsNfgZpnnVx1+MLzAacm35KlEfhY+Hqg
	BCZLChRJ9nYSC0sOvC24kcpO9vqwPNYob5IjWZsDmqU9qYwf8Mau1NLU4drARnCk
	5FsIaEofKANu1c2B1V7X9JFH66mq/Y7M/YpKQM4N/JnNVrTEG2LUMN0F/4IIM76y
	bHIVlw==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cd0k5hrat-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 11:12:54 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8960257db65so39683946d6.3
        for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 03:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771413174; x=1772017974; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/+3N+xY8cLZlUDcYTClcCN8YabWFK8vIUfB/T72lyAg=;
        b=QWwKyspclRhUVaHQsPlpNrwKmVUxdmhAdwt8QnyOhYDwMgk+DlsSIR8ClgvOA+Iod6
         /5T80CqbPGJHhfbV3rb9fQ3IGddZbIPh+8BSJdwr7z1unTXXoK9pEgo5j64crX5ZEuAD
         JrzuIZi7bAz34XL+ZNppu1VegGvXa8jPzuifhfotSbYvSYQgKLu53UQXI2aSKYXRgEtL
         sn9Uhiu/C+KvhLmgSfjAOpfgtP6eZyCY3Q5SLAotEWoaNBlz30TIiYzRmGyzMNFj80yK
         M3BhKyzJIivbrCmk4OtKyxt7A6cUCwl+3Xmwh5zHK+3MIa4a//IHs8R8sFY7TBxaIxt1
         Q7JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771413174; x=1772017974;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/+3N+xY8cLZlUDcYTClcCN8YabWFK8vIUfB/T72lyAg=;
        b=gCqQFauBnSaBsmGLiQWdhlsSIaOLUA8CtXq+xXAA2rziYJvEz92gpXt5tZXInWTAfz
         tfa9cO+V1jIy+jFWWEq22NfQLiyDmSo8Dou3aYPDjsGPKaZXzmDFT+KiPtRqPwQ0YeSl
         BV87HCCwD1eMpfQajRlz1x7uuOgfDfARs1x16t2rA7oabu5qGFbM/yk240bQ+rv4VlR5
         6L8in6RCe4dJbo+NM9bGpywVT+YrusP58AKg02s8q53eyk+C6ZsppVtiylsW5stRfR08
         HoCm3qf1eBKnC6+mOJng570yko5VSq8VUBuIeEGiDcJZYAoVVkUARDUmlFBFTybH4R6a
         BklA==
X-Gm-Message-State: AOJu0YzLYW9sFMp/9L1ysolIsQ44gE28W/pKfwVprGG4uvFEALBu2wYH
	6x+XARjwqndVnaN08vet9sIHPA5MefyQyrqzUksazc+NCJo57Um6Nq2Rmwt6grO3Ev4laqEyKUH
	MjW8qLdFviA7ncIFxjt9I75f3QvlJp2ZE3uFCo9jECKVpNSnIPpgKTnEFtGUOV9xgOoo=
X-Gm-Gg: AZuq6aL0yO9YYPVQz/sSox1izDO7xSnYD2DzLmyoB/vuUDG0YnBSKOa1wsz3aJU6zAp
	2lbgzN2jlRrQkkY9GTIQFOvdDXA3vEL52pWV+fbk3Occ03XYFNGSdyaeRS/SM7l7YjddUW3yjTb
	5cAyCSa4c8zzAzRtVtnWO4piHE0a+OiIi5XaxHAdK/SZxkHNgKOc5+R8C6UVJmB7wBdc+V17Yjf
	77QRjKj2frJYc+RpsDrmLRUOduv82oa+PqPlHDwcOBh73Eurt68Lt71ac15oB6XtAt2GhgYyO7H
	b3UbPLch3/ifDgKHuisfRBEzdHeXxANKsgrfhpK+sMyUO5WSYZPNwY1fbmqjFe5Bww0TI2R4CyL
	W+osLDipbrCrhfWVe9qCUwOiOLj4Kbj+BQJEQI7s8HVRfmJFI2Z2aCUia8VR/oVU0S0GGCNFA/s
	v+lLg=
X-Received: by 2002:a05:6214:4c42:b0:894:9f0a:7a69 with SMTP id 6a1803df08f44-89734706f3fmr182245096d6.2.1771413173565;
        Wed, 18 Feb 2026 03:12:53 -0800 (PST)
X-Received: by 2002:a05:6214:4c42:b0:894:9f0a:7a69 with SMTP id 6a1803df08f44-89734706f3fmr182244906d6.2.1771413173135;
        Wed, 18 Feb 2026 03:12:53 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65bace3fc4esm3120910a12.0.2026.02.18.03.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 03:12:52 -0800 (PST)
Message-ID: <d1adf3a9-3786-4fea-933f-e3df125a408b@oss.qualcomm.com>
Date: Wed, 18 Feb 2026 12:12:50 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] crypto: qce - Add runtime PM and interconnect
 bandwidth scaling support
To: Udit Tiwari <quic_utiwari@quicinc.com>, herbert@gondor.apana.org.au,
        thara.gopinath@gmail.com, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_neersoni@quicinc.com,
        quic_kuldsing@quicinc.com
References: <20260210061437.2293654-1-quic_utiwari@quicinc.com>
 <e5fe09e4-758e-43ed-a134-55bcf3a198b7@oss.qualcomm.com>
 <f4e1b449-9fb8-400c-ace9-bfb6b967bb13@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <f4e1b449-9fb8-400c-ace9-bfb6b967bb13@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=JqX8bc4C c=1 sm=1 tr=0 ts=69959eb6 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=YzaIS8OsZxMseUwa3qEA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-GUID: MXA3seRkZ_S9FrS2eX4EHYQbSw-rO8nJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDA5OSBTYWx0ZWRfX0z/rJjtMQpSQ
 vnN7NCqFAcUYIMScRYWrSsBaqE8K201AicvW+dwPPSjUraK6706sEQTpasz4br5YNQF6mv1Ijqe
 bSW8CRN6cdIp0suK6uojWvkpANBMW1IESB80x7lE+uFa84B+eMhgrzvl3tAvqpRoIhf48fCjsiO
 FhcUMmc99MrKjYCMGh6V3LNrgv5ZrIa1Di+uDYPvOhHSmr5seKNgEWjpXNlFf/uuB03NsY+QFpl
 n1NmkLyF4+X3vMh43ed+tsCG1e1NHiCjvOiyekBv5Ks54TeU8JoOvpVR9M2zKSENQJSZShWbscw
 pXKAhRXYUdrL8T1fGxZ8cmRUf8GKh9uxeBA5aSaQzo3qtRZsWXDeGHELQFXFyvjNVGtoX92dIlY
 J2ibXeuPAGMr7m/V/A5IINeTIzRbgALIUm2r53/R5sjGlpRG5Pq+rTxTBM/cbBVqr3wZo2sP/JS
 +A9EBeLbJdKf9+Xi0Tw==
X-Proofpoint-ORIG-GUID: MXA3seRkZ_S9FrS2eX4EHYQbSw-rO8nJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-18_01,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 phishscore=0 adultscore=0 clxscore=1015
 bulkscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602180099

On 2/18/26 7:02 AM, Udit Tiwari wrote:
> Hi Konrad,
> 
> Thanks for pointing this out.
> 
> I agree with your points regarding the usage of the ACQUIRE guard in probe to simplify the error paths, as well as the redundancy of icc_enable in the resume path. I will address both in the next version.
> 
> While preparing the fix, I performed a self-review and noticed a potential issue. Since I am providing my own custom functions for runtime suspend/resume (to handle the ICC path), the standard clock helpers are no longer called automatically by the PM framework.
> 
> I believe I need to manually call pm_clk_resume(dev) and pm_clk_suspend(dev) inside my custom functions to ensure the clocks are actually gated and ungated.
> 
> Does this look correct to you? If you agree, I will include this fix in v7.

I tried to find an answer, but it seems like one of these situations where
it's easier to add some debug prints than to analyze the code ;)

Konrad
