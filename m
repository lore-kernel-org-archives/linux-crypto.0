Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1278CDB482
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Oct 2023 16:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbjJPQxT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Oct 2023 12:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234370AbjJPQxK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2023 12:53:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2475F11281
        for <linux-crypto@vger.kernel.org>; Mon, 16 Oct 2023 09:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697474771; x=1729010771;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VKSWAXTa5ld6zHUdH3YPM+4dPs1xQoH9Q4cSTHYomq4=;
  b=eVYtxOY/Q0lCPSyVZbpTd1K0OShWTQ5yhD3uDjGvedmK1HMfx88bw6lj
   w7HJxg6Ivu6skOCnOGhwQwG49GaKU3p5szjm4zCmakt29CLqPmzJzTCpq
   w721N+ybo1uOkgTHS0eDkbfWv2016JHtPFUmD70/uWOr0fvYoB5+bcIE3
   xTVaInMCIwjGoA7DvLhBr6NgmBGCb/Rl6lVwgr7q97XvO+niYoS+LhNxO
   7hpvYRwjLqzFABhYYpchlqQTKzNdSMF1HzfMfykth7pe6nNdQCx8ibwcJ
   len2EXZfZ2vfWo66xCDQhGDX9phFz6a+neA8IuvWqs3Zwl4Ht7+qeb/M9
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="452055729"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="452055729"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:41:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="929420546"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="929420546"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Oct 2023 09:41:58 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 16 Oct 2023 09:41:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 16 Oct 2023 09:41:57 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 16 Oct 2023 09:41:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fl+gNToixLNqrz8y6SiO3ja7Y8u9raePKKXg24hNrbPgfUfLpkfZHC2KsVJlfLeedgzcgZ95g08uvZmideXBNXhy54w86QB1MYO4mhFpWp9FGv0kfp6WpPoZZC9GyB+6CkPzVkI3oX62dA72USMzRcE4O+gJYk0bHEs4rg89+B7XY4e1l7sju8KkygkPYzAtw2fAxyjDKBLdSyK0feIZZuXYi9DREgOMIZExO2+OfcX3y6o0qIVglhSY9i1sqnGtzmWxPmyWj2pOBeIAn+0SZTO82NlbmgmEbqeIn9AJ6Dr5rpdsWlgjMQk3s8NIHUrGyRxUrCxngZXNPKCu5xHM6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nbOE0AR1V5sMYwAg12OPnOZvg/Ybk3AL6h4R4OdVdWc=;
 b=DqFQuBZfbaNHxA6Bsy3qJnKq4d6c7RTkJ5G7F0lBmuDnAuNL3SsIfmUHnnC1lHfVdOqnY//z+zUxWxYhhR4HEQ9qsa/yKEDl+AtWEAt0oAgsT9o4pmGBuLicImyVVHJyoVnXvLwXrHCJEAomZg/TkIDD/qY+m5nK5+iyABvo6ZK6ILj4f46kzCcl/kuHDbLjJ0uQ7WntzFjWb2UU0FkCU44h5alnJfmtwyHiBWkaqOrc1dzM4orubRfeuETeL2htSCw5XiBROyGsfellmxZGX3q1+iJ2FFr0CWKKpTej4mBWfK23XyRoGdgpyakOkxqHGYk0vBjHYAQUDE5TssqlRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by CH3PR11MB8155.namprd11.prod.outlook.com (2603:10b6:610:164::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Mon, 16 Oct
 2023 16:41:55 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::95aa:def7:9d78:d6c9%4]) with mapi id 15.20.6863.032; Mon, 16 Oct 2023
 16:41:55 +0000
Date:   Mon, 16 Oct 2023 18:41:48 +0200
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     Tero Kristo <tero.kristo@intel.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        qat-linux <qat-linux@intel.com>,
        "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH 08/11] crypto: qat - add rate limiting feature to qat_4xxx
Message-ID: <ZS1nzBes3laXwAW1@dmuszyns-mobl.ger.corp.intel.com>
References: <20231011121934.45255-1-damian.muszynski@intel.com>
 <0dfe871ec970482090680d4fa2423243@DM4PR11MB8129.namprd11.prod.outlook.com>
 <30b7af7e-b3ab-4277-80a4-28bd4cf917d5@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <30b7af7e-b3ab-4277-80a4-28bd4cf917d5@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173,
 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
X-ClientProxiedBy: FR4P281CA0011.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c8::8) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3734:EE_|CH3PR11MB8155:EE_
X-MS-Office365-Filtering-Correlation-Id: fa9cae58-cf01-44a6-24c8-08dbce66ce6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BzTgY6EbbOn69z4ydsd0y/XuPqj6YF8Jb0nJd5VPAxkmzfm92xUpq9dkE38VEuxfmVf0Cbmz5yv4DT6VLq+HOj7Iqb6Bse5hSFpjfoX4M/PLY/0lh4PkwzvNDofAHUDcT16eOwRTpImDOnD85SKwuc8v2+wdI5CM7WyL0VPRI4iqBkIaPT76dXamDMs9qJB3VU1QzhxIKvEMIf7jQ1iF5SD1Cn2fbO7E9Ju1K5ke/Ll1OF04Cnd0ERyvxrG4TzP1ELC34N9/LHoCxJyinsHDVuhJjDVDeNRw9ga2ZyV2HWxw81uNxkOZn969ctltdJ9at5St9yvnFE0zbsMzodW9Xa1cQXSkeyMEa33xyhJ3bo2j6oduuzMaPW+xC7GinsB7qwlzzX6TTM5pgj8lnC1KSDD1UzXPuo4bHXq/ud+ickOCAkpEosqfL5fsxL4suovyzHLLYvJgRQm9EYBBEg72IyilGZl7rtCYcBHLn4gdkx3EkuPfGkrEQJFx6SnGomrpqiZQD2nuzzAqZ1eQUABgLbuuKcfeWYvr0hPROVriU+OKClYNoZiDZJV/ZLvZJy6I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(396003)(376002)(366004)(39860400002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(478600001)(6636002)(316002)(6512007)(6506007)(6486002)(36916002)(6666004)(53546011)(107886003)(54906003)(66946007)(66476007)(66556008)(6862004)(41300700001)(4326008)(44832011)(8936002)(8676002)(38100700002)(26005)(82960400001)(83380400001)(4001150100001)(2906002)(5660300002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8ojYjWE86mkiEvV3aBGToE6juTnVPdd3F9taKMQA1ccraWJdy8q+hYeA90AU?=
 =?us-ascii?Q?0MqvZB9sI25fJEQEU8mQWYviGHDABMXj7Sg+35tCWBwrcTDedUqTaqlYvt7l?=
 =?us-ascii?Q?BrNuTNE8umRyaccm84gI0QgKLv9XvfZEyrUtYaKmCbwoO27VBkTL5xOv9bCG?=
 =?us-ascii?Q?UsPY+Uvaakb2QlyOL9GsvsaQc/B3/f1mjLPLla2lxMEL+BNz81aFNuMBnMg8?=
 =?us-ascii?Q?0Joa3azruw9jhX+vnnJsg6Iq8DDSW5x4ZvmSAqgzN+suv4suZwDkAEpQbpXF?=
 =?us-ascii?Q?8Krv/yADIRQ1u1S2h7TU5Cr5C3kfVrTSKWzFLVBNEi3RofV4e2ihgkWnAqzj?=
 =?us-ascii?Q?gA8TrQO37ylU/22zQcuXQ+I58DwFJ7C2VWMUK4cvPxyfJX6yOLDUsoZd2xK2?=
 =?us-ascii?Q?ulCliaoFr5hc5LPu/1MTpTFh8aeIRaszaRSdn9wg246bFKkMpBWCnyWFOo6E?=
 =?us-ascii?Q?+lYpL2/KO0yIwgCKM49wsv9eam33EsMHTifBGj1WNt4i5aGCHnbQUDPCDuc5?=
 =?us-ascii?Q?PrhLVoPj3lf6nwMoE/shbmsMKqol/OQqAsSYoeK3/5JmSZAn6J8OwCB/+uh5?=
 =?us-ascii?Q?/sveMlp2V2bHx5OhntWKktlz7eRLH4MgW7nsHcoXMrzvObc79vetoakNnXr/?=
 =?us-ascii?Q?/8PbHVrn3/UIZ9hGGItLY6PzKIp5YPJG0atXRpao6scqEVJ2EqkBL4zVcc/h?=
 =?us-ascii?Q?s995C+nyRHB0XwKP/MNCmiBKmBiZanqlGV8OpxOpFQb0NJkqT/9HMNJn2XFb?=
 =?us-ascii?Q?wvP1M9xyYDc9uh9DF3cSButk0k52SL9TZYmWwHhitqSrqeAkpnWNVCWRT/LY?=
 =?us-ascii?Q?YAXKCgEF8rABkKwz0ZbMwL1a9NWw32Cb06NMK4w/VasqK+kILHM66DYj/yu+?=
 =?us-ascii?Q?bN6buVEiQAUaGQepi2xeKKw0JWvehJVYvkrF5irDPIB/ZXt4tG3X+nxQr658?=
 =?us-ascii?Q?GReq/WMBy0E16FCW6TzRTbaZ6xvDyOyWX+IfPc8qMb/Jegu0/yTnnLeaSmVx?=
 =?us-ascii?Q?oOZRhOwFz9wygY7yu1CtOBxkZ2t6EUEY1R9CPxmvRCIFKDsl7FdFTsudUnFe?=
 =?us-ascii?Q?OJRwcNLxKmZbxmzoe4N5IihWyoGWa/D3e5QSmVDYtQq3Au9BJJ8UByPgA2nD?=
 =?us-ascii?Q?iN5rMzU2Jy+Qzi31NxocaHPckNqbofgivWdrGSI4VY+H4x17UYht1dg9QFoo?=
 =?us-ascii?Q?MEzG2l3dImMfoANR/30gTEukiCzSuGCQC1x9vQ73jLpjSjO21n5PzsV9yY4x?=
 =?us-ascii?Q?5wAc1qOKTFVXvf5EBC+xVfB4KWq/sR3BSyZCLS1C0B/LSNEHwYl9QGgxvhMT?=
 =?us-ascii?Q?+UW+6JRb/xJmoDRXwAzIkGCUvSp1du8/y1pKPWZx7vb6i5YhM/bA5T9M1wHS?=
 =?us-ascii?Q?c4DiVbTU9XU4PTWp2Sph0zn85mxmpRIkUMhhjJwwhzrj43gHTBQkNwNXIimy?=
 =?us-ascii?Q?m8ytzcOH0aDRGdSdr0E8CT4mo2wPwYkK21YZus1q5nkh0kskuCC5YrSmCnCx?=
 =?us-ascii?Q?4WB/Q1UcAjBgyX+tnWIJjro4UKdnXIf0zwyIWjv9ULCOZaQ3f9ukAACk0y1U?=
 =?us-ascii?Q?RwjCB+vDnvgSKnRMHShqaHTDzBWnbWfvwtiDd/3dLqjiwu3Htjvl4CuIFLZg?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa9cae58-cf01-44a6-24c8-08dbce66ce6e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 16:41:55.0183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ksO6jNfJF4P1rpXUB+FT6GzPo4Y7RXDbJDTd6W1iyyP4q9BQqASToSkLeiqnKcs2Q/ttAywU0pcMiq6jknXHKYgU0HbuLZhaU645bPvEeS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8155
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2023-10-16 at 13:53:14 +0300, Tero Kristo wrote:
> Hello,
> 
> On 11/10/2023 15:15, Muszynski, Damian wrote:
> > The Rate Limiting (RL) feature allows to control the rate of requests
> > that can be submitted on a ring pair (RP). This allows sharing a QAT
> > device among multiple users while ensuring a guaranteed throughput.

...

> > +static int validate_user_input(struct adf_accel_dev *accel_dev,
> > +			       struct adf_rl_sla_input_data *sla_in,
> > +			       bool is_update)
> > +{
> > +	const unsigned long rp_mask = sla_in->rp_mask;
> > +	size_t rp_mask_size;
> > +	int i, cnt;
> > +
> > +	if (sla_in->sla_id < RL_SLA_EMPTY_ID || sla_in->sla_id >= RL_NODES_CNT_MAX) {
> 
> Should this be <= RL_SLA_EMPTY_ID? Additionally this check seems unnecessary
> as similar check is done in the validate_sla_id() which gets always called
> in the same path where the validate_user_input() is called.

You're right this check can be safely eliminated.

> 
> > +		dev_notice(&GET_DEV(accel_dev), "Wrong SLA ID\n");
> > +		goto ret_inval;
> > +	}
> > +
> > +	if (sla_in->pir < sla_in->cir) {
> > +		dev_notice(&GET_DEV(accel_dev),
> > +			   "PIR must be >= CIR, setting PIR to CIR\n");
> > +		sla_in->pir = sla_in->cir;
> > +	}
> > +
> > +	if (!is_update) {
> > +		cnt = 0;
> > +		rp_mask_size = sizeof(sla_in->rp_mask) * BITS_PER_BYTE;
> > +		for_each_set_bit(i, &rp_mask, rp_mask_size) {
> > +			if (++cnt > RL_RP_CNT_PER_LEAF_MAX) {
> > +				dev_notice(&GET_DEV(accel_dev),
> > +					   "Too many ring pairs selected for this SLA\n");
> > +				goto ret_inval;
> 
> The error gotos seem useless in this function, maybe just directly return
> -EINVAL.

Ok, will change that.

> 
> > +			}
> > +		}
> > +
> > +		if (sla_in->srv >= ADF_SVC_NONE) {
> > +			dev_notice(&GET_DEV(accel_dev),
> > +				   "Wrong service type\n");
> > +			goto ret_inval;
> > +		}
> > +
> > +		if (sla_in->type > RL_LEAF) {
> > +			dev_notice(&GET_DEV(accel_dev),
> > +				   "Wrong node type\n");
> > +			goto ret_inval;
> > +		}
> > +
> > +		if (sla_in->parent_id < RL_PARENT_DEFAULT_ID ||
> > +		    sla_in->parent_id >= RL_NODES_CNT_MAX) {
> > +			dev_notice(&GET_DEV(accel_dev),
> > +				   "Wrong parent ID\n");
> > +			goto ret_inval;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +
> > +ret_inval:
> > +	return -EINVAL;
> > +}
> > +
> > +static int validate_sla_id(struct adf_accel_dev *accel_dev, int sla_id)
> > +{
> > +	struct rl_sla *sla;
> > +
> > +	if (sla_id < 0 || sla_id >= RL_NODES_CNT_MAX)
> > +		goto ret_not_exists;
> > +
> > +	sla = accel_dev->rate_limiting->sla[sla_id];
> > +
> > +	if (!sla)
> > +		goto ret_not_exists;
> > +
> > +	if (sla->type != RL_LEAF) {
> > +		dev_notice(&GET_DEV(accel_dev),
> > +			   "This ID is reserved for internal use\n");
> > +		goto ret_inval;
> 
> Maybe just direct return here.

Done.

...

> > +static void update_budget(struct rl_sla *sla, u32 old_cir, bool is_update)
> > +{
> > +	u32 new_rem;
> > +
> > +	switch (sla->type) {
> > +	case RL_LEAF:
> > +		if (is_update)
> > +			sla->parent->rem_cir += old_cir;
> > +
> > +		sla->parent->rem_cir -= sla->cir;
> > +		sla->rem_cir = 0;
> > +		break;
> > +	case RL_CLUSTER:
> > +		if (is_update) {
> > +			sla->parent->rem_cir += old_cir;
> > +			new_rem = sla->cir - (old_cir - sla->rem_cir);
> > +			sla->rem_cir = new_rem;
> 
> Get rid of new_rem and directly assign.

Ok.

> 
> > +		} else {
> > +			sla->rem_cir = sla->cir;
> > +		}
> > +
> > +		sla->parent->rem_cir -= sla->cir;
> > +		break;
> > +	case RL_ROOT:
> > +		if (is_update) {
> > +			new_rem = sla->cir - (old_cir - sla->rem_cir);
> > +			sla->rem_cir = new_rem;
> 
> Same here. You avoid one local variable that way.

Ok.

...

> > +static int add_new_sla_entry(struct adf_accel_dev *accel_dev,
> > +			     struct adf_rl_sla_input_data *sla_in,
> > +			     struct rl_sla **sla_out)
> > +{
> > +	struct adf_rl *rl_data = accel_dev->rate_limiting;
> > +	struct rl_sla *sla;
> > +	int ret = 0;
> > +
> > +	sla = kzalloc(sizeof(*sla), GFP_KERNEL);
> 
> Why not use devm_kzalloc()? You have access to the device handle.

Our driver allows user to put a device 'down' and 'up'. During that procedure 
many components needs to be unloaded and frees it's memory. This component also 
belongs to that group. So devm_* is pointless here.

...

> > +	if (sla->type == RL_LEAF) {
> > +		ret = prepare_rp_ids(accel_dev, sla, sla_in->rp_mask);
> > +		if (!sla->ring_pairs_cnt || ret) {
> > +			dev_notice(&GET_DEV(accel_dev),
> > +				   "Unable to find ring pairs to assign to the leaf");
> > +			if (!ret)
> > +				ret = -EINVAL;
> > +
> > +			goto ret_err;
> > +		}
> > +	}
> > +
> > +	ret = 0;
> > +
> > +ret_err:
> > +	/* Allocated sla will be freed at the bottom of calling function */
> 
> I would rather recommend you release the sla here if the function fails.

Ok, will add.

...

> > +
> > +		ret = adf_rl_add_sla(accel_dev, &sla_in);
> > +		if (ret)
> > +			goto err_ret;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_ret:
> > +	dev_notice(&GET_DEV(accel_dev),
> > +		   "Initialization of default nodes failed\n");
> 
> dev_notice() here and you also do dev_err() for the exact same reason in the
> callee (adf_rl_start().) You can make this function cleaner by removing the
> dev_notice here, and directly returning in error cases without goto.

Thanks. Will fix that.

...

> > +int adf_rl_remove_sla(struct adf_accel_dev *accel_dev, u32 sla_id)
> > +{
> > +	struct adf_rl *rl_data = accel_dev->rate_limiting;
> > +	struct rl_sla *sla;
> > +	int ret;
> > +
> > +	ret = validate_sla_id(accel_dev, sla_id);
> > +	if (ret)
> > +		return ret;
> > +
> > +	sla = rl_data->sla[sla_id];
> > +
> > +	if (sla->type < RL_LEAF && sla->rem_cir != sla->cir) {
> > +		dev_notice(&GET_DEV(accel_dev),
> > +			   "To remove parent SLA all its children must be removed first");
> > +		return -EINVAL;
> > +	}
> 
> Mutex is not protecting the above portion of code, which means you can call
> clear_sla() with identical pointer value multiple times.

Thanks. Will fix that.

> > +
> > +	mutex_lock(&rl_data->rl_lock);
> > +	clear_sla(rl_data, sla);
> > +	mutex_unlock(&rl_data->rl_lock);
> > +
> > +	return 0;
> > +}

...

> > +	rl = kzalloc(sizeof(*rl), GFP_KERNEL);
> 
> devm_kzalloc()?

No, explanation above.

...


> > +int adf_rl_send_admin_init_msg(struct adf_accel_dev *accel_dev,
> > +			       struct rl_slice_cnt *slices_int)
> > +{
> > +	struct icp_qat_fw_init_admin_slice_cnt slices_resp = { };
> > +	int ret;
> > +
> > +	ret = adf_send_admin_rl_init(accel_dev, &slices_resp);
> > +	if (ret) > +		goto err_ret;
> 
> Just return ret.

Ok.


---
Damian Muszynski
