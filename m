From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH v4 02/19] crypto: ccm: use -EAGAIN for transient busy
 indication
Date: Tue, 8 Aug 2017 10:24:49 -0500
Message-ID: <4600c898-a2f2-f95f-15b4-0adcc6acc0b5__45565.4899626554$1502205975$gmane$org@amd.com>
References: <1502193834-11289-1-git-send-email-gilad@benyossef.com>
 <1502193834-11289-3-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>,
 David Howells <dhowells@redhat.com>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 Boris Brezillon <boris.brezillon@free-electrons.com>,
 Arnaud Ebalard <arno@natisbad.org>, Matthias Brugger
 <matthias.bgg@gmail.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com"
 <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>,
 Steve French <sfrench@samba.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
 James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn"
 <serge@hallyn.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <lin
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1502193834-11289-3-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 08/08/2017 07:03 AM, Gilad Ben-Yossef wrote:
> Replace -EBUSY with -EAGAIN when reporting transient busy
> indication in the absence of backlog.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Could we use "ccp" in the subject line, please?

> ---
>  drivers/crypto/ccp/ccp-crypto-main.c | 8 +++-----
>  drivers/crypto/ccp/ccp-dev.c         | 7 +++++--
>  2 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
> index 35a9de7..403ff0a 100644
> --- a/drivers/crypto/ccp/ccp-crypto-main.c
> +++ b/drivers/crypto/ccp/ccp-crypto-main.c
> @@ -222,9 +222,10 @@ static int ccp_crypto_enqueue_cmd(struct ccp_crypto_cmd *crypto_cmd)
>
>  	/* Check if the cmd can/should be queued */
>  	if (req_queue.cmd_count >= CCP_CRYPTO_MAX_QLEN) {
> -		ret = -EBUSY;
> -		if (!(crypto_cmd->cmd->flags & CCP_CMD_MAY_BACKLOG))
> +		if (!(crypto_cmd->cmd->flags & CCP_CMD_MAY_BACKLOG)) {
> +			ret = -EAGAIN;
>  			goto e_lock;
> +		}
>  	}
>
>  	/* Look for an entry with the same tfm.  If there is a cmd
> @@ -243,9 +244,6 @@ static int ccp_crypto_enqueue_cmd(struct ccp_crypto_cmd *crypto_cmd)
>  		ret = ccp_enqueue_cmd(crypto_cmd->cmd);
>  		if (!ccp_crypto_success(ret))
>  			goto e_lock;	/* Error, don't queue it */
> -		if ((ret == -EBUSY) &&
> -		    !(crypto_cmd->cmd->flags & CCP_CMD_MAY_BACKLOG))
> -			goto e_lock;	/* Not backlogging, don't queue it */
>  	}
>
>  	if (req_queue.cmd_count >= CCP_CRYPTO_MAX_QLEN) {
> diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
> index 4e029b1..3d637e3 100644
> --- a/drivers/crypto/ccp/ccp-dev.c
> +++ b/drivers/crypto/ccp/ccp-dev.c
> @@ -292,9 +292,12 @@ int ccp_enqueue_cmd(struct ccp_cmd *cmd)
>  	i = ccp->cmd_q_count;
>
>  	if (ccp->cmd_count >= MAX_CMD_QLEN) {
> -		ret = -EBUSY;
> -		if (cmd->flags & CCP_CMD_MAY_BACKLOG)
> +		if (cmd->flags & CCP_CMD_MAY_BACKLOG) {
> +			ret = -EBUSY;
>  			list_add_tail(&cmd->entry, &ccp->backlog);
> +		} else {
> +			ret = -EAGAIN;
> +		}
>  	} else {
>  		ret = -EINPROGRESS;
>  		ccp->cmd_count++;
>
