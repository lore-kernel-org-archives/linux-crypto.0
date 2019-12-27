Return-Path: <SRS0=+KeW=2R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD02C2D0C6
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 18:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21BA020722
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 18:38:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="2sOiBmv3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfL0SiH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Dec 2019 13:38:07 -0500
Received: from mail-dm6nam11on2048.outbound.protection.outlook.com ([40.107.223.48]:62561
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbfL0SiH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Dec 2019 13:38:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3Si+lbV4fMmmQKP2gLIm36MVJmcUNVKwEASebfIawofnbyvujCdyNI4hAMj1la4pi/G3OR00AVX80sfZPtRahX++MNeeU1a2cTwV0HOe4FEomHPTyqOJlMfGJ4n22N3ocNMNOUZg/549J3DDldSYfJHNfyuu1VamwMvi4LF+RBlVdVUBCJJdl4zCz6LiKu+23XgU+wHpcHix1UAJNGcXeRl8JEkrC/HS2+tiBp0ludf9LjKrLzQgHIgwfi0QSyvymDG64d0lSDND0wc7HZkjDLN/PPHPGvIWMm0UwzJinsPrBBvRDMxxCA0+/KzGy0iiK0UhmsEP90RYG45r3+xUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GppsT9s5zEVPgj8GZb9XWb5nwKOJlYeRtDABGY0DUcU=;
 b=RrMT2p44I235jRZ9cgOsHS6FAbjB5VVHiJEZkUgB6+F6Hn7kln+IJAptCrkSsce9kt/Pm1WItx7bmk7PH9LhRfjcwAsibsFQZDYuGKw575yW2aOTXQUpijseKZkxMAbExw8d8/UqPiQn4mRnvbcHH/zro2XIc+sEkkQw/bgwSXkGH7TniViq+O2HOn5LBAuFyW5UFcsNzzG6szSgohibkBvU5vUhRRsdoNDEsF/es4mKwNpq9NDerpY+F/XuJ5Q/rAjLytY1UgGTcetxhfO/4nIB3GsXCVRkBpPPc64+do4Vb4Fuof7nZzav+tuVRc46PDk+WA0grV1NwKp7wrWXNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GppsT9s5zEVPgj8GZb9XWb5nwKOJlYeRtDABGY0DUcU=;
 b=2sOiBmv3fsMHi6HEdk3BwcOazh7Bym5Vx1m9ykg79/ekIEl5EKQeEl9UOuz9yvh0zVJUO68QQZY6sHo+IpzYrVqskUiaUXEiA4e6AOJE4s3WnYqRzNq4uBGUztw1uNL5ipR1gx3NR4NrYEJR84Nyxb2sLQM3MmuNwZYZk7/7iDE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from BN8PR12MB2916.namprd12.prod.outlook.com (20.179.66.155) by
 BN8PR12MB3217.namprd12.prod.outlook.com (20.179.67.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Fri, 27 Dec 2019 18:38:04 +0000
Received: from BN8PR12MB2916.namprd12.prod.outlook.com
 ([fe80::45d0:ec5c:7480:8029]) by BN8PR12MB2916.namprd12.prod.outlook.com
 ([fe80::45d0:ec5c:7480:8029%5]) with mapi id 15.20.2559.017; Fri, 27 Dec 2019
 18:38:04 +0000
Subject: Re: [PATCH 4/4] Documentation: tee: add AMD-TEE driver details
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tee-dev@lists.linaro.org
Cc:     Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>
References: <cover.1577423898.git.Rijo-john.Thomas@amd.com>
 <25ce91ed381479fd0003d2b9670093b8c5cbf638.1577423898.git.Rijo-john.Thomas@amd.com>
From:   Gary R Hook <ghook@amd.com>
Message-ID: <91d1e931-40bf-7988-a413-3a93fc12dfb7@amd.com>
Date:   Fri, 27 Dec 2019 12:38:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <25ce91ed381479fd0003d2b9670093b8c5cbf638.1577423898.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0701CA0018.namprd07.prod.outlook.com
 (2603:10b6:803:28::28) To BN8PR12MB2916.namprd12.prod.outlook.com
 (2603:10b6:408:6a::27)
MIME-Version: 1.0
Received: from [4.3.2.105] (47.220.193.178) by SN4PR0701CA0018.namprd07.prod.outlook.com (2603:10b6:803:28::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Fri, 27 Dec 2019 18:38:03 +0000
X-Originating-IP: [47.220.193.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: edfa5c3b-92e7-477f-73a9-08d78afbe8a9
X-MS-TrafficTypeDiagnostic: BN8PR12MB3217:|BN8PR12MB3217:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB32170F5242E00F2ABEE658C8FD2A0@BN8PR12MB3217.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0264FEA5C3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(189003)(199004)(66946007)(66556008)(66476007)(110136005)(16576012)(54906003)(956004)(6706004)(6486002)(478600001)(966005)(4326008)(52116002)(186003)(2616005)(31696002)(5660300002)(8936002)(2906002)(81166006)(36756003)(8676002)(81156014)(316002)(26005)(53546011)(31686004)(16526019)(78286006)(84106002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR12MB3217;H:BN8PR12MB2916.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IZuVOviELy8RQUjlHGFoY9iV780zorloinAkPSJSoHjVXpkhrazAPLfufK4sETIEPR1RbPnXh9egwMfBaoZ2RH4xJTJJhkP5PAumwGNxRnrMHuw6mtd8ydQkJdF7X12DQgmdeomgRIVOoy5gbCQva11piBoYPGMB3sg/roJU1Vp2DrUMKTzbBhrMPhV7V/O1xZ2Pf8qx2H2TPtjQhTa4qcdcH118UpZhf2f0m6aobNDfaBVYkDFGJrI46/HTt67fd259Oin9+g57KngG1HC78BfOxkNHlTGDNxDHLeDAFHrrGy7saJVX2OqnUQRvwSA6vuBLBaDm8Q5Kjx4q87cPHv49HGxeZ5XnI4DX6er2Sy7kEwdoXZb4g+XjNVQ9SsTd77MBrrBNqg5zVpoq2d45hDISo0b3lZUzchZDG8nlxCFCGlgVHN0LatXBGHc2YJqOsOMaVjzLJNRA1drMKKOGZ0ccThJDeAxbFaCFSnhvcoXeIQITudY7Z28/byhfEk5zhzohyswoXNkZF0F7Ag7vhRyCO4Dh0OQ5sOT+3DueNL7UHi0O/QoCGthz2JLAyVMT
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edfa5c3b-92e7-477f-73a9-08d78afbe8a9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2019 18:38:04.3406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2deQbjokdFr6ImqpXncQdbJ6yjQRTrZIxbKlndqBaJcNfVc+TiuN8BUjJbp8LRtt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3217
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/26/19 11:24 PM, Rijo Thomas wrote:
> Update tee.txt with AMD-TEE driver details. The driver is written
> to communicate with AMD's TEE.
> 
> Acked-by: Jens Wiklander <jens.wiklander@linaro.org>
> Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>

Reviewed-by: Gary R Hook <gary.hook@amd.com>

> ---
>   Documentation/tee.txt | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 81 insertions(+)
> 
> diff --git a/Documentation/tee.txt b/Documentation/tee.txt
> index afacdf2..c8fad81 100644
> --- a/Documentation/tee.txt
> +++ b/Documentation/tee.txt
> @@ -112,6 +112,83 @@ kernel are handled by the kernel driver. Other RPC messages will be forwarded to
>   tee-supplicant without further involvement of the driver, except switching
>   shared memory buffer representation.
>   
> +AMD-TEE driver
> +==============
> +
> +The AMD-TEE driver handles the communication with AMD's TEE environment. The
> +TEE environment is provided by AMD Secure Processor.
> +
> +The AMD Secure Processor (formerly called Platform Security Processor or PSP)
> +is a dedicated processor that features ARM TrustZone technology, along with a
> +software-based Trusted Execution Environment (TEE) designed to enable
> +third-party Trusted Applications. This feature is currently enabled only for
> +APUs.
> +
> +The following picture shows a high level overview of AMD-TEE::
> +
> +                                             |
> +    x86                                      |
> +                                             |
> + User space            (Kernel space)        |    AMD Secure Processor (PSP)
> + ~~~~~~~~~~            ~~~~~~~~~~~~~~        |    ~~~~~~~~~~~~~~~~~~~~~~~~~~
> +                                             |
> + +--------+                                  |       +-------------+
> + | Client |                                  |       | Trusted     |
> + +--------+                                  |       | Application |
> +     /\                                      |       +-------------+
> +     ||                                      |             /\
> +     ||                                      |             ||
> +     ||                                      |             \/
> +     ||                                      |         +----------+
> +     ||                                      |         |   TEE    |
> +     ||                                      |         | Internal |
> +     \/                                      |         |   API    |
> + +---------+           +-----------+---------+         +----------+
> + | TEE     |           | TEE       | AMD-TEE |         | AMD-TEE  |
> + | Client  |           | subsystem | driver  |         | Trusted  |
> + | API     |           |           |         |         |   OS     |
> + +---------+-----------+----+------+---------+---------+----------+
> + |   Generic TEE API        |      | ASP     |      Mailbox       |
> + |   IOCTL (TEE_IOC_*)      |      | driver  | Register Protocol  |
> + +--------------------------+      +---------+--------------------+
> +
> +At the lowest level (in x86), the AMD Secure Processor (ASP) driver uses the
> +CPU to PSP mailbox regsister to submit commands to the PSP. The format of the
> +command buffer is opaque to the ASP driver. It's role is to submit commands to
> +the secure processor and return results to AMD-TEE driver. The interface
> +between AMD-TEE driver and AMD Secure Processor driver can be found in [6].
> +
> +The AMD-TEE driver packages the command buffer payload for processing in TEE.
> +The command buffer format for the different TEE commands can be found in [7].
> +
> +The TEE commands supported by AMD-TEE Trusted OS are:
> +* TEE_CMD_ID_LOAD_TA          - loads a Trusted Application (TA) binary into
> +                                TEE environment.
> +* TEE_CMD_ID_UNLOAD_TA        - unloads TA binary from TEE environment.
> +* TEE_CMD_ID_OPEN_SESSION     - opens a session with a loaded TA.
> +* TEE_CMD_ID_CLOSE_SESSION    - closes session with loaded TA
> +* TEE_CMD_ID_INVOKE_CMD       - invokes a command with loaded TA
> +* TEE_CMD_ID_MAP_SHARED_MEM   - maps shared memory
> +* TEE_CMD_ID_UNMAP_SHARED_MEM - unmaps shared memory
> +
> +AMD-TEE Trusted OS is the firmware running on AMD Secure Processor.
> +
> +The AMD-TEE driver registers itself with TEE subsystem and implements the
> +following driver function callbacks:
> +
> +* get_version - returns the driver implementation id and capability.
> +* open - sets up the driver context data structure.
> +* release - frees up driver resources.
> +* open_session - loads the TA binary and opens session with loaded TA.
> +* close_session -  closes session with loaded TA and unloads it.
> +* invoke_func - invokes a command with loaded TA.
> +
> +cancel_req driver callback is not supported by AMD-TEE.
> +
> +The GlobalPlatform TEE Client API [5] can be used by the user space (client) to
> +talk to AMD's TEE. AMD's TEE provides a secure environment for loading, opening
> +a session, invoking commands and clossing session with TA.
> +
>   References
>   ==========
>   
> @@ -125,3 +202,7 @@ References
>   
>   [5] http://www.globalplatform.org/specificationsdevice.asp look for
>       "TEE Client API Specification v1.0" and click download.
> +
> +[6] include/linux/psp-tee.h
> +
> +[7] drivers/tee/amdtee/amdtee_if.h
> 

