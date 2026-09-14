Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D058369D7C;
	Mon, 14 Sep 2026 13:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789392026; cv=none; b=tZVOi50weLqVZZDaLy/+04cFbiavXRJoxgWywR+i1934djNtCc4iOMgfy/+b9e9GsmPG3h+F8eZPX/Yhd1joPqRzuhr8xVMN5Sac/MlrYSHEEMc3HuTwyanJDuFY0mHgF9w7yXiA3V6zb4vtESiSfXCJgQvkpX6crM6uS2IoajE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789392026; c=relaxed/simple;
	bh=dmfM0QKCfuIA2cHZh7EJpOI3cU1iXUG5DQz4ahIuySc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l6xMxCpSM8dOPTPUpg3Lc1Y82djMivhqFFwOtzmzRm5zdYpkHE8rWNs4yG1hyGU3ESP8xhVb7bUvEIJEyLR5loi0XOlLjGHlDVpKZw3JMraE6yV7uyKptgXxptC/alLwMTvBvQrayWlzZRynnghQiAJXipYUSpt6JmQ9C8gzgk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ib5ybx5X; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ib5ybx5X"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ED26nW223780;
	Mon, 14 Sep 2026 13:20:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=FAExpT
	SQeOnURSVfE6PgdU+Z8ZSz89ZKBxqhzpBwsCE=; b=ib5ybx5XPAf2cQqgEzmSWU
	mfBl5OKt1oxppkAX6WQdPx42qFtCOIccSArLWetJq1aNjhaZTCae9WcqK2OJp0ED
	c64hGBkDXt5qdSWbRyeLPXTOAgfbzgiPmat11PY78YDWcqTJo7KOBT2uKrCitJcF
	q/bekem+G6QyvN40bgcS/DqMoSzSfJnh5qWacSt9dOOPtmPIcE7NJ5a3qbozAJZl
	6EApZzQdZVvf2tXO9FiUMBq++J1bfq3El7NSrvLXevMZw4uNbMV+5o0mnG2vLVDp
	l9/0kZmoXW01kT4LGZrH24mnnSW3263QwryVztT6UjJdAZ/vd5WCcAlknVNSrt5w
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxdq1kd9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Sep 2026 13:20:04 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68ED54P62386846;
	Mon, 14 Sep 2026 13:20:03 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gnk9j61mr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Sep 2026 13:20:03 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68EDK25b28574344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Sep 2026 13:20:02 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4691F58063;
	Mon, 14 Sep 2026 13:20:02 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C22D5805A;
	Mon, 14 Sep 2026 13:19:56 +0000 (GMT)
Received: from [9.67.124.200] (unknown [9.67.124.200])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 14 Sep 2026 13:19:56 +0000 (GMT)
Message-ID: <ba038abe-8278-49b0-beb7-2a0251e858eb@linux.ibm.com>
Date: Mon, 14 Sep 2026 18:49:54 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: powerpc/vmx - clean up includes, metadata, and
 p8_init()
To: Thorsten Blum <blum@kernel.org>,
        =?UTF-8?Q?Breno_Leit=C3=A3o?=
 <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
References: <20260914081500.65737-2-blum@kernel.org>
Content-Language: en-US
From: Srish Srinivasan <ssrish@linux.ibm.com>
In-Reply-To: <20260914081500.65737-2-blum@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDE4NiBTYWx0ZWRfXzqLdAcXZbk5w
 bqDPyBJhUeGG0Fvm6cCZCVO1LAAajMu86rnFC7/yUQ7PuX5GOkzvNA2bGQI+qp2i4nPLlPAGe1s
 bkGTKk//sfgTqeabhSbBxmPxrwv1nsZoJfKzoReD30VgTp3W5pfseIGOeXW7j4Ykldet46YE5BX
 G6Kx260mDKYldKqeWqhzc7Fe74MfrZe18EoSg/GOWoSfnTQnu5XTYburefJVJ1snD44Mw2iOIbP
 1tIXNzUiuOXWq1+ohdxnb8yKYUjsxvd06nQ7WFUloFMO9uYHYqNjSWxC+O8mwYHfvzOi7RfPG2c
 Ie5K9CL4BS73SdYdGfGg+6yligpDPyeFaXP/5y3ihApC0jPuBw6mDN5ALwsBdTBdOwqu3y2hPVl
 XMF/EcnlU+Aj7Unq8W7ImT2R30y0jN7Bzh9v3hc9DBSVUgjFy1f1y8w4T4h8OELvh35q8k2SvqX
 szo4qPIJt4iSvKJxtQw==
X-Proofpoint-GUID: iDL1_mx-bwn_G7WfWm5EaZr9wvkI4rjm
X-Authority-Analysis: v=2.4 cv=DobDa2/+ c=1 sm=1 tr=0 ts=6aa7f484 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=dDLX0a77UB6nXHVu2IYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: v7f9fFXDbhU1-pvt1ABFUhTVqABWpZt6
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDE4NiBTYWx0ZWRfXwwTnRCTi6+iM
 54M3goLSh1DR5Iyj0NG6+8EqqQ4DQQ7WS7A0RhpFtLaqWazNKOpVyh5+7selU37FosuwAUDKsTi
 Yvj4vSwnqwBU7K7E1UqEUdpWrGESUeA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_03,2026-09-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 spamscore=0 clxscore=1011 adultscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609140186


On 9/14/26 1:45 PM, Thorsten Blum wrote:
> In p8_init(), remove the goto statement and return ret directly.
>
> Remove any redundant includes, add a missing space in MODULE_AUTHOR(),
> and join the MODULE_DESCRIPTION() strings for better grepability.
>
> Also remove MODULE_VERSION(). It has never been updated and the kernel
> release better reflects the module version.
>
> Signed-off-by: Thorsten Blum <blum@kernel.org>



Tested-by: Srish Srinivasan <ssrish@linux.ibm.com>


> ---
>   arch/powerpc/crypto/vmx.c | 14 +++-----------
>   1 file changed, 3 insertions(+), 11 deletions(-)
>
> diff --git a/arch/powerpc/crypto/vmx.c b/arch/powerpc/crypto/vmx.c
> index 08da5311dfdf..8abc4db8ee4e 100644
> --- a/arch/powerpc/crypto/vmx.c
> +++ b/arch/powerpc/crypto/vmx.c
> @@ -8,12 +8,7 @@
>    */
>   
>   #include <linux/module.h>
> -#include <linux/moduleparam.h>
> -#include <linux/types.h>
> -#include <linux/err.h>
>   #include <linux/cpufeature.h>
> -#include <linux/crypto.h>
> -#include <asm/cputable.h>
>   #include <crypto/internal/skcipher.h>
>   
>   #include "aesp8-ppc.h"
> @@ -24,7 +19,7 @@ static int __init p8_init(void)
>   
>   	ret = crypto_register_skcipher(&p8_aes_cbc_alg);
>   	if (ret)
> -		goto err;
> +		return ret;
>   
>   	ret = crypto_register_skcipher(&p8_aes_ctr_alg);
>   	if (ret)
> @@ -40,7 +35,6 @@ static int __init p8_init(void)
>   	crypto_unregister_skcipher(&p8_aes_ctr_alg);
>   err_unregister_aes_cbc:
>   	crypto_unregister_skcipher(&p8_aes_cbc_alg);
> -err:
>   	return ret;
>   }
>   
> @@ -54,8 +48,6 @@ static void __exit p8_exit(void)
>   module_cpu_feature_match(PPC_MODULE_FEATURE_VEC_CRYPTO, p8_init);
>   module_exit(p8_exit);
>   
> -MODULE_AUTHOR("Marcelo Cerri<mhcerri@br.ibm.com>");
> -MODULE_DESCRIPTION("IBM VMX cryptographic acceleration instructions "
> -		   "support on Power 8");
> +MODULE_AUTHOR("Marcelo Cerri <mhcerri@br.ibm.com>");
> +MODULE_DESCRIPTION("IBM VMX cryptographic acceleration instructions support on Power 8");
>   MODULE_LICENSE("GPL");
> -MODULE_VERSION("1.0.0");
>
