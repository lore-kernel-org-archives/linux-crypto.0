Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9126C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 15:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F31660FC1
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 15:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236323AbhIVPw7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Sep 2021 11:52:59 -0400
Received: from mail-am6eur05on2048.outbound.protection.outlook.com ([40.107.22.48]:19854
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231712AbhIVPw6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Sep 2021 11:52:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I80Z2h30LAA4AcGxtt9vhxNZBHIeUCvzOgW6gjCSWdXDxKgPlXu6CiRYPfb82pTWlDv1KUpGbAuDnFCYvyvX6W0O48aSqeAJqB0eAWLoDED56IDJCEuF9Fy9IHD5ubg9TlifMUHcfCnYOIGkQW9T0RwOczx+xl2tI/xYXx496XWS5z7CfRg4i5C4IB0+3/olYM2uOdiuKESXTx3ndPZ0mOgzhSZG8y1TUtq2FLqHWuqWiTnZaquoZwsRo9D/QMblqVVmRJpCRpxnU2oZse83IxQ9eKeFPu13wu697Nuve3/exanqvYJjTD6Iwy6SZW0SiuTWuFLqV0l6MmGWsblqOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=LKtJxK3FNdBPuv6sn97bkAjfyRdJbcMe3aBq0JEpsqg=;
 b=bi/nL4u2HnRLmafsc0V8N9PpJDrh/lYD1S7iZqwNaayANZpZ7xKPZH33+tMYDsadECBnnRxjpfdM8hk1xlDQN9iHF7nPuhnzdG98dZXf8y2OkFKYrpnpTxv8vUQCjyB1se1f1pg1nvOEMsVkPyBex6aebMS3ehUFOZqVFSES61lhwRKBjmPiRFSUHnA2EU0KIVRx7jtIjoqDImIZdTiicMnrTgCULs/agRlPdqydpTop5Y9A7jGJlCFC5zVRuOrYfeCN3qVSGDYZ5pMJE617r8IP9nKjW4ZICaKTAgtlVxGaPEFFRMiaK/rRvATaRnTBNdDSyvpi7VyYGyJ9ppDONA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKtJxK3FNdBPuv6sn97bkAjfyRdJbcMe3aBq0JEpsqg=;
 b=Q/aCPZopEVoWpL1kCeFRyoCvk1bx2EdoqdpsBHzqkON9F5j+SvkIb5rDC6CZIlXZ75DtStslQOZ1mILGQLIeoYr4wXu0Ob/opBayDmnKEydzSZ+P8UkiR43B6yTAp6r3cyMN2rYSsNiRBgklIMrXAsnZMF3Q7pkBFMsROfb/W/I=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB7183.eurprd04.prod.outlook.com (2603:10a6:800:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 15:51:26 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3567:55c:a665:a42f]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3567:55c:a665:a42f%2]) with mapi id 15.20.4523.017; Wed, 22 Sep 2021
 15:51:26 +0000
Subject: Re: [PATCH] crypto: caam: disable pkc for non-E SoCs
To:     Michael Walle <michael@walle.cc>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
References: <20210915220307.3079917-1-michael@walle.cc>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <0b8ae053-698b-2c03-c729-c4c86ba79550@nxp.com>
Date:   Wed, 22 Sep 2021 18:51:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20210915220307.3079917-1-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0501CA0053.eurprd05.prod.outlook.com
 (2603:10a6:200:68::21) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.213] (89.136.162.44) by AM4PR0501CA0053.eurprd05.prod.outlook.com (2603:10a6:200:68::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 15:51:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a62b4fa2-a234-4b43-8c3b-08d97de0d5c7
X-MS-TrafficTypeDiagnostic: VI1PR04MB7183:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7183888329FA8288E7390B2798A29@VI1PR04MB7183.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xByLI1arjtHyguvFkybXCjPSLZfYoXmBzYaVQIkiheUsoA/D7LnRkc/nuhSstAh9wWb2TlMuNqQlRLSmyQnygpJ64fFlxbQ2P0lJI4w1Cf3/ZPcTsL0PwuTM+HhuBToM+qBaCZu71Baq2J5naRplaWnrsqFzt5iEo/OuAt1aCUCGP/fwVlOwenxSSt0EsNw+CTzS1CqVGcHTKXudE+E9QdM927EK1CEBnL/ZF+qfIXdiLOtlzeDQngFO1rNSlP8lx+gKJok2poTy6BqDeCpFfRxG7TGEBHCKwByGPOYv1lrv3o6ltsgf36X3gKO0HTekoRptXh43qpc/RirmisajO0extbqlJ9WqjrqBJA0lvyDq1MZKJ2nXtJEmtxmltz8v3vIeCcprEoF3fFFbchIcBSITwPEwfoARXEViqCdH897ssEXZ2eIxr0uaaq63XTm9Thos5LmrE2HFW0lNRPVUFlaxHnODaXe2oODxaHpe0zjZcv6SLQobE4tlNQWBOUkGO7nov7dSCd29KihkWN+AvIdEuycalG3J3SBSpZscEmfz2IrS19peegVKwf0v/7xZpzt7e50ruJzQR2vprjfMhrNiRLi4aipH6+c/8+qKEptXCITFMhrxgmUKk6wuHhZizOcj3Y9OTk/3JVPDu7jJ5mQfnO8fiwpCIg2DLOPs+GbYDy4M/FaQjQcpEFufiBSzcl4VrUK4N1qPJ4sT0W0EGI7azsqz3fkVlGAP4RPCG3v3kgOW7HAbZKgZlBzffwcanouDyce0oS3iXnSrytA1OMrZJZ7T5jabh7nE77kqCgwBXRUEBYrpU4e6/1pjF1ERUAQgBwWqvnig83XXIYITSx7kph4ArYxjumQDRQ6bGR4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(66556008)(54906003)(2906002)(110136005)(66476007)(8936002)(36756003)(956004)(966005)(5660300002)(52116002)(31686004)(26005)(86362001)(2616005)(38350700002)(53546011)(38100700002)(8676002)(508600001)(66946007)(83380400001)(16576012)(316002)(6486002)(186003)(4326008)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2hlckM2YWRRdXErWWNoTVNZcUR0OS9vWHVzK3lUblltSkVjN3ZWMm1FWnU1?=
 =?utf-8?B?UWdCcEdkOEpqSzN2R0ZtdTRLZ2NHVkpvWDNuOWFmTzdXUVFod0lsVyt6UFVi?=
 =?utf-8?B?QXR2ak1oMndsSDNaR0UwK2VhTnk3b3QwdnNqWGc0bTEyVlp4ZUFFcXA0VmJy?=
 =?utf-8?B?S3RNQUxIR0NJN09iMjJiRFVxci9lbGdvek5vaGFZNjVJQkJ2QVQ2Y3l2VG5Z?=
 =?utf-8?B?aWdIUVl5R3M0VWNNOXVtSHR0ZlYxd0c4T2tCVW5qaldCVVh3RThaSXc0SDdx?=
 =?utf-8?B?ZmovakdvT25EWDY2SExzNTRZUXZob2dvKzc2Y0RBb1pnZ1lpZWhyb2RuUUQv?=
 =?utf-8?B?cjNnZmtPbVN1bUpCdHAwSndwMmhQdm9zcktLYVlCUXI2bmN2Y3VudzA5SmJG?=
 =?utf-8?B?YjNEOVd1QXkvTXRDRDB2S3RmRVNiTnliZ1k0YUlaZTY3NGtVa09KMVFBSDd5?=
 =?utf-8?B?REFLd0o4bk9LSlg0K2dXTUxSajZCZDV5b053Ung3SUFOVlpoVmJ0RVlid0RN?=
 =?utf-8?B?bUl1OGU5SEpVRjlIQVRIcFZEMTdhUTBzOEdPS0M3NDFRY01aV2dmUmRES3dn?=
 =?utf-8?B?N0ZJeDVGNzA0N1FkREtBZUZWVmF0TTJwbUJ3dGRPWEgyckJOUjZkZnpWbkFB?=
 =?utf-8?B?Rjl2RFR6RDIvOXNpcTNLejFKbyt3b3FlMnFJblBDOGo0OXdLUkl3bS9kTCtW?=
 =?utf-8?B?VWx6TU5LTm1GVUNzYVNwS3lyakxaOFhuMHRyQnNBVDBITjVoTkR2Vk1iSVdG?=
 =?utf-8?B?aE1WQit0ODVYeTFlWWsxRXM4OENhb2I2Q3AxeUFrOTVyRHZkWG9zaytSL0g0?=
 =?utf-8?B?UFRrN1YvQ1Q2czhpdTczZnEyK1EvL2xXQkhoZndaclJJT21BMTZHSjN6R1ln?=
 =?utf-8?B?RThQVFBobE1FVFpvRnJjVG0zT0EzWkM2Q25tYU00UlcrU3BFUnI1NzByU3U5?=
 =?utf-8?B?S3RUV2J4cUpXdkQ0eE1UbFJsM080cnBwcCt3NmJkcWR6UEw1T3FoZnp1bk9V?=
 =?utf-8?B?aFpTbWdrV1o1ckdyY3ZqQXVkbmQ5bzRFRFhIbzFiR1ZmSURXdXRSemh3UjZD?=
 =?utf-8?B?dDVpMWIwL2dTcjVsdnI5ZGllTS93YVR2eTNHUTRZT2NleEVyT0dSSDZ5ZGFp?=
 =?utf-8?B?TVNTNkthdzl4a0dobURlMldQaTg2VUpNODVHVFdYR3ZNYWl2OFRFc1N6U2Ft?=
 =?utf-8?B?c0FTUVdvZE5oejRNVmNHN1E2cDlZMWJ2WC9MbkpiZ25FblZiY3VNU1YwY2Vi?=
 =?utf-8?B?WmZKRTFlbU9iUHRGQlh3dUY2cUJ4TG1aYkRwUUR2VkgrTGtXUWw1M2pES0sr?=
 =?utf-8?B?WVNoQU5vNlNQQjREMWE3ZFBrS2xXcjZMbGV6bDJTcWw5UlNXNFFJdHV5dWlo?=
 =?utf-8?B?elBvZmkzR0gwbWZkeEpCMzFaNmFtWHVFZkljYTFWemg0djFBVll3TEZhQ3B0?=
 =?utf-8?B?OUllb2U5QmlxWWN1SVl4ZTF2MlRlY2Nmc1o5U3ZNcWpTK09VaytZZzJSdnk4?=
 =?utf-8?B?a1hscThnWGZZZ3E3SEp4YkhUV3VxS1hvZHJieXE1bnQzSFExWGFGUXQzUnBY?=
 =?utf-8?B?bGVFSTcxeWtiSGN6Y2pJN3I5dXYxUmFaMnFrK2tXajhDU2xZME1kNDgxSGVt?=
 =?utf-8?B?ZVZ4bVJtTHNhV1ZiajhySGRQVXhxWlJOZmFORGxVUnlXWmZrbXI2RjFONjBB?=
 =?utf-8?B?QUlDazA3SjdLNDY5WXdnVXdPQWRPTEZGOGdGK1l6TmIrOHlleVl1NGFac2k5?=
 =?utf-8?Q?88IXWX4lMevYDT7IrH3tt22p78G4jzXT0XL6eJI?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a62b4fa2-a234-4b43-8c3b-08d97de0d5c7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 15:51:26.5005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VokTwhassqQaS7G9fqk0iizGZDbymvJbwQX+6CZX+2RTYy9dDVOUpkh3wbWjSAnuLxS85Y1uLEBhFn/9PwcWWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7183
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/16/2021 1:03 AM, Michael Walle wrote:
> On newer CAAM versions, not all accelerators are disabled if the SoC is
> a non-E variant. While the driver checks most of the modules for
> availability, there is one - PKHA - which sticks out. On non-E variants
Currently there's no dedicated support for "partially disabled" non-E
(export-controlled) parts in Linux kernel caam driver(s).

Up until recently firmware (U-boot) was deleting the "crypto" DT node
for all non-E parts [1].
Modifying the f/w indeed triggers changes across the s/w stack.

Since you are modifying only the caam code handling PKHA, is it correct
to assume that everything else is working fine?
For example: is the number of AES accelerators (AESA_VERSION[AESA_NUM])
being reported as 0 on non-E parts?

> it is still reported as available, that is the number of instances is
> non-zero, but it has limited functionality. In particular it doesn't
> support encryption and decryption, but just signing and verifying. This
> is indicated by a bit in the PKHA_MISC field. Take this bit into account
> if we are checking for availablitly.
typo:			 ^ availability
> 
> This will the following error:
> [    8.167817] caam_jr 8020000.jr: 20000b0f: CCB: desc idx 11: : Invalid CHA selected.
> 
> Tested on an NXP LS1028A (non-E) SoC.
Thanks.
Unfortunately I don't have a non-E part to test on.

Horia

[1] https://lore.kernel.org/u-boot/ff146322-e8c7-2418-ceb1-a3c0d4cee1a1@nxp.com
4eecc6f1a104 ("armv8: layerscape: don't remove crypto node if just partially disabled")
