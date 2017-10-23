From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6 16/38] crypto: ccp: Implement SEV_PEK_GEN ioctl
 command
Date: Mon, 23 Oct 2017 07:15:30 -0500
Message-ID: <ad140f6b-4e9d-7044-5e45-0c434511cb1a@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-17-brijesh.singh@amd.com>
 <20171023093240.GC19523@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: brijesh.singh@amd.com, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0073.outbound.protection.outlook.com ([104.47.36.73]:25776
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751116AbdJWMPk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 08:15:40 -0400
In-Reply-To: <20171023093240.GC19523@nazgul.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/23/17 4:32 AM, Borislav Petkov wrote:
...
>> +static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
>> +{
>> +	int ret, err;
>> +
>> +	ret = sev_platform_init(NULL, &argp->error);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = sev_do_cmd(cmd, 0, &argp->error);
> So this ret value gets potentially overwritten here. You need
> to either handle the case properly when sev_do_cmd() fails and
> sev_platform_shutdown() gets to issue SEV_CMD_SHUTDOWN (i.e., when it
> gets overwritten), or not write into ret at all by initializing it to 0
> at function entry.
>

I am not sure if I am able to understand your feedback. The
sev_platform_shutdown() is called unconditionally.

1) if sev_do_cmd() fails and sev_platform_shutdown() was success then
'ret' will contain the  error code from sev_do_cmd().
2) if sev_do_cmd() was success but sev_platform_shutdown() fails then
'ret' will contain the error code from sev_platform_shutdown()
3) if both sev_do_cmd() and sev_platform_shutdown() fails then 'ret'
will contain error code from the sev_platform_shutdown().
