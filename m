Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7728FA373D
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Oct 2022 07:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJ3H7k (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 30 Oct 2022 03:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJ3H7i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Oct 2022 03:59:38 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FE62ADA
        for <linux-crypto@vger.kernel.org>; Sun, 30 Oct 2022 00:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667116773; x=1698652773;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gI8Zr9fyvfXPSG9ONv62Rk9KgyAMTpu3VB4KFUrSYjU=;
  b=c+0TcTiMV2i+0+NYW1k2q3f5w3zmBxEg5G0jOP9BxjAyHVBVtoGFSKYM
   mUNpldmS6uIz8GI+4hDkSz5zJ1XB0VleSM0igkkD2IZCOaRKvnWltC2Jc
   OGC7fHyTNI424h9Xb8epe0PRmd8p2MWRFmW/BfCdtUfFfqou95em6qZQF
   BMvhf18ChuM5oipmSioSn8vTPsNFfH1teGCSDP6zVFgsFj93t+IFAzXWR
   K6T6wSIuZAMuU4wykBAxol7b044UBvVLOLIoH+7x9OsOqSM1c/fhfp4ey
   xTA9hRiH+q8gzwkQjDh1zxOBd9jjCgAlcfh+xZ9a5nJwkY11vLWX+Ccch
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="370794288"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="370794288"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2022 00:59:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="633206769"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="633206769"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 30 Oct 2022 00:59:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 30 Oct 2022 00:59:32 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 30 Oct 2022 00:59:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 30 Oct 2022 00:59:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 30 Oct 2022 00:59:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8+0C1VtflGjDtgv5qS1lfOxtLs880jmQQYQY1EBup7aV8JhZy+i6XhwuZ57bkfxJh+MCUlnje70wpx6DG5qOlnLm74rqmtvH2qb4eJqZN6928QMbQBJVN4GWmHkvF5wn2m7+bMBiyj523LWHJhsdrLL9dKZektGMiy+qy3eirUQ8VwfM3JI/DlwgQSNSx4liFvoTqHRjTuGNl9/cFsKcWsWscfxFpxqvAG3aDObrff/6QMmmdWkJqwzd1tb54+k7yogsNVWRGsiIjO+25SQnEmT6/zzo7/Jt0QyKZiDm5QniSbSD1t8+sCEhy1+x3M6mLTQnI7uoXavRfrUZwb5GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMlV0ZI0wq84M6ohvy3xESw7rV7u21MPDlLrjuq8AnI=;
 b=nEDnMBVBerO5yjuf60Qx4QWCCkcJO6wT8DLnEnyFp4hGHhabWpZhgiBMvRV8VEjvO9+MEGZrTEwsIAh6RgYWtpJeMGSJLRoLIv5hMoWxLQpaUkW5PdTnkHTdui2bA30yAxxDKcfEUpuehBL7QCSMbsdpGLu/jBZ0VOVtK6JcJaZbBn6X67En14JwNKhgpcKUVPw9qZ8O4k7yTUmYN8xkdJuczpDqJkTytZzHGNTzNlMR1XM614cnOI0zOLIxQ4Ycqg16nMI7prb6EDRBCaiPmsliB6s+rZrFWwTML29IF3R7O0tFUffHFW5ez+DBblE0XXZzeEsF2UY27Da/2QttbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by DM4PR11MB6357.namprd11.prod.outlook.com (2603:10b6:8:b5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Sun, 30 Oct
 2022 07:59:25 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::7f2d:39e1:85b6:93c1]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::7f2d:39e1:85b6:93c1%6]) with mapi id 15.20.5769.016; Sun, 30 Oct 2022
 07:59:25 +0000
Date:   Sun, 30 Oct 2022 15:59:15 +0800
From:   Oliver Sang <oliver.sang@intel.com>
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
CC:     "me@tobin.cc" <me@tobin.cc>, "lkp@lists.01.org" <lkp@lists.01.org>,
        lkp <lkp@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "Linux Memory Management List" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [crypto]  aa031b8f70:
 leaking-addresses.proc..rodata.cst32.PSHUFFLE_BYTE_FLIP_MASK.
Message-ID: <Y14u04MIz45Ty2ZJ@xsang-OptiPlex-9020>
References: <YwXfnidzkebRDty0@xsang-OptiPlex-9020>
 <MW5PR84MB1842289055550CE30913D2CEAB319@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MW5PR84MB1842289055550CE30913D2CEAB319@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
X-ClientProxiedBy: SI2P153CA0002.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::16) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|DM4PR11MB6357:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e68f10f-5dc2-4ae3-e38b-08daba4ca961
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9HDM2NzBdBAvOYPk+0lLFRqO7aMqPgkzZPhv6CU89fVDW35tIjxctTXYibIxEyua5ozccZus9PLImET5xMb5r4QWGXgJFJYmh3Q0/CHRb0a4UdHJmuzkz+zw7PUPrDAVxM35ST6qg+EFjRjCCTmwV7EZjmGaD1WelH1eTjrdPEhPVcrOrYe0+8jQSPMZEcNPdlitveKqlbTb7Ox/SNOitLM6wry7n52RCtxExftnBBFVF/V1oT11x8XNesT/KsDSLOXAdJm+bbrkAq98YjnduaFHrJmpAAmwHUdFBm1nDTJTSiHpKP6q2pRMJfkd8PZ+7U83VoKaLivgzkxLQAfkp4hmqD+lLW5LZ7m6hr1CUG6cnhu3xRKhBesrAozm1Cicr6up4oyrU0xZ7gM2vU02Oj1YRrMK9CIsuRY+Im5jkidouWBRwmxnmA2eRGYh3LLNDcOw+F987UVUm354Ss6NNx9LQfBEtjRbCDLoQGvMyUheMqifkZgw+MXe8s03pj/90C2rdic7cIZWalmIYzCrC/uj/nlTijVCRCKEt8rnyP4qmaaRCMeF2UMm7JiveMy0PKie/kwzDf9VDUnsyRR6ECq961ferzJrMFXFkGZGAkk9C29k6r7+rkZHsgAkaRi3LqZFy+80deIB8dyKIGlqWTvv+sA8huw5UauGUbL2JUsP5h4AF9yrunfG1KmHrpq9gpd/KYvEVEUc0wJqCueJoN8DjhOzPXLzdr0A72T2HOB9NV6/wYBHi4/XzCNzoAxgG84h7xRCpXjAuCvqbPdapw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(6486002)(4744005)(296002)(41300700001)(5660300002)(2906002)(44832011)(38100700002)(6916009)(316002)(54906003)(4326008)(66946007)(8676002)(66556008)(8936002)(186003)(66476007)(86362001)(478600001)(6506007)(26005)(9686003)(6666004)(6512007)(82960400001)(33716001)(101420200003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MhfSYKOj2avu/srUHp1gTjwTCv0djVJTth4jTrZjx3jCZu94ZIlRyDt4k3gU?=
 =?us-ascii?Q?/VpJeU7Fr+pCtTurBjl5vOjeOE5FFnKQ4gDqAdIQ6XGiZd63mptu9shzPavm?=
 =?us-ascii?Q?2ZzKSdf4x65saz6VD/8MfuD33ykFjFQYN4aSSJ/KBwTkb8//2Q3t1XViaMfI?=
 =?us-ascii?Q?skBZMo/0A8T9+CqB3XSfWRtueh8OZGIndjrNPnpWySBYhfpWE2KaW2zRGJfs?=
 =?us-ascii?Q?8b73OmSUO0pFZ3REyBehkl2wQ5GrqrqXBM9pQKzJLyrt2Lw7rpuzV9nZbdj0?=
 =?us-ascii?Q?HkTd+E8WI0DMKYPfZu5kDx7qKwJAWm4UFZoWuY0aeNLZLB0+o7oJDkHzlJsP?=
 =?us-ascii?Q?GxHxKGK5jlkLTHJ2s3vempF4DgngyuJd86gUqrWLoZlvWiWSjwz76tn2Obyj?=
 =?us-ascii?Q?G+Gim6UHdx6R11VNCD9Zv8GL8PsX1mYeJNh+imWkd6mFQi7k2BrLR4bkE/3f?=
 =?us-ascii?Q?Rvghxf554RvycLFE7LQCo+m1+CobQmX/j/As7Rhq30PA4oUb1NAxEphhemye?=
 =?us-ascii?Q?7VQFjdl/PGln5Rp7AsthxeM22ASHo3G06CEY/xjcMQfhOSO5tDn8WCp8/rDU?=
 =?us-ascii?Q?j7VW+2J/78p6z2Rlq8m0DWnGMIpu/vjkePNDJ2oQjwJ2qlcf94omSty7qVR6?=
 =?us-ascii?Q?GAT+cv12gfkX1aOwtHzL433sLZmIPAk0XAe0SOc5CwF8Z5ao8q0rVfCA6Nff?=
 =?us-ascii?Q?W4dLJ6kpp5KIEhUma0PG7H0wZtmcM7jaOAIZwLCyTouRCsBiOlIMieDJon3X?=
 =?us-ascii?Q?6e4I8QVLDI0fVlIePfzs9gjwHoiZaI0zuH2FuGzDh1PPphYWJMxekKFcmK4c?=
 =?us-ascii?Q?xGd6WKfEohtA2IN38clF1vI1I/LlSU8Xoei2EJzn186sHcjdNpxkiyCQBLcL?=
 =?us-ascii?Q?R8Qd7j2bVXuLABLdrilvI7TBGxmIWk3f/SQ147EaarsA1Nql82d7PsHEhhXR?=
 =?us-ascii?Q?zTs6RBzVvlYp/zU5dO52DmUnx4mMWWHQ7AqmLc+G7CReXp5TUKaCjtKvfEUm?=
 =?us-ascii?Q?j/Qf+NXlGwSijmBxWGEA21tvHtgO5m3tlvJwI2JSIb+I2hLbUjN9KJaJQA+u?=
 =?us-ascii?Q?rNYgAppmTwHzNlSx/dlumBkqHlQY/jM+bOb/lChLjyeojqrLSv+ZhoxACQrA?=
 =?us-ascii?Q?fhRUft0dMso0o1Cq6gAG5U5K0rUL4hhwyRfM6XHf/AGz/uIirB4MzzAISk7f?=
 =?us-ascii?Q?FP8tLljAbf5TMmT0Dal4/5ovhWHZU/+H4e0SiUExH9H3q59uYNrluXGbI/VI?=
 =?us-ascii?Q?+xqSWRPchz4i7MF389nveSjPW4LBAa7uBtyyzpN1cYgUnbcwQpV37p5gqEz8?=
 =?us-ascii?Q?EQvTcydAr0bGMZPdlAdPK7DWd8U6rElbXtm1YLA5oV3aFAiYGE3U3Re08VU4?=
 =?us-ascii?Q?u5xYKU9T7dnf3VqLGLLcR9DhqZaeA+Vd/+Jg6sF4NAgn9PCpvoNeuxKFjPhn?=
 =?us-ascii?Q?9spXTjR4rKoaRpDgTdt0Ey8l8wOvuoijU+w2ZwGZp3cNEyGoUf19+p2lEMC8?=
 =?us-ascii?Q?9IdGVgpY1EuOlt4hq6g2UuktFUkOQRNjCXIF9fMaSCevaYqO8GI5p1C22zUx?=
 =?us-ascii?Q?TLa+g0bEk/Oh8Z2jEcU58bAmHynPZNmaKbij7H78?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e68f10f-5dc2-4ae3-e38b-08daba4ca961
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 07:59:25.1203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VTOfaknKaHv0vdqlk24F52+WBpG2nS5Uv/kr3g/tt4s7jcRQJ/LuB4GCKtzyX3E3/uen2NfB/b7Ko0pLjghfMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6357
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Elliott,

On Wed, Oct 26, 2022 at 05:15:50AM +0800, Elliott, Robert (Servers) wrote:
> 
> 
> 
> Perhaps lkp needs to run that script as a normal user, not root?
> As root, it outputs 67234 lines; as a normal user, it outputs
> just 3 lines (all values related to keyboards, not addresses).
> 

Thanks for detail guidance, we will make this change.

