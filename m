Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2417ECAAD3
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Sep 2022 13:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiIONJd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Sep 2022 09:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiIONJc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2022 09:09:32 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9856310A0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Sep 2022 06:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663247371; x=1694783371;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pLgA8aaMli6dLTOi/0Mw9vMT1G8SecNeeNpztXkD4Pw=;
  b=ijIBhXpSMvTSwRXEmX/t4RACnJktC0oNSXvAXCPE3jGkAW2BFN/7DkNY
   L7gsaN3KcXLbbCtQQQ40DgkRzIrJIX6j/+IdrnWA6g3dEmRu9lfVFqSQJ
   9ibVQP/1At93gpBBNVKXQ9BnyeBr2ygh/qXLmh4Os0qPwl2PzJWOpT7wc
   oyt3oreX3s4YBMmV1WPex4nzkbb+dITnNiwravQwZ9MteNWWWd28Vi48j
   J238/zdT31sCVl/p2TRkH7yqJKzQvEpBYphWiUNqG5LdjJVgB42pnLGVe
   E9VgnsklRLU7hbqKwWsHcPZiwA61jtyzSze9fwtRQvUs/++uOTN6ASCcN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="324969186"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="324969186"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:09:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="617268584"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 15 Sep 2022 06:09:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 06:09:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 15 Sep 2022 06:09:19 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 15 Sep 2022 06:09:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Feqhab3z2KJdtSsQXgTcRyiHgTvPWgBLRMXoI2es/tnmlTCuC+gphsQ+qz4HC2n3OdplXoHRGFDKfbGmUPNzUGHJbH4FGabL2cDopu3ovujNjUS5xMglShE1SLCPCpkNOKIE5TXwcJNGSlr6MsenFAHNa5tOFq0Opxt4cuV2Oi3LCxRV/5GsjH/Q7UDNTQYuTltpdQB8VA/EOyIK5iBzSeNmoQbjGc69Cuv67fkwagI3mbikEfMt4+wSKQcBCuxblqxythBM3Q6ceYHpVBzE7O5R2yTwIXoag4G7QGwb2SYmB0FhYsoI+mcN8R5Qek/vx0z2W72Xi5+V+B4aSNDn0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0ogofm2jHTA2oReMOOgokpkBeem9I+xWQT4BqNUPJk=;
 b=QonBkhJsD58PB8ujA3ku4LiORPLj4ojASk3Ohdq1T+8RzH665FRYvhzALQLb74V66P28vkQOn/DBbqfkSSjpSFpolhfPeKU2M9XzJpiE/1EkmbeMN98sWxYDPUSGP5g/8eopll8GAOZuc5GyQ1GqBsTPlJREWnTGJVpGWrMClDEHNogd/kkNE5zXbm2CiQfIJrpx5J8RFTMay6apxKJLkEHVNSxa6UmsHSbSbzMovgUWMduSYqD1aKXNNcHLxowT+CVDUFQLIHK1wF2hREFvjFEBl7LPmKPq0Kr2JCSZczjZ66cvh98BnlFsTMx5MLstCfYW40gAZXzdqVRe+vXJjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CY8PR11MB7290.namprd11.prod.outlook.com (2603:10b6:930:9a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Thu, 15 Sep
 2022 13:09:18 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::c928:5a07:ea19:1833]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::c928:5a07:ea19:1833%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 13:09:18 +0000
Date:   Thu, 15 Sep 2022 14:09:11 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Vlad Dronov <vdronov@redhat.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        "Adam Guerin" <adam.guerin@intel.com>
Subject: Re: [PATCH 8/9] crypto: qat - expose deflate through acomp api for
 QAT GEN2
Message-ID: <YyMj9yKMSTC4Iw0s@gcabiddu-mobl1.ger.corp.intel.com>
References: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
 <20220818180120.63452-9-giovanni.cabiddu@intel.com>
 <YwigYBNM7O/J6gO1@gondor.apana.org.au>
 <YwjW2x/uT9ST8+8i@gcabiddu-mobl1.ger.corp.intel.com>
 <Yw3TpwuF7a46SZDI@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yw3TpwuF7a46SZDI@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO2P265CA0313.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::13) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CY8PR11MB7290:EE_
X-MS-Office365-Filtering-Correlation-Id: e2556187-fa40-4c03-6169-08da971b7f19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VAYPLq1vjnLg/y9sRH1mggZY90+xJY6nHdl72Bjs4itYTZPE5gt7fGDeaaycFysjUCWWDillkEazSXPoeG2R1Bc8nM+bBev8caOhPMb1UlhjCMKiXNCeCdRL8b7S2rNmRAetrdVoOHs7lL/6cMGlxobGir4Na7hKsoVs7QlHtmsj0yqbaSxAwiX2xYBcrlCqycQtrGzH0aSMYfFPINDguZ6oUJXlhl9nD9ZDt9hx6W+rZ2JPhFG0KN2wsyz6QbzFkgPZ/hdMkUckpzOVtGDuZOIfqd5pPpqBVKmhdxoL6X1w1Imo99Nsx4eFVR64HDz3TgvvQ+Kwy7mVXnNnpPQS6YZ11lIzLSH02np2ZqUC7RhT2YeAd6awnDlTIijCQb5kuJmjOChMh73cVybdf+jp4abLFenmoqCV0hbMkE3Au/fnJ1nfEVkuCzBIcPto9dVb0dsHDnItnbzeIiB4ZDMfDL+q804N0FtfM/jeh7gTZkDEMlk2TrZHdQAkmZVVrEeR7DwXAnoWuWF3GFLQm1rbhASSl20s1xCTLDbGFDww9KkhhWiveY1Fz7NorbsDFa4ZUzZEMEA6R0BFg7t6KTSNq1DyQmRRTKjdWIpcufEHKQgYxJ1/Fsi8wfvwyZATW8nuUF33n6SwZs3Z7hXV/UurIHnUrcvvd9Nh7jGUs00wBnGGhYpvkbzKk+Drp1uGnwA57RPvWf8wr351I4reNy9Z8PyX7okBsrDNh8UD+qin7YY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(376002)(366004)(39860400002)(451199015)(8676002)(86362001)(186003)(5660300002)(44832011)(6486002)(83380400001)(36916002)(6506007)(38100700002)(8936002)(66556008)(6512007)(966005)(66946007)(66476007)(41300700001)(26005)(107886003)(82960400001)(6666004)(478600001)(4326008)(6916009)(316002)(2906002)(66899012)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bfJ3dJixbiYFOe+Wk8zV5ed+DRyvLy1Kp/qwnIWVvIMz03GodeJUrw1btPSj?=
 =?us-ascii?Q?hwddDeF/qJFZjzz7Awwj3pXFYwVuh5WVSnDdCSzDJFIQus6xU6bpG6PrI0B2?=
 =?us-ascii?Q?knUafCIul0dCXHHCdbDP0FHtXJ5hV0+pk7oQCIMksg+JCw15FhXKtVmsLhaK?=
 =?us-ascii?Q?tU+UAQmRipx/v7/X1uAQMCC1r9FJGMwRUBX6TJ6Ov8D9jc6B3Soz6X/v+OUf?=
 =?us-ascii?Q?D+slsO9Vq2pQmek7orIjw4C4hwzebz22TrZJDv6oBodenOWRwm2S1l4ZNiZw?=
 =?us-ascii?Q?Yv5nPGeJ8Ou4KvXtyk15r0BYvQbC3lOMP8Q2PZ2o3aHJZtNCFiRoH0shzHAF?=
 =?us-ascii?Q?nuj9EWqbbPeJ+/mXRAQKq6xCiszT0SoaKD9hUvRFA6BDCiGHLhA7s0uyOAaJ?=
 =?us-ascii?Q?iEUuVIeutTHNMuDMfauHpZDRngF/dXOx0IVIhTks+jB2MHXtpLEsnhKEwK6o?=
 =?us-ascii?Q?lDDttYmgOkVk+NgKMTkUCswUogNu0xSa5zpcGdR1yb3lFf8WTtbTekqctRsh?=
 =?us-ascii?Q?5lY1x8Qt5A3fFpcemuMDB5nxWSd0EeYGQXqOAMWtEVZ/HN1oLkF7Kf2t475A?=
 =?us-ascii?Q?nPaDBT6K35whtkIAmB9qW/Kr8xr6yOiH5CeQAmjQfmv3r+HVe4Dz6sMJD2Wg?=
 =?us-ascii?Q?CS6O5VmQaxOhyuj0pZe1JLad3Y2N8jL6KCbLkdeljNKz2oNs/dfDZQTPWVkI?=
 =?us-ascii?Q?wg+lMPoSW66ezAfAK1h1QhDHUbWs6MaDDC6rJKmazGYP13/jCGuSBZmN3ZQU?=
 =?us-ascii?Q?7vrgjfduiR7ZT2Opd46zwCXrklA8z1xLeJR7bnNTNrkB1gBy86A/pIaJpVI9?=
 =?us-ascii?Q?J48oNylnCcP6klYd6AzC6eEI92TrcAKBCDfrD0pxjYrVLr54jtGM0n4l5l2P?=
 =?us-ascii?Q?5tLNoFyfZhSqTS9xqhe0zsY025p0UpVbFpUGgHh1e7EsYPrbstD5WmnlpPrL?=
 =?us-ascii?Q?yCQW/N0LH2kyBrVS9PMA5gJiFE6CeRZlznGj1KDkT7mflco2Rw+f3iV4fOqC?=
 =?us-ascii?Q?JEj2sFcrNatkddrnZ7XN6d764w8sssFXnxOfKPdDXEIk9I/EUEaicgVuW6zT?=
 =?us-ascii?Q?kWbowzIgIiX0qERq83u+W/pX44dfJ5zEISvlXnue2P9ERef2qZF4Z+JTnf9V?=
 =?us-ascii?Q?BODSvpZnfGkiqDDV3vyHjvNdap8DxCpEVzTj/7fMdD1TF120sSFslPs0q9gb?=
 =?us-ascii?Q?BsKyhsduoZQzsTuiG3/pQHqmtMFLWcO6bthRg1gf+fDQT8rN6THDfF0vP/Iu?=
 =?us-ascii?Q?PG4VaBvm20MP7+yG0priha5OXwJftPjqKSZZRHdFr+/W+q16mqh/SC580xvj?=
 =?us-ascii?Q?twr1WmeRnq3X56kgtzczyy/SnJYsgqEDbbqqaCXgmv5TNslr/CFD7Nd0u9p3?=
 =?us-ascii?Q?EKZkwoOgmt5Fbm3YxO/iaFoUArINI8wkqFgYsBSK2g4DQZxQvgVVgkZMe6kJ?=
 =?us-ascii?Q?u8nIkUqPLbYRsunm8VY+3QUpOI9z5naEHul5k8LUXmJ2jBhpWJOXdI7rVslf?=
 =?us-ascii?Q?Y+r+nNprXYekw8BOE9danXMJsbEjlgorRUTsL+u0w11qZ5Epki0SxNL9zH78?=
 =?us-ascii?Q?MQecsXJAuyq9zUJbA/oLBcFkAkVsl7fu5yvhSC0ToMjfubC8HdT6yqJmnVzj?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e2556187-fa40-4c03-6169-08da971b7f19
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 13:09:18.0814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0fIwnEEQbJHgG3hITvqClR8JIJDpcTR4xPNng5pIg8VO1NqygYMaEw4l+y8drTxT8b2TISgQCio2O6UG/kvRrLsHbVwD+zr88nFXwCCYZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7290
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Tue, Aug 30, 2022 at 05:08:55PM +0800, Herbert Xu wrote:
> On Fri, Aug 26, 2022 at 03:21:15PM +0100, Giovanni Cabiddu wrote:
> >
> > It would be nice if the user of the api could provide a hint for the
> > size of the destination buffer in acomp_req.dlen.
> 
> The whole point of this is that the user has no idea how big
> the result will be.  If anyone would have a clue, it would be
> whoever is doing the decompression.
> 
> Ideally the hardware would take an SG list, dump whatever result
> that fits into it, and then stop the decompression, dump the
> interim state somewhere so that it can be resumed, ask for memory
> from the driver, and then resume the decompression.
> 
> I understand that hardware already exists that cannot perform
> such an incremental process.  In that case we should hide this
> inadequacy in the driver.
> 
> Here's a suggestion.  Start with whatever value you want (e.g.,
> src * 2), attempt the decompression, if it fails because the
> space is to small, then double it and retry the operation.
I prototyped the solution you proposed and it introduces complexity,
still doesn't fully solve the problem and it is not performant. See
below*.

We propose instead to match the destination buffer size used in scomp
for the NULL pointer use case, i.e. 128KB:
https://elixir.bootlin.com/linux/v6.0-rc5/source/include/crypto/internal/scompress.h#L13
Since the are no users of acomp with this use-case in the kernel, we
believe this will be sufficient.

Can we go with this solution since we have a user waiting for the acomp
implementation in the qat driver?

*Brief description of the prototyped solution:
When the callback detects an overflow condition on a request with a NULL
destination buffer, it schedules a new workqueue. This is since the
callback is running in the context of a tasklet and we want to avoid
atomic allocations.
The workqueue allocates additional pages for the destination buffer, map
those pages, re-construct the FW destination buffer list and re-send the
request to the device, making sure that the request is actually
enqueued.

Regards,

-- 
Giovanni

