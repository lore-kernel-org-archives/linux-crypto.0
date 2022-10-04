Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5456DC433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Oct 2022 04:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJDEl3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Oct 2022 00:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJDEl2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Oct 2022 00:41:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::60f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8503B950
        for <linux-crypto@vger.kernel.org>; Mon,  3 Oct 2022 21:41:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8wSXsOeRjOU1FTHVX7INk5bp10azSYYN3YOl7tRZvD8JiJ8eaB/ejF30AvKVhHcG6ICzSUeB0rMTZeOXRumN7sAQUn/q2uLCBJVb9ee1iC8knlwzntHG3C3saPCdTO/Dyu1r+JRNadL9yuDlLIc8r7rVm2d6/GVrmWaxPGekboCMFOKLD5mgFYlKLQg4zqS++Bh+4kRTH/yaU6a3LCheFUS1nEgr7d7I6HsxleBGNEmNyLF5fbyahQHqUMWhoE8ujfQGZUR6Rgf4gIt+3kBw+Xa+APM/ZFn+g5ZS1WUurRkBLiEgjSK5QctF3dD7Bg0f8jYNRt3oLS02zKLHaw89w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yv5SyUQX+nsDNUZs2+K+rAv3cVJLBMe8TaU45PSEtl8=;
 b=MNUDDDL3k5xBK4YTMCFyicsEbhMi72oiuTy2NReamwU+kkJNBtc5//g0YqVUVFrcLAM9A5o0+ZoFyt0uhriJP6c1aanUeKs7umCtlGo5TJVUaMCFFSrV6loSg9eyRED5Su4Qx9RGTIGIpn86HsTREj8inmLgtCAn874iuyqQX888gvG34qwVnh9G/R74QFh4ZzQRDR7smMHhjixmhALySFhfEpghYx9EXBny+MmFqpH7l0BYwr8G8wwWCvXXTLEtJWEWSwobYj0fQ3QEjBmkZZzO81IXFr0N40re8xYuzbMgUFw9wSstYK/neTL3n11x928ke/0TO2i4nvSoK8HCqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yv5SyUQX+nsDNUZs2+K+rAv3cVJLBMe8TaU45PSEtl8=;
 b=pwnuNxoeCmDSKrA/br/nt1BWDUbVjho+PrEbEL2zxaHP9yo3aB949zAKSXH0CsxMcVXXzWJaGXDGWacDJZ9RUr4q+INR/Ug3LQLVQ2mHmGojqNcBbiuHEZfNVFzS/7juvjNZoAgjkCKpUNW26oS7wsFyBGSVJ2IYl77QDUNDSMk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 BY5PR12MB4180.namprd12.prod.outlook.com (2603:10b6:a03:213::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Tue, 4 Oct
 2022 04:41:21 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::e0fb:6f05:f125:c002]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::e0fb:6f05:f125:c002%3]) with mapi id 15.20.5676.028; Tue, 4 Oct 2022
 04:41:21 +0000
Message-ID: <c6fb9b25-a4b6-2e4a-2dd1-63adda055a49@amd.com>
Date:   Tue, 4 Oct 2022 10:11:10 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     herbert@gondor.apana.org.au, davem@davemloft.net
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>, ketanch@iitk.ac.in
Subject: Early init for few crypto modules for Secure Guests
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0219.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::13) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|BY5PR12MB4180:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cbeeec7-d3a8-4f19-b53d-08daa5c2af5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MbVdaJKK03qVPr+w4VytYt6YzU8KpWeKQhBgY5CG5N71DI33wqTICBdR66RRaJMnZBye3t44YxjLOpntY3Xd8QN6SRtgx45AEoG8bdAK9Rft3wfYeeuxzfekSxWfQWTLvvhtEbYIWY1u8R4lSukbsHh2QkgE/GMb7YWNgj3GU2AciAkwOUbxIUnmRU3LBg2Ta6x4rzYmnR4Vz4vvEagFKZ80MdRT6pGSs7vu7HorhMHDRV8UZd9M4k60OAGNVzwsnNNMNcNeWZPAQCW2mwT6HeHHiVFBz66cx6pmWjts2oikgmBu4SAdFHJ6f+DCsiNXcCCnGcvnpIrQI88KLCCaaImrKAB38XLng2blmy9Bo6ql1NFxkfj2QOp35hoTTxT/OeQQGx5hi2ykBOCLqvHEXDbDOlgD/nzd/l1zaY76Knsm5kORahhHo9a8Zp0OD8OePplJjCYJIx50akwYZcpjJXeeYrkfpDXyGL36tXyDQLrq86OKCi9WFOOBRv63aUMxH4PpxhLBuwVtShiNMaQROzQIufqcSST2SJCUM4rB8/ShuIvp3YAig14LG5bfawwgkBbOSPBIvZa1UajWUZhSZVTrk/RwpxarcJhs3tDiJpmhXSZkkRVMVlRDWBP8k4UGJxm3rvQ2Y+jZSGIYmVkClwaQw4YYm7dggeVyZANZ0py1TfVl3k5yAIW3RPTEXpaWx7EqDhADA+xGRY924IxhHtNG4n9pn8zz0AJfyFBk+uTS2DPmWrPBcWy/FcfTxZZk7FYXCcwEY941M7NdrGa2frYiuVAjRdhXOIbytf1LU1C34IDURQh2NRd3atYGXaMuyuinnjCDWi1E+NqVEhLnK1DBQlncY8YbPfDfZILzH0Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(451199015)(31686004)(8936002)(6512007)(26005)(186003)(6486002)(31696002)(2616005)(966005)(66556008)(6666004)(6506007)(36756003)(83380400001)(478600001)(4326008)(8676002)(66476007)(2906002)(38100700002)(66946007)(316002)(41300700001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWUyL3BwZ0h5RnVBV3dldmtmLzd2MGJZT1VadHNNYWxTRjZDbFUvRzgzcHRp?=
 =?utf-8?B?T2N1aExibkZQeUJoVDJNZ3lnUFNxS20rOUV1alpONXRKSEhJdTAxMlhiYlll?=
 =?utf-8?B?ajNtQnBabUpIaXF4TkdEeC9EMXRiTUF1cmtDYmVaQXZQeTQzWTVvOTlPTEdS?=
 =?utf-8?B?ckdEVGtReW84UHdWckhNRTV0K1Q0VnE3dXM0ZUVZVHFBWU9hTjEranZzSGlD?=
 =?utf-8?B?RGlqZGlYTVVWYkI0R3NwU2Z3UEJqbVFteHVPbXRiZkJIYjNYNDhyZE9nYkEw?=
 =?utf-8?B?MUUyNHJzVVArdEJvQnUyejZJS0dWOFF3YTN3Zm1qVHN5T05CbUdlaVVKcFJB?=
 =?utf-8?B?WXQ3WkRGbkhGNmptcngxUFVYVXM1Yk5IMS90anpzUWlOSW10TndxSnN1R0Rx?=
 =?utf-8?B?Tm9lWi9naGxoa1hyWGo1MGtHdVRsTWMvMjRiTWlydWdpWEg5Ti9YVFZFR1ht?=
 =?utf-8?B?bkxFM3Q4VndBTnBnQSsvM2t5WXJkS0UvbWhTZTRJL1hQODdoWHN2eVlaZUQ5?=
 =?utf-8?B?eDNpQzdmbWVuUWhDLzdqcTB4ZldvQ2N5MWFqZU9KUVM5NjBZZVBZYWVUaDlF?=
 =?utf-8?B?Y3JYb3RiZzJTKzlqNzN2UjltMS80MUlvVXNQN1hmcnV5U1lwNmJKZWFtOHNT?=
 =?utf-8?B?cDFTdFV0elZmS1VUSFk3TStIQ21oWXpTUGVMNzJZaDlOWUNVZmpQQ2VzUHMz?=
 =?utf-8?B?Q2h6Lzg5NitzR1YzTGdjS240MjV0QUt0L0wxR2pGWUYwNzNwakdpem9JQTVh?=
 =?utf-8?B?Nko3a0Fia0xEY2xJTHJuT3BiRmNxdWR1RVpIWHgzV2FoTVBEVko2V3F0VDBD?=
 =?utf-8?B?d05HQkdnY2pPUGNYWGtjQy9vMm15dXdhSnZobngvSEpkR3UwMlR6STF2UGUw?=
 =?utf-8?B?NEpmbERkN0VwY3JhRWRDUGtkaU1tRnpZdjFZRTFSV0JxWDc4Ui9WYzRERE9Y?=
 =?utf-8?B?L1BCa1NRcjYwcU1hYTJGOENYOTFmM1dlNWNUVFdtaGhvUTR2d3psbHdINlJx?=
 =?utf-8?B?Wk5wSzJoUWd5WVVpbWVGUWFnTHB3NjNRREFOejZZNmZ4d2VYSDBYZnNuWkgz?=
 =?utf-8?B?T1pnYkRwaEQ4SVpBclRabFlkUi9qQnFkdGo5RTRXVWpZc0ZKUjc4cXViTEVz?=
 =?utf-8?B?T1pVdVFFVWFpZW5sNmVBMW1nMWR6VjA2SmFFOTVidWVEWEw0YWxmWmZreHRN?=
 =?utf-8?B?a2ppd3NYSDNibzBZSnZFazZxQjZ3UDNKVWJkVk12YkpPOVdjNWM4ak1yNkZE?=
 =?utf-8?B?ZjlMSGU4WTg0MmJtMG1oMFlzNmluSnlwOE9NL01EaGQwWXQvcmdWekRPdlVE?=
 =?utf-8?B?M0taMG5lOXU3Y0lhczJSSHF3VGJnSmlvQVdrUkQ1bHZzYTJiaXRWL0dTanRu?=
 =?utf-8?B?QU9jOWJscXdvdDJCSDVybmhuSEFDMnlBTFhsbDhpeFhncWtHN0lTb3ExQkUw?=
 =?utf-8?B?bDlYWnM4UkNsVVVsT213NVV3ZENYa3g0MmhmS2xnZTZBdVBZOHN3SWgrR3FB?=
 =?utf-8?B?NUQ3SWtLQkJpa1RzaEMrNm50bzVLQVlwSkVZcHB1ekdCb1JYWUlKaGpVd2Fa?=
 =?utf-8?B?ay9aZmtXeXdyeklGUk5sSWF5MHhHK01sbXhSS1JEcEM0bTVCbU5DUjdTeDRM?=
 =?utf-8?B?K0Q5WjFvSGFQMDltNEhGZzJJUGloZDhYYjNGZGp3SjVBeVVuSjRaVHlOL0pq?=
 =?utf-8?B?UDE1a3Azck5PV3JOL2NBOXJ0ZWdvZXduekpjTmR5UE0xdG9maU1QcVo2SU1v?=
 =?utf-8?B?dHdQNkRLOWhKSVFsSk1MNERVNVNMbGcydHZCTm4ybE5pcE9XL1dua0doVzNY?=
 =?utf-8?B?TjJMQmF3eHpDeWFOcTJydkRrM3dRc3pYVS9lNFJYZk5tb1FZclh1WnVndjdD?=
 =?utf-8?B?T3Y3OXlVM051TkdQUHJpaGZTWWxBTytZN3ZVOTRLSkJKakdjcmZkSGxCV2gz?=
 =?utf-8?B?Ui84UkllVEdpbUFWVFRuQzcrU3l5UXpnNXAzK1U3Wk1vYXBKRmV6YjUrajA4?=
 =?utf-8?B?TVZDbm9zRlZ0Q2EzU3NGWjU0enZBcjNSeExrQVhtYkR3S1JHdTd2ck9xSWlt?=
 =?utf-8?B?V1FLOXZhVXdkcUJubjZ1LzhYeGJCOG5vRTVCY2svYVR6cmVrVkd2K2o4a3g2?=
 =?utf-8?Q?ih9wn2bDz1/iJDxF3wE6cI5VH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cbeeec7-d3a8-4f19-b53d-08daa5c2af5b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 04:41:21.1701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +TRVavxnMeWuICS8Mqn4JkVsyZMKaQvDXG00NoS11P7EHsIa4M1iKgdoSUMwlQsT7RhZqQLVEZ9Xu5JOggIP0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4180
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi!

We are trying to implement Secure TSC feature for AMD SNP guests [1]. During the boot-up of the 
secondary cpus, SecureTSC enabled guests need to query TSC info from Security processor (PSP). 
This communication channel is encrypted between the security processor and the guest, 
hypervisor is just the conduit to deliver the guest messages to the security processor. 
Each message is protected with an AEAD (AES-256 GCM). 

As the TSC info is needed during the smpboot phase, few crypto modules need to be loaded early
to use the crypto api for encryption/decryption of SNP Guest messages.

I was able to get the SNP Guest messages working with initializing few crypto modules using 
early_initcall() instead of subsys_initcall().

Require suggestion/inputs if this is acceptable. List of modules that was changed 
to early_initcall:

early_initcall(aes_init);
early_initcall(cryptomgr_init);
early_initcall(crypto_ctr_module_init);
early_initcall(crypto_gcm_module_init);
early_initcall(ghash_mod_init);

Thanks,
Nikunj


1. AMD APM Vol-2 (15.36.18 Secure TSC): https://www.amd.com/system/files/TechDocs/24593.pdf
2. SNP ABI Spec (7.9 TSC Info): https://www.amd.com/system/files/TechDocs/56860.pdf
