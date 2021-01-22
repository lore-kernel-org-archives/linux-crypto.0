Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CC7C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jan 2021 11:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CD61238EE
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jan 2021 11:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbhAVLy4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Jan 2021 06:54:56 -0500
Received: from mail-db8eur05on2100.outbound.protection.outlook.com ([40.107.20.100]:52737
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728073AbhAVLAc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Jan 2021 06:00:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDoPsi6jyK8lHUT1OUs1SM+w7YGsmhkK6dXpPGbeJQhZ0tbKROGWbRTfK80SDwqU/13uYBjH4uIpumgmwqAWVMIUXjbywb0n2OgwsSxWlyIl5St7rt/xcxx8C/2JC8gTV+8cZeCBn4y1Ky87VlY6fatvRFpUcKs/s2bB2Cgh4zzt17raOg5TSDplF+IThBqFiRvZjttOsBcDloKx1PfJyu2J6h/00qD1mIQlMfkyxwRRzx7bgxBa+s37Te48Yjqioj5Ir9gtCi6Hc40d40Us1hy+Ynz14WDJvhKAiEPzwn6JuV/pfXb6+KAyZoLnlnUvL7LZ69fs/8KD421mh+6e6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfznBBnu6480dlR40/hxctWpERhfULG6hKiOLTXd4H0=;
 b=iZnrrIcGWkiGXgqGrqn852a9cFgGa2AHLzdMrE5H89GyxB1QOCsbwnsFkcSzOV3msgKQrGSRh2mcb6opXrk9D6uGSAmYqd14i/ZXjFhuo11kNR0nJNY1KG0S6e6l+qve7QEorNaaMF73VvuucjuGeVnuquq72sIm92Na/2uzPKZmW6bWusYJ84lyVTzDJbEaroNSMmdzA7s2KpqEcE/pUzareb4fVRoYHSB+o2vp3Sx9uRI3mzF64J2W1u582KCk2IoO+DDUniSTk2oj1sCgwLTFfYee7fBCOM8xPF0IOHbJD1f/CtIaYtBKlHSz30wgx55jKalgkdZ9HPUUgYca0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfznBBnu6480dlR40/hxctWpERhfULG6hKiOLTXd4H0=;
 b=iFWcaLlKTpfFQsJKIBF8nMIvIWMCg4NQLIdxgQouh0AfPk3RzLj9dS5ioJWGk6qjdDV4jot7H1IZPRyzMyuedrI+D/0VFMcqqa/KT/RH4wkiz2WslLir3oT32DGDQYqUCtTPxoyCkJlNLPS8KOdTp5T44vmIYds1XR+iFDJqF0Q=
Authentication-Results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB5666.eurprd05.prod.outlook.com (2603:10a6:208:114::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 22 Jan
 2021 10:59:42 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::25c0:d4fd:dcbb:d34b%6]) with mapi id 15.20.3784.012; Fri, 22 Jan 2021
 10:59:42 +0000
Date:   Fri, 22 Jan 2021 11:59:25 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Fix use of sg_pcopy on iomem
 pointer
Message-ID: <20210122105925.w7xmiusoubsxxmvl@SvensMacbookPro.hq.voleatech.com>
References: <20210121051646.GA24114@gondor.apana.org.au>
 <20210122100203.uyurjtxjiier6257@SvensMacbookPro.hq.voleatech.com>
 <20210122104027.GA1935@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122104027.GA1935@gondor.apana.org.au>
X-Originating-IP: [37.24.174.41]
X-ClientProxiedBy: AM0PR01CA0174.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::43) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacbookPro.hq.voleatech.com (37.24.174.41) by AM0PR01CA0174.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 10:59:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32b90650-217d-44ef-967f-08d8bec4d24c
X-MS-TrafficTypeDiagnostic: AM0PR05MB5666:
X-Microsoft-Antispam-PRVS: <AM0PR05MB56669B75CA14151F3CA73D1AEFA00@AM0PR05MB5666.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CBG+KanPB7GpRxdC/OnVDWzTgdvU9URew7wrx62CbV5QrRFSWfWQe/Wbp2ctMGrqBkkYrid4vzKWFwKr1mbc0MJ6sGFH93HqfEljKDnWZ69nHfdXr/S+OnMNnseWs8+MRPKsqtq/z59Rk9uBU2BGLhkSo3YkBRV2xt8u17bE+aIxSgjHw3bulJmUqNWMybdZviL+Tt3PL5Avr8J4/LG08lCeqQtEhSQ8krwdjOoOT7rTNhO041ljsiK3OyuJvqyKmydV0BiixJFt3CDw7SxDOaRvwIkLnUQkuyTL5i3jjCro5ac1IY4TFRAIa5N+Lyq1plHlXZEnrz+PxLpX7DJobx5ZM6jQGjd+LJHT1NeQM62jhIyU2Pg6IdwYCtglcsKNATT3cldcl4xKdthqX0Y7HMgs0MIoEH/ypsvRTdiF5RmUBoOUFIt+bgbGuPDvmeT30kZhfU04qqQPKiiTinT2FiWj0r0McICPBOhVfJKaMgnRTCCKwsquzx+6ZAsD5/agXlYgF4icJ966usV3azxJabYbdzD/0qjQ5pMX3ozqQS72fJmOOcScdZAiVYrxpslYq4AzJpGOxjR/NLNA2NcrKX9KTVctMD4xLObaZWA+rJcenkaZeyAYSnkJ8pKIxC6tN4kfxupW8jTiv60VvBtQ6ofE+PPMDwZhFNahw65kSrY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39830400003)(346002)(136003)(376002)(8936002)(2906002)(1076003)(45080400002)(9686003)(478600001)(956004)(44832011)(54906003)(8676002)(4326008)(6666004)(316002)(186003)(55016002)(26005)(6916009)(16526019)(6506007)(83380400001)(86362001)(83080400002)(5660300002)(52116002)(66946007)(66476007)(66556008)(7696005)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oM0yPSG56v0YktnThDYNKaYxr5Rkryz+TxDS+3so9lhEBWzwf6gJlXKKPkxQ?=
 =?us-ascii?Q?HKCc5oK1Ik6cL42GknkP+kZl6HGLq3G8dKe0QruTfsimDlYfqH6HIqqqazcM?=
 =?us-ascii?Q?akW7umT7Bt3jYp8jIqQJt2i7HywDRCiicKqn2ipgY9Mq34pHKyrDyQJ0B4X4?=
 =?us-ascii?Q?DaO8YEgBhsOlXmaYckafMQwqWFebEA2TywpGu3rVq/ZBSHUxRh5VrGNyUrWA?=
 =?us-ascii?Q?qimM5gKRKj9vOAgo9sUAfH489f0yTOUJYHwXZFQeLTzSihMs5v+yqfYa6kjk?=
 =?us-ascii?Q?9XPewxZMTyJNE2JISDpbE9iv+NzPqK/OUWlrHSzXxZXKsu07qdwwRih0iHu6?=
 =?us-ascii?Q?GZHgR8PWDGT0MnLr+oG3YBbBt8CTEWi1MMiC3iKUmhdgSqt3llpwg9iKIO2M?=
 =?us-ascii?Q?g/AaZ/LZ1b8hb29hq0bkCRryyCytVT3lZttihIG+c6iEKZGCwLUT7hqOeePR?=
 =?us-ascii?Q?YQdAoieBGcPLNxiJNNSVhf9phlzhY1Uz5/UWlYt+9XLl8B5jDkp0/AIaUkeJ?=
 =?us-ascii?Q?kC5qEBTPF+2AX66nTl4jLYv23wV3rEZf9gIQdlEZia/ISLgejaDTLGbTHgXM?=
 =?us-ascii?Q?9YADGkWyjZhn70HMXz/yiSi6GcAFw2pEIGtEP9LUD0JOswtZBS/4HnZmgG6D?=
 =?us-ascii?Q?StUTb+w1TnMIZUN1PJElQpVtxv41OHlyRGqyDMyhogw7mxpZyc1WfkMFJyxR?=
 =?us-ascii?Q?oI6oGQjwQIlHl09aHcH5MBg/G8LoLMF+wJMv1EQYeuTFVS3E6pIi6bwbsoCR?=
 =?us-ascii?Q?G/GsgTbc/xvsHxB0FKi27ymEzSOItJe7QFgmXMxlrGQPyMWq2luGGqLvY12e?=
 =?us-ascii?Q?ciW6gLx84lawVZCJ+CZETF9FPAQBVDAdnX715//XPHnpgzgzFM/Q0+vMJlgg?=
 =?us-ascii?Q?RhiwpInfYBPBl1PSxdJe/XyHnjtOeDzU9y23I6ikRQJRs9KgYZXCAoxJ8toV?=
 =?us-ascii?Q?yOUWLDHdt2tShSswe1fx22V9D3AW5sBRma6qSDwfZl8f8yVBBkrXTLn6paGh?=
 =?us-ascii?Q?fE7P?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 32b90650-217d-44ef-967f-08d8bec4d24c
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 10:59:42.6197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RCOh/r+h+rCKuRNY5RRlG/k99mwG9JHCbp027bd7NNH/3l/LH22gToZEmZnn2P0GOAByuKDZ+uIXBqxKp7xfz/n0oMVoivgJyXTZyNfCJao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5666
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 22, 2021 at 09:40:27PM +1100, Herbert Xu wrote:
> On Fri, Jan 22, 2021 at 11:02:03AM +0100, Sven Auhagen wrote:
> >
> > Hi Herbert,
> > 
> > sorry, no luck on my armfh system with this patch:
> > 
> > [169999.310405] INFO: task cryptomgr_test:7698 blocked for more than 120 seconds.
> > [169999.317669]       Tainted: G           OE     5.10.0-1-vtair-armmp #1 Debian 5.10.3-3~vtair
> > [169999.326139] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 
> Hi Sven:
> 
> Thanks for testing this!
> 
> Just to check the obvious you tested this on top of my other patch,
> right?
> 
> https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpatchwork.kernel.org%2Fproject%2Flinux-crypto%2Fpatch%2F20210120054045.GA8539%40gondor.apana.org.au%2F&amp;data=04%7C01%7Csven.auhagen%40voleatech.de%7Cea6bf0786efa429cc19a08d8bec2273f%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637469088398296475%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=pRWjGItQZMLvXSCsufx6vUOSQffQM3vDsHM1OXzdSc8%3D&amp;reserved=0

Hi Herbert,

sorry, I did not test on top of the patch.
I forgot to apply it when I started from a new branch.

It is working on top of your other patch.

I am happy to test further changes if you keep on CCing
me on them.

Best
Sven

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2F&amp;data=04%7C01%7Csven.auhagen%40voleatech.de%7Cea6bf0786efa429cc19a08d8bec2273f%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637469088398296475%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=41iWnODYaS9sSmUE312RHnTmM6%2FDMgYPjm%2BNPmX6%2BKI%3D&amp;reserved=0
> PGP Key: https://eur03.safelinks.protection.outlook.com/?url=http:%2F%2Fgondor.apana.org.au%2F~herbert%2Fpubkey.txt&amp;data=04%7C01%7Csven.auhagen%40voleatech.de%7Cea6bf0786efa429cc19a08d8bec2273f%7Cb82a99f679814a7295344d35298f847b%7C0%7C0%7C637469088398296475%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=wPKSJmFfvj8CLAKQZ12BbGQzQs9TYieAn8xxxdmJ42I%3D&amp;reserved=0
