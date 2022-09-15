Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FCAECAAA1
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Sep 2022 13:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiIONuf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Sep 2022 09:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiIONue (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2022 09:50:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C7594EDB;
        Thu, 15 Sep 2022 06:50:32 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FBBOMU005212;
        Thu, 15 Sep 2022 13:50:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=i4Lymbd+GDxFkKmqtXznnRm33KdPqYyRIF0/wQVfKpk=;
 b=MWLHeyv7ENgWZEq/ORv0PPKKUTaWdVp6cGllWherPjIWN51whtjioFybUtgSJyOYqW6y
 AJs7pVni4EWegpAF2/qGsSyj/MIy+6xSTMn8BT25QNJPrFPMwEJ4vGoFHaPhdEleThOq
 Zl7IE2vOJSZgdxIJ3ZhF7Qc6TFdz+BPGKZeHKhVL8HeyhY3wBi9wgnaHxd1QHyL1Fgrp
 PUtF/SIzsyCyYbGN5PI1hKjx9wo6ce1XgMYE1S+WoS/s8zLA6qxSx59ICt4cnjYl0mTB
 T7I8MUykoET05JeLw5tNUsIADUxDooL7NQP2rFUIax8OGeR04ZfJqFcopCyKcPoyuFcQ Ew== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jjxycd8ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 13:50:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28FBUUNd027781;
        Thu, 15 Sep 2022 13:50:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jjy5fgrxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 13:50:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJAOEdTnrvcMYtX2YAWrZJP73E9120bptKstyXq4JAscPzyJWzlBGX9CNU7VN6RkOedPwQHF5ndW8Sz5XOo9kiFk7fOuJMJzj9cmpF4Z4VV9vhwetpE8f5+H1a8O892wRtc0Nb+mN4Fr+xfagkhvtQJV/0eCX96Pz/5T4VBij/K94TATNg0iCXykmBforbVjQyVIJzay7hIFITaI8XNgOg3751rvzSS2SxCVCSNnTMkSsn1HUL3lTT5AQ+BEMdKmZ9za4fLhcTdlIKmbejxyqC5Eg8kX9noCr4LuOGiVKAYRM5zTuJtJ9OqzCz8LqDkBZvE0cgvqQXL2+pwWNaCsfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i4Lymbd+GDxFkKmqtXznnRm33KdPqYyRIF0/wQVfKpk=;
 b=OJpE1EfhbLWE2MIzlgn9IfofUkkAy10dSi3h2rRXQRnSBuNRF1kmDDVodumKJZrePXXagwtPgQ166/97AntRi2WpzS6Gc9m8MmqezY4+au9ORJ9bXBfPLqVtpt1sILxJQFXBGzGdtY6uIu1T6Fo2W7QC+l83EpmAR+UzqFbAgZFY4TV980Gvl6toHxu6G0xZ013hou1uuaMLUlgXxFDSKZLqwHPMPWn3VD7zSHWuE3xZhlUaianmKGxlR8ycHn/0Zdho8xwN8Q5xArekNs6UGpJOfbFvhqQ8ZfA+1Jejxuc8GWfdSV2jCwcRaKojt5ovnHV8uB6wderrDiqgwlaQZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i4Lymbd+GDxFkKmqtXznnRm33KdPqYyRIF0/wQVfKpk=;
 b=lshGc0vQ0F0pUK7QrgCkPpoQbZuWBo280d53e74HHBCrZunAnQEhZjhdcNwVkNOSNO9NWKR++gcAyZee5RJqssIlJ5WaQobEXPz+D+YtLrSCxIlKRWX7/vTtr1p8I5myIo5UAYDx16ctOPVWXxGcZ7za3HLLxRnUTPfX5QHmYL4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BLAPR10MB5124.namprd10.prod.outlook.com
 (2603:10b6:208:325::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.14; Thu, 15 Sep
 2022 13:50:14 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6%6]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 13:50:14 +0000
Date:   Thu, 15 Sep 2022 16:49:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     George Cherian <gcherian@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: cavium - prevent integer overflow loading
 firmware
Message-ID: <YyMthStaEzAStvS1@kadam>
References: <YxDQpc9IINUuUhQr@kili>
 <Yxm5HrtXBiz6gKtv@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxm5HrtXBiz6gKtv@gondor.apana.org.au>
X-ClientProxiedBy: MR2P264CA0051.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:31::15) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|BLAPR10MB5124:EE_
X-MS-Office365-Filtering-Correlation-Id: 66bd2d26-ba24-4347-a094-08da972136cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jZZ9opugtu5NA0DRxIhfeFR3lkeiLXpZBhXU3808CMlTpANE3Ag0VV1abSZ9txoFO031KfRIZFRSXrc1unl1f7ydbJNP9sNAjh0SZHgPqIUyACybxK/dwxRQ/PHWexSD0z+aWwojBJrmYfXjU1g55b3ArvoC3v8M4iIs5OKP2g3mKJyV+fhULSOlWfOp1Xus7AyvVhd1QIOOrCHUBYJn/+ZgQ9KUOptAu50KqvkgLIMM1gEKPCnBN39o6ky8rWspDDVk/YkNRjBAQOarX+XDYQlcF91aHli/YGPPez2LQSU5h2szA+N4NAlX/kwCFsF+sRx+EPabN4HUsOlQBAZtK1Cl/KJT8RXgWbHM03zexLNAXGm7gFGop497p7b8sqYO5JZPiyK5/BOP2agR/ot6De7aLAYrX4lXD1n1pCw6i6TF/6ZuINDA4EYU99XvVCiswyeAI7xppyG02+sHazi/9W0fNMCj00MsOqFIkpwVeDpVO1JO08X8K5k7Kr+x5U1xij3KhyRa0togUx6G1vk1rBGEc7sqet481WVoXX5U3x/4da5ftYW/cV5LIhXSYfQ37VGQ2mWAXK4CydmViRHIcDqotM+2R6hfPVPQJ81W86lVCBstUBBnkL4h8Lh+nx5eroqfY4jMLt+YY3wR+nrjy6ftSDz1YlbAQgYh1SjA9cMQEfT7w7+WuHegsbQnrAzyeWXKyZcaXDv5oc5ohyLHYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(346002)(396003)(39860400002)(136003)(376002)(451199015)(86362001)(6916009)(5660300002)(66946007)(8936002)(6486002)(4326008)(38100700002)(8676002)(66556008)(66476007)(316002)(54906003)(83380400001)(6506007)(41300700001)(6666004)(478600001)(26005)(186003)(9686003)(6512007)(33716001)(2906002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kl4jFzQEtzmD0RcP4Uh7paZ8YtWtu8PyT0q96kCiepDPoVRGLUWM/srtk06F?=
 =?us-ascii?Q?tTGoB2vDTe3gkjZ4xhZGN5hKOHQKz5SoKa9jPIoLTnAlFOqVOlv4eUeQUWVM?=
 =?us-ascii?Q?81SR/mvAjoNWQPVeLQJ1QUGJSh6y1qgQuPEVimVdK+eK7MQuhk1kSywtgQ02?=
 =?us-ascii?Q?QV0u4kFYVOj8XqDLfenN4nMAFdChd1sr8XiHGCi5hRQbiOShOrKe+azwvl4A?=
 =?us-ascii?Q?4M03oBWhzfjQgBAFS3snoxGlDEA5luynaYlEs6ypv5CnGw346k+TckALDAlR?=
 =?us-ascii?Q?RJLoSkkmtTefrmdr1N8R/x1OAVvb7B5AieLHVKoS/jIfB4ZAyMtspu8Uu38l?=
 =?us-ascii?Q?F1rSx+aYdrYtM1D/eVnozrqAUXUeF/M0lxoUp/iqJhdGj0n85IEG2AtlgvLV?=
 =?us-ascii?Q?h2ejxxv4DAIDR7w6kehL/jA4ogcGpVd3w6uiwp5V8rMjsFMCK4XY8lhhz5TJ?=
 =?us-ascii?Q?xxxKdmJ6VHBYwELVp1uczwHp0A3+n/XR4AtZ8DAKaLhQIF23SsHbV5bEsi+k?=
 =?us-ascii?Q?ZdOYlM4IbiIn+4vKXYqWFAdCraPkl3feoYQgZBIeWtuuLrffd7qY6av0+6yU?=
 =?us-ascii?Q?G/aXghY/ro2PYVNFLnOJ8n9yQH6Q/jGgxd/8RoGDiFPMPQsA/bsZjQ9N9KqY?=
 =?us-ascii?Q?Thq/NPWxmibmzbDgOtRPZ2LikCUEknfrYj/tEtmSNT7+XGfTLegtEiyTNgEt?=
 =?us-ascii?Q?DaUw9I5dmHmwXa+3qcuLskVmyFVC5+Iq8mYN5dq+kuwJU9IxOhEvL0+cilmC?=
 =?us-ascii?Q?5wwkHRwGf7DArP1nlBFBF96XP/v5CPx/vTqncDmfWiCLWS2rhtb8URq0XO2w?=
 =?us-ascii?Q?7qq8K17QJafArdbsduwpIwh4izLoWIQ2BTtB8A3aljILn2zty8az2dYStsjD?=
 =?us-ascii?Q?h3V68gN47HNC8//yJYeLUXFLVU/0vubnMzAFkbnFbQ4tbhlCOnmaBJ3xpsaz?=
 =?us-ascii?Q?NFnRLwuf2PW3SHOirzdVAMWlRvdTCAFX2/MI61uG/up40X/ahIKc2D3b12K3?=
 =?us-ascii?Q?2mkpz72vRPJmN57TImZMVE7A++HdinsOg/aXTxJCR70FpP1+v4OCwylwxAnb?=
 =?us-ascii?Q?ZpeJqya24rj53gOZ7ZMCJj8bQBJ3qHZ0VBKjKENvlOiTdXYknkTY7Li/3cGi?=
 =?us-ascii?Q?7KCdMhOX/EAFByiz7NLFggDBSREYic9jzXsz/UO7uRVeDb6s+yXW0VUraxkY?=
 =?us-ascii?Q?n0LR8AbzgdEG9xOqM/sQRpef8HTDVaytgTAKurZV82yuq8FtcEYU+/tfJxLL?=
 =?us-ascii?Q?OgwEPZ1Y8hSyOyJH/Bgo6pV5V1jiekALZ3k7iFYLUqHDmpL183l7G6JbRyLp?=
 =?us-ascii?Q?2aq00SZa+Dwh31M6UlKPZSg576t1EvTKrIxVxsBB9kshcJ2MQ8uMXAmO3mus?=
 =?us-ascii?Q?WRNEnd5vNmQI+klA0ZxQXBh+EWjoVYb7+ei3MK5MqhAcLrueuT1om2jSkDdI?=
 =?us-ascii?Q?AjChtlz4YtLcNGoLhIwq7Kuju02QKbrJp/TVhtY53bIiJfSjW3I4PhSckRGF?=
 =?us-ascii?Q?BfZ6woloQIuTaI/8AxdGL3WLsV/5GcLWtV788N5Tgk6vUV9/Bkn+bpLrY91N?=
 =?us-ascii?Q?UJd9btXu7T3UXaB5XDs8H0EAbgTqvNXL9IpLI3V7ZtL+fGjLQuXVh2tvhqwO?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66bd2d26-ba24-4347-a094-08da972136cc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 13:50:14.0753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+SKMp89QbyK4WZFO9LqMFqsY7rKje9G78QP+h5Mgq+a7IhWTEiDD/9dVUmI4sHup/b1EpA8GZTqsu+F0xDIdQCrfmhFjtzrob4/F/fmIbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_08,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209150080
X-Proofpoint-ORIG-GUID: ba8lnmIm5TZwit0DMejz5zuGZByLl3zF
X-Proofpoint-GUID: ba8lnmIm5TZwit0DMejz5zuGZByLl3zF
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 08, 2022 at 05:42:54PM +0800, Herbert Xu wrote:
> On Thu, Sep 01, 2022 at 06:32:53PM +0300, Dan Carpenter wrote:
> >
> > @@ -263,7 +264,13 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
> >  	ucode = (struct ucode_header *)fw_entry->data;
> >  	mcode = &cpt->mcode[cpt->next_mc_idx];
> >  	memcpy(mcode->version, (u8 *)fw_entry->data, CPT_UCODE_VERSION_SZ);
> > -	mcode->code_size = ntohl(ucode->code_length) * 2;
> > +
> > +	code_length = ntohl(ucode->code_length);
> > +	if (code_length >= INT_MAX / 2) {
> > +		ret = -EINVAL;
> > +		goto fw_release;
> > +	}
> > +	mcode->code_size = code_length;
> 
> Where did the "* 2" go?

Crud.  :/  Sorry.

> 
> BTW, what is the threat model here? If the firmware metadata can't
> be trusted, shouldn't we be capping the firmware size at a level
> a lot lower than INT_MAX?

This is not firmware metadata, I'm fairly sure the fw_entry->data is raw
data from the file system.  Realistically, if you can't trust your
firmware then you are probably toasted but there is a move to trust as
little as possible.  Also Smatch marks data from the file system as
untrusted so it will generate static checker warnings.

regards,
dan carpenter

