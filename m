From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5 11/31] crypto: ccp: Define SEV key management
 command id
Date: Sun, 8 Oct 2017 16:14:21 -0500
Message-ID: <51e390d6-724a-dec1-91b7-4af20c73b08b@amd.com>
References: <20171004131412.13038-1-brijesh.singh@amd.com>
 <20171004131412.13038-12-brijesh.singh@amd.com>
 <20171005205658.77onrn2mr2mrxafs@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: brijesh.singh@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171005205658.77onrn2mr2mrxafs@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/5/17 3:56 PM, Borislav Petkov wrote:
> On Wed, Oct 04, 2017 at 08:13:52AM -0500, Brijesh Singh wrote:
>> Define Secure Encrypted Virtualization (SEV) key management command id
>> and structure. The command definition is available in SEV KM [1] spec
>> 0.14.
>>
>> [1] http://support.amd.com/TechDocs/55766_SEV-KM API_Specification.pdf
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
>>  include/linux/psp-sev.h | 515 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 515 insertions(+)
>>  create mode 100644 include/linux/psp-sev.h
> Some fixes ontop below.
>
> With that:
>
> Reviewed-by: Borislav Petkov <bp@suse.de>

Thanks, I have applied your fixes.
