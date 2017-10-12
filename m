From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5.2 12.2/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Thu, 12 Oct 2017 15:05:20 -0500
Message-ID: <bd2d0b20-221c-b4a0-691a-424996325c69@amd.com>
References: <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171011165030.115696-1-brijesh.singh@amd.com>
 <20171012182102.ffyxggnhyymtmhky@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171012182102.ffyxggnhyymtmhky@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/12/17 1:21 PM, Borislav Petkov wrote:
.....

> Btw, that function returns 0 unconditionally. So you can make it return
> void and...

Will do
>> +	if (ret)
>> +		goto unlock;
> ... remove this check and initialize ret to 0 at the beginning.
>

Will do
