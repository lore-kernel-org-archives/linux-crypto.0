From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: ccp - avoid uninitialized variable warning
Date: Tue, 1 Aug 2017 22:35:41 +0200
Message-ID: <CAK8P3a3sCa9=yTwjkT_iyXgu-e08rBNAQoV+0wvpL5utJhumiw@mail.gmail.com>
References: <20170731204936.1511542-1-arnd@arndb.de> <b803327a-63d8-441b-3083-4fe005aae599@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33236 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752154AbdHAUfm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2017 16:35:42 -0400
In-Reply-To: <b803327a-63d8-441b-3083-4fe005aae599@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 1, 2017 at 4:52 PM, Gary R Hook <gary.hook@amd.com> wrote:
> On 07/31/2017 03:49 PM, Arnd Bergmann wrote:
>>
>> The added support for version 5 CCPs introduced a false-positive
>> warning in the RSA implementation:
>>
>> drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_rsa_cmd':
>> drivers/crypto/ccp/ccp-ops.c:1856:3: error: 'sb_count' may be used
>> uninitialized in this function [-Werror=maybe-uninitialized]
>>
>> This changes the code in a way that should make it easier for
>> the compiler to track the state of the sb_count variable, and
>> avoid the warning.
>>
>> Fixes: 6ba46c7d4d7e ("crypto: ccp - Fix base RSA function for version 5
>> CCPs")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/crypto/ccp/ccp-ops.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
>> index 40c062ad8726..a8bc207b099a 100644
>> --- a/drivers/crypto/ccp/ccp-ops.c
>> +++ b/drivers/crypto/ccp/ccp-ops.c
>> @@ -1758,6 +1758,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue
>> *cmd_q, struct ccp_cmd *cmd)
>>         o_len = 32 * ((rsa->key_size + 255) / 256);
>>         i_len = o_len * 2;
>>
>> +       sb_count = 0;
>>         if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0)) {
>>                 /* sb_count is the number of storage block slots required
>>                  * for the modulus.
>> @@ -1852,7 +1853,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue
>> *cmd_q, struct ccp_cmd *cmd)
>>         ccp_dm_free(&exp);
>>
>>  e_sb:
>> -       if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0))
>> +       if (sb_count)
>>                 cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key,
>> sb_count);
>>
>>         return ret;
>>
>
> This is a fine solution. However, having lived with this annoyance for a
> while, and even hoping that a
> a later compiler fixes it, I would have preferred to either:
>
> 1) Initialize the local variable at declaration time, or

I try to never do that in general, see https://rusty.ozlabs.org/?p=232

> 2) Use this patch, which the compiler could optimize as it sees fit, and
> maintains a clear distinction
> for the code path for older devices:

This seems fine.

> @@ -1853,7 +1853,10 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue
> *cmd_q, struct ccp_cmd *cmd)
>
>  e_sb:
>         if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0))
> +       {
> +               unsigned int sb_count = o_len / CCP_SB_BYTES;
>                 cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key,
> sb_count);
> +       }

I would probably skip the local variable as well then, and just open-code the
length, unless that adds ugly line-wraps.

       Arnd
