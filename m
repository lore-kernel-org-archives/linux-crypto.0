Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_RED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1375EC48BD1
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 10:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9C9561029
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 10:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhFKKhg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 06:37:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59694 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbhFKKhf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 06:37:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15BAU7kC154154;
        Fri, 11 Jun 2021 10:35:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2020-01-29;
 bh=nQo2iXKace6RKY0BHKtqTjima66RIWTVTUnsOSbF2CY=;
 b=xtiD6JWGJst/EiWYN9j30DOHnhmD2cvmNoqqaScUiBNoNVZTsSRBteynG5X4cFPgJ3k6
 hgoyDgb1z+pcWboSNv/WFWDCMXnf7g744W4ViEleaeeGuXKZ9zimZ3RQfbkIR6Zb/1ao
 hYe0IONv7BJnLsK8Ld6dskBIRCtkXvAaND7MExuyXJpTf3QGhI6VaA8+Y8qCr/4gyUF4
 ixCfoBm9JBsLHifDc7x465LushkajvGB3UtGGRLTMU/nKUif4ASsH3sL28q9fcJO5p/s
 QxZPggJw4VASAD9Hpisl5Pe1ujeyLHspz7sX9JMpTafaU1XiC8RiJ1HdOj+KR0zk/mt9 xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 39017npcd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 10:35:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15BAYVZC070038;
        Fri, 11 Jun 2021 10:35:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by userp3030.oracle.com with ESMTP id 38yxcxe6hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 10:35:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrJ23FZ2Sghp9+Ac8KPsbQRmUOJ7MiuxISGA6ACFi5tvlfa/5LbZHJ27841LYd6vBmy/yVTByT0Md2MEmUW6jPWNKVFTwJXzb0xkXrP4C407ztUGWN15KaPG6aN/spN4ONYkpqN5s94fHucvlFlEgaHvw4SO9KoFjSdY/8Y5mkvk8j6l+jf82HzAhJmZYqSgsBUhPtR23G7ujend3U0EiX7hRB3TlEV+TyTZpd6A32HZuN0aEr5i46K2vtdF3ka6fJhFXtirBo1jlu16UGMZIR5lJYqp4hMm8gFSMJrENVQvHdZN2bE01p0VxoaR1Wr/C2LQSmqea+O7OihpkAG4uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQo2iXKace6RKY0BHKtqTjima66RIWTVTUnsOSbF2CY=;
 b=DvnTtnrRnhMg8noJGUB9sHHR6/NUcwavoK4rFSM18DqMZE5LM0bXypN2Acx3V5icLMq/+RdJP4CKLbGll42Kthoio8XNUa4ZXtRQGqt8CEmvYHwyiLiA/s6AmmwZqqQzfXhPuoxIiNCHplkjkX02jhQzD5DbCmFlG3V44++XWow2zGFWcCU+ZxiS51XASOgc4Ewni6GFvEBNpAx6mkswyBx47KGLnmb1vXVTaM6tsRfMdK8V18fpdy930kyNjfRTYt73/MUNp38p3dPkE+zkkxxjl+bhHg/EZEafSIGe8ZNGo1+9guEJMK1szRadJK49UdlAJox+qgHOuzDyk2bh2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQo2iXKace6RKY0BHKtqTjima66RIWTVTUnsOSbF2CY=;
 b=tZznQuYVAlJa8WWzCHM3MQes6yO2zM6w62jkLISBk6NwFvpy8AS+M7Eg/TRaUzTsK2zFwexVKno+xpHmVWKL95fyXbmpoM12Qsu05Rt6Cto5ZNNCnZi+dFUvQaMDua43Q8DU+8qLumko9FdU/svfEVp5sHh+bLmf6FXk4wmomeg=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2999.namprd10.prod.outlook.com (2603:10b6:a03:85::27)
 by BY5PR10MB4211.namprd10.prod.outlook.com (2603:10b6:a03:20c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 11 Jun
 2021 10:35:02 +0000
Received: from BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::8111:d8f1:c262:808d]) by BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::8111:d8f1:c262:808d%6]) with mapi id 15.20.4173.027; Fri, 11 Jun 2021
 10:35:02 +0000
Date:   Fri, 11 Jun 2021 06:34:57 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Christoph Hellwig <hch@lst.de>,
        Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        jianxiong Gao <jxgao@google.com>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        Jianxiong Gao <jxgao@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Hartmann <lukas@mntmn.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: swiotlb/caamjr regression (Was: [GIT PULL] (swiotlb)
 stable/for-linus-5.12)
Message-ID: <YMM8Ua0HMmErLIQg@0xbeefdead.lan>
References: <YDkbCHHBUOmfI59K@Konrads-MacBook-Pro.local>
 <YL7XXNOnbaDgmTB9@atmark-techno.com>
 <2e899de2-4b69-c4b6-33a6-09fb8949d2fd@nxp.com>
 <20210611062153.GA30906@lst.de>
Content-Type: multipart/mixed; boundary="uNcz+wGozi5IAMFR"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210611062153.GA30906@lst.de>
X-Originating-IP: [130.44.160.152]
X-ClientProxiedBy: BL1PR13CA0301.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::6) To BYAPR10MB2999.namprd10.prod.outlook.com
 (2603:10b6:a03:85::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 0xbeefdead.lan (130.44.160.152) by BL1PR13CA0301.namprd13.prod.outlook.com (2603:10b6:208:2c1::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Fri, 11 Jun 2021 10:35:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ec15544-a5da-41d2-1602-08d92cc491e3
X-MS-TrafficTypeDiagnostic: BY5PR10MB4211:
X-Microsoft-Antispam-PRVS: <BY5PR10MB421153B4DC3AB1F6CC2ABC8F89349@BY5PR10MB4211.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oQTrJAlbsB9O4HLNX6FShkmZV9XJwXP2y5pDf1dFobEECH5yJauUL4OMC4ECqHXKDa5HcL7WqccxNdsGzAMXPXglRQDF8qxhWwGtfHsvwjHQp/5qNul/WDX23AoLRDDPvmH8CCQc78kG/oQwGVL7suzRUzx1QTyJYQM/oo4BIjNC7H0+xBG1FWy4uF7uhmiUwvdfrWlECBDoCGXyhOWNKokGK3mNuirWhIgPQT1ZpWk2TWct5Tcc3aIkIVwc2ByVnqYJlhGPZF1PhrjZUTWhtPozz/lMk2y1kZ3Nxs1zzRYzM0P465O6IKqg28EILTc3rxHpCtBQ9ifWmXyDu7WHnGVAF8YPxlL3iDjeO4y21G5M40PjGK3lcTcauwHNxlKh8nzk3xxcPrQUlUzsHa/nhQQIuCXNpCXrkaNwkRijS03a1Y8uRCU7Rwe6tjR06dG2b4GoDc6/eOwkVWsmOL1Ulu8rQt87eB10tF2Lm55jXfv67MS8SVTrcHS4AXN3T9pTgz5B3OpnIts6FNaHTDtnfuAYa4EN+fExVgyqywWl70IV9uYDOUwpEoK5ovbgD2aLiVjbaodYzRko7P8b5xpUIbd/RIjIaYnzGrgh7DkgiRdeu4giSVgUCPISSsRK5JAWSTMaVUKAAAuhSW/UQRo/pt89tZ9j+TFw7B8JVmZi3yFFVCOJU7VpoIDubX6mnTDsUPGLdA8qXdxQHukjV4ybyhdMkyykdIT/kdJjOCZd8+wxfY8uATatpx8GoFy+V9iiQhauabrkJFYzlbcllFfd5RwESoJ5Wx1ciK2wm64s3v0qI5tKZNNRgqhJf29DfnhL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2999.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(136003)(396003)(346002)(66946007)(66476007)(66556008)(66616009)(966005)(52116002)(44144004)(16526019)(33964004)(478600001)(5660300002)(26005)(6506007)(7696005)(53546011)(186003)(2906002)(36756003)(86362001)(235185007)(110136005)(54906003)(9686003)(8886007)(4326008)(6666004)(8936002)(7416002)(8676002)(55016002)(38100700002)(38350700002)(956004)(83380400001)(316002)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUd6dk1RSzlWWVFXN2pUNWVLaDhvT25TNENiQTdadnZxZHB0VUhTS1NDUEpG?=
 =?utf-8?B?UnFSVGUvODNVSUFZNDdObDlhUVUzRTMvbE50WFNPUHQwU3pUY3UzWEgxRXJJ?=
 =?utf-8?B?amlTY3BaQ3dqeU14UnZUQm9xZUdqeFIzVkV2Z3AyS0t0UnVlQkttSk9Wd2JF?=
 =?utf-8?B?TXJtcjlHVmIxT2JlTFQ4bnhucWk4bXM3aytWMlhqV0dtcGJVRTNEc3NYT1VD?=
 =?utf-8?B?Ym5VUjJNY3NKd2xtR3k1YUFFVFpxSTE3aGI5Z25pM3Y0Q1dId2lqem1RYk1v?=
 =?utf-8?B?V1lxMHd1THNGVDhlVDdDMitnTDl0VHJBSUtSZitKdUg3bW92V25TNmN1cVFu?=
 =?utf-8?B?N3VBSGZ3ZTBBQ0JQVmxuNzZBU3I2OFRwN3VZRDE4dXZ5KzVWWncwRzhRRmlV?=
 =?utf-8?B?azg2OEJKNzZBOUNGV0xIZ0d0S1o5WUJlbmNIeGhYN3V0U2N3enQrNDRFK2Y2?=
 =?utf-8?B?K3d4b0grdHFZTlk4ZjF3ZC9SbnJwMi9EbWJxdG1weTlsMVk4a2M1bnFlKzQ4?=
 =?utf-8?B?OUxDOHIybGdJcGpQMkw4K1JHdWZ5MEcxa0hxN3lEK0U2Tk9lSVRZZG5PY1ZD?=
 =?utf-8?B?NW9SbEJvWVBrZmlub3pKVDJaaUhGcDlybHJBQ3FaRHRUQnN0QjdNLys2WVJw?=
 =?utf-8?B?S0VTb1U3cEI4ZkRueTA3ckVCVFRrVkw4ZUpXbmFYcEhuUzc5KzJrUnEyWm9Q?=
 =?utf-8?B?VmpRZmZiL2duVUFzTVI5Z3hPN1l5Z1FEYStsNjZUVVFOSWdobGdHUm5aaHNs?=
 =?utf-8?B?L0YyMXVDVUpFNXNUNzdaSkdENjdZUEhyY3p3QzMwdCtkZHlvYVhnOFNuMTkz?=
 =?utf-8?B?THhPZXhYSnpHdHNyTWdiYTE3RHVGRW5lRmtBeW9XREhZNlpZUFVBeHBkdkh6?=
 =?utf-8?B?MWFMakF6NlV6QmwyNGxtVHFFWGV3QjVjM2dFK2xCY0pTS2gzZVltTFZqbytZ?=
 =?utf-8?B?UkxNUVJUaW1NT04wK0J0dTZQZm9KZU9mQ0lJZWQzSERBdDZ1YTBzajJoZ3F2?=
 =?utf-8?B?cW9JalMwZzVLcUpyR2wwYTFQak1XZU1iK3NiSlVvVDdqcDZ5NlhqeU5GRkov?=
 =?utf-8?B?dGVGeFBkckowejJ5VzFGQ0NsY1JYbW9IOVFQSU5BUEdnTS8zVmE1RG9tZ0tK?=
 =?utf-8?B?T1dVRWJTZmFJMUg2RUZQTUJkZnhkTFdueHFWTUdoSDA4NW9jSmpQUnQ2eEd3?=
 =?utf-8?B?UVNkcHJ6b2pxaFFHeHI4eFc0Vzk4TXhYRVJqWkNjeFgxZG5OZzRSK2ZvTk1X?=
 =?utf-8?B?VVNxZmZweDMwS3hKQzNqWlUreWVyZHlhRkxIOFFYbFpwNXY3d20xV0JmRGFj?=
 =?utf-8?B?NThEZHN3K3NCZW1lK1BCbFJ3OVFTd1hNWTRTdjhBdDBPZzhVRXlJdEYwU2F6?=
 =?utf-8?B?TmpWcjk2WVRLVkFEZzZoblE3L1hacEJDemZVdjFjQzNzenZQTWcvY25iV1Bq?=
 =?utf-8?B?NWhmdlRSb25NS2xwTWx5K2xTQktvb3pkTThiWmFSWHIvaU5PMVpaU09LYXYv?=
 =?utf-8?B?TXhwWlV6Vlc2QmNxaXdhSCtDOTJ0MzVhT2lnYUQwMHI4WjlZS2lxSG1ZSVZO?=
 =?utf-8?B?Z3g3QjNLYjR5NUQyTEhGd25ndEJ6OTJYTk11SHJrN3R1bG5zTGFrejBFeU1q?=
 =?utf-8?B?WWxEV3ZxU0piNGFBKzErdkdZSi9RZnBqMElYR1REUUorMzF1KzQ4VDFvR3lS?=
 =?utf-8?B?SFpnZ2YwWmhUa3hENERUdm1uVU9WQ0xBd2p1bHVmTVB1TjY0QXZ4Umozd2RT?=
 =?utf-8?Q?2UrWGzt/RA61ZSeSO3kV2FGeuM+cbTT4FdwJdqF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ec15544-a5da-41d2-1602-08d92cc491e3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2999.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 10:35:02.4225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kFaq9UTXU6h8pncRxzByhEwI+nqjbVZv/IiCPS4v1cT8/kPQIz1VNf1fTMP1RFbOVvTudHsMazT0FH15GnPdtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4211
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10011 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110067
X-Proofpoint-GUID: tSzzjnYnmuhlw8mDKKdCqe2Gv608735J
X-Proofpoint-ORIG-GUID: tSzzjnYnmuhlw8mDKKdCqe2Gv608735J
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10011 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1011
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110066
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

--uNcz+wGozi5IAMFR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jun 11, 2021 at 08:21:53AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 10, 2021 at 05:52:07PM +0300, Horia Geantă wrote:
> > I've noticed the failure also in v5.10 and v5.11 stable kernels,
> > since the patch set has been backported.
> 
> FYI, there has been a patch on the list that should have fixed this
> for about a month:
> 
> https://lore.kernel.org/linux-iommu/20210510091816.GA2084@lst.de/T/#m0d0df6490350a08dcc24c9086c8edc165b402d6f
> 
> but it seems like it never got picked up.

Yikes!

Dominique,

Would you be up to testing the attached (and inline) patch please?

Linus,

Would you be terribly offended if I took your code (s/unsigned
long/unsigned int), and used Chanho's description of the problem (see below)?

Christoph,
I took the liberty of putting your Reviewed-by on the patch, you OK with
that?

Jianxiong,
Would you be up for testing this patch on your NVMe rig please? I don't
forsee a problem.. but just in case

From f06da55596675383fbf2563fe2919b2a8f68901b Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Jun 2021 12:41:26 -0700
Subject: [PATCH] swiotlb: manipulate orig_addr when tlb_addr has offset
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

in case of driver wants to sync part of ranges with offset,
swiotlb_tbl_sync_single() copies from orig_addr base to tlb_addr with
offset and ends up with data mismatch.

It was removed from
"swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single",
but said logic has to be added back in.

[From Linus's email:
That commit which the removed the offset calculation entirely, because the old

        (unsigned long)tlb_addr & (IO_TLB_SIZE - 1)

was wrong, but instead of removing it, I think it should have just
fixed it to be

        (tlb_addr - mem->start) & (IO_TLB_SIZE - 1);

instead. That way the slot offset always matches the slot index calculation.]

The use-case that drivers are hitting is as follow:

1. Get dma_addr_t from dma_map_single()

dma_addr_t tlb_addr = dma_map_single(dev, vaddr, vsize, DMA_TO_DEVICE);

    |<---------------vsize------------->|
    +-----------------------------------+
    |                                   | original buffer
    +-----------------------------------+
  vaddr

 swiotlb_align_offset
     |<----->|<---------------vsize------------->|
     +-------+-----------------------------------+
     |       |                                   | swiotlb buffer
     +-------+-----------------------------------+
          tlb_addr

2. Do something
3. Sync dma_addr_t through dma_sync_single_for_device(..)

dma_sync_single_for_device(dev, tlb_addr + offset, size, DMA_TO_DEVICE);

  Error case.
    Copy data to original buffer but it is from base addr (instead of
  base addr + offset) in original buffer:

 swiotlb_align_offset
     |<----->|<- offset ->|<- size ->|
     +-------+-----------------------------------+
     |       |            |##########|           | swiotlb buffer
     +-------+-----------------------------------+
          tlb_addr

    |<- size ->|
    +-----------------------------------+
    |##########|                        | original buffer
    +-----------------------------------+
  vaddr

The fix is to copy the data to the original buffer and take into
account the offset, like so:

 swiotlb_align_offset
     |<----->|<- offset ->|<- size ->|
     +-------+-----------------------------------+
     |       |            |##########|           | swiotlb buffer
     +-------+-----------------------------------+
          tlb_addr

    |<- offset ->|<- size ->|
    +-----------------------------------+
    |            |##########|           | original buffer
    +-----------------------------------+
  vaddr

[This patch text is from Bumyong's email; and his solution was very close
to Linus's, so incorporating his text]

Fixes: 16fc3cef33a0 ("swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single")
Signed-off-by: Bumyong Lee <bumyong.lee@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reported-by: Dominique MARTINET <dominique.martinet@atmark-techno.com>
Reported-by: Horia Geantă <horia.geanta@nxp.com>
Tested-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: stable@vger.kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad@darnok.org>
---
 kernel/dma/swiotlb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 8ca7d50..dc438b5 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -342,6 +342,7 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 {
 	struct io_tlb_mem *mem = io_tlb_default_mem;
 	int index = (tlb_addr - mem->start) >> IO_TLB_SHIFT;
+	unsigned int offset = (tlb_addr - mem->start) & (IO_TLB_SIZE - 1);
 	phys_addr_t orig_addr = mem->slots[index].orig_addr;
 	size_t alloc_size = mem->slots[index].alloc_size;
 	unsigned long pfn = PFN_DOWN(orig_addr);
@@ -350,6 +351,14 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
 
+	if (offset > alloc_size) {
+		dev_WARN_ONCE(dev, 1,
+			"Buffer overflow detected. Offset: %lu. Mapping size: %zu.\n",
+			offset, size);
+		return;
+	}
+	alloc_size -= offset;
+	orig_addr += offset;
 	if (size > alloc_size) {
 		dev_WARN_ONCE(dev, 1,
 			"Buffer overflow detected. Allocation size: %zu. Mapping size: %zu.\n",
-- 
1.8.3.1


--uNcz+wGozi5IAMFR
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="0001-swiotlb-manipulate-orig_addr-when-tlb_addr-has-offse.patch"
Content-Transfer-Encoding: 8bit

From f06da55596675383fbf2563fe2919b2a8f68901b Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Jun 2021 12:41:26 -0700
Subject: [PATCH] swiotlb: manipulate orig_addr when tlb_addr has offset
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

in case of driver wants to sync part of ranges with offset,
swiotlb_tbl_sync_single() copies from orig_addr base to tlb_addr with
offset and ends up with data mismatch.

It was removed from
"swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single",
but said logic has to be added back in.

[From Linus's email:
That commit which the removed the offset calculation entirely, because the old

        (unsigned long)tlb_addr & (IO_TLB_SIZE - 1)

was wrong, but instead of removing it, I think it should have just
fixed it to be

        (tlb_addr - mem->start) & (IO_TLB_SIZE - 1);

instead. That way the slot offset always matches the slot index calculation.]

The use-case that drivers are hitting is as follow:

1. Get dma_addr_t from dma_map_single()

dma_addr_t tlb_addr = dma_map_single(dev, vaddr, vsize, DMA_TO_DEVICE);

    |<---------------vsize------------->|
    +-----------------------------------+
    |                                   | original buffer
    +-----------------------------------+
  vaddr

 swiotlb_align_offset
     |<----->|<---------------vsize------------->|
     +-------+-----------------------------------+
     |       |                                   | swiotlb buffer
     +-------+-----------------------------------+
          tlb_addr

2. Do something
3. Sync dma_addr_t through dma_sync_single_for_device(..)

dma_sync_single_for_device(dev, tlb_addr + offset, size, DMA_TO_DEVICE);

  Error case.
    Copy data to original buffer but it is from base addr (instead of
  base addr + offset) in original buffer:

 swiotlb_align_offset
     |<----->|<- offset ->|<- size ->|
     +-------+-----------------------------------+
     |       |            |##########|           | swiotlb buffer
     +-------+-----------------------------------+
          tlb_addr

    |<- size ->|
    +-----------------------------------+
    |##########|                        | original buffer
    +-----------------------------------+
  vaddr

The fix is to copy the data to the original buffer and take into
account the offset, like so:

 swiotlb_align_offset
     |<----->|<- offset ->|<- size ->|
     +-------+-----------------------------------+
     |       |            |##########|           | swiotlb buffer
     +-------+-----------------------------------+
          tlb_addr

    |<- offset ->|<- size ->|
    +-----------------------------------+
    |            |##########|           | original buffer
    +-----------------------------------+
  vaddr

[This patch text is from Bumyong's email; and his solution was very close
to Linus's, so incorporating his text]

Fixes: 16fc3cef33a0 ("swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single")
Signed-off-by: Bumyong Lee <bumyong.lee@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reported-by: Dominique MARTINET <dominique.martinet@atmark-techno.com>
Reported-by: Horia Geantă <horia.geanta@nxp.com>
Tested-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: stable@vger.kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad@darnok.org>
---
 kernel/dma/swiotlb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 8ca7d50..dc438b5 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -342,6 +342,7 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 {
 	struct io_tlb_mem *mem = io_tlb_default_mem;
 	int index = (tlb_addr - mem->start) >> IO_TLB_SHIFT;
+	unsigned int offset = (tlb_addr - mem->start) & (IO_TLB_SIZE - 1);
 	phys_addr_t orig_addr = mem->slots[index].orig_addr;
 	size_t alloc_size = mem->slots[index].alloc_size;
 	unsigned long pfn = PFN_DOWN(orig_addr);
@@ -350,6 +351,14 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 	if (orig_addr == INVALID_PHYS_ADDR)
 		return;
 
+	if (offset > alloc_size) {
+		dev_WARN_ONCE(dev, 1,
+			"Buffer overflow detected. Offset: %lu. Mapping size: %zu.\n",
+			offset, size);
+		return;
+	}
+	alloc_size -= offset;
+	orig_addr += offset;
 	if (size > alloc_size) {
 		dev_WARN_ONCE(dev, 1,
 			"Buffer overflow detected. Allocation size: %zu. Mapping size: %zu.\n",
-- 
1.8.3.1


--uNcz+wGozi5IAMFR--
