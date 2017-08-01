From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH] crypto: ccp - avoid uninitialized variable warning
Date: Tue, 1 Aug 2017 09:52:38 -0500
Message-ID: <b803327a-63d8-441b-3083-4fe005aae599@amd.com>
References: <20170731204936.1511542-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0076.outbound.protection.outlook.com ([104.47.34.76]:17088
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751295AbdHAOxW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2017 10:53:22 -0400
In-Reply-To: <20170731204936.1511542-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/31/2017 03:49 PM, Arnd Bergmann wrote:
> The added support for version 5 CCPs introduced a false-positive
> warning in the RSA implementation:
>
> drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_rsa_cmd':
> drivers/crypto/ccp/ccp-ops.c:1856:3: error: 'sb_count' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>
> This changes the code in a way that should make it easier for
> the compiler to track the state of the sb_count variable, and
> avoid the warning.
>
> Fixes: 6ba46c7d4d7e ("crypto: ccp - Fix base RSA function for version 5 CCPs")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/crypto/ccp/ccp-ops.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index 40c062ad8726..a8bc207b099a 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -1758,6 +1758,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  	o_len = 32 * ((rsa->key_size + 255) / 256);
>  	i_len = o_len * 2;
>
> +	sb_count = 0;
>  	if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0)) {
>  		/* sb_count is the number of storage block slots required
>  		 * for the modulus.
> @@ -1852,7 +1853,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  	ccp_dm_free(&exp);
>
>  e_sb:
> -	if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0))
> +	if (sb_count)
>  		cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key, sb_count);
>
>  	return ret;
>

This is a fine solution. However, having lived with this annoyance for a 
while, and even hoping that a
a later compiler fixes it, I would have preferred to either:

1) Initialize the local variable at declaration time, or

2) Use this patch, which the compiler could optimize as it sees fit, and 
maintains a clear distinction
for the code path for older devices:

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 40c062a..a3a884a 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1733,7 +1733,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue 
*cmd_q, struct ccp_cmd *cmd)
         struct ccp_rsa_engine *rsa = &cmd->u.rsa;
         struct ccp_dm_workarea exp, src, dst;
         struct ccp_op op;
-       unsigned int sb_count, i_len, o_len;
+       unsigned int i_len, o_len;
         int ret;

         /* Check against the maximum allowable size, in bits */
@@ -1762,7 +1762,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue 
*cmd_q, struct ccp_cmd *cmd)
                 /* sb_count is the number of storage block slots required
                  * for the modulus.
                  */
-               sb_count = o_len / CCP_SB_BYTES;
+               unsigned int sb_count = o_len / CCP_SB_BYTES;
                 op.sb_key = cmd_q->ccp->vdata->perform->sballoc(cmd_q,
                                                                 sb_count);
                 if (!op.sb_key)
@@ -1853,7 +1853,10 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue 
*cmd_q, struct ccp_cmd *cmd)

  e_sb:
         if (cmd_q->ccp->vdata->version < CCP_VERSION(5, 0))
+       {
+               unsigned int sb_count = o_len / CCP_SB_BYTES;
                 cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key, 
sb_count);
+       }

         return ret;
  }


Discuss?
