Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E393C64ED6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Feb 2023 18:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjB1SJo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Feb 2023 13:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjB1SJn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Feb 2023 13:09:43 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E6E1C599
        for <linux-crypto@vger.kernel.org>; Tue, 28 Feb 2023 10:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677607782; x=1709143782;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=iJNqaTzVAwU8IuVjv2QvXlG9GljF3p2rM3ug0/NGQiI=;
  b=a9pXbdllYrrr3ppCCpsDOKY8hJIA6k5qGzCc0UsNff6wDOwFCMwHihD+
   ffsVn9L//f5tJfCfpKm2iaGDZh1ATElLaMPtl2RrJdqTlGmbo72t2Is7G
   YhqMRrbbt2AC3V1KPswCVFeb+sTy2Lz2QTtT+IDJ0Au+UCCAehtBZyCOD
   MavWz44M9LecQdZkNsgX4MmwfuViaSMuXZXLCmUCLIyZpCY8PixjikZxM
   wd+xJcF7IdmhxTzPLDN+GwwL8AxlgLXQR0w7DJTnf+oQh3UQwhfTCEbAI
   BGYDaw4s+kX9sA7o1x/lLHxbsr3D0/ocATkcLMLgSm1NHkCsNxEBWJ/8C
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="336501073"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="336501073"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 10:09:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="763258589"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="763258589"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Feb 2023 10:09:41 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 10:09:40 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 10:09:40 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 10:09:40 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 10:09:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnZwO41lf5jFxkxLytO1Iq6UIJ4+j/6VVc0CoofOmX/nuF2w1kEBY7TzWX1qsGxFiSLtrK73aVRmwzmz0GCaO9YG3ENRE1tucpk4FM6cQ4742hI8RE3iSAsq2RemVGAbRqKaHUIYu2j8BQneEqlsmPT1QOd5/jHWLVwLsJbh/Zy6EXgJ6Rdrj+fVTCm58yU4waSwE6QnhwnIf9eiPAzH9fDq0E1UvtwIl1PSGGTOnUq6vmf2zr3WXcb6pm6vWZjJdWrjnkv3+GslJCYpyotBL4Onel64KNT2OhhxHhHOuqAvSN2YpHMT5xzHxjVgE9e7+kMm/emivBUDbiSmwgLEPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AA4JpgGbxnkY4daz21lf8Z+YkgVnAyKHoEO5nUbLp9M=;
 b=ezrN/1PaOjRgAc9cAGQL4WHOGL0Ns5GEUllgqf4/fE1TckLBhZGz/aiiEcKf34SfqbhMqsKIc9kWCc91xv9dge3k3yQ4vGb51KphHtenSvPpIi1DyCvNCXdVBgXw1x0LpZodtdjlV8pbZr4ZTLUevohoV6wwRogTPeZeQMcQxSq277/u0Y92/8YtH+6VR5+buzzcq4MkaOhHQ0gp2Nf5i663FtV6bTN4vrMjoPm5h5axcuduTx/vf1Qp78EDCjBI/TsdwUoZW0T6uNkWpg1XbLTBdWqysAJ3bNWC+jDLjIaSapsV8sad84lXId4I0Zdx4bx7POBC9SCMnoZkHZ0H5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SJ0PR11MB5917.namprd11.prod.outlook.com (2603:10b6:a03:42b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Tue, 28 Feb
 2023 18:09:37 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::af76:f08d:dc47:8f8d]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::af76:f08d:dc47:8f8d%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 18:09:37 +0000
Date:   Tue, 28 Feb 2023 18:09:26 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
Subject: Re: [RFC] crypto: qat - enable polling for compression
Message-ID: <Y/5DVkSpJ5pSD25V@gcabiddu-mobl1.ger.corp.intel.com>
References: <20230118171411.8088-1-giovanni.cabiddu@intel.com>
 <Y8pQ38EkAK/DVTJ2@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y8pQ38EkAK/DVTJ2@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO4P123CA0454.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::9) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SJ0PR11MB5917:EE_
X-MS-Office365-Filtering-Correlation-Id: 11c5a61e-a677-4402-3823-08db19b6f40f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lTObntZF9pAECTFQ/DnBRUY8qB85gSIJKNtb8G47w9Xg2uzIk/qY1dnCVZhk7k25iuvZxGHiKb3G+V24em2PBIPPf4lse5Eii9eq+hk8+TlBa6MbuxTl/KlvZI3gYT+Qnq8IoyNelZ8zjgr9gDyrW2iW8C9nQujkGW9hikzvctx/s1dk1nm1DKO4nLLrWJPv0djgdIbDgjHP9apw6ME2U3E7Gh75zSGjZSUw4Fi2unU6QSloKS5KLuo3ZAaIo/QuLKs6jLLyBV4/dOlkizYjrxv6j5Vkb5a/zZOfF3qWVI8XcsIa4FYahPsPv9XhgY3RxqMCIilJBZTBIJetwtIpKXqG2UwNhd/IMfcPCBHy91iz4YN/y0BdGo+yss0zrpuGoKkHsPSsqRrQ95SgqkpINpLyP5eSosNKrR8PkAJMheNTfRWTYrVkxS0jkP/Jw295bSU6ooixQan3HAnBvrifonoTmvPaB79qcaXBRIWQNwqZ2Twmn5gKOdQiXjTFD5PU373B2XXKsbapw8qV2t/KRvDUKM9Oux2jaME2Eq73dA1+vFqMgioGQsPQRut8IvIt6H99plUHP+adEntHEko6xqs6ywqkZB6J6Boh3fa/2dPlMK76uipiZlAswHKwwGidSq19OyTVMZqT2uHS9LhlcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(396003)(346002)(39860400002)(136003)(451199018)(66556008)(4326008)(26005)(186003)(44832011)(66476007)(478600001)(66946007)(6916009)(8676002)(36916002)(6486002)(86362001)(316002)(6506007)(6512007)(8936002)(5660300002)(41300700001)(38100700002)(82960400001)(6666004)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xgrcJcxDuvzBlkazIYQ/OtIY/OSFNK9TGfJMeoVhmcnVZmAjtYtprup39yPA?=
 =?us-ascii?Q?pN+0h0uyDa5mpTSFa7a4/9iuncO9/5szf1dlcPwrUIMfbTfWuM5OcnLmaeZL?=
 =?us-ascii?Q?ARBkzxRP6UIJiJXl5JErB6uzbpA+bq+EK2ls+O1wbDP38AkqV8MCq2Bup059?=
 =?us-ascii?Q?P+Le4mhyAa8axLkvwM2agTEzF43KDXUFhdEgP3i1v89ctCenbNlDGKfTS80D?=
 =?us-ascii?Q?5oo7gzTwO5diktQ5T5+YlKQtmXXFrI4KS1CgaRqGcUdrV7sjFWjr+zPZvdMt?=
 =?us-ascii?Q?XjXTIqpc1bGdhiqs1a/zWqlSHiv72DsqQxPh42OGKhyKP2GX+z8VTnWH2wW+?=
 =?us-ascii?Q?Nvqi2DqTRskx18wmylSu55MYVbnwtiQa/m2Unui1ALpCHrH+z8E09ZcqeUnK?=
 =?us-ascii?Q?I1PIE+JKfuhJZmLiAQmHHK7WCcMBuxvcxS42vBaQYGBUwCtKmvYNVTBY4Fmm?=
 =?us-ascii?Q?FBREi4bhPRml5tEzKgyBxQg6Jk6UxlqslF5INZnZy+nr9gTkKmfqruhwKuYc?=
 =?us-ascii?Q?1NHJr+h9A1/cE7UfMZiUjx5BE8It1JLBvZOWkygO4SJWVqpqRU25gBUNnxdI?=
 =?us-ascii?Q?vml0MfrOYjAlBCjJ8UaIeB4qC5ZYCDRLjhomfVeqrAs2qnwC+gr/Ygk4g/DQ?=
 =?us-ascii?Q?rJNOKs8rmY8kVtauJRPyKgTqV5ziqLY8g8/KFeJtvqGtTpz1NqNm2eEUXGtg?=
 =?us-ascii?Q?DkP70wk4YzLerhIlno9ysoVCdh2Mr8NqhW57MjWOIJ+tTwBYpZYBev8wtV0n?=
 =?us-ascii?Q?T5+87GvVhzQp9Z/ysuBZzKPcbLlXMz0k7WYcVRXw1NRLbWhJBmI4Ka2Pj5pR?=
 =?us-ascii?Q?DCNC2ugb9O1n3R/XSgVm7wycO8n4TAbstWe3O7DDhP3W9SyVNuF8YxSk56Xp?=
 =?us-ascii?Q?CLUUidyiIj6SoOXn28d6b6z8ycflYeSfWj8zTj5sLb5BHUVmYai1kbKpg/+b?=
 =?us-ascii?Q?DYnzLW6fndqqnLHDeTceFSl/UYoG2kp+FKJ5jXhydWw8TyROUjIaaN+z0cdg?=
 =?us-ascii?Q?lj5Hv0xBEWNefZyD6D1+ffmckskzQgUsvG+Q/iJtc5QXyQdfYawf5wxvS9Vs?=
 =?us-ascii?Q?mpFF3LMcHM3O7Dxz3H/yC0Yz45aP+nXJ+9r6w3qEKMWUdSIg0lc3afPjNNPA?=
 =?us-ascii?Q?XJ3gSEMKs2Tw+ArYxUyDZQC+SBTuPpGFoFoGxRYvRINRKP0hL1AHJztOpBAU?=
 =?us-ascii?Q?2irxTV32mB7PEoS3o09Qt/DszCSl6Q9etwAOuVT4RCYmTRP8IQEMIu8438w9?=
 =?us-ascii?Q?1QPd5ANuvXwPLyhjapFGk/ymQxryQF3I+BOEN1PjkIR0bB1YBmPADxxFdVjk?=
 =?us-ascii?Q?b7p5fUMeu6RAQ/VuOOoycaLGh4vWuc0lFRa9wZEFJDu7zOzQyTxYrrw81Dkr?=
 =?us-ascii?Q?s24Mu4opz+peCnS2ZunPTNQ4W26ttFmotmgBrcxtbZI/SRUNA4vEv/ate1Tk?=
 =?us-ascii?Q?3lj9JdU13ZAKb4X/APN+UETxrYmmlSCOU39zJdPE+WbwDaPmkd1Ce6PaCbu+?=
 =?us-ascii?Q?BNLvVt4fruH2edCPExw/FASephtv12flvSWB8iTljG8Z9OTIeLPc208tWzdZ?=
 =?us-ascii?Q?yjdmDJrBEUqNFTu5OsWOWY0gzW3rsRvCAnn9IxFburxOwfmNGeVNuwS225ik?=
 =?us-ascii?Q?AQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c5a61e-a677-4402-3823-08db19b6f40f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 18:09:37.4468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I3/h/o16D9TY7Jfs4fJczP4BeScCb7BryR3lxa4Nd7EQEEEZcgLNK7MbODN3lnok7UWHa5fEWxh7f1YpUzgWT8/PwdzwAyk5p4Jv4f7AwZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5917
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks for the feedback Herbert!

On Fri, Jan 20, 2023 at 04:29:19PM +0800, Herbert Xu wrote:
> Giovanni Cabiddu <giovanni.cabiddu@intel.com> wrote:
> > When a request is synchronous, it is more efficient to submit it and
> > poll for a response without going through the interrupt path.
> 
> Can you quantify how polling is more efficient? Does it actually make
> an observable difference?
Yes it does. In average 2x faster for c62x and 3x faster for 4xxx.

> 
> > This patch adds logic in the transport layer to poll the response ring
> > and enables polling for compression in the QAT driver.
> > 
> > This is an initial and not complete implementation. The reason why it
> > has been sent as RFC is to discuss about ways to mark a request as
> > synchronous from the acomp APIs.
> 
> What existing (or future) users would benefit from this?
At the moment only zswap as it uses acomp synchronously.

> 
> You could poll based on a request flag, e.g., the existing MAY_SLEEP
> flag.
Thanks.
I might need to do it per tfm as it requires re-configuring the ring
pair and has an impact on all requests sharing the same.

BTW, I found an issue in the previous version of the patch. Below a new
version in case someone wants to try it.

Regards,

---8<---
When a request is synchronous, it is more efficient to submit it and
poll for a response without going through the interrupt path.

This patch adds logic in the transport layer to poll the response ring
and enables polling for compression in the QAT driver.

This is an initial and not complete implementation. The reason why it
has been sent as RFC is to discuss about ways to mark a request as
synchronous from the acomp APIs.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_transport.c | 28 +++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_transport.h |  1 +
 drivers/crypto/qat/qat_common/qat_comp_algs.c | 15 ++++++++--
 .../crypto/qat/qat_common/qat_compression.c   |  2 +-
 4 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 630d0483c4e0..af613ee84cdc 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -133,6 +133,34 @@ static int adf_handle_response(struct adf_etr_ring_data *ring)
        return 0;
 }

+int adf_poll_message(struct adf_etr_ring_data *ring)
+{
+       struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(ring->bank->accel_dev);
+       u32 msg_counter = 0;
+       u32 *msg = (u32 *)((uintptr_t)ring->base_addr + ring->head);
+
+       if (atomic_read(ring->inflights) == 0)
+               return 0;
+
+       while (*msg != ADF_RING_EMPTY_SIG) {
+               ring->callback((u32 *)msg);
+               atomic_dec(ring->inflights);
+               *msg = ADF_RING_EMPTY_SIG;
+               ring->head = adf_modulo(ring->head +
+                                       ADF_MSG_SIZE_TO_BYTES(ring->msg_size),
+                                       ADF_RING_SIZE_MODULO(ring->ring_size));
+               msg_counter++;
+               msg = (u32 *)((uintptr_t)ring->base_addr + ring->head);
+       }
+       if (msg_counter > 0) {
+               csr_ops->write_csr_ring_head(ring->bank->csr_addr,
+                                            ring->bank->bank_number,
+                                            ring->ring_number, ring->head);
+               return 0;
+       }
+       return -EAGAIN;
+}
+
 static void adf_configure_tx_ring(struct adf_etr_ring_data *ring)
 {
        struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(ring->bank->accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_transport.h b/drivers/crypto/qat/qat_common/adf_transport.h
index e6ef6f9b7691..d549081172f8 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.h
+++ b/drivers/crypto/qat/qat_common/adf_transport.h
@@ -16,5 +16,6 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,

 bool adf_ring_nearly_full(struct adf_etr_ring_data *ring);
 int adf_send_message(struct adf_etr_ring_data *ring, u32 *msg);
+int adf_poll_message(struct adf_etr_ring_data *ring);
 void adf_remove_ring(struct adf_etr_ring_data *ring);
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_comp_algs.c b/drivers/crypto/qat/qat_common/qat_comp_algs.c
index b533984906ec..a55a1a66080a 100644
--- a/drivers/crypto/qat/qat_common/qat_comp_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_comp_algs.c
@@ -53,6 +53,7 @@ struct qat_compression_req {
        struct qat_alg_req alg_req;
        struct work_struct resubmit;
        struct qat_dst dst;
+       bool in_progress;
 };

 static int qat_alg_send_dc_message(struct qat_compression_req *qat_req,
@@ -246,6 +247,7 @@ static void qat_comp_generic_callback(struct qat_compression_req *qat_req,
                res = ctx->qat_comp_callback(qat_req, resp);

 end:
+       qat_req->in_progress = false;
        qat_bl_free_bufl(accel_dev, &qat_req->buf);
        acomp_request_complete(areq, res);
 }
@@ -333,6 +335,7 @@ static int qat_comp_alg_compress_decompress(struct acomp_req *areq, enum directi
                return -EINVAL;

        qat_req->dst.is_null = false;
+       qat_req->in_progress = true;

        /* Handle acomp requests that require the allocation of a destination
         * buffer. The size of the destination buffer is double the source
@@ -384,10 +387,18 @@ static int qat_comp_alg_compress_decompress(struct acomp_req *areq, enum directi
        }

        ret = qat_alg_send_dc_message(qat_req, inst, &areq->base);
-       if (ret == -ENOSPC)
+       if (ret == -ENOSPC) {
                qat_bl_free_bufl(inst->accel_dev, &qat_req->buf);
+               return ret;
+       }

-       return ret;
+       do {
+               schedule();
+
+               adf_poll_message(inst->dc_rx);
+       } while (qat_req->in_progress);
+
+       return 0;
 }

 static int qat_comp_alg_compress(struct acomp_req *req)
diff --git a/drivers/crypto/qat/qat_common/qat_compression.c b/drivers/crypto/qat/qat_common/qat_compression.c
index 3f1f35283266..d7420de65dc7 100644
--- a/drivers/crypto/qat/qat_common/qat_compression.c
+++ b/drivers/crypto/qat/qat_common/qat_compression.c
@@ -174,7 +174,7 @@ static int qat_compression_create_instances(struct adf_accel_dev *accel_dev)
                msg_size = ICP_QAT_FW_RESP_DEFAULT_SZ;
                snprintf(key, sizeof(key), ADF_DC "%d" ADF_RING_DC_RX, i);
                ret = adf_create_ring(accel_dev, SEC, bank, num_msg_dc,
-                                     msg_size, key, qat_comp_alg_callback, 0,
+                                     msg_size, key, qat_comp_alg_callback, 1,
                                      &inst->dc_rx);
                if (ret)
                        return ret;
--
2.39.1


