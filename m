Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56406C07E95
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 23:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3881061107
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 23:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343788AbhGSXRy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 19:17:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:61294 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241258AbhGSVG3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 17:06:29 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JLkT8j002422;
        Mon, 19 Jul 2021 21:46:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=uWX2del9LAdqMZp61F/zFDiA2wiy6vrpMneqq7c41kU=;
 b=j3ts4MeG+bpc+mkuQmSmvqnmtc8e8S1JPNuHPloPZ6JipQnAAvJI14c6tQxD4AR9rTPv
 kwC3uKus7xzTCWj7krKY2QF78jQ4RTV2AkLx9wBbV2//ZuqopKFGQCE7I3MeUPR8g80Z
 fHjuNnqP4VsyRuD/hIkd3l0Rjm4P4j36m8vJJJqg52A/aB4q6Xt29RloF1Hfrjai1j2P
 q9HjFL+i9q6yPhzgVi7CxJMfC81mTasRMtJyCymXCac1kgThoZJK17O9prCnHcdaTCL8
 tYs8HX+vkuoZH7GmTjzwD5QSfrCIsGReGixSZjaXq3qkPnpWHpMMpUEYEeVGDCraKiWX EA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=uWX2del9LAdqMZp61F/zFDiA2wiy6vrpMneqq7c41kU=;
 b=OkgP+T9heTj8Krku4PSbxKeNeImgJZsVUKpOibCCr6/UggKoT9DNCszW14HB/EI5ziHe
 N4TDgKkSiQipK8YIY5W44qnJVfyj9eJ8prMe6LbwJIyR9UiMR4ibj9g639Y1UlcChP3H
 EtzujKLC4cstU2OpeGoBFbiF7JbZ0pKic6JD4wdcrr4PpQA4J0GwsgLwjJB8q9H/N7e8
 LPRUIXhKUWRK0M29g3vVbeODVw8FR4LhnaoESASezCgOfpTuuK5OaIEH8PR4vWJNrK/E
 Gt89ZOSvERCZs1RsKLcE6Xgr7R96EABGH2UuNWR4bp2BIld95yKBz2Kw8ocV+4ic0y0t Pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w8p0s8p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 21:46:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16JLkP9a101841;
        Mon, 19 Jul 2021 21:46:55 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by userp3030.oracle.com with ESMTP id 39umaxt1q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 21:46:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFK3cB8xLKeWCQBT2bdaVwFG/phHgKcPnatAafAwtL/9oPy66Tza5RUYN5oy9+4zK6HRfHA3IVbXkhKr8szgNIPmL8H75IMgxzWLdtMfrSlsVfplQWkR0BSxa4LV4jrAKHikPSSaWL5UzHgwANDFah/iv+Edc4HX57j4it7MwNKoFn5Y7GTaEZJsg7w8dsK5McMcKAdxPmgoM5xi8cuPCYkTwG4mPCKqfEDX31Gum8lICoxpBC+YHOXzqzxYhcCJXYwEPIAA/+RcY3vjFxMwDdb+RKMA35Zfq2HHeESG7Bk7HJ0pyE8bff6kXecU9XMoDPUxagmlQc9gK/lcDp+n1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWX2del9LAdqMZp61F/zFDiA2wiy6vrpMneqq7c41kU=;
 b=WR+ba9jFxjR0ceXTVzoJzlgLazOziS7/d4sH+ctHbWbRaZae5ZiB1XiPpGzwDBOj9g7MslT7KKGpt+kO/byf0J6/wH6wye55r+4kDpGbt5eYLItWFm0gU1qBwEKvptx8h5BJk02O/Lenr1l9CefIqjYhBEC15arnXrPo1jFelwvqXbPx9Cnm90qnwR77TNmB7hfdKvS8c8pkFPjvNPdi+eST0BlUw/fnKeqUxZF2MAS+wTlotfwfsWuMwLseF4vmB/0g8lbUkLhgQY1dViqh0kKs3fQS/OtHFfvVHOs6BUSxMWwFasljt1w/QVQDOpWMKXaEjEALQc7UAspkdfjGIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWX2del9LAdqMZp61F/zFDiA2wiy6vrpMneqq7c41kU=;
 b=OFq5sGLYesNy7wAOaHEvE47vnUkSpcWUfxyq6xKfvVoinxLvLS2ospvbfCe41plE/WmLZqsZysffNBnMMZAPutEDva1bgC0acPA812QGuK/Fl+B3QQmoZ2uwKuRmsvdb98bL5XHAy/w1vtvwvucfDTm8wcKlLyZ52s1zMWpXo6o=
Authentication-Results: fudan.edu.cn; dkim=none (message not signed)
 header.d=none;fudan.edu.cn; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27)
 by BYAPR10MB2790.namprd10.prod.outlook.com (2603:10b6:a03:89::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Mon, 19 Jul
 2021 21:46:54 +0000
Received: from BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::9478:368e:93b4:6b48]) by BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::9478:368e:93b4:6b48%4]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 21:46:54 +0000
Date:   Mon, 19 Jul 2021 17:46:49 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, Xin Tan <tanxin.ctf@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] padata: Convert from atomic_t to refcount_t on
 parallel_data->refcnt
Message-ID: <20210719214649.w65ifdp2hriryrsc@oracle.com>
References: <1626683853-64734-1-git-send-email-xiyuyang19@fudan.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626683853-64734-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-ClientProxiedBy: BL1PR13CA0294.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::29) To BYAPR10MB2966.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from oracle.com (98.229.125.203) by BL1PR13CA0294.namprd13.prod.outlook.com (2603:10b6:208:2bc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.9 via Frontend Transport; Mon, 19 Jul 2021 21:46:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b51b3b1d-7ba5-47e6-017c-08d94afeb92f
X-MS-TrafficTypeDiagnostic: BYAPR10MB2790:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2790B73D206E3BFF3D60B1B1D9E19@BYAPR10MB2790.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9EAxGuOwJfr79JtFCz/bqwhr6imPHQ96li5IMk9Rqdp3DDvoZJGphqe3q6D0EFGjFcqgAIRuRNvdZfG3v3uZnfpPgtJLPBa9AnGzKN+dPDu/FTV21kODTMIDpCbM3gFXFyx/hEvMIDKD5S7buoTLLL+6ql3vNcFm09Ytg3jR7En6tkDtWlTX3WG9MPDCgz/gQ5DKJIlZFIXv5Zo6IJZVqf62cTIrejsHFGuayV8oJ4uh4z7J4qykAmf9Hdh/2hLHvXFB6QFszDCZJRCULEIrq7PsC+E0pdeCM345DAh4WsS+O3BR9EjVorA7Y3n/j8PQGhXBUAN81F+tQSJar7ZkI2+tUPkv2zMa3s+aL8jxyjoQ+SHFTAyO7JLKt/RRLQvtWaRt8SEpgtFOqEZFMtLn5tZ4yxFzVyKh/xBQUFBUbXVFPQr3RiYaPJDg/AMdpbPN2an9iIUhZZ9MAKDpQZAk4bZjXXKfVC/CQXxh1CYNc2Ji4hROedX09X7l4ZgUuvb0fmdEziOz0PA04xnhSWhYOcovd+YNehPUgg7n+zI8W5mqwuBrI1xjQW7Dm4No5400XBby3eAffDBqkU9WQNiegNEj2t3B1lqNU34AbJBBhX41rrdUV96PqwHoeu+03YzTNqqF09/VTyWtamC+rSckZj72TBvJymr9u3YKsnLnEpVPban9nzut/EWTRkJp+OmDVriyFEBPChXO0TOZFF60Tg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2966.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(52116002)(7696005)(8886007)(186003)(2906002)(86362001)(8936002)(316002)(8676002)(4744005)(6916009)(54906003)(38350700002)(2616005)(55016002)(1076003)(5660300002)(6666004)(66946007)(26005)(4326008)(508600001)(66556008)(956004)(66476007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GILSx7+G1r0AaVhEDDvgih4telNixF7htEg7w9SoLuwSgRrHgTfg4NYyAqeP?=
 =?us-ascii?Q?msNr6kF95KQvvdT+IDFQJe89dJsb9DEkQVCaRkG7Po49YNFy3vihbConjF1f?=
 =?us-ascii?Q?yFDgkOtPOIZVsVCWjIkCC3D6GCE8wZR8b4HOKaV17uaeb/hMeHmEmqNPoi9G?=
 =?us-ascii?Q?kXx0CcTuII4GqdTwVQlhG/h3i9IRIYRIgdo6K4ln+OsixOw+KsigLFgoE7Ie?=
 =?us-ascii?Q?C0+I0dKPQSoU6kmZByDt9d/+R2QZMZ6yhLLFDsgT2z09p37gHfJQwnmgbuwX?=
 =?us-ascii?Q?2KeNvghah6ZsHK3vLdgY2NT0TwtXdet9P2YIxR4R78VH8vgGVJoEP6CN4AAl?=
 =?us-ascii?Q?7bi1WmlsnUftZfHer5MjDIwEG62eNGp1OT4mJCqp6ycIFY2ZiFiv93Oedtu0?=
 =?us-ascii?Q?CAQhwJlPTzVCY6HOiPfJ8APJRu5vq5TbLPldcouF1337+dArfZwh1jZuwCpP?=
 =?us-ascii?Q?u8wviKBydh08uWijMxy2BgPXXteB4L+3bxt5ocSxNPXiu929WXYJ7ydMGcC9?=
 =?us-ascii?Q?h4K5KRKmpzsV/vFSNPVEhbNDQ7HTKc2ByLNxM+RJcDi7XhmC6MRBTJbbkp42?=
 =?us-ascii?Q?XTfsgVjI+UayYwuV7TyqHO6X3/oHdMiU8E2VaT2gI2GuW/UxRwgS+MtiINqK?=
 =?us-ascii?Q?vAvYXfBlLIIS++HVVGZFCj+jiIbVhijPYWV5+Y+j9mcu83/YGiuPysl3g/Co?=
 =?us-ascii?Q?LpwFCwCsFcBqEQyji1xwCBxhkIeSsW2jx8MJifzteCU++cvJGsKkP/BK3BuB?=
 =?us-ascii?Q?9AuB9OsTdoJGJnUCeyDPuNWGWlwww0NO00TpW2O+8qt67p+8ZkgitxpIfKXV?=
 =?us-ascii?Q?Uu6wmbxt95uawjEQXjOP7k9dNDLZFAIBIn6cm7FtR80ZNdKWfbX+uxEyDQNs?=
 =?us-ascii?Q?w4B0DIkmxbY2y1gPsJO6xa4TKZ5AaT+tbqr2cA0e40Y49GiQa1TX/fQhohtV?=
 =?us-ascii?Q?5J99fAM5s+GdtY6MhwCm7aWJJNizkCaoLDnQV+WNUb94Q4epVuKdzQw+s3Hj?=
 =?us-ascii?Q?scgoi7TgJYXu1CUTZItFdC41jPF/seeoSDufSqypnKBTnhjpVDRJmFWNcCbY?=
 =?us-ascii?Q?1DLU9HHjCz9O+bwg/Wnyt/s9dUg1OpkttFPaM4WKXx079mO7YbMrkInKKAX3?=
 =?us-ascii?Q?V3P2UQVRUz0PCQx43+WKiZ8z6JF7Lyn+cLiafkT64G5ivdoHFgIbRjKMY2HH?=
 =?us-ascii?Q?qWNo2zTx+oQLLLo8XuJbk2aDQvbwmg7dUyLPwH3/w6HUqwFM/j5N3rYTMK2v?=
 =?us-ascii?Q?ebnte4g/folDDu/u5XIzLrCLyn0ZSFJ8LE/eMER5K8uQXyxLFatelXcZU6HD?=
 =?us-ascii?Q?yiVueX1R7Nsfofd8I8gvnihS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b51b3b1d-7ba5-47e6-017c-08d94afeb92f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2966.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 21:46:54.1958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jqL9Av9DVttJGx3sipiVLRksIJLDSWJSCasDjbTC+9cbxQhmQXtKu0TazmrYbSe4Zm+dLqGDfyA+UH53Bh0Bf1OrUU6GH59aBKq6UNahEaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2790
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=915 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107190125
X-Proofpoint-GUID: n_5PneGdJLQJ7c-9PZ7UFwOkekUA1D1o
X-Proofpoint-ORIG-GUID: n_5PneGdJLQJ7c-9PZ7UFwOkekUA1D1o
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 19, 2021 at 04:37:33PM +0800, Xiyu Yang wrote:
> refcount_t type and corresponding API can protect refcounters from
> accidental underflow and overflow and further use-after-free situations.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

This patch run on a big server didn't turn up anything, but it's
probably useful to have the extra checking.

Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
