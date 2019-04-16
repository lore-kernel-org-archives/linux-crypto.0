Return-Path: <SRS0=uro5=SS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969EBC10F14
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 10:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6505720693
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Apr 2019 10:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbfDPKfT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Apr 2019 06:35:19 -0400
Received: from [110.188.70.11] ([110.188.70.11]:40646 "EHLO spam2.hygon.cn"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727783AbfDPKfT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Apr 2019 06:35:19 -0400
Received: from MK-DB.hygon.cn ([172.23.18.60])
        by spam2.hygon.cn with ESMTP id x3GAScAS069530;
        Tue, 16 Apr 2019 18:28:38 +0800 (GMT-8)
        (envelope-from fenghao@hygon.cn)
Received: from cncheex02.Hygon.cn ([172.23.18.12])
        by MK-DB.hygon.cn with ESMTP id x3GASTDC034698;
        Tue, 16 Apr 2019 18:28:29 +0800 (GMT-8)
        (envelope-from fenghao@hygon.cn)
Received: from [172.30.20.134] (172.23.18.44) by cncheex02.Hygon.cn
 (172.23.18.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1466.3; Tue, 16 Apr
 2019 18:28:34 +0800
Subject: Re: [PATCH 0/6] Add Hygon SEV support
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>,
        "'Tom Lendacky '" <thomas.lendacky@amd.com>,
        "'Gary Hook '" <gary.hook@amd.com>,
        "'Herbert Xu '" <herbert@gondor.apana.org.au>,
        "' David S. Miller '" <davem@davemloft.net>,
        "'Janakarajan Natarajan '" <Janakarajan.Natarajan@amd.com>,
        "'Joerg Roedel '" <joro@8bytes.org>,
        =?UTF-8?B?JyBSYWRpbSBLcsSNbcOhxZkgJw==?= <rkrcmar@redhat.com>,
        "'Thomas Gleixner '" <tglx@linutronix.de>,
        "'Ingo Molnar '" <mingo@redhat.com>,
        "'Borislav Petkov '" <bp@alien8.de>,
        "' H. Peter Anvin '" <hpa@zytor.com>
CC:     "'Zhaohui Du '" <duzhaohui@hygon.cn>,
        "'Zhiwei Ying '" <yingzhiwei@hygon.cn>,
        "'Wen Pu '" <puwen@hygon.cn>, "x86@kernel.org" <x86@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1555329868-17895-1-git-send-email-fenghao@hygon.cn>
 <3a1288ab-8e18-5421-05b4-4f4ef2fc531c@redhat.com>
 <AM6PR09MB35237F925CF4C82FBBA53862D22B0@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <fda47663-9536-0d36-5a0e-c6da77e21209@redhat.com>
 <AM6PR09MB35234C86C0502E1FAAB3A305D2240@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <985108b1-6d51-4458-48de-c5b96c5f14f9@redhat.com>
From:   Hao Feng <fenghao@hygon.cn>
Message-ID: <992c3a3f-8eb2-5286-c9f7-7940fc5ccf55@hygon.cn>
Date:   Tue, 16 Apr 2019 18:28:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <985108b1-6d51-4458-48de-c5b96c5f14f9@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.23.18.44]
X-ClientProxiedBy: cncheex01.Hygon.cn (172.23.18.10) To cncheex02.Hygon.cn
 (172.23.18.12)
X-MAIL: spam2.hygon.cn x3GAScAS069530
X-DNSRBL: 
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/16/19 4:09 PM, Paolo Bonzini wrote:
> Useful does not mean secure, does it?  PKZIP encryption was certainly
> useful back in the day, but it was not secure.
> 

Thanks for the comments, quite understand the concern about security
because it is indeed so important. Many people may not hear about
SM2, so it is natural to doubt its security. Actually SM2 is not just China
standard, it is also ISO/IEC standard, this fact should give us some
confidence about its security.

You can get more information about SM2 from below ISO/IEC specification.
https://www.iso.org/obp/ui/#iso:std:iso-iec:14888:-3:ed-4:v1:en

-- 
Thanks
Harry
