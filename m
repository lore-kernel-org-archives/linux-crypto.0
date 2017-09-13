From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC Part2 PATCH v3 03/26] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) device support
Date: Wed, 13 Sep 2017 10:18:52 -0500
Message-ID: <b2836081-d915-6a14-0aaf-0deffd6ded84@amd.com>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
 <20170724200303.12197-4-brijesh.singh@amd.com>
 <20170913141749.pvphgxgcsjam4us7@pd.tnic>
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
Received: from mail-dm3nam03on0065.outbound.protection.outlook.com ([104.47.41.65]:5024
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751807AbdIMPTB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Sep 2017 11:19:01 -0400
In-Reply-To: <20170913141749.pvphgxgcsjam4us7@pd.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 09/13/2017 09:17 AM, Borislav Petkov wrote:
...

>> +
>> +unlock:
>> +	mutex_unlock(&sev_cmd_mutex);
>> +	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
>> +			sev_cmd_buffer_len(cmd), false);
>> +	return ret;
> 
> ... and here you return psp_ret == 0 even though something failed.
> 
> What I think you should do is not touch @psp_ret when you return before
> the SEV command executes and *when* you return, set @psp_ret accordingly
> to denote the status of the command execution.
> 
> Or if you're touching it before you execute the SEV
> command and you return early, it should say something like
> PSP_CMDRESP_COMMAND_DIDNT_EXECUTE or so, to tell the caller exactly what
> happened.
> 

Agreed, very good catch thank you. I will fix it.

-Brijesh
