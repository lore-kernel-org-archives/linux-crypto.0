From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v7 18/38] crypto: ccp: Implement SEV_PEK_CSR ioctl
 command
Date: Fri, 3 Nov 2017 15:01:05 -0500
Message-ID: <9ae137d6-dc96-e399-8ea8-cb16b10f9d0b@amd.com>
References: <20171101211623.71496-1-brijesh.singh@amd.com>
 <20171101211623.71496-19-brijesh.singh@amd.com>
 <20171103194209.epitwoakf3c3qlk5@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171103194209.epitwoakf3c3qlk5@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 11/3/17 2:42 PM, Borislav Petkov wrote:

...
>> +	if (psp_master->sev_state == SEV_STATE_UNINIT) {
>> +		ret = __sev_platform_init_locked(psp_master->sev_init, &argp->error);
> Right, you're passing psp_master->sev_init (or whatever you're going to
> end up calling it) down but then in __sev_platform_init_locked() you end
> up doing
>
>         if (!data)
>                 data = &psp->cmd_buf;
>
> which looks silly.
>
> IOW, if not really required, __sev_platform_init_locked() could have
> only one argument instead:
>
> static int __sev_platform_init_locked(int *error)

The cmd_buf argument can be remove. I am have not looked at SEV-ES but
it may be possible that during SEV-ES patches kvm driver may need to
call the sev_platform_init() with different cmd_buf to initialize SEV-ES
states. I can removed it in next version.


-Brijesh
