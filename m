From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Sat, 28 Oct 2017 07:20:51 -0500
Message-ID: <d6eba23e-cea2-6b4c-3594-59223d10bd6b@amd.com>
References: <20171026201322.GA32181@nazgul.tnic>
 <89f4ec21-e31e-18f2-27c5-946c38cd128d@amd.com>
 <20171027075650.GA1276@nazgul.tnic>
 <323f3862-b326-e6b4-015f-6d923d7c700f@amd.com>
 <20171027201554.GH12039@nazgul.tnic>
 <0f039ac4-a9c4-9920-4fb9-b1c5eadf3128@amd.com>
 <20171027202707.olhzx453cnkbhy62@pd.tnic>
 <a7b8859b-6537-5ce0-b0d8-bd5932c64251@amd.com>
 <20171027214949.ixzairu5ueh4to4e@pd.tnic>
 <746a1ce4-f137-5e4a-d768-34aa88893955@amd.com>
 <20171028000034.46r72fyaprfjwdj7@pd.tnic>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171028000034.46r72fyaprfjwdj7@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/27/17 7:00 PM, Borislav Petkov wrote:
> On Fri, Oct 27, 2017 at 05:59:23PM -0500, Brijesh Singh wrote:
>> Yes it is typo. PEK_GEN wants FW to be in INIT state hence someone need
>> to transition from UNINIT -> INIT.
> Which, once you've done it once on driver init, is there.
>
>> That's what I am doing except FACTORY_RESET.
> Well, not really. Lemme pick a command at random...
>
> PEK_CSR. For that, you do INIT -> PEK_CSR -> SHUTDOWN.
>
> Doc says, platform needs to be in INIT or WORKING state. But nothing
> says you should shut it down. Spec says, SHUTDOWN transitions platform
> to UNINIT state. So when the next command comes in which needs the
> platform to be in INIT state, you go and INIT it again. For no reason
> *WHATSOEVER*!
>
> I know, you're gonna say, but what if the next command needs a different
> state than INIT. Well, *then* you transition it, in the command
> function. When that function executes. But not before that and not in
> preparation that *maybe* the next command will be it.
>
> Now, if you did:
>
> INIT once during driver init
>
> PEK_CSR
>
> (platform remains in INIT state)
>
> <--- the next command here can execute directly if it is allowed in INIT
> state.
>
> Instead, the platform has been shutdown and you init it again. Do you
> see now what I mean?

Yes, I can see that with your proposal we may able to save some PSP
interaction because after command execution we do not restore to the
previous state. e.g before executing the PEK_CSR command if FW was in
UINIT then we do UNINIT -> INIT and leave it to INIT state.

> IOW, once you init the PSP master, you should keep it in the INIT state
> - or the state in which most commands expect it to be and thus save
> yourself all that unnecessary toggling. If a command needs it to be in a
> different state, only *then* you transition it.

Let me implement it and send you the patch. I think the command
execution function will look like this:

static int sev_ioctl_do_pek_csr(...)
{
   ....
   ....
   mutex(&fw_init_mutex);

   /* If FW is not in INIT state then initialize before executing command */
   if (psp->sev_state != SEV_STATE_INIT) {
       rc = sev_platform_init(...);
       if (rc) {
         mutex_unlock(&fw_init_mutex);
         return rc;
       }
    }
   
     rc = sev_do_cmd(....)

     mutex_unlock(&fw_init_mutex);

     return rc;
}

and factory reset will look like this

static int sev_ioctl_do_reset(...)
{
   mutex(&fw_init_mutex);

   /* If FW is not in UINIT state then shutdown before executing command */
   if (psp->sev_state != SEV_STATE_INIT)
       sev_platform_shutdown(...);
  
    rc = sev_do_cmd(....)

    mutex_unlock(&fw_init_mutex);

    return rc;
}

> Instead, what you have now is that you call INIT and SHUTDOWN
> around SEV_PEK_GEN, SEV_PDH_GEN, SEV_PEK_CSR, SEV_PEK_CERT_IMPORT,
> SEV_PDH_CERT_EXPORT and for all those, the platform must be in INIT
> (for some in WORKING state) but for all in INIT state and "The platform
> remains be in the same state after completion." So the whole SHUTDOWN ->
> INIT wankery in-between is a pure waste of electrons.
>
>>  I see that we can do a small optimization -- since we already know
>> the FW state hence we can avoid issuing PSP command when we know for
>> sure that command will fail because we are not in correct state.
> As I said before, you should do that regardless by recording the current
> state of the PSP in variable so that you can save yourself the status
> querying.
>
>> If command needs INIT state and FW is not in INIT state then its safe to
>> transition from UNINIT -> INIT. But if command needs UNINIT state and FW
>> is in INIT state then its not safe to transition -- in those case we
>> simply return EBUSY and let the user retry the command.
> Whatever - that doesn't contradict what I'm proposing.
>
