Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29203EAC8E
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 15:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773760435; cv=none; b=I31/R1mB38kYX4fh6IS16apq2wZ6ukITuzF2B09MCVNeUboX87F77m4i3vrU55Y9G+TPQxwk7AFIjWIe92/qUc49zv4GPjPKD7eA+N5Zaq3klGgdI0Ss+CSTC+iiTO5OV/Xk9p5GjEaSSUZ2hH8++ZwaZO7S1THkRcin1dKagLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773760435; c=relaxed/simple;
	bh=wec1FX3qjL0/PjlJ8JOlvRhgBfgGgl2MNXHRhXkt5JM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWEeZxtrDZguS0bk0L6hYrU5hXAz8seHaso/1syVgRMLGO/jlWpECxAES7yFcNMMZSRwG58pLjpXuZhg5yWSQTimryksX1gLRWdChpAzMgwF2BMHwu7TUcQgc7w9eKhMd0HSa5VNXLlqJSmu9vRSZRjYUIj+SpIeUCN4TAhEjcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XOHlssc6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ETvQ8BRK; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XOHlssc6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ETvQ8BRK"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62HEWpdK2314565
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 15:13:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=M6sq/ik301j6e3VX1pELu4ww
	YfreTBx0zyG1GNp3glM=; b=XOHlssc6ADVjTZFrQw8kS0reg08geFl5cmIWoxUX
	irlHQOEGNJDA2f70F+NTZMqb1eII3TlqHbugRUi5F4buNEnSuVSXaU8fLRTRSECz
	BTnP2byqdxt72cj3M0JmThXFcQnedrwx+U0AnxyA4OVFu0SvwQsQpb6GVK0U9nfh
	8GCgh9ckgt5EYOND1gOogWJgkejQ8pE//M0SbZv8tvAhAWa9yKz7D5ihjVa9GnWl
	vZnk54vTMSW7wr5cPNobS/hYohfWidw2Xcdt0Npw6YTx466bJTWNKTfh2GGkQ1T0
	GNFhR0csR46IFNl4v8q9M0PPY++TJIahg8uFK8clb1YE6g==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxmf2cewr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 15:13:53 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8cd7d4cc049so6238913685a.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 08:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773760433; x=1774365233; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M6sq/ik301j6e3VX1pELu4wwYfreTBx0zyG1GNp3glM=;
        b=ETvQ8BRKNU3HTsQ3ihIN6zLyC6Ie2Gmy0sK/IBtvfeTkSzbSOsExg1Vqd3g3ecwLCT
         nXpAfFyh2bjQ7Ikyo5KFBi6Ye1zQmMUn6WZ14HvNZDvd4SaVGp/gT1SAx3CeJHnNpACq
         4Yzde9q/MjOilNycxJvxSQDA5y06I736eJv9NjS+PJ7M/1bAa4/fIyPM1YyfDbRJzoTa
         zToB3HQb8P7dm6eHWwxA5Uw16bysoPDu06s4mmL4kl5IzHB4XGMkd4GwnJVqvMjSX8MX
         Kub2p4S1/+YP7jwSDUWosDA8d3fZaYSfPCho2L1Bweas5xWPpRWPwrZujU4Y3qWjh7Cn
         RepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773760433; x=1774365233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M6sq/ik301j6e3VX1pELu4wwYfreTBx0zyG1GNp3glM=;
        b=kBouwSXKr4vq+tbWoFx+n08779YrYsNJhifiZfs+lXC5z8VPS9jsxP6B7KMppDJv0g
         tAcTQkZ25s9cod6vZfef5s8PwOlNTcF7mok0X451qMEj9qcEI9i0z4jR/uzn83Jo5S+T
         enGLKvqpkz+u5R+Mkly7W7ZQFGMggSGIe/pRClVyir+UNITmiOkdLzccMHV+CtTCQPKk
         CIjGmmR8y6GcOBp3+8EGasJJJzEPcMb20OlhN9OpnteaPSGwFANmVMX+7E4L4xzahyHs
         uqt+7rHATTNyEyG3nZEhFc1TDbx2hpV5KgZggwf3sh06mu28NzxJtt+88LdXIR5zOGtp
         Cb3A==
X-Forwarded-Encrypted: i=1; AJvYcCVEkBxWjjXdEIR12q9V/RClRgH3gZGQyo6S3DCNVyg6i6n042QF7Q6K6lHDFzD0A3THhdgRemhJdzpZH7U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxU7GGbX7vHC5BzXGvfRYA8u5FxdnswlAmOs4IRiSm/EiO8x4p/
	AAr9RWj8kWHJ1KDSoeqnWGBa7SWJlpSNZrRbJmBpb4WoMZUxG1Rdv7g6MdgH5tMwzqVLVTkdb2m
	vepXcmWWO5l1xtR8ISINcFr82NWQPuXpYIsHXgPrK1EOMKytroZKoPzdrluU35sjkQNQ=
X-Gm-Gg: ATEYQzysd07OCWdGSUre+jI7hAoWFxzGkU1EC8hj/YMEOGFVrRsXbTWv8GbdOFKDZ9i
	cn4qUzUiCc9DntMzt2jsM8vEFS88XHQyVYbLBOxxyN1rrwU1hqMZlkDUn9Zgcnx2bGM7qqF1Gzs
	2dl1EZ2PaRdhN8jlBNKZrBLpNfmUfQQN6w+LGo+Vtz1Vq868+iOMy8fBCPmGyS4adTNnQB57g3C
	T0lD6xutWud3bl0saOy6t/IwFW5aatXeBWZDbZD3H56u/frBivoO+R+ilyv3fkqi4/ycPEobTkm
	QatKYPCq/XUbncKJi3S4gabwyXQT9FrrghrbIHv955UdcyQXXbbNHT4g4m+pFl5fMcr5NNneG7C
	E8GLOCMJNgzSt0AzJqF2Eb+9NwWuFZAtRUI89tTISzbUkGdqh7Jfx+9iS5zkmpMDDJHCgBG6dos
	Yup+bY/VQj/ZVSmyOQq3Xh0aN18GWJP+QZHU8=
X-Received: by 2002:a05:620a:4013:b0:8b2:f0dd:2a97 with SMTP id af79cd13be357-8cdb5b5936amr2250549785a.37.1773760432732;
        Tue, 17 Mar 2026 08:13:52 -0700 (PDT)
X-Received: by 2002:a05:620a:4013:b0:8b2:f0dd:2a97 with SMTP id af79cd13be357-8cdb5b5936amr2250543285a.37.1773760432132;
        Tue, 17 Mar 2026 08:13:52 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15602e5ffsm4227206e87.29.2026.03.17.08.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 08:13:50 -0700 (PDT)
Date: Tue, 17 Mar 2026 17:13:49 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org,
        Eric Biggers <ebiggers@google.com>,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>,
        Alexander Koskovich <akoskovich@pm.me>,
        Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: Re: [PATCH v3 02/12] dt-bindings: crypto: qcom,ice: Require
 power-domain and iface clk
Message-ID: <7dqo6qbpwgltnf7xfgiogfdpb6f34fpwsxuksdpphjqjljzsr6@hwqv7wjarob5>
References: <20260317-qcom_ice_power_and_clk_vote-v3-0-53371dbabd6a@oss.qualcomm.com>
 <20260317-qcom_ice_power_and_clk_vote-v3-2-53371dbabd6a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317-qcom_ice_power_and_clk_vote-v3-2-53371dbabd6a@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: 47v5UFBR9drwtjSf37DHJ4Y9-YfYnstj
X-Proofpoint-GUID: 47v5UFBR9drwtjSf37DHJ4Y9-YfYnstj
X-Authority-Analysis: v=2.4 cv=FvcIPmrq c=1 sm=1 tr=0 ts=69b96fb1 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=o8jIPucMfvaqZjgiISoA:9 a=CjuIK1q_8ugA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEzMyBTYWx0ZWRfX8u4tgbbPjg7d
 JZK9O7L6eAx6frML1fhmtf2bBBdICaXB4HIkxmOlA8lsxcF+xiJhmU63TxbAqJPz8PEo6G4df5H
 vKeF3YCId7Kz0hL2BWlMf+GSIQtYwDLNhEX7kjiHLciErH/kOI7v6G7V/Vq9b9pkD7PKAGkW/Fi
 bnc9Rb/Hgr7HWFYHgJt4jLF3z49lVd4cTs13tBTjL0WmVO1mTqbMipOOpelU1edO3GQ5OpMG7a0
 /dJao22o/ocW7tP7fassoLMRUF2qJj7mZV5j2pSRwj8LQWwegW750UxR3P9akJeFpC+G/u8KG3/
 QYMcNKNXav2NeVdbAKfa0miPqJXqanrUh98iuTfOwmoPIWRzOrNzBqGF+WbJNpiDc29Bgkf0COn
 LB44pF92FzPqlhKqT2tWNgUFoc7UGOjb8ImglJST78RA8Cs9TaTfNrtUxgVG2zllFV2GdkJW4A6
 bav6I7+hpOgyG3UrKRA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 clxscore=1011 malwarescore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603170133

On Tue, Mar 17, 2026 at 02:50:41PM +0530, Harshal Dev wrote:
> Update the DT bindings for inline-crypto engine to require the power-domain
> and iface clock for Eliza and Milos.

Again, this mostly duplicates the subject (and your last paragraph).
Either drop it or move it there.

> 
> If the 'clk_ignore_unused' flag is not passed on the kernel command line,
> the unused 'iface' clock could be disabled by the kernel before ICE can
> probe. This leads to unclocked ICE hardware register accces being observed
> during ICE driver probe. On the other hand, If the 'pd_ignore_unused' flag
> is not passed on the kernel command line, the unused UFS_PHY_GDSC power
> domain could be disabled by the kernel before ICE probes. This results in
> a 'stuck' clock issue being observed when ICE attempts to enable the
> 'core' clock.

What's the difference from the previous patch?

> 
> Therefore, both the 'iface' clock and the UFS_PHY_GDSC power domain are
> mandatory resources for ICE which must be specified in the device tree
> node.
> 
> Fixes: 618195a7ac3df ("dt-bindings: crypto: qcom,inline-crypto-engine: Document the Eliza ICE")
> Fixes: 85faec1e85555 ("dt-bindings: crypto: qcom,inline-crypto-engine: document the Milos ICE")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  .../bindings/crypto/qcom,inline-crypto-engine.yaml    | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 

-- 
With best wishes
Dmitry
