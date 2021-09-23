Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA8EC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 14:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76E1060EE7
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Sep 2021 14:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241480AbhIWO2W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Sep 2021 10:28:22 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:43436
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241308AbhIWO2V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Sep 2021 10:28:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/mQWsFX3sAaC2SM1WOwffj8EaRi5VIsoUJxSI1iwqzv13IQBrhn0X/3HmTJYC7LIF/4Ud0Cjr45w4E0vaZSnRIrofGhZK8R7dN+mDLScdjAtWvf8Efv/fgx/ol8Mp9+Ctd2PhkJBArACTg1n697PegzzW0cwEJCZlGno3lQm+CerjNRR6OrhEqr/Sxxuxvd6CdfSx9AlWymAQptO/gwPPuj3t/+CEwgf3YkUUVfziRH8aYJBxHYXzw2Rtj8XWW7tTg4szILCRKkTchPdL5/ujTH1/lfKus3pInRhg1s6X+134JQ25fmWKsNygUfd9ajn/ALRFfBVuniMB5113Y8xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4h/p1yEyaX+O+PidZd7nbjHE31LAShQZjPnj5S5TdlQ=;
 b=W+MeDBf0uqG/xyZI/V4nlSCHtD9Kh8dzO5l+kE9abioEBW0Kas+m/VS/gaJVCmJPNsYcvVJ2/9H7j9kY0YLmfJQKFGiNufqkssbY0NmbWRYCYsRVRIVarl7zVPYqvcKE8eURGCFGCYaXzGaMTUl+w+dWaAMT2gvbiLGMYorMdeUhi30+zL0VpbeZwknS5geipj/LvyqDXaSN6jpucFtU2CGrbUZDPceDmqAJd5jBUp1tbfCRCo3SCkQz0jjmJemd9Plvm4BsK8Kboh1McMt13cBQd4Y1l2dxIZ3HzzqgebfASFJmQD8gEQTtfU5G4es1HCNLcfW42ZX/IseMqwZldQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4h/p1yEyaX+O+PidZd7nbjHE31LAShQZjPnj5S5TdlQ=;
 b=Jg1hqkxw3pWiYuzZsjFqya1aWF7nrU26fYZMTqM9kiscp9e+tfe7N9QFy7Sa28137oAOBQLmmkDIg820z0c9/yPWrLt/ZkP7XnM9GFpmFLe6IxDVgFshHqfK4uV16yqb72y+Y47T8F7DuQelDwD2P5LTf154lDmFZLeLna+ocWE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR0402MB2815.eurprd04.prod.outlook.com (2603:10a6:800:ae::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Thu, 23 Sep
 2021 14:26:47 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3567:55c:a665:a42f]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3567:55c:a665:a42f%2]) with mapi id 15.20.4523.017; Thu, 23 Sep 2021
 14:26:47 +0000
Subject: Re: [PATCH] crypto: caam: disable pkc for non-E SoCs
To:     Michael Walle <michael@walle.cc>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
References: <20210915220307.3079917-1-michael@walle.cc>
 <0b8ae053-698b-2c03-c729-c4c86ba79550@nxp.com>
 <936221D6-08D2-4656-86AF-DC921E3CB14A@walle.cc>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <1517fbd7-8f23-f5f5-983d-469a1856bbe8@nxp.com>
Date:   Thu, 23 Sep 2021 17:26:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <936221D6-08D2-4656-86AF-DC921E3CB14A@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0051.eurprd04.prod.outlook.com
 (2603:10a6:208:1::28) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.213] (89.136.162.44) by AM0PR04CA0051.eurprd04.prod.outlook.com (2603:10a6:208:1::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 14:26:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bebf6461-dc43-47d2-0fb9-08d97e9e2ce4
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2815:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2815A2D903BE4B076BC6005D98A39@VI1PR0402MB2815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8UGLeeSYd0FMG9uqK47FDkCwKojusn6ynsjQNP2EOTXpu5MxHZj+ALgihjqFEChChaD8UQ5E1Ku+bf6yjYtTGV390WGLrNnim33xHISMihLi2xdNzXihlCaWfijUsAV0cqhunyBfHjX2P9g0FeMbvqIWluGP8EDLuOD5rzN8vC/wT+GfUA/psvI4C/ev1RZFUBRAd7dtjlb7FmPdoTPvWiMCvGznmu11K3jsx4kcsgIHjMCHox85LtEI6Jb/+pp21FlHaOxIz203NATRQav7G0LQrdJts+HwycjJCBEH6Gjx94ZBK12DsgRlt3yA5UDATHygwcbtSeEQosq9T8ZjyG1cup1fK81P7nw5a0NQhZAPkBRUiR+JxF9f4QBCZOxbC8pMs/zyoD+wIHLzme/TSSW+z9va63vJclszOK/VRIpvrCvIlhMMX38MjBMSGOAnxreZjd/KxsYUfm+P+5Kn7VQ4ZwUfa5lC27eJyDNGWbjnX3tKFQMxcAX8zEy1kGKtXyElidknONmWln+uoXhMcj+BfF0Mpoyg3meopeYc+iAjOV9hP7CPkPLl/8IJVSYlqzpOtdRrfRw4plxqBh5sKCt9qH41gtG7WICIdSGpkZJ6TdXYfxdPaWXx2rInG2wm/swnZ52cTsBCo1fAkhiDoSEoRm3xI81lXW65dzVtsPrYH0E6YZG3rUGvqXTkHJzFrVR3n5bWob+HsFiKscW1WL4U8Aj8dx8xD3r6PT2092OMhxbfrmZD6gjVh7nzAE1qs05L9KdJmdxW2z37jeXbfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(86362001)(956004)(38100700002)(2616005)(16576012)(31696002)(26005)(6486002)(66556008)(53546011)(66946007)(66476007)(316002)(8676002)(36756003)(8936002)(110136005)(186003)(54906003)(31686004)(2906002)(52116002)(508600001)(4326008)(83380400001)(5660300002)(38350700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTZsR2t6ZGtpUjl6WVpqZmZ5RlVoY1V0b1FCeGRQcHhMcnJOZnpvR2FwUnRM?=
 =?utf-8?B?bUxKZzdKNVhlN1Vxa3hrdGhXU3d0ZlprS3F2d1BMWS9ReFBuUThPaExiTWY4?=
 =?utf-8?B?WS91ejdsazVnZHJ6SGJrakhLZU45alV0TVZNR0xZWWVya3ZBVFZ3TzdmRWtq?=
 =?utf-8?B?THNUUUVmbDZ3Uk1zbTczTlZ2TE9QZytCU2hWVmdWVlRjWFlva0hHNEgyUmFR?=
 =?utf-8?B?N3lPS0twNkNSc3hwV2owbkNTNFpFZG1lV1Y0aE9NSWNmNWJ4UkJWektWRmVu?=
 =?utf-8?B?alRNVmNHZ1RINWdlZDUzd3E5LzlYZWhEQU1obXQxc0h5U0VUdUJvS2MyelRh?=
 =?utf-8?B?YXZldUF1bVo0MGQ0SExGZjQxdERUK1ZsSlBtM0FoZFoydjlnUTkwU2l3bFVD?=
 =?utf-8?B?VjluWmd5VmRsZWZicE9aMk80ZkZyR2IxdjJpWVdRRzhpSU41clRLM2VJc2xV?=
 =?utf-8?B?Ry95ODRJOEpjc0lMM1psNWJFMkRtRGFJc1dLQ1hpbEpIRjh4eXpKdk4zalhz?=
 =?utf-8?B?dXJleG9RNE5CZ20wYWZZNFZVbE0yMFVYNFVEQzYrTjdWcy9zWjlJY1lvQjF2?=
 =?utf-8?B?NjZTZzJJU2t4RzVqbENvUVBPS2EyVzlNZ1VmTG5DMkh6YVYxVExPSDFaN0p2?=
 =?utf-8?B?bUNIZUJGMWh6dHp5RVExWHhLNVBoaUlBSXBlZnZKUHU0czFLUFNnVDZVMmZ5?=
 =?utf-8?B?aytraE4rczc2K2RWNGxqSjZLRnptVndHU21meGIzUlJaSGFFQk56VHJsOUpP?=
 =?utf-8?B?cllHbzBNaGR0eE9ncEdFa09tUUpVK0RjcjZhRDkySTg0MjJOMmdJY2dPUkpi?=
 =?utf-8?B?dXhCTWY2clE0QmM3b0pyRjRtOG5PQ2JyZEZGejdvZlBmS0svWitIMFRKVHk5?=
 =?utf-8?B?c3BnZ3V6UHJ4SUhJdm0wYWpsbXNMZ1J1TFN0azY5dXhWVXNjS1dmbFZPVXNU?=
 =?utf-8?B?bXlEZnZnSElXSUVEQTE4L3c3TVlGK3V6K2FwazhrQXdrZWVJdHhMT2V0cWhK?=
 =?utf-8?B?KzZxWHVlNlNRN1dpSEI2b2JsUW05UVBWUFo4d01XdTJtZE5ZN056RGFBczlu?=
 =?utf-8?B?cVUwbUJXdnRhUjdnRlFvWDNOQ0x5cFZlUE84eFgxVitXUFk4c3FHeGRsZnlE?=
 =?utf-8?B?bXlxeGI0UUIvS0hUNEczVDZmWXRLYVNSSVBoVmJERitKeGUwekZVTkppNndS?=
 =?utf-8?B?NzY5eWd6Vi92M3N1enZ4VlVPWXBJanpITnJQaHNSdDFtWVZjMGs4R0dqSTVZ?=
 =?utf-8?B?bmFIZFZnSlN4V3JiZmVqd2Z1S0dPaEFLS25KSzUrc1lWQ01NREdWZ201Z1NW?=
 =?utf-8?B?M1RKWEpwc2FVdE41cGFFb2N5VXdNY3k0am5TRXRkRVd3R05YR1U3U3R0QVlz?=
 =?utf-8?B?bCtmbCt2d3BoWlNEeWpwUGg5QjlQamI1Mm1yUEswQTU5UWdMeUlhR1BoTXh3?=
 =?utf-8?B?S0VCVmZUOFFiVkhRM096ZVQwaUFCbCt6TWpvYms5TEluWlc1UkE2emVPbU5w?=
 =?utf-8?B?T2JiemIwTysrdGJjR3dRT2hNRFI2azl2NXN1RXNwTmVJSU9LL3BjRXZLTkYx?=
 =?utf-8?B?S0h0Y0ZlenBPQ2RyL0dKKzFNd20wdTJ2U1RWTzlDbGF0SUdlRm9PdFRzNExr?=
 =?utf-8?B?YkpETitaUDFLR1RmRjNncEZJZnJCQnRROUVNUzVWSFdsTWpjeVU4SVpnUUVT?=
 =?utf-8?B?ZjhZTlY0aEp2S2o0dUFmUTJraC80aDJ1ZHhrRnBxbTFEYzlxMjNDbWE1OG9n?=
 =?utf-8?Q?63x2REUc6i8Y8mbFv60uCMBIzYR9PPocj66loG9?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bebf6461-dc43-47d2-0fb9-08d97e9e2ce4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 14:26:47.5460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IKx6wXzMPOXqOx3pfY4mFntarawL7jntv1mHONr+EsA6dc9aRmvQHgUcjJmwTtPtmLr9geZKxu17g4rKt+xItA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2815
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/22/2021 8:55 PM, Michael Walle wrote:
> Am 22. September 2021 17:51:23 MESZ schrieb "Horia Geantă" <horia.geanta@nxp.com>:
>> On 9/16/2021 1:03 AM, Michael Walle wrote:
>>> On newer CAAM versions, not all accelerators are disabled if the SoC is
>>> a non-E variant. While the driver checks most of the modules for
>>> availability, there is one - PKHA - which sticks out. On non-E variants
>> Currently there's no dedicated support for "partially disabled" non-E
>> (export-controlled) parts in Linux kernel caam driver(s).
>>
>> Up until recently firmware (U-boot) was deleting the "crypto" DT node
>> for all non-E parts [1].
>> Modifying the f/w indeed triggers changes across the s/w stack.
> 
> Well, it does check if a module is available or not. And this seem to be the only module which have "something in between". I.e. the number of available modules is not zero but it also doesn't work as expected. 
> 
>> Since you are modifying only the caam code handling PKHA, is it correct
>> to assume that everything else is working fine?
> 
> Everything else is skipped because the "number of instances" is zero. 
> 
>> For example: is the number of AES accelerators (AESA_VERSION[AESA_NUM])
>> being reported as 0 on non-E parts? 
> 
> yes, see above. 
> 
Ok, thanks for confirming.
Documentation is not clear about what happens when the "NSEC" fuse is blown.

It looks like the reported number of accelerator instances is not reflecting
what's "built" into caam IP block, but what is available.
Blowing the "NSEC" fuse permanently disables some accelerators (e.g. AES),
while others are either not affected (e.g. MDHA, RNG) or partially disabled
(when they implement also functions that are not export-controlled) - only PKHA
seems to be in the last case.

>>> it is still reported as available, that is the number of instances is
>>> non-zero, but it has limited functionality. In particular it doesn't
>>> support encryption and decryption, but just signing and verifying. This
>>> is indicated by a bit in the PKHA_MISC field. Take this bit into account
>>> if we are checking for availablitly.
>> typo:			 ^ availability
> 
> If there is nothing else wrong, could this be fixed while applying?
> 
Fine by me, but Herbert will have to do this.

>>>
>>> This will the following error:
>>> [    8.167817] caam_jr 8020000.jr: 20000b0f: CCB: desc idx 11: : Invalid CHA selected.
>>>
>>> Tested on an NXP LS1028A (non-E) SoC.
>> Thanks.
>> Unfortunately I don't have a non-E part to test on.
> 
> You can take a look at the ls1028a RM where this bit is. described to verify what the patch is doing ;) 
> 
Yes, I've done this already.

Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia
