Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E449B22579E;
	Wed, 26 Aug 2026 15:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787759114; cv=none; b=m/9s7GcLXAyBijjlXjAutYdfZtCyJS6S26+2x213nCNeVjtuhtBSRX2iZ33BZExgzdBrl/yLOKxB4bhPT2epRj7gd8Huj2IXSdS9fJy9cxfO3hfCld5t4yg2jDzUNBfjtiuY6ekmuRulUZJiZPoh2+fbCE/Cy8Ec6mYq00UadFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787759114; c=relaxed/simple;
	bh=yda9MUX6Jg6pKFvP2ewvFUC91f4Gx/tYfXr4KQPMAeo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=HDhL+1UUVkuBA5D6z+LU/e3nZ8u4WcYQgnjwOtf9o8I6/VXmZIQe0+qYy72OWR7aRVVM8EBDp/h989vTubO2XrwTMqmNLCjhmu4FJKQba4WPiZaJKoJQOdIKae56q7o2ygDciOjd18t5Ec5YKd90acnJ4Om4B4pEzps/pFZJy4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TFvHXejf; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TFvHXejf"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67QE1VOG015857;
	Wed, 26 Aug 2026 15:44:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=QhuiGP
	oXMhblmngJRX3eRHy8747s4QcDdumj14CAWzI=; b=TFvHXejf39RnAPmXjsnaNH
	FBATIGC2zLdpW2XNA8E/j1fKrTZnyfqmejgH74jvp+HrPpouOXfd2zPSWIEV0jYD
	q/f/Gz6ecU+4mHhbb+9w5m9rPp+Ef1wfFBRDAq6vAwxOF/BX86NCsE/0Ro4whkOa
	hYAz4AQA/Azdxd1Wlus4yaLpJ2SnY9J8uzCz+1tzRJbywrECFg53D6AysAz0zjho
	Kv1AykedjpRJVLShbbY6StD9Xt+bafgnK5SUbe+oom/EPtQcoMKQYhKaw7TtFC5+
	FqfzimvXWQTWELMDs+D5H8GYwaBdGgru0T0L5PTv6l0RnopEJZSVB5SybiBoAiTA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73g4ynp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Aug 2026 15:44:21 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67QFfHXt010817;
	Wed, 26 Aug 2026 15:44:21 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g7p3qay7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Aug 2026 15:44:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67QFiJqT37618026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Aug 2026 15:44:19 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F79B20043;
	Wed, 26 Aug 2026 15:44:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6015320040;
	Wed, 26 Aug 2026 15:44:17 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.124.213.3])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 26 Aug 2026 15:44:17 +0000 (GMT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/2] crypto: rsassa-pkcs1: reject undersized keys when
 signing
From: Sudhakar Kuppusamy <sudhakar@linux.ibm.com>
In-Reply-To: <20260826103744.1554131-2-Jeremy.Jean@oss.cyber.gouv.fr>
Date: Wed, 26 Aug 2026 21:14:04 +0530
Cc: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A894B32E-FF69-4459-BB5E-662E4BEEA9F8@linux.ibm.com>
References: <20260826103744.1554131-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <20260826103744.1554131-2-Jeremy.Jean@oss.cyber.gouv.fr>
To: =?utf-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9S5tsbgRv8wJc3Dg6MZZ3oPO72zQD1UU
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI2MDEyOSBTYWx0ZWRfX7ZldgjrWg2mY
 qDfZ8K5WJcJuV6B0hUCs1/U1SpQJP++0OIS63PKVcw8+3LPseCAHGzjFiUTN3BJAzJgRZ+2PsPY
 Ht5kpKTenrdHwNfSsl1sfQDszWWMda4=
X-Proofpoint-GUID: 9S5tsbgRv8wJc3Dg6MZZ3oPO72zQD1UU
X-Authority-Analysis: v=2.4 cv=JZyMa0KV c=1 sm=1 tr=0 ts=6a8f09d6 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=hsIq0pbpFFD4-NfFpr0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI2MDEyOSBTYWx0ZWRfX3ehDIXLkKmiN
 mKq2DpdvhIrudqGeZcKdtOeIhSSANChnLZtaBGskKUqOtzdIW2qA4RnddqhNi72Ms1d+vHFdxAu
 qMuJhcQVLI+kDYpSVjqWodyamEUK6vUpjoFSuqtCIAJBWwC6Tvtb5Mk+f2pl1shkXl7s6fMx9iH
 IJVWCimxbbZkB7BYMOf4o/UUxOEvDO4oFZssxvwps/tHXbZoYZxOe+BOfGLds5L7BZ/gLR+29PY
 aRNGVgBHmUCgIjq52vx16cF1rOzoMlPW16RAv1f4YBfjkdC6FOTdGV7HbK4NqKCRYWbmP6Wc5Ke
 3il5GklWfMX1SJPhaKBCQrE43LCyE2PyjO2/zqO1XJb22gGCrEH8vv3yyW3qjTr8+jXhvxQolS6
 57oZ2EAlzrc8qeRVOBTIrwep9B7bOXr9YYHY6f8LO0vI9FGxI7WXSglXf+cH8sIKIEFPS8vvBPv
 WOk+xWCxac4f0oEoyPA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-26_04,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608260129



> On 26 Aug 2026, at 4:07=E2=80=AFPM, J=C3=A9r=C3=A9my Jean =
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>=20
> rsassa_pkcs1_sign() subtracts 11 from the unsigned key size before
> checking that the key is large enough for PKCS#1 v1.5 padding:
>=20
> if (slen + hash_prefix->size > ctx->key_size - 11)
> return -EOVERFLOW;
>=20
> If the RSA modulus is shorter than 11 bytes, the subtraction wraps.
> With a one-byte key and hash=3Dnone, the padding memset() writes past
> the output buffer.
>=20
> KASAN reports:
>=20
>    BUG: KASAN: slab-out-of-bounds in rsassa_pkcs1_sign+0x1ad/0x3b0
>    Write of size 4294967294 at addr ...
>    The buggy address is located 0 bytes to the right of
>     allocated 1-byte region [...]
>=20
> Reject keys shorter than the minimum encoded message size.
>=20
> Fixes: 3d5b1ecdea6f ("crypto: rsa - RSA padding algorithm")
> Assisted-by: Codex:gpt-5
> Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>


Reviewed-by: Sudhakar Kuppusamy <sudhakar@linux.ibm.com>


Thanks,
Sudhakar

> ---
> crypto/rsassa-pkcs1.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
> index 94fa5e9600e7..d0e4a885397f 100644
> --- a/crypto/rsassa-pkcs1.c
> +++ b/crypto/rsassa-pkcs1.c
> @@ -169,7 +169,7 @@ static int rsassa_pkcs1_sign(struct crypto_sig =
*tfm,
> u8 *in_buf;
> int err;
>=20
> - if (!ctx->key_size)
> + if (ctx->key_size < 11)
> return -EINVAL;
>=20
> if (dlen < ctx->key_size)
> --=20
> 2.47.3
>=20
>=20

