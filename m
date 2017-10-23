From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6 16/38] crypto: ccp: Implement SEV_PEK_GEN ioctl
 command
Date: Mon, 23 Oct 2017 15:00:19 -0500
Message-ID: <abc8f653-0592-b3b9-8af7-64b617645285@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-17-brijesh.singh@amd.com>
 <20171023093240.GC19523@nazgul.tnic>
 <ad140f6b-4e9d-7044-5e45-0c434511cb1a@amd.com>
 <20171023123223.GA24208@nazgul.tnic>
 <66c9f41e-868e-0d14-aaec-0858753c86d4@amd.com>
 <20171023141032.GC3044@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0053.outbound.protection.outlook.com ([104.47.38.53]:64352
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751113AbdJWUA0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 16:00:26 -0400
In-Reply-To: <20171023141032.GC3044@nazgul.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/23/2017 09:10 AM, Borislav Petkov wrote:
> On Mon, Oct 23, 2017 at 08:32:57AM -0500, Brijesh Singh wrote:
>> If both the command fails then we return status from the last command.
>> IIRC, in my previous patches I was returning status from sev_do_cmd()
>> instead of sev_platform_shutdown() but based on our previous
>> communication I thought you asked to return the status from the last
>> failed command. Did I miss understood ?
> 
> So my problem is that it looks strange that you save an error value from
> sev_do_cmd() but you don't look at it. And as I said in the other mail,
> you should either ignore it and say so in a comment why it is OK to
> ignore it or handle it but not overwrite it without looking at it.
> 
> Does that make more sense?
> 

I see your point, if both commands failed then I am now inclined towards 
ignoring the error code from shutdown command and add some comments 
explaining why its OK. thanks

-Brijesh
