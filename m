Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795620283;
	b=xgh2mV+jom1mqqeUBqBPgl//vQr+PcdCyXWsA5agVTneO/tTIVV8C/0BxDe9gGM2u025
	 mzkjFl5L15U+W2XBya3Vp8ghkECjBo8CBBhBV4GscFt3JwwoT9wyptpefAqm1HXrQDvNx
	 2g4hMO0wiiNlV0Uo1Pk9Nh4yh9ZPMJjWN/Pif6MbY4h/PO6mS4v4bNKP7wOOd7YFd5nn6
	 j6c4kEUgIgihfsJqbY7JJDKzhW5/gS3cXy6EvGyMoOprQ2y5iccYFjsgc48WU059RWJBl
	 LEanShMQIZP3YHzcrgbSX0JrKqdbfgsW+NehErBvvrSwiv8xOEVUQCz2lUBvqBW/DgQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620283;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=BWI0oTPS6UWP+KHreqzTyFzt/bLKfNI1fMUEgGA2TjQ=;
	b=SoxGIKLpmbm2rsUh6rGYZP5h7Y3OQ9yh5cnnF9r+rtCFdqBw9+0pqvtX2u/x1q3llfxU
	 O0lLsmZ8LsLCrdNYiJe2AZFE7mRoFDfnaVnC7BlK40v6p1JHlhRwVyPV8o+pmwUAvy8Cl
	 b3KIstDw5DOkrJZxDd7Clrs+ql+VhDMrPiV58KGioIDys3N3s4YqzCW+EKd+iTMf+jwTe
	 X0h1fE/8/ZGhXcDVFwrwf4mwi/OKyUHvBerAEDVlrQDR/egRYisVu0i7efOsMD+buvyJD
	 QcXVZ0DgGPaHNt64jBFWhQQ1hBHVPxmDU1ZFOsylAO8E3np/e4eAcYMxTu3ebfcdm/Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="OpB6FU//";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cJM3cew1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46E3606A330
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 15:24:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A46E3606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OpB6FU//;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cJM3cew1
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6APEMJTl2955612
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 15:24:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BWI0oTPS6UWP+KHreqzTyFzt/bLKfNI1fMUEgGA2TjQ=; b=OpB6FU//8xOqb7OS
	5fVG54KpU7ZjNVKjctadQgIBzM1pOMtfT+p8RLJQKyYAAI7DZyJ5qt+UOaP/9pq4
	u8sBWRPln3bzRSPYJOuCVV7hYFjGloUQUfoatqf+FTAUdrFoUXI8IRA4nJgD5hO1
	itivGuWNLrBgEQ4KnYHzi73YpEIkNS2hpwNeAhy7ZKl8SxdU6IFb+LEhb4BFL6GZ
	DmcN5Y+58aqVqcFdGV9uBwFeAW+ByxC0qjFbCfgk8N4RUZhVJhAGLOUIiB4jt5Kz
	fAq9A5IwNKwk2eFTo41CSn49JtybruJZBKPkwkWdyxqWMvEUDUxgC06m1qXnG5Yg
	jtr1nw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j5nu6b6ea-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 15:24:41 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2f033dc37cfso57142235ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 07:24:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795620281; cv=none;
        d=google.com; s=arc-20260327;
        b=BlQyuS6Bzyz2bEzxVwCUaTsCFwft5MhGMqGanap6A8iRJAphJV0DjaJG7aZu1tNEw1
         Dr77vsdWlKcwCdTEU6NZvYO1uqQCvNnXShq/EdiltYjhBi4X0flub358Kp67nWKTVX/r
         lS2Ydm7cTJda0N5GhTU+PEU9jX7p3cKfbRJltKuWn+qFmGt4rQfPaN++sJU17WABbg50
         mfYsjji2LpRGbqE7Tl10ClTcVI+3EsKXoOQQ61m+5b5C/Hop5gtWVWuq2RoXKu0tBVaF
         cmRakv7uIdU99yIgSgboDDgKdZCoeX/nPGupusDozHMTBqv3zQ1eRwl5wlBdbtZT570M
         uF4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BWI0oTPS6UWP+KHreqzTyFzt/bLKfNI1fMUEgGA2TjQ=;
        fh=IcJbwwm3Q3utz2E1xCajUAAylBrfvoMsc/LX0ApvLD4=;
        b=F27Hy43y6t3+yW1+QIM2yIITllQjpAZ45WRgWNHehAsmFtMvyxQ6/mG0dGY/JUdR/5
         31PHJXEdqORb8mFlwjUwIDL0WYQ9LXJKYlflqbHdSQ8MhVgYhtjhmt2lyZ4o6K+P7WQC
         7q5a1+47qXPq3dYXcwGWCOc/IMusFMs2o+GRrlGDz61/39lfy3Bl3G7+t+pHVfC2E//G
         XwIwTC8zvLhrkUJ68HExCXzW5ZS8jFuHFQoPpAE7tgShY3+36uX7JY/En2WcTlyDrpJo
         1++ir+iJLRRpoowIbZP9bIpXAzKCHeCtEcrZLMfp3CjZaLGNKYD+t1PdbTYc6R5/CWpk
         GcSw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795620281; x=1796225081; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BWI0oTPS6UWP+KHreqzTyFzt/bLKfNI1fMUEgGA2TjQ=;
        b=cJM3cew1hkvYIyL1ViCsj3kK76klrSGicdUUgE9mOCNL1W6o5ORm0MgbmkkbZ++ky/
         2vUkNgT84tLjE6cV8KtUcoRzbEb4AngRs2uu2ze3e9psU18rHrty8zOfx2nTRki6hsLi
         ntrpPDqvdLM4Wo8v4CGdX4tcetEwGUIhKyej55Krwtwr4kzuKa6iIn6MVOxmio/d6kwT
         5b4N2UeS1wwaV3RF6Zb0f+T2aTYGrOhSSvPL+aVi08R7KJALyVVCmJEa0Ui6lQZvUKQM
         ArdimzhQYaG2Y4q3n+7rcEbhRmBce9JUP/ag7s9govOUlGhur1nxeuCr65eOi75ajjRT
         pU5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795620281; x=1796225081;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BWI0oTPS6UWP+KHreqzTyFzt/bLKfNI1fMUEgGA2TjQ=;
        b=pSRSVIZDjU+nXGr+/uVRf9jN/56ZHP4PplrOVEP+i4FJqfTL5pChf8sLbVFCl5qsUV
         Qe5Vl7Ij5dxS9lY6YfncSi1NTr326W7vAjGvui/43RCHyNxL96mnsReUFs6FNVQ3Qx3r
         U01Q5NykW5Ro3qZftAzZAdLUs3z2QryAZ7ZyXy5W7HdFRh4VuzgoIIYS1cv2wmm8JwJP
         OETLbHdlpN6yF4j3tKpATnFsy1B2peBWvEDqOHy1CyZnotXFuxHXvyi2jlpVwCPMNGcJ
         cWYckW8K4AvaE/lndSHFktbO6WxcfvkEScPLzW757n9NjMuk20nU5vh8zbrVzeeVd51S
         t+lA==
X-Forwarded-Encrypted: i=1; AL+hErFdyJIfHqg0U9qxJuKVeUuGNNTdODdR/mxL/jp50qJu6PPEV97rzCj+ow+s0Qt9Gz5Ts63EItEXL3tKAs0=@vger.kernel.org
X-Gm-Message-State: APuU4Z8B++UVtaquQ+nH46AtBBrAlHVmlCN5HJQuuikHuc+ccJ6CshyJ
	jaYiKHosnImQkhoV4nYZosANcdvgoci8HTAT/BN7Q1OoVN4ThqEBdLVmHLSzb2cTpUc+aeAsPkU
	2RjMTEBSx73if2/NPkTshmX/PjtScLma0sVqPkALE61Yf549gEyUsMQ5C1ix9ELL2BAj+uqKFxR
	deiCk2FmcLb3mfY38DkA3Rw1DFqdnl3n5BLv7DhWgYlg==
X-Gm-Gg: AZFdTZcrT+mPlnBN0NF2j7bq46rztVP/lLVz9VveGQ1dCJhjwpfEfBt21w7CjQTwMky
	ST/nQHaVqUopb+PuLfFCI1bxC3nZHh8Pe+vVMtOo84W7SpUgj++EKJd48AHsG5VJrdbCkbMimiw
	aBqBtKVh0z+f1hAIvDy4yDA3YDpQ2MPDuL+Q/HJ5seSfQijTo9KSumTTUR1Q==
X-Received: by 2002:a17:90b:2ecb:b0:3ac:8446:c1a5 with SMTP id 98e67ed59e1d1-3b41c988620mr15762950a91.48.1795620281093;
        Wed, 25 Nov 2026 07:24:41 -0800 (PST)
X-Received: by 2002:a17:90b:2ecb:b0:3ac:8446:c1a5 with SMTP id
 98e67ed59e1d1-3b41c988620mr15762922a91.48.1795620280668; Wed, 25 Nov 2026
 07:24:40 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com> <20261125-halliday-dts-v3-2-5c8311c0b70b@gmail.com>
In-Reply-To: <20261125-halliday-dts-v3-2-5c8311c0b70b@gmail.com>
From: Ulf Hansson <ulf.hansson@oss.qualcomm.com>
Date: Wed, 25 Nov 2026 16:24:29 +0100
X-Gm-Features: Aa3M54pQyww1I_PbdCBse1VupHYmzcQQ8jGP2HKCbG8YvURb7jcXXUW3MJhTLAI
Message-ID: <CAPx+jO9aHqEwVu3j5CdVTsfrhk8cMRawA5rj51EA7AdVtn-U+A@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] dt-bindings: power: qcom,rpmpd: document the
 Halliday RPMh Power Domains
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
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
        Ulf Hansson <ulfh@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: wUBIo7JW0ycM6MlLjq9tuUjrTZIoL1AI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI1MDA2MSBTYWx0ZWRfXyBsGQi8QrptX
 toRIrmkw8n0dKhCQ7p8pSuS+nl1wLl2m9fgpZM0xO+GgGLw+SRpXG1hPTSHxuPDevTb/grdfBZ3
 /4YWJ2ausuuIt4TBwXAei73wJTdWFBM=
X-Proofpoint-GUID: wUBIo7JW0ycM6MlLjq9tuUjrTZIoL1AI
X-Authority-Analysis: v=2.4 cv=Vra2kO2n c=1 sm=1 tr=0 ts=6b06fdb9 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=DJpcGTmdVt4CTyJn9g5Z:22 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8
 a=yRSEYQ9GznzmN70rNvQA:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI1MDA2MSBTYWx0ZWRfX21932ctWNpMf
 3blJLJ6n7tRrALGcV3VdHwdtC4pFJIVUvmKL82SZPuonyE574hw+2+MSgfTQ3WAnhyHF5eOs070
 N2q0vxZgJietO9wSqGxwxVu7QOf7h7GaCT1GkFAUha1ZZuWUMaiNHPnK+4sLMcI+wgRrLYAC4Hv
 LaKeBXlL2onJFUwPmrq2CeMCx7djgLQn8ffyCkXsm5cYQJLmS/nXwHymp0i41kMMHGw3T+aBiIB
 kPj0/phaxeCyJHjoHivN3KgRfmrlKPlLFmpwiD67fB7wlgtSJdhjydR/fTJ6OKW9qn9xoRxrfm+
 UXYKkE/wjwHq31A5Wgd8GEx3sOIXfT8/qhwN2oyWglM1rw5Ra6FnTY6kAmzaks1BKJ9OiRTyqYv
 XL6I7gy4ANP90NqXkFd9rZK9rmeBjiwwq7gKVrDIhbkjrMiWv29GNrc7ZlL1SyIQvEH6O3wBSme
 Dk3xv98Li4DqB8HjHLg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-25_04,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 clxscore=1015 adultscore=0 phishscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611250061

On Wed, Nov 25, 2026 at 4:44=E2=80=AFAM Stanislav Aleksandrov
<lightofmysoul@gmail.com> wrote:
>
> Document the RPMh Power Domains on the Qualcomm Halliday SoC
> (SXR2250P). Its command DB has the same power domains as SM8450
> (CX, EBI, GFX, LCX, LMX, MMCX, MSS, MX and MXC), so use
> qcom,sm8450-rpmhpd as the fallback compatible.
>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>

Applied for next (available at the immutable dt branch as well), thanks!

Kind regards
Uffe


> ---
>  Documentation/devicetree/bindings/power/qcom,rpmpd.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml b/Do=
cumentation/devicetree/bindings/power/qcom,rpmpd.yaml
> index 8ee1c25a7c9d..663baae9cc64 100644
> --- a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
> +++ b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
> @@ -82,6 +82,10 @@ properties:
>            - enum:
>                - qcom,maili-rpmhpd
>            - const: qcom,hawi-rpmhpd
> +      - items:
> +          - enum:
> +              - qcom,halliday-rpmhpd
> +          - const: qcom,sm8450-rpmhpd
>
>    '#power-domain-cells':
>      const: 1
>
> --
> 2.55.0
>
