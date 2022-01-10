Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A72C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jan 2022 13:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiAJNDu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jan 2022 08:03:50 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24404 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235731AbiAJNCS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jan 2022 08:02:18 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AB0t0p022684;
        Mon, 10 Jan 2022 13:02:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=OK9eZr07NPNF076jsMUuH3vW90YMiKCmn+B5sKIdfNE=;
 b=WFvbCOG1RshBLVEvsBCeHkksbYR8Go5lw/BJNWLJGxfWF099a67GsAQOjPC6Fyqsti3S
 IgRjVif/oZQ++4d6j+R8AKwzpI+o7cKKrNPQxuPIJ+5ENhp3tFW2X7NpP7ykUIcgSbsJ
 X7wxbPHK7DE9fuOuVAWSHr1vRd3TKZDSzYj6jPwMlYa7+9XT4rdIajwm/JsmCuvydkZ0
 WVsgpz4mfrh0Vwnb9lgWI5sSEI1THJ/zr5emKR065bEkoi1/d2TnbwgjGCqfcuOd2L1o
 M7eTKuEKTn+EWq+xHSKGTxw49xSofV5PbmPtNauF5nxRDk3ddGhT4/qR116hzRR1yyfZ Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgkhx0778-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 13:02:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20AD0PxM113936;
        Mon, 10 Jan 2022 13:02:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3030.oracle.com with ESMTP id 3df0nchre4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 13:02:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pra/oAN6LhEtioTjX0mzwoWx8BBy2fnJ7g+PczswrsZOUhsUXr3+F4MHfezHylGODaxgftNYupWbwJcMQ3vIlQ0a4Ss5/kNCxsxdqjYQarQMXIiE/Fv1XWaZpbDzTMS46CISjmpB6TgdW/EauuHlmbe7DKXBwwDu1wVFDjWwo5p4ojxE27aAArVMYaMBM9elHWqXYVgjPml3Z+T7fRWyBKKZcQ9BTAiGrEMIUoLzVd5kvNWrgTX7K7DpbrGZjCV/FdfHvXj1llZk/VkEyPQLthzSbnpIl2F0WpS3tFDBo/9zhmtOsZEiy31ry6SvqARKLoIhUOcip3bx+C7jMNYfdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OK9eZr07NPNF076jsMUuH3vW90YMiKCmn+B5sKIdfNE=;
 b=B8EcPGg20X2hc4qrQhld8zQceHcoVPhT8ksq7JS3TFrJB30UHFfKS+HxoiY7yEJ9MpZo7WBpiUsnXJppowfejvpE3NsOzo+wG2jwBmhq+IKZ+O0Ut0h/1x7TUrf1q1AZ0cqs9L9kuxe91kn2xqAjH8+Z5OdEjQJnP7D8hC5WNIkn6Sr2sJzp96cDfC3B1hVWPQpQrEyGf9Ou/gxv8bcKiuMla7NMAOivhBIrtJdVp/f5e010Qg3qJoEWsPL/XQtyY1fSMd7DIIXuqpK2wcU1K281w84vcYM7nshkUFq7W+a8SvcoU67/6lV6H0oGd2WQbfUzHoywoI7k3IQngJdE1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OK9eZr07NPNF076jsMUuH3vW90YMiKCmn+B5sKIdfNE=;
 b=YPgMWQ0Afx9P7RBFNoBWgxfNRoxzp/jGvD4PygttZoiaA/04A+7pJoA8QYTsm4FYPJkGZW064VNZmGEKnHDzDwqQdnz4AtIaSqOv9iGFNCkKB1GBSnHKD6WHkHatQdmt8bi1N+1ToQDEvfoaIsjPD6rkcuVyBrOyQqWSPRvHw9E=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW5PR10MB5807.namprd10.prod.outlook.com
 (2603:10b6:303:19a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Mon, 10 Jan
 2022 13:02:14 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.012; Mon, 10 Jan 2022
 13:02:13 +0000
Date:   Mon, 10 Jan 2022 16:02:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     pgonda@google.com
Cc:     linux-crypto@vger.kernel.org
Subject: [bug report] crypto: ccp - Move SEV_INIT retry for corrupted data
Message-ID: <20220110130204.GA5984@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0123.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::20) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69161915-2e5a-4e03-d1fb-08d9d4396bc4
X-MS-TrafficTypeDiagnostic: MW5PR10MB5807:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB5807F90C7B034F7BB5B51B3C8E509@MW5PR10MB5807.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eBRVWjQF+MV8srAj30obAfMtPQ8gc0PC5PYFCkjSRE6xCdCSMbamCFrUgqEhwyUixLxtESJn+QsMelO7f0hoI6zhF+eXCzGYIuISonVCf3OdJMyUEtBeYpbB5HRPro5xEZtaMoBXF3fJFDDLHvqqLRSQ/FiECG0uKNghaOruae7f6Ia/B43gnTD4dmL/DvL5JVlHiHF91DhDNmOGgARwY9oYqDE2dBiaitfwfCrkD/glyxFtvDNqVxfP1GH39utemWd+5g2zXGy5G6xiU722DF+jYoG6a9TGWXAttq64UmJ04pbTAXDvKi5urnsCaguDHHHPgSOCeSyZGbfJ/JvhiX3i0DNn/yq5crX8Xb7UZCRCJOZEfRkvabXaLaneNKl0t/qctJXtv8WoAxvc9SohyCHoGQWhrG/diTDB5IGos8KIbRo7sH+IIbPqRgOOKId1fYi94V4gBhtIN2nnuiwjpHC7N0jviiJ7Jdx9WzuScW3EvNZTPzqXSOne8W3x7d+6pu4jY/JR9ZVqAL7jfT6TaZFYqCDcs2D0Uyas1Lg6RxvzhGF9P+nY5cANjtzyEZxf0OM3Mphk5Ej7NsXnFGM/b+gfl81d5Wzo3D0TGZznuZRCbPC9NXnu8URKGyCKyEqIObVIP3lYd/UhIZibQrKWUTDKtsAVqc1b619+qC2br3SiH8mwoGoX3ExZTGR0/AtZJUVUi0Q/MiOpR4JpF0sxLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(8676002)(9686003)(83380400001)(52116002)(316002)(5660300002)(6506007)(66476007)(66946007)(33716001)(1076003)(2906002)(33656002)(66556008)(86362001)(4326008)(26005)(6666004)(186003)(38350700002)(38100700002)(6486002)(8936002)(44832011)(6916009)(508600001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3MJLGkmEzCgq6bv0Xt0zTY/PTJt+x/afB1PmsRlWMqfavz9GU7th5dkbtRMI?=
 =?us-ascii?Q?ti7afhVvmkBYkWZCoAKuJElxa78fNggfz8IPkWXOXcALVQ0R6buWQm1noGWX?=
 =?us-ascii?Q?pGuyNZNgrEK75DMUAlv0XSZM+u5QGkMsdrk04VzO0EKtMla/12xHyhYitk00?=
 =?us-ascii?Q?Xh2pEa1E/iRUwnyi5NEC8j1ufhwngxLbq6KJGmA+f1ghnPAZ/jA/V/pMuJfa?=
 =?us-ascii?Q?ucRfI4RhQ8M/zxkLsyzvDrzR1K/LeskffzL3v+hMMUcZTQ4xcHt3S0XTc8lF?=
 =?us-ascii?Q?1fCCU+WarxHa2dBu7sH4uXQuoJDjaFcJEm7Srda2lk8b5+G6WFz6Q5EpjhoU?=
 =?us-ascii?Q?zPk3lEaltLFdfy32vINgrL8tgN4LfNiUzr+hXSbIlCVZp9lP1A5WTUpQ1Zzz?=
 =?us-ascii?Q?++GTwcg6qEyg28XWKryuP7kwyYnG93q/cwQNNVEAcSGFw1e9M0Ujk5CE4LAt?=
 =?us-ascii?Q?Q2hucfiftvWdynEkvxbMf3+1HUThnT8GgwSbcG5/bUzVLPNSzCbBiOxPuz+1?=
 =?us-ascii?Q?NrmX/FC/pTDdKxi2l2Hb3Z3yIORWztFOJ5vTiw8PIIIl1B0rak65SlBpbyPr?=
 =?us-ascii?Q?2/Qf8ZN7rgjZwpGXJnVxKSzHSgSBzcXMNvfdw5t4NkT4lG89K5Db5C+O2nki?=
 =?us-ascii?Q?dctyiy2ydDa3MgEtyYEs2lA6sFiYKQXzYyq9q+OBe3nrWEDt5RbCwzv32no7?=
 =?us-ascii?Q?6xiC9mLJU0gdjd0Nyej9X0QTZT/ZiG920uuBIW1zj3EZ+d22qr8L10fF5/1o?=
 =?us-ascii?Q?PxNA1Kw716MEk2PF0Q2Rplle/r4IF7C2MUGeE6EN6lt9gWjkeNVlqhFmI0Ro?=
 =?us-ascii?Q?SWnp/RqfSDiwZprtE+XXfaYVibM0M/rc2pMj9SqN+ORItihrwPv60Fqj46S3?=
 =?us-ascii?Q?mkSxaHFbjgJ/nS5zP+z4EsLxcNo1kmelLFdOW0UyoE2JFQllZx9nTGKTN63F?=
 =?us-ascii?Q?7DNUKc6AoDgSBXJZPiHWnRanxW/2bJYC1JtZMcc2WFFd0CLCqyK13CS3rKqr?=
 =?us-ascii?Q?YXKZN32ehZ+BT4Rz2bJTP4yym6GZohZMn6L/VMDRGslOhOS2518yq/hAGcUu?=
 =?us-ascii?Q?grPFYZX9efP1PgowcyewQyDL/PWeFDcVqoSGIy0cSEIeCLxgiNUxQN9XW5w/?=
 =?us-ascii?Q?yEEfZl7K8T1mNE4qZ52g1Iva4CCHNkCDYOFZS7AUPJg+pO5m0Fge3Mtpw/56?=
 =?us-ascii?Q?14yK27xcFWeZIqkgus3twQXuIj/zTmJwdc1a/SwhPliw3sEjjwKXnNiXtApp?=
 =?us-ascii?Q?2TGXbqGdT1En8Ku7hdPgg1HT4mo24eYl5Z0YedQkea7OszaRgRTvC2U/5lBW?=
 =?us-ascii?Q?LyxTqK8r9u1rUuTRM5fe8pSdMN8uCQsuUCnjAErKjbW4QZ5aw5JqhhlNv9vT?=
 =?us-ascii?Q?udxAw9bhvi0egAk2CnHoq1tX0kMzxqCz3IkctGZOdqtvpgVvXahyYGoXrzTX?=
 =?us-ascii?Q?ARpEfqeAp8TCK7PgWINEOUD8aQQyaP9ElRQdcRdXBaAdbRJjXi6g+LVo5zEB?=
 =?us-ascii?Q?i0e1I3Gy2ibO6C048eoX5QF8kUu0n+W6sP+TEujs5n0TP9+hoSZfZY+WrBt5?=
 =?us-ascii?Q?1okB7wKud5r1DeeiPIHVbzdHwEw0QUDJiLnSJ+zt6Q9kS2wIIWta9JCoTjAd?=
 =?us-ascii?Q?3g33RNJXnRoNYglYJXslS+vPAbc1PeGwl8RkEfnatwe2h5qLpSM46Nvr7ab6?=
 =?us-ascii?Q?q7kxVtoOGuY2H50C4PC+p1WqKxU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69161915-2e5a-4e03-d1fb-08d9d4396bc4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 13:02:13.7014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FY7ScTwivJvw7HqSRoTLRFnsnvG0eV2VHUgkELNgCOYywAa6gNPXKg6nG6RolzMjNDaGDihKaXT+f4Le8FVuzuoDSZ18rK3HDzZV0bPz2cU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5807
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10222 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201100092
X-Proofpoint-GUID: Ilk9ZhNqNF92G7N1c8nzByXBwENQk4kk
X-Proofpoint-ORIG-GUID: Ilk9ZhNqNF92G7N1c8nzByXBwENQk4kk
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Peter Gonda,

The patch e423b9d75e77: "crypto: ccp - Move SEV_INIT retry for
corrupted data" from Dec 7, 2021, leads to the following Smatch
static checker warning:

	drivers/crypto/ccp/sev-dev.c:430 __sev_platform_init_locked()
	error: uninitialized symbol 'psp_ret'.

drivers/crypto/ccp/sev-dev.c
    412 static int __sev_platform_init_locked(int *error)
    413 {
    414         struct psp_device *psp = psp_master;
    415         struct sev_device *sev;
    416         int rc, psp_ret;
    417         int (*init_function)(int *error);
    418 
    419         if (!psp || !psp->sev_data)
    420                 return -ENODEV;
    421 
    422         sev = psp->sev_data;
    423 
    424         if (sev->state == SEV_STATE_INIT)
    425                 return 0;
    426 
    427         init_function = sev_init_ex_buffer ? __sev_init_ex_locked :
    428                         __sev_init_locked;
    429         rc = init_function(&psp_ret);
--> 430         if (rc && psp_ret == SEV_RET_SECURE_DATA_INVALID) {

There are a bunch of failure paths where "rc" is set and "psp_ret" is
not initialized.

    431                 /*
    432                  * Initialization command returned an integrity check failure
    433                  * status code, meaning that firmware load and validation of SEV
    434                  * related persistent data has failed. Retrying the
    435                  * initialization function should succeed by replacing the state
    436                  * with a reset state.
    437                  */
    438                 dev_dbg(sev->dev, "SEV: retrying INIT command");
    439                 rc = init_function(&psp_ret);
    440         }
    441         if (error)
    442                 *error = psp_ret;
    443 
    444         if (rc)
    445                 return rc;
    446 
    447         sev->state = SEV_STATE_INIT;
    448 
    449         /* Prepare for first SEV guest launch after INIT */
    450         wbinvd_on_all_cpus();
    451         rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
    452         if (rc)
    453                 return rc;
    454 
    455         dev_dbg(sev->dev, "SEV firmware initialized\n");
    456 
    457         dev_info(sev->dev, "SEV API:%d.%d build:%d\n", sev->api_major,
    458                  sev->api_minor, sev->build);
    459 
    460         return 0;
    461 }

regards,
dan carpenter
