From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v5 12/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Sat, 7 Oct 2017 13:13:07 -0500
Message-ID: <97825322-e53b-153f-4208-62b750b9b341@amd.com>
References: <20171004131412.13038-1-brijesh.singh@amd.com>
 <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171006184951.vq6hlhjanaefizli@pd.tnic>
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
In-Reply-To: <20171006184951.vq6hlhjanaefizli@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On 10/6/17 1:49 PM, Borislav Petkov wrote:
...

>> +static int sev_wait_cmd_ioc(struct psp_device *psp, unsigned int *reg)
>> +{
>> +	psp->sev_int_rcvd = 0;
>> +
>> +	wait_event(psp->sev_int_queue, psp->sev_int_rcvd);
> What happens if the command times out and it never sets psp->sev_int_rcvd?

Sorry i missed replying on this comment.  We should not run into cases
where after issuing PSP command we do not get an interrupt. I would
prefer to avoid adding the timeout value. At least so far in all my runs
I have not came across this situation but it can happen ;).  The tricky
part is, what should be the default timeout value. Depending on the user
inputs some commands can take long time.
