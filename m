Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D29DC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Sep 2021 12:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EB2C61153
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Sep 2021 12:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhIHMz4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Sep 2021 08:55:56 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22978 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235448AbhIHMz4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Sep 2021 08:55:56 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 188AJ7TB010785;
        Wed, 8 Sep 2021 12:54:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=zMQSKRfkVwSaOc2ZjNJKIePzW1wuNRFI6NMTdzyDVGY=;
 b=Vm3YQPuZ88o6U9sY9qHEw+0rI09gzDnkyg+dA3nUCEnzNZyuLoxAwjm0/CXd2ER+PrTD
 GJH+SqiKFhCKU3AGRGzINc8FrZwggDQYZPo/9E17Lc+NQw4eAM7F6MJwJCqwDfSqZQf9
 OIff8BQgRrCX2d20aGGUcFUZyTN6Vm+0bvlrmyGgtMYxKHCazukNLs0/rJk08bhiOGny
 pV9jjWCSPbIW+hsHzvusJOZoziC+65Zfx8ETlMnukMFnZQIZxOOZWnrxIkqSsEwlB6/p
 s9U0wDYesqCLac+6ZKwLVeTvrP1yVysVz3V6rMKL2lreFjmgqS4Q3PVoWyt5+Efz+G7D dg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=zMQSKRfkVwSaOc2ZjNJKIePzW1wuNRFI6NMTdzyDVGY=;
 b=ZlUAR6fILvt+Iao4shn3ECpNPJfoMz7l7cr3BkPM+WDVz1ZptzaKQTJI7l1DYQP5PcXB
 HVPT4QvZMpAVu6JGiGOyEoYQTXbRriwouJ9NGjplgYYu2UYCqTNDMW3NbFjIv0egb8Py
 UhavgddmL4yEi9KKrqkHbKJbZm/3+dmNwLpRqVE1W6qV5diBMh5DxeYi0AJXE8Zrw/Dn
 Lsagc4oA2myUsHxuL+HnOyUxjv4OGKAGtT01wp6vhWIMV24sJurDhl8hoqCD1QYhYsMb
 7iHN2H7JBkR+e0OSABO1PUc+w8CMZl+qgzFObX+nHZX1f0o9qmOHidg0PFGbjT1w+o/5 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3axcw6akcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 12:54:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 188CoJO7094474;
        Wed, 8 Sep 2021 12:54:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3axst3rrcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 12:54:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yq/R30/vt8NldWZrci/fSwtDOthMJdCyMlgyDeCg3qvgHJses5OVzOFov0iicu9Ggk9jya5kjAbYm6Z1EzehfAB7PhTa+cYlTyeqAd1HD1k+XCKCr6jOvAwAYjsicB0OxTlB/PiH0cmNmr16sF5Bc9OE2XIcdjw8HpDgOvnY7ckE2BYQBf7wnsGAQnDNd7B2rH6obxx1ouGJkgRQZr0XpLTCKqZ1pj8we3csN9WBVxm5UU7vlpmyZIykvyisnO6oG0goES5xYD6/MKGS+aIO3I5BmZz9ZZVmvIh9SEdVVYg7Jixcf3whr9TSqUokcePxlOPynOgJiUHDYVD/sriPGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zMQSKRfkVwSaOc2ZjNJKIePzW1wuNRFI6NMTdzyDVGY=;
 b=K0LibJYpfjoU6emQ90SpkIVCncM77K7EsHPHLr+qbc6+1g8Vmd8x+JJZx/Ts/ksx7ofA+Sor+so+ID29MTT2TX6Ioe0boDp+iwWBGmRDoW4shqdsCTdhkoQ2f/WFGKdmhc9vCLJNbs/bZSrADGdrI6bObKAXvXu+7oOBsmoX/C2aL4llOVmwKpnTF5DVKC4nFKun09/CRRm6blo8a2XQbmbgqIr49Gmun5a2ZT+39pODDmaJPyVamqbHzlMlGcC1QcAsyYd1A9yPwoa85+6WbY/IEVHd/rT1onzF0mflng4MUS8cU/FByeLAXkA0uzEmTdTzz/qbHsNMjRhGDV8aag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMQSKRfkVwSaOc2ZjNJKIePzW1wuNRFI6NMTdzyDVGY=;
 b=fnJGrqviTw/NBLqvZo91KdmHnMh5+jwzEmouBlMpIIIDwLd0sCsVb4jXNPxQrznLTITQDI5bDA3/oWAKt4GE3cKcWZqmSG2P2F60Ul/QB0EkZN0pXvwKlEUjKXTIouuoghuFE2WAFOoFfKzp+7ed7PNIkJU1Sij7PKab1Uv+pfY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2207.namprd10.prod.outlook.com
 (2603:10b6:301:36::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 8 Sep
 2021 12:54:44 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4500.014; Wed, 8 Sep 2021
 12:54:44 +0000
Date:   Wed, 8 Sep 2021 15:54:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     chouhan.shreyansh630@gmail.com
Cc:     linux-crypto@vger.kernel.org
Subject: [bug report] crypto: aesni - xts_crypt() return if walk.nbytes is 0
Message-ID: <20210908125440.GA6147@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: LO2P265CA0218.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::14) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (2a02:6900:8208:1848::11d1) by LO2P265CA0218.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:b::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Wed, 8 Sep 2021 12:54:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4241f4f-fa54-467e-64dc-08d972c7d47f
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2207:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2207005566F2647E698408368ED49@MWHPR1001MB2207.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EH/wXXzvMiSV988smHblWmD2z/VLXW/hNE1k9mQWSSZzz6wZmCBDUZT96NU+xix4++y6iEsheJA5vUgT4deYO5BHQ3LpjTgYbllcfnZikNizJvpQd5zrkJDG/axPPmQU17bCm0qy7sDmlQlNO87tG7rPUcUXy1KG+iVX3QHxXwQYjJfmIm3RONeMcbEQ0QKnWouOsZr9lkfaYKZhR3O8VGN49Zfz8htzmcMsmSUyvcAaOX7v/amvIF3zLQSjlxseiIcRRjesqb5nadaHtMhcYOU0j6vSEMECJTLt3Lk5OiNWXN07cg1CvnJ9g7xMtdz3LDQeDaHa1SPJjqkjDOaPQRcwGep4Ao+/A1GyiUBzmns+ZKHRNU6Szb8JCvd1mEy5i4J4DygTCl3XlatRgzHQofKbeSyzZ4pAMTfulzaOfeKtopEPqg02mKaxP8eIfFwz9vDTi7OuX0gU2DiBxTeoxoOLW6AlXlYxZBdhtS0oeFNAZk5jJ9XgpVpPFA6EEPr9iiNHHLNrvIGvG2ICfRhZIW7LL+6WKZlHLg6fnq2EGiLx0AZQadxiVIMNmqsrbZPtlMApQp1KopAD38ruXeUZYpFXcSIMUM+frewflugTGGPqUhUrO3XvzXSUoqTQpWVSbqBlvRzdNqPHHWQ+TH87Yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(39860400002)(366004)(33656002)(86362001)(316002)(186003)(8936002)(6916009)(55016002)(5660300002)(4326008)(478600001)(9576002)(44832011)(33716001)(8676002)(1076003)(38100700002)(2906002)(9686003)(52116002)(6496006)(66476007)(66556008)(66946007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TUinyt5yQhPt75rzVNIxuyCIB4voV+mfTwQ0TVsQcjPGvLSH2jco14wfbcyG?=
 =?us-ascii?Q?yygGdPr5yCa0UAtxdultipQatiJ6Jpk95iORUCeSfnB+ZYtLKohA2UyTT1y1?=
 =?us-ascii?Q?A6oFREvIq5iFeYuUsM2FSUjB+EySH/KsAwf1oaSZoKHdAZveGA3Z5Dq+nW8x?=
 =?us-ascii?Q?thCpOs/XWJLSsMDZQCzr9RNQwgboWZvrGnbAYY2fegHhutsutXSdAg1qSssI?=
 =?us-ascii?Q?2OMXvqx6nJmTY1tl/nSEAiOqcrUDt4G+f3ceSHtuiySisL63ctJldNH2uGpE?=
 =?us-ascii?Q?1hiNq88rcEAnktHWH7mSyB9tko033hNPFWhTLefyspl73JnlJCn78d2JnPJU?=
 =?us-ascii?Q?1XvpNYh2Yn/mVtWnUBE9Y/rarlgDE0u+e8/IU2YbPv7kIcDrmoLFrimY2xRz?=
 =?us-ascii?Q?gTqIiP/2KmaRg/k1icKBMl5LvxwYnYyKAOCjVSImtGPtCrMPm75Z0kW3gJmP?=
 =?us-ascii?Q?Q2bX5BAtd5QhNsJAcPgjW945A8CQBWON4Bex0W/J2r5FtQU4R+JAXas+647u?=
 =?us-ascii?Q?LU4SY7zeyLHQhVbKD4kH5lk9N7IfQVwGB1UJv9Oub4H0EdKrwGRiARdVzrig?=
 =?us-ascii?Q?bbGJ5cr9xXHBeHOjvTt8tfaGUf+wPKz4GHNpMDfuwTVu/2SW4JZC4x9O0XLY?=
 =?us-ascii?Q?29yh0LnLyBvgO4prO9ExpBpUW9271QJ6kVNig9g5GTesUTblm+pYhvQg8wCl?=
 =?us-ascii?Q?9uLJmlGZ2BXrCAjD1Cah/Dwk5NtNM3tEa0zqDaaPd1XViYeMg++a6r5W/4iR?=
 =?us-ascii?Q?olbN/7+hNJDNpvBq/8LadoW/1txvrRQDXnpFSzytr92QCfMsS2JQ4kTWa1/G?=
 =?us-ascii?Q?+LNIn3aQqq4yuDKiZwrwp9tZGmeawNmz/62o/++ZWhDMXqoQiyiOfygbAdnP?=
 =?us-ascii?Q?xEeJ9AQpzX2qQYYqW/xI4jnmDvb3FlV945X8y49iiUMKKxtTXuQtaw1YFm1l?=
 =?us-ascii?Q?R01ETbIA6mjt+tJGklD9e6tq0/PKEQFH75c5U7/YRY56+dqmWNd9CLpjaHdz?=
 =?us-ascii?Q?1oMDDfIftKMmApZatfDXxf6WxnwHY2K37CpGTmygzSuRrJY1hUKVqxuGE8eF?=
 =?us-ascii?Q?ahgzPzo8lREkICQD8I3+VbBUbijDKl3l+PDOXVxmmAwbLSHhfTcihYF0Ghf3?=
 =?us-ascii?Q?s85sZV6L88enz9ELPI+Cep1IZn8An5i1+hgfeR0JUzWnBtNix7iiZdwtTTzv?=
 =?us-ascii?Q?PhPcW4r2O/cTOcxEjysvJt9CRiScuYt8mafu0NP1POsRUVMeaeBiuLixRuBZ?=
 =?us-ascii?Q?MfgN140nTUF12QnDak9I7fDlux6HTFLA9P6jrkiZ4+g5TvH5oiyn4UjBDAmx?=
 =?us-ascii?Q?SCZPQIz8JsXYcO4Hl3G7UYQ+QqzPcd2bHnHR5T56jA568T3lqx+I0ARf0HqU?=
 =?us-ascii?Q?Kn8fjG4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4241f4f-fa54-467e-64dc-08d972c7d47f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 12:54:44.0931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: meKjpsFYZRwW09jwknte7h7W0QKQSAh3TGZ4TWYmC0CSYPLpiPDYDGqKB8Yu0QoNNPRxW5r/Ny9lcFJC2z4lBUmxw4fBucm9AffvmuXzfAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2207
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=780 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080082
X-Proofpoint-GUID: 6U9AWlWCP64Ipal6n59ST97L_mmPCYy3
X-Proofpoint-ORIG-GUID: 6U9AWlWCP64Ipal6n59ST97L_mmPCYy3
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Shreyansh Chouhan,

The patch 72ff2bf04db2: "crypto: aesni - xts_crypt() return if
walk.nbytes is 0" from Aug 22, 2021, leads to the following
Smatch static checker warning:

	arch/x86/crypto/aesni-intel_glue.c:915 xts_crypt()
	warn: possible missing kernel_fpu_end()

arch/x86/crypto/aesni-intel_glue.c
    839 static int xts_crypt(struct skcipher_request *req, bool encrypt)
    840 {
    841         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
    842         struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
    843         int tail = req->cryptlen % AES_BLOCK_SIZE;
    844         struct skcipher_request subreq;
    845         struct skcipher_walk walk;
    846         int err;
    847 
    848         if (req->cryptlen < AES_BLOCK_SIZE)
    849                 return -EINVAL;
    850 
    851         err = skcipher_walk_virt(&walk, req, false);
    852         if (!walk.nbytes)
    853                 return err;

The patch adds this check for "walk.nbytes == 0".

    854 
    855         if (unlikely(tail > 0 && walk.nbytes < walk.total)) {
                                         ^^^^^^^^^^^^^^^^^^^^^^^^
But Smatch says that "walk.nbytes" can be set to zero inside this
if statement.

    856                 int blocks = DIV_ROUND_UP(req->cryptlen, AES_BLOCK_SIZE) - 2;
    857 
    858                 skcipher_walk_abort(&walk);
    859 
    860                 skcipher_request_set_tfm(&subreq, tfm);
    861                 skcipher_request_set_callback(&subreq,
    862                                               skcipher_request_flags(req),
    863                                               NULL, NULL);
    864                 skcipher_request_set_crypt(&subreq, req->src, req->dst,
    865                                            blocks * AES_BLOCK_SIZE, req->iv);
    866                 req = &subreq;
    867 
    868                 err = skcipher_walk_virt(&walk, req, false);
    869                 if (err)
    870                         return err;
    871         } else {
    872                 tail = 0;
    873         }
    874 
    875         kernel_fpu_begin();
    876 
    877         /* calculate first value of T */
    878         aesni_enc(aes_ctx(ctx->raw_tweak_ctx), walk.iv, walk.iv);
    879 

Leading to not entering this loop and so we don't restore kernel_fpu_end().

So maybe the "if (walk.nbytes == 0)" check should be moved to right
before the call to kernel_fpu_begin()?

    880         while (walk.nbytes > 0) {
    881                 int nbytes = walk.nbytes;
    882 
    883                 if (nbytes < walk.total)
    884                         nbytes &= ~(AES_BLOCK_SIZE - 1);
    885 
    886                 if (encrypt)
    887                         aesni_xts_encrypt(aes_ctx(ctx->raw_crypt_ctx),
    888                                           walk.dst.virt.addr, walk.src.virt.addr,
    889                                           nbytes, walk.iv);
    890                 else
    891                         aesni_xts_decrypt(aes_ctx(ctx->raw_crypt_ctx),
    892                                           walk.dst.virt.addr, walk.src.virt.addr,
    893                                           nbytes, walk.iv);
    894                 kernel_fpu_end();
    895 
    896                 err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
    897 
    898                 if (walk.nbytes > 0)
    899                         kernel_fpu_begin();
    900         }
    901 
    902         if (unlikely(tail > 0 && !err)) {
    903                 struct scatterlist sg_src[2], sg_dst[2];
    904                 struct scatterlist *src, *dst;
    905 
    906                 dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
    907                 if (req->dst != req->src)
    908                         dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
    909 
    910                 skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
    911                                            req->iv);
    912 
    913                 err = skcipher_walk_virt(&walk, &subreq, false);
    914                 if (err)
--> 915                         return err;
    916 
    917                 kernel_fpu_begin();
    918                 if (encrypt)
    919                         aesni_xts_encrypt(aes_ctx(ctx->raw_crypt_ctx),
    920                                           walk.dst.virt.addr, walk.src.virt.addr,
    921                                           walk.nbytes, walk.iv);
    922                 else
    923                         aesni_xts_decrypt(aes_ctx(ctx->raw_crypt_ctx),
    924                                           walk.dst.virt.addr, walk.src.virt.addr,
    925                                           walk.nbytes, walk.iv);
    926                 kernel_fpu_end();
    927 
    928                 err = skcipher_walk_done(&walk, 0);
    929         }
    930         return err;
    931 }

regards,
dan carpenter
