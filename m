Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDB7C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Dec 2021 09:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241132AbhLOJXg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Dec 2021 04:23:36 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:54568 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241129AbhLOJXg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Dec 2021 04:23:36 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BF97IJR027002;
        Wed, 15 Dec 2021 09:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=lsblKTSQmYshOAImYttIlLJlmkChpJkC+UpQjmlNnkA=;
 b=aXgJMM2HmjRHuq6Snaak5cJCaDx71ot/hCGJ9gwvmxVG2PAJl3OwOJ/31QvYjTv0odYC
 WMVcAr8ZQ5SNl/+JTWB4nslU5h7/U/ZQRoTFLiIFMDWoTxs/UAtUzhgdT8pJOPjKVskm
 R1hHumjYBkIsPgYgMf1LSThwhwrMkgo4BmwJHeYnpGF5gg+ZpnvIkjK4Gv8R994qQCRj
 JFOKB/JRwnsFnKuZB/lp4SRY+NPQMttBXomCCCtwAyeZDkUcG2vTEIo67Pb4OLF2C/g3
 JuIYxL2mUoeyyQzUEUrrMSWnd0owJhl/Tad+ktca/lNcRiYkvvvm9g0QYfTMBoEVVHB1 hA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3uke8a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 09:23:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BF9A5Qd142332;
        Wed, 15 Dec 2021 09:23:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3030.oracle.com with ESMTP id 3cvj1f5s6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 09:23:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMoRjpa+DLswTMGyzzuGzr2fKvINWgVq8RQvoWJLOPp4xQeSyjfIpBEtS3XVjyr+7x3MrPOsaRj1OuU3HOs3nMHMg09Q7GOzk0J5hnmvuwoAPvM0uIgb1CuUaurN+57tfyppSq9NhFZAJZsr7yAyuRbhHgspNPuqkoRyJXlp599Nz2GPirL9YJ7TBCBg0sY+WhfTbI+CB+XvoZkw8CncpYT70iNAf+2Ez93JOsI4X2r45QOM+PNfX4RIIBjzhPRIWeKhyunx6jJ18YR/KL5kMcGWkVWVKsS2pIQeznVN/kEyBqCjkUb6VYGKeW7UDuI7u+DXBOXIpF8z7ycPvIfnIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lsblKTSQmYshOAImYttIlLJlmkChpJkC+UpQjmlNnkA=;
 b=Iphoj2iei/v2+iBqLx6z1F1oXeh8gwCVLNnej+CCteFiuAMf96BPA08Kz0kRD6IKh2nrrZDdgPSlge6CetCap1YhMXJSU+1hcdaPW7179SfO60j90z6auOYAzcMc7DcGtH4z7xgAD7731XH01gWUXk0nxDHufF2cBYP0HvnXk3wDH9fVBne0MlL3fnMTQbMNf2eTMBtjDqEWmXQmFAQdBNe6GaTOmKwzGx1LvkcOElEiesy5joW3pS7n8jrh5xmlqk8E2NzsVHRtvm+BC7KzfIzguyMBDm50X8aicKGqHSwcHLaT7Rf/mmhlhC57zxjcc0mnh91UPUzL5V+V23FeHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsblKTSQmYshOAImYttIlLJlmkChpJkC+UpQjmlNnkA=;
 b=OpSSycUrScLW35nVCMQkbDD4LFPc2Eyp0hs1Uxk+Cas71B9L6+cwwmqkm7sNA2wADFAi9ljL1HwYdLHe3T+oZsUHBBcPdVa0qDVxuOTCooXa6f96v2Y693TPvJmJMEMFu+s33PaiXEmTiOgzGpXXassRM8whBhuxYnLhF5KRSAc=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5554.namprd10.prod.outlook.com
 (2603:10b6:303:141::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Wed, 15 Dec
 2021 09:23:32 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::7194:c377:36cc:d9f0%6]) with mapi id 15.20.4801.014; Wed, 15 Dec 2021
 09:23:32 +0000
Date:   Wed, 15 Dec 2021 12:23:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     schalla@marvell.com
Cc:     linux-crypto@vger.kernel.org
Subject: [bug report] crypto: octeontx2 - add apis for custom engine groups
Message-ID: <20211215092320.GA2732@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0111.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::8) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c7815eb-7098-403f-5ff6-08d9bfac8fdb
X-MS-TrafficTypeDiagnostic: CO6PR10MB5554:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5554B68B077517172B0AF13E8E769@CO6PR10MB5554.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SFBnk4TnG9DT5Auv3uis5Mzo4FhzXACwgmOPg2m1tHZfHRkzB0Efb0Yxll6LWpoLXlgc9aMe6H/9yN+3Nx0nRpWKqaRXn4DIDLnwPxZQC2xlHOvtapaWiz/Pt/hZhuHFkZVoE4cTvOMKz7WeGBUjUdzLSZzpw0eAgOnhcyUl34bwoIf4actkaN1hDNcVu4HtFFgK5dME41Iu4kaSoDmCmUfexTnGxTQfVWivJhutUNMt/PUf/oGJWzpOn7IegjqBwhUMwFB5tPEbCootlcPSebrPhVdBdGDcTkVKUaY9A3EPHBYgTqR7Bwr3yodyq3F/Lj/jpNl4thg6CCMlF+IafCU+wKD4z711NTbdCpdZfdEZx7hRaTtnUj6+zRA4usWKPy+Xg7nl4LBri5jsKjLkaQgGvIcfuZwiaLk7lzJok62uXyosOiiO4D7/WfY4z5He7smruc8uGlEkP270zNWoieBxN1AdSBZt7AkQurn1tL0O//7aBpP0K8pbeZxDBnebCnFKL+NFJ36sxRUtwx6gZbDuU7VtyrQl5jpCrFJck1loNNHxGlaXobmfGNGfoeB4shRWgGmjma0eU4TC9ldtAU+9hyCtF6SewNRdBvMeodwPjbh8don4Lyb+K/mUnVvS0R4ky5oQo5yvVaqyZdt2uJlBiyc7YYc1wW+gZD226yq1rjE6GVQBntZKgwpjHOl9x08OrDcs0TvChA4sogu45g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(1076003)(4326008)(8676002)(186003)(26005)(38100700002)(38350700002)(5660300002)(8936002)(6666004)(6916009)(316002)(6506007)(2906002)(52116002)(44832011)(86362001)(6486002)(83380400001)(6512007)(33656002)(9686003)(66946007)(66556008)(508600001)(66476007)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eeZHb0H/BJb0M1vX7FE26ZHl2lHs+/a59cJA9zRfv+cOFNQ7+y29aSm38JPl?=
 =?us-ascii?Q?/6vwpPmV9CmQ0KXOfIpCGLPFN9og4he2x3L8jsBrgsGLsNbF7DcGjGuxBTpU?=
 =?us-ascii?Q?pVUayzNopuz7V/CzdD47V5fdzAo+y2FM28krGGcl78oYp0UfkPdA5BwDAlfG?=
 =?us-ascii?Q?c8oLgwpdRLzrSP0CZhaM0l9UrqL80hLH84s4k+avj163/EqFp6xeqv07ZpB1?=
 =?us-ascii?Q?TQKwwUv79VY5Cp4neW0xq+dOicuvRU8C/aRLdvEXlujHbw9xTN46zv71ZidG?=
 =?us-ascii?Q?kKHwuzqWKA80ubXrVugkDwEdoy9A1+gqfGFutZSz39rMfA+RPqGNPYXvVgqf?=
 =?us-ascii?Q?iDF7DLUzc4hV20ZV8brOSKKt2/s7AnA5qcqUizHmVprQAkizGS9jovpT2Yzr?=
 =?us-ascii?Q?no75/WnF9jZa2mHgF4jN/03WqXev2JJygCK3SLkN1ihaLl/E6gHnr/QDyiSb?=
 =?us-ascii?Q?evoi9UATrrdoL1oUTy0B9nmpFh4R4gG/7rbthHN/9h2JxHDBYDtGHlka7iq9?=
 =?us-ascii?Q?EtvOAbKCgEn0LAs3/jA4uscRyGar1k4YEXphiLFlyE8m5uChQsL7ruJfftVT?=
 =?us-ascii?Q?CmM+paAmkiWy6A52+Pl29G4n+FgtDii7ItYTyGkUEApI6wN3Nhcc7y5MdhmT?=
 =?us-ascii?Q?TzzLL5AWsnIXpjUIs++0/xw96X4zzMzK/0lGQQyo0UnxotxMhP8H7WRuHYCa?=
 =?us-ascii?Q?oMo+o4M6fBT73KI2GNEDx6DnAtR3SjgqtyUc3nU+0hpksorDqGsKqHuqN9w3?=
 =?us-ascii?Q?E79hB4xtD0bObMioVuyBA6BfLu6eAq8Xo+0kYWecJHy3lkq1zXyaq9gxTPo5?=
 =?us-ascii?Q?er6p6GHC6vJdqxj//+h0Q/LDUT6xS6LxLAtPDjSsgjGA8d4LBaaEPR8+Rz9t?=
 =?us-ascii?Q?3+oruXcgrHdj42yh4BHy/Pkn3YDi0REfcuSCqeIonwsbtjrG+fDMpuNj4DY5?=
 =?us-ascii?Q?3HodP1JKyLLWsT5b9OCzV+ATNJ7bo90hVkTXcAarILsA5N1qllybQ2hRB0Go?=
 =?us-ascii?Q?y6LjtrABeUOEbsepdkz4LLxM5jez0yUo5mBsJ3Rg15u/Ihmwg3SeFH4R6TNg?=
 =?us-ascii?Q?3OODmEWTvWB31Pn5il3YUIsLj+Ul5TkrvWs29STfgQCFEmGjq0XTYwLqEbza?=
 =?us-ascii?Q?xHqnzB7u+J/EYWUFdJOwZDgmGulbZ2K+87bHFbskl7vkR+UdbDwZEvd4FBKo?=
 =?us-ascii?Q?d0rJSt1mrGj/t/wYdCi27MBG4G7zSUJVyDVgDugkBq7zG/GUrnAY0bF62PHI?=
 =?us-ascii?Q?NV9gMyfrgA47eKN03NZ4bLjZGjUjbbpy0oiropAe1wrlEqxy7Qwk0muU2gMl?=
 =?us-ascii?Q?Rmik7vHBRpFQJBreU/j+ZtRsTMED+OMJSVjUJtVhoHNykRMKWh3+ug7KNL0o?=
 =?us-ascii?Q?XAiV9sPOTdhGFM8WHKr8IFjuJS5T1d6X9ZnAQ0+ke353ngfPCQ/65GTiRe2b?=
 =?us-ascii?Q?w+NFk+vQiS10trzLrVsEDKK8UuVtDMovQj27RXFlGpxSqwQyxF3HnajIIibi?=
 =?us-ascii?Q?Nb+wIfiGBr7bjLncB6q5guhRM4NFrYSkro/0JPZVg5dsWO1Wl80xtzc+IB2y?=
 =?us-ascii?Q?cq0kSOtFYdlri2oWHEYKFwgN+Vwhb9/PnjwDKhGQkxetSdRS7cXrPwt1DgB3?=
 =?us-ascii?Q?kM1ysx0Z1/lkC523pvKX44Zb+nqhrgVqUPbY7Pooo+JLYT7k5d5w3q7Gh+X3?=
 =?us-ascii?Q?sbkRaO2DxMXja2VZMF7+IL2+lPk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c7815eb-7098-403f-5ff6-08d9bfac8fdb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 09:23:31.9823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9dkw4ojf6oX4OnGRgdB3wb3lZLTr5ErFXJFBsS0oEK/+ydrT7+92HfTvnID9Rbbr0zZJ8SifGWkXthOS5ynWuZuMg31D49Z6/Em640kBzGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5554
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10198 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=970
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150051
X-Proofpoint-GUID: hySEPWp0qReI_97m5XjTZzWF0H_w07EH
X-Proofpoint-ORIG-GUID: hySEPWp0qReI_97m5XjTZzWF0H_w07EH
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Srujana Challa,

The patch d9d7749773e8: "crypto: octeontx2 - add apis for custom
engine groups" from Dec 1, 2021, leads to the following Smatch static
checker warning:

	drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:1807 otx2_cpt_print_uc_dbg_info()
	error: buffer overflow 'mask' 4 <= 4

drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
    1758 void otx2_cpt_print_uc_dbg_info(struct otx2_cptpf_dev *cptpf)
    1759 {
    1760         struct otx2_cpt_eng_grps *eng_grps = &cptpf->eng_grps;
    1761         struct otx2_cpt_eng_grp_info *mirrored_grp;
    1762         char engs_info[2 * OTX2_CPT_NAME_LENGTH];
    1763         struct otx2_cpt_eng_grp_info *grp;
    1764         struct otx2_cpt_engs_rsvd *engs;
    1765         u32 mask[4];
                 ^^^^^^^^^^^

    1766         int i, j;
    1767 
    1768         pr_debug("Engine groups global info");
    1769         pr_debug("max SE %d, max IE %d, max AE %d", eng_grps->avail.max_se_cnt,
    1770                  eng_grps->avail.max_ie_cnt, eng_grps->avail.max_ae_cnt);
    1771         pr_debug("free SE %d", eng_grps->avail.se_cnt);
    1772         pr_debug("free IE %d", eng_grps->avail.ie_cnt);
    1773         pr_debug("free AE %d", eng_grps->avail.ae_cnt);
    1774 
    1775         for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
    1776                 grp = &eng_grps->grp[i];
    1777                 pr_debug("engine_group%d, state %s", i,
    1778                          grp->is_enabled ? "enabled" : "disabled");
    1779                 if (grp->is_enabled) {
    1780                         mirrored_grp = &eng_grps->grp[grp->mirror.idx];
    1781                         pr_debug("Ucode0 filename %s, version %s",
    1782                                  grp->mirror.is_ena ?
    1783                                          mirrored_grp->ucode[0].filename :
    1784                                          grp->ucode[0].filename,
    1785                                  grp->mirror.is_ena ?
    1786                                          mirrored_grp->ucode[0].ver_str :
    1787                                          grp->ucode[0].ver_str);
    1788                         if (is_2nd_ucode_used(grp))
    1789                                 pr_debug("Ucode1 filename %s, version %s",
    1790                                          grp->ucode[1].filename,
    1791                                          grp->ucode[1].ver_str);
    1792                 }
    1793 
    1794                 for (j = 0; j < OTX2_CPT_MAX_ETYPES_PER_GRP; j++) {
    1795                         engs = &grp->engs[j];
    1796                         if (engs->type) {
    1797                                 get_engs_info(grp, engs_info,
    1798                                               2 * OTX2_CPT_NAME_LENGTH, j);
    1799                                 pr_debug("Slot%d: %s", j, engs_info);
    1800                                 bitmap_to_arr32(mask, engs->bmap,
    1801                                                 eng_grps->engs_num);
    1802                                 if (is_dev_otx2(cptpf->pdev))
    1803                                         pr_debug("Mask: %8.8x %8.8x %8.8x %8.8x",
    1804                                                  mask[3], mask[2], mask[1],
    1805                                                  mask[0]);
    1806                                 else
--> 1807                                         pr_debug("Mask: %8.8x %8.8x %8.8x %8.8x %8.8x",
    1808                                                  mask[4], mask[3], mask[2], mask[1],
                                                          ^^^^^^^
Out of bounds.

    1809                                                  mask[0]);
    1810                         }
    1811                 }
    1812         }
    1813 }

regards,
dan carpenter
