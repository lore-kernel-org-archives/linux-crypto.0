Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89895C64EC4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Mar 2023 11:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjCILKp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Mar 2023 06:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbjCILKY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2023 06:10:24 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3759E9F24
        for <linux-crypto@vger.kernel.org>; Thu,  9 Mar 2023 03:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678359883; x=1709895883;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7GLbRmoH4/tbbXBbe4xb/Nke/wNgYmiyJk9xsVEOJ34=;
  b=JLT/mktQX6xz2pZR1D8EIXBYL7Sq7CzJdJlUe+Ic7EhtR8h85H5ZYNQK
   flB1LikbVLYC+qtRoOWK6Y9i7h2TxTRdR85lngR/ThzJD/vfZIxGpEfYF
   8zWEYeYGd+JUrWlk8oKeQeORRjBgQsmSKlUehAppNbY9O2Y5Mm0dqalGK
   7QvwmTQx//kLtOM0vhm1ERU1o0iBFA/uEpZmtTQ+jYm2I0NlIFlzKUXUA
   Bxz9Wifeyl1EThzZ2RoWvuLWH7K784yeuHawQs/TCI1USN+9Kpzic/OCU
   CYblU0RaOGM4Ly1DgpgQ7tuu1K2Slgsv3lNs6KBfLgw6dhDPn19QfNhVs
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="338755274"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="338755274"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 03:04:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="707573019"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="707573019"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 09 Mar 2023 03:04:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 03:04:33 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 03:04:33 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 03:04:33 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 03:04:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JMyM6xm4OB5TXEI02O8z7tN6v1fLicfkgpWdz2z7V3i/MsKjBy/ybiTo+sddTzVAFKjRTWqFJtLPwTl2Ma8wJdmMK7cwy0GDl5+bQgD9m1//4Rx7pc22RHheTuuVyqkZTbj+mKh5s6UhAHJnKxc4UCiOtAMYXvplE0MtKOZyRfSfE7RzPVc713qzpJBUd2m2Vocr/djT1oMU/oswYSYybxrXbtFuJiRPmK4McdkwVKlq3aOgnOu8HyVqO3/ZVcNPOQToXyOoWTWz2I8xJ3wT8bHz/d0wyOpjrw+IrcoeHimf6477Liy0WbJcZ+TBN9cTQFTwVOyO18KohdpfY709HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IWQ/Lg+mWPivTYQwlRNq4gWkdjxIyTeiEiq9g+VQ17k=;
 b=hZH7qNkjfTulXA83PciVR4ib+7Sr5QiknBegnUadXnDWkmMdNoJuapiumCd9yfsLVIfsPAgD9H9BHEFkAa0jG6h+T8i9LRGycypPyILLq565GE3mmpt5RDLesbNnkeTO9yXoZN8I5mjqsvXmpGD0vH1drtx9BDpLBwQyPCZonBMdJ8byyfoaPxbEIaZzukieOV5s0Ny0EAXUGD7eULGMukSq7nfOuLKWEQIT1iHUCXo5HCJhA8KNtvu69Qgtpl3ffjsE2W4+lWr43Aw3SkzcIxVda74DpAM68t/nk/evREyZ8gyQDYOckLvxvt5S8vjGk89lW8EsAUlQnpp9xZJmjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by PH7PR11MB6979.namprd11.prod.outlook.com (2603:10b6:510:207::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 11:04:30 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::bf91:c1f1:da12:9cf]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::bf91:c1f1:da12:9cf%3]) with mapi id 15.20.6178.018; Thu, 9 Mar 2023
 11:04:30 +0000
Date:   Thu, 9 Mar 2023 11:04:18 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Meadhbh Fitzpatrick <meadhbh.fitzpatrick@intel.com>,
        <linux-crypto@vger.kernel.org>,
        Damian Muszynski <damian.muszynski@intel.com>
Subject: Re: [PATCH] crypto: qat - change size of status variable
Message-ID: <ZAm9MpyFnU1q2pmc@gcabiddu-mobl1.ger.corp.intel.com>
References: <20230309113306.4008-1-meadhbh.fitzpatrick@intel.com>
 <ZAm3cSjNderM7gzn@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZAm3cSjNderM7gzn@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO4P265CA0277.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::8) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|PH7PR11MB6979:EE_
X-MS-Office365-Filtering-Correlation-Id: bdd186e1-5fd3-4122-ddb5-08db208e0e71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eZ0S4DpD07nRwDwJT6C1fx/uxZFQ00pmZhabLRc9qxiR8fEPAInAV+a8+uHTMQtZV2P+t57ZcCzccO/RR6mvpuCFezFmFgj7mPGnRlC+oud1Fc6e2sC3jjo1+4zhgR9hVAeugCpS0O9yQDFP5HPGn2BVP+jRkgjI7WLMpaG78MzAno/hQ/++r6tJM/lzrF+0sGCM9gQAvhcjfGgNaoabboi/XU3JLFTZgJJCC319nvQ6hfHVjjVh6VGUi+kR9UDpkXxEcAwxJZjYe/hUHLlUe/PAB4YyGUMYR+jPvHuHwXlPLltqPwZht72uyHHn/AWafmqi6RV6lkJJ5NlweSXta5N0pDrsbfByxMk713tdJAqwr8CEhgIpkoniNx9/IPMlEz91jRTiQaLJiTZBQ22eG0P/bjXFaueGIHONk7A5ANApWuJ0iVmkB5gL4k3Ur/0ZoH83GgamX8UkJFRY7ZgVc0I2y1/B+r7y+QXX2cm9R0F7FDYZ8lpvEcJlhTGx9K3+dkuZmNWx1HXDhRDBvWdfXkAm+b9yYhvdamgGqCQOIGklBU+kavCKpfhxijFfd71kI05VxSMBYMVnnJ8bwYZ9CHOUQlgc71juw3hsNRLsIGomvcjkiMEMi6OcpiZx5VGE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199018)(478600001)(186003)(54906003)(38100700002)(82960400001)(66556008)(66476007)(36916002)(44832011)(66946007)(4326008)(8676002)(6916009)(26005)(6512007)(2906002)(6506007)(6666004)(5660300002)(107886003)(316002)(6486002)(966005)(41300700001)(8936002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u5Sb7zMSyLx+cL1uagcOMEQONrXx660cgHS3MkihibBJaPC/pBMMVq5dH9W9?=
 =?us-ascii?Q?3lsVSmFNtXlHIMg7pNLlo6+fFVoEcv03W+UjvyoHCOZVyNz0MI1QyPrEqQ3p?=
 =?us-ascii?Q?C2ND6A8hHergV7zYvYEVFZ2vN6W+t3hDf1UwSoEVPgah+R+Ur9fmfBDdWbaX?=
 =?us-ascii?Q?VhFZD5v9HxmVWlFE/SdZ+/mWIMo6VuyebLSG0k0VM9yd7cgrV5H9A48OqiFZ?=
 =?us-ascii?Q?MfXzI4z/PvmOQqI9xjoqDF7ocpdXGdUAdBCzhidxBrpNvzHkIx/Bk2t5oW72?=
 =?us-ascii?Q?+N25f/XQBUoYrkxgfkyXejyhGY2l6YvtGGwoJlHTldzeQr9ZWwh8VCEFfyg2?=
 =?us-ascii?Q?AUQlwz2C1HCx2WHnpppvaXL1fcLxAR1i16YIKQHmEkTrdfBvfTMA4dk2Eltz?=
 =?us-ascii?Q?e+hpS2PW1SSa5xuoTdqOfvYoWaVBsyZUqP3Krt4v31kZ+ZISBCF6mZO2f60B?=
 =?us-ascii?Q?4wOzYBC8R9ufwfg++MQCaiSt21ak/AG05nhlTur2jVEkZpLV9JRjUlvD2Yjm?=
 =?us-ascii?Q?lfrMf+uosmG6nHnOUCA1ToSj+pDCztDc5gxiROUKftaYUR2lLVmSxbhFghoM?=
 =?us-ascii?Q?czskkjOdc7yPK9g6l2VeetNwWcOp+OWsSEGTEDSHXB6JWufTzvgAcbvk2aTC?=
 =?us-ascii?Q?e05FWaF9UhcadGWfZF4Bzo/tgX5v1wkv/r/c9umApwt6sp0wS3uAJzcxOXhc?=
 =?us-ascii?Q?gz/JcH8QXTV3ITisnq5j+gs3LPyARMxyA3C6bbvRFIrW2+F5cFpiCaZJ6H7r?=
 =?us-ascii?Q?LDgmawqrYY+pk5GaV1oYS92jjQQJu6wPwlak+htV1lxWIDglPniiG1eX7EU1?=
 =?us-ascii?Q?I20BppKRRaHGXJfAJ591E1CP7rsuISoJEKHR/ucJKnMJl0mn1VAtdI7eHZUA?=
 =?us-ascii?Q?cFQZM6Y9ahc0QKgvWAjt8s/rKw6LxNLyP7c4AK6bUtfuNffDV4FV6MyEGsLd?=
 =?us-ascii?Q?giV8QgFdMX+k1awZVRFMiQco9rUXb1tgNMz2+nzdwHCLEEBthgYZV2WUfJX5?=
 =?us-ascii?Q?8rBaC4zqcAW5eHF4oxbpz0o9ViyliLO7x8wWYUOuuSF6fNDfTHpR1+GWpaeX?=
 =?us-ascii?Q?P+6fEO78fxvHj/YgPx/n3HHE6j8F6opAuaxB1deGmbGvH3pB4Ipa6aAWrf0F?=
 =?us-ascii?Q?7/avGa4unIZMXBPayY7JC0UZaRP3YLY1WCEXaQ7PWL43G8IKlAs8gW5Di2Jo?=
 =?us-ascii?Q?+9l3F5oh3727/OcVf68Si1rnKgBTilZJpZjKS8pNeBDTqf1FKeBpr8E1fUGq?=
 =?us-ascii?Q?WQCpctOT1MHrA7EKDej4NKRHBr+ZVh5FvkTflpTG7uD6c+UlxbjCziEZQhFo?=
 =?us-ascii?Q?redqqASVIvc8ejPqW6GTb4TXqjug1xwzxSyFiV1PBg/2Gngyi7+7vSpxshd8?=
 =?us-ascii?Q?dpT53A6iz9D658QAkjd2QNq/yCBt62qm0dToF510rhsS2AFEMfozel53jtxd?=
 =?us-ascii?Q?ZgGAmRfKlu99jbrGxGVcluMyo+Aw6JIP+Vt4LvKPkZGtgQ23cCHfJT/puZeY?=
 =?us-ascii?Q?i4+hYXQPXLoJNp/qitu4WUdReUXylqZqYov50NdYk2g4JkimHkcRbrJObvT9?=
 =?us-ascii?Q?HscrUi9dbsRIQDIobSzIX3RhoZmyMIM5v564dUKq5acDqMQ3OZEVf2u91QzF?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bdd186e1-5fd3-4122-ddb5-08db208e0e71
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 11:04:30.4720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5IFxpurhRiHft/7BcKle+yZk51RQBzVuBL8nK8f4RwECrf5Bgej3VffnOnEZ80ofBA0lZyMiSyFOmdvSBt9fsPkuTR1jh7DW1E8V+9s5+qs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6979
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 09, 2023 at 06:39:45PM +0800, Herbert Xu wrote:
> On Thu, Mar 09, 2023 at 11:33:06AM +0000, Meadhbh Fitzpatrick wrote:
> > 
> > diff --git a/drivers/crypto/qat/qat_common/qat_comp_algs.c b/drivers/crypto/qat/qat_common/qat_comp_algs.c
> > index b533984906ec..726b71d2a4a8 100644
> > --- a/drivers/crypto/qat/qat_common/qat_comp_algs.c
> > +++ b/drivers/crypto/qat/qat_common/qat_comp_algs.c
> > @@ -183,7 +183,7 @@ static void qat_comp_generic_callback(struct qat_compression_req *qat_req,
> >  	int consumed, produced;
> >  	s8 cmp_err, xlt_err;
> >  	int res = -EBADMSG;
> > -	int status;
> > +	s8 status;
> 
> Sorry, but this makes no sense.  Why are these s8's to begin
> with? It doesn't look like you even allow negative values.
You are right. Thanks for spotting this.
When reviewing it I mixed up the cmp_err and xlt_err with the status which
is a u8.

The functions qat_comp_get_cmp_status() and qat_comp_get_xlt_status()
should be changed to return an u8 as the field returned by the firmware
is an unsigned byte [1].

The `status` variable in qat_comp_generic_callback() can be changed to s8
or stay as int. It is just used to check if a value is set.

...
    if (unlikely(status != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
            goto end;
...

where ICP_QAT_FW_COMN_STATUS_FLAG_OK is 0.

[1] https://elixir.bootlin.com/linux/v6.3-rc1/source/drivers/crypto/qat/qat_common/icp_qat_fw.h#L104

Regards,

-- 
Giovanni
