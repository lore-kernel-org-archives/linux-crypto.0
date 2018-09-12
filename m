From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH crypto-2.6] crypto: ccp: add timeout support in the SEV
 command
Date: Tue, 11 Sep 2018 19:11:05 -0500
Message-ID: <ec8245a3-1620-4501-0ebd-f04dfe973bc8@amd.com>
References: <1534367485-4386-1-git-send-email-brijesh.singh@amd.com>
 <1534367485-4386-2-git-send-email-brijesh.singh@amd.com>
 <20180904051930.5kvyyu75ym5mubuz@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, linux-crypto@vger.kernel.org,
        thomas.lendacky@amd.com, Gary Hook <Gary.Hook@amd.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180904051930.5kvyyu75ym5mubuz@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On 9/4/18 12:19 AM, Herbert Xu wrote:
> On Wed, Aug 15, 2018 at 04:11:25PM -0500, Brijesh Singh wrote:
>> Currently, the CCP driver assumes that the SEV command issued to the PSP
>> will always return (i.e. it will never hang).  But recently, firmware bugs
>> have shown that a command can hang.  Since of the SEV commands are used
>> in probe routines, this can cause boot hangs and/or loss of virtualization
>> capabilities.
>>
>> To protect against firmware bugs, add a timeout in the SEV command
>> execution flow.  If a command does not complete within the specified
>> timeout then return -ETIMEOUT and stop the driver from executing any
>> further commands since the state of the SEV firmware is unknown.
>>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: Gary Hook <Gary.Hook@amd.com>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  drivers/crypto/ccp/psp-dev.c | 46 +++++++++++++++++++++++++++++++++++++++-----
>>  1 file changed, 41 insertions(+), 5 deletions(-)
> Patch applied.  Thanks.
Thanks Herbert.

Can you please include this patch in your next 4.19-rcX pull request?
Multiple folks are encountering this firmware bug on Ryzen systems. I
will submit the modified version of this patch for stable release (s) so
that we fix issues in 4.18,.17 and .16. thank you.

-Brijesh
