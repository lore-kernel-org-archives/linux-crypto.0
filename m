Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134D9C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 11:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8EB86023E
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 11:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhKBLPX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Nov 2021 07:15:23 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:41050 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229720AbhKBLPX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Nov 2021 07:15:23 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A27KVoe027239;
        Tue, 2 Nov 2021 12:12:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=selector1;
 bh=3zDfwzbTTckNrmCbEG6nrtNSQ4GjS+cI8xuZ1RFHfsk=;
 b=mG1V3qX4rn4Qfinl6jU2a9fwfE8Zq+4pJtqkPBl/cvMOuRePHTS5sQ/BXNFahEWfy0EL
 OxZAfDs5yrSnyrNAAwBXYeFw2cUL5NXt7rc3Z9l0v3415K9m1p48Ig8LeHEbH7J916iB
 QFUdCmmRV+trXo60nVuMzgKhvvMDnB/+wy3kftY0+AyKjM+YOV1Xij/hrKrIjJ4acBJE
 lksOk/0EgpJHtqk1q6f1Ks8/eYyLEbMDYriYh/7dCgWXbQ4HfnP/ZKFQcyws/Er9vgcg
 OP1f/HrTK9yhgYRiVApaZxC1D/8Qm7GXQSsjMPq7d5DYd64ujPRAInc9MwvyMl4sU/CL 9w== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3c30uvhf96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 12:12:28 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 91F7210002A;
        Tue,  2 Nov 2021 12:12:26 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 4C21B22BFC2;
        Tue,  2 Nov 2021 12:12:26 +0100 (CET)
Received: from gnbcxd0088.gnb.st.com (10.75.127.48) by SFHDAG2NODE2.st.com
 (10.75.127.5) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 2 Nov
 2021 12:12:25 +0100
Date:   Tue, 2 Nov 2021 12:12:20 +0100
From:   Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
X-X-Sender: toromano@gnbcxd0088.gnb.st.com
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Marek Vasut <marex@denx.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] crypto: stm32/cryp - fix CTR counter carry
In-Reply-To: <CAMj1kXF5_2AnQH8pjgzbeq63iSkdkUVq3wZM_NURotoHj0sJMw@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2111020907550.20378@gnbcxd0088.gnb.st.com>
References: <20211029135454.4383-1-nicolas.toromanoff@foss.st.com> <20211029135454.4383-4-nicolas.toromanoff@foss.st.com> <CAMj1kXF5_2AnQH8pjgzbeq63iSkdkUVq3wZM_NURotoHj0sJMw@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
X-Originating-IP: [10.75.127.48]
X-ClientProxiedBy: SFHDAG2NODE3.st.com (10.75.127.6) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_07,2021-11-02_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Sun, 31 Oct 2021, Ard Biesheuvel wrote:

> On Fri, 29 Oct 2021 at 16:01, Nicolas Toromanoff
> <nicolas.toromanoff@foss.st.com> wrote:
>>
>> [...]
>>
>> @@ -1219,25 +1219,26 @@ static void stm32_cryp_check_ctr_counter(struct stm32_cryp *cryp)
>>
>>         if (unlikely(cryp->last_ctr[3] == 0xFFFFFFFF)) {
>>                 cryp->last_ctr[3] = 0;
>> -               cryp->last_ctr[2]++;
>> +               cryp->last_ctr[2] = cpu_to_be32(be32_to_cpu(cryp->last_ctr[2]) + 1);
>>                 if (!cryp->last_ctr[2]) {
>> -                       cryp->last_ctr[1]++;
>> +                       cryp->last_ctr[1] = cpu_to_be32(be32_to_cpu(cryp->last_ctr[1]) + 1);
>>                         if (!cryp->last_ctr[1])
>> -                               cryp->last_ctr[0]++;
>> +                               cryp->last_ctr[0] = cpu_to_be32(be32_to_cpu(cryp->last_ctr[0]) + 1);
>>                 }
>>
>
> crypto_inc() ??

Good point, I didn't know/find this function.

Thanks,
Nicolas.
