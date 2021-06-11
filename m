Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47006C48BD1
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 11:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 329F461246
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 11:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhFKLB5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 07:01:57 -0400
Received: from mail-eopbgr140051.outbound.protection.outlook.com ([40.107.14.51]:54089
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231381AbhFKLBj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 07:01:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnVXnQWXkQi3kNiP5B1YRGNZWDdgrZVzAdFGMIphynia3r0FutcwFMtmdhb+hWC1cjQxhDNOgPdl4QwQZfAT5ERaBsa4vET7Bw2RkD4HdoTFtwNgwxuJ0JiDh1dkE/0nF+oj5GRLddCZvZ7lYm92JexSyqUwumTzydjOsvrQhXal69dwJapH8HrGHZXNqXhFE+hfL5ronYYeca3RIZvr1l9jiuxblOsR9W7XSUA/eQz192+jtDjTnpPD5cD3V7U/PaSVpTieu46bBC5s++jA1MCuWATOLBk/FTFNazJAkcqdhvZdLAT4URK4QYND61hwjHAemH1Imi1pF2Gaac1bTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3E8Nmy2UfieGHnfdu8p9LdyQGZUbeElmzN6iIfdiB8=;
 b=T5DgQYv4HOF8eyBMQ+0sgfqYRlNrwNnyv+AZgj3HDonJdrjKGHRn1rxhwkHVVsXfMphoLwnUgGP5Wk3jOcnIy0WFvCksu5RZHhlmv9Lbxsppe3tOxihGJE+FNfuYdwUo13DE/t5WfvkBPiOhpUIhtsJ055sFIxuArF0/p3i5eQUF08dWyum2JV5O3g6D5bWwweQYtYhV3yF6a+30nB7Fah/otTdHtUInBsSF3tW9xI2g3v//BbTUajmCOAUz0UYblSW3rTgGI2+UJq6P6py8xGy/lRGUWO5QYgNiAFywdo97mQ1M0a5J9l1hymaCGHh/NTVFJjduiUoJW1s7Ux3jUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3E8Nmy2UfieGHnfdu8p9LdyQGZUbeElmzN6iIfdiB8=;
 b=s0z1VWAr0ZDtNayKlyBxBt/Me4dcga9jEkQXc9m5lDKK0jGWgus9u5KFG4IG+4TmPdu8B7nhXwa5o3dIUJyziqDAky64jQLByRekukhBsuqyOemQvwy/IbTnWuFk2YXoUgYP7R0PRfL+bSlbMUtryzt+kMclA/NqD6dkf8UyHYg=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VE1PR04MB7344.eurprd04.prod.outlook.com (2603:10a6:800:1a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.23; Fri, 11 Jun
 2021 10:59:40 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::e8df:8117:d230:f321]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::e8df:8117:d230:f321%5]) with mapi id 15.20.4219.022; Fri, 11 Jun 2021
 10:59:40 +0000
Subject: Re: swiotlb/caamjr regression (Was: [GIT PULL] (swiotlb)
 stable/for-linus-5.12)
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        jianxiong Gao <jxgao@google.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Hartmann <lukas@mntmn.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Bumyong Lee <bumyong.lee@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>
References: <YDkbCHHBUOmfI59K@Konrads-MacBook-Pro.local>
 <YL7XXNOnbaDgmTB9@atmark-techno.com>
 <2e899de2-4b69-c4b6-33a6-09fb8949d2fd@nxp.com>
 <20210611062153.GA30906@lst.de> <YMM8Ua0HMmErLIQg@0xbeefdead.lan>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <407997cd-dfa0-7b36-fa12-2baebdfcfff7@nxp.com>
Date:   Fri, 11 Jun 2021 13:59:36 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YMM8Ua0HMmErLIQg@0xbeefdead.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM0PR04CA0128.eurprd04.prod.outlook.com
 (2603:10a6:208:55::33) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.213] (78.97.206.147) by AM0PR04CA0128.eurprd04.prod.outlook.com (2603:10a6:208:55::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Fri, 11 Jun 2021 10:59:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44768021-b992-4394-c136-08d92cc802ba
X-MS-TrafficTypeDiagnostic: VE1PR04MB7344:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7344AABD54ECC607733D2BF998349@VE1PR04MB7344.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7B9PLo8Zbg5cUtCWU491+r92y6lOlfdJECZjFXTQgQPzDoGEy9mjqwD+At3ZeTmI1TcebuycPt1YDgoVlFJ5N7AFEjnELHhQARqHPXvOLSnZdh4kLlTCBwywYMSuVy4BH+a7rJmYmM61z6myNbu2cm8pYLA7C8Y5gK1xkeORM7qDV/xbCXMxV+ulOB4j1v+R/z1b2zVP2AVI0CJu4Sv33jwjQjQ0GKuAXt1tjmXyEOf3OUJ/PyAlDaICNhPMPUBGsJPKOe0PbRyV0Bc8TrpQBZ5DiE5Ag5gKOwzUR9z/qv12tQ7xNVV5deCPrESI8e6uVlg/jhA2wm2BFe+ND9K6HBOLtcfT6MV1m0GV9IxhQuzPveQUYOIWMX6twKEsA7vcmtrIuYz0x5WW8TiY/ND/qcEjMGNESTDNnntCIRCWMmIvhEfL1JjERpvw/bqY8lzOZr+SPJvDkdqvbwPNJScITUPLF0bzjhAnf7huRt8T/QLe63cK0h+4oDYVGlZd7mPpkD66b/G+nSPymV0QnGhAPzXuV722XA4pYUORyC2uyCTKFgFuCWHsoXJbhI3Gl37Pb8jgDRdK+o3EmKtjvbOoaGlIL7MHqaJvla1T4fTcQd3wgRcYkcerwny3jdWgkyYrEwh9wl3/MjJ4xQwZ1ldxhJD1PwrqeG2JSDapZ56qd6BYoATqMObyKI3GP11D1m+AHmzLpsYPNRnBpll5kEybYJTHD2iUvFMwAW72Kk91c9bCKgslCeZxJ0ww0jOYvtVh8rcy6nN/nlWbMZsoYds3Y7nraWCRmJAZZEYp/0OzpjazplwPWCjQNnF9ThY8cXaMq4FV/IPFt7xGp7aylrcE3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(36756003)(31686004)(110136005)(31696002)(66556008)(16576012)(316002)(54906003)(38100700002)(7416002)(66946007)(6486002)(52116002)(86362001)(66476007)(5660300002)(186003)(8676002)(966005)(4326008)(478600001)(2906002)(16526019)(83380400001)(8936002)(26005)(956004)(53546011)(38350700002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0s3WFVrUnJLTlEwcWo3emIyZVVTa1A3dFNtTUQ4WEFNNnQrVkZJUUVPektB?=
 =?utf-8?B?WTN4ZXZnRWR0cmRJYmdxd0F3WXQrSi9ya1dUR2g5bzF5OW5YUVEybXMrdkVz?=
 =?utf-8?B?RWZhQVlpd3BucFp4TjlMWnhGV3RtekJzbWtnN2FJSGRGaER5SmZPalpKOE02?=
 =?utf-8?B?dFJFWnVwOFZXSWZWeXhoU0tZaXFNOGFZbEdXdEhWYS9iSmxUV0NyaU9zRlJP?=
 =?utf-8?B?NzdyK0R0dUs0bm45TFR1R2FOOVZXdGJ6aFJyR1FOSjVsbU5zYnRiSE4yMzYv?=
 =?utf-8?B?b1puR253VG1FZFpWV1hEdzZZcU1ldHJtTnRKQ1kzNms5aDdJblBtbHRUSzlq?=
 =?utf-8?B?alFJV1VaZG5xRWlzMXJvUUNvT29Sc0dtMnFydjdEdEZKT2hFVFZZOHRxd0hM?=
 =?utf-8?B?NW5BMWd5alZncVhCUlhSbHJ3Q3NLM1YwK2xocE9GZ05RUGxTTUpvV3d5bUlw?=
 =?utf-8?B?OWV5QS8wWnJ2cTBpSjNqN2V6QU5LVEhRMUJ6OEMrRkpzbnJiWEFxUWdhZlJw?=
 =?utf-8?B?WVNsM3FHNTVlc1JEdFc4Qml5ZFFpVDF0VVZkZHNXQ2I0NWpvMmdnRnk4OTN2?=
 =?utf-8?B?UFhJSmRmV2JNSE9EQSt2Sko0R0QxekpMb3dOSjFSYU81WE84Z3pNRjM3UXpk?=
 =?utf-8?B?TDMvUzJOdjI4dDA2QUl2MEVhUjFVMFlSaXVrTm9sU1kzWXM4UFNmVTVmaGx3?=
 =?utf-8?B?cFBmSVZjY1NIUWhqSkJJMXBjSmo4V1ZxUjNNMmxqVDdOQSt1V2dzVldCSnAz?=
 =?utf-8?B?d0pHNDFVMUJZQzdrTUV6L0F2bXVaRHFuQy9UUWFzc0xaeHl4Nm9mMGhyVmwx?=
 =?utf-8?B?VmV6cXlibHYvc1JJNnJLMzdkWllSOGxjQWR1anZ1OUNFSmd3dFRRRG5EL1o0?=
 =?utf-8?B?cHUyV05JeGUzWGlVS3hFcW1GVUVHOU5TWkVGVmh4SjBoRzRBQm9PV3UzUVk4?=
 =?utf-8?B?T2h0WXFwSWhIOTZHWHFlcDc3Z0tQdTZpVlR4RUFvdTRvWjdFc09TbU1VWkla?=
 =?utf-8?B?V2V1czhVcC83UithV2JiM1RzbXdJWGxTeVU1enRGMUlZdll5WHNnQ0VMdEZK?=
 =?utf-8?B?WVg0Y1dpRTdhZlRNVkNQMXRzNUQ2RVQ0NFpVZ0FneTFNM3hLSlR2L0U3WEc5?=
 =?utf-8?B?RjBaeTZKdWVXMFVMVGxUS29DcHRjeWhnTnRiTmpZUm9GVjdYbldsQnB0WkQ5?=
 =?utf-8?B?U1diU3dtbjhVb3NLRkpIY3lxSUplNHV3TktoOCtFaW5BMTdhOXZSWlpEQ1hF?=
 =?utf-8?B?ZGRTckpNZWlmZGs3STVYRTRkUGpIeDIzOHdaVExuOWQvTE9pU1lkY1QvdkJC?=
 =?utf-8?B?TnpGQXNrOXBob3dyNElhajlMdVBsUTJIS3ZhUTR6dzZRRU8zYTBSRFhKaEhD?=
 =?utf-8?B?ZllPT3dybmQyenBXTTJKK3ZJSTBnYmFVMHZkWTAyaXlIZG5DR1dpdEhpYUpy?=
 =?utf-8?B?VWVYaEY2REpkS08wOTNXcTdiZFcvUDlrdlcxVExNb0NQUVdBQXB2UlpCOFZM?=
 =?utf-8?B?ZWhIcWxuSVhSU2VCRENrWjhIc1BaTTh1UTBvRk9IY0hsT3ROeGFnazE1UXZU?=
 =?utf-8?B?Y0w3UGRsMWszT3FoSUU5SklXVmhpZnR1U3FiY0c3b0xuVm9sUHI4OXhSQlNu?=
 =?utf-8?B?T3RRcDhlZGZzTFpsSTg0a1FXZ1B1VXFJM0o3SmJjNEl6aVB6S2luSXFpN3JK?=
 =?utf-8?B?dW1XbzRxRE9ETlBSRTRGT0NwR0hpRFdlK3NSSDZpYnF5bkcwZk1wSC9meGNW?=
 =?utf-8?Q?qzAumuuRqSpRix4lQlxZv2uVoh85YggJRPIfcFh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44768021-b992-4394-c136-08d92cc802ba
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 10:59:40.2129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L7cjaD1uX6ZMYyRqtDxzg3MfhtZNcbi/BeIHn7IJTrqPpdcvXdyaYqedGxr+kChLrtiOFG7KRuF7bZ+2pU5dMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7344
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 6/11/2021 1:35 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Jun 11, 2021 at 08:21:53AM +0200, Christoph Hellwig wrote:
>> On Thu, Jun 10, 2021 at 05:52:07PM +0300, Horia Geantă wrote:
>>> I've noticed the failure also in v5.10 and v5.11 stable kernels,
>>> since the patch set has been backported.
>>
>> FYI, there has been a patch on the list that should have fixed this
>> for about a month:
>>
>> https://lore.kernel.org/linux-iommu/20210510091816.GA2084@lst.de/T/#m0d0df6490350a08dcc24c9086c8edc165b402d6f
>>
>> but it seems like it never got picked up.
> 
> Yikes!
> 
> Dominique,
> 
> Would you be up to testing the attached (and inline) patch please?
> 
> Linus,
> 
> Would you be terribly offended if I took your code (s/unsigned
> long/unsigned int), and used Chanho's description of the problem (see below)?
> 
Both patches work for my case.

However, there's yet another, possibly significant, difference b/w the two:
	offset = (tlb_addr - mem->start) & (IO_TLB_SIZE - 1);
vs.
	offset = (tlb_addr & (IO_TLB_SIZE - 1)) -
		 swiotlb_align_offset(dev, orig_addr);

I think accounting for the alignment offset (swiotlb_align_offset())
has to be kept.

Horia
