Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82516C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Oct 2022 14:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiJMOp1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Oct 2022 10:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiJMOp0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2022 10:45:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425DB5F217;
        Thu, 13 Oct 2022 07:45:24 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29DEJ9qX008445;
        Thu, 13 Oct 2022 14:45:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=jkKbp4YDMsFPRqDZ84qYi3JUY9SKCUo7uTCD52SoCIU=;
 b=IhJ+npqnyDSnNKD1TBai8VhzQV+T5aaK7KfA94UQqVFjstgFMkgjsm1r0KWRM80qMYpN
 hSp9kUBlIS7k1d8FV8qJWbf79piLHkevzVQxfNNB63PThwLDD6vB6dmjF0SygmTj8KTk
 ywryF3p2wgx+ey+JsfdAB2MxDwW7QT1NKGWu//4uQqxlJI1ZtDFF1i1Y9hKHtZ82fsEO
 8GB7obUoMPticx/c+2if8uCpKg/TOZ6XN4vrbjTF/Bt19LEydeCfeKUQFnr2mgv8eTKX
 Bc/nH6HWFd2nh1aTAlefrTnOMwIhTBfXrLL0JnsL5zq2sEBydR0A4b/McYSdAcyAG//W sg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k30ttdc5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Oct 2022 14:45:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29DDObbe001723;
        Thu, 13 Oct 2022 14:45:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn6a0jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Oct 2022 14:45:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9brz8b5yczAu/2W2PzpkU7EaMMGed8K6uvIhloL9P+YNJ3907qmV6EHRExYTpo/MU3Muk4Sj+LdgeqwYFSj5MtAEOkDj4prGjIdxYBLBeVgPPaXOd/UnNpM7t+D1dKLTmoSkg5qBG3A2+nfD595ZLIl6VFLqi3PV4l3jhvzJkATeo7vzSCYBYHPMG+M/coSuE9KF4zPWIoEzGdsBjlG1m/uLoNm+5zntUuaDEFVUxAVo84U6atw08hsR7Zq6jy9E5BFkLU7RxRS2PA+2ynKGFOmamxRuI4vQXKbh09oAlG8roVvyUBu+YE65KQg4GrHLyL2ILVtno0UyBj10M3xEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jkKbp4YDMsFPRqDZ84qYi3JUY9SKCUo7uTCD52SoCIU=;
 b=ly2hDxmJLRe5x7+XTRnn+OWI+MwcU+xpbNF5vyuMkQzQtfZbHpVCKzoJc65sY+G9yPy53Alm0UrkCsn+UhWEg/6TV2ixUTXGJ9et4almTEWuMUTnIXx/nl1gx/qpOeb4ZWc2OkKHSeITXUPiNoRsXhnVowWHLzFF0W5MNGQCyPySNdgtyXSujR4rOcwk0JyrAR5tuQeBXEQahev1Afw3t9QyrvNxR2n1BUTVwU7G+6ioJECMwnokRpC/8QpPC7U9d2l91zukGsvpU0A+XtVAYyFnhlxIoCK68e5K7GPyp0fEDgqxSoomlzjh0LDeQoNdQqJMzp28kSSf3YcdflccFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jkKbp4YDMsFPRqDZ84qYi3JUY9SKCUo7uTCD52SoCIU=;
 b=QgO+DSeAUVH3VpT+73bO1Spr1oPXCZ5HIZXztzx2q8ZeaZnhmvBpB75txNwRJrNE4kRO7nihtJFSzr2nYMVwaTm3Ecnd3GBtrc/tu3U2UG4B4Rm1fR09Uq0e7HeEfME25vEdp1/rLaly2rkHaSIoYE7zUazN/ygh5bGM5uW3FZ0=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by IA0PR10MB6721.namprd10.prod.outlook.com
 (2603:10b6:208:441::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 13 Oct
 2022 14:45:10 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec%4]) with mapi id 15.20.5676.031; Thu, 13 Oct 2022
 14:45:09 +0000
Date:   Thu, 13 Oct 2022 17:44:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     George Cherian <gcherian@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] crypto: cavium - prevent integer overflow loading
 firmware
Message-ID: <Y0gkXAkIjeoAkQJ/@kadam>
References: <YygPj8aYTvApOQFB@kili>
 <cecca972-33c8-03a9-d632-c85ed06dff8b@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cecca972-33c8-03a9-d632-c85ed06dff8b@wanadoo.fr>
X-ClientProxiedBy: JN2P275CA0016.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::28)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|IA0PR10MB6721:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b01259d-2ec6-458e-d7c4-08daad2986a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6KH5Z5h+mLjGitJ7OFGmcTfuA6Kg9W8ognSZgkJ7ZLhcTSPO+P39WxLQCRFaSEc5QnGP3bgBT+jZkUYvWfqQdVjYRRojr6FCr9ugk1IegN3zcPwN+E8SQ1gukmiR2FAqZHwn7WcxMNZdgCASlE4j1NV809IJG65sxPgTE+hnMLofM2xztW8n3H3otIEoiKG0vu4WWAIBnhPktDaDWXiJmADO3ugl4MYCer662mhHHEFAsSAvP632vUUtp99AKvG4RTcOgHNeIydzBfsErCTSROF2nUjZLyTJZRJmmL/3aLiofoOEALSemLbU3lH2ugyNblioywkdhIj0a33+yxlmd/0p3Gb/kjWw7sY1tDljm2hybKSVUz4IEDd5fdHLqVEdvhvzpGhKgNX8B/IN54Ri/hjEBxPbqpMOQgrTCzlAYXJ/SpUP/b05oD1HvfP4aBEJyc6RinHOkFYjSHKT2ORJ8K25MBnJ51MvH7rhJm3iiz7hjgw+f3bTnCl7ryilIaw7i3x+XizZ7vM5iwLVghKSd2B/nZgjVrF1XKKIcX63YE8AwJayVrCUj6OCKKBNUgV1VNpn3p3gL4dNKsuhpNQDI5ed8ypMZwmsQv2DVMqJ3LWPHlpdwl2cFp4qCj/0aIiogepwemcApwcwmbbcVOjs8yIlUd2RH+jWTBbygH/4JkXTiN6SWyVLhOWZD5VAnRWmvfuEA7AVaePocV++/4BXww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199015)(8936002)(6916009)(186003)(2906002)(5660300002)(86362001)(41300700001)(54906003)(26005)(6486002)(478600001)(4326008)(8676002)(66476007)(66556008)(66946007)(44832011)(83380400001)(316002)(6512007)(6666004)(9686003)(38100700002)(6506007)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K3RunRNj+GqY/NZAncwqryYSef8jZ/f/PZAWkIE/PtMzhcQFoWcImkF6amcY?=
 =?us-ascii?Q?ZwsXf4N21gliaV+p+Bl97Uu6hFF3sgSubjte0Xbwfkf/vUSRreDh40piN9jm?=
 =?us-ascii?Q?ZA4Has/+gy/uTyvf8BWKRfII8JQuXIG383ctJHd3nlTQFkOzK4C7mg9/3e4d?=
 =?us-ascii?Q?NSmJlfZS6DUD4mfkDeOJgM3YnGhKjSXi8yxtmu1AgMuvCm66DAT2buwwWhWL?=
 =?us-ascii?Q?w2vlUKZaKfoPYBurMXXqNWlB1TEADQQ5R2gTb+A9PMfNDc8Egt3mtq+yzMZn?=
 =?us-ascii?Q?YmSMzwYBzOLxIWl+f8Y8MlJGdFRiCaAiWZsw1wSDJLZaKJIKNyWVo/5VOaIZ?=
 =?us-ascii?Q?uL5N+sHTlJDrAy2GYz8SXhO+tl0NItiput25OIJ39w26bmICZLPzF8SFh/wn?=
 =?us-ascii?Q?iBNFs5rVe6XVDQclAn+kC0FWgVe7kEYQ9UWn05tZGw0ZItdLkSyTa81mWyUx?=
 =?us-ascii?Q?BRLc7PVbc4Z2lIxZfhwGYPkRibngz2uoAzxpsTRVOWsJtbSbnDvxtJ7zy1Bs?=
 =?us-ascii?Q?3n01lgQFDzRn83PTVG9Jr33mOut7O86mGAPtvIMIMJcpE00om6hxaOEET7kf?=
 =?us-ascii?Q?QOBkwdYC65A7aDq7k1Rwoeavq6ZjsXxjc06UarqjwD15us9S/kN0MCFSmszg?=
 =?us-ascii?Q?oPRJvpEX784veMuctWcLWEZ6OeUl3YaFUhBpJhREI+o6zWS5/b07n2J0eYSM?=
 =?us-ascii?Q?RPuzuOeHnWhmKtt0ypehkEGkz/YePEpwkihvl59iI+281TFKiy6IjlxhGEfU?=
 =?us-ascii?Q?bph+Rw+Tmx1KjI34u6O9Aajq7N+KXR9cY4BHF+fyw2V2pgJrt8hkblKWCWHr?=
 =?us-ascii?Q?qf7yCWmMVecXUygfikEK8oj295qm2/i/2Nn6oZXBdmhiEvQnQF1zt1Fa3clP?=
 =?us-ascii?Q?ymB1YDMhYBj5jBLZO8M+K0IBME9jYW4x47NWXAxJqvd5gUQycNlrPsCnkSo7?=
 =?us-ascii?Q?iQxFvGCkGvHBphMZfsLnJwdd8Zspx0AE7fkbfjchSfUY4b0B7PPFGeKV87vW?=
 =?us-ascii?Q?qb3Pn+LBBCxRZ0xOeIDS9qW/mZuA7PDOP+wwE9VhC4kzVKBzzKG78NGJ5xvM?=
 =?us-ascii?Q?ZNrw2vXctJj1xcQL4qgpodJg2ZEJmTIjWpKwFEQ1MHlJNJO7iQ05O3T+OHo8?=
 =?us-ascii?Q?Ganogm27O9WG8gzgcvr8tpmR8xT/+WF5lCydyYy6PJfNatL8SHgOJqfll8pE?=
 =?us-ascii?Q?JEPLxk8JKkPKdXfdJw+hezO0o7AIX+0rW8Tb87yHRrnXzQHPh80JVLCY20fa?=
 =?us-ascii?Q?Ueqyohr4egwBM/nP/OU/CCv8MVPUgMs1RzCIzsi8Xs6Ti+yWPIVOqb3tWka2?=
 =?us-ascii?Q?OpWsLjC8VQ+Y1SpeptEVlZBrO/+E/7jbPA2O0s09MQISAv9RM8I884y4NzDI?=
 =?us-ascii?Q?GFWjhBCNczrthcXzdyAjAhhzL8XLiDgGhkuFJOfSoHcCwsUvyOmZB/EpX7Iz?=
 =?us-ascii?Q?fT7BBgq8R5dAYMrCG9ge9AAezpuNM1S1SGlZX6kpIqQat1Iny2yqX8LSmV+X?=
 =?us-ascii?Q?Uz6X5eXd7w8wEHGHnVg/j1ZsTCKh9aE1F5HXewt/C2goIz3MYTzs0GBg0quJ?=
 =?us-ascii?Q?luQ4BwtLU9HfBC5wJ6CEzhftwbbyWY/BiuD/L0JYQ8C5Fr2WRngOVORfFQpC?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b01259d-2ec6-458e-d7c4-08daad2986a4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 14:45:09.8529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eykLabLdLo7wGTO+eiP3jFkX3TpH6TBS2YQIEIAlDT1BgIg56Ymw/GeC1U01U11+gyrN4uJPC+kvdV+hlGOokKSoxDyMwy1ZUGcn1uv0uBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-13_08,2022-10-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210130086
X-Proofpoint-GUID: nf2QE93IWYVoAZ-RGvquFYslnUl-8xxv
X-Proofpoint-ORIG-GUID: nf2QE93IWYVoAZ-RGvquFYslnUl-8xxv
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 30, 2022 at 06:32:53PM +0200, Christophe JAILLET wrote:
> Le 19/09/2022 ? 08:43, Dan Carpenter a ?crit?:
> > The "code_length" value comes from the firmware file.  If your firmware
> > is untrusted realistically there is probably very little you can do to
> > protect yourself.  Still we try to limit the damage as much as possible.
> > Also Smatch marks any data read from the filesystem as untrusted and
> > prints warnings if it not capped correctly.
> > 
> > The "ntohl(ucode->code_length) * 2" multiplication can have an
> > integer overflow.
> > 
> > Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engine")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > v2: The first code removed the " * 2" so it would have caused immediate
> >      memory corruption and crashes.
> > 
> >      Also in version 2 I combine the "if (!mcode->code_size) {" check
> >      with the overflow check for better readability.
> > 
> >   drivers/crypto/cavium/cpt/cptpf_main.c | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
> > index 8c32d0eb8fcf..6872ac344001 100644
> > --- a/drivers/crypto/cavium/cpt/cptpf_main.c
> > +++ b/drivers/crypto/cavium/cpt/cptpf_main.c
> > @@ -253,6 +253,7 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
> >   	const struct firmware *fw_entry;
> >   	struct device *dev = &cpt->pdev->dev;
> >   	struct ucode_header *ucode;
> > +	unsigned int code_length;
> >   	struct microcode *mcode;
> >   	int j, ret = 0;
> > @@ -263,11 +264,12 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
> >   	ucode = (struct ucode_header *)fw_entry->data;
> >   	mcode = &cpt->mcode[cpt->next_mc_idx];
> >   	memcpy(mcode->version, (u8 *)fw_entry->data, CPT_UCODE_VERSION_SZ);
> > -	mcode->code_size = ntohl(ucode->code_length) * 2;
> > -	if (!mcode->code_size) {
> > +	code_length = ntohl(ucode->code_length);
> > +	if (code_length == 0 || code_length >= INT_MAX / 2) {
> 
> Hi,
> 
> out of curiosity,
> 
> 'code_length' is 'unsigned int'
> 'mcode->code_size' is u32.
> 
> Why not UINT_MAX / 2?

Sorry for not responding earlier.  UINT_MAX / 2 would have worked here.

There was a similar issue in ucode_load() and in that code if you wanted
to use UINT_MAX then you would have had to write something like:

	if (code_length >= (UINT_MAX - 16) / 2)

That is sort of 9th grade algebra level of complicated.  But I've messed
it up basic algebra before and I've seen other people mess up their
integer overflow tests as well.

So I decided it was easier to just use INT_MAX / 2 consistently
everywhere.  The real values are not going to be anywhere near that
high so it doesn't affect runtime at all.

Also while I was writing this patch back in September, I saw someone
had changed one of INT_MAX checks to UINT_MAX.  For no reason at all.
It doesn't affect runtime.  They didn't tell me at all.  I was
unspeakably annoyed and I vowed to hold a grudge about this for all
time.  But unfortunately I forgotten the details so they're essentially
forgiven at this point...

regards,
dan carpenter
