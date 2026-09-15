Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23218330B09;
	Tue, 15 Sep 2026 06:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789455551; cv=none; b=NB6falu0Wk5yJr2CMpSEuv5ImjXZmvMlzn5g0zgPmkExYeXAKXipuyYTih4kqLSGJsx7Rm4pyrARjQMFLtWpJY4g8zIJxvthCcxVDJ/uiHk/fPNCvDyukpJfx7KRFqmDwf0EyqTcjuxyMXkN1TLFS91r5sonb+RipOLk8zFuC7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789455551; c=relaxed/simple;
	bh=Gg+EoPsEW5gzv+8dPtkA20rhKnMNGE7ZUSVxfGzFb9Q=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=bRZWddivtqSEiRtoQK6wI/OLVb7qphISnBDTv59pOPrhOO0vqWemWthmGTWDgvD6R3TjmQvnbisEZVAeoCM8cceXQmhyhWXg6JDPyPYLXB8lay0nDzQ9swdfFDB17upk0TXYNnhdqZdGMXkcoFT+U5nsbghENvu1Oh4fKRbdxdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EtufcZ70; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EtufcZ70"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F31TVd3867980;
	Tue, 15 Sep 2026 06:58:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=xqlFK0
	yj4P5BCqBGmrtySPTD4NnZjt1wjZ1E89dzkfY=; b=EtufcZ70jx85+h8jFPT9ln
	lH1CCStHETzeZCUEE2w8Sw/no84RTIbDODOZzanSJGgSoY8f/YX3w665tGe/Dpsi
	IhJhUWStslNEUC/TxdoTmxSMinjXM/iwrD0Jg5CkvQ9kyEPsZUossi1Rn2Jrdc2u
	kYimusJbd34qsmKBfn9aViR14zALaP3WrmBGsfV3J9v6Py9ExQS9D35TZYmugE5s
	9GXR6cCRAtF9Eim3CJevRjScdMmCThKzBAe/awPGD2cDnmp/FzcWjAxHB4pMiprd
	17y9mZ4GZGF/EfRhKCrU5Fb14lHoD4zSKUdCZNUnhBXsinb0T5XInFumcr7US3CQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf4wq1h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 06:58:51 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68F6ZHW13523880;
	Tue, 15 Sep 2026 06:58:51 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gpyxs884h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 06:58:50 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68F6wko628770658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Sep 2026 06:58:46 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA4CE2004E;
	Tue, 15 Sep 2026 06:58:46 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B4502004B;
	Tue, 15 Sep 2026 06:58:42 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.39.20.113])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Sep 2026 06:58:42 +0000 (GMT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] crypto: powerpc/vmx - clean up includes, metadata, and
 p8_init()
From: Sudhakar Kuppusamy <sudhakar@linux.ibm.com>
In-Reply-To: <20260914081500.65737-2-blum@kernel.org>
Date: Tue, 15 Sep 2026 12:28:28 +0530
Cc: =?utf-8?Q?Breno_Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Shrikanth Hegde <sshegde@linux.ibm.com>, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0974915C-5714-43CD-A04C-C4ABB534D7F2@linux.ibm.com>
References: <20260914081500.65737-2-blum@kernel.org>
To: Thorsten Blum <blum@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: ltkHWBcQvt7Z-jXyf4QksDgq_e7g8Oe3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDA5MiBTYWx0ZWRfX69HbRwDVIlM6
 PM9ur1Xj+RlxfvHL60W49Ixr11J8Zf0Nz5uCWCARTEs3ukwbeBW0ItYatfaZL9oQkz0NuK7jFig
 fpLjWxZjrscFz6fm7fE7Sb4QCnek1A0=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aa8ecac cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=a0PVYM7KTqR9pnvm3HMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Iqp_z3-sGWrdUCLWQJ0DLUmAA_Q6Xbc_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDA5MiBTYWx0ZWRfXy5uRAZuwpDoi
 NjLyuPQZoRGeWfZnBYsWEEW/gLuo9LJpFikobd3PVtCokKfGArGedZXVpwMUJJc+oe/IP21LbTH
 +PVYjdi2BJjtXtCkANRhlz7YjaV4RpsXKAqKF1NvqDxDSjTujCH0ui98CpjhIPHUAem/zdIrJi1
 1ao+Nn/OBIh216wCR9huhbO3LcLkwAs0ajnK1aQ8pl49BlXuUr5kSRsXojPwSxZVgIQuKP/t2lx
 jBcabbrZQkk8+4sFYOAlve+1kwVvTmjXHinSdZ59v5/JHOqN2+dNccv0hOP/fpwCNk7e8pWHZq1
 OzysmrPBO8ZSM9s1TGKcp3clSx9JTRSHLDoaVsK5Hblmf6GOTCdfMN6W90KWaNRc+mQRdwaUSZd
 Di21ARiZ4OswGpcEGtU0dlAZL0RjGF4lTvfE3NLCLdYr9/FUNb5dy9nSD7mSeDq7DBPOapHIv7D
 rjdM/zMeAMYAFZEhdaQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_01,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1011 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150092



> On 14 Sep 2026, at 1:45=E2=80=AFPM, Thorsten Blum <blum@kernel.org> =
wrote:
>=20
> In p8_init(), remove the goto statement and return ret directly.
>=20
> Remove any redundant includes, add a missing space in MODULE_AUTHOR(),
> and join the MODULE_DESCRIPTION() strings for better grepability.
>=20
> Also remove MODULE_VERSION(). It has never been updated and the kernel
> release better reflects the module version.
>=20
> Signed-off-by: Thorsten Blum <blum@kernel.org>


Reviewed-by: Sudhakar Kuppusamy <sudhakar@linux.ibm.com>

Thanks,
Sudhakar

> ---
> arch/powerpc/crypto/vmx.c | 14 +++-----------
> 1 file changed, 3 insertions(+), 11 deletions(-)
>=20
> diff --git a/arch/powerpc/crypto/vmx.c b/arch/powerpc/crypto/vmx.c
> index 08da5311dfdf..8abc4db8ee4e 100644
> --- a/arch/powerpc/crypto/vmx.c
> +++ b/arch/powerpc/crypto/vmx.c
> @@ -8,12 +8,7 @@
>  */
>=20
> #include <linux/module.h>
> -#include <linux/moduleparam.h>
> -#include <linux/types.h>
> -#include <linux/err.h>
> #include <linux/cpufeature.h>
> -#include <linux/crypto.h>
> -#include <asm/cputable.h>
> #include <crypto/internal/skcipher.h>
>=20
> #include "aesp8-ppc.h"
> @@ -24,7 +19,7 @@ static int __init p8_init(void)
>=20
> ret =3D crypto_register_skcipher(&p8_aes_cbc_alg);
> if (ret)
> - goto err;
> + return ret;
>=20
> ret =3D crypto_register_skcipher(&p8_aes_ctr_alg);
> if (ret)
> @@ -40,7 +35,6 @@ static int __init p8_init(void)
> crypto_unregister_skcipher(&p8_aes_ctr_alg);
> err_unregister_aes_cbc:
> crypto_unregister_skcipher(&p8_aes_cbc_alg);
> -err:
> return ret;
> }
>=20
> @@ -54,8 +48,6 @@ static void __exit p8_exit(void)
> module_cpu_feature_match(PPC_MODULE_FEATURE_VEC_CRYPTO, p8_init);
> module_exit(p8_exit);
>=20
> -MODULE_AUTHOR("Marcelo Cerri<mhcerri@br.ibm.com>");
> -MODULE_DESCRIPTION("IBM VMX cryptographic acceleration instructions "
> -   "support on Power 8");
> +MODULE_AUTHOR("Marcelo Cerri <mhcerri@br.ibm.com>");
> +MODULE_DESCRIPTION("IBM VMX cryptographic acceleration instructions =
support on Power 8");
> MODULE_LICENSE("GPL");
> -MODULE_VERSION("1.0.0");
>=20

