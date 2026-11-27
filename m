Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795787929;
	b=Y50bAZrYNjScZoBpzSw169FbDwOLLKFLJ1zsxi0aANKw4F5BSZ5UQGHItaH/QBINJELg
	 PG2ar5BXODIYSkvyLnPSS4XAiDae13lu9y+JBBwOq8w1mreUs5DjCyU7/3RccpVRK9sXV
	 Lq03+M3wV8JZP3QJ4+WSuVvcwLHKRlsXmVtTSRIC3GY07FbDK1JOfR0wBcDzO12yWFxZA
	 386MoCldUSFnY1rbTllakFgB9UXFldfyj3fUQGQWF8Ibkxy51PxStbEF0fBNjO3KmL4LW
	 NTX7aFUFueJw2+x02LhtqBFu4FJ+ydS1OHXLOc8lCYtGgCLSM2QDd5SvGSvHno8IqWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795787929;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=1v7qWyLIaLArgF+vLRv6x7RBzzWwcYRuKaCCg84dQ9A=;
	b=NXUGXH2Xxu77L8yD4w8jaeIdXQpdP1SdTxsIVcJ4CyOb2LWHkjZiJ+Up8DvYtLZx+PX9
	 1P3BIPrUz+7kPArjOUz8Xks33sLZbZGFldjJVfF23G4zXHcAX2AKCerdcPv/Lna1TuxXC
	 bpt1AzzcB5IBg6hqgl+2DJP4/BtZqWqZbh1mqg+OsRgiv1y5NSik8Dr0TQlnN7cv8Tn94
	 g2ZvQapEB2UNQGSMdu35CUwnJZzFNDiy8gIVwwCxoiYiUz3W09e/4C/bw1qkza00GoKC0
	 9+xSjzBbYxTxIee2sH5UZxsehAWU0RSiTLuaLZgLtW45wyykwg1mWv2YTU/+R+S88RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TOjcsKcu;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FORsxwKQ;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD56606A31F
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 13:58:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AD56606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TOjcsKcu;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FORsxwKQ
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARDtugi674129
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 13:58:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1v7qWyLIaLArgF+vLRv6x7RBzzWwcYRuKaCCg84dQ9A=; b=TOjcsKcuDkQqhKEM
	pY+66B0jBD0y+w2WuxCnqNyxwYqmtuMoZrTl0cJPLd/mTTklLplbhyMHb4TC5Wtq
	Ji2Qk2dzyLEh2cMIRuDPdYHqZpE/N6fX61D4TPWfBAqekwTKIPscpXnW+mrJEX1g
	T67dFtRLf4IjNGcPXVhIvoHFM1MztDlxyVpCMHvcXvYw2hHwPLywFmqnznbL2nOM
	sz22SEUOUEnjiVdwNO2bgpnoMVFCLggMv5jNCcGehEEubP3PBl+8lUty7whgbc4y
	8od1uEnUK+wQdjbAqIyVdpYI0rzoM6UghTNlC4hv0RttWqdHeAoj6pqD+rHn22WG
	zHDzIQ==
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com [209.85.221.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j6u49b9ng-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 13:58:47 +0000 (GMT)
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-5edc82ecc78so345987e0c.3
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 05:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795787926; x=1796392726; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1v7qWyLIaLArgF+vLRv6x7RBzzWwcYRuKaCCg84dQ9A=;
        b=FORsxwKQO9IHATmRZuwnt/wzNKkR76nev4Im041FDN08XKsqjU4h+VVpkDoGm21N+f
         /oeDWC7HpwU5XAoQlfBoTZucLYqP2da14CrW2L7LXHltK8zA6hgd3FYjFMBJlh7gJTB+
         iD8G6N06MrZc/leeTgaSqm4ZRHGiVGyc5hvVqtkhQ6fAsP6PylP1sFZdxlR6y/biVyvP
         6suhILDhV7T7nlzNeWh9Z9G2sijUqJBTrC7KBxzn3QJYNhf6maSKO2w+9AfKYUiOWpje
         Gc72E6kLMJgBTCsCygQSVhizKDh/Je5Hnx9bL55FUerD2pHWiPV3arEFgvFuAb+dBxTF
         OYXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795787926; x=1796392726;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1v7qWyLIaLArgF+vLRv6x7RBzzWwcYRuKaCCg84dQ9A=;
        b=E/E7xKYL+PHHcqfxUMaZEs/jnymL+c+d6kzWQLAAbR7i6mPoxGToCrauHYu+Gp66Jk
         0fe9OFBcWVkk9FUmQKOzW/3W6DAU2svS40nXu5wx3afgta1Q4U/zAp72Yg4EovRK2VxE
         uyEDOR+ABt+GhwefGxsL1aZXnee6CV+q+TxFkkuQhdXgXrDgjeP0SnfUqNov2TbwmuZJ
         H1uHpCrUx2/w7TqVpaVLe7akytsyhnnasGSNOAq+S5x9W4/+KJ0/KivPu3GU1vojOpt+
         LndKns9r56oaxNCrxW/F/qym2mCeQldj7VcCfbQVPclBsiZjxpOd5WKswIjeA88LXQ64
         ncgQ==
X-Forwarded-Encrypted: i=1; AL+hErFqPvNJcPVkErbBMBUgVcRogSjdR6eUqNHZziDpbZKHTKzNUFDXOy4uR8wZLIqRy0sFy7q0bmg2J/ODkLo=@vger.kernel.org
X-Gm-Message-State: APuU4Z9Gqyjx85cWbY7mxRRrLnyZm7HDLpQQspnmbhD1otKLOTs/zOMd
	zLBg/qyHVA+yL1XdVs4Fl/Gp1UF4G1DxWUaRvA9o0ZjF92dYBNhBYIeAJfW/QFduPGOWwrX8Egb
	iyMnkpAn6JSxNwIkqdcn5Bx1mdI7GpIweH9vzMQpZjsS5ypdfXEkcjZhnnRKzZq778yU=
X-Gm-Gg: AZFdTZeVVHZT7v1hYYLD5X4OkWL8VayB8DipvwPBqhwHGuxh6ffNTe4X9xVrC6bEf/I
	c2KGp4LsszNI1P4381kc9GX3kStvBIwBi1Y7+pWrlGE6PJYH7SZb+Mn3MYnLQnaIlB5vczWP3ud
	2JPeoC5a66DarhsKEqXjCXA/rIarflAQYIXHuuHde6ENZA5MgPwwa00V38sabPHY8pDHHoBmv52
	pzhlKcaV6EFgZ0bvL5kyjcUFLnotBClRx6LDCHnJ0+IELlj66GhlHw3NFmn35bKQ5bPk7gpHKXs
	bwAs0VLjaf8cZ8++pKE354wsRLR4G9CMlTKvPa5hV54cfcNTT3CqHpLRXRNFPawNloxSXn9aYAQ
	wc/B9I0kTGls+JlqWUbR6sdq0Nv8O/e2pbM+nOZ4pzyH6WROQR/Gc9Vznj3VJmggl8wHCjbo=
X-Received: by 2002:a05:6122:c2c2:10b0:5ec:b706:37e0 with SMTP id 71dfb90a1353d-5ee8ae3e277mr16434832e0c.1.1795787926274;
        Fri, 27 Nov 2026 05:58:46 -0800 (PST)
X-Received: by 2002:a05:6122:c2c2:10b0:5ec:b706:37e0 with SMTP id 71dfb90a1353d-5ee8ae3e277mr16434775e0c.1.1795787925770;
        Fri, 27 Nov 2026 05:58:45 -0800 (PST)
Received: from [192.168.226.72] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ba37109b55sm10578803a12.32.2026.11.27.05.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 05:58:45 -0800 (PST)
Message-ID: <87280d80-9047-405b-8dcc-11276d34d2dd@oss.qualcomm.com>
Date: Fri, 27 Nov 2026 14:58:40 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/14] arm64: dts: qcom: Add Samsung Galaxy XR
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>,
        Guru Das Srinagesh <linux@gurudas.dev>,
        Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>,
        Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        "Joerg Roedel (AMD)" <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Jhu <stanleyjhu@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
        Georgi Djakov <djakov@kernel.org>,
        Sibi Sankar <sibi.sankar@oss.qualcomm.com>,
        Ulf Hansson <ulfh@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-usb@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
 <20261125-halliday-dts-v3-14-5c8311c0b70b@gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261125-halliday-dts-v3-14-5c8311c0b70b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: H8TFJvCgoxD1UQGKdQSz3Yt2n33-wGgg
X-Proofpoint-ORIG-GUID: H8TFJvCgoxD1UQGKdQSz3Yt2n33-wGgg
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA1NSBTYWx0ZWRfX24YgeMv1mErk
 A6+v2N5geWwhB7PVHIYMAFoFMWepSTLsbqDRwA9TcWpZet+Q+I2JKxNuO3AfJKBLjUZ+ehzmPK2
 PzPoIoP+jXWrT04E7Xv+X91XovwPrkw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA1NSBTYWx0ZWRfX8aJ5YxSH73ZN
 RNXKrXOi3AzNqMpiUEtHxnd3Gt5tXlK51Al/gtXq6jxTAPG8H9UF/whLQpBWdSRsWSUFeFZpG59
 P4dFG6ZofoohhZChk3iLLXNQR6yql/qmRQxL2xlfBTdvW6ICThnu8Xqi9RDJvzyjJm3ueic0NIO
 hK32ADO6MOoy2OcOgIYVXJaQ9RMEkRHV9AVq1YGdCr2XzIh2C6lFlD3B6fq+1b0fz5H+WoA8Wyz
 OOSmwX+1tCty4LDDjyWdG/yHVE2ZuncU+pM667H2Ml3Qm81xbopc2x+2A/s1iG0CTP7VgBKFJBD
 zZxHhErQT849Ug8oLe4tYRA8Nmlzv8QSmEOSIzxj5dcIsww82kQ6slva710i44qtqPD2XH6dpRz
 s+zEMvriAtEN/v+ipncSl3++sHPLSwxei5B3BSiX7iAt+jXLEA1LreAu9ZiII0fC/PdYIRbhGTh
 c8LbagB1ZC3N0w/lIKw==
X-Authority-Analysis: v=2.4 cv=A875rKWG c=1 sm=1 tr=0 ts=6b098c97 cx=c_pps
 a=JIY1xp/sjQ9K5JH4t62bdg==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8 a=pIfNyjNAQl_vEFP8Sf4A:9 a=QEXdDO2ut3YA:10
 a=tNoRWFLymzeba-QzToBc:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 clxscore=1015 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270055

On 11/25/26 4:43 AM, Stanislav Aleksandrov wrote:
> Add the device tree for the Samsung Galaxy XR headset, which is based on
> the Qualcomm Halliday SoC (SXR2250P).
> 
> Supported so far: the PMICs and their regulators, the power and volume
> down keys, USB in high-speed peripheral mode and UFS storage.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
