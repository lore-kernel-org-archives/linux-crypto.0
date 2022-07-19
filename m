Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6B3C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jul 2022 08:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiGSIO7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Jul 2022 04:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiGSIO7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Jul 2022 04:14:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0C0B5E
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 01:14:57 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26J88Noj013960;
        Tue, 19 Jul 2022 08:14:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=3qnAHFJWpVPIfZwGOiGfooTazcZPweywWCzhYgtU3mo=;
 b=Y6A7Q31lVmJz6/vTRubUb09zlRmvL5QEbvdpGwkzw4ifJ/TEi33oi948ZSqnNanu231k
 E8GAzZ3aCUCWk1bYZy3iVFpR/mawIQLrgexFo+lUCrqsovmXAxZO+TWQb/3vgBWP0+mo
 I3gbtx2JhKyIIFZwcyE1OJHVJK/f77gihwU1sRXzGq//0n3bDjyhNW7jaoOBc1yxzXdi
 zljPgJoJ6cP5IgECJAYjuHMepWLsj/J3ZcYeGQ/zaXKHcp7MxakqQtsG3XdkScrHoK8v
 NHzxDVbKAkE778ke2+6HGnl23Avx4URn9AzBJNnICVoCS5xLX6sShzHm27lC8vM7zNM2 SQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbmxs5f7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 08:14:56 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26J8CNWD018724;
        Tue, 19 Jul 2022 08:14:56 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k4h9dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 08:14:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zq7QCRk+yu4whUjFBZ7i1pdFqDO9tAv3N+jlrX5K2SFnLeAr1ncv7e0ED5ih0i3JEi6anejELxwkTkj593FECQ9uD1AidAdZEd/iQIzqVMlLlemmEugFX04yIhBu1qvKRAYJxjXx/K/PBEX31Mu4E/BctXSXB0OpCE6KNqFhhGLOVFwo3JmjnnuSF1OdJj4AWo6meSqqCW1DzRjAVV5YhNTy80mhe2u+OzSKuDxEVfGRc2ZjQQ/q35H3v0zFcnYFlkgMTf72qg7ynQGTTvXRxpVl1tUFTlLtjUQVtX6J9rj5kosUmvoEwLkTydhjo5zJtJ9BzyNLSdCWXjKO6cCxNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3qnAHFJWpVPIfZwGOiGfooTazcZPweywWCzhYgtU3mo=;
 b=guOns/yI3SGCPymB8lPvmM9bmxg20/ELFUZIjvLqyotVWk1cv0myk+ZyQSCuK9q8e2qth5s1PLpw8DGvwfOEZrtIgLR4tpiDA+BBb0sp3J11FeKO/88p9gBUUS3oG7Jh2j+F3HtKvsMR9MpvrqQ9vZ6TA7aKO3HBucALS39peQE5Ua2oqOnDC0DdPzgPulgdRfD/ttvIi69uUtbwNGcofSe83ipXsYtIVufn+CO1THVUx41B6kkParitWskoMH08mRZaeU32z5mc5e2qgTsJJQT2VmJYu8uPaZcaCyNHnZpMYlnYGvRzE4k2iUXCE0REG58SbVgAxNcFFcj0wvbS6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qnAHFJWpVPIfZwGOiGfooTazcZPweywWCzhYgtU3mo=;
 b=wLVaf8N8/JdDyzkjgtpz8NCOxInA8Sxv/rLo1VSouIcRftI8OLucK4noQ2KmBxskk/FI8MgbAYE4jVg6on22WqdhlYdrSryahMOe+E9o2NSMnWExwpoT2NKmlD6QoXSpmmR9AoimKvBMfyYmK3hDdNyLTQ76ztyIwdqOldxHTy8=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BYAPR10MB3029.namprd10.prod.outlook.com
 (2603:10b6:a03:8d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Tue, 19 Jul
 2022 08:14:54 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 08:14:53 +0000
Date:   Tue, 19 Jul 2022 11:14:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     ap420073@gmail.com
Cc:     linux-crypto@vger.kernel.org
Subject: [bug report] crypto: aria - Implement ARIA symmetric cipher algorithm
Message-ID: <YtZn9YdHZDDBWzoC@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZRAP278CA0015.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::25) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da873109-4d63-4bb4-c13d-08da695ec263
X-MS-TrafficTypeDiagnostic: BYAPR10MB3029:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dtCx8Ro5fnLWzf7WJd7Q1ZJ3XQCmM71ghg+7PzhN4r0LkNGzJFYFtMZU48p2YO5SE+3/iTLihD0ytZRHFyj5ZM7ngcyVLGRYoNlPLVw7X7g8a7GDbJU54bacxreWn5Nc5naOi49IJdyY8wrcTmkgKot5qp5ubZDvnR46xqtA9VC0uBaJLBb3DSXe9XF0d8fUvBzIFOhKQRjJu9CudgWuVk5U5Y78+MW1b38NqEg/evkirj3UuMBMTs/khXU5C/korIGZ+IwAjad9VzHZ1fnOaZ7gmuL97ICacAki/EwtNGKxBA/MyKY3vMC/dLQvGNr1qk3Bz18oLo+lzQYEv4msQrRxBeA5ggTsGqOD7LMWAeakuTSzEOmrRPVFlko/79sZ7weBQFijmCn+EUGjdyHwHQBy8NWsyV2MoNuJzl7x51P8Msb34T25mmQ0n2GrmpCo88n9cK0VAMW22dFsgBGeh6Q/80UD5GRFwZpYsA/FX6Um4QS6I1HHl8waw/q2LcfJxhbTiy72ZZj12KwBJ9taV4gaLni7lYl8yIpHEx5uIrVPIHD/a0qNV609dLVS2yK+i7MOqnmk3ogJYco77FSMHjIwv8KxsSJjWONT60ZaeIMMdiuUvWTH486TANHqIfg2ZYo3SDlf/VaFJ8bLlbhK8Vh/2sRWPspokSDJpjqHEQIlJZwClLhozAgYDqRF9uA+wgnlqPXJnH9ISBkGo5BzWbCJNA7DNcmAdNCw8HnwOhfbeWhsOHoY7uyoEdfnIlPMNHOAfl8J+at1hHNGg7cJpsSQj/anjZKk2/hbGsExcZHdUwI+m/xKHvMMsB2NYFaB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(366004)(396003)(346002)(376002)(136003)(6486002)(4326008)(2906002)(8676002)(66556008)(66476007)(5660300002)(41300700001)(478600001)(6666004)(86362001)(8936002)(66946007)(83380400001)(26005)(9686003)(6512007)(52116002)(6506007)(44832011)(316002)(6916009)(33716001)(38100700002)(38350700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DE7jP6oNYUjQZDEVs0epjdA1Aud4AZQJRd1mT03KK5AYxmksTe5viAh8Jdgi?=
 =?us-ascii?Q?yluhQXWCBABTKdYlhW+anTk39LBW/tUPXIautrnccZnMywQ3pyBCszTlPVs6?=
 =?us-ascii?Q?6PKLyo9fP1eLMq4Z9EEkqpsp5ih2S0CU1TLvMK3u9TaLjsPJKBW9m3ExMK1d?=
 =?us-ascii?Q?uaO+mEAJEqUrMGvEyjqPH+olV4jxB2C5qVhykJL5fbH44/Z2/0monw4zU9fY?=
 =?us-ascii?Q?2fXZC/uAqn2nqxaYIsLYnudx7eJcxB5oUAXNZ6td6zZW/qxDaO53X8PEzS08?=
 =?us-ascii?Q?nG6t01tsxx7DhQquh6590/UY7mSKh/wOW3PWwqUB+AvjtvTskpShZB11u7Sn?=
 =?us-ascii?Q?ejGHMsNcA/eEn6wo+eE07kI/mbAiIn/jmf2Tl+kT0STee0tfdtXrlRhwo3ll?=
 =?us-ascii?Q?wtu8ZuGm2ouKNeGyyZmGNug8FImhZSOx3mi1cKY3ONvc1350LkaVBr9P2MNg?=
 =?us-ascii?Q?tKjc3jZX9rgunDwEj2HH2AJgY9sDvTB7Te+IjxHeIH8OKGiXZXFNURwv3x7n?=
 =?us-ascii?Q?vvUQrBG8y9BmEdblLYM4gKcg71ibbDeEgnQWOTxLzaHBeyaLReNypsBvvSH+?=
 =?us-ascii?Q?F/CXi9J93ksBcBFAHHe+zdUwQyqd3Q0XTN0uIOSRdVMUiVWNat6xGvQm0UOH?=
 =?us-ascii?Q?IJX93AS6RWDaYQO6EgQe6bGSoFz2pkDWoyB4Nbk8BKqV5lrkyeu4vbkIfNUc?=
 =?us-ascii?Q?bXSbUvC6fZufJhOx1p//k1CqfxGnKtvzFImQESX9844pBPTtskBbrN+ySQc7?=
 =?us-ascii?Q?QNiCOweGuPFIUwhSkaRhcVde8BUfmVdKrgqorsy63KDEhpoB0Vz7tlQKAevE?=
 =?us-ascii?Q?utdikWVFlVBdKsPXVaLM1vigRhnL7X9jHIDk0CT4qp9bqZ0R1TaSGHtH4vJA?=
 =?us-ascii?Q?pC3g92OGv/ukWM8Hw6LqR+6+cRcGZfRmee6v9ZPSFmfQmOUFIwMeFZ/9W7hv?=
 =?us-ascii?Q?+CjRrsTINnvavyPUYR0tODsqU4RX2TQDCpnoT3CNDz94oRLD1J2J9Q0n5i/y?=
 =?us-ascii?Q?1T8jeShAukKclRvXeV/WUCFM+C2KsR1n1xo1v/YO5LkDKVaWMsqi50Cw9Q9J?=
 =?us-ascii?Q?Y1TDLNgzuTXJYqo/03RiMRyKKSru+wA5ivrsM+tuMajICK2pjc/oVHJwbMTO?=
 =?us-ascii?Q?40+sT/aVbUHoDNROvI5jntSdLOf9JXGfYV4IuMJeRUQqb06sL+VDk6gQJ4QE?=
 =?us-ascii?Q?QudiuJF0E/G++elsp46QLvpu4k0vR1MI3H2/v3KNuLkw0KqOJfLFzYMNvuJn?=
 =?us-ascii?Q?V/bcMHw4HWPt64BQ4Qji43VRdw7XhAeALaZSdSRB8TP5S2CKEUjSJWr9mCLu?=
 =?us-ascii?Q?Kv+ZFgDZY4rjJCilSt/qTMnBW3noLW2nwilF1gcq+8nAYtnkv+PEblsuaIw4?=
 =?us-ascii?Q?RkopXKvg1BKiaNtfjyt+IuXuWBbOdjeoiFSeZ9XtIpANRlSUjNe1P8tU4CyO?=
 =?us-ascii?Q?XHrMyrMyTtKSFMN1TxZ+Bnyms9dXPHLFrcO5Ll9T5hJUEUgvPy0HDKU4biwo?=
 =?us-ascii?Q?I+bZ35nN3OdF2TPipJFJeawOMgeoIoH/WTEZZyuhQeoOXXYgxVfN+0wPeEGw?=
 =?us-ascii?Q?W9eJmxPg73PJtwYyqnHLyOkIbwcD6SjYNVeKcIesu3Z94gDtz7ZoeqITFtUX?=
 =?us-ascii?Q?1A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da873109-4d63-4bb4-c13d-08da695ec263
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 08:14:53.9099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gaLl9RrD1NmVQj0Y7oJQ35K2swQPeK1hn1qhPL4FSZ9zEZCk0R8kSc/T3/ugqpmKBhEMU0zuvos5F4qGH6T+oKLbXTTiqUBAnGU0CRfFQT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3029
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190035
X-Proofpoint-GUID: gOt_nSCECd94pilCuzY82qCk6_giQ-8O
X-Proofpoint-ORIG-GUID: gOt_nSCECd94pilCuzY82qCk6_giQ-8O
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Taehee Yoo,

The patch e4e712bbbd6d: "crypto: aria - Implement ARIA symmetric
cipher algorithm" from Jul 4, 2022, leads to the following Smatch
static checker warning:

crypto/aria.c:69 aria_set_encrypt_key() error: buffer overflow 'ck' 4 <= 4
crypto/aria.c:70 aria_set_encrypt_key() error: buffer overflow 'ck' 4 <= 5
crypto/aria.c:71 aria_set_encrypt_key() error: buffer overflow 'ck' 4 <= 6
crypto/aria.c:72 aria_set_encrypt_key() error: buffer overflow 'ck' 4 <= 7
crypto/aria.c:86 aria_set_encrypt_key() error: buffer overflow 'ck' 4 <= 8
crypto/aria.c:87 aria_set_encrypt_key() error: buffer overflow 'ck' 4 <= 9
crypto/aria.c:88 aria_set_encrypt_key() error: buffer overflow 'ck' 4 <= 10
crypto/aria.c:89 aria_set_encrypt_key() error: buffer overflow 'ck' 4 <= 11

crypto/aria.c
    19 static void aria_set_encrypt_key(struct aria_ctx *ctx, const u8 *in_key,
    20                                  unsigned int key_len)
    21 {
    22         const __be32 *key = (const __be32 *)in_key;
    23         u32 w0[4], w1[4], w2[4], w3[4];
    24         u32 reg0, reg1, reg2, reg3;
    25         const u32 *ck;
    26         int rkidx = 0;
    27 
    28         ck = &key_rc[(key_len - 16) / 8][0];

key_rc is declared like this:

static const u32 key_rc[5][4] = {

    29 
    30         w0[0] = be32_to_cpu(key[0]);
    31         w0[1] = be32_to_cpu(key[1]);
    32         w0[2] = be32_to_cpu(key[2]);
    33         w0[3] = be32_to_cpu(key[3]);
    34 
    35         reg0 = w0[0] ^ ck[0];
    36         reg1 = w0[1] ^ ck[1];
    37         reg2 = w0[2] ^ ck[2];
    38         reg3 = w0[3] ^ ck[3];
    39 
    40         aria_subst_diff_odd(&reg0, &reg1, &reg2, &reg3);
    41 
    42         if (key_len > 16) {
    43                 w1[0] = be32_to_cpu(key[4]);
    44                 w1[1] = be32_to_cpu(key[5]);
    45                 if (key_len > 24) {
    46                         w1[2] = be32_to_cpu(key[6]);
    47                         w1[3] = be32_to_cpu(key[7]);
    48                 } else {
    49                         w1[2] = 0;
    50                         w1[3] = 0;
    51                 }
    52         } else {
    53                 w1[0] = 0;
    54                 w1[1] = 0;
    55                 w1[2] = 0;
    56                 w1[3] = 0;
    57         }
    58 
    59         w1[0] ^= reg0;
    60         w1[1] ^= reg1;
    61         w1[2] ^= reg2;
    62         w1[3] ^= reg3;
    63 
    64         reg0 = w1[0];
    65         reg1 = w1[1];
    66         reg2 = w1[2];
    67         reg3 = w1[3];
    68 
--> 69         reg0 ^= ck[4];

So 4 and above is out of bounds.

    70         reg1 ^= ck[5];
    71         reg2 ^= ck[6];
    72         reg3 ^= ck[7];
    73 
    74         aria_subst_diff_even(&reg0, &reg1, &reg2, &reg3);
    75 
    76         reg0 ^= w0[0];
    77         reg1 ^= w0[1];
    78         reg2 ^= w0[2];
    79         reg3 ^= w0[3];
    80 
    81         w2[0] = reg0;
    82         w2[1] = reg1;
    83         w2[2] = reg2;
    84         w2[3] = reg3;
    85 
    86         reg0 ^= ck[8];
    87         reg1 ^= ck[9];
    88         reg2 ^= ck[10];
    89         reg3 ^= ck[11];
    90 
    91         aria_subst_diff_odd(&reg0, &reg1, &reg2, &reg3);
    92 
    93         w3[0] = reg0 ^ w1[0];
    94         w3[1] = reg1 ^ w1[1];
    95         w3[2] = reg2 ^ w1[2];
    96         w3[3] = reg3 ^ w1[3];
    97 
    98         aria_gsrk(ctx->enc_key[rkidx], w0, w1, 19);
    99         rkidx++;
    100         aria_gsrk(ctx->enc_key[rkidx], w1, w2, 19);
    101         rkidx++;
    102         aria_gsrk(ctx->enc_key[rkidx], w2, w3, 19);
    103         rkidx++;
    104         aria_gsrk(ctx->enc_key[rkidx], w3, w0, 19);
    105 
    106         rkidx++;
    107         aria_gsrk(ctx->enc_key[rkidx], w0, w1, 31);
    108         rkidx++;
    109         aria_gsrk(ctx->enc_key[rkidx], w1, w2, 31);
    110         rkidx++;
    111         aria_gsrk(ctx->enc_key[rkidx], w2, w3, 31);
    112         rkidx++;
    113         aria_gsrk(ctx->enc_key[rkidx], w3, w0, 31);
    114 
    115         rkidx++;
    116         aria_gsrk(ctx->enc_key[rkidx], w0, w1, 67);
    117         rkidx++;
    118         aria_gsrk(ctx->enc_key[rkidx], w1, w2, 67);
    119         rkidx++;
    120         aria_gsrk(ctx->enc_key[rkidx], w2, w3, 67);
    121         rkidx++;
    122         aria_gsrk(ctx->enc_key[rkidx], w3, w0, 67);
    123 
    124         rkidx++;
    125         aria_gsrk(ctx->enc_key[rkidx], w0, w1, 97);
    126         if (key_len > 16) {
    127                 rkidx++;
    128                 aria_gsrk(ctx->enc_key[rkidx], w1, w2, 97);
    129                 rkidx++;
    130                 aria_gsrk(ctx->enc_key[rkidx], w2, w3, 97);
    131 
    132                 if (key_len > 24) {
    133                         rkidx++;
    134                         aria_gsrk(ctx->enc_key[rkidx], w3, w0, 97);
    135 
    136                         rkidx++;
    137                         aria_gsrk(ctx->enc_key[rkidx], w0, w1, 109);
    138                 }
    139         }
    140 }

regards,
dan carpenter
