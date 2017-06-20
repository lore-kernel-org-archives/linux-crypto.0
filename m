From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 05/11] Fix ERROR: space prohibited after that open
 parenthesis '('
Date: Tue, 20 Jun 2017 11:27:39 +0300
Message-ID: <20170620082739.d647q2tlruk6vnbi@mwanda>
References: <1497935984-4406-1-git-send-email-fbihjmeric@gmail.com>
 <1497936106-4673-1-git-send-email-fbihjmeric@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
To: Jhih-Ming Huang <fbihjmeric@gmail.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1497936106-4673-1-git-send-email-fbihjmeric@gmail.com>
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

On Tue, Jun 20, 2017 at 01:21:46PM +0800, Jhih-Ming Huang wrote:
> From: Jhih-Ming Hunag <fbihjmeric@gmail.com>
> 
> Fixed "ERROR: space prohibited after that open parenthesis '('".
> 
> Signed-off-by: Jhih-Ming Hunag <fbihjmeric@gmail.com>
> ---
>  drivers/staging/ccree/ssi_aead.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
> index 6bcab5a..5166874 100644
> --- a/drivers/staging/ccree/ssi_aead.c
> +++ b/drivers/staging/ccree/ssi_aead.c
> @@ -1375,10 +1375,10 @@ static int validate_data_size(struct ssi_aead_ctx *ctx,
>  static unsigned int format_ccm_a0(u8 *pA0Buff, u32 headerSize)
>  {
>  	unsigned int len = 0;
> -	if ( headerSize == 0 ) {
> +	if (headerSize == 0 ) {

Remove the other space as well.  I looked ahead in the series so I see
that you do it later, but it should be done here.

regards,
dan carpenter
