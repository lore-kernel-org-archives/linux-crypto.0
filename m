From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.1 12.1/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Wed, 11 Oct 2017 09:23:53 -0500
Message-ID: <70607e4a-b2e1-7b0a-a9d1-0d7f52c3910a@amd.com>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007184049.jrbxebb4jlciu3hj@pd.tnic>
 <c6ec79f7-5192-8ed3-4df3-260c09ceccb9@amd.com>
 <20171011141949.z4blmu5wy5sooq4p@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171011141949.z4blmu5wy5sooq4p@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/11/2017 09:19 AM, Borislav Petkov wrote:
> On Sun, Oct 08, 2017 at 08:30:47AM -0500, Brijesh Singh wrote:
>> Basically we need some variable which is outside the per-device
>> structure so that we don't end up creating multiple /dev/sev nodes. If
>> needed, I think we can remove 'has_sev_fops' variable from struct
>> psp_device if we decide to dynamic alloc 'struct miscdevice sev_misc' in
>> struct psp_device. The 'has_sev_fops' is  mainly used in sev_exit(). If
>> we decide to dynamic alloc sev_misc then in  sev_exit() we can use
>> psp->sev_misc != NULL instead of psp->has_sev_ops.
> 
> Yap, that sounds better than an explicit variable.
> 

Sure, I will implement it and send you v5.2. thanks
