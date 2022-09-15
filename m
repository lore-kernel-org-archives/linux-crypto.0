Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF16ECAAD3
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Sep 2022 13:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiIONzl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Sep 2022 09:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiIONzj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2022 09:55:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1293A74E3E;
        Thu, 15 Sep 2022 06:55:37 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FCmIKY021819;
        Thu, 15 Sep 2022 13:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=KD61jvWgznv1biLmWQdq33zGllesS1kVKy8K+VV2rRQ=;
 b=YSvv5nLnMVftUfRLfUO3Y4f1StL+ujFI/Wx8lsP9+gpKWSKI0VZst9CAJ1KB+GvOJsSc
 neT2hwySa4BI9CHm39NYVPM/sj/OjxD3DD4woYV2r3D9urSamaO7Y/ZiMdpovQkZO+NJ
 Jyag95UrfI4uxbwOd0I3hafETKc7tn1vMDypQTgQOvjCjn0VV2L0aBVX5E8AqaZHN6Gy
 77P6D7W6on7Whr5m7wLotK2tNontO7iR79M7yNFvVDnzDpvI9hrKLIcoCZOiBBeRY6pB
 yDG4J2KCyPjmRgfHfj3GIc79kOh1TiE5wSS1YrsOcAPphSqw6i1faqaChN8MBfauDmlu eg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jjxypdayp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 13:55:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28FBUTnX037979;
        Thu, 15 Sep 2022 13:55:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jjym60f7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 13:55:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ItZ9xmyxh1gok51h42cGdXPJBUm10rxtS77KDGeR2oUm9iqXPXBexT7CTfbGRlHffx7XqABCXWg8udw71pULv6yh7r9tckqb2sd1KfkYfX+YlY12Voct3xH4+Rze7/F6rW9/aWCyd70DgolEfG+JZzKR3yVtmSgY+Hy0485X3a3i2YrjYY61l9Gna+GjG5W8KzHJpaENrbu+JhGszQdEq6vRztx1B3BSvxfFsbJDiAE6H9Eg+CzKfsO+6l1EmWkLRl1vXub0DdMnTz7XEBcuUpoWpkNtKnh8PcQIuO6YZ3Y/oPEyz73siVPhnxo9EFxF1cFlhVjCDjYbJQgsggTiJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KD61jvWgznv1biLmWQdq33zGllesS1kVKy8K+VV2rRQ=;
 b=bYEBMyRcsURHJDEVa61MNG36kIXXGTNdJXseMdpWMUJTIoY3+7SDw30nSDLjMxKYplGlI32n3RxBNLGComAhhqwGI2CO3+d37ICKzyVpcSAE6xSN0s0v7lpXY5BG74jsU/a7hOt0HHNLRPT9wrlbnRmU8pV3FZwzROOhMBYnWXDHPMXn0EufWGHgAPQrwzmv27m2ps8P9jx/2AlYBRBl12YxpaJvtCoxymekXtU3YJ3TQkrJHxn9GkUs3J/iDKWr68PpSGaRJlt4wDdT9uXJZG3aK6vB30Abd/FPGTw9/G1BBCWfVSIaCBnws468utRZD26qVzTsS3RCCxFEconGNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KD61jvWgznv1biLmWQdq33zGllesS1kVKy8K+VV2rRQ=;
 b=kRB8xf9YI+f+60iYibHWP0Qkz93dmn4XsZFkoOnJnyV2AJWDirwc3oIoRa/cJsqf+fO010cfDC2En8LVituy+4vVaawh0bde/ENKrpl9RECsuJy1yrLS18a0P5VEZaKkgHAFPnZXGU8Zc525N5s6IjFeeFQ5hBQQr23Fd0dudv8=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SJ0PR10MB5600.namprd10.prod.outlook.com
 (2603:10b6:a03:3dc::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 13:55:17 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6%6]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 13:55:17 +0000
Date:   Thu, 15 Sep 2022 16:54:54 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lukasz Bartosik <lbartosik@marvell.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: marvell/octeontx - prevent integer overflows
Message-ID: <YyMurruKJH2TKhAR@kadam>
References: <YxDQeeqY6u5EBn5H@kili>
 <Yxm3MuG+2hMdJSGB@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxm3MuG+2hMdJSGB@gondor.apana.org.au>
X-ClientProxiedBy: JNAP275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::10)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|SJ0PR10MB5600:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b37d890-048e-4096-39a2-08da9721ebbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hJ4s3dkEhJoeOL3PO1keil5VNIMQG8Idlam2kRQ8XvJw++0lrqC4ftMiu9pKLgQGJZhORdu/UQd1NLZq/omDuZndZtycmDY7BZaMd5OkzcqdaVhqQZLsaI0p5Z5KubLF60gzo3FJ4jKt7wL+WJ1iKBeVnW8WS64PtLSE/MCQwVfHhfZ1E9vMgJloCKlsdCmo3tQfKUuMrXUQ0K7/8dMeOxyvEMuEJ8B9REupiFWmO0HdQhlfzGrfpVPqbuqZ5Z4TZVE7r9xOOUrctmHuT57ETmOk9CTXlMwvogGxZq8jJQbILA4yOh2VRQR0hgGQ8Gs/T2xG/G9RU107vGXPTgAtxvZt4mIGhxvqvnjaugOTlVGJfe9qoa9Rh32Mn2zR65m4si6AbHL74prO8hUVP0Z06RFjJWqqpAXDxpem6Exz6IkeG3iPE0ZnWpdvAY2950GtuNi21Z/SHwpxOI1Gyn77EM+pLCabbV24TdHKOKegkPeT34osErJ4YMv2b1rfk/Xhx4E/zicdHa/LWE40ttCLhp1TLTuLoDaYCuMRVEe3q9OnGz3XNs609YA+hYPRvS2e7uNGhZLLfMf2FZT+qqIBMVSmAkGuO9sC7caB5XnsxzMlkjKHju6FctcA4aumwmTiMU7RZxQVvIggtvT+95UlmIGANf7tPa7EEoAzDbpNAYcPV6lwM4HEWTHqJL0TNIHifkS/DlfTw4VgpzwiOQRrHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199015)(26005)(4326008)(316002)(7416002)(6486002)(54906003)(86362001)(66556008)(5660300002)(33716001)(478600001)(6666004)(8676002)(6512007)(38100700002)(6506007)(66476007)(8936002)(186003)(66946007)(44832011)(41300700001)(4744005)(9686003)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qGQME+BKJeKgivE4HL8ejab6+WPqlB25r99dL0fpBi/PUnDqwHlbFNsJduj0?=
 =?us-ascii?Q?YPCHpgfACK/SO/9WYLOJiRY+FnwwKFPxQ3NlWSSytG1kVsYUbzD5ilF71Zyd?=
 =?us-ascii?Q?JBJYmZm66Q/sygSIana2kQ2GwK01fUeR0xV3KEnsAw1NXOLvDnnoCIgv1Z6e?=
 =?us-ascii?Q?nJ6m0cLTjjPMbE/Xjjre0PN3iSi7O5yheqrRLEundXprf3cdH21wOA1wPqyn?=
 =?us-ascii?Q?Ie6SBQeDVzY1pLMguYSwInVwRHrTdulRi5zy9f31i0h88jzaEr6jEM5EKO/p?=
 =?us-ascii?Q?mDkyxB1vWQVQhh5xC7w3xbV/tsWSwSI+OnPHJpz9DOd8nDDBSrDsw6ffnFpE?=
 =?us-ascii?Q?am+sLbDIfQYpGoN0CgOv0cjxh674h4GyL3pzYiXhC2mYA0YLEql/YCLtaipv?=
 =?us-ascii?Q?YMC0rkAFmr85BfLXSyOB+NruFl6iLQ1m3e1M0Y4LpSuMBjbQnPWpCNkPfj00?=
 =?us-ascii?Q?PYwxRKDI7fHqUY4lgBjLDJZXAidb0Npi7V3a0+JYZe3f8kixR7IDWBMw9tPm?=
 =?us-ascii?Q?S/GcxmBnvghqNn6h9qjFtWziYrHKWzGcTG5XsiZnL/GuYz4eMXAF+dg4pOry?=
 =?us-ascii?Q?PaCSGYqMx/9Cb6TvjXPzHYtlb8GvVm8ywOkLyY5j5wp6cD/iEv9B1wLWdgyd?=
 =?us-ascii?Q?duQNZ3mn+knpIGXTuljEYxcnfYGleITbu09nJCln5FxJYOyNNI5EztdGVf43?=
 =?us-ascii?Q?TqnzDT/uy84xJzEfxZrAOsCTJWPUlEYe/IYbsgFAbSIy6OCMP8703LZO/H8Q?=
 =?us-ascii?Q?Rbzp/u+s96xEEHVDFSRKFBPJi6EW7+cXg0gdpTMXm4gkMsuV0LJ+XRJk/f7p?=
 =?us-ascii?Q?gqRzk0C8Z++J84eD1wP7U6Ya3rx3bCAcBT2cFb837zluUGQbSkW0RXrwkGU6?=
 =?us-ascii?Q?H9l0ki4exIAI1g4xz2fr7P9BKlufKdY8F5Rj5T+tcrQHcicKqfe7wsdUg0E5?=
 =?us-ascii?Q?iUmqgO2dXXBB2VMyh4RErItY1EzHXrn2CcuOa2JKyGlVQi2eAmqGMqFQfpeO?=
 =?us-ascii?Q?ulq2tbRv/5WlapaY2WWR16k6OivBl3yU08vyatonzForcuV/F1XB7ZonbPmN?=
 =?us-ascii?Q?MH3FyYwM4SLpDZfbbm8PmmHtJ0qku0A1UKmALWGpc2InOhpsFm6+2zhmPeDa?=
 =?us-ascii?Q?RoTv7/omAHxnv6kjl+oCwGNy5pbkddxg4Ij7UvQW+02wzxE5ytdA62vGo4rN?=
 =?us-ascii?Q?nyzHwAJ9ecEACvePx1W+QR0Cul9X1jkZ/ymEgUBthViJj7J0q3lZ31vF7pRp?=
 =?us-ascii?Q?URRV3klVfkQWlTTFKc/zgCDoZ/aFxrcfi72ABsogvGw+H5qHmeadnf/JiZ+V?=
 =?us-ascii?Q?cMjVhW4K1Xv+RV6Ux0xZ8ty623AU10qDzeF+KjPRwvajJgpWWYvqASNTmDDa?=
 =?us-ascii?Q?jaoXOC00DtnfTy+28N0mgpFcR8fDtdrMDIt7tt5dcCb5FfzrMoYpxSy5IAag?=
 =?us-ascii?Q?SZVTSOsnLmijn57CgVS+oUuq17i9WiqclFNzjoYdei35Z3Tc/2DjnRup1VmD?=
 =?us-ascii?Q?lQc/EzWMJ0CC+FHVFuxov2xlHGOkxYT+4v/Cteo08o9AF23XIQnFTQSnLsUb?=
 =?us-ascii?Q?kHZn4Jn47k3e25rZwS/EiQuRMOfB061GGxW+O8heO9CaeAsgSFgozKRYAHMM?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b37d890-048e-4096-39a2-08da9721ebbb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 13:55:17.2852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4eEnoezZmiJNY9hY5q/QQ6rrl84Yp7Tgg1YambXj9LMPsRGfU4uDEmPJ7RlsYe88rLnnqW7aIoUJh6ZRwP2Sq0xVkFmJazyQlpPigISEjzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5600
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_08,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2208220000
 definitions=main-2209150081
X-Proofpoint-ORIG-GUID: HzCxYEPdQNJwZO7zsda9pdRQwypyV3zO
X-Proofpoint-GUID: HzCxYEPdQNJwZO7zsda9pdRQwypyV3zO
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 08, 2022 at 05:34:42PM +0800, Herbert Xu wrote:
> On Thu, Sep 01, 2022 at 06:32:09PM +0300, Dan Carpenter wrote:
> >
> > @@ -303,7 +304,13 @@ static int process_tar_file(struct device *dev,
> >  	if (get_ucode_type(ucode_hdr, &ucode_type))
> >  		return 0;
> >  
> > -	ucode_size = ntohl(ucode_hdr->code_length) * 2;
> > +	code_length = ntohl(ucode_hdr->code_length);
> > +	if (code_length >= INT_MAX / 2) {
> > +		dev_err(dev, "Invalid code_length %u\n", code_length);
> > +		return -EINVAL;
> > +	}
> > +
> > +	ucode_size = code_length * 2;
> >  	if (!ucode_size || (size < round_up(ucode_size, 16) +
> >  	    sizeof(struct otx_cpt_ucode_hdr) + OTX_CPT_UCODE_SIGN_LEN)) {
> >  		dev_err(dev, "Ucode %s invalid size\n", filename);
> 
> How come you didn't add a "ucode_size > size" check like you did
> below?
> 

I'm really sorry.  This was not my best work at all.  The ucode_size
was a mistake.  It should have just been the check against INT_MAX.

regards,
dan carpenter
