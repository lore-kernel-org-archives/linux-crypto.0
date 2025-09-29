Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6CF3016EC;
	Mon, 29 Sep 2025 11:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759146281; cv=none; b=Iw61S4tJ8Zl2EqxsMtDDZQV/7t3iPNcSuv9CA6sFUM0GmnjzphwxoHuJCGW4c3+5yOghALvlSharQvhBqafeNuq4w1zJu3S3sCc2tTJcq1s6iP6tDjlyPuuy/2OJjYLId6hghiFP65VBEhVsoNo3RnuStqn/cHwDwgFTU6OwWCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759146281; c=relaxed/simple;
	bh=C1ygtBPEqFsy/Q8p5AKavsu3/YI1AB1lWX+iu/u/QPI=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=aNJ5wA7o0c0ARKYvxskBBPwV3Hcs3XosCfD+zWTr9e3pcZsO30dADlpsB2ZMwCUL9hIp/5wto8EZOUeRPwIWRc08W/m4AMNOPIwMREe2gy3AqMMWEdualwVdIc/msrJKX06ShxmgCnvHuNkJ5n4phd8+8iSxPUGFDMP0u4PQXBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NKRukHif; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NKRukHif"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58SMK6EX022485;
	Mon, 29 Sep 2025 11:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=hFeN9jTOUjBxVBfzmkKkge1w/Iv5GqKPsgbt8sCqfo4=; b=NKRukHifdj1t
	t/vIt3waWrr7JyRfEd7DJhH+wpLf1LuE81qbnrmhBphIzmRN7jZUnNI1MgRgv2Kt
	Fci/ZL9NlrWEv//APfatVc39W0GqaGTexFgMTZEpjpc8Gwqm2YcgW/6+hOrGHfac
	Faag+H1JI7+jkB2qC8zT/LyTZtzKXp4mCPU6369rfqtjKkB02xBCvILRKaRLyPfj
	PG7c011FN2PdZ6WzqlUaZv6ZSIspweZO5ADDkstevNGpqILH6NYlEnGIgv+Sh7ZA
	K6U/6WDQARdivAZR+sM7+x58bUuVCEvp/CyiZDFZSQVF1S3vJ7+rIQuP2aw/22PU
	ZGBNmvPOpQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7n7hw3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Sep 2025 11:39:30 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58T7jAvp020508;
	Mon, 29 Sep 2025 11:39:29 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49et8rx0h4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Sep 2025 11:39:29 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58TBdH1j29295210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 11:39:17 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4457958052;
	Mon, 29 Sep 2025 11:39:28 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B993F58056;
	Mon, 29 Sep 2025 11:39:27 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 29 Sep 2025 11:39:27 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 29 Sep 2025 13:39:27 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld"
 <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu
 <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Holger Dengler
 <dengler@linux.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 1/8] s390/sha3: Rename conflicting functions
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20250926141959.1272455-2-dhowells@redhat.com>
References: <20250926141959.1272455-1-dhowells@redhat.com>
 <20250926141959.1272455-2-dhowells@redhat.com>
Message-ID: <88913f4419f2f7cd29b57539c3726251@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2l9zG-XCITD7Ju6YkV2wUG6m2cFz_gPL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfXzLK+mcl8g2dl
 WAKtYLQstbEsmze6p/QHc/FgrDB+MhGkt9E6HR8IYzsmrtMPqDcRxSW4dIHbavjn8U3KzfNQXgr
 +Ke55XqQaSRTpgHBSkugmuBIGnHGqTiSAR8CsiYmVqKoojg17UpgJrmhqTB33xyBjIYyUVb90Oe
 i8/rrhq7yELYcXraD3TeWrSXwmvBafh1Mk0arCx5sit1ADjjYnO7RUgK6UpZnKOrEDt6pGyfapY
 jb/VI6XbWgA1cL5SrkBJvPwdqk4uBgkOC1rMxV2+2EL2NzU/tdmhVeG57/jirYronziC1Lc5mXO
 eLO0iSDyuWqfzPKjLwZ2SiRpZwAyfY9dY1LfeFdcu0UrsNKBt3B1dXR5Jdbn4I4/wrQrPzQdWwH
 oFpbiBHK9JwcGulAh+ehnOdsuwuyfQ==
X-Proofpoint-GUID: 2l9zG-XCITD7Ju6YkV2wUG6m2cFz_gPL
X-Authority-Analysis: v=2.4 cv=T7qBjvKQ c=1 sm=1 tr=0 ts=68da6ff2 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
 a=UGG5zPGqAAAA:8 a=VnNF1IyMAAAA:8 a=FNyBlpCuAAAA:8 a=ViNXwmFP9Bwyp9zFovgA:9
 a=CjuIK1q_8ugA:10 a=17ibUXfGiVyGqR_YBevW:22 a=RlW-AWeGUCXs_Nkyno-6:22
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-29_04,2025-09-29_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 clxscore=1011 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025

On 2025-09-26 16:19, David Howells wrote:
> Rename the s390 sha3_* functions to have an "s390_" prefix to avoid
> conflict with generic code.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Eric Biggers <ebiggers@kernel.org>
> cc: Jason A. Donenfeld <Jason@zx2c4.com>
> cc: Ard Biesheuvel <ardb@kernel.org>
> cc: Harald Freudenberger <freude@linux.ibm.com>
> cc: Holger Dengler <dengler@linux.ibm.com>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: Stephan Mueller <smueller@chronox.de>
> cc: linux-crypto@vger.kernel.org
> cc: linux-s390@vger.kernel.org
> ---
>  arch/s390/crypto/sha3_256_s390.c | 26 +++++++++++++-------------
>  arch/s390/crypto/sha3_512_s390.c | 26 +++++++++++++-------------
>  2 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/s390/crypto/sha3_256_s390.c 
> b/arch/s390/crypto/sha3_256_s390.c
> index 03bb4f4bab70..fd5ecae60a57 100644
> --- a/arch/s390/crypto/sha3_256_s390.c
> +++ b/arch/s390/crypto/sha3_256_s390.c
> @@ -19,7 +19,7 @@
> 
>  #include "sha.h"
> 
> -static int sha3_256_init(struct shash_desc *desc)
> +static int s390_sha3_256_init(struct shash_desc *desc)
>  {
>  	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
> 
> @@ -32,7 +32,7 @@ static int sha3_256_init(struct shash_desc *desc)
>  	return 0;
>  }
> 
> -static int sha3_256_export(struct shash_desc *desc, void *out)
> +static int s390_sha3_256_export(struct shash_desc *desc, void *out)
>  {
>  	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
>  	union {
> @@ -50,7 +50,7 @@ static int sha3_256_export(struct shash_desc *desc, 
> void *out)
>  	return 0;
>  }
> 
> -static int sha3_256_import(struct shash_desc *desc, const void *in)
> +static int s390_sha3_256_import(struct shash_desc *desc, const void 
> *in)
>  {
>  	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
>  	union {
> @@ -68,22 +68,22 @@ static int sha3_256_import(struct shash_desc
> *desc, const void *in)
>  	return 0;
>  }
> 
> -static int sha3_224_import(struct shash_desc *desc, const void *in)
> +static int s390_sha3_224_import(struct shash_desc *desc, const void 
> *in)
>  {
>  	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
> 
> -	sha3_256_import(desc, in);
> +	s390_sha3_256_import(desc, in);
>  	sctx->func = CPACF_KIMD_SHA3_224;
>  	return 0;
>  }
> 
>  static struct shash_alg sha3_256_alg = {
>  	.digestsize	=	SHA3_256_DIGEST_SIZE,	   /* = 32 */
> -	.init		=	sha3_256_init,
> +	.init		=	s390_sha3_256_init,
>  	.update		=	s390_sha_update_blocks,
>  	.finup		=	s390_sha_finup,
> -	.export		=	sha3_256_export,
> -	.import		=	sha3_256_import,
> +	.export		=	s390_sha3_256_export,
> +	.import		=	s390_sha3_256_import,
>  	.descsize	=	S390_SHA_CTX_SIZE,
>  	.statesize	=	SHA3_STATE_SIZE,
>  	.base		=	{
> @@ -96,22 +96,22 @@ static struct shash_alg sha3_256_alg = {
>  	}
>  };
> 
> -static int sha3_224_init(struct shash_desc *desc)
> +static int s390_sha3_224_init(struct shash_desc *desc)
>  {
>  	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
> 
> -	sha3_256_init(desc);
> +	s390_sha3_256_init(desc);
>  	sctx->func = CPACF_KIMD_SHA3_224;
>  	return 0;
>  }
> 
>  static struct shash_alg sha3_224_alg = {
>  	.digestsize	=	SHA3_224_DIGEST_SIZE,
> -	.init		=	sha3_224_init,
> +	.init		=	s390_sha3_224_init,
>  	.update		=	s390_sha_update_blocks,
>  	.finup		=	s390_sha_finup,
> -	.export		=	sha3_256_export, /* same as for 256 */
> -	.import		=	sha3_224_import, /* function code different! */
> +	.export		=	s390_sha3_256_export, /* same as for 256 */
> +	.import		=	s390_sha3_224_import, /* function code different! */
>  	.descsize	=	S390_SHA_CTX_SIZE,
>  	.statesize	=	SHA3_STATE_SIZE,
>  	.base		=	{
> diff --git a/arch/s390/crypto/sha3_512_s390.c 
> b/arch/s390/crypto/sha3_512_s390.c
> index a5c9690eecb1..f4b52a3a0433 100644
> --- a/arch/s390/crypto/sha3_512_s390.c
> +++ b/arch/s390/crypto/sha3_512_s390.c
> @@ -18,7 +18,7 @@
> 
>  #include "sha.h"
> 
> -static int sha3_512_init(struct shash_desc *desc)
> +static int s390_sha3_512_init(struct shash_desc *desc)
>  {
>  	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
> 
> @@ -31,7 +31,7 @@ static int sha3_512_init(struct shash_desc *desc)
>  	return 0;
>  }
> 
> -static int sha3_512_export(struct shash_desc *desc, void *out)
> +static int s390_sha3_512_export(struct shash_desc *desc, void *out)
>  {
>  	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
>  	union {
> @@ -49,7 +49,7 @@ static int sha3_512_export(struct shash_desc *desc, 
> void *out)
>  	return 0;
>  }
> 
> -static int sha3_512_import(struct shash_desc *desc, const void *in)
> +static int s390_sha3_512_import(struct shash_desc *desc, const void 
> *in)
>  {
>  	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
>  	union {
> @@ -67,22 +67,22 @@ static int sha3_512_import(struct shash_desc
> *desc, const void *in)
>  	return 0;
>  }
> 
> -static int sha3_384_import(struct shash_desc *desc, const void *in)
> +static int s390_sha3_384_import(struct shash_desc *desc, const void 
> *in)
>  {
>  	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
> 
> -	sha3_512_import(desc, in);
> +	s390_sha3_512_import(desc, in);
>  	sctx->func = CPACF_KIMD_SHA3_384;
>  	return 0;
>  }
> 
>  static struct shash_alg sha3_512_alg = {
>  	.digestsize	=	SHA3_512_DIGEST_SIZE,
> -	.init		=	sha3_512_init,
> +	.init		=	s390_sha3_512_init,
>  	.update		=	s390_sha_update_blocks,
>  	.finup		=	s390_sha_finup,
> -	.export		=	sha3_512_export,
> -	.import		=	sha3_512_import,
> +	.export		=	s390_sha3_512_export,
> +	.import		=	s390_sha3_512_import,
>  	.descsize	=	S390_SHA_CTX_SIZE,
>  	.statesize	=	SHA3_STATE_SIZE,
>  	.base		=	{
> @@ -97,22 +97,22 @@ static struct shash_alg sha3_512_alg = {
> 
>  MODULE_ALIAS_CRYPTO("sha3-512");
> 
> -static int sha3_384_init(struct shash_desc *desc)
> +static int s390_sha3_384_init(struct shash_desc *desc)
>  {
>  	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
> 
> -	sha3_512_init(desc);
> +	s390_sha3_512_init(desc);
>  	sctx->func = CPACF_KIMD_SHA3_384;
>  	return 0;
>  }
> 
>  static struct shash_alg sha3_384_alg = {
>  	.digestsize	=	SHA3_384_DIGEST_SIZE,
> -	.init		=	sha3_384_init,
> +	.init		=	s390_sha3_384_init,
>  	.update		=	s390_sha_update_blocks,
>  	.finup		=	s390_sha_finup,
> -	.export		=	sha3_512_export, /* same as for 512 */
> -	.import		=	sha3_384_import, /* function code different! */
> +	.export		=	s390_sha3_512_export, /* same as for 512 */
> +	.import		=	s390_sha3_384_import, /* function code different! */
>  	.descsize	=	S390_SHA_CTX_SIZE,
>  	.statesize	=	SHA3_STATE_SIZE,
>  	.base		=	{

Acked-By: Harald Freudenberger <freude@linux.ibm.com>
