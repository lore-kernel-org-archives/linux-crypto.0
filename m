Return-Path: <SRS0=MPLy=2O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E8FC2D0CF
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Dec 2019 10:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 878D420643
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Dec 2019 10:56:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="EC6qJRqg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfLXK46 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Dec 2019 05:56:58 -0500
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:6095
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726091AbfLXK46 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Dec 2019 05:56:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPPwBZyAGydGkSDfoR35iLAtU4vfwBuQETNGi6mW6ppBzOLUMChcMEKta8Om9SUv8EgWYHwcEK1cFGvWfvtXnnn26mlO/yoLTeoMXW1t/w1nz4PQEkrjzIL3iJi8xSFOuA0tnyeYbugAE/mzMb1ndLK1r4FzrP+sM5/yMa8/IRHyoRagkf/fy3lAldi6M3xVmZ/z9d4xnaEAFRX2iRU+bYyMHdrlDsbrK54FkNpVTYzQCZeufhpuWB54pqKkC6I0pPLs3xObAA3WRmj7D3SonlipBuKBlVh/Z+F5mVZ9u+/43yNclnLKKuIjgDmH7uKFHYWZ+uo4HPPkJe9JGo5HBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSFrervQ0xvaIKWEzukmB7SKU3qHjBp/VALqj3r6EGo=;
 b=juFTfCIKQHRc2Wl3OhMx6sq9fIDNy/DI32pYQZoQFq7Srbsrkvq6gJsOmeaZpvh1pg+gIfwkR9PdCPtaoROH25Xf1Feec2DypXGIeP08khFIU1uZCVTRl65fpYh7hIRCM8LrZIdzDyPu7KvvGP0+lHXYZnqpJTw6pssBqY74R3tTi9BEjdf8rVcbCOs8HbQtnJSgaYwaYK/AkZUt/wCU0TuNFpGqjOcCSw1NDP5OnF23WB55Qo3P3aUUpF7SElpr1bf8TUEptF3WaI4hqcid9vyZODhvecF6twc3J97arFZ+Obdv1HUa47lFlAaAQZfdRNH8hWnqLJNjkGtl9x1fXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSFrervQ0xvaIKWEzukmB7SKU3qHjBp/VALqj3r6EGo=;
 b=EC6qJRqg5Ja6zmC7jlKiRnTh6oq0FR3JU/gb8mVUJBgPVtoXc9BJqDdGyEBkv2VN1IvvBaKZTf/gbYCYf7BQ9jceYJd6oH4TS1l6ih8/CbGas8LStYWTEqiWmx4ewSHZ9zYp5LmqZstRPPEUF+wC9gqSiiuob2ukwxEns4hw6g0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Rijo-john.Thomas@amd.com; 
Received: from CY4PR12MB1925.namprd12.prod.outlook.com (10.175.62.7) by
 CY4PR12MB1272.namprd12.prod.outlook.com (10.168.167.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Tue, 24 Dec 2019 10:56:14 +0000
Received: from CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2]) by CY4PR12MB1925.namprd12.prod.outlook.com
 ([fe80::9be:baba:170f:3e2%3]) with mapi id 15.20.2559.017; Tue, 24 Dec 2019
 10:56:14 +0000
Subject: Re: [RFC PATCH v3 0/6] Add TEE interface support to AMD Secure
 Processor driver
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <cover.1575438845.git.Rijo-john.Thomas@amd.com>
 <20191220070439.etvk73fedrijsrgm@gondor.apana.org.au>
From:   "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
Message-ID: <a0c7cbd0-2195-195b-d753-7cbadfd4a272@amd.com>
Date:   Tue, 24 Dec 2019 16:25:55 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20191220070439.etvk73fedrijsrgm@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0018.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::28) To CY4PR12MB1925.namprd12.prod.outlook.com
 (2603:10b6:903:120::7)
MIME-Version: 1.0
Received: from [10.138.134.82] (165.204.156.251) by MA1PR0101CA0018.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:21::28) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 24 Dec 2019 10:56:11 +0000
X-Originating-IP: [165.204.156.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 56c63924-8aa0-4942-14a9-08d7885fe4f0
X-MS-TrafficTypeDiagnostic: CY4PR12MB1272:|CY4PR12MB1272:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB12728A1B823078D039E788CDCF290@CY4PR12MB1272.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-Forefront-PRVS: 0261CCEEDF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(396003)(136003)(376002)(189003)(199004)(81156014)(2906002)(81166006)(66946007)(186003)(5660300002)(26005)(16526019)(956004)(2616005)(66556008)(8676002)(66476007)(966005)(8936002)(36756003)(316002)(31696002)(86362001)(53546011)(16576012)(6916009)(52116002)(54906003)(6666004)(478600001)(31686004)(4326008)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1272;H:CY4PR12MB1925.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NidpCj/cErx1l4mcfaWWXXUjKDEc93N8JcF4HuBm5K8C6ektTtPt5L0zo22IRmWkZvsevn9089o+OVlM22SmQqTtcIRIQSljDkMyTmaLbT8oGmfHy8p7cf2L3az9Yagln8bX0qxajPh6Tb2kZVbvUothXXhCJzogXD9KxhcsR1Wtbe7Plu2sc3i+pHs4afdKZ0cIpSphfrGd400JehrXQ9NV+EiCW9WszWDwq+5FNbmQ2875wC9XxiJz4Hrr2kNMwIysbslXSJQn7CnkdiK4viJOU78CTo9g048IFrsd9vdfhQn9WErABkEjRwDkWvB+oAbo+JcA/j6iKK4dz9pzWxQOseOjWrkGQJiewke2kPzRtDNHoRBm4lhTW3FFxjtuTTZusu91FMvpvWzgo3dbGP9Qo4Q1EBAO7gAT+mdZW3J9mAfkLs6P0YDaOO6Rkq93Eahysl0CTLGmeRqM8V3ytL1Po53pwId2o7wQ/GpRZ3Q=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56c63924-8aa0-4942-14a9-08d7885fe4f0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2019 10:56:14.2383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FEG+WloH22A3PeG8N42LG4BPkaSEu8NX3ZE3rJfkFF6R0iMsyLTwxl42xArX9DHV8BH6UuPTdrz7Dtna/uMzug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1272
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On 20/12/19 12:34 pm, Herbert Xu wrote:
> On Wed, Dec 04, 2019 at 11:48:57AM +0530, Rijo Thomas wrote:
>> The goal of this patch series is to introduce TEE (Trusted Execution
>> Environment) interface support to AMD Secure Processor driver. The
>> TEE is a secure area of a processor which ensures that sensitive data
>> is stored, processed and protected in an isolated and trusted
>> environment. The Platform Security Processor (PSP) is a dedicated
>> processor which provides TEE to enable HW platform security. It offers
>> protection against software attacks generated in Rich Operating System
>> (Rich OS) such as Linux running on x86.
>>
>> Based on the platform feature support, the PSP is capable of supporting
>> either SEV (Secure Encrypted Virtualization) and/or TEE. The first three
>> patches in this series is about moving SEV specific functions and data
>> structures from PSP device driver file to a dedicated SEV interface
>> driver file. The last two patches add TEE interface support to AMD
>> Secure Processor driver. This TEE interface will be used by AMD-TEE
>> driver to submit command buffers for processing in PSP Trusted Execution
>> Environment.
>>
>> v3:
>> * Rebased the patches onto cryptodev-2.6 tree with base commit
>>   4ee812f6143d (crypto: vmx - Avoid weird build failures)
>>
>> v2:
>> * Rebased the patches on cryptodev-2.6 tree with base commit
>>   d158367682cd (crypto: atmel - Fix selection of CRYPTO_AUTHENC)
>> * Regenerated patch with correct diff-stat to show file rename
>> * Used Co-developed-by: tag to give proper credit to co-author
>>
>> Rijo Thomas (6):
>>   crypto: ccp - rename psp-dev files to sev-dev
>>   crypto: ccp - create a generic psp-dev file
>>   crypto: ccp - move SEV vdata to a dedicated data structure
>>   crypto: ccp - check whether PSP supports SEV or TEE before
>>     initialization
>>   crypto: ccp - add TEE support for Raven Ridge
>>   crypto: ccp - provide in-kernel API to submit TEE commands
>>
>>  drivers/crypto/ccp/Makefile  |    4 +-
>>  drivers/crypto/ccp/psp-dev.c | 1033 ++++------------------------------------
>>  drivers/crypto/ccp/psp-dev.h |   51 +-
>>  drivers/crypto/ccp/sev-dev.c | 1068 ++++++++++++++++++++++++++++++++++++++++++
>>  drivers/crypto/ccp/sev-dev.h |   63 +++
>>  drivers/crypto/ccp/sp-dev.h  |   17 +-
>>  drivers/crypto/ccp/sp-pci.c  |   43 +-
>>  drivers/crypto/ccp/tee-dev.c |  364 ++++++++++++++
>>  drivers/crypto/ccp/tee-dev.h |  110 +++++
>>  include/linux/psp-tee.h      |   73 +++
>>  10 files changed, 1842 insertions(+), 984 deletions(-)
>>  create mode 100644 drivers/crypto/ccp/sev-dev.c
>>  create mode 100644 drivers/crypto/ccp/sev-dev.h
>>  create mode 100644 drivers/crypto/ccp/tee-dev.c
>>  create mode 100644 drivers/crypto/ccp/tee-dev.h
>>  create mode 100644 include/linux/psp-tee.h
> 
> All applied.  Thanks.
> 

Thank you for pulling in the changes!
Can you also pull in the patch series titled - TEE driver for AMD APUs? It is
related to this patch series.

Jens who is the TEE subsystem maintainer has given an Acked-by for the
patch series. Please refer link: https://lkml.org/lkml/2019/12/16/608

Thanks,
Rijo
