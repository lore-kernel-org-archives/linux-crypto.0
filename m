Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="e2o/93bE"
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A781FD6;
	Tue, 28 Nov 2023 03:19:01 -0800 (PST)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ASAHr9v002957;
	Tue, 28 Nov 2023 11:18:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : reply-to : in-reply-to : references :
 message-id : content-type : content-transfer-encoding; s=pp1;
 bh=J3HHv4i8+Bk14NUtCy4omkhMqlZmh9n5UV+F1K/cE7g=;
 b=e2o/93bEYJdwsrrAzaKQfjDl4cSFem4wn+Ah6dYK9+l9RCWeh5u4xq0m8bn3NK0K/UJz
 Ircppzysugau3iva89rEp9FRA32PVP3yuB4tp0/t24fKrmMP4ngbZ28ZvPhK4WpHB3c1
 +kkXQuVFt9DQ8FBWzuHG+Snh50M7J+NU4RruEAdRGXnj6gPhQ4HJElMfW/x11h6QHMae
 StzY73Qn9gNZCfcOgkg8pc+63KMZH0txbBOJtNwPk8XHrmtQeUzPBxhwPMZUobgcovOz
 yauBsxSY6iuXAevWpAsl8O6RQop8/mlXD/PqUPVIVxeZFXDRU1qosWmMy4D2emeRr/JF Vw== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uneawssm1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Nov 2023 11:18:58 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3ASAWPXR031009;
	Tue, 28 Nov 2023 11:18:58 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uku8sygsk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Nov 2023 11:18:58 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3ASBIuV048365834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Nov 2023 11:18:57 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E22FB58053;
	Tue, 28 Nov 2023 11:18:56 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D9C658059;
	Tue, 28 Nov 2023 11:18:56 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Nov 2023 11:18:56 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 28 Nov 2023 12:18:56 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-s390@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        Holger Dengler
 <dengler@linux.ibm.com>
Subject: Re: crypto: s390/aes - Fix buffer overread in CTR mode
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <ZWWHFeOPcW30OYo1@gondor.apana.org.au>
References: <ZWWHFeOPcW30OYo1@gondor.apana.org.au>
Message-ID: <fa07b027fcfabbe712539afd5612ddfb@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: i7if7HTaVawiwdxntyrM5APHuFs8uv4n
X-Proofpoint-GUID: i7if7HTaVawiwdxntyrM5APHuFs8uv4n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-28_10,2023-11-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1011
 mlxscore=0 mlxlogscore=579 suspectscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311280089

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

Reviewd-by: Harald Freudenberger <freude@de.ibm.com>

There is similar code in paes_s390.c. I'll send a patch for that.
