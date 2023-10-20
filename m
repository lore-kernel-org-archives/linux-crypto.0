Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29289C001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 12:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377017AbjJTM6s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 08:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376956AbjJTM6r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 08:58:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FBCD52
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 05:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697806725; x=1729342725;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kd7noH5TB7+domL9BYZNrEHvUC0E6BH1W3wEkqHrr+g=;
  b=b64qUg/bR/ac63+7Qe0MJ93yyObv4dRicUBJiFUmTXTGCfrP0+Q7svNH
   CiLq1JRdNcR6ouOM6YmCVjMnKNr4EwHmZaEA3mwSjIhjysICLAZ5jE0FH
   wjC/hob82jeLqX/UWZQo4nVlPyj/boghyyad4EWcM0VI7Cqf+CvR3Q/PR
   VFjpSL68S2sYQqzoXwvfCU37kuuMOijLLX9s3a2EFNo39NIF+WBusDTqY
   FbFY0kRtz0roXmaXP7uFWfQOPRmgjgmi7Z8/bCEXhfXccRyXpBdZ08NVx
   Tmx5FJGWtnOcYe9KXH+Iz5hB3ZUVocRKghcyPofJbWcj6fUIvc2SL4pb+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="450717171"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="450717171"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 05:58:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="750907152"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="750907152"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 05:58:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 05:58:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 05:58:44 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 05:58:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7n3otIEYMoIgncasWU299UjAzsll6O4DeGbm6HObjCHNp+su+y0ZV6bbD6tGyAN8zvPjqcF5L8GxFviT/AwC5laEmWJ55OEdbNAI6G1hYAgkOwMIIxv1XBUpc+HFLa7uadCNlQxGQgweOHU84xMyxST/3+sk5ac5fkF0PnmbueCFsabNsqKVsDKCg72n3+XsUV9hbC1DL19m5QJhLavJn+Tvye9wmnq5oX762vCf2KfZOa+cJgjjJI4uHrpb9hqZVkjyYfYD4YcowFeshSClMghrT8BL0/Sc+4CwWFcy8h7czauehZ1B+MWPekoXAR1iiUtQHWr/SVEFSMnowVhxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skxSRBk78wTRO1JsBHM8SbE/y+5p86r8FMetX3bFuz4=;
 b=IXbNqf2n/ZI7Cz3JtK3jF+bHpl37oos1cugBnCmREx7hzicniikRRCY3hGnU6uGeEPpc79RRIr94sqIiZowJgpzkeJHz0E24BrOy80mnvrOCUy4ybcpy1qfS3tQm8OpE01c1DNgb2Ns8Nw5dcr36qzbxXTZ1nAjOExGcLJKW6+cB7E2hfcypu3zGJ2szm0hwyGLvHiQR9YNyUTmmOTFVbFsQBTQPXx+JHEnDbhvDthJrVWIqYTWHeEOle0AFlciFbB0CeCOuE1OkUqFzSeDaqYX8RqHi/v+co5lCh8HPzafhf0eovjwiOGJV/p6JR9DY9pF5Lt/TLtDZWPv+VF5mQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SA0PR11MB4717.namprd11.prod.outlook.com (2603:10b6:806:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 12:58:43 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::8593:7da:ec34:29a3]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::8593:7da:ec34:29a3%4]) with mapi id 15.20.6886.034; Fri, 20 Oct 2023
 12:58:42 +0000
Date:   Fri, 20 Oct 2023 13:58:38 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Mikulas Patocka <mpatocka@redhat.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>
Subject: Re: [RFC PATCH] crypto: de-prioritize QAT
Message-ID: <ZTJ5fngubmYWgt8r@gcabiddu-mobl1.ger.corp.intel.com>
References: <0171515-7267-624-5a22-238af829698f@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0171515-7267-624-5a22-238af829698f@redhat.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2PR04CA0298.eurprd04.prod.outlook.com
 (2603:10a6:10:28c::33) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SA0PR11MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: 9eb9c1cf-27e1-4055-446f-08dbd16c49b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RrWEu+bAhVn2fgb+XzsVn2gd/UYPrMAx2YXuQN92RdklabIa4/XG+Aw18seh42MWaS1sb7ZkW7hpb1DxqmyQGWdHFcG8svjBKMGnpPMJ53AHH3Pnyez6zUGDRM/ygNGHLZPy+0VCDq0TLWx5ajkgeu6pwajfG5Bu1gykZKubKiqlvuBHT4UgzKxozqoG2ds370uPKTXEelXs8twhvYrgX090jNj/Q95b1XJPXwJ0D4GDSp/ct9TA05+z8VdL0PANpJcKzGAF4RUBg3dE/udrcnf6FClfaQUhz01bjYoRogcbmUzPTpAny+bFi44mtJcbMQRJ6ahOBL7/B1XdpDbYdZbHiALsW/bgTalQl7pT4t3Pt7zDwB0kWRdpEG6F5IOmbQVuApDzrC2+AVeUmnQLQCnPgirPf1QBjjwgCptFIVlkbGa1tOaBi8N8ZUlg8pXA+MPY3FBa/9pSepM6pqCwg0tVzWOCEbW88aZ6EWYit2hL+S1sGYOhc6fN5HSKA3FnZDa7rw9q0loYO0UMaKM5eU0D7CoA0xwec8cADoIvZIw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(396003)(136003)(346002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(478600001)(4326008)(966005)(6486002)(2906002)(82960400001)(44832011)(8676002)(8936002)(38100700002)(5660300002)(41300700001)(86362001)(316002)(6916009)(54906003)(66476007)(66556008)(66946007)(107886003)(6506007)(6512007)(6666004)(36916002)(83380400001)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0VdRQddUYEbl36TrJ9O+q3YSzPSwtRgHoZz2488h9kjgA0Fl/n5INKusDN0b?=
 =?us-ascii?Q?IfLU0rL8dfuudtdcPzN9KfPBilmM4HTpMGRSOuLfMp7vJvaXugUMGSs0QIDF?=
 =?us-ascii?Q?VB97znVBroCjUnmKnEDUq0E9+yhi4R+qRt3jdyFp6JvaQqlylW6rJR72vkBG?=
 =?us-ascii?Q?diJIvSQEf9/BxivALy8viIgJxY01Ic3l1Jc+r5/ncUPyOvNNB9JJvu+266GZ?=
 =?us-ascii?Q?CvrOUpE2PyIbBU3kzL2tM4bPHyT3tOkOEfRU3V+ZL+okXsd/pboCzY2v3bF+?=
 =?us-ascii?Q?DSf5ja1PicH1j3JXQWYU7U7LjoynYUlBk3r5lnQocDuEkndxDKBEukDcpHUP?=
 =?us-ascii?Q?1zgcgJ131oNvTX0vwYUvv3nkk3cTqtk+IU04gTAQu8S6799ou//O7nl5Q7ub?=
 =?us-ascii?Q?pI7cFKKdh96O5r3eUzdml3tzU9L5xPJRoQLGE+o72B4vRkTXNej3jLnrnv0C?=
 =?us-ascii?Q?zx7BCEz4HLG5S51cy+AnvKQuHCaEia6YgeY6RxMS21k+MRGWmqfDWUVam+Up?=
 =?us-ascii?Q?EDcL+2dDdwA87XADQ2jatBCJFq5hK3fIa+eDQiiB0iQqwju6iuMbK0sDPqCX?=
 =?us-ascii?Q?U8cnHz4sL5yAo9s2qUVZwt+TS0+XiUJ1NN9xteq3XPGqsyB6b4jDtb3aORLi?=
 =?us-ascii?Q?5gVrH2mCg3NS/K+d6F17q6NauXnoyFjko/J9vPGG21f9nNqWqmvqgdHKdTXT?=
 =?us-ascii?Q?XYHsewaoBoMlRNSwSduMDfn5Lg56kbQp3Ln8EuDPnkRf62Um1iGIPphLod3v?=
 =?us-ascii?Q?FdWfadVfM7PXOjKohNjU+jBcsREmq0G5s8Zqpb2PPtqCYTd+ipQIk7sZPfKX?=
 =?us-ascii?Q?y1km+Be/GtpsfuG/EOChlkNX0pKXMJG5WV6F9cwF+QLtU+RVNUFGTc/DqOLW?=
 =?us-ascii?Q?Zl920G5EaWF6qC4s9m9hdnqmltB9OG5LPOBK+bACaulvlQAeCqtQ0sZ6uu+p?=
 =?us-ascii?Q?vZBvQCmp4SXG5RH5ZwWb0B+voPZZZjCKzdNXnz73qxDVYm7SOzvE7Ic7K7NK?=
 =?us-ascii?Q?qrC4bN9YPCuJX+rBOvi8TAbycwHZ5ZdK6fxnhNXeiLN8wvPSS3pfDlQ0jDDQ?=
 =?us-ascii?Q?YU5KTQEEXyIas9P9TQAEtAzCxOdxatPBZKPhFo42Uu7QkcAitlsht+IcO1Vt?=
 =?us-ascii?Q?mfWhe+RcCSrM/7cziUecdn11p+5c4w+LQVNlZIfToRpycl3or6quYTxaPf8l?=
 =?us-ascii?Q?SFrtyvD8dqSxhN6J6VYbM2PkMPk3NZ3Y3Pb/qQkPt4Kh+qU9Jm0Vq/7kVQ1s?=
 =?us-ascii?Q?a9Xr+8+BwZhsnMBSFt/oMtFVvGuURrNorCQnMXqO7xDAVw+ln7ssYVfMR/7I?=
 =?us-ascii?Q?VlLgA4lubLyfPSqaYjy7GVUn4GDGhf+ROY6FssI7YQnDwKjrdC0mxVUG3YwC?=
 =?us-ascii?Q?wxW65J5rxCOXVnpg2sTspZ/dVg2OS+Ti9nLPM5lbbodn9rm0OpncaWHOSCpx?=
 =?us-ascii?Q?BPhHqdrWpq9ynq9Vop4awYlqZv76KWgPqPB6CqQTHt5qvJafyl8ilEP0P6a3?=
 =?us-ascii?Q?EVkHU6U/VAnn+ek4tHk95boP58wHiucpF+OZcpVJiVq+cw0polxtt6WY3PDH?=
 =?us-ascii?Q?5yiJPGioz7GsDZ7fxYSO0fuSbYAEHLa1j29XyjGl2b1UKfBh9Cq+JfAgIspU?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb9c1cf-27e1-4055-446f-08dbd16c49b2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 12:58:42.8247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Es7V4/tdECHe97+cjD9HoXGQNUPeMOq5TQ8cwcsWyQo1l6GirSoh53GcGxp89wA7pUPjf2Q/3cnffn0LDUmG80rghmjux1oDl24FGqxzXHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4717
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 16, 2023 at 01:26:47PM +0200, Mikulas Patocka wrote:
> Hi
> 
> I created this kernel module that stress-tests the crypto API:
> https://people.redhat.com/~mpatocka/benchmarks/qat/tools/module-multithreaded.c
> 
> It shows that QAT underperforms significantly compared to AES-NI (for 
> large requests it is 10 times slower; for small requests it is even worse) 
> - see the second table in this document: 
> https://people.redhat.com/~mpatocka/benchmarks/qat/kernel-module.txt
> 
> QAT has higher priority than AES-NI, so the kernel prefers it (it is not 
> used for dm-crypt because it has the flag "CRYPTO_ALG_ALLOCATES_MEMORY", 
> but it is preferred over AES-NI in other cases).
Probably you can get better performance by modifying your configuration
and test.
From your test application I can infer that you are using a single QAT
device. The driver allocates a ring pair per TFM and it loads balances
allocations between devices.
In addition, jobs are submitted synchronously. This way the cost of
offload is not amortised between requests.

Regards,

-- 
Giovanni
