Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA22FCDB465
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Oct 2023 07:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjJPHXR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Oct 2023 03:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjJPHXQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2023 03:23:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82725AD
        for <linux-crypto@vger.kernel.org>; Mon, 16 Oct 2023 00:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697440994; x=1728976994;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=yNwM8+bAYQlBox0iXLobBCfYNPPlrgvvpeicUnHD4z4=;
  b=X6NiIEMmTY3GgF2fxEYvyiIZfgfLjhHAL9WNIiEFYIJp4lTsojBlRLGW
   7XJv55d0hOAEirZtU8rlbUd0y6ZX5Ur5XcscmMFkrG4sfd2T9otVctgyr
   f9MWFO+pVo1tX7y49C+WAbyKCo7rhswenl8b/+XHE5P6dOXjTy4HM+yGb
   icAWAeD2UV+zTifCGoGO5+JrUcnLeiFXqLp8mwgMOaCouYFlWdSnE++EX
   PLwMu8wtP/VHJg4a8dxuUnvA70ku6gpWMAyGLVqCvG0m8GFHi1EUI1GxP
   Ay5XRwl3XC5R39Y9BPjbQuL04PHRLThAyUbUKc37Ad21D1RjP8rh7pf5d
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="385303629"
X-IronPort-AV: E=Sophos;i="6.03,228,1694761200"; 
   d="scan'208";a="385303629"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 00:23:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="749201142"
X-IronPort-AV: E=Sophos;i="6.03,228,1694761200"; 
   d="scan'208";a="749201142"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Oct 2023 00:23:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 16 Oct 2023 00:23:13 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 16 Oct 2023 00:23:12 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 16 Oct 2023 00:23:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 16 Oct 2023 00:23:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WNnmm1/Bkgw3xxY9Qjoq2trtYWwuztF03+8KtTHOKK6VJfY1sK9jfFTCXHM2pYzXBZf/WCtlin3Dj0MdVbVCgoI2JG+/rzUi5/beQXk6fVtBspJI14Kb0Q0KbxdWxRloDu3DNzNHV2B/RUC5QTK5G6AVm1CrF2t0+vYkU8lYoO9t7FIzlPD6VUOagoSc+EfUTxpDxfv6prtTzgySMCyhb0mD5SX8BFBZSULET6/ndJH4jgaySyg7uCAcLZvdCx1YSkLORyQL2wGDzRgZkpXlA1JXVAXL/3l4vaDRWa5B2BYqrTX3u5eQ5l0lNvPz34aa9fVGgV4srOLZSyQNnibLvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z6s3C62DV1IgmuxMfIFQDlkUvkYtPLWCtlJ43IhOl98=;
 b=Am7rvNLuWyrFcHNnwRdhk8FZbYz1vy7lyauaZwlo9kh0UhenMt3s8CKZZwjtIx7lQKX7Js8OrS+OO3ao2BPxw5YuPP0zij4LFpwT+zSJ8qt006wV3QAtOmneUmFkgNBH7bzG+IQbFsM/UT/iN1uY2ywZDtJ2T+DtgJtCUpfl6wxds5QzKj7mo2zWAzu1A3rOSmm9+UjOnpBR8yO4F3cKEV2MVlNx4MbRyAIh/XRmU9QHtRHkdElnRdhZxRQ2q03lYG9Dr82JkxbEIr03pIfk5NyUq7tSr2l93U54BsEeOD3AYVS+RWEfpIoB8KcFhXPHrSva5RTT3rN0gnidgxI8Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW5PR11MB5906.namprd11.prod.outlook.com (2603:10b6:303:1a0::21)
 by CO1PR11MB4881.namprd11.prod.outlook.com (2603:10b6:303:91::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Mon, 16 Oct
 2023 07:23:10 +0000
Received: from MW5PR11MB5906.namprd11.prod.outlook.com
 ([fe80::6c57:9517:b2a7:3385]) by MW5PR11MB5906.namprd11.prod.outlook.com
 ([fe80::6c57:9517:b2a7:3385%7]) with mapi id 15.20.6863.043; Mon, 16 Oct 2023
 07:23:10 +0000
Message-ID: <431876b0-98cf-4b21-9826-b91f49043fd7@intel.com>
Date:   Mon, 16 Oct 2023 10:23:03 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/11] crypto: qat - add retrieval of fw capabilities
Content-Language: en-US
To:     "Muszynski, Damian" <damian.muszynski@intel.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        qat-linux <qat-linux@intel.com>,
        "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
References: <20231011121934.45255-1-damian.muszynski@intel.com>
 <2ee58a8ad2e04a3f8a65bbf35d83041b@DM4PR11MB8129.namprd11.prod.outlook.com>
From:   Tero Kristo <tero.kristo@intel.com>
In-Reply-To: <2ee58a8ad2e04a3f8a65bbf35d83041b@DM4PR11MB8129.namprd11.prod.outlook.com>
X-ClientProxiedBy: FR2P281CA0046.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::20) To MW5PR11MB5906.namprd11.prod.outlook.com
 (2603:10b6:303:1a0::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5906:EE_|CO1PR11MB4881:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dc2beac-86b2-43bc-2880-08dbce18c065
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CosfK9Kth6HyYyi3zMC8ArDxMvHWucjw/SLlE1yI8Lye2E1ZUxNcZLuzbJySLzCFz3vI7wZmOpJg5Cbe0Ad4qioahcN/dqf/7oPlP/+vIFAcUM9HjHTk4e69kBprodgDxKb62XVvMQ/lY4d3NnaKsNfdOZXd5pj52dW80FRiP0YF+eQlInn0HilFe/7+iDF2JZQZT6qblhc3ED0Llsf8uL8vlH8gUoTokrlCr/StkP7rqWcU9ZdDqrd6OCOmRm1PfJmQAxTQ8HT5inkyP+D3MSYct4lX4ULuuBCqFj2uTn9rWuJc6zKkSPmSGezJU3rjll7/czESgCGTZQbPFJEKEBMcDpuvyS79UMy/fJ4vjyzo7jNrQ6d9kHZtpMm0C3yE9AzQrXdVETVRuuASKy0iUFyyMAko1yy81RG9bK7g2hTYNMjOTNrTtIeSq2C+41qfofqlR+613P9afBg+WcXwoKDeO3dxlvIHtBu3+lPcJ9In2MVVKPY+pQnrQT+B/l1bk65ucYJyYo+0HXa8aEO1TusnAiuzZwRiawfbZRQ03yrvF0Z/qR5QtNiIPPba1FwqnDg6RLByTzaJag/RCr/GTULWH0wBqZ9kjJir9VDa99Q74Ov3ZR/JcQXugxoAnX4tQrpjHcY8avNqWD/jM0wZag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5906.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(376002)(39860400002)(366004)(396003)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(36756003)(31686004)(110136005)(66946007)(66476007)(66556008)(41300700001)(54906003)(38100700002)(31696002)(86362001)(82960400001)(83380400001)(6512007)(2616005)(26005)(107886003)(53546011)(6666004)(6506007)(6486002)(478600001)(316002)(4326008)(5660300002)(8936002)(44832011)(2906002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzlMNTExODJjWXMxM2lyNHNyVlN0YnJZR1pJNlR1b1ZzNWg0OXFQSWUvVG96?=
 =?utf-8?B?d05YZWNQU2hWS0F2bXgyMkFiMzZtdHF5a3pvczEvbWdYSlFsczhuMkFNaVFs?=
 =?utf-8?B?Ky9XLyt4NDlOaUhoRXNGdG1lWXZIMFFqM1RJODV2SmtvcWJnZTR5aDFpMUdY?=
 =?utf-8?B?VVBjQm12YTRWVFNZUEFGaVQ2YjRHcGgzZFZMUUlVTitralJSbURmMkNGbFlr?=
 =?utf-8?B?SFNqa0U1QjNxWUFFRmZFMXRhZEJZK2FZUkNXeEJabGlhSGVOMHpIeXQyaXJv?=
 =?utf-8?B?eDFQejdqV213c1hJVjJKS1lXSmtOcGp1UEMxamxlY2FIZVl6NDV0Q0krNzYw?=
 =?utf-8?B?bEFqRDVJTlpWcEpxb2lVUlFjYzdVaHV5WGtMcTVzRUExdWxNeDFmdy9qSlkz?=
 =?utf-8?B?eDdIbGZ0NXVsRDIySmNPUExBVGlvY3p2WnIxeTBPRk0vNkRpWlBRTzRqYmFM?=
 =?utf-8?B?akNCM1NjVFo3T0JmVWRvaEVpRjU0Wms0TmlhWU5PRGNtMzRrQXltRTNjUXYz?=
 =?utf-8?B?blJwcWwxU2dmVGdVdFVVYzI5V3k2VXNSam1xM01zME9TUEY4NUhoM1RwNTlp?=
 =?utf-8?B?ek5tVXprOG1iMFo5UWlNMGtyTXdadEhDRFpPd3NYRytwL3BlNTRjWkQrS3gr?=
 =?utf-8?B?U1ZQdGdnMFJMT1VRL1NWQWdscTBBMFY3a0xrVTVyV0tvTGRWZ05PUXhKV1ZB?=
 =?utf-8?B?Y2lxbmwxdWpKUWNEZjMxTnpneGdERXVJY3hBR0YvRS9ERDBVWEhyMnExcCtS?=
 =?utf-8?B?RStPUVVJU2gwcTFsbThYbWU1S3Fhc3dmalNxdVc3dmpaR0Z3aW1CaklwOWhF?=
 =?utf-8?B?dUVnMWk1UjdVdGU5Qk1waFNNcGtoYmFyY3hLODU2V0RVVXdRenVnQjQ5Vk91?=
 =?utf-8?B?cmRPQzFPUDZJOHZwdmlIOEVpckRyejVCQzRrc3Zka3Q2eEJWOXNPU1hYVVF2?=
 =?utf-8?B?VHJtdGhsR1JQR2tiZzJLSEpSL250MVZJRS96ZFlSSWp6anVnS0ZONFRSdEwv?=
 =?utf-8?B?a1Q2dWVWcHd1NFQvalZ6a29mT0RITlJDeHNjNjBlQzFqTGJ2TzNUWDlvRGhR?=
 =?utf-8?B?aWZXa05nM08yWHJ4ZEh4T3dBK1hvZ2U1R3ZaUTYwL1N5eU4zQXlwOHdUZDdD?=
 =?utf-8?B?QkNtRGdrMWFNdUlLeWVhbXJkMDB5aVo1ZlF4TWtlWmV0VW1WVzVWV2w3WVV5?=
 =?utf-8?B?RzVjZ0JENnU5dFd5SkpZTVB1U2FmUHpWeHV3L3p2aXNmUm02WkJUNTBrOXRK?=
 =?utf-8?B?UnpybG9IS2dWcTNUYTBxMGluK0FTN3NRaDRNT3VTRXZtSk5WTDk4TnQ3Ly91?=
 =?utf-8?B?TlIvdTlxU3pBK1Z5QTAveGpRb295bUNOS3phR2xmcVdJZFFZaXMyOG9UZ242?=
 =?utf-8?B?dXNQVHhESTdTU2FXTGJ0RzBubTRBQndMQjJ5d1o2WHRLdy9DQkhYV1Q3ZTBk?=
 =?utf-8?B?WHV4M3hPY0lFQlptU1VmV082VEdNTlo2VGJWY2o3N25zc3RWdzhDZjlaNkp4?=
 =?utf-8?B?L0dtSTF0Nm1aQkFGM0czcHZRM1NweUptblFISHV6ZmxMOEpYRFA5RVJQOGhJ?=
 =?utf-8?B?Vk5FS0RTR3NUU2Fvd3JieXBDUTJMN1kvTndidHlPZGh3Wkx5cHZMa2Y3Y0ds?=
 =?utf-8?B?Wks2REhDUjB3bG1Idk15ek5pekRKeHZsVXVhY1pRL2l1MTE0VmF0bGEzOHpK?=
 =?utf-8?B?ZU1seEhyd252b1RvdmVXejVKYTJVUGdLM1JJaCs3Q3UxZUI5S0EwdGdkWXlU?=
 =?utf-8?B?SkZWcGl5WXVrNE5FV1BjUDNPbUdjVFRQbXoxRU1MdUhMNmhVTDZ1ZzV2V3NS?=
 =?utf-8?B?RnBPM2F3bi9xVnBrY2d4cUx5WHFISlJtWDVpRmpWa0N0QWdVUEM1QmthOGEz?=
 =?utf-8?B?KzFNeWVRb2JKbzZJTlRtZW9GS2tlamJTU1dtdXVFMnJXb1FKd3F3RTUwaGhU?=
 =?utf-8?B?NUZlSHdNODU5NnN2blYyZjJOMnNyS0ZFQ0xxanlwRklMcFdYUStRL1B4NmlR?=
 =?utf-8?B?WTRzUnZpOExTS3QySzRrR2Fjd2gvMjhpczNLY3lMSEpVZFYyMld6V2xxWWZj?=
 =?utf-8?B?MEkzQmJPcU92U1U4YXpZTDcrakdVTHRScWQzZ21zMHRZWkp5SzBqemtPa0Rs?=
 =?utf-8?B?NU11V1pUMEJsN0VLbGNaZVVlcjdNTE15WkM2WlkxSDhhVzhyY0xMckZhaXhP?=
 =?utf-8?B?dnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dc2beac-86b2-43bc-2880-08dbce18c065
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5906.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 07:23:10.6334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCG++Ronhm7mpL7eJ02fWLDfPtsSKJbgv+Lhn9ztZMIWlWEzre5DA0WuN05MYXrR2EY4mO15fbUD//dN5fe7GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4881
X-OriginatorOrg: intel.com
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGVsbG8sCgpPbiAxMS8xMC8yMDIzIDE1OjE1LCBNdXN6eW5za2ksIERhbWlhbiB3cm90ZToKPiBU
aGUgUUFUIGZpcm13YXJlIHByb3ZpZGVzIGEgbWVjaGFuaXNtIHRvIHJldHJpZXZlIGl0cyBjYXBh
YmlsaXRpZXMKPiB0aHJvdWdoIHRoZSBpbml0IGFkbWluIGludGVyZmFjZS4KPiAKPiBBZGQgbG9n
aWMgdG8gcmV0cmlldmUgdGhlIGZpcm13YXJlIGNhcGFiaWxpdHkgbWFzayBmcm9tIHRoZSBmaXJt
d2FyZQo+IHRocm91Z2ggdGhlIGluaXQvYWRtaW4gY2hhbm5lbC4gVGhpcyBtYXNrIHJlcG9ydHMg
aWYgdGhlCj4gcG93ZXIgbWFuYWdlbWVudCwgdGVsZW1ldHJ5IGFuZCByYXRlIGxpbWl0aW5nIGZl
YXR1cmVzIGFyZSBzdXBwb3J0ZWQuCj4gCj4gVGhlIGZ3IGNhcGFiaWxpdGllcyBhcmUgc3RvcmVk
IGluIHRoZSBhY2NlbF9kZXYgc3RydWN0dXJlIGFuZCBhcmUgdXNlZAo+IHRvIGRldGVjdCBpZiBh
IGNlcnRhaW4gZmVhdHVyZSBpcyBzdXBwb3J0ZWQgYnkgdGhlIGZpcm13YXJlIGxvYWRlZAo+IGlu
IHRoZSBkZXZpY2UuCj4gCj4gVGhpcyBpcyBzdXBwb3J0ZWQgb25seSBieSBkZXZpY2VzIHdoaWNo
IGhhdmUgYW4gYWRtaW4gQUUuCj4gCj4gU2lnbmVkLW9mZi1ieTogRGFtaWFuIE11c3p5bnNraSA8
ZGFtaWFuLm11c3p5bnNraUBpbnRlbC5jb20+Cj4gUmV2aWV3ZWQtYnk6IEdpb3Zhbm5pIENhYmlk
ZHUgPGdpb3Zhbm5pLmNhYmlkZHVAaW50ZWwuY29tPgo+IC0tLQo+ICAgLi4uL2ludGVsL3FhdC9x
YXRfY29tbW9uL2FkZl9hY2NlbF9kZXZpY2VzLmggIHwgIDEgKwo+ICAgLi4uL2NyeXB0by9pbnRl
bC9xYXQvcWF0X2NvbW1vbi9hZGZfYWRtaW4uYyAgIHwgMjUgKysrKysrKysrKysrKysrKysrKwo+
ICAgLi4uL3FhdC9xYXRfY29tbW9uL2ljcF9xYXRfZndfaW5pdF9hZG1pbi5oICAgIHwgIDMgKysr
Cj4gICAzIGZpbGVzIGNoYW5nZWQsIDI5IGluc2VydGlvbnMoKykKPiAKPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9jcnlwdG8vaW50ZWwvcWF0L3FhdF9jb21tb24vYWRmX2FjY2VsX2RldmljZXMuaCBi
L2RyaXZlcnMvY3J5cHRvL2ludGVsL3FhdC9xYXRfY29tbW9uL2FkZl9hY2NlbF9kZXZpY2VzLmgK
PiBpbmRleCAzNjc0OTA0ZDA1MjcuLjQ1NzQyMjI2YTk2ZiAxMDA2NDQKPiAtLS0gYS9kcml2ZXJz
L2NyeXB0by9pbnRlbC9xYXQvcWF0X2NvbW1vbi9hZGZfYWNjZWxfZGV2aWNlcy5oCj4gKysrIGIv
ZHJpdmVycy9jcnlwdG8vaW50ZWwvcWF0L3FhdF9jb21tb24vYWRmX2FjY2VsX2RldmljZXMuaAo+
IEBAIC0yMjEsNiArMjIxLDcgQEAgc3RydWN0IGFkZl9od19kZXZpY2VfZGF0YSB7Cj4gICAJdTMy
IHN0cmFwczsKPiAgIAl1MzIgYWNjZWxfY2FwYWJpbGl0aWVzX21hc2s7Cj4gICAJdTMyIGV4dGVu
ZGVkX2RjX2NhcGFiaWxpdGllczsKPiArCXUxNiBmd19jYXBhYmlsaXRpZXM7Cj4gICAJdTMyIGNs
b2NrX2ZyZXF1ZW5jeTsKPiAgIAl1MzIgaW5zdGFuY2VfaWQ7Cj4gICAJdTE2IGFjY2VsX21hc2s7
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2ludGVsL3FhdC9xYXRfY29tbW9uL2FkZl9h
ZG1pbi5jIGIvZHJpdmVycy9jcnlwdG8vaW50ZWwvcWF0L3FhdF9jb21tb24vYWRmX2FkbWluLmMK
PiBpbmRleCAxNWZmZGE1ODIzMzQuLjlmZjAwZWI0Y2M2NyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJz
L2NyeXB0by9pbnRlbC9xYXQvcWF0X2NvbW1vbi9hZGZfYWRtaW4uYwo+ICsrKyBiL2RyaXZlcnMv
Y3J5cHRvL2ludGVsL3FhdC9xYXRfY29tbW9uL2FkZl9hZG1pbi5jCj4gQEAgLTMxMCw2ICszMTAs
MjYgQEAgc3RhdGljIGJvb2wgaXNfZGNjX2VuYWJsZWQoc3RydWN0IGFkZl9hY2NlbF9kZXYgKmFj
Y2VsX2RldikKPiAgIAlyZXR1cm4gIXN0cmNtcChzZXJ2aWNlcywgImRjYyIpOwo+ICAgfQo+ICAg
Cj4gK3N0YXRpYyBpbnQgYWRmX2dldF9md19jYXBhYmlsaXRpZXMoc3RydWN0IGFkZl9hY2NlbF9k
ZXYgKmFjY2VsX2RldiwgdTE2ICpjYXBzKQo+ICt7Cj4gKwl1MzIgYWVfbWFzayA9IGFjY2VsX2Rl
di0+aHdfZGV2aWNlLT5hZG1pbl9hZV9tYXNrOwo+ICsJc3RydWN0IGljcF9xYXRfZndfaW5pdF9h
ZG1pbl9yZXNwIHJlc3AgPSB7IH07Cj4gKwlzdHJ1Y3QgaWNwX3FhdF9md19pbml0X2FkbWluX3Jl
cSByZXEgPSB7IH07Cj4gKwlpbnQgcmV0Owo+ICsKPiArCWlmICghYWVfbWFzaykKPiArCQlyZXR1
cm4gMDsKPiArCj4gKwlyZXEuY21kX2lkID0gSUNQX1FBVF9GV19DQVBBQklMSVRJRVNfR0VUOwo+
ICsJcmV0ID0gYWRmX3NlbmRfYWRtaW4oYWNjZWxfZGV2LCAmcmVxLCAmcmVzcCwgYWVfbWFzayk7
Cj4gKwlpZiAocmV0KQo+ICsJCXJldHVybiByZXQ7Cj4gKwo+ICsJKmNhcHMgPSByZXNwLmZ3X2Nh
cGFiaWxpdGllczsKPiArCj4gKwlyZXR1cm4gMDsKPiArfQo+ICsKPiAgIC8qKgo+ICAgICogYWRm
X3NlbmRfYWRtaW5faW5pdCgpIC0gRnVuY3Rpb24gc2VuZHMgaW5pdCBtZXNzYWdlIHRvIEZXCj4g
ICAgKiBAYWNjZWxfZGV2OiBQb2ludGVyIHRvIGFjY2VsZXJhdGlvbiBkZXZpY2UuCj4gQEAgLTMy
MSw2ICszNDEsNyBAQCBzdGF0aWMgYm9vbCBpc19kY2NfZW5hYmxlZChzdHJ1Y3QgYWRmX2FjY2Vs
X2RldiAqYWNjZWxfZGV2KQo+ICAgaW50IGFkZl9zZW5kX2FkbWluX2luaXQoc3RydWN0IGFkZl9h
Y2NlbF9kZXYgKmFjY2VsX2RldikKPiAgIHsKPiAgIAl1MzIgZGNfY2FwYWJpbGl0aWVzID0gMDsK
PiArCXUxNiBmd19jYXBhYmlsaXRpZXMgPSAwOwo+ICAgCWludCByZXQ7Cj4gICAKPiAgIAlyZXQg
PSBhZGZfc2V0X2Z3X2NvbnN0YW50cyhhY2NlbF9kZXYpOwo+IEBAIC0zNDAsNiArMzYxLDEwIEBA
IGludCBhZGZfc2VuZF9hZG1pbl9pbml0KHN0cnVjdCBhZGZfYWNjZWxfZGV2ICphY2NlbF9kZXYp
Cj4gICAJfQo+ICAgCWFjY2VsX2Rldi0+aHdfZGV2aWNlLT5leHRlbmRlZF9kY19jYXBhYmlsaXRp
ZXMgPSBkY19jYXBhYmlsaXRpZXM7Cj4gICAKPiArCXJldCA9IGFkZl9nZXRfZndfY2FwYWJpbGl0
aWVzKGFjY2VsX2RldiwgJmZ3X2NhcGFiaWxpdGllcyk7CgpZb3UgY291bGQganVzdCBwYXNzIHRo
ZSBhY2NlbF9kZXYtPmh3X2RldmljZS0+ZndfY2FwYWJpbGl0aWVzIGluc3RlYWQgb2YgCmZ3X2Nh
cGFiaWxpdGllcyBoZXJlLCBpZ25vcmUgdGhlIHJldHVybiB2YWx1ZSwgYW5kIGdldCByaWQgb2Yg
dGhlIGxvY2FsIAp2YXJpYWJsZS4KCi1UZXJvCgo+ICsJaWYgKCFyZXQpCj4gKwkJYWNjZWxfZGV2
LT5od19kZXZpY2UtPmZ3X2NhcGFiaWxpdGllcyA9IGZ3X2NhcGFiaWxpdGllczsKPiArCj4gICAJ
cmV0dXJuIGFkZl9pbml0X2FlKGFjY2VsX2Rldik7Cj4gICB9Cj4gICBFWFBPUlRfU1lNQk9MX0dQ
TChhZGZfc2VuZF9hZG1pbl9pbml0KTsKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vaW50
ZWwvcWF0L3FhdF9jb21tb24vaWNwX3FhdF9md19pbml0X2FkbWluLmggYi9kcml2ZXJzL2NyeXB0
by9pbnRlbC9xYXQvcWF0X2NvbW1vbi9pY3BfcWF0X2Z3X2luaXRfYWRtaW4uaAo+IGluZGV4IDll
NWNlNDE5ZDg3NS4uZTRkZTlhMzBlMGJkIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2lu
dGVsL3FhdC9xYXRfY29tbW9uL2ljcF9xYXRfZndfaW5pdF9hZG1pbi5oCj4gKysrIGIvZHJpdmVy
cy9jcnlwdG8vaW50ZWwvcWF0L3FhdF9jb21tb24vaWNwX3FhdF9md19pbml0X2FkbWluLmgKPiBA
QCAtMTYsNiArMTYsNyBAQCBlbnVtIGljcF9xYXRfZndfaW5pdF9hZG1pbl9jbWRfaWQgewo+ICAg
CUlDUF9RQVRfRldfSEVBUlRCRUFUX1NZTkMgPSA3LAo+ICAgCUlDUF9RQVRfRldfSEVBUlRCRUFU
X0dFVCA9IDgsCj4gICAJSUNQX1FBVF9GV19DT01QX0NBUEFCSUxJVFlfR0VUID0gOSwKPiArCUlD
UF9RQVRfRldfQ1JZUFRPX0NBUEFCSUxJVFlfR0VUID0gMTAsCj4gICAJSUNQX1FBVF9GV19EQ19D
SEFJTl9JTklUID0gMTEsCj4gICAJSUNQX1FBVF9GV19IRUFSVEJFQVRfVElNRVJfU0VUID0gMTMs
Cj4gICAJSUNQX1FBVF9GV19USU1FUl9HRVQgPSAxOSwKPiBAQCAtMTA5LDEwICsxMTAsMTIgQEAg
c3RydWN0IGljcF9xYXRfZndfaW5pdF9hZG1pbl9yZXNwIHsKPiAgIAkJCV9fdTMyIHVuc3VjY2Vz
c2Z1bF9jb3VudDsKPiAgIAkJCV9fdTY0IHJlc3J2ZDg7Cj4gICAJCX07Cj4gKwkJX191MTYgZndf
Y2FwYWJpbGl0aWVzOwo+ICAgCX07Cj4gICB9IF9fcGFja2VkOwo+ICAgCj4gICAjZGVmaW5lIElD
UF9RQVRfRldfU1lOQyBJQ1BfUUFUX0ZXX0hFQVJUQkVBVF9TWU5DCj4gKyNkZWZpbmUgSUNQX1FB
VF9GV19DQVBBQklMSVRJRVNfR0VUIElDUF9RQVRfRldfQ1JZUFRPX0NBUEFCSUxJVFlfR0VUCj4g
ICAKPiAgICNkZWZpbmUgSUNQX1FBVF9OVU1CRVJfT0ZfUE1fRVZFTlRTIDgKPiAgIAotLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0KSW50ZWwgRmlubGFuZCBPeQpSZWdpc3RlcmVkIEFkZHJlc3M6IFBMIDI4MSwgMDAxODEg
SGVsc2lua2kgCkJ1c2luZXNzIElkZW50aXR5IENvZGU6IDAzNTc2MDYgLSA0IApEb21pY2lsZWQg
aW4gSGVsc2lua2kgCgpUaGlzIGUtbWFpbCBhbmQgYW55IGF0dGFjaG1lbnRzIG1heSBjb250YWlu
IGNvbmZpZGVudGlhbCBtYXRlcmlhbCBmb3IKdGhlIHNvbGUgdXNlIG9mIHRoZSBpbnRlbmRlZCBy
ZWNpcGllbnQocykuIEFueSByZXZpZXcgb3IgZGlzdHJpYnV0aW9uCmJ5IG90aGVycyBpcyBzdHJp
Y3RseSBwcm9oaWJpdGVkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQKcmVjaXBpZW50LCBw
bGVhc2UgY29udGFjdCB0aGUgc2VuZGVyIGFuZCBkZWxldGUgYWxsIGNvcGllcy4K

