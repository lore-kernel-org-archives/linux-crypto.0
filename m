Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E48C64E8A
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Dec 2020 14:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AD81221FB
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Dec 2020 14:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgLBO3B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Dec 2020 09:29:01 -0500
Received: from mail-eopbgr20086.outbound.protection.outlook.com ([40.107.2.86]:42574
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727843AbgLBO3B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Dec 2020 09:29:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1j1Jt7AtHHdMyqCBwYbmyEWJ2tOvIqzoBADzJa3wKVJBQ2rrDncG/513Gfg+lM9poYDf3HVWTp5/bAHFH9eGjlmnCu9fA+pQlQ0/saWCSY5wA5Cc8YUZNAzVQyOx+ynsfHmjSCAgYM0TRdPjQ+05/rBzUVBNLaEXSMheFRsJvU70Zgk8lnyTZZ/w8ickBb20Ntuk8DjAQas/kgSNxMtgH1tHji1ILf68LjX6VHUUGo3EIyYcDqsYvmdRwHJTjWDXYt/4UDafK/XWYJzlfImcdsRGqIPybNzYkWQU+farV3jLCDs4PNe+YgjiWSqnDjerrZ/+yG/bxAFVG+0mfWdlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiYszWI0OZj+fFrWq4yBYpZ09hxAM+wBwovAnnm58eg=;
 b=OrW85xywwEsNr8VgPq1lV/uibzWjYN0TOLMhGm/ewleaxnZ/b5vvL7WKNiDlhDH0R6gqlNQDEGs+KOoUuD85jgGRT7qHH4OL5O+ZNblOfehCUQjGDVI84yhHjtSO0njOrzeAYFONgfE4ykzIYybno9Ne+sdl8A1mqoLE/NpWpMEPcPAmEtFweeDvnTZdbZGKq1suUWiRnGlNSWov5rgGizp9lFBnJCsm+19/HIr219ZgODwy1sFp36wP4HFbZYv1PWZV3VbrVaDRxbwAQTF5Z8CBXKhPVlHUjy+OSMvbooon7q2HMv17O9BYBEirqZjeiS0TNsLfDNxqtoQAFvYQDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiYszWI0OZj+fFrWq4yBYpZ09hxAM+wBwovAnnm58eg=;
 b=MSSM8KXBUHvaP6S2Z27A67Ukvng1vYmVdipMyqkbWXFV2Nm/GXvOtMh4Ce18DNR9EpfyADoA1HovWqNEZB5FbvkFUpb3s3/Si7eikZIS7eaXUMNuYgIgMdqzR3U57yAgKqobtS8Ag0KOMiuLOR1HEL568l3ebcO3IKQjy3QkucE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB3136.eurprd04.prod.outlook.com (2603:10a6:802:10::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Wed, 2 Dec
 2020 14:28:11 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3cd1:fe15:f8d4:ac32]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::3cd1:fe15:f8d4:ac32%5]) with mapi id 15.20.3632.019; Wed, 2 Dec 2020
 14:28:11 +0000
Subject: Re: [PATCH] random: Don't freeze in add_hwgenerator_randomness() if
 stopping kthread
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Stephen Boyd <swboyd@chromium.org>, Theodore Ts'o <tytso@mit.edu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Keerthy <j-keerthy@ti.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20191110135543.3476097-1-mail@maciej.szmigiero.name>
 <5dcee409.1c69fb81.f5027.48ad@mx.google.com>
 <415922ac-3c87-081c-6fdf-73fc97d0f397@maciej.szmigiero.name>
 <20191117005641.qgremf2lrj46qy4p@gondor.apana.org.au>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <2f581f84-378f-05cf-1902-f0494aafe706@nxp.com>
Date:   Wed, 2 Dec 2020 16:28:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <20191117005641.qgremf2lrj46qy4p@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM0PR05CA0078.eurprd05.prod.outlook.com
 (2603:10a6:208:136::18) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR05CA0078.eurprd05.prod.outlook.com (2603:10a6:208:136::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Wed, 2 Dec 2020 14:28:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1df14d43-78b5-4187-5871-08d896ce7eb6
X-MS-TrafficTypeDiagnostic: VI1PR04MB3136:
X-Microsoft-Antispam-PRVS: <VI1PR04MB31365091668427A047B9962398F30@VI1PR04MB3136.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jYURbm0kjxdnC+VAuloRonY20lh9/+uEE7cDrt6Zm6KGDQcYkG7nSJXof1LYpFC20VjBdV0lVTBY93NmUJMVK6GXsCaeLhAae3JqRf9LgGiqLeAHnVtA8yJYdrENUP6yjdptIEzBNBNBAkdam4mDr3zzgFbs1UvLa4C1jdJhyGrMe1tQu8QcOcCOfbURS4EBYu+e1zQcQfjZMlRr8DX1eZc80XpniOvjHPm9JZuOMBrwbIeHUaslXoicJo9XowirePE51+0IN6ndQ8vyKLxr7cN/M6itiyWR1NCZ0j5uroN6aQFlyYuCZ2ImINfHSB7NzjZVtGjAk2aCuy7WFlS/ACfvEP25tCe4aw3UqSIBdLA2Ye01JPQTRgcUlG2vhpf0lamhVv7xG5Csa1KOTzy22uPSVWSwS7iJuRJ6BTT5nxk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39850400004)(396003)(376002)(346002)(5660300002)(66556008)(956004)(83380400001)(316002)(16576012)(2616005)(110136005)(54906003)(6486002)(31696002)(36756003)(478600001)(7416002)(8936002)(66476007)(52116002)(2906002)(186003)(66946007)(4326008)(26005)(86362001)(31686004)(8676002)(53546011)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MlV4Wmd1OVpDc3NrWnZzenM4cHBTY2ZJR3ppd3U2YXJHczF5TzhnbkNnZGdJ?=
 =?utf-8?B?dkNsYyttYUJvZERUQXljZktHN2FTWjYzeis0eFVaY1VHZFRZMDM0azFBWExW?=
 =?utf-8?B?bHBJMnJqaVF2VU9sZXRlcDhleVNtems4YlErRUNTbktOQVh0VzIxQzVtQWhS?=
 =?utf-8?B?S01vVnc4YWkzemEwcElQci9UbXhJKytUS1dCS1F4SUx1NGpFTXlCTWtQTHVn?=
 =?utf-8?B?akxMVDJmQURHRW9LS3pPMTZXNlAwWUk4WVZKVEFlNk1IZ29wcDBxaFBwSWRM?=
 =?utf-8?B?eTI5TkhjNTRpWlIrZ0pXK0xDcWoyWlZtb21DRGdwaDd1MU1OalQzajNCWDBI?=
 =?utf-8?B?VytOaEhTMlYzYk1EVW1FVTJHdWhnS1hsNE16SzhNL05qMFM5U3dLbzFtcXdT?=
 =?utf-8?B?NnJkMnpnWHdTcUsvTTdXbDBUeDVkRmc5RXNVT2h3SFJEVldENWcxdkNUN20r?=
 =?utf-8?B?bXFoK24rcTVjTDJoeEN5QVYrWnI4UktYejJQRHo2SlNBN2xrVFdZcmJJczRw?=
 =?utf-8?B?akFNZzlLNTkrSGtadXcwVXhUeU9IQVErc25sT0xGVUR1R0hBMXZ2QkloQ0ZS?=
 =?utf-8?B?MWlzTE9aaGZYWHV0YUZaUU9jOUlydVp4N0liL0tjenp2eEZXaURmSTFmQzJm?=
 =?utf-8?B?WlZILzNyc0dnSlBFTE1kTkpwMlU4NEJ3N21JNkpnQ0Qva2ROa2hKNXhhY1hp?=
 =?utf-8?B?MmJhbGo1cTBoczhRSWZjVlpFZHFiZnltWVJmU1R0eURTM0VHdlBDQU90bzhT?=
 =?utf-8?B?MGJIajlPMUlWQzNWcWxoa2ovMTRSUGF4K2FvWlpDSE9LYW9NN1p6MFBTbzF4?=
 =?utf-8?B?MjUzSStOM3NUemEzOVUzUFMrRXE5dWJBU2NPM2I2WW1BR24yYVBKM1luMHQ3?=
 =?utf-8?B?OFFJWmJoS3cxd3ZyTzJqMjF1SFJhcGovZ1RUM0taSmRxSCtvaEZCNVBIZTZ2?=
 =?utf-8?B?a25sblZVSzJoMm1RSk5wY0RoOHJXeFlMalVtckVXbk5ZY0FvQWc3eEZ4a1N1?=
 =?utf-8?B?bFNPZncrNjV1cDZjcEVjRjdHdHRpaHprdXY1TDV3cDZzZDFlb0MyVzJFaHkx?=
 =?utf-8?B?bzdYeFFhSCtlVVRiZkI0QnJSQ3lCdEhnOTY4L3lPK0FMQ1RKc2krRVNFeXJj?=
 =?utf-8?B?WFFmaU9ZK2REY05zZXc0TW1XRkthYVlrRXlsZGV0cU9nYjNKb2lLVnJlUi9l?=
 =?utf-8?B?M1BwOE5rYnNabE0vNHdQQlhHdEFsL2xxd0ZlSU94ZkdPQUVNeGE0QXF1RGww?=
 =?utf-8?B?YzJic2tHa0hXWnAzTncycjRNOVR2Z1NXUlJQQS9uN01Mb3EzaExmQzJUWFYy?=
 =?utf-8?Q?u15RLLc4ehlMdEjqhDGXt+UqLYQPDGtRKV?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1df14d43-78b5-4187-5871-08d896ce7eb6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 14:28:11.1840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jzmis0f3OWo02CfdxErtwD1Pc6HqtGjXdFnXNmpU7ogJlVAR7BRj2AZ3Mbgu9DK7fk2g6Qbrdtmc0ECbAo5kvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3136
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/17/2019 2:57 AM, Herbert Xu wrote:
> On Sun, Nov 17, 2019 at 12:01:20AM +0100, Maciej S. Szmigiero wrote:
>>
>> If a reader (user space) task is frozen then it is no longer waiting
>> on this waitqueue - at least if I understand correctly how the freezer
>> works for user space tasks, that is by interrupting waits via a fake
>> signal.
> 
> At this point I'm just going to revert the whole thing and we can
> sort it out in the next development cycle.
> 
Working at adding power management support for caam crypto driver,
I've stumbled upon the issue of caam rng suspending while hwrng kthread
is still active.

For now I've fixed the issue by unregistering / re-registering caam rng
from hwrng at device suspend / resume time.

OTOH I see a few commits:
03a3bb7ae631 ("hwrng: core - Freeze khwrng thread during suspend")
ff296293b353 ("random: Support freezable kthreads in add_hwgenerator_randomness()")
59b569480dc8 ("random: Use wait_event_freezable() in add_hwgenerator_randomness()")

however they were reverted a bit later in commit
08e97aec700a ("Revert "hwrng: core - Freeze khwrng thread during suspend"")

I wasn't able to find a follow-up on this topic.
Could you advise on what's the proper thing to do going forward?

Thanks,
Horia
