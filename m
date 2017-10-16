From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH] staging: ccree: Fix bool comparison
Date: Tue, 17 Oct 2017 08:17:08 +1100
Message-ID: <20171016211708.GM16106@eros>
References: <1508148491-11837-1-git-send-email-sunil.m@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
 driverdev-devel@linuxdriverproject.org, karthik@techveda.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: sunil.m@techveda.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1508148491-11837-1-git-send-email-sunil.m@techveda.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 16, 2017 at 03:38:11PM +0530, sunil.m@techveda.org wrote:
> From: Suniel Mahesh <sunil.m@techveda.org>
> 
> Bool tests don't need comparisons.

This commit log could be a bit longer. You may like to read
Documentation/process/submitting-patches.rst (section 2).

> This fixes the following coccinelle warning:
> WARNING: Comparison of bool to 0/1
> 
> Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
> ---
> Note:
> - Patch was tested and built(ARCH=arm) on latest
>   linux-next.

Building is _not_ testing.

> - No build issues reported, however it was not
>   tested on real hardware.

This is implicit if you state 'builds on ARM'

> - Please discard this changeset, if this is not
>   helping the code look better.

This is implicit also ;)

> ---
>  drivers/staging/ccree/ssi_request_mgr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
> index 2e0df57..942afe2 100644
> --- a/drivers/staging/ccree/ssi_request_mgr.c
> +++ b/drivers/staging/ccree/ssi_request_mgr.c
> @@ -272,7 +272,7 @@ int send_request(
>  	unsigned int max_required_seq_len = (total_seq_len +
>  					((ssi_req->ivgen_dma_addr_len == 0) ? 0 :
>  					SSI_IVPOOL_SEQ_LEN) +
> -					((is_dout == 0) ? 1 : 0));
> +					(!is_dout ? 1 : 0));

Perhaps

-					((is_dout == 0) ? 1 : 0));
+					(is_dout ? 0 : 1)

Good luck,
Tobin.
