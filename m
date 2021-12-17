Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBEFC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Dec 2021 07:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbhLQHR6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Dec 2021 02:17:58 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:17012 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229503AbhLQHR4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Dec 2021 02:17:56 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BH2Y9CX014966;
        Fri, 17 Dec 2021 07:12:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=cn54XCEaSaTaZJXKbd+nhWNukrNKN5tIkRy+C2dGBOc=;
 b=L8/N9NA4nFdMFFzHG828nOjyTZ4IlowzYccm/r9oblTiEgGfWBIWad/rj29hTimRAa2n
 gqj1n35cFdabEzVr/o2kMJqYOfKGMwS54acQ8W9OGhjgmPd5A0wWrPZdlvlnLa6L7Dcq
 Vz4iMxczsjx54/nTYra0/lZQRDSF4JKEaJBbeTCxrUlOckziw8h5SjP78IpyUsJKquqa
 bt+flQE5JIhiaCCq2y8LSkyj4oa/REdQaLY0KjcPn8lLxyr1NypoUVxzQAFVZgDEwXXP
 Gt2JuE8ZV7aTPTsSXDat50Y7+IXto16tJNEpkdMoHIFXTPCiE7GwlpVnEYY7V6Ybgb80 8w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cykm5d23s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 07:12:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BH79vPn133299;
        Fri, 17 Dec 2021 07:12:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3020.oracle.com with ESMTP id 3cvnev5f18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 07:12:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHnM0T3Qz/1IwGG0rYpRKB8zL0VNLJj6ueV0nxUVTeMAylnrnbu64lhRkVZP04y/YrEcyX2hV9/xW0wulx9IjW541KNBgoRMUf52srVbPYzLFPLdqKZug1u0Im/Canb9MfnlN4UD9iNCZnqP/TM9YIxvmrN4PkMLDt6O4IF7DIzgselTiaOuyyvaLambgE++R46yodSXbQK0VD/qQwVBkN9h1P/Jb1FuUTsoWXulEVyBccI3ocFDvCdmTbPNrMwEImENrSi26sKGNZCov2pdSbzqakeoNqj45IoxZRan4/37YuhV7++SNrZlBizK92yxOt5pnXxO0My6EunAFAPBdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cn54XCEaSaTaZJXKbd+nhWNukrNKN5tIkRy+C2dGBOc=;
 b=kYPAa2nTOExU1NqZWR/KZVcGQNY0ScF1n5GZqbNLGbdDJVqskROQQUosLI6OiXZjCdfUljYKRTnyV0C279llsTMliWdRNmejbBqzdkIq9Ognlft5fi/06kRRy58SqV8tHWMQgHfO+3Sy2kvlp3nQB485Je9G4T+cIAp3SlCvF8qATZeILqTUby1P3lzC5v3BZfLUZXHS1jwN1WutbBxZYnMZeDzRL94CPX/R/NW0+D6ZQ2ZHGzszi66UulL2ut0hRF7c/T/dqKZbCX/emhKZ9VJH9bTi12ip0dvt9/MntOX48JZJQIK4dhEjpBw4M6Wdtoq0XZyjPYS02cxn2su9Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cn54XCEaSaTaZJXKbd+nhWNukrNKN5tIkRy+C2dGBOc=;
 b=eYQ+1oKOy9lWJT6TOSItdle4BnsCvRyDh3AfzTh5Onwhyt2smfrf4hi6clGikOLm9bIyhogUuHwmBtv3ONZXWvZqHFF+ro1wlXCcKB1i/dRzkQcYgYDTMO+55k97OJRSrKm2eojG8jeXbcW6Vi4zNPmU3kBfsvGc+08Om0mVrQ4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW4PR10MB5863.namprd10.prod.outlook.com
 (2603:10b6:303:18e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 17 Dec
 2021 07:12:46 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4801.016; Fri, 17 Dec 2021
 07:12:46 +0000
Date:   Fri, 17 Dec 2021 10:12:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Srujana Challa <schalla@marvell.com>
Cc:     Arnaud Ebalard <arno@natisbad.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Suheil Chandran <schandran@marvell.com>,
        Shijith Thotton <sthotton@marvell.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] crypto: octeontx2 - out of bounds access in
 otx2_cpt_dl_custom_egrp_delete()
Message-ID: <20211217071232.GG26548@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0096.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::11) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f028ef4-cac5-4e34-b333-08d9c12ca09a
X-MS-TrafficTypeDiagnostic: MW4PR10MB5863:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB5863EB3DBC87772B5584F2198E789@MW4PR10MB5863.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4YugtjLQdl+Hbzm1+vnnNPtIbznItJfKveFYVO/bgsRlL31JaXhSudNn6bumZM01t/IVUyBWtQmtdQNJgGNv9+PYlfjANfxCwZDOCJzyDNF7QOBPj4tuyUSBrxE0n1c2eyzrf//kdEZCtqgzUjYJBRlNXfv20of3aJkoVeJTw4AyU8iTYrTzbeLMZbo/sKTOdEW3yftaUWVNjH4YQeXfn0oq6n76JUA0s8zWtp8QItk9EajBOn8JsUF//1xRBfByW/AR+0ugZ3S3BNHAmNqqJZ+2obYq6tNr8LtXvz6K/7/IEH1muA/RneaDiPNypi2dSJ4O4Azppbh2BAg7xcZiVuNuOXrUaqSh5V8t9UI55WNXzC5hE+A9KFvzaRgIo46gt5o2UF9ZmJbZpBt3sRYB1Wt7K6gnd1/e5UD26NnDCX1Z32REyheJu6ZEZKu0yf5Fm/Dsk2qG89GXaVAUw2r2GMk+oh8+SnNhrKlbZq9oiaeyBAkgJuPBUih4VTYcPsuz4dkooexiSN3C3VjtO67QYEosEPDWEtwkMFXlpQKztMxylslRelhjmQcYSuFegd/SVCPxsMnyRQwnUGIVSiUzhB+f4VwX5SMo5ZhYZBBtgevQtaFBpw+FGBmAHA2evOKLBd1tvJlsAOJXqEr/13O+KNrArXfngI1jTKsGsv7+c6cFQzNYBU06Q5MQ0frjg3RVMOj8AAxaq8FS24h7LoeXsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8936002)(33656002)(6506007)(186003)(6486002)(86362001)(66556008)(83380400001)(6512007)(316002)(4744005)(66946007)(5660300002)(54906003)(66476007)(8676002)(33716001)(9686003)(44832011)(38350700002)(6666004)(2906002)(1076003)(110136005)(38100700002)(26005)(508600001)(4326008)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aWnT7jHd3FdL/vA1xaai455jo5/I+XaEKhkHvgkmmOvbVXMCgOqfK+251rBW?=
 =?us-ascii?Q?h58aVCOweCS2VfeXTW3ovJg6uzSHMbapkGNgCahEqB5eY95FFBUZ1/cMJn3I?=
 =?us-ascii?Q?wC35dZJ37VcbbyLySZEMc7Mv+kmK/3dKw1vJ7cGd3lvnTpAAsAZ836yTuhjb?=
 =?us-ascii?Q?YPyhwk0vfiv6bsYo5CFGzs4gjiFWkbZ/Z+lC6Hw394c6sOzwRUUKM/hXtLco?=
 =?us-ascii?Q?iZD7LvGC7IQzNzTlHEkRW/tjW3YqbhqjanefoSCgtPpYCAMJkM48BX8XwcJs?=
 =?us-ascii?Q?M22IgEZyJXhs2OGFgy8uqCZwM9uu/RaWYSvzxVZAxeAVrQ8s0iAhZv2ugYhI?=
 =?us-ascii?Q?GI/rTwOc31MmHtjoHnzyNEEwdlOOXAinBSwf9gm8KLq5GtineLCTw5xLnM2a?=
 =?us-ascii?Q?06Vdb1luVwoiWYHRZ+SzON5zAf67e80y0tMcZ2lmNrPfSfe70L1T1CNSUoIH?=
 =?us-ascii?Q?6miQVJMKSDEyi9Mzgy8C2gVWsr4PWjZ/VT7TSTUIyaYdx3NXQw6lwX7wtXn+?=
 =?us-ascii?Q?RtlREcRa10SG8DE5eaNrY5a4utRBJJOAXJpEksz5ImUdbJ9y538/EuzH0WiU?=
 =?us-ascii?Q?YcjaA+Ur7WZFQG5xtUAHNqVrLKlkqdCWoJclv0Frd8eeNh4XWTlmBl+MXA4R?=
 =?us-ascii?Q?CHlfsNDpq1kuJoQUdZalV42IU02oAPtWlOnJE6xLncEOx4HoLTBXVTri3kwU?=
 =?us-ascii?Q?jXzDEl8eAqA3CbauEjRO4Hez5BtaSfxzphyfb1y81TRWockDAQI9gvAGC4NS?=
 =?us-ascii?Q?nHzNPns5ofrYgFFfrobonMOq/cjPjHUXt3kcPu5DGI/miPI49vosyRfq3dDd?=
 =?us-ascii?Q?z9TdTBQWq634tJrFRBvJncS7sGtoXSanzPgzJ+5LNzwTQ3oQBco6zWx72RC3?=
 =?us-ascii?Q?HlcKleNQXuy5zGK7x3DufSB8kQMrlWDKgpCARpiQHmBsyOukKHmKzR4HcGX7?=
 =?us-ascii?Q?kWcIgQBffUouA1lPi0IYpk/XnvbIA4V/64Q3W4Lp7DgGMIqvMe+QoUvl76gO?=
 =?us-ascii?Q?dAB1vVhiH0BY+YqZoyLMzCRCbiOA3TvO8TxVaspSHq2Fh+kPWW0q1PaPcbJo?=
 =?us-ascii?Q?WAXlULE9XqeSZ3PzJPneyOXZ1o3wf4oW+8u0aTebKWzFvnhgUIwhF0Kyknea?=
 =?us-ascii?Q?yKviD/DIrwniKAzOEyIXsjXDel1lY4AGQRzJs65NSQtAZHq7AXr5N9dC5JfN?=
 =?us-ascii?Q?G1K78TbKQqkRTky1ywnuIH8K8rCxGvmH/Eu89dtpXkEg3mwQB4rHGdZ0mBOE?=
 =?us-ascii?Q?8A968hLR4b6HMfkFsqrAPSXA5VLyJxMEljJxuDXG7KxQ4zPymjjd283y/x/I?=
 =?us-ascii?Q?zt0lajev6iArO48ddmRt9Bsgut6NVcHFaD887DgXdB+vRh5sLZ58DyVZ3d2O?=
 =?us-ascii?Q?TXW8Jle37PS4V5CcY7MxjTfbSqJ9ZpWix0yaFhJaBGmTSFp9tDqduDKdO+Oc?=
 =?us-ascii?Q?b7zuUJf5D+6/JTE8/TcUNEMbOjxjST0h1JDjisR4RPX+46N0TqpBd46SCprK?=
 =?us-ascii?Q?53V1FGB92KAQ53LWdnIRyo/5bCcya5MqD0KTcdO7LVL4qLDT8mwFAxPZBjW0?=
 =?us-ascii?Q?oQuv7g8TkcOD1i9hWvT0lKkHxyDyKXNeQKlngQaC1V6/SRiGttaa5KFci9u6?=
 =?us-ascii?Q?OPTBPSop9hV//iAKYTswPOoWVim6mRdlRYMV3U9N3hbegE1m4nAfqtXJTe4Z?=
 =?us-ascii?Q?qqGgVUBqhxfwPwuqsWB5l817OV8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f028ef4-cac5-4e34-b333-08d9c12ca09a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 07:12:46.8119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ImeppHu4boXx+NIEWwmsgV7315TaKWrpia+XMyoMTqixdEOnyfM9oARjNxMQPcWCf3D5B5mfIt75kD4+xdgpdyQ4sLH9XcsR0syTyFTTtHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5863
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10200 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=3
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170040
X-Proofpoint-GUID: s2CBPjsmgvTz8e4NtmH0wjuZ3kDLKoK9
X-Proofpoint-ORIG-GUID: s2CBPjsmgvTz8e4NtmH0wjuZ3kDLKoK9
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If "egrp" is negative then it is causes an out of bounds access in
eng_grps->grp[].

Fixes: d9d7749773e8 ("crypto: octeontx2 - add apis for custom engine groups")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 57307eac541c..07f28d887c2c 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1695,7 +1695,7 @@ int otx2_cpt_dl_custom_egrp_delete(struct otx2_cptpf_dev *cptpf,
 	if (kstrtoint(tmp, 10, &egrp))
 		goto err_print;
 
-	if (egrp >= OTX2_CPT_MAX_ENGINE_GROUPS) {
+	if (egrp < 0 || egrp >= OTX2_CPT_MAX_ENGINE_GROUPS) {
 		dev_err(dev, "Invalid engine group %d", egrp);
 		return -EINVAL;
 	}
-- 
2.20.1

