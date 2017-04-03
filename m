From: Stewart Smith <stewart@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] crypto/nx: Add P9 NX support for 842 compression engine.
Date: Mon, 03 Apr 2017 11:37:22 +1000
Message-ID: <87vaqmmfu5.fsf@linux.vnet.ibm.com>
References: <1491066107.29552.29.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Cc: mikey@neuling.org, suka@us.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Haren Myneni <haren@linux.vnet.ibm.com>,
        herbert@gondor.apana.org.au, mpe@ellerman.id.au, ddstreet@ieee.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52273 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750992AbdDCBhe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Apr 2017 21:37:34 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v331XmaC122820
        for <linux-crypto@vger.kernel.org>; Sun, 2 Apr 2017 21:37:34 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29k3uugrm8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Sun, 02 Apr 2017 21:37:33 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <stewart@linux.vnet.ibm.com>;
        Sun, 2 Apr 2017 21:37:33 -0400
In-Reply-To: <1491066107.29552.29.camel@hbabu-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Haren Myneni <haren@linux.vnet.ibm.com> writes:
> @@ -656,13 +953,21 @@ static __init int nx842_powernv_init(void)
>  	BUILD_BUG_ON(DDE_BUFFER_ALIGN % DDE_BUFFER_SIZE_MULT);
>  	BUILD_BUG_ON(DDE_BUFFER_SIZE_MULT % DDE_BUFFER_LAST_MULT);
>
> -	for_each_compatible_node(dn, NULL, "ibm,power-nx")
> -		nx842_powernv_probe(dn);
> +	if (is_vas_available()) {
> +		for_each_compatible_node(dn, NULL, "ibm,xscom")
> +			nx842_powernv_probe_vas(dn);

I'm not keen on how the device bindings work, instead, I think firmware
should provide a 'ibm,vas' compatible node, rather than simply searching
through all the ibm,xscom nodes.

XSCOMs aren't something that Linux should really know about, it's a
debug interface, and one we use through PRD to do PRD-things, XSCOMs
aren't part of the architecture.

-- 
Stewart Smith
OPAL Architect, IBM.
