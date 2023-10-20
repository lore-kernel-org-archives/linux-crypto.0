Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5512C001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 13:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377411AbjJTNDC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 09:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377332AbjJTNDB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 09:03:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1873D67
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 06:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697806979; x=1729342979;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=aZZ5W+HnAqNd+o9+ZbW7eCJGgB7QhJERIKCtHOWZwwc=;
  b=C6cWOxd0QIP7LFSNh1qv+WlzgtEgpPFfcrAZ2oAW7qEVGLDRE5lQY4Eq
   h7Wh/9zxQsaB29+5QJozqQ3+Y2t0z+g2gszvZ0HCvlfObkf80UlO2CYGc
   k76rF6okvXJwzLiaMvLTXa9/f7sQFoKzC1Ci28kDJsBysBZXqnT1htZlY
   eXQZfJ46SjE1YLJMDK3B3QIe7UTSM9rsR6nKH23TbebyTbz4Ys429s+LQ
   akRfptQ5vyJv/crk19azCIoj8pJkC3HyX2jRYxs8Gy6dOh1yQRxJ1nfOl
   v6WyT/VW6EwXSY/HUuma9RoSvgurbhy+1TcBth8BioFPkIMMN/5uv4XkT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="385368952"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="385368952"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 06:02:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="848073422"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="848073422"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2023 06:02:52 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:02:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 20 Oct 2023 06:02:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 20 Oct 2023 06:02:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 20 Oct 2023 06:02:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTzPMXqZ4JDq3Og5n4lhrTpqzOAuYyhU17ngaC+GKo17sgwavYfuSMNoEJkuiIX3bY0uCzRWtQvCzS8JnoCeI0uxIAJH4DEP2XwVm2GYGxxPJYxYIiryWtwZSPx3+xIuV0mNal0UBEhmP0TlwRIa4GZ9nB8HQ1pHq1YfNbhcgbPJqRetx4hdzu5aasdhxgiDyzCebKDMzrg3YsiicK2wEZ4jFnVoSSMo6QQImyOzTqu0In7WXpKeM2pD9TtEqbYaHEPs8BeNNbuLCuU3Z/2XurtL1uS5tkpVf+EWMucurm54bcfEx4XnJqaYno2hh9nCBHEod50YsRgFNX0gu3Irsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JdgtMcvNFi9V3sRqHc10568dw/5GvZZvGIItsddISTU=;
 b=ZpwCst+BuX5MPnVgizL0lVW7COy1Dry8Yc0DGVLZy5JLKm6zg8c74abf4a8lWooQoqdRRz/miZSCVgnKfTPeUypK2HDilMresHfFysiMxY7DhrEo2/6E33YrHft32uLR/hQQcuvIqRhPEh2kG/yFd4fL411jQfy5qXUf5HsdOl5ozMG3bERZBH2Z8V6020ReM/JvGd4KDY7KM5Y1YgNdC1K1F7OsZR3rmPMcwOhmWZkDH6LKMgMCIQSS3hBAd8qn2StNgimLF5C9LmT1vakHoF8653UIHVcJZ1SYkrpUq1NqDY9lcekg0qMbUtA2wZ0keIzEvPrMtlq99d1iBzp9DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SA0PR11MB4717.namprd11.prod.outlook.com (2603:10b6:806:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 13:02:50 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::8593:7da:ec34:29a3]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::8593:7da:ec34:29a3%4]) with mapi id 15.20.6886.034; Fri, 20 Oct 2023
 13:02:49 +0000
Date:   Fri, 20 Oct 2023 14:02:45 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Damian Muszynski <damian.muszynski@intel.com>,
        <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>
Subject: Re: [PATCH 00/11] crypto: qat - add rate limiting feature to qat_4xxx
Message-ID: <ZTJ6dQcPbrGDBUNU@gcabiddu-mobl1.ger.corp.intel.com>
References: <20231011121934.45255-1-damian.muszynski@intel.com>
 <ZTIPpMdWOWBuHAmM@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZTIPpMdWOWBuHAmM@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0314.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4ba::21) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SA0PR11MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: cd9e0660-fd51-476f-9893-08dbd16cdce7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VvC+yhlYDTPBksTeaHq/QOmCBb+khmzB6y5XQqPadZRB42U+QoFkUsq+WZTEGZT2qz9ZPWhtld9KQPSKnAeFViBpbyeWme7UxGQl3/NApb94gkL6AJ9lgPV/3c2kBr34E6aqHhuV8/forzDJmb+tu5VvCL/oSCy6c7i5Sqi/DZrRKn3WcOGhFYxEHRR1MdOz1GkpgjF0fmtiMOSe++4hzwJfX2gthdtR+ony8kYEs3Tzh0Ve1JS8KmQ/2mXQ04+kzvUDt51zzWOfiNtxKeBGMpNGRcVuKsIuCMxtJ6MQRGDja2jegpvt+grWxc3YQSrw0slvVhnWhyo+1CF2Hp/yvbKt7s8j7ojXWo5ECU9QbcfG19l5kgGST6bv9tFxziAIZW1cWXVUFvEtzSTQPKKWmeoe6PWrXkE2cV3Wfcle9aReK+7JaCev1gBArAPunWLSI6923wywU0xwdFXml0jOYbNxQYsOjx2vr+C65lu5M8U6gc7wYwF2lC9AE30gTYuTBBPGAB3ELQ+Hi4Sq/jkT1KYGfhXvHc19p7Egx5q1LqKkS4eZ1TeJ03V/ap48wOOA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(396003)(136003)(346002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(478600001)(4326008)(6486002)(2906002)(82960400001)(44832011)(8676002)(8936002)(38100700002)(5660300002)(41300700001)(86362001)(316002)(6916009)(66476007)(66556008)(66946007)(107886003)(6506007)(6512007)(6666004)(36916002)(83380400001)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q0SvpOdb2pFMJXqIZW7z25ZOJbDdevvWZc7no3fO88HYiijTbCpzdNg9NmrY?=
 =?us-ascii?Q?RWzJmUjKuyF2pGGjPMjXfSj4VaS7Fj+v0xIh7agyPZPsLSqYHL3Pmzi0wgGw?=
 =?us-ascii?Q?2sc28K7pa4SDNVPLKK64IroHbMcHpyZfcG6lpwITyDZJ2hOxcUCnpkwN5Ert?=
 =?us-ascii?Q?8UvgpLbhB/UOJT8oP6OhRl7X0/UekqEMo7D0btQfZ+uTsyhdEn3QypRWcuwZ?=
 =?us-ascii?Q?ya6qimCLC0QqfJNtbQKQl/YchxLW1TJwS6PalPdsz/U5uki3kHEG8dVu9hWa?=
 =?us-ascii?Q?S0BlOowxYpm/6hMNPfIkBNU3FDbf1GWM4MG2Sl5R+npoSTdmdf5pKfMLTWo0?=
 =?us-ascii?Q?ALjAdErMtc8HxP/hCOZFc+hIqmYI2cVWwZ6XoAE0RS4G6H+sS5/zxprGxDJi?=
 =?us-ascii?Q?lSeL03WVdDCW/VG22HAXLMIrODIicmXZdvMg9H0PEaNk16thLQDC4/LygFbs?=
 =?us-ascii?Q?aIZSVDs5MBEWaq+/8Ko0qGnFxBiHamd/2DPcUY/2VDlb5PPx/eTF3dIxvIWx?=
 =?us-ascii?Q?QS2LYj8O7b2AxE7kITUb0y4Aq0KGxV1/9xBgCywZ391rEX5xZWymOFmQuDhB?=
 =?us-ascii?Q?nXri0DZLLheaDVfUmvDxRNU6S6I4IEtVrxWX0CqEipJn566yT0/1kIDiwt/D?=
 =?us-ascii?Q?Z1K6B9dVzgbnE+Qd1W+NS2viGyVsPsEztXvskjs3/W5EQTSzXrTLOktgpLF8?=
 =?us-ascii?Q?6NNFUA7QlyXNRz8GIP5By+4nyXzvaohSMGtCB/qsMDMbw8VNRsd+AV2hIkzx?=
 =?us-ascii?Q?3G6Qll1Pa4B9+N8VER8avR5ofwKH1XkGf/zmTS7hQBgyIewePNZhek2UQwRn?=
 =?us-ascii?Q?ryryNMjNkG2g5zw7FKsdlOB0YGVwUvTFvvtrWbnMq0a31z4MHQXFZ9w8cTFk?=
 =?us-ascii?Q?8255SFHxFczp2tFRqhWcYwTSGf0hf2xfi8Jcv4zHEYFN8wqkuUb4ayjnETl8?=
 =?us-ascii?Q?Bdr8g+ksyWxWP2X+K1X9zmUyeuYWgrjXzs2fOnKDLunIP5rRG3BNTFet0oMe?=
 =?us-ascii?Q?26UBmpzkwTjABdQJ1OBE7ni6nDEJ5KOj5uJfiuaV7JnOM+Uak/LyNpv0XSoR?=
 =?us-ascii?Q?ThEaRq7bUz8CKsMcYr3unBv0Q8l9UHWBYGp3JRHqvpmOIFnAPEdsW0mWiiAF?=
 =?us-ascii?Q?8bsL6dxwDNxZjuMoKHhfNnWxb6uBjLVFc2iVovPAh0DBNIASMyzBpd511eoC?=
 =?us-ascii?Q?FkeR2KnVTLIVGSS+SvHhxauKnYQB+swSDLbcwqe4rLNYaFChMa0N7T6qEPBs?=
 =?us-ascii?Q?nK1GNB900gcWFtaIXjHt49urorurxXCblYCrjst9z2hrME8QKDbdxg+RFcuv?=
 =?us-ascii?Q?RjwthhLi3IrEfMKIGWT8a1d7OkUx1RKcBAhL6qNxdifEU2IqQJsZCUmBgeq6?=
 =?us-ascii?Q?OvT2XuzJkvqkjshS+uYdiuGc58orPLdlhxwIqIwrfgH0TST+UxVfaPD4sv2m?=
 =?us-ascii?Q?Koe9/qYdnrkKsLulz3m5mkZPqZ29Ymjpolq0KS+W+/dEhXRpc8UJy+hKVTU5?=
 =?us-ascii?Q?g+RrG1nOPbZV1kmoM3ZObNWNoXK7f2JaiveK8so1in84jHGgb7L6aCU89l8F?=
 =?us-ascii?Q?v+79r/80MhzC3VJ5vBxIIkaV4UWeDjH6D886DOWMmZOeaHGlVQTtVXbER+oG?=
 =?us-ascii?Q?Hw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd9e0660-fd51-476f-9893-08dbd16cdce7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 13:02:49.7147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TReROGK3qbUWtrolSk2LF8Y0pj6StJ2F8/EIRIRXQm2I2SsUTKSAZzrZIlIG3Px1P6Z7VocWdY4OpoTkpqELIdtAuBDMw5FReyXvqlAoMgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4717
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 20, 2023 at 01:27:00PM +0800, Herbert Xu wrote:
> On Wed, Oct 11, 2023 at 02:14:58PM +0200, Damian Muszynski wrote:
> > This set introduces the rate limiting feature to the Intel QAT accelerator.
> > The Rate Limiting allows control of the rate of the requests that can be
> > submitted on a ring pair (RP). This allows sharing a QAT device among
> > multiple users while ensuring a guaranteed throughput.
> 
> This does not sound like something that should sit in a driver.
To clarify, this is enabling *hardware* rate limiting.

The driver is not doing any active control flow on the jobs submitted to
the accelerator. Instead, it provides a mechanism that allows system
admins to set policies that are then programmed to the device.
Such policies allow to restrict the flow or provide a committed rate on
selected ring pairs.

In brief, the role of the driver is parameter checking and device
configuration based on inputs.

> Could we implement this in crypto_engine instead?
I do not see how this can be implemented in the crypto_engine as rate
limiting functionalities in QAT are applicable not only to requests
submitted through the crypto API but also to requests submitted from a
user space application through qatlib and from a guest virtual machine.

Regards,

-- 
Giovanni
