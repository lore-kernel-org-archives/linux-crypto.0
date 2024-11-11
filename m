Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8263514B962;
	Mon, 11 Nov 2024 12:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731327530; cv=none; b=h+WN5ujtof2i2V94c64W0+ffRdgFD2E5PwjguoQsgakZqNGer20JKbo7WDnECt8M5S5nEUpmUBo381Aa3fSdTiOhFYV97tPcGB2Pg0Y/otPajkNkmwfgle6wdgS/3FcTvhz/+cqcJK1FGR1PgAXBi9P8NOL/kIv9hczHfz39hw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731327530; c=relaxed/simple;
	bh=xWi8h8pnQLKp1si/maEHmvjXTcm+MxWEkbYF6yg/6q4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u78xbWcMHcuThmGAzj1Ah7HtR7Ala3uYerq2p3fslLPY3NKPlIEAPmQKm63YqBf2aG0hSufsANsy6PWkQiHJhLnEo0+chJF3xkbXtSBdSa7Uo3SldlPEHDIU3w2DdmTnBrCODS55388TNdUiAE1g2QSPM3NIeQSPUQEs7nPwVGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NxwQNA34; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NxwQNA34"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ABAetFo026004;
	Mon, 11 Nov 2024 12:13:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=tfSwEr
	RqOzH+WLQqQOP5a2HeWmI9Ap5QcDblX/8ZL40=; b=NxwQNA34er3hW9Avplujpg
	wWb/hAoOGIlHaEagSj5USb3lO+FmNAOWnbhSxW33HbpAfl2f7olNZd3mqM+uSlRi
	4oWTu0WH4+9nRDE5dflt2os+Bs5g3CPEYl5Sm78RBuBUq7saSPRdUiVwzHuf8NC+
	B8f8XCxq9YwwJHbTsaiJkEBAtIwbEwAb/abbHFVbKBsMYo1k3Cd7iwixxObEJlnp
	tiyxrOfC6QjJezV9jEdShvH2xYS6qajmcYFbH4TOSIV4HibMfgse5gEEsj2+kivr
	Mfym6gQ51G4TWvxMJJ05gB4steISI41QRtoE/Locs/nkTR5XVru5261CL7bKkaoQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42ugch09xp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Nov 2024 12:13:39 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AB7D3VG017527;
	Mon, 11 Nov 2024 12:13:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42tk2mt8aa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Nov 2024 12:13:39 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ABCDZFn62980496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Nov 2024 12:13:35 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F7FF2004D;
	Mon, 11 Nov 2024 12:13:35 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E62F82004B;
	Mon, 11 Nov 2024 12:13:34 +0000 (GMT)
Received: from [9.171.168.76] (unknown [9.171.168.76])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 11 Nov 2024 12:13:34 +0000 (GMT)
Message-ID: <ea93f581-795b-49c3-865a-76a00ee46c01@linux.ibm.com>
Date: Mon, 11 Nov 2024 13:13:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] s390/crypto: New s390 specific shash phmac
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
        dengler@linux.ibm.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, hca@linux.ibm.com
References: <20241107145521.424769-1-freude@linux.ibm.com>
 <20241107145521.424769-4-freude@linux.ibm.com>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <20241107145521.424769-4-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7bWJIjcyka6lDbZ6uqCodZURDayRi7iN
X-Proofpoint-GUID: 7bWJIjcyka6lDbZ6uqCodZURDayRi7iN
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1011 spamscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411110101

On 07.11.2024 15:55, Harald Freudenberger wrote:
> From: Holger Dengler <dengler@linux.ibm.com>
> 
> Add support for protected key hmac ("phmac") for s390 arch.
> 
> With the latest machine generation there is now support for
> protected key (that is a key wrapped by a master key stored
> in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
> for the s390 specific CPACF instruction kmac.
> 
> This patch adds support via 4 new shashes registered as
> phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).
> 
> Please note that as of now, there is no selftest enabled for
> these shashes, but the implementation has been tested with
> testcases via AF_ALG interface.
> 
> Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> ---
>  arch/s390/configs/debug_defconfig |   1 +
>  arch/s390/configs/defconfig       |   1 +
>  arch/s390/crypto/Makefile         |   1 +
>  arch/s390/crypto/phmac_s390.c     | 473 ++++++++++++++++++++++++++++++
>  drivers/crypto/Kconfig            |  12 +
>  5 files changed, 488 insertions(+)
>  create mode 100644 arch/s390/crypto/phmac_s390.c
> 
> diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
> index 6b602d972e91..a8ba72e7162d 100644
> --- a/arch/s390/configs/debug_defconfig
> +++ b/arch/s390/configs/debug_defconfig
> @@ -804,6 +804,7 @@ CONFIG_PKEY_EP11=m
>  CONFIG_PKEY_PCKMO=m
>  CONFIG_PKEY_UV=m
>  CONFIG_CRYPTO_PAES_S390=m
> +CONFIG_CRYPTO_PHMAC_S390=m
>  CONFIG_CRYPTO_DEV_VIRTIO=m
>  CONFIG_SYSTEM_BLACKLIST_KEYRING=y
>  CONFIG_CORDIC=m
> diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> index 7844b9f5851b..cd2e9c94b736 100644
> --- a/arch/s390/configs/defconfig
> +++ b/arch/s390/configs/defconfig
> @@ -790,6 +790,7 @@ CONFIG_PKEY_EP11=m
>  CONFIG_PKEY_PCKMO=m
>  CONFIG_PKEY_UV=m
>  CONFIG_CRYPTO_PAES_S390=m
> +CONFIG_CRYPTO_PHMAC_S390=m
>  CONFIG_CRYPTO_DEV_VIRTIO=m
>  CONFIG_SYSTEM_BLACKLIST_KEYRING=y
>  CONFIG_CORDIC=m
> diff --git a/arch/s390/crypto/Makefile b/arch/s390/crypto/Makefile
> index a0cb96937c3d..47637140b95c 100644
> --- a/arch/s390/crypto/Makefile
> +++ b/arch/s390/crypto/Makefile
> @@ -16,6 +16,7 @@ obj-$(CONFIG_S390_PRNG) += prng.o
>  obj-$(CONFIG_CRYPTO_GHASH_S390) += ghash_s390.o
>  obj-$(CONFIG_CRYPTO_CRC32_S390) += crc32-vx_s390.o
>  obj-$(CONFIG_CRYPTO_HMAC_S390) += hmac_s390.o
> +obj-$(CONFIG_CRYPTO_PHMAC_S390) += phmac_s390.o
>  obj-y += arch_random.o
>  
>  crc32-vx_s390-y := crc32-vx.o crc32le-vx.o crc32be-vx.o
> diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
> new file mode 100644
> index 000000000000..77a5244b2eb4
> --- /dev/null
> +++ b/arch/s390/crypto/phmac_s390.c
> @@ -0,0 +1,473 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright IBM Corp. 2024
> + *
> + * s390 specific HMAC support for protected keys.
> + */
> +
> +#define KMSG_COMPONENT	"phmac_s390"
> +#define pr_fmt(fmt)	KMSG_COMPONENT ": " fmt
> +
> +#include <asm/cpacf.h>
> +#include <asm/pkey.h>
> +#include <crypto/sha2.h>
> +#include <crypto/internal/hash.h>
> +#include <linux/cpufeature.h>
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include <linux/spinlock.h>
> +
> +/*
> + * KMAC param block layout for sha2 function codes:
> + * The layout of the param block for the KMAC instruction depends on the
> + * blocksize of the used hashing sha2-algorithm function codes. The param block
> + * contains the hash chaining value (cv), the input message bit-length (imbl)
> + * and the hmac-secret (key). To prevent code duplication, the sizes of all
> + * these are calculated based on the blocksize.
> + *
> + * param-block:
> + * +-------+
> + * | cv    |
> + * +-------+
> + * | imbl  |
> + * +-------+
> + * | key   |
> + * +-------+
> + *
> + * sizes:
> + * part | sh2-alg | calculation | size | type
> + * -----+---------+-------------+------+--------
> + * cv	| 224/256 | blocksize/2 |   32 |  u64[8]
> + *	| 384/512 |		|   64 | u128[8]
> + * imbl | 224/256 | blocksize/8 |    8 |     u64
> + *	| 384/512 |		|   16 |    u128
> + * key	| 224/256 | blocksize	|   96 |  u8[96]
> + *	| 384/512 |		|  160 | u8[160]
> + */
> +
> +#define MAX_DIGEST_SIZE		SHA512_DIGEST_SIZE
> +#define MAX_IMBL_SIZE		sizeof(u128)
> +#define MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
> +
> +#define SHA2_CV_SIZE(bs)	((bs) >> 1)
> +#define SHA2_IMBL_SIZE(bs)	((bs) >> 3)
> +
> +#define SHA2_IMBL_OFFSET(bs)	(SHA2_CV_SIZE(bs))
> +#define SHA2_KEY_OFFSET(bs)	(SHA2_CV_SIZE(bs) + SHA2_IMBL_SIZE(bs))
> +
> +#define PHMAC_SHA256_KEY_SIZE	(SHA256_BLOCK_SIZE + 32)
> +#define PHMAC_SHA512_KEY_SIZE	(SHA512_BLOCK_SIZE + 32)
> +#define PHMAC_MAX_KEY_SIZE	PHMAC_SHA512_KEY_SIZE
> +
> +struct phmac_protkey {
> +	u32 type;
> +	u32 len;
> +	u8 protkey[PHMAC_MAX_KEY_SIZE];
> +};
> +
> +struct s390_phmac_ctx {
> +	u8 *key;
> +	unsigned int keylen;
> +
> +	struct phmac_protkey pk;
> +	/* spinlock to atomic update pk */
> +	spinlock_t pk_lock;
> +};
> +

....


> +
> +static inline int s390_phmac_sha2_setkey(struct crypto_shash *tfm,
> +					 const u8 *key, unsigned int keylen)
> +{
> +	struct s390_phmac_ctx *tfm_ctx = crypto_shash_ctx(tfm);
> +
> +	if (tfm_ctx->keylen) {
> +		kfree_sensitive(tfm_ctx->key);
> +		tfm_ctx->key = NULL;
> +		tfm_ctx->keylen = 0;
> +	}
> +
> +	tfm_ctx->key = kmemdup(key, keylen, GFP_ATOMIC);
> +	if (!tfm_ctx->key)
> +		return -ENOMEM;
> +	tfm_ctx->keylen = keylen;
> +
> +	return 0;
> +}
> +
> +static int s390_phmac_sha2_init(struct shash_desc *desc)
> +{
> +	struct s390_phmac_ctx *tfm_ctx = crypto_shash_ctx(desc->tfm);
> +	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
> +	unsigned int bs = crypto_shash_blocksize(desc->tfm);
> +	int rc;
> +
> +	rc = phmac_convert_key(desc->tfm);

There is no need to perform the (possibly time consuming) key conversation at every init.
You only need to convert the key if a new key was set (via setkey function) before. 
Once converted, it can be reused by multiple init calls, if no other setkey is done in between.

One possibility to achieve this is to add a flag field into struct s390_phmac_ctx (i.e. new_key_set).
In the setkey function set new_key_set to 1 once te key has been updated in the context. 
In the init function, if new_key_set is != 0, then convert the key and set new_key_set to 0. 
Any subsequent init calls (with no setkey in-between) will see new_key_set == 0 and thus will not convert the key again, but reuse the already converted key.

If the key hasn't changed it is simply unnecessary to perform the (possibly time consuming) key conversation again and again.

This improves performance for use cases where a tfm is allocated, a key is set once, and then multiple sequences of init/update/final are performed to calculate the HMACs of different pieces of data but with the same key. This is for example what dm-integrity does, it does init/update/final for every sector, but the key is set only once at the very beginning. 

> +	if (rc)
> +		goto out;
> +
> +	spin_lock_bh(&tfm_ctx->pk_lock);
> +	memcpy(ctx->param + SHA2_KEY_OFFSET(bs),
> +	       tfm_ctx->pk.protkey, tfm_ctx->pk.len);
> +	spin_unlock_bh(&tfm_ctx->pk_lock);
> +
> +	ctx->buflen = 0;
> +	ctx->gr0.reg = 0;
> +
> +	switch (crypto_shash_digestsize(desc->tfm)) {
> +	case SHA224_DIGEST_SIZE:
> +		ctx->gr0.fc = CPACF_KMAC_PHMAC_SHA_224;
> +		break;
> +	case SHA256_DIGEST_SIZE:
> +		ctx->gr0.fc = CPACF_KMAC_PHMAC_SHA_256;
> +		break;
> +	case SHA384_DIGEST_SIZE:
> +		ctx->gr0.fc = CPACF_KMAC_PHMAC_SHA_384;
> +		break;
> +	case SHA512_DIGEST_SIZE:
> +		ctx->gr0.fc = CPACF_KMAC_PHMAC_SHA_512;
> +		break;
> +	default:
> +		rc = -EINVAL;
> +	}
> +
> +out:
> +	pr_debug("rc=%d\n", rc);
> +	return rc;
> +}
> +
>
-- 
Ingo Franzki
eMail: ifranzki@linux.ibm.com  
Tel: ++49 (0)7031-16-4648
Linux on IBM Z Development, Schoenaicher Str. 220, 71032 Boeblingen, Germany

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM DATA Privacy Statement: https://www.ibm.com/privacy/us/en/
