From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Fri, 27 Oct 2017 16:28:31 -0500
Message-ID: <a7b8859b-6537-5ce0-b0d8-bd5932c64251@amd.com>
References: <20171026135614.GA12359@nazgul.tnic>
 <9258d8e7-b185-01d2-be92-d7d2820c7eb6@amd.com>
 <20171026174427.GB29782@nazgul.tnic>
 <bc7254d3-a2d9-e3fd-02a4-164d5e4fb545@amd.com>
 <20171026201322.GA32181@nazgul.tnic>
 <89f4ec21-e31e-18f2-27c5-946c38cd128d@amd.com>
 <20171027075650.GA1276@nazgul.tnic>
 <323f3862-b326-e6b4-015f-6d923d7c700f@amd.com>
 <20171027201554.GH12039@nazgul.tnic>
 <0f039ac4-a9c4-9920-4fb9-b1c5eadf3128@amd.com>
 <20171027202707.olhzx453cnkbhy62@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027202707.olhzx453cnkbhy62@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 10/27/17 3:27 PM, Borislav Petkov wrote:
> On Fri, Oct 27, 2017 at 03:25:24PM -0500, Brijesh Singh wrote:
>> Yep, we are doing state transition only when we really need to. At least
>> so far I have tried to avoid making any unnecessary state transitions.
> So change all those which do INIT -> CMD -> SHUTDOWN to do only the
> command as the INIT state is the default state, AFAIU it.
>
I don't that will work. It may be possible that I am not able to follow
what exactly you have in mind. Please let me clarify it, on boot the
firmware is in UINIT state.

Firmware maintain three states: UINIT, INIT and WORKING. Few commands
can be executed in UINIT, several command can be executed in INIT, some
command can be executed in WORKING and few commands can be executed in
any states (see SEV spec for platform state). We do not have ioctls to
issue the INIT and SHUTDOWN command.

As I have explained in previous messages, the SHUTDOWN unconditionally
destory's the FW context hence we have refrained from providing the
access for this command to userspace.

My approach is, when userspace issues a command we check if command
requires INIT state, if so then we do INIT -> CMD -> SHUTDOWN. If
command can be executed in any state then we issue the command . If
command need to be executed in UINIT state then we *do not* do
SHUTDOWN->CMD, instead we issue the cmd and PSP will fail with error
code and caller can check the error code to determine why command failed.

If I go with your recommendation then I am not able to see who will
transition the platform from UINIT -> INIT so that command can run?

Lets try with very simple example:

# modprobe ccp

/* FW is in INIT state */

# userspace runs

ioctl(fd, SEV_USER_PEK_GEN, &err)

This will fail because PEK_GEN require the platform in INIT state and
nobody has done the state transition from INIT -> UINIT.


-Brijesh
