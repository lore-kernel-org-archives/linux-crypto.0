Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09595C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 15:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241596AbiDRPbr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 11:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241347AbiDRPbO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 11:31:14 -0400
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40049.outbound.protection.outlook.com [40.107.4.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD605F9F
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 07:43:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ka3/oDBPHJw2msxHNlHcAWo99WFLD69MCpI1pw6sf6cHlUgqjMuQw2oAviRltmQL8bXefDEk4btJjoO9uz/oUUcHyF2cRMdJ090mNQGS/FyCZMjB7mfNULy70bN23M0OhQ735fzFB2miCgfJyxez4lzolxfKW1JZa56ZDwyFxWW6RGwATUDw4ZOivrnkaNbhvi225dMYjBLCv368IK4ynhYtzeWZtw+S6n+/BShtMydgNa1Hnlj9kR8nqFVxGu3WyJJ0gR5sFJL9cC3tbIZBxwmFw68Xl5VwBEo5g1bhQdlsujXnYrW1AK/U1rHiLPmhxRZVr4CXldzCAo/sqSE+Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CC3pXKyaddg4dOkweotze9l/atf5G/1ppF2ShY5NDV0=;
 b=O9/6pq63qKJ58tsF/43TZnJg90QHC4pBWbiccMk4OjFX++asnd0+PzRe51mEktLnbMH+F2DcZhP0Um/hbzrAFsiF1erGxtCoBoP4Qw+pgWAnRnZugg0N6f3FeVlpbQ1/kdZgKQfVxP5/QTbKNkA4+dpvqK+Nah/7Pp4md0O2FJVdeheklvOF4OTR53xnCw9DtXzTAIkjTR4v+4fAn3BWDuB9c275nXxyyIhU5DD5+/220wwdFDT2lrd3MmRfC5/s46Zq5SeDpWlPaY86D7BU8uXSkzaYBwuLFKsngt9YBGgeRQNzU1W1WCUX2dh52sLGZhCRIgOY3t4MJLFef+4Ldw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CC3pXKyaddg4dOkweotze9l/atf5G/1ppF2ShY5NDV0=;
 b=boEGmCLmY7lks289JS5WafEVX1aMurnoM1gTdWPeM5XTHdC3A4u949msmIVVu89z9zqt6EWcD+99bH1ySIuCxCnNfU4oCUpPsgG83cGzvbaH3CFaFy54/Da36BI+J7X8nSF4Nr9PoE0diPL35huZ3K1V5aIhYP+Rxe5+An88RWs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9517.eurprd04.prod.outlook.com (2603:10a6:102:229::20)
 by AS8PR04MB7608.eurprd04.prod.outlook.com (2603:10a6:20b:293::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Mon, 18 Apr
 2022 14:43:28 +0000
Received: from PAXPR04MB9517.eurprd04.prod.outlook.com
 ([fe80::ecbc:8286:8006:fb5f]) by PAXPR04MB9517.eurprd04.prod.outlook.com
 ([fe80::ecbc:8286:8006:fb5f%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 14:43:28 +0000
Message-ID: <fc7885ef-1771-b047-699b-517c7f015c9b@nxp.com>
Date:   Mon, 18 Apr 2022 17:43:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2] crypto: caam - fix i.MX6SX entropy delay value
Content-Language: en-US
To:     Fabio Estevam <festevam@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Gaurav Jain <gaurav.jain@nxp.com>, Varun Sethi <V.Sethi@nxp.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Fabio Estevam <festevam@denx.de>
References: <20220416135412.4109213-1-festevam@gmail.com>
 <CAOMZO5B3ENSkK0aL+n=cm73--60mVukNtej=LOdx-Xa8XDkV4g@mail.gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
In-Reply-To: <CAOMZO5B3ENSkK0aL+n=cm73--60mVukNtej=LOdx-Xa8XDkV4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0086.eurprd02.prod.outlook.com
 (2603:10a6:208:154::27) To PAXPR04MB9517.eurprd04.prod.outlook.com
 (2603:10a6:102:229::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a75bc050-fa54-41ba-1431-08da2149cc8b
X-MS-TrafficTypeDiagnostic: AS8PR04MB7608:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB76088B9C44A367C69D0E368B98F39@AS8PR04MB7608.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fF79ZJFoQObSmAjRFBu5y9LKNdSEoFlLMlaxd3IcBJQcURMgGLq+4u+rzmmB9oPhuQN98c9byL+vHY/oUNvJ3mGQcalpPE8wu10Nhb0GEIlG7LkHytsOOvzHY1Edca5DcNOmtGGrHpKQN65Dh4KIKHB81YDSq1ckoCq8CHSi0bchTt2dcTW834X6Fnpg+P9CUfRB8Ewsvsn8EN96ZtB3Fg61G3uyVF8YnALOse+AU6mOeTwGPW2laIcoAQkXKPN1bSI7I4AyyrDRBMHr0jRNuxLwGF9ss6uoL0pKT2Va+/cxBOKshYilruItaCpr7dh5HjEL+Qpb2YAhomkudzuLod8RQKxGfGobmdalF3J2Znj0BkQoLlV2pAl+Pp3pcGtATHUpCdkcgCd2WNOgvHXtq+7Pa9tzomH7d4NEPdiPdIn6KC6Sa2yBgZXd3RQATpMiuc+zZ6QbKMFFQQnNwA+TLjQJTOamKhhSXCeSP6XiX3BGy43pq0OBa9u+9LVGd9nXHfmgqmegXNQks9WtfapQ1Jz6BekdXNvKp1FskHHtQrteRthuj+1+VSzTw44BhaUjt+SCLGdqEwm49akbZWrr5i9uiTm4tdw2cJxMo3e1pwD3gVESV0e+QcSoH4yQiiSe810UCV3sOhhG0Uj0aEgHwOnrQA7QC06vvWfBKtz+b4h2rzDd+z86hFacGPWoKy2Ta/7MSqlocQoEHJoTvP3tFU/E6J0zeuyXk61dSRes3dxdMSQgmUqsWJzo2mLRktVp/WnxQbgdQmmbGTUq8O8gCarCCvM0sL6Vp+PDXMJX2zs5+NYioLBrop6qfwHdUv+ARg3+BcdzCVTNMjoc1tHHlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9517.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(508600001)(52116002)(31696002)(38100700002)(6486002)(8936002)(38350700002)(8676002)(26005)(186003)(2616005)(66476007)(6506007)(6512007)(6666004)(86362001)(966005)(83380400001)(5660300002)(66556008)(31686004)(66946007)(4326008)(2906002)(36756003)(316002)(110136005)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEZHMUN5eUIrUFNmeTNOQ0d5d0cxVk4zUndMNXpKQWpsWktWa3ZMc2pvTGhy?=
 =?utf-8?B?alRUZ3JTRzE1V1Badm9FbExuU1J1bkhzckZtbk11WlV4L09kQURjcTM3WHRq?=
 =?utf-8?B?RDArVXpMMHgxYWVLMzBzQ3dRT3lmdmNiM2xPTE56djk5R1BhMDBCdDREdExF?=
 =?utf-8?B?OTVUNlVHSHRtWW1JcXFsV0JkMVR6MFhiaS9JV3l3NW9ZSTNCVVdMMWFNbi8v?=
 =?utf-8?B?eGF1WStnVnpBZmtUc1IxbjJSQmRpSUgrSW9STzQzd3pWSVFhY2Z1b0JmVUJz?=
 =?utf-8?B?dTFJMWludjhUUDdsS0JHV0RMVHdVNEFxRHNGZVVDdUk0QzR4N1NNN09RWHVa?=
 =?utf-8?B?YjBqQnd2ZmtiVnhUU1RtOGR0ekZHOFQ1ZWhPN0JnWTNtNjUrNWZPMXBPUDlF?=
 =?utf-8?B?eDg1NzRpQXdlMGgzZmU1bWVMMHpMU0NHS3lLZXdUVzZqRUp0ckozS09HS25h?=
 =?utf-8?B?NDhDcG5SamdNaTVqSk5vRDhBUzFnRW5nRndSaHdwUnRQQ2NzY1dvbWU5ZHFS?=
 =?utf-8?B?bDNIVVl1OStkQVp5MkV6NVEzY1BuT1h3N1l4dCsrVk5CMVZvVW81TXFab1pl?=
 =?utf-8?B?eTBYQ0l3NXo4bWs0bElLNHpreUgvenVvUXpkUFBvZ1p1UDFKTk1ZK21PT1Vn?=
 =?utf-8?B?UUx3dnkrRjhWd0VOdzFwN0pCVEx2djByV2syQUc4VWE4K01HN01EVUw3WVR5?=
 =?utf-8?B?bVJWSHQ1MFhhU0RSamtnSkdKREdicE1MUUtxd2RQS0ptbnlWTHZNMmZnbzRH?=
 =?utf-8?B?cWVFZ0kwV1krMXdHMFFhYlpHakRVZm1ldjMxaG1pOWZtYjdqZXZUbmlmUlFj?=
 =?utf-8?B?T0FlbUVYOE1qS1dETnZ5SVkvQWF5ZFIzUUlDdUJEeWcrRTB4VW9Nc2Q1ZjRn?=
 =?utf-8?B?eitvYXM3NWMyd2JWd3REY2p4QUVaRzVyelJtZGxZVTY4TzVhZmlJU1R6YWtW?=
 =?utf-8?B?T0wwZ1NEakxGTDd5ZXdMYVpKRVA0MUhXMmhSakJpQkNQaW1QNTRCRFU0ZHY1?=
 =?utf-8?B?R3F4SGdXL3IxSmc5WG5OZUNVNmN4OWVLZGI1cGRtYkkyRUg1dTR3UndKcTJW?=
 =?utf-8?B?UG5hL2ZSTVlxL1JsOWlIczBHSWJEdFFZc2dpbkw1QVVHclEyUW9Zdmg0SnRn?=
 =?utf-8?B?UWtqT3N6dDJWU0tJRkdEMDNzN25GeEhmRGpJd3lqdkYrNzAwTnF3WDU0RVRS?=
 =?utf-8?B?NW1xY3A5czdtNE9iMnFRYktpaHFVSDZSTFhIbUpkQmE4RW5yUEJlNXRXREJE?=
 =?utf-8?B?R2prdmkwRmxoYTJJaTNMOTd6QnFqRWh3OWFrcE9La3hpZEkzMnVIOW9kWXRy?=
 =?utf-8?B?dGRobzcrd3FteVFqalNKNUpvc2kyWTRGZVFUSHVzcVZrSXhKU0M5MzNOWmxL?=
 =?utf-8?B?MFBUVEdvTDdUVlF3TWRzT3JYS2laUUZWWmdvOTZJdFo4bkJDQTNYeDdaWEJL?=
 =?utf-8?B?ZndrWWZSTWc2d0FRQVRPV2N1YVh2R1NOUDNycmNpYnJiUjF5RW9XK1d3TVB1?=
 =?utf-8?B?aXhMMnI3bml6T3BWcnV6RytiTEQrYmhSdzlBc3JLNWxkc2I0ME5uMU8rRVNz?=
 =?utf-8?B?aERvVWJlMnJnaStWQzRWWVdyRXJJRE1UT3BsVkg4dUM0WE4zNGduQ1oxYlNB?=
 =?utf-8?B?SzVkelJmZXJuMVlEK1lOc1l5YXFJTUM3K282clEwcmhLWm9rZlpKQ2RRc3BZ?=
 =?utf-8?B?OEFiNVBpaFNwRmlJNGNEbUVFYzRaOXp2R2ZDTnRUaXZRSmJVTUFJcUxqZ0ZW?=
 =?utf-8?B?R3UvYllxTUtNZEJSOWdpY0c3S1JQRk8rbXFCcVBuKzlxc2J6S240d1k4Q1dk?=
 =?utf-8?B?QkdYcUR6R1lKY0E1NkdoRitPTEhlY0M4VjhjMXlQQ3pZaFI2bzdHWEpXOTVq?=
 =?utf-8?B?RWNVUlR5YXhMSDRtVHJBTXVHd2VEam96OWxKK1NiOHVaZGo2a1lpMzRHWGky?=
 =?utf-8?B?M1BsOU9mS1dPempaR3Q0NTgyeXY0MDBrOTR2alZRRDFUOVlXdHVoOVIreW10?=
 =?utf-8?B?Z3MxdzN1MUJXaDNFZDFmZ0RWbzU1OHRqNC9KdW9tVVB5OTZUZWhlcTE2Nmxp?=
 =?utf-8?B?bTVyanUxalBlaXJ0MWkxRDZBaTRjVGFrcWpZK0pGUitTNmxLMVpCaG9kQmhx?=
 =?utf-8?B?dkE0NW5sTzJCMUZYdklIcmFOSHo0TDRFNW9GWW5EMGNDQzJnM092V0pqR2lP?=
 =?utf-8?B?WHdJUFl0T1FZY1I4VVdXSFdjcFY4OEFyOXZSUUdQOUpxcDVsTk52VzVjcitL?=
 =?utf-8?B?U2xVTEpUS0V3TTN2V0hJNVdNU1BmZko1NVhkd05xdnZPSWdZS3RFa3k4ODcv?=
 =?utf-8?B?TnJEVDBySTNha2tDVE9VYjg5OHJ5ZkpTRjlzdzNVbGhWdG9KSk9BSmxvUDJs?=
 =?utf-8?Q?qVHF2yaNlzws7ZVo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a75bc050-fa54-41ba-1431-08da2149cc8b
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9517.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 14:43:27.9667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gotqabYSE4f3/GOSr+m9J1GsLynAKb1nDjEHrYk/rVzed8Cwb2eh3nHBCopyeevI8rqdLWDGyuc3epFo2ZqR+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7608
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/16/2022 5:34 PM, Fabio Estevam wrote:
> Hi Horia and Varun,
> 
> On Sat, Apr 16, 2022 at 10:54 AM Fabio Estevam <festevam@gmail.com> wrote:
>>
>> From: Fabio Estevam <festevam@denx.de>
>>
>> Since commit 358ba762d9f1 ("crypto: caam - enable prediction resistance
>> in HRWNG") the following CAAM errors can be seen on i.MX6SX:
>>
>> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
>> hwrng: no data available
>> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
>> ...
>>
>> This error is due to an incorrect entropy delay for i.MX6SX.
>>
>> Fix it by increasing the minimum entropy delay for i.MX6SX
>> as done in U-Boot:
>> https://patchwork.ozlabs.org/project/uboot/patch/20220415111049.2565744-1-gaurav.jain@nxp.com/
>>
>> Signed-off-by: Fabio Estevam <festevam@denx.de>
>> ---
>> Change since v1:
>> - Align the fix with U-Boot.
> 
> Actually, after thinking more about it, I realize that this issue is
> not i.MX6SX specific as
> I have seen reports of the same failures on i.MX6D as well.
> 
Someone will need to check whether this solves the issue on i.MX6D,
the root cause might be different.

Besides this, as Varun said, we should check with the HW team,
such that the value used for entropy delay is optimal.
IOW we need TRNG characterization for i.MX6D.

> Would it make sense to fix it like this instead?
> 
> --- a/drivers/crypto/caam/regs.h
> +++ b/drivers/crypto/caam/regs.h
> @@ -516,7 +516,7 @@ struct rng4tst {
>         };
>  #define RTSDCTL_ENT_DLY_SHIFT 16
>  #define RTSDCTL_ENT_DLY_MASK (0xffff << RTSDCTL_ENT_DLY_SHIFT)
> -#define RTSDCTL_ENT_DLY_MIN 3200
> +#define RTSDCTL_ENT_DLY_MIN 12000
>  #define RTSDCTL_ENT_DLY_MAX 12800
>         u32 rtsdctl;            /* seed control register */
>         union {
> 
> Any drawbacks in using this generic approach?
> 
One drawback is performance, not sure if there are others.

Horia
