From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.2 12.2/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Thu, 12 Oct 2017 16:52:32 -0500
Message-ID: <69a807a3-770a-662d-9cf0-25fad035a323@amd.com>
References: <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171011165030.115696-1-brijesh.singh@amd.com>
 <20171012140816.6siefvahj6ww7uzf@pd.tnic>
 <622585ce-c575-29ff-0484-404b7cf684fc@amd.com>
 <20171012214120.upn2set2gichsejq@pd.tnic>
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
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171012214120.upn2set2gichsejq@pd.tnic>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On 10/12/17 4:41 PM, Borislav Petkov wrote:
> On Thu, Oct 12, 2017 at 04:11:18PM -0500, Brijesh Singh wrote:
>> The sev_exit() will be called for all the psp_device instance. we need
>> to set psp_misc_dev = NULL after deregistering the device.
>>
>> if (psp_misc_dev) {
>>   misc_deregister(psp_misc_dev);
>>    psp_misc_dev = NULL;
> Right, except we assign that misc device to every psp device:
>
> 	psp->sev_misc = psp_misc_dev;
>
> so the question now is, how do you want this to work: the misc device
> should be destroyed after the last psp device is destroyed or how?

We don't know when the last psp device is getting destroyed. Since we
are  making the sev_misc_dev as a global variable then there is no
reason for 'sev_misc' field in the psp_device.

> Because after the first:
>
> 	psp_misc_dev = NULL;
>
> the respective psp->sev_misc will still keep references to that device
> but the device itself will be already deregistered. And that sounds
> strange.

See my above comment, I think the simplest solution is remove psp->sev_misc
