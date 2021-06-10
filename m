Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46129C48BD1
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 23:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D638613E9
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Jun 2021 23:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFJXWc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Jun 2021 19:22:32 -0400
Received: from mail-eopbgr70084.outbound.protection.outlook.com ([40.107.7.84]:63601
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230103AbhFJXWc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jun 2021 19:22:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJsv+VKBpyyFfXsDrmdFDJVP/XT+FxVU3jJwsA6Tk+jNVW/jjo/DIfZnroHEdKsEp7YZvlNZH9319MhEikA/VW7FMinjfOSh8bVsKi1zLeiV8BmlXHR3rYUY6mUYN5saGlOEWgZUt/GX0IWGQ0jNNwuxMU90GWAYbKVlhjQaZnWBNm5AzwnLIuFqEaBn9uNK0QT7mkrdWZ3FoOmF0M514CDM5O1jI6ikRTdMca/qD8VPjTgjWM6Y/ITAFB4mhLgYDNmSo8f0clmD7qEvrokTb3APOzDTwp/S4VKYNmeRacHlPm/Gh99Ba0CbsTyzI1CPeISIuukOpGEn50OUCJ6QnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/aGmZpv7p5Zs+f5c7qcVSuUCxxMS5y1g5nC8qLwLCA=;
 b=B13loD+t8o2DtkAkaH8gq96YCtY3oTvdxH/NTb2LWJEmrzzrCSP6BCFhilLVGa+wXEbiMGIprxS/UZZyEseZ1JloSpCnP6aASTeEE9I77O4IensABYW2ko+v6lP2aplAOaYZ/RjgfxC1Wht4JpGAX9heAqKubg5TgjN6ArDIEf75+xKDCpIKiInqbA8N3MQtmYPNe24rl0KaJSp+eisnQW4qRfoSqfJnh8VnvRLXf0K+MHaRrHtOZEl33A9A1R/EwXj+xolOBoX2vvGynL04yzySN0yllrMLG7Ra1ix4R8ENOMsJwwPVtrOrPD33KkRtA9tT8DcKL4ySO3OQ6YHboQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/aGmZpv7p5Zs+f5c7qcVSuUCxxMS5y1g5nC8qLwLCA=;
 b=AmcLIgMuW7JWOC0hwaUwmGiIsKZ3J0xQUDW348tmDsEIbFDuor6O9gpoBb2SJPg+UzzxCSXVGeNjf3Wf27PXNp/fRhUJr0cvhPXGE5Uc95Ul2hm26c+cacHUT5S4sNlk9cp9mEXr48O+2apod0Jji6G8sK4FXHc20rXKFh4eo4g=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR0402MB2815.eurprd04.prod.outlook.com (2603:10a6:800:ae::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Thu, 10 Jun
 2021 23:20:30 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::e8df:8117:d230:f321]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::e8df:8117:d230:f321%5]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 23:20:30 +0000
Subject: Re: swiotlb/caamjr regression (Was: [GIT PULL] (swiotlb)
 stable/for-linus-5.12)
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        Jianxiong Gao <jxgao@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Hartmann <lukas@mntmn.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <YDkbCHHBUOmfI59K@Konrads-MacBook-Pro.local>
 <YL7XXNOnbaDgmTB9@atmark-techno.com>
 <2e899de2-4b69-c4b6-33a6-09fb8949d2fd@nxp.com>
 <CAHk-=wiKAdWpSav4+qYT4_LDSQm=7pO8RqKEoQoJsyDVtTCk3Q@mail.gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <ebdb8daa-e30d-3399-c081-af6b11caae03@nxp.com>
Date:   Fri, 11 Jun 2021 02:20:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CAHk-=wiKAdWpSav4+qYT4_LDSQm=7pO8RqKEoQoJsyDVtTCk3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM3PR03CA0058.eurprd03.prod.outlook.com
 (2603:10a6:207:5::16) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.213] (78.97.206.147) by AM3PR03CA0058.eurprd03.prod.outlook.com (2603:10a6:207:5::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Thu, 10 Jun 2021 23:20:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f1e120d-48b3-4a27-59ab-08d92c6656b5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2815:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2815E4D869F0C5239EE42A3698359@VI1PR0402MB2815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YScNVz0wOq3lHqCfaamLfWnDZ8iopBUJskGTt0bCfa004VCXW7ADrV8sVgW/WBGdr2+opDZuv1YmGYqV035D4Q/htQJ0KSk7uKP2Ab9sKP+kXil5PkUFSjsTQeBPafg0BBVyczJreUy4JEbE94zmdhM2ygoLu2FCwYN4F5tJwVGSjKfBtw1DfvUYVPwNQXzoQhZOMqWLurwyv6uycFdofxVbsn/mC23Wfvxan/MCA04cwiD7yIcCpMEV3GQhQ2dQTPHQ9L5EuyXXEDqEiQ08QQuaYVdhh2tfjBG4/vrTLVJRYFBX4z42ub91AQRfiMThujQ4jeHdKRB8xA+TYMnpPXW47fyNCebeZX5GlHgpRQMfWMvb5GI/0pLcmekouKefdkUmejmVzWsjDbeEnN2gilXIk0bDRGOsKZfsB+WR+cHbRcSg+tWb9s4UdDNuxAroeQWxxlLUqfBQaVEr8M5PIe9UjDfZBsappjB4W2MShGQwFy9bUbpRzcqiQSUuiRDWi+BnojSeQRT75+t+yNWOs5+OAJ/GxWx6NMuECFhQqpxDWljM1VMiLu9SmkX4eBlJk9OPKOP4CqprbIjOlznl0Fo1DAPzpejNQVXYba57f/aapWhrSdupI+lya9p6DEpVhsIHXUjXq7Dhe4Czd9AzPkW1a/akIfU5ux141KLxr6P+11o1zOHydt4kcnsVYS6rrg2lJL3jDiZk408yCXLyVLmH66P/wmgNPAbpbbaGJyw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(31696002)(186003)(36756003)(31686004)(5660300002)(558084003)(110136005)(6486002)(6666004)(2616005)(52116002)(16526019)(54906003)(26005)(7416002)(956004)(8676002)(4326008)(53546011)(66946007)(16576012)(38100700002)(66476007)(38350700002)(66556008)(498600001)(2906002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?elZhZTYzR3Q5UVhqU2RnSkdRMnJNN1ZWSXpRdUtqUHF1TzkvSkczNmtJOVN0?=
 =?utf-8?B?ODN4cVZ3eEFuMVFUZ3VYaWoyV2Y4ZEpuSmVRaDRMR05Zb21qMzEzZTR4T2hn?=
 =?utf-8?B?U1dacGQ1UTdhbU1rbUErL1BKa1paOXErQm80OE90QjN2cWtCcGI4OHVlazh3?=
 =?utf-8?B?TU96SnE1dEVuZTFXaE9ITXJlMEg5ZmFrcjZZbngxMENZUkxhVG5qSWRLdUx4?=
 =?utf-8?B?K2FEdlFXUUJrWHphcmhnS2pnNE0yQkt0YmErN25OTkdyanAvMkt1c2JGb2FD?=
 =?utf-8?B?MisweGh3Sld6STJkc21aTktIMzBPUFdCRWdnMmJMbnNuZnBIK29kQVRmcXZE?=
 =?utf-8?B?RlJ5RU4rNnhBR3VZanhmaHpZUTJZVVYwb0xPT0V2R2kya1ViNy9KRWt3NE5s?=
 =?utf-8?B?RkpabHd4a1V1OTk2Q2w2SnpnWnRucFF2M2t4ZExKTGZ0YlVSS0RRUkFpejYx?=
 =?utf-8?B?c3c1aVYzbitZeUpzMjdvUlc2NG5PSFlqbVpLRUlUNDZIbFZwQVVGWm90YW41?=
 =?utf-8?B?S2U4c2RJcGJqSUJxcUJDbDJPVXpOSHVTb0JsbUZSTUtnWm0yd2pNanJ3eFll?=
 =?utf-8?B?WG1MeThqVXR6UXBUZVRzWGlaWnJWYXNjYWNqNUdoeVNLT3hhSjJkMEFoNm9E?=
 =?utf-8?B?YUhUSzZMdUR2ZTJzaUpiRUIvbnNpUGxkSDd0SnJ2TG5VckhFRHdXdTlnTWpU?=
 =?utf-8?B?amdzSExRUEZxTmlKNDlFWGpYSUdZcHRUZkptZkdwdk8zb3FaUlRPNnZ0TDgr?=
 =?utf-8?B?MGM2NXhxUzdOZk1WWngzWklKNkkzeCtFN05mMGx1RXMxemR0ZFF1SVU0RE9P?=
 =?utf-8?B?c3hONE5mVGgwMHZOelFiL1AvSnVPY2puQVorYmxXNEE1OU10S3dlcDZnK1pB?=
 =?utf-8?B?czI3Q1NGeFhWeW1mMHJjYmFxcWNiYWJJRlNTOGVsa3pnL2x0U1l3WmI3ekJY?=
 =?utf-8?B?R252S3I4THcyNUd4b0d1U1R4MW9aRloxMkxQNFZ4MU9OcmlmSmdHL3BuU2Er?=
 =?utf-8?B?TjVqN2JPZVRHNDkwYlNYWXFXdFlHT2dJWlo1MW80dHB3MTZ4MWhSR05wWDgz?=
 =?utf-8?B?MHVEM1FXUjUxWmFFaVBvMXorb1BPZUZKOUcxTlg5OGpPK2tuNWJONnI0cHd4?=
 =?utf-8?B?S08yWXR5dTl6QThSUEZ5MTh6OVBLMWFzVXBaYzJPeThkWkUveWdDZzlzZFNt?=
 =?utf-8?B?bkJBUjE5dUNPVEU1SEVGeE5hOXJqazVkcTdESHB3WkwxbThVR3NGWUkzSHJ3?=
 =?utf-8?B?N1FtbExCakx5a1l4WktrKzFBOHJISFVsaW9hOFBKNHpCMzF0Yld3MXZzQzY2?=
 =?utf-8?B?a2dlWmJscmh3V3Z6Yld1eE4zbXBvR1NKd0VNemtYOWJ4Sm90aDdZVG1ENUI3?=
 =?utf-8?B?NTVkT0Q0SFV2bTlnd2V0YmRkcDR0NTdOUUVzbzdPWmJkcWlyQzAvSTJRc0cv?=
 =?utf-8?B?THhSMnhCYmVxMlBQSnVhazUxVm9YUWxoMlhYSGdoUFlDVFkrZGpNbVNkeVdi?=
 =?utf-8?B?b1BTVUtlWWtWUVRZOWFwWFBlZ3c5bDZiVG5aRTRDSHJRVzlpRXJUb0lKVXJr?=
 =?utf-8?B?c0VORWdkYmxpb1JiZm9NdjhSbHFpSndUcGpETG0xa0tDNmx0TTFJaytuTXht?=
 =?utf-8?B?MnZmQjhzUHNSZ3ZCSFNQR21kUGVQczBJNjE0VkhGQW4zTm8wOFBKVTZEMTdk?=
 =?utf-8?B?Y0hoRWx2clU0L0ZZZUc3VzArazROS25rUlBsUHNBU1Eydy83YUpVK2M3L2RP?=
 =?utf-8?Q?M/fHuXEYi/7OhJI+EbF2pBxn1tFsDbaa1xhFWeo?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f1e120d-48b3-4a27-59ab-08d92c6656b5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 23:20:30.7634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qpHe4ER8EDU16OlM6Xj+x9NuMmWWVm9z4rTa4cLHzN5mnQzozmAWj8V2aTc6NEKpbF76mOIw7SAQKiYNLSdUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2815
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/10/2021 10:41 PM, Linus Torvalds wrote:
> 
> How about a patch like the attached? Does that fix things for you.
> 
Yes, it fixes the caam driver regression.

Tested-by: Horia Geantă <horia.geanta@nxp.com>

on top of next-20210610.

Thank you,
Horia
