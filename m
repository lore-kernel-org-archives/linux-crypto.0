From: Frans Klaver <fransklaver@gmail.com>
Subject: Re: [PATCH 14/14] staging: ccree: fix block comment style
Date: Thu, 29 Jun 2017 16:38:14 +0200
Message-ID: <CAH6sp9PD6FbZXQWdhig37PRQaTKzPk8a-3_X+nh_nvE0AMFubQ@mail.gmail.com>
References: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
 <1498548449-10803-15-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: driverdevel <devel@driverdev.osuosl.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1498548449-10803-15-git-send-email-gilad@benyossef.com>
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

On Tue, Jun 27, 2017 at 9:27 AM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Align block comments according to coding style.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/staging/ccree/cc_hw_queue_defs.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
> index f11487a..e6b8cea 100644
> --- a/drivers/staging/ccree/cc_hw_queue_defs.h
> +++ b/drivers/staging/ccree/cc_hw_queue_defs.h
> @@ -23,8 +23,8 @@
>  #include <linux/bitfield.h>
>
>  /******************************************************************************
> -*                              DEFINITIONS
> -******************************************************************************/
> + *                             DEFINITIONS
> + ******************************************************************************/

I think if you change to the preferred block comment format, you
should also drop these lines full of asterisks. I'm not sure why a
multi-line comment is warranted here, anyway.

Frans
