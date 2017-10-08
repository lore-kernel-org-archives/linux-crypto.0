From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.1 12.2/31] crypto: ccp: Define SEV userspace
 ioctl and command id
Date: Sun, 8 Oct 2017 16:18:44 -0500
Message-ID: <dd928018-32f0-2362-2fa1-4f9c471ac2a9@amd.com>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-2-brijesh.singh@amd.com>
 <20171007142010.6cnkeyywbitk6u73@pd.tnic>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171007142010.6cnkeyywbitk6u73@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/7/17 9:20 AM, Borislav Petkov wrote:
> On Fri, Oct 06, 2017 at 08:06:00PM -0500, Brijesh Singh wrote:
>> Add a include file which defines the ioctl and command id used for
>> issuing SEV platform management specific commands.
>>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
>> Cc: Borislav Petkov <bp@suse.de>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: Gary Hook <gary.hook@amd.com>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: linux-crypto@vger.kernel.org
>> Cc: kvm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  include/uapi/linux/psp-sev.h | 115 +++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 115 insertions(+)
>>  create mode 100644 include/uapi/linux/psp-sev.h
> First of all, thanks for splitting the patch - it is much easier to
> review this way.
>
> Then, this patch should be 12.1, i.e., the first of the split because otherwise
> the previous one - which should be the next - fails building due to
>
> drivers/crypto/ccp/psp-dev.c:26:32: fatal error: uapi/linux/psp-sev.h: No such file or directory
>  #include <uapi/linux/psp-sev.h>
>                                 ^
> Just swap them in their order.

Ah, yes I will swap the order in next submission. thanks
