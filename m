Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oTDdJ2fG"
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB7E18F;
	Tue, 28 Nov 2023 05:18:07 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ASCqSYK024414;
	Tue, 28 Nov 2023 13:18:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=RXpfz7Llk5CCG02ZWuvVU6iCecbBmpRM0GOJZafVqcM=;
 b=oTDdJ2fGA22fJbi21xS52NAqrpz2nL3i1i9CYOJA1IXCIIBqqmuHYdrmyL88GkoRv1FP
 5Pdp02AxcXJVYWH5l5Rpckduq81u7ci/BV5VE5NkB7tKUkdC6Kv2PgNKMEpOrYMK8TaP
 swwFkS/y5JPcL+tA2Pe1lqjvVvuWlI4JoUnm7qMp5uEQPWxGi5CTzjiVsxLIXMSqjEn3
 CigYarfA3UbIo0Jndlb8Dmu8x5myMJ40XgIq8w8AHF9hD+TLtEz7XfAXhXrcRd0+NySK
 U0zO7256epasjy4zIf3FJHUYdL8Qf73gjQOCt4bTEJMucvxhEC0H7BVFMznKS84cCM3U Zw== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ungkarq03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Nov 2023 13:18:04 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3ASAWfYP031072;
	Tue, 28 Nov 2023 13:18:03 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uku8t02y7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Nov 2023 13:18:03 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3ASDI2ON23593640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Nov 2023 13:18:03 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC49558065;
	Tue, 28 Nov 2023 13:18:02 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 953305805A;
	Tue, 28 Nov 2023 13:18:02 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Nov 2023 13:18:02 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 28 Nov 2023 14:18:02 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-s390@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: crypto: s390/aes - Fix buffer overread in CTR mode
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <ZWWHFeOPcW30OYo1@gondor.apana.org.au>
References: <ZWWHFeOPcW30OYo1@gondor.apana.org.au>
Message-ID: <ce50a198e3c59f30376cf54e52d5e749@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RMqiNfl3fKm5MENOJAyGCAVHljmBHnku
X-Proofpoint-ORIG-GUID: RMqiNfl3fKm5MENOJAyGCAVHljmBHnku
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-28_14,2023-11-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=719
 clxscore=1015 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311280106

On 2023-11-28 07:22, Herbert Xu wrote:
> When processing the last block, the s390 ctr code will always read
> a whole block, even if there isn't a whole block of data left.  Fix
> this by using the actual length left and copy it into a buffer first
> for processing.
> 
> Fixes: 0200f3ecc196 ("crypto: s390 - add System z hardware support for
> CTR mode")
> Cc: <stable@vger.kernel.org>
> Reported-by: Guangwu Zhang <guazhang@redhat.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
> index c773820e4af9..c6fe5405de4a 100644
> --- a/arch/s390/crypto/aes_s390.c
> +++ b/arch/s390/crypto/aes_s390.c
> @@ -597,7 +597,9 @@ static int ctr_aes_crypt(struct skcipher_request 
> *req)
>  	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
>  	 */
>  	if (nbytes) {
> -		cpacf_kmctr(sctx->fc, sctx->key, buf, walk.src.virt.addr,
> +		memset(buf, 0, AES_BLOCK_SIZE);
> +		memcpy(buf, walk.src.virt.addr, nbytes);
> +		cpacf_kmctr(sctx->fc, sctx->key, buf, buf,
>  			    AES_BLOCK_SIZE, walk.iv);
>  		memcpy(walk.dst.virt.addr, buf, nbytes);
>  		crypto_inc(walk.iv, AES_BLOCK_SIZE);

Here is a similar fix for the s390 paes ctr cipher. Compiles and is
tested. You may merge this with your patch for the s390 aes cipher.

--------------------------------------------------------------------------------

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 8b541e44151d..55ee5567a5ea 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -693,9 +693,11 @@ static int ctr_paes_crypt(struct skcipher_request 
*req)
          * final block may be < AES_BLOCK_SIZE, copy only nbytes
          */
         if (nbytes) {
+               memset(buf, 0, AES_BLOCK_SIZE);
+               memcpy(buf, walk.src.virt.addr, nbytes);
                 while (1) {
                         if (cpacf_kmctr(ctx->fc, &param, buf,
-                                       walk.src.virt.addr, 
AES_BLOCK_SIZE,
+                                       buf, AES_BLOCK_SIZE,
                                         walk.iv) == AES_BLOCK_SIZE)
                                 break;
                         if (__paes_convert_key(ctx))
