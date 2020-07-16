Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684CEC433E2
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 10:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C19E2074B
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 10:35:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="BYjMww2o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgGPKf6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 06:35:58 -0400
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:15526
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726190AbgGPKf5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 06:35:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcGu4nI7/dfwtWdI3zkE92R6bsMWEjaArK0Cfo2Jje7Qu9FCqStv7t875hUzliZQSTrja2MOviDgLwfDxgZUjlvQNq5aeDxyBNkV3z5QXLjPqa94Ma/yaiNEXu+lFNVNFhg4ucdhylzXEInv2Bcma5huIel0BDxw3RleuNWJuFMA52jnF0ZSeUowAWwUDjK1zFkrdPh0nHur8ofPqLjFt4l7Mol26QEUzPf513LdmOUMkUGSoJuKP/OmESQwG8cNkudxX9cVF/svb9BpUKmCxqWVIa2JrE8WKdld2Ew0pv015oZy9sCc0jgefACjseGhI2CMQ+50L1n7dZw2E7lyjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUNYenW79sckUMYV2jOPTfADp2ZUz0B/UYlcZLvbpGY=;
 b=XTZZ/z6C2WWCLaQGnAh1Y91cOb+g+yLQ+ndpcUTaftBkGC4LTlUZh0mzXB7urco9FWfav+EoMmefjSvtM6Wl6GJNl0fAUX5uO2vBJIN4D/EAddopTeEeJd+nJqXddTI3YHgZ9ugK9syyLjx8BZ2kzwJ1wyRn72HZ5uVBLXnB00RhHePASH/uEK2MMbjUYDXvd5/RHM0mYGb8Gs5ucldY5GOlUfiHdg/AZuhiLKW7W9lZ15bdcNlS+ewF3fsu0dtbWJ3PL+XjW77mjtXTNayooqBa2y9W71zbI2yFjNcoHytFvqDT7BCVMe1f0B3Q4gXiFXBkaeIcic/ocVy6ePPjrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUNYenW79sckUMYV2jOPTfADp2ZUz0B/UYlcZLvbpGY=;
 b=BYjMww2opoD8yXjaO7q0QWSQ0jEQue2KtE9eOt1NMdZDimKH7NpTAQO55j8b+5sHzxEkHTwrRdpzx77GOat22hfBfH6zxNanR30lT+Oeabk6XvMapt3oJlX8bGcFpFt3ifHFo00GnSuqxEZ0j7pQ/MB9L5lA2nDTSCr1r4Kf9kI=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB7117.eurprd04.prod.outlook.com (2603:10a6:800:12f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 10:35:54 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::8459:4be8:7034:7a81%6]) with mapi id 15.20.3195.018; Thu, 16 Jul 2020
 10:35:54 +0000
Subject: Re: [PATCH 2/2] crypto: caam - support tagged keys for skcipher
 algorithms
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <1594591536-531-1-git-send-email-iuliana.prodan@nxp.com>
 <1594591536-531-3-git-send-email-iuliana.prodan@nxp.com>
 <20200716073610.GA28215@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <0c818beb-05e5-a6c6-717d-782b32afff26@nxp.com>
Date:   Thu, 16 Jul 2020 13:35:51 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200716073610.GA28215@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0080.eurprd03.prod.outlook.com
 (2603:10a6:208:69::21) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (84.117.251.185) by AM0PR03CA0080.eurprd03.prod.outlook.com (2603:10a6:208:69::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Thu, 16 Jul 2020 10:35:53 +0000
X-Originating-IP: [84.117.251.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7f19422f-9241-43e6-2308-08d8297404bd
X-MS-TrafficTypeDiagnostic: VI1PR04MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7117E93E26C15A988E652EDE987F0@VI1PR04MB7117.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P2dprMi8Oxpbif9xPIkNwekDwkPpMAoiUxKksh1B9q/5C5aMlgOqV3pxVwaM4hXKPDEgdi/3UOVcSROebBC4UfDYH42Nr4m3vU98q31AHI1q4mnyVYGFmIV69lKZhU3UBk70ym9r/9Dy6bZjxxDhiLcFLMOOh5tH+2dqrYq9TrKVv/25lCyHIxUhgWhOx6fa0Ak7r/XoqeZgmI/9dybt/t0YuWYiwd7K2yu7SNW1vpFEE7RnWygBU/IgGNlAMVbEUs2O5isfEyxpmWBPBVjbLYrjxnZdz/ezXxVNXTkct+Or1A6IUwbn1/l+9PwlrfEQvQhjqFk9/Nsi3UEJhrGZ2Od/Pzsu3zDsqysc0+Xku992OfGCQCkz2Yp2lrpxzkll
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(26005)(36756003)(186003)(66556008)(66476007)(86362001)(8936002)(66946007)(31686004)(16576012)(83380400001)(110136005)(54906003)(16526019)(5660300002)(316002)(31696002)(2906002)(8676002)(6636002)(53546011)(4326008)(956004)(52116002)(478600001)(2616005)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6MmbxJ8LaXpL0csCoEAs9culLYJ4UbKzIKYLZRysVM3hcJjPW3ldOQu83ytgqiAJbdxc4Vfg0C0xJlMxgL+57sgVQxier39jqVSXRyQlvE1crtwAuTPO0h3XcH4xjvUo+KjamgKp++rmJFv3ABzEpxpcimIWUi8DhfPD+xpoDeQnlSEELsWNuK+3QjNuP/4kxg00MbfchKdOKfyb6GZ7Db9Qh1BHNVWvUvM0dfqWZcjjFl7qCjKG4FcRecvjKChZwO+SeXEwm7dg0qOTujAbCZjb+9DlWBGWcSJD5Qv6lsJ4be/anrnMq4DvRayUQe5vAeKPHiAYEI0RbPxJ6eLBsjg6DXuj3zKH6rMlXzOVwhxdQxOJJaqXvbW6bMiKOpCOpYuEfQptqGOXD1wxtAirLZXJcermVuOwKXoVa6eTf/nCpTuBN147GuC6rL+ZhHCRUcM4qojY2a58CeSSD4YcPkNE0avKwRPQg9r8HnqDuAw8vY1eW/rl34SCjBjkUGy5
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f19422f-9241-43e6-2308-08d8297404bd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 10:35:54.7163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ud0y18XIS4juyMt8c1Vvgdo2Pvf/plSyG70KDpxenrEJNHFxXVBvtM/iTYmviXnhRyTxYekW9r1CSJc/e9R72A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7117
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/16/2020 10:36 AM, Herbert Xu wrote:
> On Mon, Jul 13, 2020 at 01:05:36AM +0300, Iuliana Prodan wrote:
>> Tagged keys are keys that contain metadata indicating what
>> they are and how to handle them using tag_object API.
>>
>> Add support, for tagged keys, to skcipher algorithms by
>> adding new transformations, with _tk_ prefix to distinguish
>> between plaintext and tagged keys.
>>
>> For job descriptors a new option (key_cmd_opt) was added for KEY command.
>> Tagged keys can be loaded using only a KEY command with ENC=1
>> and the proper setting of the EKT bit. The EKT bit in the
>> KEY command indicates which encryption algorithm (AES-ECB or
>> AES-CCM) should be used to decrypt the key. These options will be kept in
>> key_cmd_opt.
>>
>> The tk_ transformations can be used directly by their name:
>> struct sockaddr_alg sa = {
>>     .salg_family = AF_ALG,
>>     .salg_type = "skcipher", /* this selects the symmetric cipher */
>>     .salg_name = "tk(cbc(aes))" /* this is the cipher name */
>> };
>> or for dm-crypt, e.g. using dmsetup:
>> dmsetup -v create encrypted --table "0 $(blockdev --getsz /dev/mmcblk2p10)
>> crypt capi:tk(cbc(aes))-plain :32:logon:seckey 0 /dev/mmcblk2p10 0 1
>> sector_size:512".
>>
>> Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
>> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> 
> Can this use the existing paes name instead of tk as done in
> other drivers?
> 
This patch set adds support only for some AES-based algorithms.
However, going further the plan is to add all keyed algorithms
supported by caam.

Thus I wouldn't tie the name to AES.

Possible alternatives would be:
pk - protected keys
tk - with "t" standing for "trusted" instead of "tagged"

Wrt. "trusted", I am not sure this term should strictly be tied
to a TPM or not.

Thanks,
Horia
