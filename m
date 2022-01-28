Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A62A9C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 07:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345859AbiA1HoW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 02:44:22 -0500
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:47844
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346790AbiA1HoN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 02:44:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeYiMizfE1hCvFKp5DrK/7EciKkgkyL7i5CIGz0JZOrLTW67fKGjWvUEy30aKvO4NgwqWB+eTPiIoh3XK6WxaE/jnnvgBWMwDWeFm3zHfvhsCIN5sLBOu1f8r6Bhf6K2tV6jzvLqoEXi4BbtQaffNEHTFj5JaU5c8wWvUmk6qomnQMrJkrqv0BhfNDPdd9n/GL/0WPxSLzGdS1h4jZTX/s9kEnwXr1+6SQZO1J2+S9l7RJcav8ydODN4rsS91qgEGQpRp2g7KslmMxr4clyVjJVTV3DZRG/HwzP1+JWJ2Pw+NlDcMtiMxUiZVBXaqDXHewEyL5BmDQaMqTox0XM3lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zmyFl2hAT+w81tD1eRjEdZwiqIJPkSusheowJuea7JA=;
 b=IDg69TRumpRDrbL7e03CnqwPdJiET/kzhovAe4pokovDwLOuFVnI7PI+P00o/v1QQCrfY9hg8hRrHEgAonC/scbqnRBQUCZsHLRnA9LBYj6Pul671CcEmXGx9PEtYjgWqr4s23NX1B9FmASOD2l+KRKfLFvlGueQ9/OBqJAvdnGm/TL9eDiSYHaAJwbPTF7zfUQ/CINJzOBFW9Ybou9/MsdAvh7drBnXncOqWqT9gpsiU9Lm7fpd8JkItygXpcLNUEaR0Z//D9NQueUpQBuxaCYQz2W0KgqUI+nE7rbpsTNc5HnU9eZPZntDAe5+at3kkTo62QyQmQ5qCwxMiSRYZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmyFl2hAT+w81tD1eRjEdZwiqIJPkSusheowJuea7JA=;
 b=W+wRLmNT1fdFRt/cgkUPrRMGtv/6Hvq6OGUnxOUZbwl97RJgOwrFsfZAQyNDgyGlJYs5txXdEHNjzxqri8K+W7rRVSQ/NE6f09AWrcHX5kJIIfZ4OG739cs8YzxDYCqxpBNkXxGHKcPAwfxZkr5zPwlgd+5qlwZvl2jbm+Klql0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by AM6PR04MB4487.eurprd04.prod.outlook.com (2603:10a6:20b:23::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Fri, 28 Jan
 2022 07:44:11 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4de2:963a:1528:b086]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4de2:963a:1528:b086%4]) with mapi id 15.20.4930.017; Fri, 28 Jan 2022
 07:44:11 +0000
Message-ID: <ee43a9f9-3746-a48d-5615-b9f4166eaa46@nxp.com>
Date:   Fri, 28 Jan 2022 09:44:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] crypto: caam - enable prediction resistance conditionally
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Fabio Estevam <festevam@gmail.com>
Cc:     Andrei Botila <andrei.botila@nxp.com>,
        "andrew.smirnov@gmail.com" <andrew.smirnov@gmail.com>,
        "fredrik.yhlen@endian.se" <fredrik.yhlen@endian.se>,
        "hs@denx.de" <hs@denx.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
References: <20220111124104.2379295-1-festevam@gmail.com>
 <YfOL3Yxvb5srGKp4@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
In-Reply-To: <YfOL3Yxvb5srGKp4@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0202CA0004.eurprd02.prod.outlook.com
 (2603:10a6:200:89::14) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fecd3f29-c753-4244-5d74-08d9e231f91b
X-MS-TrafficTypeDiagnostic: AM6PR04MB4487:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB44871A232F9994894BF7B0BF98229@AM6PR04MB4487.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7nsmMXJ9WTVCLCZzROfS3aA7Wy9aXvoqIJqNtwpFPpqsd56vxHZy6A7u+VeFl1vhdVHoOsUG/5nmSyms47rbkBXgpnrlNsti3sSsj8fY9aP4P20mocGjxT8BoXrPovsWzRgiRJ+nS7mhK8+Kvul8e+FVHzKJwSBQvNQRaAa6UhJS26xqkohcfC5FMhn7+EnoXr9vOnSqwZZVdxszYdz5wdL7yLm676JYUma0zipDk01PM67Sh3j76VWPzZKEtyVOWODtUQEy2QSJkMETef/E24l4exdz7pcj/fBCCI978JfDlf7teRIs/ZhH/wtIm1nFG4fG6r0k4H2XFxgJRENI2lCVgZw3pmZWDBhqdpCuyIxW/ruAVXC15OxPyZvRJghmVa2mfr+tLCxiXxMXtdA3OKNxwFxLAbsgYGo6PhrPccj6qKax8uqb25Ba1X1TQWn1wS1defbAFl05bLThC1skZGk7EnZXpJ4XSCQFjxgXRPg6fS3py0RKii3hACAJGraZqvQOZn3RKIzOaeeJ4/syjNgzDGfLBLlTeuUy0Qfe1n6IMFvbQIsOiOHm5ESPyWeIF+zsuNhzFWnPlfMsDt3A39G4B1/0umj2REQ+OPYEiaNuts/p3klae8umX71X7rQ4CSqOqiGPu1D7oRZtz/GlUt+ZdyROYC2N6AkKOBGipQWuIKo4vWVPJ2LrFi80L59WfDsX/xWtmNC7sZZQt0hZQWekiaR7g2ylmipwEBi/fsrHl5sF63jlKeQtAehQcRjb8RZOusowSBybVYHqVzBD1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(83380400001)(508600001)(54906003)(110136005)(53546011)(6512007)(6506007)(52116002)(86362001)(6486002)(26005)(186003)(31696002)(2616005)(38350700002)(5660300002)(36756003)(31686004)(2906002)(38100700002)(66946007)(4326008)(8936002)(66476007)(66556008)(8676002)(43740500002)(45980500001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTNNaUVzQzRPOWxjRzBicEtFaXA5TnRMa1RhVVlqVWwweHRXaVBYYnJseVoy?=
 =?utf-8?B?V3BkblhteVJOR1ZsVDNvcmdVbWs2NmdYZEFlSlhUaVk0SGRJUnpvS2RzNWho?=
 =?utf-8?B?ZklJeHZ3VzhHTWdnVWx4ZGZKV0NrZGxMR0Z4bWUwUnFrY2xKeTAxTWFoREdh?=
 =?utf-8?B?dWFkYVIreG5YdTNoNXZQb0FXcE5Db25LZ3RrWmwvUHpnZFNvRWZXWFhKckht?=
 =?utf-8?B?TGQrVC84OU5oZFJhdDVhNU01b21ra1VtSUo3YjJNQUFZWU91R3ZnMGNJM2ll?=
 =?utf-8?B?OGJmWitMR2NaR0lqL0lIZ3VrOFNLaHhKaVhXQzdQOTdqSktIRmwvUnBVa0ZM?=
 =?utf-8?B?eGloL29pc0UvamV4M1VNY1BiUS9CeVFyUURaZE1SUTZMaURScTZldllEVWtP?=
 =?utf-8?B?MzNVOTlaZFJ2VE5QOWRCc250T1NCRnh4aDBBMkFXc0VXamlsNDBtZ3ZmL2s2?=
 =?utf-8?B?Y1pHdWJHQzZLMHZkSjh1STVJUCtEbjFvbE03ZFZDVW4rdjJXL2hHdmNMQ1RM?=
 =?utf-8?B?b0RQRHFaS0FqUDBMcEFqbHVKNktPcy9DMTJnN2VuT2VrN2YzcDB4S2JzR0p1?=
 =?utf-8?B?NC9rL2pSSlV3TDk2ZWJNTC9Db1dYaTFSMTRIeWN6T0hWa2hSQ3l6RzNNTGto?=
 =?utf-8?B?VjdIQnRzVnFhMGZzS0RVQTV6cWkvQk5WeGYyMmdPK1ZwTTExbUNzTFJNaHBO?=
 =?utf-8?B?WDdTNUs0SFJHUk9SMDZuRmNDQVY2cGZZSDVWNnIxQ01RWlFiQmlFRVZKL2VI?=
 =?utf-8?B?SHRITElCVlROMk5WT2RyRlNWeDFldytQK3RidDFIWmNWSVBsTC95UVM2eWJW?=
 =?utf-8?B?aE1KeWhHNzc5Nzh6QUx0bFpmNkk1YnlMQTNFMjkyQlhOZ29pVnowd0IwbFVk?=
 =?utf-8?B?RDBpaE5ZeWdiV0Z2Z0l0NGhOUFRVWHljd25Ya0REVXNSSXhaVC9nZUw4emFX?=
 =?utf-8?B?cERld1FTanE5Vkt1T2lQNS9QTVVzRnZpZDQvQ3hOZHVwdElpVFNwMFY2ajRD?=
 =?utf-8?B?cnZEeVBIYksycmdTd1E5T3p1Zm5lUW5hSTY5bmdHaW15YzJYMTg4RDVKZTBp?=
 =?utf-8?B?WlE0d0gwczZid09DYU5abEhPZ1RrZ1M0bXJNTGx2ZHY4MEIyUFNDRTRoZzVT?=
 =?utf-8?B?ZTNrREpRMFJ2Y0FCeEsrTXFFbXhZZmk0RE4zdGtQUTAyTWp4Y213d1FXbHk5?=
 =?utf-8?B?bk9XNC9vOW55TWp1aTE4TENIS2w2MExWMlpIcXJ1YS9OSEFUdW45M1ZtSUhl?=
 =?utf-8?B?UXhJR1FIVjVjMTM1NWE5YXdtS1YwSUY3N29ML0pYemZBNlh4NUhTQ3JYTlVa?=
 =?utf-8?B?Y2xYdk5NWXNubFRDa21udEh5czZBM0tWdTU4WDdpMksydWZJVThtMWlic0ZT?=
 =?utf-8?B?U3RkSzlZYnRMMGljVDBXaStiZlhtWmNuYzdRK2ZGMUZoZkcyaHM2Wjg2SGZQ?=
 =?utf-8?B?d0M0SmRWLzVieTBmcGlMMjNyR0RGaURVNUpISUtoTloxOVlYTUlRMjBlMTJm?=
 =?utf-8?B?ZEdWK2NmK2FKcmx5ZzJ1aUUzaE9DRCtHaWNWbEpXTEFyelF2Qk1mTThXd0Va?=
 =?utf-8?B?Y3pRanFRNXpDYlhSK2c4djdXYmJlQ29VWTlzbXBacExKSVRuQ3daNVViVlJ4?=
 =?utf-8?B?cW11UkdGM0FOUnFHQlJxekFxZVNiM2RBTXdWei8xMkhHWUJSM1BmRndXRCtw?=
 =?utf-8?B?eFhKNkNHOWJDTFN6VHhTZi9JTmpGd1NKdGlGOGVGc04wM2xLZlNkbkVPVUNw?=
 =?utf-8?B?bHdibmdpMlZUTllRRDJGMVU2aGNJWXR2VUN2MTRyOXd2dm5TcG9Yd2ZGVk55?=
 =?utf-8?B?L3U1WitTL2VsbkxzTFlQWUhiN25jQ0lLemJDaDE5TXhtYjdJV2xmQUcyREZu?=
 =?utf-8?B?VnZVcDJ1UkdjTWEwZ245SkQ4TnNrMXZ4d0FpTG90Y2Jna1ZPWXZFMFNMR0t0?=
 =?utf-8?B?M0Q3anRtQmxZVEY0RWlJdkFHcG01TVp3dU9YMGlQa1k3Q1k1WFFzRlhJWk50?=
 =?utf-8?B?a2NPa1VnbEx1ZzAzb2dTYnhiWHFiam1DTzA5UlFzS3hoK0pHUE1OeU9yZFh3?=
 =?utf-8?B?L3ZiRWEzWFozdHdRd29NN2FCa2k5WTFlcVpDVWoxQk5yREp5bnFjZTR2TG9v?=
 =?utf-8?B?Q01QSlhPVWlBMmVFOGdCd3dDKzk0VDJpa0hXb3dEV29wVlJGVjdhVkZQS0hP?=
 =?utf-8?Q?PRsclVS7D36kTUyR9BEPQpc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fecd3f29-c753-4244-5d74-08d9e231f91b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 07:44:11.1637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bWRY2ikJFrJOPvUGlnAg/cTuO3vLsGsqC3CeXsrj6JDvj0j14zv0joxK7ACmTE3RfV+2wnl/fgl6TReATaNCQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4487
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/28/2022 8:23 AM, Herbert Xu wrote:
> On Tue, Jan 11, 2022 at 09:41:04AM -0300, Fabio Estevam wrote:
>> From: Fabio Estevam <festevam@denx.de>
>>
>> Since commit 358ba762d9f1 ("crypto: caam - enable prediction resistance
>> in HRWNG") the following CAAM errors can be seen on i.MX6:
>>
>> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
>> hwrng: no data available
>> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
>> hwrng: no data available
>> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
>> hwrng: no data available
>> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
>> hwrng: no data available
>>
>> OP_ALG_PR_ON is enabled unconditionally, which may cause the problem
>> on i.MX devices.
>>
What parts exactly?
Anything besides i.MX6 SX, S/DL?

>> Fix the problem by only enabling OP_ALG_PR_ON on platforms that have
>> Management Complex support.
>>
This limitation doesn't make any sense, it's too general.
Only a handful of Layerscape devices have MC, so all i.MX devices and
most LS devices will no longer have prediction resistance enabled.

>> Fixes: 358ba762d9f1 ("crypto: caam - enable prediction resistance in HRWNG")
>> Signed-off-by: Fabio Estevam <festevam@denx.de>
>> ---
>>  drivers/crypto/caam/caamrng.c | 15 +++++++++++----
>>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> Patch applied.  Thanks.
We've been in contact with Fabio and we're working on a solution.
Now I realize the list hasn't been Cc-ed - sorry for the confusion
and for not providing an explicit Nack.

Herbert, could you please revert this patch?

It's doing more harm than good, since it's making the internal CAAM RNG
work like a DRBG / PRNG (instead of TRNG) while the driver registers
to hwrng as an entropy source.

Thanks,
Horia
