From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Fri, 27 Oct 2017 17:59:23 -0500
Message-ID: <746a1ce4-f137-5e4a-d768-34aa88893955@amd.com>
References: <20171026174427.GB29782@nazgul.tnic>
 <bc7254d3-a2d9-e3fd-02a4-164d5e4fb545@amd.com>
 <20171026201322.GA32181@nazgul.tnic>
 <89f4ec21-e31e-18f2-27c5-946c38cd128d@amd.com>
 <20171027075650.GA1276@nazgul.tnic>
 <323f3862-b326-e6b4-015f-6d923d7c700f@amd.com>
 <20171027201554.GH12039@nazgul.tnic>
 <0f039ac4-a9c4-9920-4fb9-b1c5eadf3128@amd.com>
 <20171027202707.olhzx453cnkbhy62@pd.tnic>
 <a7b8859b-6537-5ce0-b0d8-bd5932c64251@amd.com>
 <20171027214949.ixzairu5ueh4to4e@pd.tnic>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0088.outbound.protection.outlook.com ([104.47.34.88]:10055
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750915AbdJ0W7a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2017 18:59:30 -0400
In-Reply-To: <20171027214949.ixzairu5ueh4to4e@pd.tnic>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 10/27/17 4:49 PM, Borislav Petkov wrote:
> On Fri, Oct 27, 2017 at 04:28:31PM -0500, Brijesh Singh wrote:
>> This will fail because PEK_GEN require the platform in INIT state and
>> nobody has done the state transition from INIT -> UINIT.
> Huh, FW is in INIT state and PEK_GEN wants it to be in INIT state. Typo?

Yes it is typo. PEK_GEN wants FW to be in INIT state hence someone need
to transition from UNINIT -> INIT.

> Aaanyway, I don't like this whole notion of prematurely and predictively
> executing commands on the PSP if it is not needed. So how about
> executing only those commands which put the FW in the required state and
> then executing the actual command?

That's what I am doing except FACTORY_RESET. The FACTORY_RESET require
the FW to be in UNINIT state,  since we don't who else is running in
parallel hence its not safe to issue the SHUTDOWN to transition from
INIT -> UNINIT. If FW is not in correct state this  command will fail
with error code (INVALID_STATE) and user can retry (please note that
user can always use PLATFORM_STATUS to query the current FW state before
issuing a command). I see that we can do a small optimization -- since
we already know the FW state hence we can avoid issuing PSP command when
we know for sure that command will fail because we are not in correct state.

>
> I.e., if a command needs to be executed in UINIT state, you put the PSP
> in that state before executing that command. If the command needs to be
> in INIT state, you put the PSP in INIT state first and so on...

If command needs INIT state and FW is not in INIT state then its safe to
transition from UNINIT -> INIT. But if command needs UNINIT state and FW
is in INIT state then its not safe to transition -- in those case we
simply return EBUSY and let the user retry the command.
