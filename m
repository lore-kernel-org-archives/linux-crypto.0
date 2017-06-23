From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH 0/3] Introduce AMD Secure Processor device
Date: Fri, 23 Jun 2017 16:23:59 -0500
Message-ID: <771a32f1-4afb-daf8-2da5-3f9e5c7a4551@amd.com>
References: <20170622114204.4361-1-brijesh.singh@amd.com>
 <20170622132539.GA14239@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Hook, Gary" <Gary.Hook@amd.com>,
        thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0053.outbound.protection.outlook.com ([104.47.36.53]:52822
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752606AbdFWVYG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 17:24:06 -0400
In-Reply-To: <20170622132539.GA14239@localhost>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 06/22/2017 08:25 AM, Pavel Machek wrote:
> On Thu 2017-06-22 06:42:01, Brijesh Singh wrote:
>> CCP device (drivers/crypto/ccp/ccp.ko) is part of AMD Secure Processor,
>> which is not dedicated solely to crypto. The AMD Secure Processor includes
>> CCP and PSP (Platform Secure Processor) devices.
>>
>> This patch series adds a framework that allows functional component of the
>> AMD Secure Processor to be initialized and handled appropriately. The series
>> does not makes any logic modification into CCP - it refactors the code to
>> integerate CCP into AMD secure processor framework.
> 
> Ok, so this is just preparation. When finished, what services will it provide
> to Linux userland?

Yes, this is in preparation to add PSP [1] and SEV (Secure Encrypted Virtualization)
[2] support. When finished, the SEV will provide:

a) in-kernel API to communicate with SEV FW inside the AMD Secure Processor
b) userspace ioctl to manage the platform keys/certificates

I have posted PSP and SEV patches as part of SEV RFC, see below

[1] http://marc.info/?l=linux-mm&m=148846780431232&w=2
[2] http://marc.info/?l=linux-mm&m=148847075032602&w=2

-Brijesh
