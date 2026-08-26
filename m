Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33B63B9DA8;
	Wed, 26 Aug 2026 15:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787759137; cv=none; b=gAE9XUyiEf/c2V3Kq02yEhQj4W4CJDzyH8NdZUc86+1lhfxMoEUAj4c3Sl9zBWVB//hQj3FyBEMy8Hs45WBb+EfsAZl02l/nNC/w0Tx5F+VE3pLk6HASSHnJKSKxwO3BUtdnPwUF7bo4eH5aHSgcIOux7jaSJusltDZc6T1zDxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787759137; c=relaxed/simple;
	bh=KXcUPHVoaQJfAjh0Xr6CYc3qr686V/ZOfBvoUG+IKCA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=aZqeqVB3kStSot76yvjB1y031R2LdV0LtzOtm1GXHfeeJNj9TI4NEPBP5LqOYNYkxnZa1yZTvJVFrUOZ6fymElsAIkvev25ncHR2ooJJA8yIMWYPuDbSvZ9fPutK/UVRbE8eqtIGFkigE7Cfn5F9McuEY7Gp/P0HVZ2P/DzBjzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jkTTR/rM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jkTTR/rM"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67QE1hka4099807;
	Wed, 26 Aug 2026 15:44:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=QHF3Ke
	bkIZ+vGajKHXIlWCi+fcg+Ol06VbFwHvqxa1o=; b=jkTTR/rMq2EQrhbiRdeocp
	957Pnj701hoAbAUxVDCdclrngvAWSxbFVoA61xcx3oiyk+by80JKBYh+TPI98JOl
	rQClrkDZVL934D0GrE4vOGjWR0qjpOZH65/wQR2mfkqLMSYc7hQXpDdbHGeLYWST
	WyP+Mtr8cbDaK2IlQWFVf7OEsho1JwsjjG6dExGQtU4o9iIGyNN/XXrT7FwPh5Dv
	jAomC0yG43n7MtSl4KJeQvW2HKQp53O4SU8lWT4vk+nLAeME7i3oiYQFpdDAoreK
	MGwYgzPpgD1C6KvYsuW8m420OyUkiJB9cqH8FSEeMaXJU3DlUtu1SDgoQosg77Kg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g716hyr5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Aug 2026 15:44:46 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67QFfHXJ010818;
	Wed, 26 Aug 2026 15:44:44 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g7p3qay9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Aug 2026 15:44:44 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67QFigVA50462990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Aug 2026 15:44:42 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5B2F20040;
	Wed, 26 Aug 2026 15:44:42 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF9F52004B;
	Wed, 26 Aug 2026 15:44:40 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.124.213.3])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 26 Aug 2026 15:44:40 +0000 (GMT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/2] crypto: rsassa-pkcs1: reject undersized keys when
 verifying
From: Sudhakar Kuppusamy <sudhakar@linux.ibm.com>
In-Reply-To: <20260826103744.1554131-3-Jeremy.Jean@oss.cyber.gouv.fr>
Date: Wed, 26 Aug 2026 21:14:30 +0530
Cc: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DA520816-F403-4F8D-87BC-F4ABA923C06B@linux.ibm.com>
References: <20260826103744.1554131-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <20260826103744.1554131-3-Jeremy.Jean@oss.cyber.gouv.fr>
To: =?utf-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI2MDEyOSBTYWx0ZWRfX7qTLye1e0wro
 zWYuWJr0yq7pg5k5tjXKeebFu7jPDxhLZZtEQvFCTqg3c3r3gRDXR9c0BTww7Wv2v0Yt8hVZueP
 JsJPLWpau8/s1XcTCnJPOlWB+TDj0s8=
X-Proofpoint-GUID: De3-inlnaXpaCoihQWPci-xmyBuLLUIs
X-Proofpoint-ORIG-GUID: De3-inlnaXpaCoihQWPci-xmyBuLLUIs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI2MDEyOSBTYWx0ZWRfX6Q0iUrMjShJO
 HoCqoAeYT4J0ddps+8gFTx9CAgbsYUkeyIiCgXi9OHOl9/jZ3qOGObEIbINBf3K8XEhu4hneA20
 UhZRIHzRCqqodNiBqi14O+l9eGcT6wnEUbNgmXVnZN1UNH9Fl9+unVX6UO0iKBwHCEniJEXorSg
 nOX/VhjTozgZqFXa2mTv47S0Asm7C6XADFWrYR2RN1uSzyeO55ziftS9pCQY3GeFy08NfVdY0jx
 7GIn1vqwiwmbAkt5I1BToTLu5QdKbQK+4PBbNoZQ9I1iUNbnRxD931YByzQD6UDfmjwA15dQ+cu
 b2YHpMWvF5mxWrTKaP5fxKFiPeVLFvvcfrAxZ13A7r1IQiQ65EYXH+lHYxNrg9D8vi409qI2S8i
 Bbs9vbey2J297dTPzW6cW/x5Gn/Xv3yxnfs5YthdTz3WD2PFe9BuzNaXTCyJUuNmgFINEeRbikt
 OZcG16FbApveM4r931A==
X-Authority-Analysis: v=2.4 cv=H7brBeYi c=1 sm=1 tr=0 ts=6a8f09ee cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=Qxsn6e9zUWdzkDgwqbgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-26_04,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608260129



> On 26 Aug 2026, at 4:07=E2=80=AFPM, J=C3=A9r=C3=A9my Jean =
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>=20
> rsassa_pkcs1_verify() accepts any nonzero key size.
>=20
> With a one-byte key and a zero RSA result, the leading-zero handling
> decrements dst_len to zero and advances out_buf past the allocation.
> The next out_buf[0] access reads out of bounds.
>=20
> KASAN reports:
>=20
>    BUG: KASAN: slab-out-of-bounds in rsassa_pkcs1_verify+0x79d/0x900
>    Read of size 1 at addr ...
>    The buggy address is located 0 bytes to the right of
>     allocated 73-byte region [...]
>=20
> Reject keys shorter than the minimum PKCS#1 v1.5 encoded message size.
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
> index d0e4a885397f..39137476ce81 100644
> --- a/crypto/rsassa-pkcs1.c
> +++ b/crypto/rsassa-pkcs1.c
> @@ -231,7 +231,7 @@ static int rsassa_pkcs1_verify(struct crypto_sig =
*tfm,
> int err;
>=20
> /* RFC 8017 sec 8.2.2 step 1 - length checking */
> - if (!ctx->key_size ||
> + if (ctx->key_size < 11 ||
>    slen !=3D ctx->key_size ||
>    rsassa_pkcs1_invalid_hash_len(dlen, hash_prefix))
> return -EINVAL;
> --=20
> 2.47.3
>=20
>=20

