Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52D2C761A6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Apr 2023 07:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbjDCHAl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Apr 2023 03:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbjDCHAW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2023 03:00:22 -0400
Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A074CE38A
        for <linux-crypto@vger.kernel.org>; Sun,  2 Apr 2023 23:59:47 -0700 (PDT)
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3336ZVmq009923;
        Mon, 3 Apr 2023 08:59:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=message-id : date :
 mime-version : from : subject : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=VJ5A6Gk6cqgeOFIfWofDzb9dSKDciEwj0Io5fqbefMY=;
 b=RCyHMUqyMzipa1NftYtdB79Fti/HSZO6JCl4uCmAQt8tmh4xtTZIPzHhqv9kUzWGHpfw
 lsP7Br0DUZQpvSsgABjgMG6TyV6z52crbLH7M0yry7WQV824D+3UMAQ3kcNfZCmto8+F
 BGeP3+Manv3GU+MKRb23CQnNJL0QHU972fS42Z1TQMof8ifLvE6t9gUgvOBpOdhBF7He
 bCG3UipTWcpMmQn+PIL8EksIcxIyADN7WbmkhpBsKxbCRnhL8ffG+4TqFHmQoLIdmBGh
 LjQZK+luT3U0nvuJ2/aYjw9y2ua2h+UR5AGMqFozDpznSeoUl6roPiyDJ/x6nPg6MERd EQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3ppa1m8cug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 08:59:41 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id E97B310002A;
        Mon,  3 Apr 2023 08:59:40 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node3.st.com [10.75.129.71])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 85497210F76;
        Mon,  3 Apr 2023 08:59:40 +0200 (CEST)
Received: from [10.201.22.173] (10.201.22.173) by SHFDAG1NODE3.st.com
 (10.75.129.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Mon, 3 Apr
 2023 08:59:40 +0200
Message-ID: <34f2cffe-f4ce-9746-1a01-39abb80437d9@foss.st.com>
Date:   Mon, 3 Apr 2023 08:59:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
From:   Thomas BOURGOIN <thomas.bourgoin@foss.st.com>
Subject: Re: [PATCH] crypto: hash - Remove maximum statesize limit
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <ZCJk8JQV+0N3VwPS@gondor.apana.org.au>
 <ZCJllZQBWfjMCaoQ@gondor.apana.org.au>
 <0ac4854f-a8cb-1344-7de7-3c2579e6eba6@foss.st.com>
 <ZCT/SoUW4q5PA4JF@gondor.apana.org.au>
In-Reply-To: <ZCT/SoUW4q5PA4JF@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.22.173]
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To SHFDAG1NODE3.st.com
 (10.75.129.71)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_04,2023-03-31_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> Please use the cryptodev tree for all crypto work.

Thanks for the tip, the serie works on STM32MP1

Tested-by : Thomas Bourgoin <thomas.bourgoin@foss.st.com>

BR
