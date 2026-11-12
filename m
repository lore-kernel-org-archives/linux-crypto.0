Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794503241;
	b=ouUT9UqmiGT6OFS2i+KX0IviY0G/LuIU/OGguWYAC36GDUM3/CiNvzO0mADnvoVI39dj
	 aeJApahzl7H8VBsXkqjQQWQbtk3LUwwBAdJlAfAa+3nqmpWXba+GZyZKfo+lEKaE0IVeS
	 QVYD1eKbKBiiGy9y458+Ma9jbSlVD+VJRUagrC6nd4QjOTnws6O48jETBr6W66c1T20gs
	 GdZC7pFecYFi7Fb5Qftx9y4A7laiVsYhDoYY2c+uZ/tbrE/XEk75p+c5AHrzmyOI0ZVGY
	 0bVZZUzCdweRMt/QV6zl1S0yyt1C67s+D+lToBmU+lX8vaVyxftA6gb9e/Egqu4n66A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794503241;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=d8OCFrT9adZJNKw7+Du7M717kyOB2h1aMx6G8juaeWU=;
	b=IMzoKopPqQ0YU0xWx6tJEgA7zELimNEJO2WtHA2mArhDXMN/SqxVXgQAOhPkt/U+EBE8
	 YMMLdKiKpOQwzS7y+6AKs7KebnfceYPkhLpR780tTw94YsV/arPmwvw36IdvvZvjXWLaz
	 TqiwxO1ifIKC0wqudUSAcpLvCpJ4NHZW19Bva2T9HrrJoNp6O+R8dG3EGxkBful70w3sl
	 37APgOyBeV97hN/KaMSAtr1dTxfun1R3t9wQ8PttRmC7sD+TJqa8c+76mjB0iiOsOdGI8
	 KbX6iCZd1P3itE8Ldz0l3C5mvDMaEJNZCosREjeH1MB6TAsAsqOanhNkYYShEjelQew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=eTa9ot1I;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2927606A321;
	Thu, 12 Nov 2026 17:07:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2927606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=eTa9ot1I
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACFiKI4182972;
	Thu, 12 Nov 2026 17:07:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=d8OCFr
	T9adZJNKw7+Du7M717kyOB2h1aMx6G8juaeWU=; b=eTa9ot1I8aSOJaMZKyleP4
	VSth/L40IG+Rxvt7yN7/UUhdgrmKKU1t3Lwj8XOtCx9SdC37qlQETSVeXLuQ1pa/
	Mtb4UyyJTlsiupyMY0fLNaZlOQ664Yy6haBS4nzr2HQhMKQb26OajqTFvnDv3rTd
	sc+ZFXz3BDpYg1ZJ3q7qRDzvyu1CB7Xf6kHhGEqLHN1QmqNKctkdbDNL7oNkfx/G
	aE1TRwp18b6GDp7Szuvx/Lz3Xy5lfpwR3+jgF2x7tv2pfoPLd4Ta76zeshQxBVOs
	JigPjXseaENaej4XrjQ+GhAoxaSb0pn4iB/5PvqQYOut0igF6nVs8yiFyMbtePVQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hssdm05x1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 17:07:00 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACFr1iC952596;
	Thu, 12 Nov 2026 17:07:00 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hvkq0x6ew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 17:07:00 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ACH6xeP21299816
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Nov 2026 17:06:59 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D79B5805C;
	Thu, 12 Nov 2026 17:06:59 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A02AB5805A;
	Thu, 12 Nov 2026 17:06:58 +0000 (GMT)
Received: from [9.47.158.153] (unknown [9.47.158.153])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Nov 2026 17:06:58 +0000 (GMT)
Message-ID: <e852580d-9e18-4733-a431-2db8c5f9c2a3@linux.ibm.com>
Date: Thu, 12 Nov 2026 12:06:57 -0500
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
Subject: Re: [PATCH] crypto: ecdsa - Reject non-DER X9.62 signatures
To: florian.bauckholt@cispa.de, Lukas Wunner <lukas@wunner.de>,
        Ignat Korchagin <ignat@linux.win>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20261112-ecdsa-x962-der-v1-1-36b24c5f5e11@cispa.de>
Content-Language: en-US
From: Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20261112-ecdsa-x962-der-v1-1-36b24c5f5e11@cispa.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=POqaavqC c=1 sm=1 tr=0 ts=6af5f235 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=TCxdwlj9iro683_zv34A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA2NiBTYWx0ZWRfX7XBQJFgelxNU
 sIpObdvwuRWGkUzYerrwmvm8OL51ISop7fYXoBJOUQdsaNOzBjLiQdCgFzya/RXEF14kLZxgeAV
 dL9g16WmMQzWzYJq1cpUHgOcKvjJHUO+5YYnqmr+keiPNSQjw+LwMhpqfb6EsmAo00UgCvCNUGd
 +NbhCpU6irdn6+6nBTDvO+5RfV1tvyDogQzdkFQOkw9AdFhbgs/Jo4m0w1bMoS+iUWV4+YXTeJX
 57+3eaoeMwF3+KVV2JYm7XadSz3FDQEUbzgOcfESq15Zs68wW7fCW7GnQqItRFJQ1BPSVrpYurN
 pjWXMbGwhyhvDsfpl5mNb6/41Z+marn7OQ9ATtxqjE0L8wBpyOlsizQh71zuqo/Ewm1vnxvZ42n
 cPK71U8LE3lfemQ47y/RcftuPgSnVBaJ5l5IJ8xDFWlV5nydC/CPjTp9PdQCekjx4CvmqrGDkhP
 TOyrNtYPgQltMqvMF5A==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA2NiBTYWx0ZWRfXy5SgFgMpkF3e
 GGxF9CsDnkGm9vq7ofKNcl4yWREjBnoL1w3OD/IXjKZH6MKyZKBam+Aivw6TDtr46rTEGN4K2N4
 x0RuPR910m2/A/NbYXfkNPl0sjlsqDg=
X-Proofpoint-ORIG-GUID: RXDSoLVPK73RCWasd3ZZ8x2QoQintnkf
X-Proofpoint-GUID: RXDSoLVPK73RCWasd3ZZ8x2QoQintnkf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_02,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120066



On 11/12/26 5:47 AM, Florian Bauckholt via B4 Relay wrote:
> From: Florian Bauckholt <florian.bauckholt@cispa.de>
> 
> The x962(ecdsa-nist-*) template decodes Ecdsa-Sig-Value with the
> generic BER decoder, and ecdsa_get_signature_rs() only strips one
> leading zero byte without looking at the INTEGER's sign or encoding.
> As a result the following encodings of a valid signature are accepted
> as well:
> 
>   - a SEQUENCE tag without the constructed bit (0x10 instead of 0x30),
>     as the decoder ignores that bit when matching a constructed tag
>   - non-minimal length encodings of the SEQUENCE, r or s (long form
>     where the short form fits, or padded with zero bytes)
>   - indefinite length for the SEQUENCE
>   - data following the SEQUENCE (the decoder does not check that the
>     whole buffer was consumed)
>   - r or s with the most significant bit set but without the leading
>     zero byte, i.e. a negative INTEGER read as positive
>   - r or s with a superfluous leading zero byte
> 

I have a user-space test suite here:
https://github.com/stefanberger/eckey-testing

It tries to load openssl-generated self-signed certs into the kernel and 
this fails now:

$ ./test-ecc-kernel-keys.sh
Testing with curves:  prime256v1 secp384r1 secp521r1
Testing with hashes:  sha224 sha256 sha384 sha512 sha3-256 sha3-384 sha3-512
Good: curve: prime256v1 hash:   sha224 keyid: 927415098 
keyctl_pkey_verify: Invalid argument



> RFC 3279 section 2.2.3 and SEC 1 section C.5 require Ecdsa-Sig-Value to
> be DER-encoded, so all of these are invalid and should be rejected.
> 
> This is a behaviour change for every user of the x962 template (X.509
> certificates, module and IMA signatures, KEYCTL_PKEY_VERIFY): signatures
> that are valid ECDSA signatures but are not DER-encoded used to verify
> and are now rejected with -EINVAL. The p1363 template is not affected.
> 
> Add a test vector for each of these encodings, taken or derived from
> Wycheproof's secp256r1/SHA-256 test vectors.
> 
> Found by differential testing against other ECDSA implementations.
> 
> Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature verification")
> Signed-off-by: Florian Bauckholt <florian.bauckholt@cispa.de>
> ---
> Hi,
> 
> I recently tried out differential testing for crypto libraries and ran
> into a DER-vs-BER discrepancy after hooking up Linux's x962
> implementation via UML. I don't see a security impact: the signature
> must still be valid for the key, only its encoding is malleable. But all
> major implementations reject BER encodings for x962.
> 
> The patch works around the fact that the ASN.1 input is parsed by a
> generic BER parser by checking each potential difference between DER and
> BER. This is the minimal change, but a more generic "strict DER parser"
> might be a better solution imo. Should the ASN.1 decoder instead learn
> an opt-in strict mode?
> 
> One dependency: since commit cb481e59ea6c ("KEYS: fix overflow in
> keyctl_pkey_params_get_2()") KEYCTL_PKEY_VERIFY passes max_sig_size
> instead of the caller's signature length, so the signature handed to
> the x962 template is followed by trailing bytes whenever it is shorter
> than the maximum. That only works today because the BER decoder ignores
> trailing data. With this patch such signatures are rejected via keyctl.
> The fix for that is patch 1/2 of the series below, posted separately to
> the keyrings list, and should go in first:
> 
>    https://lore.kernel.org/r/20261111-keyctl-pkey-fixes-v1-0-934ebaa267a7@cispa.de
> 
> I did not add Cc: stable since this is a behaviour change. If you would
> like it backported, note that v7.2 and later need the keyctl fix first.
> 
> Tool-generated content: I used LLMs (Claude) to implement and iterate on
> the patch. I'm fairly confident the fix is complete because it passes
> differential testing.
> 
> Thanks!
> ---
>   crypto/ecdsa-x962.c |  36 ++++++++++++
>   crypto/testmgr.h    | 161 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 197 insertions(+)
> 
> diff --git a/crypto/ecdsa-x962.c b/crypto/ecdsa-x962.c
> index ee71594d10a0..69e932bbd551 100644
> --- a/crypto/ecdsa-x962.c
> +++ b/crypto/ecdsa-x962.c
> @@ -6,6 +6,7 @@
>    * Copyright (c) 2024 Intel Corporation
>    */
>   
> +#include <linux/asn1.h>
>   #include <linux/asn1_decoder.h>
>   #include <linux/err.h>
>   #include <linux/module.h>
> @@ -36,6 +37,20 @@ static int ecdsa_get_signature_rs(u64 *dest, size_t hdrlen, unsigned char tag,
>   	if (!value || !vlen || vlen > bufsize + 1)
>   		return -EINVAL;
>   
> +	/*
> +	 * The signature must be DER-encoded (RFC 3279 section 2.2.3, SEC 1
> +	 * section C.5): an INTEGER with a short-form length (vlen never
> +	 * exceeds 127 bytes) and minimal two's complement contents that
> +	 * encode a non-negative value (X.690 sections 8.3.2 and 10.1).  The
> +	 * decoder has already matched the primitive INTEGER tag exactly.
> +	 */
> +	if (hdrlen != 2)
> +		return -EINVAL;
> +	if (d[0] & 0x80)
> +		return -EINVAL;
> +	if (vlen > 1 && d[0] == 0 && !(d[1] & 0x80))
> +		return -EINVAL;
> +
>   	/*
>   	 * vlen may be 1 byte larger than bufsize due to a leading zero byte
>   	 * (necessary if the most significant bit of the integer is set).
> @@ -73,6 +88,24 @@ int ecdsa_get_signature_s(void *context, size_t hdrlen, unsigned char tag,
>   				      sig_ctx->ndigits);
>   }
>   
> +/*
> + * The BER decoder accepts a SEQUENCE tag without the constructed bit,
> + * long-form and indefinite lengths, and ignores data following the SEQUENCE.
> + * DER permits only the constructed tag, the shortest length encoding and
> + * nothing after the SEQUENCE.  The decoder has already checked that r and s
> + * fill a definite-length SEQUENCE exactly.
> + */
> +static bool ecdsa_x962_seq_is_der(const u8 *src, unsigned int slen)
> +{
> +	if (src[0] != (ASN1_CONS_BIT | ASN1_SEQ))
> +		return false;
> +
> +	if (src[1] < 0x80)
> +		return slen == 2 + src[1];
> +
> +	return src[1] == 0x81 && src[2] >= 0x80 && slen == 3 + src[2];
> +}
> +
>   static int ecdsa_x962_verify(struct crypto_sig *tfm,
>   			     const void *src, unsigned int slen,
>   			     const void *digest, unsigned int dlen)
> @@ -88,6 +121,9 @@ static int ecdsa_x962_verify(struct crypto_sig *tfm,
>   	if (err < 0)
>   		return err;
>   
> +	if (!ecdsa_x962_seq_is_der(src, slen))
> +		return -EINVAL;
> +
>   	return crypto_sig_verify(ctx->child, &sig_ctx.sig, sizeof(sig_ctx.sig),
>   				 digest, dlen);
>   }
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index 0ee15a8fae27..635032615212 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -1490,6 +1490,167 @@ static const struct sig_testvec x962_ecdsa_nist_p256_tv_template[] = {
>   	.verify_error = -EKEYREJECTED,
>   	.public_key_vec = true,
>   	},
> +	/* Wycheproof secp256r1/SHA-256 tcId 6: negative s. */
> +	{
> +	.key =
> +	"\x04\x29\x27\xb1\x05\x12\xba\xe3\xed\xdc\xfe\x46\x78\x28\x12\x8b"
> +	"\xad\x29\x03\x26\x99\x19\xf7\x08\x60\x69\xc8\xc4\xdf\x6c\x73\x28"
> +	"\x38\xc7\x78\x79\x64\xea\xac\x00\xe5\x92\x1f\xb1\x49\x8a\x60\xf4"
> +	"\x60\x67\x66\xb3\xd9\x68\x50\x01\x55\x8d\x1a\x97\x4e\x73\x41\x51"
> +	"\x3e",
> +	.key_len = 65,
> +	.m =
> +	"\xbb\x5a\x52\xf4\x2f\x9c\x92\x61\xed\x43\x61\xf5\x94\x22\xa1\xe3"
> +	"\x00\x36\xe7\xc3\x2b\x27\x0c\x88\x07\xa4\x19\xfe\xca\x60\x50\x23",
> +	.m_size = 32,
> +	.c =
> +	"\x30\x44\x02\x20\x2b\xa3\xa8\xbe\x6b\x94\xd5\xec\x80\xa6\xd9\xd1"
> +	"\x19\x0a\x43\x6e\xff\xe5\x0d\x85\xa1\xee\xe8\x59\xb8\xcc\x6a\xf9"
> +	"\xbd\x5c\x2e\x18\x02\x20\xb3\x29\xf4\x79\xa2\xbb\xd0\xa5\xc3\x84"
> +	"\xee\x14\x93\xb1\xf5\x18\x6a\x87\x13\x9c\xac\x5d\xf4\x08\x7c\x13"
> +	"\x4b\x49\x15\x68\x47\xdb",
> +	.c_size = 70,
> +	.verify_error = -EINVAL,
> +	.public_key_vec = true,
> +	},
> +	/* Wycheproof secp256r1/SHA-256 tcId 8: long-form length. */
> +	{
> +	.key =
> +	"\x04\x29\x27\xb1\x05\x12\xba\xe3\xed\xdc\xfe\x46\x78\x28\x12\x8b"
> +	"\xad\x29\x03\x26\x99\x19\xf7\x08\x60\x69\xc8\xc4\xdf\x6c\x73\x28"
> +	"\x38\xc7\x78\x79\x64\xea\xac\x00\xe5\x92\x1f\xb1\x49\x8a\x60\xf4"
> +	"\x60\x67\x66\xb3\xd9\x68\x50\x01\x55\x8d\x1a\x97\x4e\x73\x41\x51"
> +	"\x3e",
> +	.key_len = 65,
> +	.m =
> +	"\xbb\x5a\x52\xf4\x2f\x9c\x92\x61\xed\x43\x61\xf5\x94\x22\xa1\xe3"
> +	"\x00\x36\xe7\xc3\x2b\x27\x0c\x88\x07\xa4\x19\xfe\xca\x60\x50\x23",
> +	.m_size = 32,
> +	.c =
> +	"\x30\x81\x45\x02\x20\x2b\xa3\xa8\xbe\x6b\x94\xd5\xec\x80\xa6\xd9"
> +	"\xd1\x19\x0a\x43\x6e\xff\xe5\x0d\x85\xa1\xee\xe8\x59\xb8\xcc\x6a"
> +	"\xf9\xbd\x5c\x2e\x18\x02\x21\x00\xb3\x29\xf4\x79\xa2\xbb\xd0\xa5"
> +	"\xc3\x84\xee\x14\x93\xb1\xf5\x18\x6a\x87\x13\x9c\xac\x5d\xf4\x08"
> +	"\x7c\x13\x4b\x49\x15\x68\x47\xdb",
> +	.c_size = 72,
> +	.verify_error = -EINVAL,
> +	.public_key_vec = true,
> +	},
> +	/* Wycheproof secp256r1/SHA-256 tcId 25: data after the SEQUENCE. */
> +	{
> +	.key =
> +	"\x04\x29\x27\xb1\x05\x12\xba\xe3\xed\xdc\xfe\x46\x78\x28\x12\x8b"
> +	"\xad\x29\x03\x26\x99\x19\xf7\x08\x60\x69\xc8\xc4\xdf\x6c\x73\x28"
> +	"\x38\xc7\x78\x79\x64\xea\xac\x00\xe5\x92\x1f\xb1\x49\x8a\x60\xf4"
> +	"\x60\x67\x66\xb3\xd9\x68\x50\x01\x55\x8d\x1a\x97\x4e\x73\x41\x51"
> +	"\x3e",
> +	.key_len = 65,
> +	.m =
> +	"\xbb\x5a\x52\xf4\x2f\x9c\x92\x61\xed\x43\x61\xf5\x94\x22\xa1\xe3"
> +	"\x00\x36\xe7\xc3\x2b\x27\x0c\x88\x07\xa4\x19\xfe\xca\x60\x50\x23",
> +	.m_size = 32,
> +	.c =
> +	"\x30\x45\x02\x20\x2b\xa3\xa8\xbe\x6b\x94\xd5\xec\x80\xa6\xd9\xd1"
> +	"\x19\x0a\x43\x6e\xff\xe5\x0d\x85\xa1\xee\xe8\x59\xb8\xcc\x6a\xf9"
> +	"\xbd\x5c\x2e\x18\x02\x21\x00\xb3\x29\xf4\x79\xa2\xbb\xd0\xa5\xc3"
> +	"\x84\xee\x14\x93\xb1\xf5\x18\x6a\x87\x13\x9c\xac\x5d\xf4\x08\x7c"
> +	"\x13\x4b\x49\x15\x68\x47\xdb\x00\x00",
> +	.c_size = 73,
> +	.verify_error = -EINVAL,
> +	.public_key_vec = true,
> +	},
> +	/* Wycheproof secp256r1/SHA-256 tcId 48: indefinite length. */
> +	{
> +	.key =
> +	"\x04\x29\x27\xb1\x05\x12\xba\xe3\xed\xdc\xfe\x46\x78\x28\x12\x8b"
> +	"\xad\x29\x03\x26\x99\x19\xf7\x08\x60\x69\xc8\xc4\xdf\x6c\x73\x28"
> +	"\x38\xc7\x78\x79\x64\xea\xac\x00\xe5\x92\x1f\xb1\x49\x8a\x60\xf4"
> +	"\x60\x67\x66\xb3\xd9\x68\x50\x01\x55\x8d\x1a\x97\x4e\x73\x41\x51"
> +	"\x3e",
> +	.key_len = 65,
> +	.m =
> +	"\xbb\x5a\x52\xf4\x2f\x9c\x92\x61\xed\x43\x61\xf5\x94\x22\xa1\xe3"
> +	"\x00\x36\xe7\xc3\x2b\x27\x0c\x88\x07\xa4\x19\xfe\xca\x60\x50\x23",
> +	.m_size = 32,
> +	.c =
> +	"\x30\x80\x02\x20\x2b\xa3\xa8\xbe\x6b\x94\xd5\xec\x80\xa6\xd9\xd1"
> +	"\x19\x0a\x43\x6e\xff\xe5\x0d\x85\xa1\xee\xe8\x59\xb8\xcc\x6a\xf9"
> +	"\xbd\x5c\x2e\x18\x02\x21\x00\xb3\x29\xf4\x79\xa2\xbb\xd0\xa5\xc3"
> +	"\x84\xee\x14\x93\xb1\xf5\x18\x6a\x87\x13\x9c\xac\x5d\xf4\x08\x7c"
> +	"\x13\x4b\x49\x15\x68\x47\xdb\x00\x00",
> +	.c_size = 73,
> +	.verify_error = -EINVAL,
> +	.public_key_vec = true,
> +	},
> +	/* Wycheproof secp256r1/SHA-256 tcId 5 with a primitive SEQUENCE tag. */
> +	{
> +	.key =
> +	"\x04\x29\x27\xb1\x05\x12\xba\xe3\xed\xdc\xfe\x46\x78\x28\x12\x8b"
> +	"\xad\x29\x03\x26\x99\x19\xf7\x08\x60\x69\xc8\xc4\xdf\x6c\x73\x28"
> +	"\x38\xc7\x78\x79\x64\xea\xac\x00\xe5\x92\x1f\xb1\x49\x8a\x60\xf4"
> +	"\x60\x67\x66\xb3\xd9\x68\x50\x01\x55\x8d\x1a\x97\x4e\x73\x41\x51"
> +	"\x3e",
> +	.key_len = 65,
> +	.m =
> +	"\xbb\x5a\x52\xf4\x2f\x9c\x92\x61\xed\x43\x61\xf5\x94\x22\xa1\xe3"
> +	"\x00\x36\xe7\xc3\x2b\x27\x0c\x88\x07\xa4\x19\xfe\xca\x60\x50\x23",
> +	.m_size = 32,
> +	.c =
> +	"\x10\x44\x02\x20\x2b\xa3\xa8\xbe\x6b\x94\xd5\xec\x80\xa6\xd9\xd1"
> +	"\x19\x0a\x43\x6e\xff\xe5\x0d\x85\xa1\xee\xe8\x59\xb8\xcc\x6a\xf9"
> +	"\xbd\x5c\x2e\x18\x02\x20\x4c\xd6\x0b\x85\x5d\x44\x2f\x5b\x3c\x7b"
> +	"\x11\xeb\x6c\x4e\x0a\xe7\x52\x5f\xe7\x10\xfa\xb9\xaa\x7c\x77\xa6"
> +	"\x7f\x79\xe6\xfa\xdd\x76",
> +	.c_size = 70,
> +	.verify_error = -EINVAL,
> +	.public_key_vec = true,
> +	},
> +	/* Wycheproof secp256r1/SHA-256 tcId 5 with a superfluous zero in r. */
> +	{
> +	.key =
> +	"\x04\x29\x27\xb1\x05\x12\xba\xe3\xed\xdc\xfe\x46\x78\x28\x12\x8b"
> +	"\xad\x29\x03\x26\x99\x19\xf7\x08\x60\x69\xc8\xc4\xdf\x6c\x73\x28"
> +	"\x38\xc7\x78\x79\x64\xea\xac\x00\xe5\x92\x1f\xb1\x49\x8a\x60\xf4"
> +	"\x60\x67\x66\xb3\xd9\x68\x50\x01\x55\x8d\x1a\x97\x4e\x73\x41\x51"
> +	"\x3e",
> +	.key_len = 65,
> +	.m =
> +	"\xbb\x5a\x52\xf4\x2f\x9c\x92\x61\xed\x43\x61\xf5\x94\x22\xa1\xe3"
> +	"\x00\x36\xe7\xc3\x2b\x27\x0c\x88\x07\xa4\x19\xfe\xca\x60\x50\x23",
> +	.m_size = 32,
> +	.c =
> +	"\x30\x45\x02\x21\x00\x2b\xa3\xa8\xbe\x6b\x94\xd5\xec\x80\xa6\xd9"
> +	"\xd1\x19\x0a\x43\x6e\xff\xe5\x0d\x85\xa1\xee\xe8\x59\xb8\xcc\x6a"
> +	"\xf9\xbd\x5c\x2e\x18\x02\x20\x4c\xd6\x0b\x85\x5d\x44\x2f\x5b\x3c"
> +	"\x7b\x11\xeb\x6c\x4e\x0a\xe7\x52\x5f\xe7\x10\xfa\xb9\xaa\x7c\x77"
> +	"\xa6\x7f\x79\xe6\xfa\xdd\x76",
> +	.c_size = 71,
> +	.verify_error = -EINVAL,
> +	.public_key_vec = true,
> +	},
> +	/* Wycheproof secp256r1/SHA-256 tcId 5 with a long-form length of r. */
> +	{
> +	.key =
> +	"\x04\x29\x27\xb1\x05\x12\xba\xe3\xed\xdc\xfe\x46\x78\x28\x12\x8b"
> +	"\xad\x29\x03\x26\x99\x19\xf7\x08\x60\x69\xc8\xc4\xdf\x6c\x73\x28"
> +	"\x38\xc7\x78\x79\x64\xea\xac\x00\xe5\x92\x1f\xb1\x49\x8a\x60\xf4"
> +	"\x60\x67\x66\xb3\xd9\x68\x50\x01\x55\x8d\x1a\x97\x4e\x73\x41\x51"
> +	"\x3e",
> +	.key_len = 65,
> +	.m =
> +	"\xbb\x5a\x52\xf4\x2f\x9c\x92\x61\xed\x43\x61\xf5\x94\x22\xa1\xe3"
> +	"\x00\x36\xe7\xc3\x2b\x27\x0c\x88\x07\xa4\x19\xfe\xca\x60\x50\x23",
> +	.m_size = 32,
> +	.c =
> +	"\x30\x45\x02\x81\x20\x2b\xa3\xa8\xbe\x6b\x94\xd5\xec\x80\xa6\xd9"
> +	"\xd1\x19\x0a\x43\x6e\xff\xe5\x0d\x85\xa1\xee\xe8\x59\xb8\xcc\x6a"
> +	"\xf9\xbd\x5c\x2e\x18\x02\x20\x4c\xd6\x0b\x85\x5d\x44\x2f\x5b\x3c"
> +	"\x7b\x11\xeb\x6c\x4e\x0a\xe7\x52\x5f\xe7\x10\xfa\xb9\xaa\x7c\x77"
> +	"\xa6\x7f\x79\xe6\xfa\xdd\x76",
> +	.c_size = 71,
> +	.verify_error = -EINVAL,
> +	.public_key_vec = true,
> +	},
>   	/* Wycheproof secp256r1/SHA-256 tcId 60. */
>   	{
>   	.key =
> 
> ---
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> change-id: 20261105-ecdsa-x962-der-9c421ab28189
> 
> Best regards,
> --
> Florian Bauckholt <florian.bauckholt@cispa.de>

