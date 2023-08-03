Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5ABC001DF
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Aug 2023 09:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbjHCJUk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Aug 2023 05:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbjHCJTz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2023 05:19:55 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAF43AA3
        for <linux-crypto@vger.kernel.org>; Thu,  3 Aug 2023 02:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691054391; x=1722590391;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XmtfgB8uwnPI622cOkKX7toQiUI422MY81z2UpKGSU8=;
  b=Fyacw1cyJ7teadDMd3rSb+2azTUIf9eGfweQpF7TaWKtcMraHULXaUzT
   Wr5kjqJDky+Om5dtmhSBHRctaTITUCaVh7II5NwJPtjV3oFTWuMQizXm9
   yEFOx3PDqyuVL5uHAuamo+WGtY8nrXp9MFeZOlLgDF87YOL1KAPEamB7F
   51UbZnAA0NmDvygFDuHpntYcz2PaVXvljcLAk4o6wc5/Uk5w/YO2XNEMu
   ie56xgb42lBI9he4ST7HHkqt/Vlt9UJsz+CyKBMdncaQV0h1CuJi2CqnR
   QUcJ/O1vxTQuLs32cerDkO4QJsGILI8g0CKLoFHkCgWF2MXtGzveeHVda
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="354739160"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="354739160"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 02:19:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="706479665"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="706479665"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 03 Aug 2023 02:19:36 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 3 Aug 2023 02:19:36 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 3 Aug 2023 02:19:36 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 3 Aug 2023 02:19:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Krhwglsm8DBPm56T1QfBTipTUFn5cJQRSfr9Pbi2wxMQSkClHLUCRbECBjdpOBn8nP2hJmueNKiJL/7BxfR0FjPs11F5GO3y5tJA6iorYipRdchSW7v62HaCykS+s3eyKcjYPJiR4oH3MluNSfu7PvjEA6kh/SChCD/AzCCCMqNmjWkDNGPsEnsqsiWh7fAbVmiDTOl7uxD5JKbD/0AzXGoj428hqjdTQfYX/uyO3p54sEmc6vcyHtmFmD5mt8noICa0IlDcIR38LnwPz+4a+6wgZbGhIqAJ259ragROdDF7fCyhVWOw8uxQJ354i29fT4zwR2rSZsr/D4w2mX7TQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5YpZyJeQJqLTjf5zLFZbkM+QBYlTRZ440XN9MFqWuU=;
 b=iQ3Nx3rdg4vkOagQD/v24jVnWxzZWJJK80jDETkCdIxOV1su42VOcaTBBqFbHfvu2xKJhqHwAh/SuPOn0REb7Ypowa5UYcAXphmVM+5ucsCy8r5EJJ+UjFSzxKsUwu5UR4SWWw9j5TPJ3+86PM7DQ0SQJyagnb+dj93gyKW0izNSsK/wBfTagTke4H/6zznXVa8b9Y9ChQ1Cwr1wMHWizUd/WWa86UqwrCwtt95aLPV8xtAUd/nIvuoatZQB58YnPkGsF8L8TTOgM8KqNd9s1hiTmPL+GqdrYoLpH9Rvng720WB97wPnUXKO88NYIH9HGP4Ks/k39OeYGMLAsGJ9IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DM8PR11MB5591.namprd11.prod.outlook.com (2603:10b6:8:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.20; Thu, 3 Aug
 2023 09:19:34 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::f8a8:855c:2d19:9ac1]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::f8a8:855c:2d19:9ac1%7]) with mapi id 15.20.6631.046; Thu, 3 Aug 2023
 09:19:34 +0000
Date:   Thu, 3 Aug 2023 10:19:24 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
CC:     <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Subject: Re: [PATCH -next] crypto: qat - use kfree_sensitive instead of
 memset/kfree()
Message-ID: <ZMtxHI/O1293fmol@gcabiddu-mobl1.ger.corp.intel.com>
References: <20230802091427.3269183-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230802091427.3269183-1-yangyingliang@huawei.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: FR0P281CA0213.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::7) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DM8PR11MB5591:EE_
X-MS-Office365-Filtering-Correlation-Id: 09903592-d301-4088-0645-08db9402c053
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tIyzNP4rlB/+0nQIpfsgRXVFtIqAPIpjaQM88ZkiMKVi2wLvXzCc9BQLX4Di/TQ3z8P3/E+vxj7mVCYK+vmVUmQ72/SAaSvg/f5glfXTswGiGdT3Lf+dT4BgBuA7uqOHV9x8zhf38WC2AR3cgB7XEOSwZcBHnzeeH9Yz21sI3/XB0DPpVibm1fHFoHY17hHwOjeic6z7PZUKLeUHWOBL3MHS6aoom/NRLoRysKPRRTgAFIXQV7Mfp6mSDm5a+/9aUAoPYTq8VCV1osgiAYaJXeuX/wfMtYIQulI9frCYQ3dPVaifBqLv3lxHEA84gLBqDWp4L4dv2++Y8WbHgWllq971THWXHlVCc0tviaSA5pgModdIwsomtffl11ldw1u6A0+YTO3wKLmEOct+esKJCZFa9Dch1GIZw9C3cY40GgbHplSLa9A0l3ja+9/1yntd+JdfM4C6loYXr2c02jpL7KCUm2YhNZoI+LmhRFsW904gq9LYHoz7gxR8Soz6HwG1TlqaileqOSShe7n/+18716OmOjI2c0V9fDtfksq7f1o6Fx3quMph4iG+MWynL5CB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199021)(2906002)(44832011)(86362001)(558084003)(38100700002)(82960400001)(41300700001)(6666004)(6486002)(6512007)(66476007)(316002)(36916002)(4326008)(6916009)(66946007)(66556008)(26005)(6506007)(5660300002)(478600001)(186003)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X/zJ8TL2n3eYR2jv+ggwtDB/64wEq/UrjdaFxyqMtAraemZT4zdloKLDoR7L?=
 =?us-ascii?Q?ofZ7Hfc6L6DVpekWD4iGFAo+6o7ot16d/njdUpb/e3QLys0JvHYbKBZFPgVA?=
 =?us-ascii?Q?A3c/5t7Fupy+xabrSHkCSlCCjo2C6zeS9gmlJEo+vt+q+97twWkkABNSSpLo?=
 =?us-ascii?Q?i1KNrvJN/OnaqllZr4C0HuJilxrX3ykMy6mbiEX4q1IlbYzSlOlgz1+TYVdV?=
 =?us-ascii?Q?mgNtgQUhhocfX/SZRnrAWyMj2rFCQmfZPpbCeCzE49P3JwLAKR09mXU14MP1?=
 =?us-ascii?Q?an5neUCILTrNawvoPZM3PmO9uyn+Auqw+mePg4JS52XZRUXtrNROpTZxWEv/?=
 =?us-ascii?Q?JqF6vqiiVK0H4tmvAYbo1q7yvj/FWOFu1/v9Zm6bV0iANuqsiwCL5ciOwWp4?=
 =?us-ascii?Q?vkpoy3EPl6C1bk/5neIArLnlZoeFsAsBWwi7N3XgoigqrGxBlQVtHcDJiv0J?=
 =?us-ascii?Q?8d/6AZCeb5fWvVpNG8YCE43K8i4Omr9OzwWDioaZ5gbUTTSbNMx7qIs9tlo7?=
 =?us-ascii?Q?KV3vx2prDi/Pxle9WKzX9bIt4Sml5A5jV8MDuzApqAPKWVKoo+OR8a56avFQ?=
 =?us-ascii?Q?PzXZVBMG2t6eJd79aZUB5oYBBirDt4k+3CiHFuNeUw6advCSW8ATNye9mJTn?=
 =?us-ascii?Q?2C/DZXvHy4sDA87urwWD8tqyb/oPa5GKJS6Ij/mjPtc+dW0RjSQkxqPZ6ppY?=
 =?us-ascii?Q?fMKKXvfIYvlSUz2zXdaE03f6QPBPvBm5gEGH5y9SpgrW6fGKajrzbjw60tN3?=
 =?us-ascii?Q?6brtJAYRDjhdvZRd6gq3mpltYVeXbiwC9YNmhQACYVBKMaO8Ecc7lsG0ly6J?=
 =?us-ascii?Q?HhUAuwkQLHOpJcRhScd5/rzTP3IhufHAyw/i3sbxJzLfzjzkK7ScSu1uD36H?=
 =?us-ascii?Q?qZEz6lwHi4N8nqAYNWOOlBs9aTooGV9T+qQnA107j7aiaEsXitS//JHlGUWX?=
 =?us-ascii?Q?sjuGMGz9iBBJKoOABFC8+5RwX/4wrDUO1jJAy9+x3UGJH1mwM0UjRAmS41HL?=
 =?us-ascii?Q?dfhFjl7Y4eWcBoycz3JjtpuQwlG2tsrr9KDOn4yVj0vOS0fFM8xyohoOOjHr?=
 =?us-ascii?Q?hdYZMefdgC53BL1/6/UDVZKmiO6HYQU85erSNYOuq6+H4yqyz3VQ2I8WKDQL?=
 =?us-ascii?Q?GXF0uqZGMsb0IAoJZu3b/t/hCRzRnh6l1WJze0jwulr3kpYwK1QVoDHfhH1P?=
 =?us-ascii?Q?8zt3iwtkjHZ2n96LaYl0sj52+/5TbhWK0RewV9FmdwOazSGc2hvGfLzzpLWB?=
 =?us-ascii?Q?lAKuaMKmWRww5F1C52T1lMkXBWaqgEByEXe8572aMiVbzEYDiKBwLTLodbLC?=
 =?us-ascii?Q?KwR7b2vo18ZBQKXb2yIIf1/LyhltUMzxOEx2Ywiz6FDeBmyUfRjMVtjgLCba?=
 =?us-ascii?Q?ZWKzii0SQV5H8SWEMU5W3J91xQC4ACwi8+8U59Ur5IRSbaRJttiKMc9AHOxP?=
 =?us-ascii?Q?NdcQJ8jEE2A1KMaueqvLKNgqV0ACPexeiKKQFD/u32o4kdywuYucPYx7g0N+?=
 =?us-ascii?Q?vATVYJHzA6rC3oKaF90AySfNtiD5a6DU+0WfEs5Gd+nJPhMjNlpS5/jgu5cY?=
 =?us-ascii?Q?HNeMjzAIY4pblzVwz/DZaZ1icnRgqFbudOEDtehC5hvaSeKduwW8Q1uOBD1n?=
 =?us-ascii?Q?LA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09903592-d301-4088-0645-08db9402c053
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2023 09:19:34.2560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t5oWwo6S2iodD/W+QWrzyhhbCJNsfl40VVcZDvAmO6eZ8kuVMHbGHHR5B80INgpz2FRU8B15g+kujOCNBwEGNSYkJDdQ1Jzp22CNLENUW6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5591
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 02, 2023 at 05:14:27PM +0800, Yang Yingliang wrote:
> Use kfree_sensitive() instead of memset() and kfree().
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
