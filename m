Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795817060;
	b=TtarRD/Hwzv3VleHEVMPJbAV2cCz0/4Es5JCsnPQW2qY4EQIPILqN6coCVH9o+k40Yxw
	 G4FbDATlUKQawZPyNvZvFGPtFeUR4ZbeyWtll7lF/wtxbL+ctJUPh7mcCPKm97mXFUunV
	 VQwDTDxfpNClq3c3DwOU1Bkf4PYk4DSXlCBkEpfq+6/U5EX/ZyciCRxIVwQ2SwGUMrkPm
	 2NorzxqWlIyAyRTgFUJyu6EGSzZ8vy3YuzSNn0VpDAk8TOXoBK/xQx+DwB0WPAMXXEu0Q
	 UlbP8Sm1LzEQIGgc83JisqodSler/Ul3XS8SMK58Lsctfk2C9+xDmTs46xFiKSgMmGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795817060;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:Reply-To:From:Date:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=JGegOYPUkmuOzaJl4ip/1ixl2J9HWePeYSjpj3fg+rA=;
	b=AdvB9OWJU7qi0kT3mNv3GD2YKihqhZ3qf+hQLB/LIecMWh6beYfjDMQEHe4f8ZyNpTwJ
	 nyDeWNLHNGuYQZ9513XXbelCylNyNoYRxZcpJWJCz8Hj35f6Q2Py3a3fxrlqSt5sUI4Vn
	 2W/hEt/FD+rvNvkkeYF9/kmZAIduhrYbCwYK1kA4KXM5uhdsvlZaKpzzxG9OKpw/No+Aw
	 xGYtuXDrxzrq9XDq9Y0X/vE7TCGoJqW55sP/Nwe9OyD4RQfvspC1A+bJlo8XoO4+N6qpT
	 vwLEj+JoSkb1krrE0rmns9a3EAQVJKpCyLV31FgDmmL9wvCNePPXHQ5M+MRHVsMrpxA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VuV5uhcl;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=eXwLlq4P;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0BF606A31E
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 22:04:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E0BF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VuV5uhcl;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=eXwLlq4P
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARJB1cg1127964
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 22:04:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=JGegOYPUkmuOzaJl4ip/1ixl2J9HWePeYSjpj3fg+rA=; b=Vu
	V5uhclGLJCw0uuDKiYF9CAaZtWBrhjmkkK5vqeYo4SiQvna1e7VqqrIsW3j2OiS9
	0/mzPioQGVmi+zv538EbWc0GY92sAslAei8nYZ0pwFIcL1BUQW+tHa2o8fQ9v48y
	9hTlRQlYhqIq3gvlaomL0BPc+7CfUlVXyQGTSiEzifDRX4aOAomRg0aMGI934hg2
	jjfgoKBjYyXAjYRqilnyAUCHA3mZnSy0rLXW/Kr/cGozYEcZoNGXGywinJ/wwBub
	yMcVjuGvijFy/92EnyjECH5/xlx9k36H2H1a0sysBHaX1wM1HfHaxgbi2KxQkdIH
	c9uQup0+e3QZr/MrFJrg==
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j74g6u1ew-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 22:04:18 +0000 (GMT)
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-46f178d813bso4761092fac.3
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 14:04:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795817058; cv=none;
        d=google.com; s=arc-20260327;
        b=X0zARd55c95LldgYne1/a2ZnqNYSGTihny848HmNzfz4W8Vqvq//mJRvCRvKEaM2m5
         UgWStKQj6b+9I/gTjjuw4BE8dgLtfdt4sVA9lGGp43hMiOfRLww5MoJ9A1CzEOL+mKXG
         Ujq0/57UXcIbbSX7w0nEczt4lHVCaP6wwIRWl3u2X5gU6WIq8Q18gq5IL9c0QAW4BlUD
         TRwal9s5ZNyNsKue7D4q34Gr624NWkSinG3/4j+LWyBpYlfCUqxDFcC5mnr38qOw8/EI
         ShUVR0/4XPsAOZEfAgV3c6tSVpLZMSG5qfa0Pj6gCIlaoQK2ZIsLaCpK3vJrIGKwLHy1
         EXNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=JGegOYPUkmuOzaJl4ip/1ixl2J9HWePeYSjpj3fg+rA=;
        fh=bqS2uTqvKLf7au+1D2jieqkQjkEL1MM/BRWMYQvCiA0=;
        b=fQupB5s6Z4YtxF1FKOsD1rRQPNPrqutrlxQIHiU8T0WdSDH2B1R5pgyhmmyXVfFG5u
         wm+f8onvxTuXuwW34Yeav0VkQfranFIF3NAJ/X0uLXsKuy1oxi4N/9X0fJPm2d98qU1u
         68cI2HlQDbihbRdG/TKWHuyY3qtQB5YMhF+gL/uGpfd1ooLVyhD0oaAeBvCLLjj7ryL1
         aH7+XZeX7ik3U2cRhp3I0jba/jTmZehmC/nSR11ZzASomlMW/CQyz8OWeYlsvLUifg3/
         cPQsyDS4IfZsNoXQDG1rLCKBnlXMhOq10UAxTd4aBFxVAzgjl5nAvBztrnDxi6ST0Pbo
         ZZDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795817058; x=1796421858; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:reply-to:in-reply-to:references:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JGegOYPUkmuOzaJl4ip/1ixl2J9HWePeYSjpj3fg+rA=;
        b=eXwLlq4PYSgOHHx6/XpsQMNWT0E0nHzeVhbkOkjAmhom8njmHs5xWEfoylrxg6UyvV
         eOx1dxC85FK6zF8BKmmkS/K4W6KEwMcQpy6Rh/iTci3lBdodguOZ0Bp+bAOXEQ6hi5GS
         6C8IoEwABtGvlCpv3L8e25lHaK9aXiYueNT/s1eIlB7j9YfQaVWgQ51wyDnEzAX3UlFG
         KJfyIzoH2Z9IsgQW3yT94rTtSGEQJZLZa5nHCJTL4dy0SkvzBhEYYIbvDPRCbj/BktRd
         +u2yoKt57YSTzpaGbDs+3ZYOCk8J7S2O8JwQg8CvO7LK+zqEGnYTAZa9ZYHJ1bXIT+QS
         8fKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795817058; x=1796421858;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JGegOYPUkmuOzaJl4ip/1ixl2J9HWePeYSjpj3fg+rA=;
        b=f/1THNWHdxlcXHaPCxyU2Bd7Cb0vDabkDgU7K3di5f4rtqPgG8TfG/Q9yF9L9SRng9
         3wks/nwK6La+IptIFR8HfW8RRyJEPjyzIM6RWR2DiacjYZcxJQ3Uf1dqpBbHtiFqYR+S
         SOEMl3SHnJdI/nyCzsMdEZNPRchmpR4dMKCeURCPintpK8iyXVCa0e0cW8mPbRGD7RlG
         olu7HZEOdVMGG/4qla8G57wNvKgmEHLONo/n+3a9iLyyIRYzyG5T4LW5TzQeBxiv4cd1
         nMBVKbf38sjwlhSP7NWOhi1ihuIZJDQXXloh6HNpphZsVUSrV7GBXoMumdXpnDS7k5ZO
         yYnQ==
X-Forwarded-Encrypted: i=1; AL+hErE3QFEtjTdFGWAbLdVbOIG/gAZ/9UhX7SQX56mmUuPeO6cknc32t0tKQ1MnK8qYlf5yX5QegqcuQH2uTTE=@vger.kernel.org
X-Gm-Message-State: APuU4Z95mmakrYOgCkEyyh5LmplmhM5xS5nZceOrkL4doIB/rni5pPbB
	G5iZK4oFzDagO7dtKh621jlMYu5MIfXsZcAx/E8RETppJ5XEn5DBc4X3Myo08B6HV3kwy+JWAjm
	/de1mSShwFX1/KU6Z5OxmUxolJ7DFYFF4OljYybKUnwhQ/vadBSsz2cpw0ARuVnZTkU0DZtLQL2
	6k19vhzbDEMqg0nnFZTz1nrtMfvUe3Nxr1F+9WfAnhlA==
X-Gm-Gg: AZFdTZcs5EJDmwg+8j6puDR/KTsrUGC1mfyHnVMzb5Jt3A5f+T8pIJ8AuQ0BzHNxyEQ
	D92fBijH8TaaF7idycRN40dqngZj7YqygBOdzlE7NEiOW3XkuicaP09SnhDbShwxTeNyasLOKcG
	En+iGG6zodtkO/dLxvdA1EEMW0qVhbRp9UH+Dsj8XTTJCf5mPaY+8FtMI2xhyLZrf1RqVB+9W20
	db+HmBOemiXVcpVphvqSA==
X-Received: by 2002:a05:6870:92c9:b0:491:6c73:817e with SMTP id 586e51a60fabf-4bc7d270fb2mr24823483fac.5.1795817057613;
        Fri, 27 Nov 2026 14:04:17 -0800 (PST)
X-Received: by 2002:a05:6870:92c9:b0:491:6c73:817e with SMTP id
 586e51a60fabf-4bc7d270fb2mr24823451fac.5.1795817057156; Fri, 27 Nov 2026
 14:04:17 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261127-qce-fix-self-tests-v13-1-80b601792901@oss.qualcomm.com> <648c686f-c20a-418d-9314-4b269321406a@gmail.com>
In-Reply-To: <648c686f-c20a-418d-9314-4b269321406a@gmail.com>
Reply-To: rob.clark@oss.qualcomm.com
From: Rob Clark <rob.clark@oss.qualcomm.com>
Date: Fri, 27 Nov 2026 14:04:05 -0800
X-Gm-Features: Aa3M54roYu8MrDi1iygKtDP3qZ6YDP-WhV4C28xi4aVFCCESr3FORy1xpwMQ3ZM
Message-ID: <CACSVV00Juw154J08msOA63a-_4TYvHzYqsjPnD_nE6jg-_=GZw@mail.gmail.com>
Subject: Re: [PATCH v13] crypto: qce - split the crypto driver into core and
 crypto parts
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: hSptfq_KLxN3LHHX2wkvz4ImYaioSpfW
X-Authority-Analysis: v=2.4 cv=U5kHnuru c=1 sm=1 tr=0 ts=6b09fe62 cx=c_pps
 a=nSjmGuzVYOmhOUYzIAhsAg==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=rJkE3RaqiGZ5pbrm-msn:22 a=pGLkceISAAAA:8 a=wJmJrFKEA18kwO9BSagA:9
 a=QEXdDO2ut3YA:10 a=1zu1i0D7hVQfj8NKfPKu:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA4NyBTYWx0ZWRfX4ox5hmtqjdLU
 iRaZyP5KAxcNWmCxcgTAQVq7aNQ5uYmo39LQ7nZXZUAHId1y6r17L0zShZdtbyLLiofDoukXR/5
 9srf5FvJTa8vITjB7mGyGIN2HDKBjdo=
X-Proofpoint-GUID: hSptfq_KLxN3LHHX2wkvz4ImYaioSpfW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA4NyBTYWx0ZWRfX7gEEhtAScJ9c
 1q+jHmUI5+zv8VYJL2u11UozguKN4nrcFA1gtIm0nBo2l/C7MzOvgedVr+dMRMooiFp8GTdhKAV
 8g0mqH3gyX5/veQeb2uya3eu/pFOJxIjSlIFy6GsF1/b9EaWOB5PDdB4/XBIHVqpTM9o4WIHVS3
 a0uoMWzlMUW9YBtSDmC9sQiwrP3pm5Vmg8nNTLHJG4J3TmE8H5Ck7vDldaJAU8WQdm8XowJUSaC
 y7xUfF6a+whLQCsQzaEpKKRVKT+nbFFQW9U9i/TnBqBHemGbZGsIPWS35QqqUPZczG7tAP+eNR/
 0hx3HTTsg230HCudwMutNztVRnXBJdfRVFLkfYrA1SHkn5KOXGhMc6XTHwH9tGuBy8ULKGmRFYd
 D1kGcvoXFsj0woFIR5xtrNfoPObBNnZRAZyTqIex21KL4P8cpXOq5xBmHbPnBbGCCzVMIjgujEh
 Ggpk7CiG4oDB/dRbEzg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_04,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 adultscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270087

On Fri, Nov 27, 2026 at 1:35=E2=80=AFPM Demi Marie Obenour
<demiobenour@gmail.com> wrote:
>
> On 11/27/26 12:38 PM, Bartosz Golaszewski wrote:
> > Most users don't want to enable the crypto features of the Qualcomm
> > Crypto Engine driver. However, they still want it to scale down the
> > interconnect votes to 0 when unused. Additionally, more features for
> > this IP will be supported in the future (for instance: for secure media
> > playback use-cases) but this functionality will most likely require a
> > new in-kernel API.
>
> Nit: Can we use "restricted" instead of "secure"?  From the user's
> perspective, the media isn't any more secure than any other.  It's just
> inaccessible as cleartext.

Very much my own $0.02 here, but for better or worse "secure playback"
is what the feature is more widely known as.  I haven't heard anyone
ever refer to the feature as "restricted playback".  Not trying to
argue about the original name, just pointing out that I think
referring to it as "restricted media playback" is more confusing, not
less.

BR,
-R

> --
> Sincerely,
> Demi Marie Obenour (she/her/hers)
