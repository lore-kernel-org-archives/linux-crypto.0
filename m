Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9EBC74A5B
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Mar 2023 15:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjC2P0o (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Mar 2023 11:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjC2P0n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Mar 2023 11:26:43 -0400
Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F184E3C15
        for <linux-crypto@vger.kernel.org>; Wed, 29 Mar 2023 08:26:36 -0700 (PDT)
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TF1Y8M031366;
        Wed, 29 Mar 2023 17:26:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=vAv0XQskPSCa+2H1FCFz/2qh9D/yfrNYCCGJe5/v0jg=;
 b=mJxNNCEeSkHjv99cpIH5pO2lY8PM1UOEbQwOCHC+C/vty+CMYY9GP610VPKJ87t0McPS
 P8btfryhbYJo3teetI1MpLRAiMHnss40UmQEhyx5ZEdY/CwGiHFk626HJ6qRPli9J0MF
 ZST5/mOVm4JaVKy2orlMaM1S0LqpXCPZq4atx2o6vWAu++mtsAv/EYDHWkY4R8o7UCpH
 ulNF9CrP1iYRogkRrXYdQPHgHDVzVyJ6q24X4YBR97Ec2lWVeF9mTb/plbxBx+i+5iCy
 IUu8WTPaXoTvJC2PVkqHXmypMkcBEhBGNBXoCIujzpCQfajj4ThxCs7IQP11Ue5suiWk pw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3pmkm1hw0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 17:26:31 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id CDD8F10002A;
        Wed, 29 Mar 2023 17:26:30 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node3.st.com [10.75.129.71])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 2089C217B91;
        Wed, 29 Mar 2023 17:26:30 +0200 (CEST)
Received: from [10.201.22.173] (10.201.22.173) by SHFDAG1NODE3.st.com
 (10.75.129.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Wed, 29 Mar
 2023 17:26:29 +0200
Message-ID: <0ac4854f-a8cb-1344-7de7-3c2579e6eba6@foss.st.com>
Date:   Wed, 29 Mar 2023 17:26:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH] crypto: hash - Remove maximum statesize limit
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <ZCJk8JQV+0N3VwPS@gondor.apana.org.au>
 <ZCJllZQBWfjMCaoQ@gondor.apana.org.au>
From:   Thomas BOURGOIN <thomas.bourgoin@foss.st.com>
In-Reply-To: <ZCJllZQBWfjMCaoQ@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.22.173]
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE3.st.com
 (10.75.129.71)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_08,2023-03-28_02,2023-02-09_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi herbert,

I'm testing the serie on STM32MP1.
I cannot apply the patch on my kernel tree.
The patch fails to apply for the file crypto/ahash.c
I tried on tags v6.3-rc1 ans v6.3-p2.

On which branch can I test your patch ?

I see the overall idea of the patch so I modified crypto/ahash.c
and the serie works on STM32MP1.

Thomas

