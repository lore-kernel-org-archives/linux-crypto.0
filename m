Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFBAAC4338F
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Aug 2021 14:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBD7360F41
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Aug 2021 14:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbhHDOw5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Aug 2021 10:52:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30038 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234423AbhHDOw4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Aug 2021 10:52:56 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 174Ek3kT025106;
        Wed, 4 Aug 2021 14:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=FbBoMJyUvfQjOK3NCY29cLc6m5Tp8DZjvqUBfdCordo=;
 b=vgenw2QJOg+M+QEeUNUdOXDR9eop+59Lw60MEv7PjF/7TRDBCJI0Uyfh1dtXl07zRZzH
 4xMMH7EKpq+/Fc/8CyeHRfHLDYsjD6cu5yIp9Po1ACypMIxajFW66RtrQZmOaMTRSBvV
 mzcOCK0jnxTsFAMiqoVq7AzKss5bqh34zkiJTj83923o/7hdP7YHuQihjxQHLPF8NYYG
 Z7xA6xtyqmr14ZZMZcla59sivkzR9mgE3Tc+XYsWEsdXCi/0qZE3qSUjz5dqraaUg14D
 5K17JQ++cVxh/PQBAZ4LQvZ10NzfCG2crvWLmGya8dMiUuPYGCDJ7kHCJ/Hytg+x1JUK 8Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=FbBoMJyUvfQjOK3NCY29cLc6m5Tp8DZjvqUBfdCordo=;
 b=NsLrBgY4lP7KcyBZB4T0hKGwQQ8OhvVj8Lpn6vGqXJmldEWNmEPUR0kiqtxsSQUvIhac
 5gpOBCpXtf/g4mKqtUKCXq7dCva4r/aREW3fPY87RxaVf7k4F078AM0yQ1/tkaKAcA0G
 ps4ZYczcy/BP4YNmv5KYckcTRQUTLgvy5OqrzpWyom2311b+EdtiJWTZQBr/Ft1OTLjt
 PQYGpfFWYvg6jvim9074JM9aT3/W2sw+sJYbEtIcw0pQwdQqSiW2dKIAb87Viawl5Cvm
 7zaLiQo67sfFNkwSxa3Xsnkmmwa4EfLJK3wTjFeyYNpc26DyWAasfyJUWpMKFn9+59qM kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a6cntpn2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Aug 2021 14:52:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 174EpP5S183328;
        Wed, 4 Aug 2021 14:52:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by userp3020.oracle.com with ESMTP id 3a5g9xafxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Aug 2021 14:52:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=baGIODcGBKe1lQ//z+xIpuPUFv8AinTHruyR77E0cyHA0cke8Psc5jgd9Xt87mE17cBeruWrPbJj5kLsCZJYg2Tp7YPPcOpcvpShbggKz+xcQDAlUfd4J3fUF45BNOnB0XNAtokS6vTdW986Jv2mU6IbTO8IgdmzTifcnuRvAgxJVFs7cE6x1qhO2F0E4rvD1NHLIkhS4EPdbob9nIyc0HC4vKYIuBwKiassmicviw1L69GvOlxH6pxglavidGRAwKPAVU8KcTD0Y+PKcGsN529/a8zhzS//h/89m5ebZuUioG+yFYrGL93d0KS9sMwe9/SpeHaISa+kT2papgdgHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbBoMJyUvfQjOK3NCY29cLc6m5Tp8DZjvqUBfdCordo=;
 b=JBjH2Mnlk51aJpGNtZnWw6JrVzizuCliHXP2dvwvw8Af0eo7cvy1uDY/KCPJk/Arjh4V+MNfPEoT1XUCqiKe7DPdrkAA+iUkYn+B2wYipkmdnTasrEybHLoGSUnKDXMlhqvuzQOW0gtc9Greq+2qBrsN0P4KjqoWdhg5TDmGNCxlrJfKcqYNay+/Wy+M+3gBBU8cbuWT4BMOz+/tjfKWMRexTcHZrQUh7FEBgjtZREypTV0xpdQaQ5LTgI46rR1UsUgh/a9hp/kDt/zT7CMPgV3qLixqbNFe93EzSNvTlpes1TWovQpddBs8lSbRf6khAcfeYqAdIi5bkXDhUBTqdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbBoMJyUvfQjOK3NCY29cLc6m5Tp8DZjvqUBfdCordo=;
 b=nfBBEMIBnAHhYgn15pcSjUwXsLuivG2cLPiUFLqlNT4MXLXb7lG6QxCQeo+DGWrNC6Z/l+r2n8IYTDZoosGcnj5uCMekd4mUM7UE4Nb+aNdBJkueoCYy+WB+LHBEJDgGNRLdiEuLLu+yPRdhlXKnIDz4giiEl7WXtUZZmu865kg=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27)
 by BY5PR10MB4321.namprd10.prod.outlook.com (2603:10b6:a03:202::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Wed, 4 Aug
 2021 14:52:23 +0000
Received: from BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::9478:368e:93b4:6b48]) by BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::9478:368e:93b4:6b48%4]) with mapi id 15.20.4373.026; Wed, 4 Aug 2021
 14:52:23 +0000
Date:   Wed, 4 Aug 2021 10:52:19 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 27/38] padata: Replace deprecated CPU-hotplug functions.
Message-ID: <20210804145219.tun2tid53nnh3i77@oracle.com>
References: <20210803141621.780504-1-bigeasy@linutronix.de>
 <20210803141621.780504-28-bigeasy@linutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803141621.780504-28-bigeasy@linutronix.de>
X-ClientProxiedBy: MN2PR19CA0026.namprd19.prod.outlook.com
 (2603:10b6:208:178::39) To BYAPR10MB2966.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from oracle.com (98.229.125.203) by MN2PR19CA0026.namprd19.prod.outlook.com (2603:10b6:208:178::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Wed, 4 Aug 2021 14:52:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f35b2532-ab04-418a-f153-08d9575777a4
X-MS-TrafficTypeDiagnostic: BY5PR10MB4321:
X-Microsoft-Antispam-PRVS: <BY5PR10MB43214CB02578B06D5EA1723FD9F19@BY5PR10MB4321.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r/+BMYwZQSj3iIKk4zHcQvsXkOjHJmWJYbvd0iLpesyZxXEFzdunNmHHUZJ9R1SCf9hm2EzZVuXnsLrr4ryk939Ovq1e/46thPM2Op4e+NXD20429mUm5+CnRdWJGQ8c1QNY3ust6sl61zjDHJhbybZ/VTsONXTcMz5A1gXnHzkOzPW4TdbQZh+Wq75alOtieQHyl4piZlQdJnIhvyhv33y3cUWoGd9J1k3cwBugZP0RkIEsjwXQuH3hG9TTvdRZnBqDiDXAiZj/k3F7sj+GWrny2hGPBBidhHOshgV9uBQ4nyk5du/x+LzqOW9J2afKq845F0ftPVY5vkg4wIu5IMSz9daaKHCv3KsuXAVlYCUwGwshSUtdK3qFMve0D8SS9znBlplCp1Gx3gz4Q0epUS9gjFByy59eqCMXLy3h20fXpmrN5tKVLsXnpc9d2/O6AXqUv6ikInBRXrhyufgOwCdpqjElBd6mJTrJPbi3rE6/8NsqdEwOLfefPt+5oo1KQ5ZAJAI5GjSNk9N9FMAw5QY5trjV0rrhJBGqlocu2HcG9BpQveL+JOH+iUeqr6wzQXYdaWKg9Q3RetK9tS7hCm0nxwokFYQnaGKHsWp8VqU3w3MKlJpgFNW4OfVrpQM0y5qvgW4zSGrpwYQHp5vlQM+a2AdUA1iskf0afC/uyyBCMzZrhmVDZabKzOON1ObgILJYnLSSLCPrvWydyHNNHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2966.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8886007)(52116002)(7696005)(36756003)(316002)(66476007)(55016002)(1076003)(54906003)(8936002)(66556008)(66946007)(508600001)(38350700002)(38100700002)(8676002)(4326008)(26005)(83380400001)(5660300002)(6916009)(6666004)(4744005)(2906002)(186003)(86362001)(2616005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M9W9+8rJOgBlucmVqQ4e5cFwWRx2GB15CLnZhpm/x4HK1A/ckkC9debbU/oi?=
 =?us-ascii?Q?uOF5RWpBrhdd8tL0/sg+73e2QzNEJkWb1//csY9v015hbeIQvFw8q9K8C5XA?=
 =?us-ascii?Q?br9vrz176LOrFrIMAD2peRDPJjXr4lTV4Ao/KLZFLCiTFWyDbth8QjfM6G0D?=
 =?us-ascii?Q?7T2j2CjlHaqJ/IIXtlE00vKXP81u3h73EMA+4yGPx3KigXtrdImxricyY0Oe?=
 =?us-ascii?Q?rQIgWFIkB1RTMu3hxRSocGPQqw3oaeOLdA+s5SDxewQhUoM4dDQyEZOuw4Xk?=
 =?us-ascii?Q?isV0ZfcSGLCzAMMtt3YZl9+rqCFdad/6aTPJkZD28ORqNoXyawu2JNmrq7zP?=
 =?us-ascii?Q?gunxEAz2AfzTkW85pb/v3QEOjMh0BCq8Pl3+6OSefI/GM77PcV93MD2WCuBv?=
 =?us-ascii?Q?olydNpBhI3sNGdsnQVEzIr7qnn4xEI06EOIMeIt6z4gCOG0KmNwgkzXOyOYe?=
 =?us-ascii?Q?1xgkBCZIAhvR6Q9BjLKa8D7pCU9AwrYiRGiZcc2ZZeAFJon36pilxLCK2MDj?=
 =?us-ascii?Q?kW6EzzuHPpVm1Hcvn9kZniv58rFJ9i4Hiehq+rTL4u+P/D1mNUwqsZhsXNNb?=
 =?us-ascii?Q?KQwFT89gbs7i3yZUKrkASWo2WcsyaCoAWMvOMvluOC3wO8ZnmElIWXVzRa0M?=
 =?us-ascii?Q?cUViizmrXO+N2H2pnZGoEpC1gdMSCJcZAFetehY3lGh3pHCkzH39r2zW3UBe?=
 =?us-ascii?Q?BRGX5qntyiQJSKAgHogl3adASAaEJFR7NQECLAbpEBvgqW1qvsJ9SEhsz+yh?=
 =?us-ascii?Q?n/yKkpvBivegNZybE9/V93Ay9QfsRPLNmDnGBZ6Z0wOyC5sQR4MeYIt8G2US?=
 =?us-ascii?Q?wXk8dgojWYRLVg2fpAeCD/XIx5TNdw0FAEJpKd3Va4XeJgFdO4UHYcDqnCA8?=
 =?us-ascii?Q?7w3FKeKbQn0e351IZ2qtzCABexclWui2rnM1+OTrsqeHkyXxf/fw/iX57pPM?=
 =?us-ascii?Q?gHZrmf6C21RfYC05HNxUYojK9LCx/lUczoXfSPYEmos6aVz5JXbXYBoDRapQ?=
 =?us-ascii?Q?Y5rdSXxRolgsjdepm3rOQnSb7qVq2mzh2ZeF0P6uUjJpvaJRODCf8nv4AI9K?=
 =?us-ascii?Q?X4zkJ6KPrZUcrlXkJg3KNofs9nRCkypdOVp6pKZSRUnbDklPfg5ajOxlgtEv?=
 =?us-ascii?Q?OlrN4wka/VUuQlBLhvcd/fMe9ZzsJRXfXWKuocZDCXJrTfSEmKG20YNfugl4?=
 =?us-ascii?Q?Znp81Hw/2AheMukrSH+KANub+KxqHBQ+8Wyh09KNQlWw0GFSnZLlG7qZuEeZ?=
 =?us-ascii?Q?Gy5pifFZMZsrK3Mo7JHxS2z8mfxhpE99nHjzwEmqFyRA7txS7JDItlBoWVV4?=
 =?us-ascii?Q?YmKUh46IS6wUhSmSIkJyubL9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f35b2532-ab04-418a-f153-08d9575777a4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2966.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 14:52:23.2674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGKyppF08G3dB1lotniRYK6OXWTAEVacY4/Xni/5GteP+rHYY41iwInUnv1xWvTkaPgXpSBEnR5wp9+9rsWpgGHW5VcS8xQRNwplwrjSa/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4321
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108040083
X-Proofpoint-ORIG-GUID: wkBSPEo2Ta9zoONq5MpwFKB5ZtLeutzP
X-Proofpoint-GUID: wkBSPEo2Ta9zoONq5MpwFKB5ZtLeutzP
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 03, 2021 at 04:16:10PM +0200, Sebastian Andrzej Siewior wrote:
> The functions get_online_cpus() and put_online_cpus() have been
> deprecated during the CPU hotplug rework. They map directly to
> cpus_read_lock() and cpus_read_unlock().
> 
> Replace deprecated CPU-hotplug functions with the official version.
> The behavior remains unchanged.
> 
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Satisfying to see the old wrappers finally go away.

Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
