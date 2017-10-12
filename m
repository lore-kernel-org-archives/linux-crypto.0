From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.1 12.5/31] crypto: ccp: Implement SEV_PEK_GEN
 ioctl command
Date: Thu, 12 Oct 2017 15:34:54 -0500
Message-ID: <26a451b8-2c34-979a-ccdc-15e4948abb80@amd.com>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-5-brijesh.singh@amd.com>
 <20171012182844.kjv5zab7o6fwwwdk@pd.tnic>
 <e2a67da0-5442-f9d6-6390-bfbb0a352639@amd.com>
 <20171012202152.dzlzka7vmojcxu6q@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0065.outbound.protection.outlook.com ([104.47.32.65]:6894
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752452AbdJLUfE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2017 16:35:04 -0400
In-Reply-To: <20171012202152.dzlzka7vmojcxu6q@pd.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/12/17 3:21 PM, Borislav Petkov wrote:
> On Thu, Oct 12, 2017 at 03:11:07PM -0500, Brijesh Singh wrote:
>> Lets  consider this scenario
>> 1- platform is in uninit state, we transition it to INIT
>> 2- PEK_GEN command failed
>> 3- since we have transitioned the platform in INIT state hence we must
>> call the shutdown otherwise we will leave the system in wrong state. The
>> shutdown command will most probably succeed and we will look the ret value
> Sure but what do you do if the main command, i.e., PEK_GEN succeeds but
> the shutdown command fails?
>
> You probably should carve out the whole shutdown order in separate
> functions. I mean, the sequences do repeat in a couple of functions so
> you could do:
>
> ioctl:
>
> 	case <CMD>:
>
> 		init_platform()
> 		do_main_cmd()
> 		shutdown_platform()
> 	break;
>
> and this way you have everything nicely separated and retvals properly
> tracked...
>
> Hmmm?

Some commands are allowed in INIT and WORKING, some in UINIT only,  some
WORKING, and others in all the state. We need to follow the platform
state machine. I will see what I can do. thanks
