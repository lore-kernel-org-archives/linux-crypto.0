Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE4BC33CB1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 08:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46F96207FF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 08:07:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="F56g24+3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgAPIHd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 03:07:33 -0500
Received: from mail-dm6nam11on2063.outbound.protection.outlook.com ([40.107.223.63]:35904
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726653AbgAPIHd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 03:07:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/ed1nOICWpOq93n446FyKP3DtIbmxrU8wWs8hehsUIyUf8T2b9Hgy3dzV6sezPrRL3shlerKqPtdrKCQYsz64n9+zEJ9T344tUiAK5T5UjBSXrpOMmuYzBfc6iSXVoLMAMzPWxsmAdfsPeuYkO3LiGYHdXv0rmX3m9ofv15AXJ9ILm9U7b9vvWeVBJ0ZEmuuMimiq8bWfHwKP8JVPDvhCKt0Nr84tfH/YSG9oXb2QSsF55vsFZnLpIa8zsGk4/R35TYH5+Qbr0QaC/REJOd4yop4czZzfWjJ8unlJAGj7tM0Zn1y/wkTDBa2pG9m5vt+kRWWSetl+kkl50TvRESXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxFOTJ5Gw5UCeESIxecSkgu2h/vvliHkuHC9slQl4iQ=;
 b=LYYj/KvTZT/sop7s6T0gi3eQvX2g6Ai0z8OMeYvyYSKTMG9mualZsdCyVBgFKAHBX9lhNzbHEMF/jlV50HvOriRIBqxalN2Ru4J5RH4MGvrDynG7c5PEpydIt63mhoJWh7OmmLuUvDRq4ljubjUW1wxjlis3LrxzlDhoP2aE4WcC62+4AhEV0naTbLZdErKkbeu1GosNrOWpfW/5bfnSmk+/ICRVBdhyYjJ7b6HfINPt3SPcgV5nx3mXXRSZSEhglXWyDGd2VlvnXXB4pxOIcZgjCQIXzCmM8q1EKy6g6PsIZFFyI+chJ3Ry0pwwIpnpTEmjieaMc+JgwysSWhGjxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxFOTJ5Gw5UCeESIxecSkgu2h/vvliHkuHC9slQl4iQ=;
 b=F56g24+3aUuHHU6Wm8C4I9JePAKh2wwFkZdOyRWFIcySfODSP9eiMyb/VOICE17nrxObFLnE3UaPx/2cA9vlrfVwv7K3OhYXNNcUJraX9Y9LSHvB/3paDLgfeJbUzVbfLsvPkVK/PQEhKx0X7aN7lX+33aPiS7dqeoo2aCdpeFQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1480.namprd12.prod.outlook.com (10.172.71.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Thu, 16 Jan 2020 08:07:30 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2644.015; Thu, 16 Jan 2020
 08:07:30 +0000
Subject: Re: [PATCH][next] tee: fix memory allocation failure checks on
 drv_data and amdtee
To:     Colin King <colin.king@canonical.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Gary R Hook <gary.hook@amd.com>, tee-dev@lists.linaro.org,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200107143601.105321-1-colin.king@canonical.com>
 <747f9c93-7465-99aa-0b91-a05fd64c7d1f@amd.com>
 <20200116070544.doegatlwgsftbhc4@gondor.apana.org.au>
From:   "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
Message-ID: <645872d0-02fe-84f7-209a-dd43cb8264a1@amd.com>
Date:   Thu, 16 Jan 2020 13:37:03 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20200116070544.doegatlwgsftbhc4@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0147.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::17) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from [10.138.134.82] (165.204.156.251) by MA1PR01CA0147.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Thu, 16 Jan 2020 08:07:27 +0000
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d76aa0c8-c89d-4897-4255-08d79a5b21ff
X-MS-TrafficTypeDiagnostic: CY4PR12MB1480:|CY4PR12MB1480:
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB148046968C22B48210F1FF57CF360@CY4PR12MB1480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 02843AA9E0
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(199004)(189003)(4744005)(6916009)(52116002)(26005)(2616005)(31686004)(2906002)(956004)(16526019)(186003)(5660300002)(53546011)(6666004)(66556008)(66476007)(66946007)(16576012)(8676002)(478600001)(31696002)(81156014)(54906003)(4326008)(81166006)(36756003)(6486002)(8936002)(316002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1480;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7EpyYAb04POdDc3o7+yG5gbGIUkYUzSxrk/qXoFjGHPhOrPxZBoc5aeEfePT8/GSzMHSkiqi1ylMJI51AH4540zRuqvFk2CVvgR092jlw8teS9uVuKI0pldKXX9mNwHkvDUEoijUGs5QSZO4NANddHhprNCnErEFMqoAFNkkD6Quwx9mbpt35IfWpsCQ6Vfz1pnn5wThsqmmphKEKzZ9WafLTua2VwV2q2T6jOers4d8aJWoEc4KqcjoQPwW3cYHcDrRlYRPwbyTh9TyTqTO7Sa5pOQ3mZBCTagMnGPg9uJCytOBNmEGay0qSA0au6n+vkcMueVNxrmneRrJ+OjP+Qt3wegZ53FKWDCZYX48MaviU4JQCA/h+B+m1eVD6jeR90hpYtzOnCNmysiHDNmVi3KT1TJGs1NWkMUwOUknHb01qQZCnphK3xNVvhIl8DXK
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d76aa0c8-c89d-4897-4255-08d79a5b21ff
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2020 08:07:30.1401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hwsSwA/oBrpMVtEJECPvBjl6il08iT+s4Ugh7Gbej7K/fjX/cIbIOWI6p3gCMmPnHW506YDYWEL3GjOo2YHAOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1480
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Colin,

On 16/01/20 12:35 pm, Herbert Xu wrote:
> On Wed, Jan 08, 2020 at 12:33:08PM +0530, Thomas, Rijo-john wrote:
>> +linux-crypto
>>
>> On 07/01/20 8:06 pm, Colin King wrote:
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> Currently the memory allocation failure checks on drv_data and
>>> amdtee are using IS_ERR rather than checking for a null pointer.
>>> Fix these checks to use the conventional null pointer check.
>>>
>>> Addresses-Coverity: ("Dereference null return")
>>> Fixes: 757cc3e9ff1d ("tee: add AMD-TEE driver")
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>
>> Reviewed-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
> 
> This patch needs to be resubmitted to the linux-crypto list for
> it to be picked up by patchwork.

Can you please resubmit this patch to linux-crypto list?

Thanks,
Rijo

> 
> Thanks,
> 
