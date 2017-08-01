From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH] crypto: ccp - avoid uninitialized variable warning
Date: Tue, 1 Aug 2017 16:33:50 -0500
Message-ID: <d711ecd6-507f-6e49-1423-88364de08632@amd.com>
References: <20170731204936.1511542-1-arnd@arndb.de>
 <b803327a-63d8-441b-3083-4fe005aae599@amd.com>
 <CAK8P3a3sCa9=yTwjkT_iyXgu-e08rBNAQoV+0wvpL5utJhumiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0053.outbound.protection.outlook.com ([104.47.40.53]:49424
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752053AbdHAVek (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2017 17:34:40 -0400
In-Reply-To: <CAK8P3a3sCa9=yTwjkT_iyXgu-e08rBNAQoV+0wvpL5utJhumiw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/01/2017 03:35 PM, Arnd Bergmann wrote:
> On Tue, Aug 1, 2017 at 4:52 PM, Gary R Hook <gary.hook@amd.com> wrote:
>> On 07/31/2017 03:49 PM, Arnd Bergmann wrote:
>>>
>>> The added support for version 5 CCPs introduced a false-positive
>>> warning in the RSA implementation:
>>>
>>> drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_rsa_cmd':
>>> drivers/crypto/ccp/ccp-ops.c:1856:3: error: 'sb_count' may be used
>>> uninitialized in this function [-Werror=maybe-uninitialized]
>>>
>>> This changes the code in a way that should make it easier for
>>> the compiler to track the state of the sb_count variable, and
>>> avoid the warning.
>>>
>>> Fixes: 6ba46c7d4d7e ("crypto: ccp - Fix base RSA function for version 5
>>> CCPs")
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>> ---
>>>  drivers/crypto/ccp/ccp-ops.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
>>> index 40c062ad8726..a8bc207b099a 100644
>>> --- a/drivers/crypto/ccp/ccp-ops.c
>>> +++ b/drivers/crypto/ccp/ccp-ops.c
>>> @@ -1758,6 +1758,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue
>>> *cmd_q, struct ccp_cmd *cmd)
>>>         o_len = 32 * ((rsa->key_size + 255) / 256);
>>>         i_len = o_len * 2;
>>>
>>> +       sb_count = 0;
>>>         if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0)) {
>>>                 /* sb_count is the number of storage block slots required
>>>                  * for the modulus.
>>> @@ -1852,7 +1853,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue
>>> *cmd_q, struct ccp_cmd *cmd)
>>>         ccp_dm_free(&exp);
>>>
>>>  e_sb:
>>> -       if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0))
>>> +       if (sb_count)
>>>                 cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key,
>>> sb_count);
>>>
>>>         return ret;
>>>
>>
>> This is a fine solution. However, having lived with this annoyance for a
>> while, and even hoping that a
>> a later compiler fixes it, I would have preferred to either:
>>
>> 1) Initialize the local variable at declaration time, or
>
> I try to never do that in general, see https://rusty.ozlabs.org/?p=232

I know. I just globally disagree with a global decision of this sort.
Now I make errors that are more complex, partially because I've shot myself
in the foot repeatedly, and learned from it.

Nonetheless...

I will ack your suggested patch. Thank you for addressing this. I've learned
something.
