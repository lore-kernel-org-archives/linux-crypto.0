Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4996DC432BE
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Aug 2021 21:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C2BE613A6
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Aug 2021 21:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhHWVOc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Aug 2021 17:14:32 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:18456 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232710AbhHWVOb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Aug 2021 17:14:31 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17NHgqpw010647;
        Mon, 23 Aug 2021 21:13:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=UVzc4s8Id/HwqtuUqQgnF9rDDucrlWdKgtv0eHFFCXs=;
 b=jKXsyiTj5BGytpaJo1hzDxKoQ/uFG33hJ3Pdz0q3QfVriSEpN1s2pqkblm2GW71TgimK
 InGOtuq2jPM+dwfn/Rizf3UtepsWQxD0UT/czban5WlpOoc9sU6wH5CkL3fqUY3Haw+E
 aumk7flUxNAXo1rW6xZF8VXPJGapnOciW4yflzKIyNk2NoMOGFHnQ4GNTUnbJ9c/wfK4
 Ex8tyoQJniTgu+OtJ8nJcsWNtrkHWeAVeda4crzimuP7eOUafGIigUiK+rlnYrVmBDPB
 ur9JJIwHbMOQplpNjNcRmhiSHtUzcXiFMfgXS/QWmYXkFC96pOvPiMhqGcq7FLM1qBwP rQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=UVzc4s8Id/HwqtuUqQgnF9rDDucrlWdKgtv0eHFFCXs=;
 b=kVAMsf8DNl8z3MPTStuGeUadn4vOXOlggId3g7ue+DJZXtKNvnAuDH5KBPcuJZxq+6As
 k5acpNSjUEPy9hy9NFTAUFOtzaxNUkCRzXpg+MSB9kJ9m/VT0vEcRxTNpc+EPVmGkfek
 BAPpjhRskGSh5xBwEarkqnMuK1WHW4FTrrd/2+g6EgUmWtPTsGi9OKisXMTxcyJIS439
 KLqJh2IjlPilCNJnxMM4hZiXc90vPNs9w5/idUGTq0cTQMlW3u/C9M8LQ83z7wOF67zr
 LeKlNizUlDl6JLUNPyEhRKl92ZCxb7LAadvgFkHO/kg7O46xrSC6tWSZ9DqnHxq/y9Xs 1g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akxreajp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 21:13:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17NLBCRU092982;
        Mon, 23 Aug 2021 21:13:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3020.oracle.com with ESMTP id 3ajsa41hrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 21:13:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JA8sJxcwEHGZmu6oHEwKv5BCEIvh0Ooa37vA7x/aNNZiHqRa7oVACnW91xqm+B7BwMbMRuWhFSB+4KAXB80gobfsJxuv8V6DOYy4ni9GeBxNGdzkWFPqkr0c57/debdEJfxXvi9rUBns4JciMYsV7sUMtJpzaSnrlPnRyDbLTCUP93WDB0Zkt34U2ivimZrGNkPmKz2QtAb0zMfnDetISo4fFdssRxYrujC5CsvuK4f6XUWMJ/0dFstN2QlXKWJqlTMo+Md2nWYWWwstNC9y6bFiJdYyuuH5gdQUBcwfsMfKcQf3B6WAAAYpeOGQMtF6ja3NB/o4qF6Kuqcv1ZACHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVzc4s8Id/HwqtuUqQgnF9rDDucrlWdKgtv0eHFFCXs=;
 b=gGw+L0Ht4IgHGWIqC5Fd2N2Og9t0pqNzsB5YSoCoa31nYGxAjIuxRIXnn8Sv4Jdz4UW2Fh7CWL01CtcxHfE5EP/9H2le8wBXwgab7iDxVItnADH5M7etTKZB1nYpJ42GVSFxF/E1M2O7kAoJNm7/Lks6UwuCdSi9JpXSmJMiMxkEfJ8FsWcEj/FqJFOdRGUrAzcbyFElcLTXlTnDyoq1SFgPrhVAbS+HqUVM3W7PfkVwV3/tzqGLhHUvUMEDY0Z5/2YIYboJs++ZZofJtIJlOyo20SvzSzEdKBqO43sciiFyx31mNC5kb7PdHNEVje84en9lf6Nwy0xb3odvSwlMIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVzc4s8Id/HwqtuUqQgnF9rDDucrlWdKgtv0eHFFCXs=;
 b=rCcMJhfFgMd+YH4y2g5JY8VszkrCQde8UYo+k6ijX8QVY8SOMV0WJ1W6bqW6mGyQSL6TJvq3zSRffNkqLQdUsrm7cwe3IP9G0R8/hWoiPOf5pGyHw2JuUwW56yiGpS30sDf53bhS04QWcvExpFbyfJB8MzqEHHN+K9cPtESCBes=
Authentication-Results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2966.namprd10.prod.outlook.com (2603:10b6:a03:8c::27)
 by BYAPR10MB2439.namprd10.prod.outlook.com (2603:10b6:a02:ba::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Mon, 23 Aug
 2021 21:13:40 +0000
Received: from BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::203c:7f44:c562:b991]) by BYAPR10MB2966.namprd10.prod.outlook.com
 ([fe80::203c:7f44:c562:b991%3]) with mapi id 15.20.4436.022; Mon, 23 Aug 2021
 21:13:40 +0000
Date:   Mon, 23 Aug 2021 17:13:36 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     steffen.klassert@secunet.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Remove repeated verbose license text
Message-ID: <20210823211336.yt4lhxtcdozq5cdi@oracle.com>
References: <20210822022734.1002-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210822022734.1002-1-caihuoqing@baidu.com>
X-ClientProxiedBy: MN2PR15CA0013.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::26) To BYAPR10MB2966.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from oracle.com (98.229.125.203) by MN2PR15CA0013.namprd15.prod.outlook.com (2603:10b6:208:1b4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 21:13:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34bdddf6-d4b8-49e9-221d-08d9667ae103
X-MS-TrafficTypeDiagnostic: BYAPR10MB2439:
X-Microsoft-Antispam-PRVS: <BYAPR10MB24391F192D5D6746E2CEAF89D9C49@BYAPR10MB2439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ixoH7jnthIwFJt90zM1aDva0NqwAgUIOVr4I5VwRpdnE4qftDEVTBNq7w3UawMzvgbjrQV9L/23/HpfRD3eNz9TUuerf+tFax+mrdzj01lShna8zpG6bVcC5AlW4PYF2cLhhMh9kWvSwZ7JqQ7OtPZZFUsT6WFGk9qZYeO07lnSO9iHq/VODkioaP4punq2mknOODr5xuecjPTN4zEUbvplHEcgpdNmQNd9ZjP8wGbod3NTthrnkcRaqjANHUC++iZmf7z1n62JdcE6zFszDh/1j4nYyb5XB5o/9x083FjHKYUvsDcyer1TjF1qQS5b31pHa26em54LUvZvoMPCWykF7Z50uv56BgthHhvDp5F2xobtWx2947go44VRBzT/dbft8CTYAIU112FY6w8I4yVR5WoMh/ywuQPchodXXPJ9EGBTlflG5R7DacjPSugmVK0GYe9JBuFEZzTJz0k70xan/FYKzkxKZP0114qdnwzEBn3Ov32dnD9/inka7e8NKBDMlj0eBomkpfPl1kqcX3lJWWGznlm5SPoXJgflt/4zxWjciDrM9M6cSSL4/4M3NrHmCT35ArBOC9zDGyB9ciy/SGCT4zQd/fU/yL4OQSVe5U1HYOTMf5EPnuv4qXXzQO9I1U0fPMw/lVv+6eYYsjMRf33UhkAdURCWORy6W5k752b3iLGLzur82Z/G0X2DqpH1ofjvm5VSDQCrbwGpFL9JWPwh1FdJX0vJti3M4BG0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2966.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(396003)(39860400002)(376002)(66476007)(66556008)(86362001)(4326008)(478600001)(5660300002)(1076003)(36756003)(6916009)(38350700002)(38100700002)(2616005)(956004)(6666004)(8886007)(2906002)(55016002)(26005)(8676002)(52116002)(7696005)(316002)(83380400001)(66946007)(8936002)(186003)(2004002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: wTH8NDPzwz4Jjn9pvVXMhHhyK4x/aVaxLmBeKLzrz2tNeYM163qktYboGILTFeWkwcWCWAqX0X4S99jmcCvY3mEDVothCowrc1bTjMvV/nU3W9aFXqLtOfVpvuIrpXWWK91oEoE4xK9SgnmZ88roo2nUN5kfLncFmTkxWUPpAxYO9b1DN0Sj5aqByfBbFLhne64GNf808HzE3X3oGkm8xuU8Vl5In3XU8PU1ToAXyjM8D1vvDUUN3cIh7fgbtv9ol2NbeRPvlMAy7c1VkF61Jkj2MycsSg9GvjpSP6HZwDKVUgnT9v5SKGScuDyKIClAX2TP/4fRT8bvnGYDO9zmB3gfrMk7sX5Y+vOlKVMN2Lc3MtLLLVKuRu+jlrAsFT6LlXBeZqQF7nPErhMwmqLfNAC305bqB+1KqKRW+PTvCvMhxdbfA1KmUBt1lVG3afdSh9ZOPBEpVDURDgHK0uQGx4ztNgLJuSQ02LTr3iwogv14S4tZmcBoX/V+YHpshgBqOpSXcsapIs4l8CrrZJyTyKWKSUgFStpGo8QcEC6uknSA/12g8EqaESBdJBaAMMLfGXeSaiUJ9dbUu7aWjRh8EZpnO3LKQCiA4EtqhugjeLrkEdmuzSL51CSPhxCF1Ru4Ux5XsHhYt3uqYbjDSQ2RXj5oblB41PDQ/xwR9g1rhj0obBDB/yd57mJ4UtDALZ/qZg1btXGhsc0EcIMbsFBXvzCpYsbYLBwJp0FH6cgd3R6aM56Dgr1C7Jd5UCIFUp7i
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34bdddf6-d4b8-49e9-221d-08d9667ae103
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2966.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 21:13:40.2104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fOiE/itUYmXvlEEeA4zSzDb+Hd3VrtyeSP9TK3+2EymfbSp8Ta+68zkOO/63i8LafFN/KayVkrcyHFGMo2su/gv3YW18lpmXie90wWTvKjk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2439
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108230145
X-Proofpoint-ORIG-GUID: 6q3vhLupaQcQCkSCPJRJZ9XXxbXuE1Hj
X-Proofpoint-GUID: 6q3vhLupaQcQCkSCPJRJZ9XXxbXuE1Hj
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Aug 22, 2021 at 10:27:34AM +0800, Cai Huoqing wrote:
> remove it because SPDX-License-Identifier is already used
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>

> ---
>  kernel/padata.c | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 3258ab89c2a3..18d3a5c699d8 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -9,19 +9,6 @@
>   *
>   * Copyright (c) 2020 Oracle and/or its affiliates.
>   * Author: Daniel Jordan <daniel.m.jordan@oracle.com>
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms and conditions of the GNU General Public License,
> - * version 2, as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope it will be useful, but WITHOUT
> - * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - * more details.
> - *
> - * You should have received a copy of the GNU General Public License along with
> - * this program; if not, write to the Free Software Foundation, Inc.,
> - * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
>   */
>  
>  #include <linux/completion.h>
> -- 
> 2.25.1
> 
