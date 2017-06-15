From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 3/6] ima: Log the same audit cause whenever a file
 has no signature
Date: Thu, 15 Jun 2017 12:00:56 -0400
Message-ID: <1497542456.4287.57.camel@linux.vnet.ibm.com>
References: <1496886555-10082-1-git-send-email-bauerman@linux.vnet.ibm.com>
         <1496886555-10082-4-git-send-email-bauerman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>
To: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750830AbdFOQBd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 12:01:33 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5FFwoox096105
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2017 12:01:33 -0400
Received: from e23smtp03.au.ibm.com (e23smtp03.au.ibm.com [202.81.31.145])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2b3vrwhxt0-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2017 12:01:33 -0400
Received: from localhost
        by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Fri, 16 Jun 2017 02:01:30 +1000
In-Reply-To: <1496886555-10082-4-git-send-email-bauerman@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2017-06-07 at 22:49 -0300, Thiago Jung Bauermann wrote:
> If the file doesn't have an xattr, ima_appraise_measurement sets cause to
> "missing-hash" while if there's an xattr but it's a digest instead of a
> signature it sets cause to "IMA-signature-required".
> 
> Fix it by setting cause to "IMA-signature-required" in both cases.
> 
> Signed-off-by: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>

Thank you.  Queued to be upstreamed.

Mimi
> ---
>  security/integrity/ima/ima_appraise.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index ea36a4f134f4..809ba70fbbbf 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -217,7 +217,8 @@ int ima_appraise_measurement(enum ima_hooks func,
>  		if (rc && rc != -ENODATA)
>  			goto out;
> 
> -		cause = "missing-hash";
> +		cause = iint->flags & IMA_DIGSIG_REQUIRED ?
> +				"IMA-signature-required" : "missing-hash";
>  		status = INTEGRITY_NOLABEL;
>  		if (opened & FILE_CREATED)
>  			iint->flags |= IMA_NEW_FILE;
