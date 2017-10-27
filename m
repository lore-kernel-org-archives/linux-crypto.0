From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Fri, 27 Oct 2017 06:28:38 -0500
Message-ID: <323f3862-b326-e6b4-015f-6d923d7c700f@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-14-brijesh.singh@amd.com>
 <20171023092020.GB19523@nazgul.tnic>
 <f58e72e5-8636-2abb-99e9-c58f462463e7@amd.com>
 <20171026135614.GA12359@nazgul.tnic>
 <9258d8e7-b185-01d2-be92-d7d2820c7eb6@amd.com>
 <20171026174427.GB29782@nazgul.tnic>
 <bc7254d3-a2d9-e3fd-02a4-164d5e4fb545@amd.com>
 <20171026201322.GA32181@nazgul.tnic>
 <89f4ec21-e31e-18f2-27c5-946c38cd128d@amd.com>
 <20171027075650.GA1276@nazgul.tnic>
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
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171027075650.GA1276@nazgul.tnic>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/27/17 2:56 AM, Borislav Petkov wrote:
> On Thu, Oct 26, 2017 at 03:59:32PM -0500, Brijesh Singh wrote:
>> we can workaround #1 by adding some hooks in sp_pci_init() to invoke the PSP
>> initialization routines after pci_register_driver() is done but #2 can get
>> painful because it will require us calling the SHUTDOWN outside the
>> sp_pci_exit() code flow.
> Ok, do that and init the PSP master and then put the device in UNINIT
> state only in the functions which execute those commands which need the
> device to be in UNINIT state, e.g., wrap the SEV_CMD_FACTORY_RESET glue
> in a command function which does put the device in the UNINIT state as a
> first step.

transiting a platform in UINIT state to handle the FACTORY_RESET can
have a negative consequence.

Consider this scenario:

Process A
---------
sev_launch_start(...)

while (count < 10000) {
    sev_launch_update(...)
}

sev_launch_finish()
...
...

Process B:
---------
....
sev_factory_reset();
....

If in order to handle the FACTORY_RESET we  transition a platform in
UINIT state then it will results as unexpected failure from the
sev_launch_update() because the FACTORY_RESET command remove all the
state information created by sev_launch_start() etc. 

I think our design so far is simple, if command require INIT state then
caller executes sev_platform_init(), then command and finish with
sev_platform_shutdown(). If command does not require INIT state, then
simply issue the command. e.g currently, when caller issues
FACTORY_RESET then we pass command directly to PSP and if FW is in INIT
state then FACTORY_RESET returns error (INVALID_STATE/EBUSY) and we
propagate the error code to userspace.  User can retry the command
sometime later when nobody else is using the PSP.


>
> Then, when that function is done, put the device in the mode which the
> other commands would expect it to be in, e.g., INIT state.
>
> This way you'll simplify the whole command flow considerably and won't
> have to "toggle" the device each time and will save yourself a lot of
> time on command execution.
>
> Thx.
>
