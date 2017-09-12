From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC Part2 PATCH v3 03/26] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) device support
Date: Tue, 12 Sep 2017 10:32:13 -0500
Message-ID: <855be17c-382e-4e7d-7300-ca19cc50c625@amd.com>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
 <20170724200303.12197-4-brijesh.singh@amd.com>
 <20170912140249.f26w5xedbrqu52i4@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?XCJSYWRpbSBLcsSNbcOhxZlcIg==?= <rkrcmar@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0048.outbound.protection.outlook.com ([104.47.42.48]:51454
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751404AbdILPcT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Sep 2017 11:32:19 -0400
In-Reply-To: <20170912140249.f26w5xedbrqu52i4@pd.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Boris,

I will address all your feedback in next rev.


On 09/12/2017 09:02 AM, Borislav Petkov wrote:
...


> 
> You could make that more tabular like this:
> 
>          case SEV_CMD_INIT:              return sizeof(struct sev_data_init);
>          case SEV_CMD_PLATFORM_STATUS:   return sizeof(struct sev_data_status);
>          case SEV_CMD_PEK_CSR:           return sizeof(struct sev_data_pek_csr);
> 	...
> 
> which should make it more readable.
> 
> But looking at this more, this is a static mapping between the commands
> and the corresponding struct sizes and you use it in
> 
>          print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
>                          sev_cmd_buffer_len(cmd), false);
> 
> But then, I don't see what that brings you because you're not dumping
> the actual @data length but the *expected* data length based on the
> command type.
> 
> And *that* you can look up in the manual and do not need it in code,
> enlarging the driver unnecessarily.
> 
> ...


The debug statement is very helpful during development, it gives me the full
view of what command we send to PSP, data dump of command buffer before and
after the request completion.  e.g when dyndbg is enabled the output looks like
this:

[392035.621308] ccp 0000:02:00.2: sev command id 0x4 buffer 0x000080146d232820
[392035.621312] (in):  00000000: 0000 0000 0000 0000 0000 0000
[392035.624725] (out): 00000000: 0e00 0000 0000 0b00 0000 0000

The first debug line prints command ID, second line prints memory dump of the command
structure and third line prints memory dump of command structure after PSP processed
the command.

The caller will use sev_issue_cmd() to issue PSP command. At this time we know
the command id and a opaque pointer (this points to command structure for command id).
Caller does not give us length of the command structure hence we need to derive it
from the command id using sev_cmd_buffer_len(). The command structure length is fixed
for a given command id.


Thanks
Brijesh
